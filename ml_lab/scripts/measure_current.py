"""Port του υπάρχοντος dB-based detection (lib/src/services/sleep_event_analyzer.dart)
σε Python και measurement στα ίδια rec2-rec5 labeled recordings.

Σκοπός: σύγκριση F1 του current rule-based classifier vs ML pipeline (Silero+SnoreCNN).
"""
from __future__ import annotations

import argparse
import json
import math
import sys
from dataclasses import dataclass
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from src.audio import ensure_wav, load_wav  # noqa: E402
from src.metrics import aggregate, frame_metrics  # noqa: E402

# Από sleep_recorder.dart: setSubscriptionDuration(160ms)
FRAME_STEP_MS = 160
TARGET_SR = 16000

# Από sleep_event_analyzer.dart constants
MIN_FRAMES = 3
MIN_EVENT_DURATION_MS = 400
MIN_DYNAMIC_RANGE = 5.0
MERGE_GAP_MS = 700


@dataclass
class Frame:
    elapsed_ms: int
    decibels: float


@dataclass
class Cluster:
    frames: list[Frame]

    @property
    def first(self) -> Frame:
        return self.frames[0]

    @property
    def last(self) -> Frame:
        return self.frames[-1]

    @property
    def duration_ms(self) -> int:
        return (self.last.elapsed_ms - self.first.elapsed_ms) + FRAME_STEP_MS

    @property
    def peak_db(self) -> float:
        return max(f.decibels for f in self.frames)

    @property
    def avg_db(self) -> float:
        return sum(f.decibels for f in self.frames) / len(self.frames)

    @property
    def db_spread(self) -> float:
        avg = self.avg_db
        var = sum((f.decibels - avg) ** 2 for f in self.frames) / len(self.frames)
        return math.sqrt(var)


def compute_db_frames(audio: np.ndarray, sr: int = TARGET_SR) -> list[Frame]:
    """Simulate flutter_sound disposition.decibels: per-160ms window 20*log10(rms).

    flutter_sound στο Android χρησιμοποιεί MediaRecorder.getMaxAmplitude.
    Approximation: per-window peak * 32768, dB = 20*log10(peak/32768) σε dBFS,
    αλλά flutter_sound επιστρέφει positive values κανονικά (offset ~120 dB ref).
    Για τη heuristic δεν παίζει ρόλο το absolute scale — μόνο τα relative differences,
    άρα χρησιμοποιούμε 20*log10(rms) + 120 ώστε να είναι θετικά.
    """
    hop = int(sr * FRAME_STEP_MS / 1000)
    frames: list[Frame] = []
    for i, start in enumerate(range(0, audio.size - hop + 1, hop)):
        chunk = audio[start : start + hop]
        rms = float(np.sqrt(np.mean(chunk.astype(np.float64) ** 2)))
        db = 20 * math.log10(max(rms, 1e-7)) + 120  # offset → positive range
        frames.append(Frame(elapsed_ms=i * FRAME_STEP_MS, decibels=db))
    return frames


def percentile(sorted_values: list[float], pct: float) -> float:
    idx = round((len(sorted_values) - 1) * pct)
    return sorted_values[max(0, min(len(sorted_values) - 1, idx))]


def find_loud_clusters(frames: list[Frame], threshold: float) -> list[Cluster]:
    """Direct port of LocalLevelSleepEventAnalyzer._findLoudClusters."""
    if not frames:
        return []
    gaps = []
    for i in range(1, len(frames)):
        g = frames[i].elapsed_ms - frames[i - 1].elapsed_ms
        if 0 < g <= 2000:
            gaps.append(g)
    frame_step = sorted(gaps)[len(gaps) // 2] if gaps else 160
    merge_gap_ms = max(MERGE_GAP_MS, frame_step * 2)

    clusters: list[Cluster] = []
    current: Cluster | None = None
    last_loud: Frame | None = None
    for f in frames:
        if f.decibels < threshold:
            continue
        if current is None:
            current = Cluster(frames=[f])
        else:
            gap = f.elapsed_ms - (last_loud.elapsed_ms if last_loud else f.elapsed_ms)
            if gap <= merge_gap_ms:
                current.frames.append(f)
            else:
                clusters.append(current)
                current = Cluster(frames=[f])
        last_loud = f
    if current is not None:
        clusters.append(current)
    return clusters


def relu(x: float) -> float:
    return max(0.0, x)


def normalize(features: dict) -> dict:
    return {
        "duration": min(1.0, max(0.0, features["duration_s"] / 12.0)),
        "frame_count": min(1.0, max(0.0, features["frame_count"] / 12.0)),
        "peak_lift": min(1.0, max(0.0, features["peak_lift"] / 24.0)),
        "average_lift": min(1.0, max(0.0, features["average_lift"] / 16.0)),
        "variability": min(1.0, max(0.0, features["variability"] / 12.0)),
    }


def classify(features: dict) -> str:
    """Direct port of TinyLevelNeuralSleepClassifier.classify."""
    peak_lift = features["peak_lift"]
    avg_lift = features["average_lift"]
    variability = features["variability"]
    duration_ms = features["duration_ms"]
    frame_count = features["frame_count"]

    if peak_lift < 5 and avg_lift < 3:
        return "noise"
    if duration_ms <= 1400 and frame_count >= 3 and peak_lift >= 12 and avg_lift >= 6:
        return "snore"
    if duration_ms <= 3200 and frame_count >= 3 and avg_lift >= 9 and variability <= 2.6:
        return "snore"
    if duration_ms >= 5000 and avg_lift >= 6 and variability <= 2.8:
        return "snore"
    if duration_ms <= 16000 and variability >= 3.2 and peak_lift >= 7:
        return "talk"
    if 3200 < duration_ms < 5000 and peak_lift >= 7:
        return "talk"
    if duration_ms <= 2000:
        return "talk"

    inp = normalize(features)
    sustained = relu(-0.8 + inp["duration"] * 2.0 + inp["average_lift"] * 0.5 + inp["frame_count"] * 0.8)
    impulse = relu(-0.2 + inp["peak_lift"] * 1.4 - inp["duration"] * 0.8)
    irregularity = relu(0.1 + inp["variability"] * 1.1 - inp["average_lift"] * 0.2)
    loudness = relu(0.2 + inp["average_lift"] + inp["peak_lift"] * 0.6)

    snore_logit = -1.1 + sustained * 1.4 + loudness * 0.4 - impulse * 0.3
    talk_logit = -0.4 + impulse * 1.6 + loudness * 0.3 - sustained * 0.7
    noise_logit = -0.1 + irregularity - sustained * 0.5 - impulse * 0.2

    logits = [snore_logit, talk_logit, noise_logit]
    winner = max(range(3), key=lambda i: logits[i])
    return ["snore", "talk", "noise"][winner]


def analyze_recording(audio: np.ndarray) -> list[dict]:
    """Returns predicted events [{start, end, label, confidence}]."""
    frames = compute_db_frames(audio)
    if len(frames) < MIN_FRAMES:
        return []

    values = sorted(f.decibels for f in frames)
    floor = percentile(values, 0.20)
    high = percentile(values, 0.92)
    peak = values[-1]
    dynamic_range = high - floor
    if dynamic_range < MIN_DYNAMIC_RANGE and peak < floor + 7:
        return []

    threshold = floor + max(3.5, min(10.0, dynamic_range * 0.30))
    clusters = find_loud_clusters(frames, threshold)

    events: list[dict] = []
    for cl in clusters:
        if cl.duration_ms < MIN_EVENT_DURATION_MS:
            continue
        feats = {
            "duration_ms": cl.duration_ms,
            "duration_s": cl.duration_ms / 1000.0,
            "frame_count": len(cl.frames),
            "peak_lift": cl.peak_db - threshold,
            "average_lift": cl.avg_db - threshold,
            "variability": cl.db_spread,
        }
        kind = classify(feats)
        if kind == "noise":
            continue
        events.append({
            "start": cl.first.elapsed_ms / 1000.0,
            "end": (cl.last.elapsed_ms + FRAME_STEP_MS) / 1000.0,
            "label": kind,
            "confidence": min(1.0, cl.peak_db - threshold) / 12.0 + 0.5,
        })
    return events


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--raw-dir", type=Path, default=ROOT / "data" / "raw")
    p.add_argument("--wav-dir", type=Path, default=ROOT / "data" / "wav")
    p.add_argument("--labels", type=Path, default=ROOT / "data" / "labels.json")
    p.add_argument("--out", type=Path, default=ROOT / "data" / "current_detection_report.json")
    args = p.parse_args()

    labels = json.loads(args.labels.read_text(encoding="utf-8"))
    args.wav_dir.mkdir(parents=True, exist_ok=True)
    per_recording = []
    report = {"per_recording": [], "metric": "frame_based_per_200ms_tick"}

    for filename, meta in labels["recordings"].items():
        raw = args.raw_dir / filename
        if not raw.exists():
            continue
        wav = ensure_wav(raw, args.wav_dir)
        sig = load_wav(wav)
        duration_s = sig.size / TARGET_SR

        events = analyze_recording(sig)
        metrics = frame_metrics(events, meta["events"], duration_s=duration_s)
        per_recording.append(metrics)

        print(f"\n[{meta.get('alias', filename)}] {filename} ({duration_s:.0f}s, {len(events)} events)")
        for label, cm in sorted(metrics.items()):
            print(f"  {label:>6}  P={cm.precision:5.2f}  R={cm.recall:5.2f}  F1={cm.f1:5.2f}"
                  f"  (TP={cm.tp} FP={cm.fp} FN={cm.fn})")

        report["per_recording"].append({
            "file": filename,
            "alias": meta.get("alias"),
            "duration_s": duration_s,
            "predicted_events": events,
            "ground_truth_events": meta["events"],
            "metrics": {label: {
                "precision": cm.precision, "recall": cm.recall, "f1": cm.f1,
                "tp": cm.tp, "fp": cm.fp, "fn": cm.fn, "tn": getattr(cm, "tn", 0),
            } for label, cm in metrics.items()},
        })

    print("\n=== AGGREGATE ===")
    agg = aggregate(per_recording)
    for label, cm in sorted(agg.items()):
        print(f"  {label:>6}  P={cm.precision:5.2f}  R={cm.recall:5.2f}  F1={cm.f1:5.2f}"
              f"  (TP={cm.tp} FP={cm.fp} FN={cm.fn})")
    report["aggregate"] = {label: {
        "precision": cm.precision, "recall": cm.recall, "f1": cm.f1,
        "tp": cm.tp, "fp": cm.fp, "fn": cm.fn,
    } for label, cm in agg.items()}

    args.out.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"\nReport → {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
