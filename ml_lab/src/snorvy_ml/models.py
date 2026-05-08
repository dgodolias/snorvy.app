from dataclasses import dataclass, field
from enum import StrEnum


class Label(StrEnum):
    noise = "noise"
    snore = "snore"
    talk = "talk"


@dataclass(frozen=True)
class TimeWindow:
    start_seconds: float
    end_seconds: float

    @property
    def duration_seconds(self) -> float:
        return self.end_seconds - self.start_seconds


@dataclass(frozen=True)
class WindowPrediction:
    window: TimeWindow
    label: Label
    confidence: float
    snore_score: float
    talk_score: float
    scores: dict[str, float] = field(default_factory=dict)


@dataclass(frozen=True)
class EventSegment:
    label: Label
    start_seconds: float
    end_seconds: float
    confidence: float
    window_count: int

    @property
    def duration_seconds(self) -> float:
        return self.end_seconds - self.start_seconds


@dataclass(frozen=True)
class PipelineResult:
    window_predictions: list[WindowPrediction]
    segments: list[EventSegment]
    embeddings_path: str
    window_predictions_path: str
    segments_path: str
