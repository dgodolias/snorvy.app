"""Audio feature extraction για το adrianagaler tiny_conv micro model.

Καλεί τον επίσημο TFLite-Micro `audio_microfrontend` op (μέσω TensorFlow):
49 frames × 40 mel channels με PCAN noise normalization, scaled για int8 model input.

Defaults ταυτισμένα με μετά-training params του adrianagaler:
- sample_rate=16000, window_size=30ms, window_step=20ms
- num_channels=40, lower=125Hz, upper=7500Hz
- enable_pcan=True (default PCAN params), enable_log=True

Ref: https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/experimental/microfrontend/python/ops/audio_microfrontend_op.py
"""
from __future__ import annotations

import numpy as np
import tensorflow as tf
from tensorflow.lite.experimental.microfrontend.python.ops import audio_microfrontend_op as _afe

SAMPLE_RATE = 16000
WINDOW_SIZE_MS = 30
WINDOW_STEP_MS = 20
NUM_CHANNELS = 40
LOWER_BAND_LIMIT_HZ = 125.0
UPPER_BAND_LIMIT_HZ = 7500.0
NUM_FRAMES = 49
FEATURE_SIZE = NUM_FRAMES * NUM_CHANNELS  # 1960

WINDOW_SAMPLES = int(SAMPLE_RATE * WINDOW_SIZE_MS / 1000)  # 480
HOP_SAMPLES = int(SAMPLE_RATE * WINDOW_STEP_MS / 1000)     # 320
EXPECTED_AUDIO_SAMPLES = HOP_SAMPLES * (NUM_FRAMES - 1) + WINDOW_SAMPLES  # 15840


def compute_features(audio: np.ndarray, sr: int = SAMPLE_RATE) -> np.ndarray:
    """Compute (49, 40) features για 1-sec audio chunk με audio_microfrontend.

    audio: float32 [-1, 1]. Auto-converts σε int16 για το op.
    """
    if audio.ndim != 1:
        raise ValueError(f"expected 1-D audio, got shape {audio.shape}")
    if sr != SAMPLE_RATE:
        raise ValueError(f"expected {SAMPLE_RATE} Hz, got {sr}")

    if audio.size < EXPECTED_AUDIO_SAMPLES:
        audio = np.pad(audio, (0, EXPECTED_AUDIO_SAMPLES - audio.size))
    elif audio.size > EXPECTED_AUDIO_SAMPLES:
        audio = audio[:EXPECTED_AUDIO_SAMPLES]

    audio_int16 = np.clip(audio * 32768.0, -32768, 32767).astype(np.int16)
    audio_tf = tf.constant(audio_int16)

    features = _afe.audio_microfrontend(
        audio_tf,
        sample_rate=SAMPLE_RATE,
        window_size=WINDOW_SIZE_MS,
        window_step=WINDOW_STEP_MS,
        num_channels=NUM_CHANNELS,
        upper_band_limit=UPPER_BAND_LIMIT_HZ,
        lower_band_limit=LOWER_BAND_LIMIT_HZ,
        enable_pcan=True,
        enable_log=True,
        out_scale=1,
        out_type=tf.float32,
    )
    arr = features.numpy()  # shape (NUM_FRAMES, NUM_CHANNELS)

    # Pad/trim σε ακριβώς 49 frames
    if arr.shape[0] < NUM_FRAMES:
        arr = np.pad(arr, ((0, NUM_FRAMES - arr.shape[0]), (0, 0)))
    elif arr.shape[0] > NUM_FRAMES:
        arr = arr[:NUM_FRAMES]
    return arr.astype(np.float32)


def quantize_for_model(features: np.ndarray, scale: float, zero_point: int) -> np.ndarray:
    flat = features.flatten()
    q = np.round(flat / scale + zero_point)
    return np.clip(q, -128, 127).astype(np.int8)


def get_config() -> dict:
    return {
        "sample_rate": SAMPLE_RATE,
        "window_size_ms": WINDOW_SIZE_MS,
        "window_step_ms": WINDOW_STEP_MS,
        "num_channels": NUM_CHANNELS,
        "lower_band_limit_hz": LOWER_BAND_LIMIT_HZ,
        "upper_band_limit_hz": UPPER_BAND_LIMIT_HZ,
        "num_frames": NUM_FRAMES,
        "feature_size": FEATURE_SIZE,
        "expected_audio_samples": EXPECTED_AUDIO_SAMPLES,
        "preprocessing": "tflite_micro_audio_microfrontend",
        "enable_pcan": True,
        "enable_log": True,
    }
