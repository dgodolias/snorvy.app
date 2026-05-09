"""SnoreCNN inference — sliding window over an audio file."""
from __future__ import annotations

from pathlib import Path

import numpy as np
from ai_edge_litert.interpreter import Interpreter

from . import mfcc

SR = mfcc.SAMPLE_RATE
WINDOW_SAMPLES = mfcc.EXPECTED_AUDIO_SAMPLES  # 15840 (~990ms)
DEFAULT_HOP_SECONDS = 0.2

# adrianagaler model class indices (από summary.md):
# train labels: snoring + off + silence + unknown
# Convention TFLite-Micro speech_commands: silence=0, unknown=1, target_words[0]=2, target_words[1]=3
# Targets are alphabetical: "off", "snoring" → off=2, snoring=3
CLASS_INDEX = {"silence": 0, "unknown": 1, "off": 2, "snoring": 3}


class SnoreClassifier:
    """Wraps adrianagaler tiny_conv TFLite model.

    Input: (1, 1960) int8 (49×40 log-mel features quantized).
    Output: (1, 4) int8 softmax → [silence, unknown, off, snoring].
    """

    def __init__(self, model_path: Path):
        self.interpreter = Interpreter(model_path=str(model_path))
        self.interpreter.allocate_tensors()
        self.input_details = self.interpreter.get_input_details()[0]
        self.output_details = self.interpreter.get_output_details()[0]
        self._in_scale, self._in_zero = self.input_details["quantization"]
        self._out_scale, self._out_zero = self.output_details["quantization"]

    def predict_window(self, audio: np.ndarray) -> dict:
        feats = mfcc.compute_features(audio)
        q = mfcc.quantize_for_model(feats, self._in_scale, self._in_zero)
        q = q.reshape(self.input_details["shape"])

        self.interpreter.set_tensor(self.input_details["index"], q)
        self.interpreter.invoke()
        out_q = self.interpreter.get_tensor(self.output_details["index"])

        out = (out_q.astype(np.float32) - self._out_zero) * self._out_scale
        probs = out.flatten()
        # Re-normalize μετά τη dequantization
        probs = np.clip(probs, 0, None)
        s = probs.sum()
        if s > 0:
            probs = probs / s
        return {name: float(probs[idx]) for name, idx in CLASS_INDEX.items()}

    def sliding_window(
        self, audio: np.ndarray, hop_seconds: float = DEFAULT_HOP_SECONDS
    ) -> tuple[np.ndarray, np.ndarray]:
        hop_samples = int(hop_seconds * SR)
        last_start = max(1, audio.size - WINDOW_SAMPLES + 1)
        starts = list(range(0, last_start, hop_samples))
        if not starts:
            starts = [0]

        timestamps = np.array([(s + WINDOW_SAMPLES / 2) / SR for s in starts])
        probs = np.zeros(len(starts), dtype=np.float32)
        for i, start in enumerate(starts):
            chunk = audio[start : start + WINDOW_SAMPLES]
            probs[i] = self.predict_window(chunk)["snoring"]
        return timestamps, probs
