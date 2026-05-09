"""Parallel decision matrix + event grouping (post-process)."""
from __future__ import annotations

from dataclasses import dataclass

import numpy as np

# Decision thresholds — tuned για quiet phone-mic recordings.
SNORE_ENTER = 0.40
SNORE_EXIT = 0.25
TALK_ENTER = 0.50
TALK_EXIT = 0.30

MIN_SNORE_DURATION_S = 0.4
MIN_TALK_DURATION_S = 0.5
MERGE_GAP_SNORE_S = 1.5
MERGE_GAP_TALK_S = 1.5
SUPPRESSION_S = 1.5

DECISION_GRID_S = 0.2  # 200ms ticks


@dataclass
class Event:
    start: float
    end: float
    label: str
    confidence: float

    def to_dict(self) -> dict:
        return {
            "start": round(self.start, 3),
            "end": round(self.end, 3),
            "label": self.label,
            "confidence": round(self.confidence, 4),
        }


def _resample_to_grid(timestamps: np.ndarray, values: np.ndarray, grid: np.ndarray) -> np.ndarray:
    """Linear resample of (timestamps, values) onto common grid."""
    if timestamps.size == 0:
        return np.zeros_like(grid)
    return np.interp(grid, timestamps, values, left=values[0], right=values[-1])


def combine_streams(
    snore_timestamps: np.ndarray,
    snore_probs: np.ndarray,
    voice_timestamps: np.ndarray,
    voice_probs: np.ndarray,
    duration_s: float,
) -> list[Event]:
    """Run parallel decision matrix on a 200ms grid and group ticks into events.

    Decision priority per tick:
      snore_prob >= SNORE_ENTER          -> snore
      voice_prob >= TALK_ENTER (and not snore) -> talk
      otherwise                          -> silence (dropped)

    Με hysteresis (state machine) ώστε να μην flicker-άρει στο boundary.
    """
    grid = np.arange(0.0, duration_s + DECISION_GRID_S, DECISION_GRID_S)
    snore_on_grid = _resample_to_grid(snore_timestamps, snore_probs, grid)
    voice_on_grid = _resample_to_grid(voice_timestamps, voice_probs, grid)

    snore_events = _hysteresis_events(
        grid, snore_on_grid, voice_on_grid,
        enter=SNORE_ENTER, exit_=SNORE_EXIT,
        label="snore", min_duration=MIN_SNORE_DURATION_S,
        priority="snore",
    )
    talk_events = _hysteresis_events(
        grid, snore_on_grid, voice_on_grid,
        enter=TALK_ENTER, exit_=TALK_EXIT,
        label="talk", min_duration=MIN_TALK_DURATION_S,
        priority="talk",
    )

    snore_events = _merge_close(snore_events, MERGE_GAP_SNORE_S)
    talk_events = _merge_close(talk_events, MERGE_GAP_TALK_S)
    return sorted(snore_events + talk_events, key=lambda e: e.start)


def _hysteresis_events(
    grid: np.ndarray,
    snore: np.ndarray,
    voice: np.ndarray,
    *,
    enter: float,
    exit_: float,
    label: str,
    min_duration: float,
    priority: str,
) -> list[Event]:
    """Per-class hysteresis state machine με decision matrix priority.

    Decision matrix:
    - Όταν label='snore', enter όταν snore >= enter_threshold
    - Όταν label='talk', enter όταν voice >= enter_threshold ΚΑΙ snore < enter_threshold
      (snore wins on conflict — loud snore που το VAD νομίζει voice δεν γίνεται talk)
    """
    events: list[Event] = []
    in_event = False
    seg_start = 0.0
    seg_probs: list[float] = []

    for i, t in enumerate(grid):
        if label == "snore":
            target = snore[i]
            active = (target >= enter) if not in_event else (target >= exit_)
        else:  # talk
            target = voice[i]
            snore_active = snore[i] >= SNORE_ENTER
            if in_event:
                active = (target >= exit_) and not snore_active
            else:
                active = (target >= enter) and not snore_active

        if active and not in_event:
            in_event = True
            seg_start = t
            seg_probs = [target]
        elif active and in_event:
            seg_probs.append(target)
        elif (not active) and in_event:
            duration = t - seg_start
            if duration >= min_duration:
                events.append(
                    Event(
                        start=seg_start,
                        end=t,
                        label=label,
                        confidence=float(np.mean(seg_probs)) if seg_probs else 0.0,
                    )
                )
            in_event = False
            seg_probs = []

    if in_event:
        duration = grid[-1] - seg_start
        if duration >= min_duration:
            events.append(
                Event(
                    start=seg_start,
                    end=grid[-1],
                    label=label,
                    confidence=float(np.mean(seg_probs)) if seg_probs else 0.0,
                )
            )
    return events


def _merge_close(events: list[Event], max_gap: float) -> list[Event]:
    if not events:
        return events
    events = sorted(events, key=lambda e: e.start)
    merged = [events[0]]
    for ev in events[1:]:
        last = merged[-1]
        if ev.label == last.label and (ev.start - last.end) <= max_gap:
            merged[-1] = Event(
                start=last.start,
                end=ev.end,
                label=last.label,
                confidence=(last.confidence + ev.confidence) / 2,
            )
        else:
            merged.append(ev)
    return merged


def get_config() -> dict:
    return {
        "snore_enter_threshold": SNORE_ENTER,
        "snore_exit_threshold": SNORE_EXIT,
        "talk_enter_threshold": TALK_ENTER,
        "talk_exit_threshold": TALK_EXIT,
        "min_snore_duration_seconds": MIN_SNORE_DURATION_S,
        "min_talk_duration_seconds": MIN_TALK_DURATION_S,
        "merge_gap_snore_seconds": MERGE_GAP_SNORE_S,
        "merge_gap_talk_seconds": MERGE_GAP_TALK_S,
        "suppression_seconds": SUPPRESSION_S,
        "decision_grid_seconds": DECISION_GRID_S,
        "snore_wins_on_conflict": True,
    }
