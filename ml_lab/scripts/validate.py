"""Run pipeline on labeled recordings, report F1.

Acceptance criterion (από stochasm): F1 > 0.7 σε όλα τα labeled recordings.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from src.metrics import aggregate_f1, match_events  # noqa: E402
from src.pipeline import Pipeline  # noqa: E402

PASS_THRESHOLD_F1 = 0.7


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--raw-dir", type=Path, default=ROOT / "data" / "raw",
                   help="Directory με τα m4a/wav recordings")
    p.add_argument("--wav-dir", type=Path, default=ROOT / "data" / "wav",
                   help="Cache directory για decoded 16kHz WAVs")
    p.add_argument("--labels", type=Path, default=ROOT / "data" / "labels.json")
    p.add_argument("--snore-model", type=Path, default=ROOT / "models" / "snore_cnn.tflite")
    p.add_argument("--vad-model", type=Path, default=ROOT / "models" / "silero_vad.onnx")
    p.add_argument("--out", type=Path, default=ROOT / "data" / "validation_report.json")
    p.add_argument("--iou", type=float, default=0.3, help="(unused, kept for compat)")
    p.add_argument("--hop", type=float, default=0.2, help="Snore CNN sliding hop seconds")
    return p.parse_args()


def fmt_metrics(label: str, m) -> str:
    tn = getattr(m, "tn", 0)
    return (f"  {label:>6}  P={m.precision:5.2f}  R={m.recall:5.2f}  F1={m.f1:5.2f}"
            f"  (TP={m.tp} FP={m.fp} FN={m.fn} TN={tn})")


def main() -> int:
    args = parse_args()

    if not args.snore_model.exists():
        print(f"ERROR: missing {args.snore_model} — run scripts/setup.py first")
        return 1
    if not args.vad_model.exists():
        print(f"ERROR: missing {args.vad_model} — run scripts/setup.py first")
        return 1
    if not args.labels.exists():
        print(f"ERROR: missing {args.labels}")
        return 1

    labels = json.loads(args.labels.read_text(encoding="utf-8"))
    pipeline = Pipeline(snore_model=args.snore_model, vad_model=args.vad_model)
    args.wav_dir.mkdir(parents=True, exist_ok=True)

    per_recording = []
    report = {"per_recording": [], "passes": True, "iou_threshold": args.iou,
              "pass_f1_threshold": PASS_THRESHOLD_F1}

    for filename, meta in labels["recordings"].items():
        raw = args.raw_dir / filename
        if not raw.exists():
            print(f"  [skip] {filename} — not in {args.raw_dir}")
            continue
        print(f"\n[{meta.get('alias', filename)}] {filename}")
        result = pipeline.run(raw, args.wav_dir, snore_hop_s=args.hop)
        metrics = match_events(result.events, meta["events"], duration_s=result.duration_s)
        per_recording.append(metrics)

        for label, cm in sorted(metrics.items()):
            print(fmt_metrics(label, cm))
            if cm.f1 < PASS_THRESHOLD_F1:
                report["passes"] = False

        report["per_recording"].append({
            "file": filename,
            "alias": meta.get("alias"),
            "duration_s": result.duration_s,
            "predicted_events": result.events,
            "ground_truth_events": meta["events"],
            "metrics": {label: {
                "precision": cm.precision,
                "recall": cm.recall,
                "f1": cm.f1,
                "tp": cm.tp,
                "fp": cm.fp,
                "fn": cm.fn,
                "tn": getattr(cm, "tn", 0),
            } for label, cm in metrics.items()},
        })

    print("\n=== AGGREGATE ===")
    aggregate = aggregate_f1(per_recording)
    for label, cm in sorted(aggregate.items()):
        print(fmt_metrics(label, cm))
        if cm.f1 < PASS_THRESHOLD_F1:
            report["passes"] = False
    report["aggregate"] = {label: {
        "precision": cm.precision, "recall": cm.recall, "f1": cm.f1,
        "tp": cm.tp, "fp": cm.fp, "fn": cm.fn, "tn": getattr(cm, "tn", 0),
    } for label, cm in aggregate.items()}

    args.out.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"\nReport → {args.out}")

    if report["passes"]:
        print(f"\n✓ PASS  (όλα τα F1 >= {PASS_THRESHOLD_F1}). Run: python scripts/export.py")
        return 0
    print(f"\n✗ FAIL  (F1 < {PASS_THRESHOLD_F1}). Διάβασε το report, σκέψου retrain.")
    return 2


if __name__ == "__main__":
    sys.exit(main())
