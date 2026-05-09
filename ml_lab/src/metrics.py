"""Frame-based metric (per 200ms tick) — έβλεπει αν το model πιάνει activity μέσα στις GT regions
ασχέτως πόσο fragmented είναι τα predicted events.

Κάθε tick παίρνει label:
  - GT: το πρώτο GT event που το περιέχει (snore wins αν overlap)
  - Pred: το πρώτο predicted event που το περιέχει (snore wins αν overlap)
"""
from __future__ import annotations

from dataclasses import dataclass

import numpy as np

TICK_S = 0.2  # ίδιο grid με decision.py


@dataclass
class ClassMetrics:
    label: str
    tp: int
    fp: int
    fn: int
    tn: int = 0

    @property
    def precision(self) -> float:
        denom = self.tp + self.fp
        return self.tp / denom if denom else 0.0

    @property
    def recall(self) -> float:
        denom = self.tp + self.fn
        return self.tp / denom if denom else 0.0

    @property
    def f1(self) -> float:
        p, r = self.precision, self.recall
        return 2 * p * r / (p + r) if (p + r) else 0.0


def _events_to_ticks(events: list[dict], n_ticks: int, tick_s: float = TICK_S) -> list[str | None]:
    """Per tick → label string ('snore'/'talk') ή None για silence.

    Snore wins σε overlap (consistent με decision matrix).
    """
    labels: list[str | None] = [None] * n_ticks
    # First pass: talk
    for ev in events:
        if ev["label"] != "talk":
            continue
        i0 = max(0, int(ev["start"] / tick_s))
        i1 = min(n_ticks, int(np.ceil(ev["end"] / tick_s)))
        for i in range(i0, i1):
            labels[i] = "talk"
    # Second pass: snore (overrides talk)
    for ev in events:
        if ev["label"] != "snore":
            continue
        i0 = max(0, int(ev["start"] / tick_s))
        i1 = min(n_ticks, int(np.ceil(ev["end"] / tick_s)))
        for i in range(i0, i1):
            labels[i] = "snore"
    return labels


def frame_metrics(
    predicted: list[dict],
    ground_truth: list[dict],
    duration_s: float,
    tick_s: float = TICK_S,
) -> dict[str, ClassMetrics]:
    """Per-class binary classification per tick.

    For class C:
      TP = ticks όπου GT=C AND Pred=C
      FP = ticks όπου GT≠C AND Pred=C
      FN = ticks όπου GT=C AND Pred≠C
      TN = ticks όπου GT≠C AND Pred≠C
    """
    n = max(1, int(np.ceil(duration_s / tick_s)))
    gt_ticks = _events_to_ticks(ground_truth, n, tick_s)
    pr_ticks = _events_to_ticks(predicted, n, tick_s)

    classes = {"snore", "talk"}
    metrics = {c: ClassMetrics(label=c, tp=0, fp=0, fn=0, tn=0) for c in classes}

    for i in range(n):
        for c in classes:
            gt_is_c = gt_ticks[i] == c
            pr_is_c = pr_ticks[i] == c
            if gt_is_c and pr_is_c:
                metrics[c].tp += 1
            elif (not gt_is_c) and pr_is_c:
                metrics[c].fp += 1
            elif gt_is_c and (not pr_is_c):
                metrics[c].fn += 1
            else:
                metrics[c].tn += 1
    return metrics


def aggregate(per_recording: list[dict[str, ClassMetrics]]) -> dict[str, ClassMetrics]:
    if not per_recording:
        return {}
    labels: set[str] = set()
    for m in per_recording:
        labels.update(m.keys())
    total = {label: ClassMetrics(label=label, tp=0, fp=0, fn=0, tn=0) for label in labels}
    for m in per_recording:
        for label, cm in m.items():
            total[label].tp += cm.tp
            total[label].fp += cm.fp
            total[label].fn += cm.fn
            total[label].tn += cm.tn
    return total


# Backward-compatible aliases
match_events = frame_metrics
aggregate_f1 = aggregate
