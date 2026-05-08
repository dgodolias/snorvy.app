from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

from snorvy_ml.pipeline import run_cli


if __name__ == "__main__":
    run_cli()
