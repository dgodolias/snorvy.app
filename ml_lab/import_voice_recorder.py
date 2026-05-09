from pathlib import Path
from datetime import datetime
import shutil


def voice_recorder_dir() -> Path:
    return Path.home() / "Documents" / "Sound recordings"


def latest_recording(source_dir: Path) -> Path:
    recordings = sorted(
        [
            path
            for path in source_dir.iterdir()
            if path.is_file() and path.suffix.lower() in {".m4a", ".wav", ".aac", ".mp3"}
        ],
        key=lambda path: path.stat().st_mtime,
        reverse=True,
    )
    if not recordings:
        raise FileNotFoundError(f"No recordings found in {source_dir}")
    return recordings[0]


def import_latest() -> Path:
    source_dir = voice_recorder_dir()
    source = latest_recording(source_dir)
    target_dir = Path(__file__).resolve().parent / "data" / "raw"
    target_dir.mkdir(parents=True, exist_ok=True)
    modified_at = datetime.fromtimestamp(source.stat().st_mtime)
    target_name = f"voice_recorder_{modified_at:%Y-%m-%d_%H%M%S}{source.suffix.lower()}"
    target = target_dir / target_name
    shutil.copy2(source, target)
    return target


def main() -> None:
    target = import_latest()
    print(target)


if __name__ == "__main__":
    main()
