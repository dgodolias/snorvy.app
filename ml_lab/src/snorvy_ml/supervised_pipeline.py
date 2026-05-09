from argparse import ArgumentParser
from pathlib import Path

import joblib

from snorvy_ml.models import PipelineResult
from snorvy_ml.output import write_segments_csv, write_window_predictions_csv
from snorvy_ml.segmenter import build_time_windows, merge_predictions, smooth_predictions
from snorvy_ml.training import predict_windows
from snorvy_ml.yamnet import load_audio_mono_16k, load_yamnet_model, run_yamnet, save_embeddings


def analyze_audio_file_with_classifier(
    input_path: Path,
    output_dir: Path,
    classifier_path: Path,
) -> PipelineResult:
    output_dir.mkdir(parents=True, exist_ok=True)

    classifier = joblib.load(classifier_path)
    yamnet_model = load_yamnet_model()
    waveform = load_audio_mono_16k(input_path)
    _, embeddings, _ = run_yamnet(yamnet_model, waveform)

    windows = build_time_windows(count=len(embeddings))
    raw_predictions = predict_windows(
        model=classifier,
        windows=windows,
        embeddings=embeddings,
    )
    window_predictions = smooth_predictions(raw_predictions)
    segments = merge_predictions(window_predictions)

    embeddings_path = output_dir / "embeddings.npz"
    window_predictions_path = output_dir / "window_predictions.csv"
    segments_path = output_dir / "segments.csv"

    save_embeddings(embeddings_path, embeddings, classifier.classes_)
    write_window_predictions_csv(window_predictions_path, window_predictions)
    write_segments_csv(segments_path, segments)

    return PipelineResult(
        window_predictions=window_predictions,
        segments=segments,
        embeddings_path=str(embeddings_path),
        window_predictions_path=str(window_predictions_path),
        segments_path=str(segments_path),
    )


def build_parser() -> ArgumentParser:
    parser = ArgumentParser(description="Run the trained Snorvy classifier head.")
    parser.add_argument("input", type=Path, help="Path to a wav/m4a/audio file.")
    parser.add_argument(
        "--classifier",
        type=Path,
        default=Path("build/ml-lab/supervised/classifier.joblib"),
        help="Path to the trained classifier joblib file.",
    )
    parser.add_argument(
        "--out",
        type=Path,
        default=Path("build/ml-lab/supervised-latest"),
        help="Output directory for CSV/NPZ artifacts.",
    )
    return parser


def run_cli() -> None:
    args = build_parser().parse_args()
    result = analyze_audio_file_with_classifier(
        input_path=args.input,
        output_dir=args.out,
        classifier_path=args.classifier,
    )
    print(f"windows: {len(result.window_predictions)}")
    print(f"segments: {len(result.segments)}")
    print(f"window CSV: {result.window_predictions_path}")
    print(f"segments CSV: {result.segments_path}")
    print(f"embeddings: {result.embeddings_path}")
