import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:snorvy/src/services/ml/audio_microfrontend.dart';
import 'package:snorvy/src/services/ml/pipeline_config.dart';

class SnorePrediction {
  const SnorePrediction({required this.probabilities, required this.snoring});
  final Map<String, double> probabilities;
  final double snoring;
}

/// Wraps the adrianagaler tiny_conv TFLite model (int8 quantized).
/// Input: (1, 1960) int8 = 49x40 log-mel features.
/// Output: (1, 4) int8 softmax → [silence, unknown, off, snoring].
class SnoreClassifier {
  SnoreClassifier._(
    this._interpreter,
    this._microfrontend,
    this.config,
    this._inScale,
    this._inZero,
    this._outScale,
    this._outZero,
  );

  final Interpreter _interpreter;
  final AudioMicrofrontend _microfrontend;
  final SnoreConfig config;
  final double _inScale;
  final int _inZero;
  final double _outScale;
  final int _outZero;
  bool _disposed = false;

  static Future<SnoreClassifier> load(
    PipelineConfig pipelineConfig, {
    String? customAssetPath,
  }) async {
    // tflite_flutter ≥0.12 calls rootBundle.load(assetName) without auto-
    // prefixing; pass the full bundle path including the 'assets/' prefix.
    final assetPath = customAssetPath ?? pipelineConfig.snoreModelAsset;
    final interpreter = await Interpreter.fromAsset(assetPath);
    interpreter.allocateTensors();
    final inputTensor = interpreter.getInputTensors().first;
    final outputTensor = interpreter.getOutputTensors().first;
    final mfcc = pipelineConfig.mfcc;
    final microfrontend = AudioMicrofrontend(
      sampleRate: mfcc.sampleRate,
      windowSizeMs: mfcc.windowSizeMs,
      windowStepMs: mfcc.windowStepMs,
      numMelChannels: mfcc.numChannels,
      numFrames: mfcc.numFrames,
      lowerBandLimitHz: mfcc.lowerBandLimitHz,
      upperBandLimitHz: mfcc.upperBandLimitHz,
      enablePcan: mfcc.enablePcan,
      enableLog: mfcc.enableLog,
    );
    return SnoreClassifier._(
      interpreter,
      microfrontend,
      pipelineConfig.snore,
      inputTensor.params.scale,
      inputTensor.params.zeroPoint,
      outputTensor.params.scale,
      outputTensor.params.zeroPoint,
    );
  }

  /// Run the snore CNN on a single 990ms / 15840-sample window.
  SnorePrediction predictWindow(Float32List audioChunk) {
    if (_disposed) {
      throw StateError('SnoreClassifier already disposed');
    }
    final features = _microfrontend.computeFlat(audioChunk);
    final input = _microfrontend.quantize(features, _inScale, _inZero);
    final inputShape = [1, features.length];
    final outputShape = [1, config.classIndex.length];
    final output = Int8List(outputShape[0] * outputShape[1]);

    _interpreter.run(
      input.buffer.asInt8List().reshape<int>(inputShape),
      output.buffer.asInt8List().reshape<int>(outputShape),
    );

    final raw = List<double>.generate(
      output.length,
      (i) => (output[i] - _outZero) * _outScale,
    );
    final clipped = raw.map((p) => p < 0 ? 0.0 : p).toList();
    final sum = clipped.fold<double>(0.0, (a, b) => a + b);
    final normalized =
        sum > 0 ? clipped.map((p) => p / sum).toList() : clipped;

    final probs = <String, double>{};
    config.classIndex.forEach((name, idx) {
      probs[name] = normalized[idx];
    });
    return SnorePrediction(
      probabilities: probs,
      snoring: probs['snoring'] ?? 0.0,
    );
  }

  /// Sliding window over a full audio buffer. Returns (timestamps_seconds,
  /// snoring_probabilities) where each timestamp is the centre of the window.
  ({List<double> timestamps, List<double> probs}) processAudio(
    Float32List audio, {
    double? hopSeconds,
  }) {
    final hop = hopSeconds ?? config.defaultHopSeconds;
    final hopSamples = (hop * _microfrontend.sampleRate).round();
    final windowSamples = config.windowSamples;
    final lastStart = audio.length >= windowSamples
        ? audio.length - windowSamples
        : 0;
    final starts = <int>[];
    for (var s = 0; s <= lastStart; s += hopSamples) {
      starts.add(s);
    }
    if (starts.isEmpty) starts.add(0);

    final timestamps = <double>[];
    final probs = <double>[];
    for (final start in starts) {
      final end = start + windowSamples;
      final chunk = end <= audio.length
          ? Float32List.sublistView(audio, start, end)
          : _padTo(audio, start, windowSamples);
      final pred = predictWindow(chunk);
      timestamps.add((start + windowSamples / 2) / _microfrontend.sampleRate);
      probs.add(pred.snoring);
    }
    return (timestamps: timestamps, probs: probs);
  }

  static Float32List _padTo(Float32List audio, int start, int length) {
    final out = Float32List(length);
    final available = audio.length - start;
    if (available > 0) {
      for (var i = 0; i < available && i < length; i++) {
        out[i] = audio[start + i];
      }
    }
    return out;
  }

  void dispose() {
    if (_disposed) return;
    _interpreter.close();
    _disposed = true;
  }
}
