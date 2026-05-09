from argparse import ArgumentParser
from collections.abc import Sequence
from dataclasses import dataclass
import csv
from pathlib import Path

import joblib
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.preprocessing import StandardScaler

from snorvy_ml.dataset import (
    WindowExample,
    build_labeled_examples,
    feature_matrix,
    target_labels,
)
from snorvy_ml.models import Label, TimeWindow, WindowPrediction
from snorvy_ml.output import write_segments_csv, write_window_predictions_csv
from snorvy_ml.segmenter import merge_predictions, smooth_predictions
from snorvy_ml.yamnet import load_yamnet_model


model_classes = (Label.other, Label.snore, Label.talk)


@dataclass(frozen=True)
class MetricRow:
    scope: str
    label: Label
    precision: float
    recall: float
    f1: float
    support: int


def train_classifier(examples: list[WindowExample]) -> Pipeline:
    return make_pipeline(
        StandardScaler(),
        LogisticRegression(
            C=1.0,
            class_weight="balanced",
            max_iter=2_000,
            random_state=7,
        ),
    ).fit(feature_matrix(examples), target_labels(examples))


def predict_examples(
    model: Pipeline,
    examples: list[WindowExample],
) -> list[WindowPrediction]:
    return predict_windows(
        model=model,
        windows=[example.window for example in examples],
        embeddings=feature_matrix(examples),
    )


def predict_windows(
    model: Pipeline,
    windows: Sequence[TimeWindow],
    embeddings: np.ndarray,
) -> list[WindowPrediction]:
    probabilities = model.predict_proba(embeddings)
    class_names = list(model.classes_)
    predictions: list[WindowPrediction] = []

    for index, window in enumerate(windows):
        row = probabilities[index]
        score_by_label = {
            class_name: float(row[class_index])
            for class_index, class_name in enumerate(class_names)
        }
        label = Label(class_names[int(np.argmax(row))])
        confidence = float(np.max(row))
        predictions.append(
            WindowPrediction(
                window=window,
                label=label,
                confidence=confidence,
                snore_score=score_by_label.get(Label.snore.value, 0.0),
                talk_score=score_by_label.get(Label.talk.value, 0.0),
                scores=score_by_label,
            )
        )

    return predictions


def metric_rows(
    scope: str,
    actual: Sequence[str],
    predicted: Sequence[str],
) -> list[MetricRow]:
    rows: list[MetricRow] = []
    for label in model_classes:
        label_value = label.value
        true_positive = sum(
            1
            for actual_label, predicted_label in zip(actual, predicted)
            if actual_label == label_value and predicted_label == label_value
        )
        false_positive = sum(
            1
            for actual_label, predicted_label in zip(actual, predicted)
            if actual_label != label_value and predicted_label == label_value
        )
        false_negative = sum(
            1
            for actual_label, predicted_label in zip(actual, predicted)
            if actual_label == label_value and predicted_label != label_value
        )
        support = sum(1 for actual_label in actual if actual_label == label_value)
        precision = divide_or_zero(true_positive, true_positive + false_positive)
        recall = divide_or_zero(true_positive, true_positive + false_negative)
        f1 = divide_or_zero(2 * precision * recall, precision + recall)
        rows.append(
            MetricRow(
                scope=scope,
                label=label,
                precision=precision,
                recall=recall,
                f1=f1,
                support=support,
            )
        )
    return rows


def divide_or_zero(numerator: float, denominator: float) -> float:
    if denominator == 0:
        return 0.0
    return numerator / denominator


def leave_one_file_out_metrics(examples: list[WindowExample]) -> list[MetricRow]:
    files = sorted({example.file for example in examples})
    rows: list[MetricRow] = []

    for held_out_file in files:
        train_examples = [
            example for example in examples if example.file != held_out_file
        ]
        test_examples = [
            example for example in examples if example.file == held_out_file
        ]
        model = train_classifier(train_examples)
        predictions = predict_examples(model, test_examples)
        rows.extend(
            metric_rows(
                scope=held_out_file,
                actual=[example.label.value for example in test_examples],
                predicted=[prediction.label.value for prediction in predictions],
            )
        )

    return rows


def write_metrics_csv(path: Path, rows: Sequence[MetricRow]) -> None:
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(
            file,
            fieldnames=["scope", "label", "precision", "recall", "f1", "support"],
        )
        writer.writeheader()
        for row in rows:
            writer.writerow(
                {
                    "scope": row.scope,
                    "label": row.label.value,
                    "precision": f"{row.precision:.6f}",
                    "recall": f"{row.recall:.6f}",
                    "f1": f"{row.f1:.6f}",
                    "support": str(row.support),
                }
            )


def write_trained_outputs(
    out_dir: Path,
    model: Pipeline,
    examples: list[WindowExample],
) -> None:
    for file_name in sorted({example.file for example in examples}):
        file_examples = [
            example for example in examples if example.file == file_name
        ]
        predictions = smooth_predictions(predict_examples(model, file_examples))
        segments = merge_predictions(predictions)
        file_out_dir = out_dir / Path(file_name).stem
        file_out_dir.mkdir(parents=True, exist_ok=True)
        write_window_predictions_csv(
            file_out_dir / "window_predictions.csv",
            predictions,
        )
        write_segments_csv(file_out_dir / "segments.csv", segments)


def build_parser() -> ArgumentParser:
    parser = ArgumentParser(description="Train the local Snorvy classifier head.")
    parser.add_argument(
        "--raw-dir",
        type=Path,
        default=Path("ml_lab/data/raw"),
        help="Directory containing labeled audio files.",
    )
    parser.add_argument(
        "--labels",
        type=Path,
        default=Path("ml_lab/data/labels/labels.csv"),
        help="CSV with file,start_seconds,end_seconds,label,notes.",
    )
    parser.add_argument(
        "--out",
        type=Path,
        default=Path("build/ml-lab/supervised"),
        help="Output directory for model and metrics.",
    )
    return parser


def run_cli() -> None:
    args = build_parser().parse_args()
    args.out.mkdir(parents=True, exist_ok=True)

    yamnet_model = load_yamnet_model()
    examples = build_labeled_examples(
        raw_dir=args.raw_dir,
        labels_path=args.labels,
        yamnet_model=yamnet_model,
    )
    model = train_classifier(examples)
    model_path = args.out / "classifier.joblib"
    metrics_path = args.out / "leave_one_file_out_metrics.csv"

    joblib.dump(model, model_path)
    write_metrics_csv(metrics_path, leave_one_file_out_metrics(examples))
    write_trained_outputs(args.out, model, examples)

    print(f"examples: {len(examples)}")
    print(f"model: {model_path}")
    print(f"metrics: {metrics_path}")
    print(f"outputs: {args.out}")
