# Snorvy ML Lab

Local Python sandbox for testing the audio pipeline before it goes into the
Flutter app.

Pipeline:

```text
audio file
-> mono 16 kHz waveform
-> YAMNet windows, 0.96s window / 0.48s hop
-> other/snore/talk label per window
-> smoothing
-> merged event segments
-> CSV artifacts for inspection
```

## Setup

```powershell
python -m venv .venv-ml
.\.venv-ml\Scripts\python -m pip install --upgrade pip
.\.venv-ml\Scripts\python -m pip install -r ml_lab\requirements.txt
```

## Run On One Audio File

Import the newest Windows Voice Recorder file:

```powershell
python ml_lab\import_voice_recorder.py
```

```powershell
.\.venv-ml\Scripts\python ml_lab\run_pipeline.py path\to\clip.wav --out build\ml-lab\run-001
```

Outputs:

- `window_predictions.csv`: one row per YAMNet window.
- `segments.csv`: merged snore/talk events.
- `embeddings.npz`: frozen YAMNet embeddings for later classifier training.

## Labels

Labels live in `ml_lab/data/labels/labels.csv`:

```csv
file,start_seconds,end_seconds,label,notes
clip.wav,1.44,3.36,snore,user-labeled snore
clip.wav,6.72,10.08,talk,user-labeled talk
clip.wav,12.00,13.44,other,quiet/background
```

Use three labels only: `other`, `snore`, `talk`.

## Train Classifier Head

Train a small classifier on top of frozen YAMNet embeddings:

```powershell
.\.venv-ml\Scripts\python ml_lab\train_classifier.py --out build\ml-lab\supervised
```

Outputs:

- `classifier.joblib`: trained local classifier head.
- `leave_one_file_out_metrics.csv`: sanity-check metrics per held-out recording.
- one folder per labeled recording with predicted `window_predictions.csv` and `segments.csv`.

Run the trained classifier on a new file:

```powershell
.\.venv-ml\Scripts\python ml_lab\run_trained_pipeline.py path\to\clip.m4a --out build\ml-lab\new-test
```
