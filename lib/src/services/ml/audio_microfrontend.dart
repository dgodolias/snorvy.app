import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

/// FFI wrapper γύρω από `libsnorvy_microfrontend.so`, που με τη σειρά του
/// φωτιάζει το επίσημο TFLite-Micro `audio_microfrontend` C source — bit-exact
/// με το Python `tf.lite.experimental.microfrontend`.
///
/// Παράγει (num_frames × num_channels) uint16 log-mel-PCAN features για κάθε
/// 1-sec audio chunk. Κάθε call είναι one-shot με fresh state, ταιριάζοντας
/// τη συμπεριφορά του Python ml_lab.
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
  })  : _windowSamples = (sampleRate * windowSizeMs / 1000).round(),
        _hopSamples = (sampleRate * windowStepMs / 1000).round() {
    _native = _NativeBindings.instance;
    if (_native.apiVersion() != _expectedApiVersion) {
      throw StateError(
        'snorvy_microfrontend ABI mismatch: got '
        '${_native.apiVersion()}, expected $_expectedApiVersion',
      );
    }
  }

  static const int _expectedApiVersion = 1;

  final int sampleRate;
  final int windowSizeMs;
  final int windowStepMs;
  final int numMelChannels;
  final double lowerBandLimitHz;
  final double upperBandLimitHz;
  final int numFrames;
  final bool enablePcan;
  final bool enableLog;

  final int _windowSamples;
  final int _hopSamples;
  late final _NativeBindings _native;
  static bool _loggedFirstCall = false;

  static double _int16Rms(Pointer<Int16> ptr, int n) {
    var sum = 0.0;
    for (var i = 0; i < n; i++) {
      final v = ptr[i].toDouble();
      sum += v * v;
    }
    return n == 0 ? 0.0 : math.sqrt(sum / n);
  }

  int get expectedAudioSamples =>
      _hopSamples * (numFrames - 1) + _windowSamples;

  /// Compute features for [audio] (16 kHz mono float32 in [-1, 1]) and return
  /// a flat `Float32List` of length `numFrames * numMelChannels`. The buffer
  /// is padded or truncated to exactly `expectedAudioSamples`.
  Float32List computeFlat(Float32List audio) {
    final expected = expectedAudioSamples;
    final padded = audio.length == expected
        ? audio
        : _padOrTruncate(audio, expected);

    final featureCount = numFrames * numMelChannels;
    final inPtr = calloc<Int16>(expected);
    final outPtr = calloc<Uint16>(featureCount);
    try {
      // float32 [-1, 1] → int16 PCM
      for (var i = 0; i < expected; i++) {
        final clipped = padded[i].clamp(-1.0, 1.0);
        inPtr[i] = (clipped * 32767.0).round();
      }

      final written = _native.compute(
        inPtr,
        expected,
        outPtr,
        featureCount,
        sampleRate,
        windowSizeMs,
        windowStepMs,
        numMelChannels,
        lowerBandLimitHz.round(),
        upperBandLimitHz.round(),
        enablePcan ? 1 : 0,
        enableLog ? 1 : 0,
      );
      if (written < 0) {
        throw StateError(
          'snorvy_microfrontend native call failed (code=$written)',
        );
      }

      final out = Float32List(featureCount);
      for (var i = 0; i < written && i < featureCount; i++) {
        out[i] = outPtr[i].toDouble();
      }
      // Debug: emit a one-shot summary of the first FFI call so we can see
      // whether the native side is producing real features or constant noise.
      if (!_loggedFirstCall) {
        _loggedFirstCall = true;
        // ignore: avoid_print
        print(
          '[Microfrontend] first call: written=$written/$featureCount '
          'in[0..3]=${[for (var i = 0; i < 4; i++) inPtr[i]]} '
          'in_rms=${_int16Rms(inPtr, expected).toStringAsFixed(1)} '
          'out_min=${out.reduce((a, b) => a < b ? a : b).toStringAsFixed(0)} '
          'out_max=${out.reduce((a, b) => a > b ? a : b).toStringAsFixed(0)} '
          'out_mean=${(out.reduce((a, b) => a + b) / out.length).toStringAsFixed(1)}',
        );
      }
      return out;
    } finally {
      calloc.free(inPtr);
      calloc.free(outPtr);
    }
  }

  Int8List quantize(Float32List features, double scale, int zeroPoint) {
    final out = Int8List(features.length);
    for (var i = 0; i < features.length; i++) {
      final q = (features[i] / scale + zeroPoint).round();
      out[i] = q.clamp(-128, 127);
    }
    return out;
  }

  static Float32List _padOrTruncate(Float32List audio, int expected) {
    if (audio.length == expected) return audio;
    if (audio.length > expected) {
      return Float32List.sublistView(audio, 0, expected);
    }
    final out = Float32List(expected);
    for (var i = 0; i < audio.length; i++) {
      out[i] = audio[i];
    }
    return out;
  }
}

/// Auxiliary log/exp helpers retained for legacy callers.
double log2(double value) => math.log(value) / math.ln2;

typedef _SnorvyMfApiVersion = Int32 Function();
typedef _SnorvyMfApiVersionDart = int Function();

typedef _SnorvyMfCompute = Int32 Function(
  Pointer<Int16>,
  Int32,
  Pointer<Uint16>,
  Int32,
  Int32,
  Int32,
  Int32,
  Int32,
  Int32,
  Int32,
  Int32,
  Int32,
);
typedef _SnorvyMfComputeDart = int Function(
  Pointer<Int16>,
  int,
  Pointer<Uint16>,
  int,
  int,
  int,
  int,
  int,
  int,
  int,
  int,
  int,
);

class _NativeBindings {
  _NativeBindings._() {
    final lib = _openLibrary();
    apiVersion = lib
        .lookup<NativeFunction<_SnorvyMfApiVersion>>('snorvy_mf_api_version')
        .asFunction<_SnorvyMfApiVersionDart>();
    compute = lib
        .lookup<NativeFunction<_SnorvyMfCompute>>('snorvy_mf_compute')
        .asFunction<_SnorvyMfComputeDart>();
  }

  static final instance = _NativeBindings._();

  late final _SnorvyMfApiVersionDart apiVersion;
  late final _SnorvyMfComputeDart compute;

  static DynamicLibrary _openLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libsnorvy_microfrontend.so');
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return DynamicLibrary.process();
    }
    if (Platform.isWindows) {
      return DynamicLibrary.open('snorvy_microfrontend.dll');
    }
    if (Platform.isLinux) {
      return DynamicLibrary.open('libsnorvy_microfrontend.so');
    }
    throw UnsupportedError(
      'snorvy_microfrontend not available on ${Platform.operatingSystem}',
    );
  }
}
