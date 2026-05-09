# Snorvy ML Bundle — Flutter Integration Guide

**For:** the agent integrating αυτό το ML bundle στο `snorvy.app` Flutter project.
**Source:** worktree `ml-pipeline` (branch `worktree-ml-pipeline`), `ml_lab/` Python validation lab.
**Validation status:** ⚠️ FAIL on F1>0.7 gate — see "Current accuracy" κάτω.
**APK budget:** ~38 MB universal increase confirmed acceptable (app στα 22 MB → 60 MB OK).

## TL;DR — what to do

1. Copy 3 files σε `assets/ml/`
2. Add 3 packages στο `pubspec.yaml`
3. Implement 5 Dart classes (one is hard — `AudioMicrofrontend`)
4. Wire τα predictions στο υπάρχον [audio_event_clip_store.dart](../../../../../../../lib/src/services/audio_event_clip_store.dart)
5. Test με τα recordings που υπάρχουν στο [ml_lab/data/raw/](../../../../../../../ml_lab/data/raw/) (rec2-rec5)
6. Compare με τα Python predictions στο [ml_lab/data/validation_report.json](../../data/validation_report.json)

## ⛔ Critical "do NOT" list

| Don't | Why |
|---|---|
| Don't change τη recording config στο [sleep_recorder.dart](../../../../../../../lib/src/services/sleep_recorder.dart) | RAW audio είναι σκόπιμο — DSP θα παραμορφώσει snore signature. AGC at inference time αντί. |
| Don't use librosa-style MFCC | Το model trained σε TFLite-Micro `audio_microfrontend` με PCAN. Mismatch = 19% F1 (verified). |
| Don't change sample rate από 16000 | Hardcoded σε models, recording, και configs. |
| Don't enable `enableNoiseSuppression` ή `enableVoiceProcessing` | Θα κόψει snoring frequencies. |
| Don't ship without measuring με rec2-rec5 πρώτα | Numbers must match Python validation_report.json (within ±5%) — αλλιώς preprocessing έχει drift. |
| Don't merge κοντινά snore events πριν UI | User βλέπει events όπως τα βγάζει το model — post-processing decisions ζουν στο UI layer. |
| Don't hardcode hyperparameters | Διάβαζε `pipeline_config.json` ως single source of truth. |

## Bundle contents

```
flutter_export/
├── snore_cnn.tflite       # 18.7 KB — adrianagaler tiny_conv INT8
├── silero_vad.onnx        # 2.3 MB  — Silero v5 voice activity detector
├── pipeline_config.json   # 1.3 KB  — όλα τα hyperparameters
└── README.md              # αυτό το αρχείο
```

## APK size impact (user-confirmed acceptable)

| | Per ABI | Universal APK |
|---|---|---|
| Assets (3 files) | ~2.3 MB | ~2.3 MB |
| `tflite_flutter` native libs | ~2 MB | ~6 MB |
| `onnxruntime` native libs | ~10 MB | ~30 MB |
| `AudioMicrofrontend` Dart port | ~50 KB | ~50 KB |
| **Total** | **~14 MB** | **~38 MB** |

## Dependencies — pubspec.yaml

```yaml
dependencies:
  tflite_flutter: ^0.10.4
  onnxruntime: ^1.4.1
  ffi: ^2.1.0  # για native MFCC port (αν επιλέξεις FFI route)

flutter:
  assets:
    - assets/ml/snore_cnn.tflite
    - assets/ml/silero_vad.onnx
    - assets/ml/pipeline_config.json
```

⚠️ Στο `android/app/build.gradle.kts` πιθανότατα χρειάζεται `packagingOptions { pickFirst("**/libc++_shared.so") }` για τα native libs.

## Step-by-step integration

### Step 1: Copy assets

```powershell
mkdir <flutter_root>\assets\ml
copy snore_cnn.tflite      <flutter_root>\assets\ml\
copy silero_vad.onnx       <flutter_root>\assets\ml\
copy pipeline_config.json  <flutter_root>\assets\ml\
```

### Step 2: Add Dart classes

Όλα στο `lib/src/services/ml/` — νέο folder. **Σειρά υλοποίησης**:

#### 2a. `pipeline_config.dart` — load JSON

Παράγει typed Dart object από `pipeline_config.json`. Parse στο app startup, expose ως singleton ή Riverpod provider.

#### 2b. `audio_agc.dart` — software AGC

Port του [ml_lab/src/audio.py:apply_agc](../../src/audio.py). Target -20 dBFS RMS, peak headroom -1 dBFS, max gain 40 dB. Idempotent. Apply σε raw float32 audio buffer.

```dart
class AudioAgc {
  static (Float32List, double) apply(Float32List audio) {
    // RMS, peak, gain calc → multiply
    // returns (amplified, gain_db)
  }
}
```

#### 2c. ⚠️ `audio_microfrontend.dart` — THE HARD PART

**Αυτό είναι το #1 risk του integration.** Το TFLite-Micro `audio_microfrontend` op (49×40 log-mel + PCAN) **δεν έχει Dart port**. Three options:

**Option C1 — Port C++ → Dart (recommended).** Source στο [tensorflow/lite/experimental/microfrontend/](https://github.com/tensorflow/tensorflow/tree/master/tensorflow/lite/experimental/microfrontend). ~500 lines πραγματικού math (FFT, mel filterbank, log compression, PCAN smoothing). Pure Dart, no FFI, no native deps. Use `package:fftea` για FFT.

**Option C2 — FFI σε prebuilt libtensorflow_microfrontend.so.** Compile static lib από TFLite-Micro repo, ship σε `android/app/src/main/jniLibs/<abi>/`. Build per ABI για Android + framework για iOS. Πιο γρήγορο runtime αλλά πολύ πιο πολύπλοκο build.

**Option C3 — Skip και retrain.** Train custom model με librosa MFCC features (controlled, easy port). Drops binary και λύνει το preprocessing risk για πάντα. **Best long-term**, αλλά out-of-scope για αυτό το ticket.

For MVP, go **C1**. Reference Python implementation: [ml_lab/src/mfcc.py](../../src/mfcc.py).

**Validation στο port:** Πάρε 1-sec audio chunk, τρέξε Python `audio_microfrontend` και Dart port. Compare 49×40 outputs **bit-exact**. Tolerance ±2 σε int8 quantized values.

#### 2d. `snore_classifier.dart`

Wrapper γύρω από `tflite_flutter`. Μέθοδοι:
- `Future<void> load()` — load `snore_cnn.tflite` από assets
- `SnorePrediction predictWindow(Float32List audioChunk)` — chunk = 15840 samples (~990ms) @ 16kHz
- `SnorePrediction` έχει `Map<String, double> probs` με keys από `pipeline_config.snore.class_index`

Class index ordering στο config: `silence=0, unknown=1, off=2, snoring=3`.

Quantization: model input είναι int8 με `(scale, zero_point)` που έρχονται από `Interpreter.getInputTensors()[0].params`. Dequantize output με ίδιο τρόπο.

Reference: [ml_lab/src/snore.py](../../src/snore.py).

#### 2e. `vad_classifier.dart`

Wrapper γύρω από `onnxruntime` package. Silero v5 stateful — **MUST manage state** μεταξύ chunks:

```dart
class VadClassifier {
  late OrtSession _session;
  Float32List _state = Float32List(2 * 1 * 128);  // shape (2,1,128) flattened, init με zeros
  static const int FRAME_SAMPLES = 512;

  Future<double> processChunk(Float32List chunk) async {
    assert(chunk.length == FRAME_SAMPLES);
    final outputs = await _session.runAsync({
      'input': OrtValueTensor.createTensorWithDataList(chunk, [1, 512]),
      'state': OrtValueTensor.createTensorWithDataList(_state, [2, 1, 128]),
      'sr': OrtValueTensor.createTensorWithDataList(Int64List.fromList([16000]), []),
    });
    _state = outputs['stateN']!.value as Float32List;  // update for next call
    return (outputs['output']!.value as Float32List)[0];
  }

  void resetState() => _state.fillRange(0, _state.length, 0.0);
}
```

⚠️ **Validate** ότι το output ταιριάζει με την Python `silero_vad` library σε ένα γνωστό WAV file. Αν δεν ταιριάζει, υπάρχει state management bug.

Reference: [ml_lab/src/vad.py](../../src/vad.py).

#### 2f. `decision_engine.dart`

Hysteresis state machine + event grouping. Pure logic, no models. Port από [ml_lab/src/decision.py](../../src/decision.py).

```dart
class DecisionEngine {
  final PipelineConfig config;
  bool _inSnoreEvent = false;
  bool _inTalkEvent = false;
  // ... per-class state for hysteresis

  /// Per 200ms tick. Returns event start/end transitions.
  DecisionTick tick({required double snoreProb, required double voiceProb, required double timeS}) {
    // priority: snore_prob > snore_enter → SNORE
    // else: voice_prob > talk_enter & not snore → TALK
    // else: silence
    // hysteresis exits on snore_exit / talk_exit
  }
}
```

### Step 3: Wire to existing recording pipeline

Ο υπάρχων recorder ([sleep_recorder.dart](../../../../../../../lib/src/services/sleep_recorder.dart)) γράφει chunks σε disk ως m4a/wav. **Δύο integration approaches**:

**Approach A — Post-process recorded chunks (simpler, recommended πρώτα).**
1. Όταν `audio_event_clip_store` τελειώνει chunk, decode → 16kHz mono float32 PCM
2. Apply AGC
3. Sliding window: feed 512-sample chunks σε VAD, 990ms windows (200ms hop) σε SnoreCNN
4. Decision engine merges → events
5. Replace τη ρητά rule-based classification που υπάρχει ήδη στο [sleep_event_analyzer.dart](../../../../../../../lib/src/services/sleep_event_analyzer.dart)

**Approach B — Streaming inference during recording (Phase 2).**
- Direct PCM stream από flutter_sound (όχι file write). Πιο αποδοτικό αλλά απαιτεί custom recorder hookup. Μην το κάνεις στην πρώτη iteration.

### Step 4: Validation στο integration

**Smoke test** πριν trust-άρεις τα predictions:

1. Πάρε ένα από τα `voice_recorder_2026-05-08_*.m4a` files από το main project's `ml_lab/data/raw/`
2. Τρέξε το Flutter pipeline σε αυτό το αρχείο (debug-only loader αν χρειάζεται)
3. Compare τα predicted events με αυτά στο [ml_lab/data/validation_report.json](../../data/validation_report.json)
4. **Pass criterion:** event timestamps ίδιες ±200ms, class labels match σε ≥90% των windows.
5. Αν αποτυγχάνει: το preprocessing port έχει bug — κυρίως `AudioMicrofrontend`.

## pipeline_config.json — contract reference

Όλα τα hyperparameters είναι εκεί. **Treat ως single source of truth** — μην hardcode-άρεις τιμές.

| Section | Key | Value | Notes |
|---|---|---|---|
| `mfcc` | `sample_rate` | 16000 | |
| `mfcc` | `window_size_ms` | 30 | |
| `mfcc` | `window_step_ms` | 20 | |
| `mfcc` | `num_channels` | 40 | mel filterbank channels |
| `mfcc` | `num_frames` | 49 | |
| `mfcc` | `lower_band_limit_hz` | 125.0 | |
| `mfcc` | `upper_band_limit_hz` | 7500.0 | |
| `mfcc` | `enable_pcan` | true | per-channel auto normalization |
| `mfcc` | `feature_size` | 1960 | 49×40 flattened |
| `mfcc` | `expected_audio_samples` | 15840 | input PCM size |
| `vad` | `threshold` | 0.3 | tuned για quiet recordings |
| `vad` | `min_speech_ms` | 200 | |
| `vad` | `min_silence_ms` | 100 | |
| `vad` | `speech_pad_ms` | 200 | |
| `snore.class_index` | snoring | 3 | output index |
| `snore` | `default_hop_seconds` | 0.2 | sliding window hop |
| `snore` | `window_samples` | 15840 | |
| `decision` | `snore_enter_threshold` | 0.4 | |
| `decision` | `snore_exit_threshold` | 0.25 | hysteresis |
| `decision` | `talk_enter_threshold` | 0.5 | |
| `decision` | `talk_exit_threshold` | 0.3 | |
| `decision` | `min_snore_duration_seconds` | 0.4 | |
| `decision` | `min_talk_duration_seconds` | 0.5 | |
| `decision` | `merge_gap_snore_seconds` | 1.5 | |
| `decision` | `merge_gap_talk_seconds` | 1.5 | |
| `decision` | `decision_grid_seconds` | 0.2 | tick rate |
| `decision` | `snore_wins_on_conflict` | true | |

## Current accuracy (validated 2026-05-09)

Frame-based metric (per 200ms tick) σε rec2-rec5:

| Class | Precision | Recall | F1 |
|---|---|---|---|
| **snore** | 0.61 | 0.35 | 0.45 |
| **talk** | 0.53 | 0.07 | 0.13 |

**Implications:**
- Όταν το model βγάζει "snore", είναι ~60% σωστό. Καλύτερο από rule-based αλλά όχι production-ready.
- Πιάνει μόνο 35% των snore-active seconds — αρκετά missed.
- Talk detection είναι πρακτικά αδύναμο σε αυτές τις low-level recordings — Silero conservative.

**Δες full report:** [ml_lab/data/validation_report.json](../../data/validation_report.json) και [ml_lab/FINDINGS.md](../../FINDINGS.md).

## Recommended UX given current accuracy

1. Tag το feature ως **"Beta detection"** στο UI ώστε ο user να ξέρει ότι είναι imperfect
2. Δείξε confidence score per event (από `event.confidence`)
3. Επίτρεψε σε user να **διορθώνει** events (snore → talk, delete, merge) — αυτή η human-in-the-loop labeling γίνεται training data για επόμενο retrain
4. Μην εμφανίζεις aggregate stats τύπου "you snored X times" — οι αριθμοί δεν είναι αξιόπιστοι ακόμη

## Roadmap μετά το ship

- **Short-term:** AGC tuning per-environment, lower talk threshold further
- **Medium-term:** Retrain custom model με librosa MFCC + user-corrected labels — drops ML payload σε ~2 MB και βελτιώνει accuracy στο user's mic profile (Option C3 παραπάνω)
- **Long-term:** Replace adrianagaler model, possibly drop Silero για unified single-model approach

## License notice

`snore_cnn.tflite` (adrianagaler) repo δεν έχει LICENSE file → "all rights reserved" by default. Πριν production ship:
- Open GitHub issue στην Adriana Rotaru για license confirmation, ή
- Retrain στο public Kaggle Snoring Dataset (~30 min CPU, ίδια `tiny_conv` recipe)

## Where to ask questions

- Validation lab: [ml_lab/](../..)
- Original recordings + labels: [ml_lab/data/](../../data)
- Findings + numbers: [FINDINGS.md](../../FINDINGS.md), [data/validation_report.json](../../data/validation_report.json)
- Stochasm doc that drove design choices: στο chat history (call `/stochasm` τις ίδιες παραδοχές)
