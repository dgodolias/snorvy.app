import 'dart:math' as math;
import 'dart:typed_data';

class AudioAgcResult {
  const AudioAgcResult(this.audio, this.appliedGainDb);
  final Float32List audio;
  final double appliedGainDb;
}

class AudioAgc {
  static const double targetDbfs = -20.0;
  static const double peakHeadroomDbfs = -1.0;
  static const double maxGainDb = 40.0;

  static AudioAgcResult apply(Float32List audio) {
    if (audio.isEmpty) return AudioAgcResult(audio, 0.0);

    var sumSq = 0.0;
    var peak = 0.0;
    for (var i = 0; i < audio.length; i++) {
      final v = audio[i];
      sumSq += v * v;
      final a = v.abs();
      if (a > peak) peak = a;
    }
    final rms = math.sqrt(sumSq / audio.length);
    if (rms < 1e-8 || peak < 1e-8) return AudioAgcResult(audio, 0.0);

    final targetRms = math.pow(10.0, targetDbfs / 20.0).toDouble();
    final peakLimit = math.pow(10.0, peakHeadroomDbfs / 20.0).toDouble();
    final maxGain = math.pow(10.0, maxGainDb / 20.0).toDouble();

    var gain = math.min(targetRms / rms, peakLimit / peak);
    gain = math.min(gain, maxGain);
    if (gain < 1.0) return AudioAgcResult(audio, 0.0);

    final amplified = Float32List(audio.length);
    for (var i = 0; i < audio.length; i++) {
      amplified[i] = audio[i] * gain;
    }
    return AudioAgcResult(amplified, 20.0 * (math.log(gain) / math.ln10));
  }
}
