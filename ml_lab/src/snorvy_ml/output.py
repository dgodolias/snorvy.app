from collections.abc import Sequence
import csv
from pathlib import Path

from snorvy_ml.models import EventSegment, WindowPrediction


def write_window_predictions_csv(
    path: Path,
    predictions: Sequence[WindowPrediction],
) -> None:
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(
            file,
            fieldnames=[
                "start_seconds",
                "end_seconds",
                "label",
                "confidence",
                "snore_score",
                "talk_score",
            ],
        )
        writer.writeheader()
        for prediction in predictions:
            writer.writerow(
                {
                    "start_seconds": f"{prediction.window.start_seconds:.3f}",
                    "end_seconds": f"{prediction.window.end_seconds:.3f}",
                    "label": prediction.label.value,
                    "confidence": f"{prediction.confidence:.6f}",
                    "snore_score": f"{prediction.snore_score:.6f}",
                    "talk_score": f"{prediction.talk_score:.6f}",
                }
            )


def write_segments_csv(path: Path, segments: Sequence[EventSegment]) -> None:
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(
            file,
            fieldnames=[
                "start_seconds",
                "end_seconds",
                "duration_seconds",
                "label",
                "confidence",
                "window_count",
            ],
        )
        writer.writeheader()
        for segment in segments:
            writer.writerow(
                {
                    "start_seconds": f"{segment.start_seconds:.3f}",
                    "end_seconds": f"{segment.end_seconds:.3f}",
                    "duration_seconds": f"{segment.duration_seconds:.3f}",
                    "label": segment.label.value,
                    "confidence": f"{segment.confidence:.6f}",
                    "window_count": str(segment.window_count),
                }
            )
