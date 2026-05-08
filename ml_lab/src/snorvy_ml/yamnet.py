from collections.abc import Sequence
import csv
from pathlib import Path
from typing import Any

import numpy as np

from snorvy_ml.config import sample_rate_hz, yamnet_tfhub_url


def load_audio_mono_16k(path: Path) -> np.ndarray:
    import librosa

    waveform, _ = librosa.load(path, sr=sample_rate_hz, mono=True)
    return waveform.astype(np.float32)


def load_yamnet_model() -> Any:
    import tensorflow_hub as hub

    return hub.load(yamnet_tfhub_url)


def read_yamnet_class_names(model: Any) -> list[str]:
    class_map_path = model.class_map_path().numpy().decode("utf-8")
    return class_names_from_csv(Path(class_map_path))


def class_names_from_csv(path: Path) -> list[str]:
    with path.open(newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        return [row["display_name"] for row in reader]


def run_yamnet(
    model: Any,
    waveform: np.ndarray,
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    scores, embeddings, spectrogram = model(waveform)
    return (
        scores.numpy(),
        embeddings.numpy(),
        spectrogram.numpy(),
    )


def save_embeddings(
    path: Path,
    embeddings: np.ndarray,
    class_names: Sequence[str],
) -> None:
    np.savez_compressed(
        path,
        embeddings=embeddings,
        class_names=np.asarray(list(class_names)),
    )
