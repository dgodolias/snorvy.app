# ML Pipeline Bug Log

Κάθε bug που μας έχει «δαγκώσει» στην integration του Silero-VAD + adrianagaler tiny_conv pipeline. Όταν το ML αρχίσει να συμπεριφέρεται περίεργα, **ξεκινά από τα symptoms εδώ πριν ψάξεις από την αρχή**.

Σειρά: από το πιο πρόσφατο προς το παλαιότερο.

| # | Symptom | Root cause | Fix commit | Verify |
|---|---|---|---|---|
| 9 | Καθαρό talk με Silero voice peaks 0.99+ (28 frames > 0.7) **δεν** γίνεται talk event | Voice timeline σε 32ms hop (Silero) → linear interp στο 200ms decision grid → narrow ~500ms spike smoothed σε ~0.4 ticks → δεν περνά το `talk_enter=0.7` σε 3+ συνεχόμενα ticks. Snore suppression δούλευε (raw scan), αλλά talk hysteresis ακόμα έβλεπε smoothed signal. | `ffcf89b` | Replace voice resampling με max-pooling: κάθε grid tick = max όλων των Silero frames στο ±100ms window. Verify με recording όπου ομιλείς σε ένα window — talk event με conf > 0.9 πρέπει να εμφανιστεί. |
| 8 | Snore suppression δεν ενεργοποιείται ακόμα κι αν Silero βγάζει 0.73 voice spike | Linear interpolation στο 200ms decision grid σκότωνε ένα narrow 32ms voice frame (0.73 → 0.36 μετά interp). Suppression mask δεν περνούσε ποτέ το threshold. | `2afb00c` | `_voiceContextFromRaw` σκανάρει raw timestamps απευθείας. Debug JSON `voice.probs` σε raw 32ms hop πρέπει να έχει >0.5 ticks, και τα γύρω 200ms grid ticks πρέπει να μαρκάρονται suppressed. |
| 7 | Talks γίνονται snore γιατί snore CNN πατάει στις παύσεις λέξεων | `snore_wins_on_conflict=true` επέτρεπε στο snore να καπελώνει σωστές voice detections. | `1907786` | Recording με ομιλία: voice mean ~0.5+ → talk events fire, snore suppressed σε ±2s rolling max ≥ 0.5. |
| 6 | Silero voice prob max=0.12 σε δικά μας audio, max=1.00 με PyPI wrapper σε **ίδιο model file** | PyPI silero_vad's OnnxWrapper προσθέτει 64 samples audio context μπροστά από κάθε 512-sample frame: `x = torch.cat([self._context, x], dim=1)`. ONNX input shape είναι (1, 576), όχι (1, 512). Χωρίς το context το model βλέπει zeros ως ιστορία και ποτέ δεν warm up. | `4a7b661` | `lib/src/services/ml/vad_classifier.dart` πρέπει να έχει `_context = Float32List(64)`, prepended πριν κάθε `OrtValueTensor.createTensorWithDataList` με shape `[1, 576]`, και update στο τέλος του `processChunk` με τα τελευταία 64 samples του chunk. |
| 5 | ML event correctly tagged snore αλλά ξαφνικά γίνεται talk στο UI | `WavAudioEventKindRefiner.refine()` έχει heuristic (`activeZeroCrossingRate >= 1300`) που πετυχαίνει για το dB-based analyzer, αλλά **αναποδογυρίζει σωστές ML decisions**. 100% των ML events flipping σε ένα run. | `e1e2494` | `audio_event_clip_store.dart` δεν τρέχει refiner όταν `event.source == AnalyzerSource.ml`. Logcat: `[Refiner] flipped X/Y events` πρέπει να αναφέρει 0 για ml-source events. |
| 4 | Snore probs uniform 0.25 για ΟΛΑ τα windows σε όλα τα recordings, ασχέτως input | `tflite_flutter`'s `Tensor.copyTo` γράφει στο **List instance που του περνάμε**, όχι στον underlying Int8List buffer. Παλιό code: `output.buffer.asInt8List().reshape([1,4])` δημιουργεί νέα nested list. Tflite γράφει εκεί, εμείς διαβάζουμε από το αρχικό zeroed buffer. Όλες τιμές = 0 → dequant = 0.5 → softmax 0.25 ανά class. | `9770f6c` | `snore_classifier.dart` πρέπει να έχει `final outputList = List<List<int>>.generate(...)` ως variable και μετά `_interpreter.run(inputList, outputList)`, να διαβάζει από `outputList[0]`. |
| 3 | Snore class index λάθος. Έβαλα `snoring=3` με βάση speech_commands convention, αλλά: για Kaggle public snore samples idx 1 wins 9/13 times (mean 0.64 vs idx 3 = 0.28). | adrianagaler trained με non-standard label declaration order. summary.md λίστα `snoring, off, silence, unknown` **δεν** σημαίνει που μπαίνει το silence. Verified empirically: `snoring=1, off=2, silence=0, unknown=3`. idx 0 ποτέ δεν fires (no silence training). | `91840b4` | `assets/ml/pipeline_config.json` `class_index` πρέπει να είναι `{silence:0, snoring:1, off:2, unknown:3}`. Canary `assets/ml/canary_snore.wav` (Kaggle 1_300) πρέπει να δίνει `probs['snoring'] >= 0.5`. |
| 2 | ML pipeline never ran — όλα τα events έβγαιναν από rule-based fallback. Logcat: `Unable to load asset: "ml/snore_cnn.tflite"`. | `tflite_flutter ≥0.12.1` καλεί `rootBundle.load(assetName)` χωρίς auto-prefix. Το παλιό code στρι πάνε `.replaceFirst('assets/', '')` πριν περάσει στο `Interpreter.fromAsset()`, οπότε το lookup ήταν για `ml/snore_cnn.tflite` αντί `assets/ml/snore_cnn.tflite`. Model load αποτύγχανε σιωπηλά → fallback. | `c58d7f6` | `snore_classifier.dart` περνάει το full asset path με `assets/` prefix στο `Interpreter.fromAsset()`. `_loadFailed` πρέπει να μένει false. Logcat: `[MlAnalyzer] ML pipeline ready (canary OK)`. |
| 1 | Pure-Dart microfrontend port έβγαζε όλα τα features στο [-2, 5] range, με quantized όλα στο int8 floor [-128, -82]. Snore CNN επέστρεφε πάντα "unknown" 91%. | Old Dart port χρησιμοποιούσε `math.log(x)` (natural log). TFLite-Micro C source χρησιμοποιεί `log2(x) << scale_shift` (=64). Διαφορά scale 30x. Το παλιό approximate port αντικαταστάθηκε με FFI σε vendored C source. | `71c5926` (FFI) + αντικατέστησε όλο το `audio_microfrontend.dart` body | `[Microfrontend] first call: out_max=621, out_mean=275` (≈ Python TF). |

## Side fixes (hardening, όχι bugs)

- **Canary self-test** στο `_load()` ([ml_sleep_event_analyzer.dart](../lib/src/services/ml/ml_sleep_event_analyzer.dart)): silence/noise/VAD canary + bundled real-snore canary. Bail σε fallback αν fail. (`ba324cb` + `91840b4`)
- **`AnalyzerSource` tag**: κάθε event ταγκάρεται ml/ruleBased ώστε να ξέρουμε ποιος pipeline έβγαλε τι. (`ba324cb`)
- **VAD output extraction by length**: αντικατάσταση εύθραυστου `prob == 0.0` heuristic. (`ba324cb`)
- **`min_snore_duration: 1.0s` πέταγε όλα τα snore events**: real snores είναι 200-600ms bursts. Reduced to 0.4s. (`cf6f3e3`)
- **Decision engine + AGC + thresholds**: τυχαία tuning στο pipeline_config.json. Παρακολούθησε στο debug JSON.

## Validation tools

- **Bundled real-snore canary**: `assets/ml/canary_snore.wav` (Kaggle 1_300). Φορτώνεται στο app startup. Αν fail → drops to fallback.
- **Debug JSON dump**: σε `kDebugMode`, ο analyzer γράφει `app_flutter/recordings/ml_debug/<chunk>_ml_debug.json` με snore_probs[], voice_probs[], decisions[]. Pull μέσω adb και τρέξε στο `ml_lab/scripts/`.
- **Python lab parity**: `ml_lab/src/snore.py` + `ml_lab/src/vad.py` + `ml_lab/src/decision.py` τρέχουν ίδιο pipeline σε Python. Verified bit-exact (Pearson 1.0) με Dart pipeline στις 2026-05-09.

## Πώς να αποφύγεις το επόμενο silent failure

1. **Πρώτη ένδειξη ότι κάτι σπάει**: pull το πιο πρόσφατο `app_flutter/recordings/ml_debug/<chunk>_ml_debug.json` και ψάξε:
   - **Snore mean = 0.25 ή 0.5 ακριβώς** → output aliasing / class index swap
   - **Snore + Voice = 0 παντού** → ML didn't load, ψάξε `ML disabled` στο logcat
   - **Snore varies, Voice stuck < 0.2** → Silero context prefix bug (Bug #6)
   - **Voice peaks > 0.7 αλλά no talk events** → resampling smoothing (Bug #9)
   - **Voice spike high αλλά snore γίνεται event μέσα του** → suppression mask resampling (Bug #8)
2. **Πάντα τρέξε `[Microfrontend] first call:`** log line. Αν `out_max < 100`, μicrofrontend has issue (όχι log2*64).
3. **Πάντα τρέξε canary**. Αν `[MlAnalyzer] ML disabled, falling back: <reason>` εμφανιστεί, ξεκίνα από εκεί.
4. **Αν `[Refiner] flipped > 0/N` για ml-source events** → bug στο refiner gating.
5. **Αν resampling παίζει ρόλο** (αλλάζεις decision grid, hop, threshold): πάντα verify στα RAW probs, όχι στα grid-resampled. Bugs #8 και #9 ήταν αυτό ακριβώς το pattern δύο φορές.

## Καθολικός κανόνας

**Οποιοδήποτε νέο knob στο pipeline_config.json πρέπει να επιβεβαιωθεί με Python lab parity πριν ship.** Αλλιώς θα ξανακάνουμε class-index swap σε λάθος convention κλπ.
