from collections.abc import Iterable, Sequence

from snorvy_ml.config import SegmentSettings, yamnet_hop_seconds, yamnet_window_seconds
from snorvy_ml.models import EventSegment, Label, TimeWindow, WindowPrediction


def build_time_windows(
    count: int,
    window_seconds: float = yamnet_window_seconds,
    hop_seconds: float = yamnet_hop_seconds,
) -> list[TimeWindow]:
    return [
        TimeWindow(
            start_seconds=index * hop_seconds,
            end_seconds=index * hop_seconds + window_seconds,
        )
        for index in range(count)
    ]


def smooth_predictions(
    predictions: Sequence[WindowPrediction],
) -> list[WindowPrediction]:
    if len(predictions) < 3:
        return list(predictions)

    smoothed = list(predictions)
    for index in range(1, len(predictions) - 1):
        previous = predictions[index - 1]
        current = predictions[index]
        next_item = predictions[index + 1]
        if previous.label == next_item.label and current.label != previous.label:
            smoothed[index] = WindowPrediction(
                window=current.window,
                label=previous.label,
                confidence=(previous.confidence + next_item.confidence) / 2,
                snore_score=current.snore_score,
                talk_score=current.talk_score,
                scores=current.scores,
            )

    return smoothed


def merge_predictions(
    predictions: Sequence[WindowPrediction],
    settings: SegmentSettings = SegmentSettings(),
) -> list[EventSegment]:
    merged = merge_runs(predictions, settings)
    return [
        segment
        for segment in merged
        if keep_segment(segment, settings)
    ]


def merge_runs(
    predictions: Sequence[WindowPrediction],
    settings: SegmentSettings,
) -> list[EventSegment]:
    segments: list[EventSegment] = []
    current_items: list[WindowPrediction] = []

    for prediction in predictions:
        if prediction.label == Label.other:
            flush_segment(current_items, segments)
            current_items = []
            continue

        if not current_items:
            current_items = [prediction]
            continue

        previous = current_items[-1]
        gap = prediction.window.start_seconds - previous.window.end_seconds
        if (
            prediction.label == previous.label
            and gap <= settings.merge_gap_seconds
        ):
            current_items.append(prediction)
        else:
            flush_segment(current_items, segments)
            current_items = [prediction]

    flush_segment(current_items, segments)
    return segments


def flush_segment(
    items: Sequence[WindowPrediction],
    segments: list[EventSegment],
) -> None:
    if not items:
        return

    confidence = sum(item.confidence for item in items) / len(items)
    segments.append(
        EventSegment(
            label=items[0].label,
            start_seconds=items[0].window.start_seconds,
            end_seconds=items[-1].window.end_seconds,
            confidence=confidence,
            window_count=len(items),
        )
    )


def keep_segment(
    segment: EventSegment,
    settings: SegmentSettings,
) -> bool:
    if segment.confidence < settings.min_confidence:
        return False
    if segment.label == Label.snore:
        return segment.duration_seconds >= settings.min_snore_seconds
    if segment.label == Label.talk:
        return segment.duration_seconds >= settings.min_talk_seconds
    return False


def labels_for_debug(predictions: Iterable[WindowPrediction]) -> list[str]:
    return [prediction.label.value for prediction in predictions]
