from argparse import ArgumentParser
from pathlib import Path

from snorvy_ml.classifier import classify_score_matrix
from snorvy_ml.models import PipelineResult
from snorvy_ml.output import write_segments_csv, write_window_predictions_csv
from snorvy_ml.segmenter import build_time_windows, merge_predictions, smooth_predictions
from snorvy_ml.yamnet import (
    load_audio_mono_16k,
    load_yamnet_model,
    read_yamnet_class_names,
    run_yamnet,
    save_embeddings,
)


def analyze_audio_file(input_path: Path, output_dir: Path) -> PipelineResult:
    output_dir.mkdir(parents=True, exist_ok=True)

    model = load_yamnet_model()
    class_names = read_yamnet_class_names(model)
    waveform = load_audio_mono_16k(input_path)
    scores, embeddings, _ = run_yamnet(model, waveform)

    windows = build_time_windows(count=len(scores))
    raw_predictions = classify_score_matrix(
        scores=scores,
        class_names=class_names,
        windows=windows,
    )
    window_predictions = smooth_predictions(raw_predictions)
    segments = merge_predictions(window_predictions)

    embeddings_path = output_dir / "embeddings.npz"
    window_predictions_path = output_dir / "window_predictions.csv"
    segments_path = output_dir / "segments.csv"

    save_embeddings(embeddings_path, embeddings, class_names)
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
    parser = ArgumentParser(description="Run the local Snorvy ML audio pipeline.")
    parser.add_argument("input", type=Path, help="Path to a wav/m4a/audio file.")
    parser.add_argument(
        "--out",
        type=Path,
        default=Path("build/ml-lab/latest"),
        help="Output directory for CSV/NPZ artifacts.",
    )
    return parser


def run_cli() -> None:
    args = build_parser().parse_args()
    result = analyze_audio_file(input_path=args.input, output_dir=args.out)
    print(f"windows: {len(result.window_predictions)}")
    print(f"segments: {len(result.segments)}")
    print(f"window CSV: {result.window_predictions_path}")
    print(f"segments CSV: {result.segments_path}")
    print(f"embeddings: {result.embeddings_path}")
