"""Bundle pretrained models + config για copy στο Flutter app.

Εξάγει:
  flutter_export/
    snore_cnn.tflite       (copy από models/)
    silero_vad.tflite      (TFLite conversion από ONNX, αν διαθέσιμο· αλλιώς ONNX)
    silero_vad.onnx        (fallback)
    pipeline_config.json   (όλες οι παράμετροι του pipeline)
    README.md              (Flutter integration notes)
"""
from __future__ import annotations

import json
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from src import decision, mfcc, snore, vad  # noqa: E402


def try_convert_silero_to_tflite(onnx_path: Path, tflite_path: Path) -> bool:
    """Best-effort onnx → tflite conversion via onnx2tf.

    onnx2tf δεν είναι πάντα stable σε Silero v5 stateful tensors. Αν αποτύχει,
    το Flutter app θα τρέξει Silero μέσω onnxruntime Dart bindings.
    """
    try:
        import onnx2tf  # noqa: F401
    except ImportError:
        print("  [skip] onnx2tf δεν είναι installed (pip install onnx2tf)")
        return False
    work_dir = tflite_path.parent / "_silero_tf_tmp"
    work_dir.mkdir(parents=True, exist_ok=True)
    try:
        subprocess.run(
            ["onnx2tf", "-i", str(onnx_path), "-o", str(work_dir), "-osd"],
            check=True,
        )
        for candidate in work_dir.rglob("*_float32.tflite"):
            shutil.copy2(candidate, tflite_path)
            return True
        return False
    except Exception as exc:  # noqa: BLE001
        print(f"  [fail] onnx2tf: {exc}")
        return False
    finally:
        shutil.rmtree(work_dir, ignore_errors=True)


def main() -> int:
    out = ROOT / "flutter_export"
    out.mkdir(parents=True, exist_ok=True)

    snore_src = ROOT / "models" / "snore_cnn.tflite"
    vad_src = ROOT / "models" / "silero_vad.onnx"
    if not snore_src.exists() or not vad_src.exists():
        print("ERROR: missing models — run scripts/setup.py first")
        return 1

    print(f"Exporting → {out}")
    shutil.copy2(snore_src, out / "snore_cnn.tflite")
    print(f"  snore_cnn.tflite  ({snore_src.stat().st_size} B)")

    shutil.copy2(vad_src, out / "silero_vad.onnx")
    print(f"  silero_vad.onnx   ({vad_src.stat().st_size} B)")

    converted = try_convert_silero_to_tflite(vad_src, out / "silero_vad.tflite")
    if converted:
        print(f"  silero_vad.tflite ({(out / 'silero_vad.tflite').stat().st_size} B)")
    else:
        print("  silero_vad.tflite NOT generated — Flutter app θα χρησιμοποιήσει ONNX runtime")

    config = {
        "version": 1,
        "mfcc": mfcc.get_config(),
        "vad": vad.get_config(),
        "snore": {
            "class_index": snore.CLASS_INDEX,
            "default_hop_seconds": snore.DEFAULT_HOP_SECONDS,
            "window_samples": snore.WINDOW_SAMPLES,
        },
        "decision": decision.get_config(),
        "models": {
            "snore_tflite": "snore_cnn.tflite",
            "vad_tflite": "silero_vad.tflite" if converted else None,
            "vad_onnx": "silero_vad.onnx",
        },
    }
    config_path = out / "pipeline_config.json"
    config_path.write_text(json.dumps(config, indent=2), encoding="utf-8")
    print(f"  pipeline_config.json")

    readme = out / "README.md"
    readme.write_text(_flutter_readme(converted), encoding="utf-8")
    print(f"  README.md")

    print("\nDone. Copy αυτά τα αρχεία στο Flutter app:")
    print(f"  cp {out}/snore_cnn.tflite      <flutter_root>/assets/ml/")
    print(f"  cp {out}/silero_vad.{('tflite' if converted else 'onnx')}  <flutter_root>/assets/ml/")
    print(f"  cp {out}/pipeline_config.json  <flutter_root>/assets/ml/")
    return 0


def _flutter_readme(silero_tflite: bool) -> str:
    silero_ext = "tflite" if silero_tflite else "onnx"
    silero_pkg = "tflite_flutter" if silero_tflite else "onnxruntime"
    return f"""# Flutter export bundle

Αυτό είναι το ready-to-copy bundle για το Flutter app.

## Αρχεία

| File | Τι είναι | Πού πάει |
|---|---|---|
| `snore_cnn.tflite` | adrianagaler tiny_conv INT8 (~18.7KB) | `assets/ml/` |
| `silero_vad.{silero_ext}` | Silero VAD ({silero_pkg}) | `assets/ml/` |
| `pipeline_config.json` | ΟΛΑ τα hyperparameters του pipeline | `assets/ml/` |

## Flutter dependencies

```yaml
dependencies:
  tflite_flutter: ^0.10.0
  {"# silero δεν χρειάζεται extra package, ίδιο tflite_flutter" if silero_tflite else "onnxruntime: ^1.4.0  # για Silero ONNX"}
  ffi: ^2.0.0
```

## Pipeline contract

Το `pipeline_config.json` είναι το **single source of truth**. Το Flutter app πρέπει να
αναπαράγει:

1. **Audio capture σε 16 kHz mono** — `AudioRecord` με `sampleRate: 16000` (Android)
2. **MFCC bit-exact** με τις παραμέτρους στο `mfcc` section. Χρησιμοποίησε ένα από:
   - `dart_melgram` (community) με matched config
   - Custom port του SpeechPy MFCC σε Dart
   - **VALIDATE bit-exact** σε ένα γνωστό WAV πριν trust-άρεις το model output
3. **Silero state management** ανά chunk (state shape `(2, 1, 128)` για v5)
4. **Decision matrix + hysteresis** ακριβώς όπως στο `decision` section

## Caveat

License του `snore_cnn.tflite` είναι ασαφές — adrianagaler repo δεν έχει LICENSE file.
Πριν το ship-άρεις σε production:
- Ανοιξε GitHub issue στην Adriana Rotaru για license confirmation
- Ή retrain στο Kaggle Snoring Dataset με ίδια `tiny_conv` recipe (~30 min CPU)
"""


if __name__ == "__main__":
    sys.exit(main())
