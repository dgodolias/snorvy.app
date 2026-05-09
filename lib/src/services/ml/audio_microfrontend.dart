import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fftea/fftea.dart';

/// Pure-Dart port of TFLite-Micro's `audio_microfrontend` op for the
/// adrianagaler tiny_conv snore model. Produces (num_frames, num_channels)
/// log-mel features with optional PCAN smoothing.
///
/// Reference: tensorflow/lite/experimental/microfrontend (C++ source).
/// The defaults below mirror what the Python ml_lab pipeline uses
/// (sample_rate=16000, window=30ms, hop=20ms, 40 mel channels, PCAN on).
///
/// **Caveat:** this port follows the published math but is not validated
/// bit-exact against the C++ implementation. Inference outputs may drift
/// from the Python validation_report.json by more than the documented
/// ±2 int8 tolerance until a parity test is added.
class AudioMicrofrontend {
  AudioMicrofrontend({
    this.sampleRate = 16000,
    this.windowSizeMs = 30,
    this.windowStepMs = 20,
    this.numMelChannels = 40,
    this.lowerBandLimitHz = 125.0,
    this.upperBandLimitHz = 7500.0,
    this.numFrames = 49,
    this.enablePcan = true,
    this.enableLog = true,
    this.pcanStrength = 0.95,
    this.pcanOffset = 80.0,
    this.pcanGainBits = 21,
    this.pcanSmoothingBits = 6,
  })  : _windowSamples = (sampleRate * windowSizeMs / 1000).round(),
        _hopSamples = (sampleRate * windowStepMs / 1000).round() {
    _fftSize = _nextPow2(_windowSamples);
    _fft = FFT(_fftSize);
    _hann = _hannWindow(_windowSamples);
    _melFilterbank = _buildMelFilterbank(
      fftSize: _fftSize,
      sampleRate: sampleRate,
      numChannels: numMelChannels,
      lower: lowerBandLimitHz,
      upper: upperBandLimitHz,
    );
    _pcanSmoothed = List<double>.filled(numMelChannels, 0.0);
    _pcanSmoothing = 1.0 - 1.0 / math.pow(2.0, pcanSmoothingBits);
  }

  final int sampleRate;
  final int windowSizeMs;
  final int windowStepMs;
  final int numMelChannels;
  final double lowerBandLimitHz;
  final double upperBandLimitHz;
  final int numFrames;
  final bool enablePcan;
  final bool enableLog;
  final double pcanStrength;
  final double pcanOffset;
  final int pcanGainBits;
  final int pcanSmoothingBits;

  final int _windowSamples;
  final int _hopSamples;
  late final int _fftSize;
  late final FFT _fft;
  late final Float64List _hann;
  late final List<List<double>> _melFilterbank;
  late final List<double> _pcanSmoothed;
  late final double _pcanSmoothing;

  /// Compute features for [audio] (16 kHz mono float32 in [-1, 1]) and return
  /// a flat `Float32List` of length `numFrames * numMelChannels`. The buffer
  /// is padded or truncated to exactly `expectedAudioSamples`.
  Float32List computeFlat(Float32List audio) {
    final expected = expectedAudioSamples;
    final padded = audio.length == expected
        ? audio
        : _padOrTruncate(audio, expected);
    _resetState();
    final out = Float32List(numFrames * numMelChannels);
    for (var frame = 0; frame < numFrames; frame++) {
      final start = frame * _hopSamples;
      final end = start + _windowSamples;
      final frameSamples = padded.sublist(start, end);
      final mel = _frameToMel(frameSamples);
      for (var c = 0; c < numMelChannels; c++) {
        out[frame * numMelChannels + c] = mel[c];
      }
    }
    return out;
  }

  int get expectedAudioSamples =>
      _hopSamples * (numFrames - 1) + _windowSamples;

  Int8List quantize(Float32List features, double scale, int zeroPoint) {
    final out = Int8List(features.length);
    for (var i = 0; i < features.length; i++) {
      final q = (features[i] / scale + zeroPoint).round();
      out[i] = q.clamp(-128, 127);
    }
    return out;
  }

  void _resetState() {
    for (var i = 0; i < _pcanSmoothed.length; i++) {
      _pcanSmoothed[i] = 0.0;
    }
  }

  List<double> _frameToMel(Float32List frame) {
    final padded = Float64List(_fftSize);
    for (var i = 0; i < frame.length; i++) {
      padded[i] = (frame[i] * 32768.0) * _hann[i];
    }
    final spectrum = _fft.realFft(padded);
    final numBins = (_fftSize ~/ 2) + 1;
    final power = List<double>.filled(numBins, 0.0);
    for (var i = 0; i < numBins; i++) {
      final c = spectrum[i];
      power[i] = c.x * c.x + c.y * c.y;
    }

    final mel = List<double>.filled(numMelChannels, 0.0);
    for (var c = 0; c < numMelChannels; c++) {
      final coeffs = _melFilterbank[c];
      var sum = 0.0;
      for (var k = 0; k < coeffs.length; k++) {
        sum += coeffs[k] * power[k];
      }
      mel[c] = sum;
    }

    if (enablePcan) {
      for (var c = 0; c < numMelChannels; c++) {
        _pcanSmoothed[c] =
            _pcanSmoothing * _pcanSmoothed[c] + (1.0 - _pcanSmoothing) * mel[c];
        final base = math.pow(_pcanSmoothed[c] + 1e-9, pcanStrength).toDouble();
        mel[c] = mel[c] / (base + pcanOffset);
      }
    }

    if (enableLog) {
      for (var c = 0; c < numMelChannels; c++) {
        mel[c] = math.log(mel[c] + 1e-9);
      }
    }

    return mel;
  }

  static Float64List _hannWindow(int size) {
    final w = Float64List(size);
    if (size == 1) {
      w[0] = 1.0;
      return w;
    }
    for (var i = 0; i < size; i++) {
      w[i] = 0.5 - 0.5 * math.cos(2 * math.pi * i / (size - 1));
    }
    return w;
  }

  static int _nextPow2(int n) {
    var p = 1;
    while (p < n) {
      p <<= 1;
    }
    return p;
  }

  static Float32List _padOrTruncate(Float32List audio, int expected) {
    if (audio.length >= expected) {
      return Float32List.sublistView(audio, 0, expected);
    }
    final out = Float32List(expected);
    for (var i = 0; i < audio.length; i++) {
      out[i] = audio[i];
    }
    return out;
  }

  static List<List<double>> _buildMelFilterbank({
    required int fftSize,
    required int sampleRate,
    required int numChannels,
    required double lower,
    required double upper,
  }) {
    final numBins = (fftSize ~/ 2) + 1;
    final melLow = _hzToMel(lower);
    final melHigh = _hzToMel(upper);
    final melPoints = List<double>.generate(
      numChannels + 2,
      (i) => melLow + (melHigh - melLow) * i / (numChannels + 1),
    );
    final hzPoints = melPoints.map(_melToHz).toList();
    final binFreqs = List<double>.generate(
      numBins,
      (i) => i * sampleRate / fftSize,
    );

    return List<List<double>>.generate(numChannels, (c) {
      final low = hzPoints[c];
      final mid = hzPoints[c + 1];
      final high = hzPoints[c + 2];
      final coeffs = List<double>.filled(numBins, 0.0);
      for (var k = 0; k < numBins; k++) {
        final f = binFreqs[k];
        if (f <= low || f >= high) continue;
        if (f <= mid) {
          coeffs[k] = (f - low) / (mid - low);
        } else {
          coeffs[k] = (high - f) / (high - mid);
        }
      }
      return coeffs;
    });
  }

  static double _hzToMel(double hz) => 1127.0 * math.log(1.0 + hz / 700.0);
  static double _melToHz(double mel) => 700.0 * (math.exp(mel / 1127.0) - 1.0);
}
