"""Audio I/O — m4a decode, resample to 16kHz mono."""
from __future__ import annotations

import subprocess
from pathlib import Path

import numpy as np
import soundfile as sf

TARGET_SR = 16000


def decode_to_wav(input_path: Path, output_path: Path, target_sr: int = TARGET_SR) -> Path:
    """Decode m4a/mp3/wav → 16kHz mono float32 WAV using ffmpeg.

    ffmpeg must be on PATH. Raises subprocess.CalledProcessError on failure.
    """
    output_path.parent.mkdir(parents=True, exist_ok=True)
    cmd = [
        "ffmpeg",
        "-y",
        "-loglevel", "error",
        "-i", str(input_path),
        "-ac", "1",
        "-ar", str(target_sr),
        "-acodec", "pcm_s16le",
        str(output_path),
    ]
    subprocess.run(cmd, check=True)
    return output_path


def load_wav(path: Path, expected_sr: int = TARGET_SR) -> np.ndarray:
    """Load mono WAV as float32 in [-1, 1]. Validates sample rate."""
    audio, sr = sf.read(str(path), dtype="float32", always_2d=False)
    if sr != expected_sr:
        raise ValueError(f"{path}: expected {expected_sr} Hz, got {sr}")
    if audio.ndim > 1:
        audio = audio.mean(axis=1).astype(np.float32)
    return audio


# AGC target: -20 dBFS RMS, αλλιώς the off-the-shelf VAD/CNN δεν παίρνουν αρκετό σήμα.
# Τα recordings μας έρχονται γύρω -50 dBFS (RMS 0.0019), άρα +30 dB gain χρειάζεται.
AGC_TARGET_DBFS = -20.0
AGC_PEAK_HEADROOM_DBFS = -1.0  # μην clip-άρει
AGC_MAX_GAIN_DB = 40.0  # cap για να μην ανεβάσουμε άπειρο noise


def apply_agc(audio: np.ndarray) -> tuple[np.ndarray, float]:
    """Auto-amplify σε target RMS, χωρίς να clip-άρει.

    Returns (amplified_audio, applied_gain_db). Idempotent — αν το audio
    είναι ήδη πάνω από target RMS, gain=0 και επιστρέφει unchanged.
    """
    if audio.size == 0:
        return audio, 0.0
    rms = float(np.sqrt(np.mean(audio.astype(np.float64) ** 2)))
    peak = float(np.max(np.abs(audio)))
    if rms < 1e-8 or peak < 1e-8:
        return audio, 0.0

    target_rms = 10 ** (AGC_TARGET_DBFS / 20.0)
    rms_gain = target_rms / rms
    peak_limit = 10 ** (AGC_PEAK_HEADROOM_DBFS / 20.0)
    peak_gain = peak_limit / peak
    gain = min(rms_gain, peak_gain, 10 ** (AGC_MAX_GAIN_DB / 20.0))
    gain = max(gain, 1.0)
    return (audio * gain).astype(np.float32), 20.0 * np.log10(gain)


def ensure_wav(raw_path: Path, wav_dir: Path) -> Path:
    """Decode raw audio to wav_dir/<stem>.wav, skip if cached."""
    wav_path = wav_dir / f"{raw_path.stem}.wav"
    if wav_path.exists() and wav_path.stat().st_mtime >= raw_path.stat().st_mtime:
        return wav_path
    return decode_to_wav(raw_path, wav_path)
