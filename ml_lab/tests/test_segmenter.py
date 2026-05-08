import unittest

from snorvy_ml.models import Label, TimeWindow, WindowPrediction
from snorvy_ml.segmenter import merge_predictions, smooth_predictions


class SegmenterTest(unittest.TestCase):
    def test_merge_adjacent_same_labels(self) -> None:
        predictions = [
            prediction(0.0, 0.96, Label.snore),
            prediction(0.48, 1.44, Label.snore),
            prediction(0.96, 1.92, Label.noise),
            prediction(1.44, 2.40, Label.talk),
            prediction(1.92, 2.88, Label.talk),
        ]

        segments = merge_predictions(predictions)

        self.assertEqual([segment.label for segment in segments], [Label.snore, Label.talk])
        self.assertAlmostEqual(segments[0].start_seconds, 0.0)
        self.assertAlmostEqual(segments[0].end_seconds, 1.44)
        self.assertAlmostEqual(segments[1].start_seconds, 1.44)
        self.assertAlmostEqual(segments[1].end_seconds, 2.88)

    def test_smooth_single_window_label_flip(self) -> None:
        predictions = [
            prediction(0.0, 0.96, Label.snore),
            prediction(0.48, 1.44, Label.noise),
            prediction(0.96, 1.92, Label.snore),
        ]

        smoothed = smooth_predictions(predictions)

        self.assertEqual([item.label for item in smoothed], [Label.snore, Label.snore, Label.snore])


def prediction(start: float, end: float, label: Label) -> WindowPrediction:
    return WindowPrediction(
        window=TimeWindow(start_seconds=start, end_seconds=end),
        label=label,
        confidence=0.7,
        snore_score=0.7 if label == Label.snore else 0.0,
        talk_score=0.7 if label == Label.talk else 0.0,
    )


if __name__ == "__main__":
    unittest.main()
