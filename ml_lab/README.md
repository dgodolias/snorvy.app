# Snorvy ML Lab

Local Python sandbox for testing the audio pipeline before it goes into the
Flutter app.

Pipeline:

```text
audio file
-> mono 16 kHz waveform
-> YAMNet windows, 0.96s window / 0.48s hop
-> noise/snore/talk label per window
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

```powershell
.\.venv-ml\Scripts\python ml_lab\run_pipeline.py path\to\clip.wav --out build\ml-lab\run-001
```

Outputs:

- `window_predictions.csv`: one row per YAMNet window.
- `segments.csv`: merged snore/talk events.
- `embeddings.npz`: frozen YAMNet embeddings for later classifier training.

## Next Step

Once the window/segment output looks reasonable, we add a labeler that writes:

```csv
file,start_seconds,end_seconds,label
clip.wav,1.44,3.36,snore
clip.wav,6.72,10.08,talk
clip.wav,12.00,13.44,noise
```

Then we train a small classifier head on top of the frozen YAMNet embeddings.
