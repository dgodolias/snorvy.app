from dataclasses import dataclass
from pathlib import Path

import numpy as np

from snorvy_ml.labels import group_spans_by_file, label_for_window, read_label_spans
from snorvy_ml.models import Label, TimeWindow
from snorvy_ml.segmenter import build_time_windows
from snorvy_ml.yamnet import load_audio_mono_16k, run_yamnet


@dataclass(frozen=True)
class WindowExample:
    file: str
    window: TimeWindow
    label: Label
    embedding: np.ndarray


def build_labeled_examples(
    raw_dir: Path,
    labels_path: Path,
    yamnet_model: object,
) -> list[WindowExample]:
    spans_by_file = group_spans_by_file(read_label_spans(labels_path))
    examples: list[WindowExample] = []

    for file_name, spans in spans_by_file.items():
        audio_path = raw_dir / file_name
        waveform = load_audio_mono_16k(audio_path)
        _, embeddings, _ = run_yamnet(yamnet_model, waveform)
        windows = build_time_windows(count=len(embeddings))
        examples.extend(
            WindowExample(
                file=file_name,
                window=window,
                label=label,
                embedding=embeddings[index],
            )
            for index, window in enumerate(windows)
            if (label := label_for_window(window, spans)) is not None
        )

    return examples


def feature_matrix(examples: list[WindowExample]) -> np.ndarray:
    return np.vstack([example.embedding for example in examples])


def target_labels(examples: list[WindowExample]) -> np.ndarray:
    return np.asarray([example.label.value for example in examples])
