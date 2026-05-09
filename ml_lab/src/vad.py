"""Silero-VAD inference μέσω official PyPI silero-vad package (PyTorch JIT).

Το direct ONNX path που είχαμε σε προηγούμενη version έδειχνε νεκρά voice_probs
ενώ το επίσημο PyPI package τα πιάνει σωστά — πιθανώς λάθος state management
ή outdated ONNX file. Switch σε official για guarantee match με upstream.

Για Flutter export: το PyPI package εκθέτει ONNX model στο
`silero_vad/data/silero_vad.onnx` που μπορούμε να χρησιμοποιήσουμε αργότερα.
"""
from __future__ import annotations

from pathlib import Path

import numpy as np
import torch
from silero_vad import get_speech_timestamps, load_silero_vad

SAMPLE_RATE = 16000
DEFAULT_THRESHOLD = 0.3  # quiet recordings need looser threshold
DEFAULT_MIN_SPEECH_MS = 200
DEFAULT_MIN_SILENCE_MS = 100
DEFAULT_SPEECH_PAD_MS = 200  # generous pad — Silero detects only middle of utterance


class SileroVAD:
    """Wraps official silero-vad PyTorch JIT model."""

    def __init__(self, model_path: Path | None = None):
        # model_path kept για backward compat με caller· το PyPI package κατεβάζει το model μόνο του
        self.model = load_silero_vad()

    def voice_timeline(self, audio: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
        """Frame-level voice probabilities — προσέγγιση από segment list μέσω 200ms ticks.

        Επιστρέφει (timestamps, voice_probs) όπου voice_prob είναι 1.0 inside detected
        speech segments, 0.0 αλλιώς. Για το decision matrix η ακρίβεια αυτής της
        binary representation αρκεί.
        """
        segs = self.voice_segments(audio)
        duration_s = audio.size / SAMPLE_RATE
        n_ticks = max(1, int(duration_s / 0.2))
        timestamps = np.arange(n_ticks) * 0.2 + 0.1
        probs = np.zeros(n_ticks, dtype=np.float32)
        for s in segs:
            i0 = max(0, int(s["start"] / 0.2))
            i1 = min(n_ticks, int(np.ceil(s["end"] / 0.2)))
            probs[i0:i1] = 1.0
        return timestamps, probs

    def voice_segments(
        self,
        audio: np.ndarray,
        threshold: float = DEFAULT_THRESHOLD,
        min_speech_ms: int = DEFAULT_MIN_SPEECH_MS,
        min_silence_ms: int = DEFAULT_MIN_SILENCE_MS,
        speech_pad_ms: int = DEFAULT_SPEECH_PAD_MS,
    ) -> list[dict]:
        """Returns [{start, end}] σε seconds μέσω official `get_speech_timestamps`."""
        if audio.dtype != np.float32:
            audio = audio.astype(np.float32)
        tensor = torch.from_numpy(audio)
        ts = get_speech_timestamps(
            tensor,
            self.model,
            sampling_rate=SAMPLE_RATE,
            threshold=threshold,
            min_speech_duration_ms=min_speech_ms,
            min_silence_duration_ms=min_silence_ms,
            speech_pad_ms=speech_pad_ms,
            return_seconds=True,
        )
        return [{"start": float(t["start"]), "end": float(t["end"])} for t in ts]


def get_config() -> dict:
    return {
        "sample_rate": SAMPLE_RATE,
        "threshold": DEFAULT_THRESHOLD,
        "min_speech_ms": DEFAULT_MIN_SPEECH_MS,
        "min_silence_ms": DEFAULT_MIN_SILENCE_MS,
        "speech_pad_ms": DEFAULT_SPEECH_PAD_MS,
    }
