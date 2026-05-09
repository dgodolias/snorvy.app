import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/ml/audio_agc.dart';
import 'package:snorvy/src/services/ml/decision_engine.dart';
import 'package:snorvy/src/services/ml/pipeline_config.dart';
import 'package:snorvy/src/services/ml/snore_classifier.dart';
import 'package:snorvy/src/services/ml/vad_classifier.dart';
import 'package:snorvy/src/services/ml/wav_reader.dart';
import 'package:snorvy/src/services/sleep_event_analyzer.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';

/// SleepEventAnalyzer powered by the ml_lab pipeline (Silero VAD + tiny_conv
/// snore CNN). Reads the recorded WAV chunk from disk, runs the parallel
/// decision matrix, and emits AnalyzedSleepEvents.
class MlSleepEventAnalyzer implements SleepEventAnalyzer {
  MlSleepEventAnalyzer({
    SleepEventAnalyzer? fallbackAnalyzer,
    PipelineConfig? config,
    SnoreClassifier? snoreClassifier,
    VadClassifier? vadClassifier,
  })  : _fallback = fallbackAnalyzer,
        _config = config,
        _snore = snoreClassifier,
        _vad = vadClassifier;

  final SleepEventAnalyzer? _fallback;
  PipelineConfig? _config;
  SnoreClassifier? _snore;
  VadClassifier? _vad;
  Future<void>? _loading;
  bool _loadFailed = false;

  Future<void> _ensureLoaded() {
    if (_snore != null && _vad != null) return Future.value();
    if (_loadFailed) return Future.value();
    return _loading ??= _load();
  }

  Future<void> _load() async {
    try {
      _config ??= await PipelineConfig.loadFromAssets();
      _snore ??= await SnoreClassifier.load(_config!);
      _vad ??= await VadClassifier.load(_config!);
      // Canary self-test: every silent failure we hit (asset path, output
      // aliasing, class index swap) would have been caught here. Bail to
      // fallback if any check fails.
      final canaryError = await _runCanary(_snore!, _vad!);
      if (canaryError != null) {
        throw StateError('canary failed: $canaryError');
      }
      // ignore: avoid_print
      print('[MlAnalyzer] ML pipeline ready (canary OK)');
    } on Object catch (error, stack) {
      _loadFailed = true;
      _config = null;
      _snore?.dispose();
      _snore = null;
      _vad?.dispose();
      _vad = null;
      // ignore: avoid_print
      print('[MlAnalyzer] ML disabled, falling back to rule-based: $error');
      if (kDebugMode) {
        debugPrint(stack.toString());
      }
    }
  }

  /// Synthetic canary: feed two known signals through the full pipeline and
  /// assert the model output looks structurally correct. This catches:
  ///   - missing assets (model file not in bundle)
  ///   - output-buffer aliasing (every class lands at uniform 0.25)
  ///   - class index swaps (silence audio firing the wrong slot)
  ///   - microfrontend / FFI breakage (constant features)
  /// Returns null on success, an error reason on failure.
  Future<String?> _runCanary(SnoreClassifier snore, VadClassifier vad) async {
    const windowSamples = 15840; // 990 ms at 16 kHz

    // Test 1 — silence input must NOT classify as snore. We don't pin which
    // non-snore class wins (the Kaggle-trained model can drift between
    // silence/unknown/off on pure-zero input) but pinning snore<0.5 catches
    // the class-index swap we hit before, where talks/silence were firing the
    // slot we read as "snoring".
    final silence = Float32List(windowSamples);
    final silenceProbs = snore.predictWindow(silence).probabilities;
    final silenceSnore = silenceProbs['snoring'] ?? 0.0;
    if (silenceSnore > 0.5) {
      return 'silence canary: snore=$silenceSnore probs=$silenceProbs';
    }

    // Test 2 — non-uniform output: noisy input must NOT produce uniform 0.25
    // across the four classes. (That was the output-aliasing symptom.)
    final noise = Float32List(windowSamples);
    final rng = math.Random(0xc0ffee);
    for (var i = 0; i < windowSamples; i++) {
      noise[i] = (rng.nextDouble() - 0.5) * 0.5;
    }
    final noisePred = snore.predictWindow(noise);
    final spread =
        noisePred.probabilities.values.fold<double>(0.0, math.max) -
            noisePred.probabilities.values.fold<double>(1.0, math.min);
    if (spread < 0.05) {
      return 'noise canary: uniform output (spread=$spread, probs=${noisePred.probabilities})';
    }

    // Test 3 — VAD on silence must report no speech.
    final vadProb = vad.processChunk(Float32List(VadClassifier.frameSamples));
    if (vadProb > 0.5) {
      return 'vad silence canary: prob=$vadProb';
    }
    vad.resetState();
    return null;
  }

  @override
  Future<SleepAnalysisResult> analyzeFrames({
    required List<RecordingPowerFrame> frames,
    required DateTime startedAt,
    required DateTime endedAt,
    required String recordingPath,
  }) async {
    await _ensureLoaded();
    if (_loadFailed || _config == null || _snore == null || _vad == null) {
      return _fallback?.analyzeFrames(
            frames: frames,
            startedAt: startedAt,
            endedAt: endedAt,
            recordingPath: recordingPath,
          ) ??
          SleepAnalysisResult.empty;
    }

    final config = _config!;
    final snore = _snore!;
    final vad = _vad!;

    Float32List samples;
    try {
      final wav = await WavReader.readMono16(File(recordingPath));
      if (wav.sampleRate != config.mfcc.sampleRate) {
        if (kDebugMode) {
          debugPrint(
            '[MlAnalyzer] sample rate mismatch ${wav.sampleRate} vs '
            '${config.mfcc.sampleRate} - falling back',
          );
        }
        return _fallback?.analyzeFrames(
              frames: frames,
              startedAt: startedAt,
              endedAt: endedAt,
              recordingPath: recordingPath,
            ) ??
            SleepAnalysisResult.empty;
      }
      samples = wav.samples;
    } on FileSystemException catch (error) {
      if (kDebugMode) {
        debugPrint('[MlAnalyzer] cannot read $recordingPath: $error');
      }
      return SleepAnalysisResult.empty;
    } on FormatException catch (error) {
      if (kDebugMode) {
        debugPrint('[MlAnalyzer] WAV parse failed for $recordingPath: $error');
      }
      return _fallback?.analyzeFrames(
            frames: frames,
            startedAt: startedAt,
            endedAt: endedAt,
            recordingPath: recordingPath,
          ) ??
          SleepAnalysisResult.empty;
    }

    if (samples.isEmpty) return SleepAnalysisResult.empty;

    final agc = AudioAgc.apply(samples);
    final amplified = agc.audio;
    final durationSeconds = amplified.length / config.mfcc.sampleRate;

    final snoreOut = snore.processAudio(amplified);
    final vadOut = vad.processAudio(
      amplified,
      sampleRate: config.mfcc.sampleRate,
    );

    final engine = DecisionEngine(config.decision);
    final decisions = engine.combine(
      snoreTimestamps: snoreOut.timestamps,
      snoreProbs: snoreOut.probs,
      voiceTimestamps: vadOut.timestamps,
      voiceProbs: vadOut.probs,
      durationSeconds: durationSeconds,
    );

    final events = <AnalyzedSleepEvent>[];
    for (final dec in decisions) {
      final kind = dec.label == 'snore'
          ? SleepEventKind.snore
          : dec.label == 'talk'
              ? SleepEventKind.talk
              : SleepEventKind.noise;
      events.add(
        AnalyzedSleepEvent(
          kind: kind,
          startsAt: startedAt.add(
            Duration(milliseconds: (dec.startSeconds * 1000).round()),
          ),
          duration: Duration(
            milliseconds: (dec.durationSeconds * 1000).round(),
          ),
          intensity: (dec.confidence.clamp(0.0, 1.0) * 100).round().clamp(
            12,
            100,
          ),
          filePath: recordingPath,
          source: AnalyzerSource.ml,
        ),
      );
    }

    final snoreScore = events
        .where((e) => e.kind == SleepEventKind.snore)
        .length;

    // Debug: dump probs + events σε JSON για bit-exact comparison με Python lab.
    // Triggered only in debug builds; lives next to the WAV chunk so you can
    // pull both with one adb pull.
    if (kDebugMode) {
      try {
        final docs = await getApplicationDocumentsDirectory();
        final dumpDir = Directory(p.join(docs.path, 'recordings', 'ml_debug'));
        if (!await dumpDir.exists()) {
          await dumpDir.create(recursive: true);
        }
        final stem = p.basenameWithoutExtension(recordingPath);
        final dumpPath = p.join(dumpDir.path, '${stem}_ml_debug.json');
        final payload = <String, dynamic>{
          'chunk': p.basename(recordingPath),
          'duration_s': durationSeconds,
          'agc_gain_db': agc.appliedGainDb,
          'snore': {
            'timestamps': snoreOut.timestamps,
            'probs': snoreOut.probs,
          },
          'voice': {
            'timestamps': vadOut.timestamps,
            'probs': vadOut.probs,
          },
          'decisions': decisions
              .map((d) => {
                    'start': d.startSeconds,
                    'end': d.endSeconds,
                    'label': d.label,
                    'confidence': d.confidence,
                  })
              .toList(),
        };
        await File(dumpPath).writeAsString(jsonEncode(payload), flush: true);
      } on Object catch (error) {
        debugPrint('[MlAnalyzer] debug dump failed: $error');
      }
      debugPrint(
        '[MlAnalyzer] chunk=${recordingPath.split('/').last} '
        'gain=${agc.appliedGainDb.toStringAsFixed(1)}dB '
        'snore_windows=${snoreOut.probs.length} '
        'vad_frames=${vadOut.probs.length} events=${events.length}',
      );
    }
    return SleepAnalysisResult(snoreScore: snoreScore, events: events);
  }

  void dispose() {
    _snore?.dispose();
    _vad?.dispose();
  }
}
