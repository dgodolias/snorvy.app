from collections.abc import Sequence

import numpy as np

from snorvy_ml.config import LabelThresholds, snore_class_terms, speech_class_terms
from snorvy_ml.models import Label, TimeWindow, WindowPrediction


def class_indices(class_names: Sequence[str], terms: Sequence[str]) -> list[int]:
    return [
        index
        for index, class_name in enumerate(class_names)
        if any(term.lower() in class_name.lower() for term in terms)
    ]


def max_score(scores: np.ndarray, indices: Sequence[int]) -> float:
    if not indices:
        return 0.0
    return float(np.max(scores[list(indices)]))


def classify_score_row(
    scores: np.ndarray,
    class_names: Sequence[str],
    window: TimeWindow,
    thresholds: LabelThresholds = LabelThresholds(),
) -> WindowPrediction:
    snore_indices = class_indices(class_names, snore_class_terms)
    talk_indices = class_indices(class_names, speech_class_terms)
    snore_score = max_score(scores, snore_indices)
    talk_score = max_score(scores, talk_indices)

    label = Label.noise
    confidence = max(snore_score, talk_score)

    if (
        snore_score >= thresholds.snore_min_score
        and snore_score >= talk_score + thresholds.winner_margin
    ):
        label = Label.snore
        confidence = snore_score
    elif (
        talk_score >= thresholds.talk_min_score
        and talk_score >= snore_score + thresholds.winner_margin
    ):
        label = Label.talk
        confidence = talk_score

    selected_scores = {
        "snore": snore_score,
        "talk": talk_score,
    }

    return WindowPrediction(
        window=window,
        label=label,
        confidence=confidence,
        snore_score=snore_score,
        talk_score=talk_score,
        scores=selected_scores,
    )


def classify_score_matrix(
    scores: np.ndarray,
    class_names: Sequence[str],
    windows: Sequence[TimeWindow],
    thresholds: LabelThresholds = LabelThresholds(),
) -> list[WindowPrediction]:
    return [
        classify_score_row(
            scores=scores[index],
            class_names=class_names,
            window=windows[index],
            thresholds=thresholds,
        )
        for index in range(min(len(scores), len(windows)))
    ]
