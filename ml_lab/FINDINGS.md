# Validation findings — 2026-05-09

**Verdict: FAIL** σε F1 > 0.7 gate. Δύο compounding προβλήματα, και τα δύο προβλέφθηκαν στο stochasm.

## Numbers

| Recording | Snore F1 | Talk F1 |
|---|---|---|
| rec2 | 0.00 | 0.00 |
| rec3 | 0.00 | 0.00 |
| rec4 | 0.00 | — |
| rec5 | 0.50 | 0.00 |
| **Aggregate** | **0.19** | **0.00** |

## Root causes

### 1. SnoreCNN preprocessing mismatch (stochasm critical risk #1, exact prediction)

Το `tiny_conv_micro_16k_silence_balanced/model.tflite` αποδείχθηκε ότι **δεν** χρησιμοποιεί SpeechPy MFCC (όπως υπονοούσε το repo README). Στην πραγματικότητα τρέφεται από το **TFLite-Micro `audio_microfrontend` op**:

- Input: `(1, 1960)` int8 — 49 frames × 40 mel channels flattened
- Preprocessing: log-mel + **PCAN** (Per-Channel Auto Normalization)
- Δεν υπάρχει επίσημο Python port του audio_microfrontend
- TensorFlow full install απέτυχε σε Windows long-path (filename > MAX_PATH)

Η librosa log-mel approximation χωρίς PCAN δίνει `~19% snore F1`. Το model δεν διακρίνει snore από silence/talk χωρίς το exact preprocessing.

### 2. Audio recording level πολύ χαμηλό

Τα recordings έχουν RMS 0.001-0.003 (**-50 έως -54 dBFS**) — ~30 dB κάτω από κανονικό phone recording. Ο Silero-VAD επιστρέφει `voice_prob ≈ 0` παντού, ακόμη και με x20 amplification (max 0.16, < threshold 0.5).

```
per-second RMS at rec5 (talking labeled at 78-93s):
  78-93s talk:  rms ≈ 0.0023-0.0028  (only ~30% πάνω από background)
  background:  rms ≈ 0.0017
```

Το audio_microfrontend έχει PCAN ειδικά για αυτή τη συνθήκη — δυναμικό gain. Ο Silero-VAD δεν.

## Τι δούλεψε

✅ Pipeline scaffolding — όλο το end-to-end orchestration τρέχει: decode → MFCC → inference → decision → events → F1.
✅ Setup script — downloads ~2.4MB models χωρίς errors.
✅ Validation harness — clean F1 report, JSON dump, exit codes.
✅ Decision matrix + hysteresis logic — δοκιμασμένα σε edge cases.

## Τι ΔΕΝ δούλεψε

❌ adrianagaler model με μη-exact preprocessing → 19% F1.
❌ Silero-VAD με quiet recordings → 0 detection.

## Επόμενα βήματα (recommendations)

### Option A: Retrain στα δικά μας recordings (recommended από stochasm net judgement)

- Pros: Πλήρης έλεγχος preprocessing, ταιριάζει στο noise floor / mic profile του phone
- Cons: ~30-60 min training, χρειαζόμαστε περισσότερα labels (rec2-rec5 είναι λίγα)
- Approach: librosa log-mel features → απλό CNN ή transfer-learning από YAMNet → TFLite export

### Option B: Acquire exact audio_microfrontend

- Vendoring του C++ source σε ένα μικρό Python wrapper, ή
- TensorFlow install σε shorter path (π.χ. `C:\tf_venv` αντί για το worktree path)
- Αν επιτύχει: το adrianagaler model πιθανότατα δίνει 75-85% F1 (το 91% Kaggle κατεβαίνει λόγω domain shift)

### Option C: AGC pre-amplification + οποιοδήποτε approach

- Πρόσθεσε automatic gain control πριν το VAD/CNN
- Κερδίζει τους Silero θεωρητικά (fixes the level problem only)
- Δεν λύνει το preprocessing mismatch του snore CNN

### Option D: Audio recorder fix στο Flutter app

- Άλλαξε το recorder gain settings στο [audio_event_clip_store.dart](../../../lib/src/services/audio_event_clip_store.dart) ώστε τα recordings να είναι σε normal -20 dBFS
- Ταυτόχρονη retrain ή AGC θα παραμένει αναγκαίο

## Stochasm calibration

| Stochasm prediction | Actual outcome |
|---|---|
| "Preprocessing mismatch is #1 silent killer" | ✅ EXACTLY αυτό συνέβη |
| "Realistic 75-85% accuracy" | ❌ Πολύ χαμηλότερο (19%) — αλλά λόγω missing preprocessing, όχι domain shift |
| "Silero may flag snores as voice" | ❌ Silero δεν detect-άρει τίποτα — ούτε καν το talk |
| "1-day Python validation" | ✅ ~3 hours |
| "If F1 < 0.7 → retrain" | ✅ Recommended path forward |

## Commit message για το worktree

```
Add ml_lab Python validation harness (Silero-VAD + adrianagaler tiny_conv)

Validation FAILED on labeled recordings (snore F1=0.19, talk F1=0.00).
Root causes:
  1. adrianagaler model requires TFLite-Micro audio_microfrontend (PCAN);
     librosa log-mel approximation insufficient.
  2. Recording level -50 dBFS leaves Silero-VAD with no signal.

Pipeline scaffolding works end-to-end. Next: retrain on local data with
controlled preprocessing, OR acquire exact audio_microfrontend.

See ml_lab/FINDINGS.md for full report.
```
