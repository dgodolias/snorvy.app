# ml_lab — Snorvy audio classification pipeline

Python validation lab για το audio pipeline που θα τρέξει στο Flutter app:
**Silero-VAD** (talk detection) + **adrianagaler tiny_conv** (snore detection) → parallel decision matrix → snore/talk events.

> Ο σκοπός εδώ ΔΕΝ είναι να τρέξει σε production. Είναι το **validation gate** πριν αγγίξουμε Flutter (per stochasm). Όταν τα F1 scores δείξουν `> 0.7` σε labeled recordings, εξάγουμε bundle σε `flutter_export/` έτοιμο για copy στο app.

## Quick start

```powershell
# 1. Δημιουργία venv (Windows PowerShell)
python -m venv .venv-ml
.venv-ml\Scripts\Activate.ps1

# 2. Install deps
pip install -r requirements.txt

# 3. Download pretrained models (Silero-VAD ONNX + adrianagaler TFLite)
python scripts/setup.py

# 4. Σύνδεση recordings — copy/move τα m4a αρχεία στο data/raw/
#    (ή πέρασε --raw-dir στο validate)
mkdir data\raw
copy ..\..\..\..\ml_lab\data\raw\*.m4a data\raw\

# 5. Τρέξε validation στα labeled recordings
python scripts/validate.py

# 6. Αν F1 > 0.7, εξήγαγε bundle για Flutter
python scripts/export.py
```

## Directory layout

```
ml_lab/
├── README.md                  # αυτό το αρχείο
├── requirements.txt           # Python deps
├── .gitignore
├── data/
│   ├── raw/                   # m4a recordings (gitignored)
│   ├── wav/                   # decoded 16kHz mono WAVs (gitignored)
│   └── labels.json            # ground truth από user labels
├── models/                    # downloaded pretrained (gitignored)
│   ├── snore_cnn.tflite       # adrianagaler 18.7KB INT8
│   ├── snore_cnn_float.tflite # adrianagaler 68KB float32
│   └── silero_vad.onnx        # Silero v5 ONNX ~1.7MB
├── src/
│   ├── audio.py               # decode m4a→wav, resample
│   ├── mfcc.py                # SpeechPy-style 32×32 MFCC (matches adrianagaler training)
│   ├── snore.py               # SnoreCNN sliding window inference
│   ├── vad.py                 # Silero ONNX inference με state management
│   ├── decision.py            # parallel decision + hysteresis + event grouping
│   ├── pipeline.py            # full orchestration για ένα file
│   └── metrics.py             # IoU event matching + F1
├── scripts/
│   ├── setup.py               # download models
│   ├── validate.py            # τρέχει pipeline σε labeled recordings, F1 report
│   └── export.py              # bundle για Flutter consumption
└── flutter_export/            # generated artifacts (gitignored)
    ├── snore_cnn.tflite
    ├── silero_vad.tflite      # converted Silero (αν setup περάσει)
    ├── pipeline_config.json   # ΟΛΑ τα hyperparams που θέλει το Flutter app
    └── README.md              # Flutter integration notes
```

## Pipeline architecture

```
input.m4a (variable sr, stereo)
    │
    ▼ decode (ffmpeg) + resample → 16kHz mono WAV
    │
    ├──► Silero-VAD (chunked) ──► voice_prob timeline (per 32ms frame)
    │
    └──► SnoreCNN (sliding 1s, hop 200ms)
              │ MFCC 32×32 (SpeechPy bit-exact)
              ▼
            snore_prob timeline
    │
    ▼ combine on 200ms grid + decision matrix
    │
    ├─► snore: prob > 0.7
    ├─► talk: voice > 0.5 & snore < 0.5
    └─► silence/noise: both low
    │
    ▼ hysteresis + min_duration + merge_gap
    │
    ▼
Events: [{start, end, label, confidence}, ...]
```

## Decision matrix

| voice_prob | snore_prob | output |
|---|---|---|
| any | > 0.7 | **snore** (snore wins on conflict) |
| > 0.5 | < 0.5 | **talk** |
| > 0.5 | 0.5-0.7 | **talk** (borderline) |
| < 0.5 | < 0.5 | silence/noise (drop) |

Hyperparameters live σε [src/decision.py](src/decision.py) και εξάγονται σε `flutter_export/pipeline_config.json`.

## Validation acceptance criterion

Από το stochasm:

> Pass: **F1 > 0.7** σε όλα τα labeled recordings (rec2-rec5).
> Fail → retrain σε δικά μας data αντί να debug-άρουμε mismatched preprocessing για βδομάδες.

## Prerequisites

- **Python 3.10+** (3.11 ή 3.12 ιδανικά)
- **ffmpeg** στο PATH (για m4a decode). Windows: `winget install ffmpeg`
- **Internet** για το `scripts/setup.py` (downloads ~2MB models)

## Known caveats

- adrianagaler model **δεν έχει LICENSE** στο repo. Για prototype OK· πριν το ship, ζήτα confirmation από την Adriana Rotaru ή retrain.
- Silero TFLite conversion γίνεται στο `scripts/export.py`. Αν αποτύχει, fallback σε ONNX runtime στο Flutter (`onnxruntime` Dart bindings, λιγότερο mature).
- Domain shift: τα 91% accuracy του adrianagaler είναι σε Kaggle studio data. Περίμενε 75-85% στα δικά μας phone-mic recordings.

## Next steps post-validation

1. Αν F1 ✅ → run `scripts/export.py` → copy `flutter_export/` στο `assets/` του Flutter app
2. Αν F1 ❌ → retrain (separate effort), ή review preprocessing mismatch με `scripts/validate.py --debug-mfcc`
