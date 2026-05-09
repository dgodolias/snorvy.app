"""Download pretrained models στο models/ directory.

Σταθερά URLs σε commit-pinned raw GitHub paths για reproducibility.
"""
from __future__ import annotations

import hashlib
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

MODELS = [
    {
        "name": "snore_cnn.tflite",
        "url": "https://github.com/adrianagaler/Snoring-Detection/raw/master/deployment/tiny_conv_micro_16k_silence_balanced/model.tflite",
        "expected_size": 18712,
    },
    {
        "name": "snore_cnn_float.tflite",
        "url": "https://github.com/adrianagaler/Snoring-Detection/raw/master/deployment/tiny_conv_micro_16k_silence_balanced/float_model.tflite",
        "expected_size": 68044,
    },
    {
        "name": "silero_vad.onnx",
        "url": "https://github.com/snakers4/silero-vad/raw/master/src/silero_vad/data/silero_vad.onnx",
        "expected_size": None,  # Silero ξανανεβαίνει συχνά, μην pin-άρουμε size
    },
]


def download(url: str, dest: Path) -> None:
    print(f"  Downloading {url}")
    with urllib.request.urlopen(url, timeout=60) as resp, dest.open("wb") as f:
        f.write(resp.read())


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    h.update(path.read_bytes())
    return h.hexdigest()


def main() -> int:
    target_dir = ROOT / "models"
    target_dir.mkdir(parents=True, exist_ok=True)

    print(f"Setup → {target_dir}")
    failures: list[str] = []
    for spec in MODELS:
        dest = target_dir / spec["name"]
        if dest.exists():
            size_ok = spec["expected_size"] is None or dest.stat().st_size == spec["expected_size"]
            if size_ok:
                print(f"  {spec['name']}: cached ({dest.stat().st_size} B, sha256={sha256(dest)[:12]})")
                continue
            print(f"  {spec['name']}: stale, re-downloading")
            dest.unlink()
        try:
            download(spec["url"], dest)
            actual = dest.stat().st_size
            print(f"  {spec['name']}: ok ({actual} B, sha256={sha256(dest)[:12]})")
            if spec["expected_size"] and actual != spec["expected_size"]:
                print(f"    !! expected {spec['expected_size']} B, got {actual} B")
        except Exception as exc:  # noqa: BLE001
            print(f"  {spec['name']}: FAILED — {exc}")
            failures.append(spec["name"])

    if failures:
        print(f"\nFAILED: {failures}")
        return 1
    print("\nAll models ready. Run: python scripts/validate.py")
    return 0


if __name__ == "__main__":
    sys.exit(main())
