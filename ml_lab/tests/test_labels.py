import unittest

from snorvy_ml.labels import label_for_window
from snorvy_ml.models import Label, LabelSpan, TimeWindow


class LabelAssignmentTest(unittest.TestCase):
    def test_assigns_dominant_overlap_label(self) -> None:
        spans = [
            LabelSpan("clip.m4a", 0.0, 2.0, Label.other),
            LabelSpan("clip.m4a", 2.0, 3.0, Label.snore),
        ]

        label = label_for_window(TimeWindow(1.92, 2.88), spans)

        self.assertEqual(Label.snore, label)

    def test_drops_ambiguous_boundary_window(self) -> None:
        spans = [
            LabelSpan("clip.m4a", 0.0, 2.0, Label.other),
            LabelSpan("clip.m4a", 2.0, 4.0, Label.talk),
        ]

        label = label_for_window(TimeWindow(1.5, 2.5), spans)

        self.assertIsNone(label)


if __name__ == "__main__":
    unittest.main()
