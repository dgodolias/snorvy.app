"""End-to-end pipeline για ένα audio file."""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

import numpy as np

from . import audio as audio_io
from . import decision, snore, vad


@dataclass
class PipelineResult:
    file: str
    duration_s: float
    events: list[dict]
    snore_timeline: tuple[np.ndarray, np.ndarray]
    voice_timeline: tuple[np.ndarray, np.ndarray]

    def filter_label(self, label: str) -> list[dict]:
        return [e for e in self.events if e["label"] == label]


class Pipeline:
    def __init__(self, snore_model: Path, vad_model: Path):
        self.snore = snore.SnoreClassifier(snore_model)
        self.vad = vad.SileroVAD(vad_model)

    def run(
        self,
        audio_path: Path,
        wav_dir: Path,
        snore_hop_s: float = snore.DEFAULT_HOP_SECONDS,
        apply_agc: bool = True,
    ) -> PipelineResult:
        wav_path = audio_io.ensure_wav(audio_path, wav_dir)
        signal = audio_io.load_wav(wav_path)
        if apply_agc:
            signal, gain_db = audio_io.apply_agc(signal)
            print(f"  AGC gain: +{gain_db:.1f} dB")
        duration_s = signal.size / audio_io.TARGET_SR

        snore_ts, snore_probs = self.snore.sliding_window(signal, hop_seconds=snore_hop_s)
        voice_ts, voice_probs = self.vad.voice_timeline(signal)

        events = decision.combine_streams(
            snore_timestamps=snore_ts,
            snore_probs=snore_probs,
            voice_timestamps=voice_ts,
            voice_probs=voice_probs,
            duration_s=duration_s,
        )
        return PipelineResult(
            file=audio_path.name,
            duration_s=duration_s,
            events=[e.to_dict() for e in events],
            snore_timeline=(snore_ts, snore_probs),
            voice_timeline=(voice_ts, voice_probs),
        )
