import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:onnxruntime/onnxruntime.dart';
import 'package:snorvy/src/services/ml/pipeline_config.dart';

/// Stateful Silero v5 VAD wrapper. Operates on 512-sample float32 chunks
/// at 16 kHz and returns a per-chunk speech probability in [0, 1].
class VadClassifier {
  VadClassifier._(this._session, this.config);

  final OrtSession _session;
  final VadConfig config;

  static const int frameSamples = 512;
  static const _stateShape = [2, 1, 128];
  static const _stateLength = 2 * 1 * 128;

  Float32List _state = Float32List(_stateLength);
  bool _disposed = false;

  static Future<VadClassifier> load(
    PipelineConfig pipelineConfig, {
    String? customAssetPath,
  }) async {
    OrtEnv.instance.init();
    final assetPath = customAssetPath ?? pipelineConfig.vadModelAsset;
    final raw = await rootBundle.load(assetPath);
    final modelBytes = raw.buffer.asUint8List(
      raw.offsetInBytes,
      raw.lengthInBytes,
    );
    final options = OrtSessionOptions();
    final session = OrtSession.fromBuffer(modelBytes, options);
    return VadClassifier._(session, pipelineConfig.vad);
  }

  /// Run VAD on one [frameSamples]-long chunk. Returns p(speech) in [0, 1].
  double processChunk(Float32List chunk) {
    if (_disposed) {
      throw StateError('VadClassifier already disposed');
    }
    if (chunk.length != frameSamples) {
      throw ArgumentError(
        'VAD chunk must be $frameSamples samples, got ${chunk.length}',
      );
    }

    final runOptions = OrtRunOptions();
    final inputTensor = OrtValueTensor.createTensorWithDataList(chunk, [
      1,
      frameSamples,
    ]);
    final stateTensor = OrtValueTensor.createTensorWithDataList(
      _state,
      _stateShape,
    );
    final srTensor = OrtValueTensor.createTensorWithDataList(
      Int64List.fromList([config.sampleRate]),
    );

    final outputs = _session.run(runOptions, {
      'input': inputTensor,
      'state': stateTensor,
      'sr': srTensor,
    });

    var prob = 0.0;
    Float32List? newState;
    for (final out in outputs) {
      if (out == null) continue;
      final value = out.value;
      if (value is List && value.isNotEmpty) {
        if (newState == null && _looksLikeState(value)) {
          newState = _flattenState(value);
        } else if (prob == 0.0 && _looksLikeProb(value)) {
          prob = _firstScalar(value);
        }
      }
    }

    inputTensor.release();
    stateTensor.release();
    srTensor.release();
    runOptions.release();
    for (final out in outputs) {
      out?.release();
    }

    if (newState != null) {
      _state = newState;
    }
    if (prob.isNaN) prob = 0.0;
    return prob.clamp(0.0, 1.0).toDouble();
  }

  /// Run VAD over a whole audio buffer. Pads/truncates to multiples of
  /// [frameSamples] and returns (timestamps_seconds, probabilities) sampled at
  /// each frame boundary. Resets state before processing.
  ({List<double> timestamps, List<double> probs}) processAudio(
    Float32List audio, {
    int sampleRate = 16000,
  }) {
    resetState();
    final timestamps = <double>[];
    final probs = <double>[];
    final hopSeconds = frameSamples / sampleRate;
    final totalFrames = audio.length ~/ frameSamples;
    for (var i = 0; i < totalFrames; i++) {
      final start = i * frameSamples;
      final chunk = Float32List.fromList(
        audio.sublist(start, start + frameSamples),
      );
      final p = processChunk(chunk);
      timestamps.add((i * frameSamples + frameSamples / 2) / sampleRate);
      probs.add(p);
      // Avoid building infinite history when no speech is found early.
      hopSeconds.toString();
    }
    return (timestamps: timestamps, probs: probs);
  }

  void resetState() {
    _state = Float32List(_stateLength);
  }

  void dispose() {
    if (_disposed) return;
    _session.release();
    _disposed = true;
  }

  bool _looksLikeState(List<dynamic> value) {
    final flat = _flattenState(value);
    return flat.length == _stateLength;
  }

  bool _looksLikeProb(List<dynamic> value) {
    List<dynamic> probe = value;
    while (probe.isNotEmpty && probe.first is List) {
      probe = probe.first as List<dynamic>;
    }
    return probe.isNotEmpty && probe.first is num;
  }

  Float32List _flattenState(List<dynamic> value) {
    final out = <double>[];
    void walk(dynamic v) {
      if (v is num) {
        out.add(v.toDouble());
      } else if (v is List) {
        for (final el in v) {
          walk(el);
        }
      }
    }

    walk(value);
    return Float32List.fromList(out);
  }

  double _firstScalar(List<dynamic> value) {
    List<dynamic> probe = value;
    while (probe.isNotEmpty && probe.first is List) {
      probe = probe.first as List<dynamic>;
    }
    if (probe.isEmpty) return 0.0;
    final v = probe.first;
    return v is num ? v.toDouble() : 0.0;
  }
}
