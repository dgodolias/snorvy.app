from collections import defaultdict
from collections.abc import Sequence
import csv
from pathlib import Path

from snorvy_ml.models import Label, LabelSpan, TimeWindow


def read_label_spans(path: Path) -> list[LabelSpan]:
    with path.open(newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        return [
            LabelSpan(
                file=row["file"],
                start_seconds=float(row["start_seconds"]),
                end_seconds=float(row["end_seconds"]),
                label=Label(row["label"]),
                notes=row.get("notes", ""),
            )
            for row in reader
        ]


def group_spans_by_file(spans: Sequence[LabelSpan]) -> dict[str, list[LabelSpan]]:
    grouped: dict[str, list[LabelSpan]] = defaultdict(list)
    for span in spans:
        grouped[span.file].append(span)
    return {
        file_name: sorted(items, key=lambda item: item.start_seconds)
        for file_name, items in grouped.items()
    }


def overlap_seconds(window: TimeWindow, span: LabelSpan) -> float:
    start = max(window.start_seconds, span.start_seconds)
    end = min(window.end_seconds, span.end_seconds)
    return max(0.0, end - start)


def label_for_window(
    window: TimeWindow,
    spans: Sequence[LabelSpan],
    min_overlap_ratio: float = 0.50,
) -> Label | None:
    overlaps = [
        (overlap_seconds(window, span), span.label)
        for span in spans
    ]
    best_overlap, best_label = max(overlaps, default=(0.0, Label.other))
    if best_overlap <= 0.0:
        return Label.other
    if best_overlap / window.duration_seconds <= min_overlap_ratio:
        return None
    return best_label
