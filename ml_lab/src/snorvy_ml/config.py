from dataclasses import dataclass


sample_rate_hz = 16_000
yamnet_window_seconds = 0.96
yamnet_hop_seconds = 0.48
yamnet_tfhub_url = "https://tfhub.dev/google/yamnet/1"

speech_class_terms = (
    "Speech",
    "Conversation",
    "Narration",
    "Monologue",
    "Child speech",
)
snore_class_terms = ("Snoring",)


@dataclass(frozen=True)
class LabelThresholds:
    snore_min_score: float = 0.20
    talk_min_score: float = 0.20
    winner_margin: float = 0.04


@dataclass(frozen=True)
class SegmentSettings:
    merge_gap_seconds: float = 0.72
    min_snore_seconds: float = 0.40
    min_talk_seconds: float = 1.20
    min_confidence: float = 0.75
