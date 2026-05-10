import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class PipelineConfig {
  const PipelineConfig({
    required this.mfcc,
    required this.vad,
    required this.snore,
    required this.decision,
    required this.snoreModelAsset,
    required this.vadModelAsset,
  });

  final MfccConfig mfcc;
  final VadConfig vad;
  final SnoreConfig snore;
  final DecisionConfig decision;
  final String snoreModelAsset;
  final String vadModelAsset;

  static Future<PipelineConfig> loadFromAssets({
    String configAsset = 'assets/ml/pipeline_config.json',
    String mlAssetDir = 'assets/ml',
  }) async {
    final raw = await rootBundle.loadString(configAsset);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final models = json['models'] as Map<String, dynamic>;
    return PipelineConfig(
      mfcc: MfccConfig.fromJson(json['mfcc'] as Map<String, dynamic>),
      vad: VadConfig.fromJson(json['vad'] as Map<String, dynamic>),
      snore: SnoreConfig.fromJson(json['snore'] as Map<String, dynamic>),
      decision: DecisionConfig.fromJson(
        json['decision'] as Map<String, dynamic>,
      ),
      snoreModelAsset: '$mlAssetDir/${models['snore_tflite']}',
      vadModelAsset: '$mlAssetDir/${models['vad_onnx']}',
    );
  }
}

class MfccConfig {
  const MfccConfig({
    required this.sampleRate,
    required this.windowSizeMs,
    required this.windowStepMs,
    required this.numChannels,
    required this.numFrames,
    required this.lowerBandLimitHz,
    required this.upperBandLimitHz,
    required this.featureSize,
    required this.expectedAudioSamples,
    required this.enablePcan,
    required this.enableLog,
  });

  final int sampleRate;
  final int windowSizeMs;
  final int windowStepMs;
  final int numChannels;
  final int numFrames;
  final double lowerBandLimitHz;
  final double upperBandLimitHz;
  final int featureSize;
  final int expectedAudioSamples;
  final bool enablePcan;
  final bool enableLog;

  factory MfccConfig.fromJson(Map<String, dynamic> json) {
    return MfccConfig(
      sampleRate: json['sample_rate'] as int,
      windowSizeMs: json['window_size_ms'] as int,
      windowStepMs: json['window_step_ms'] as int,
      numChannels: json['num_channels'] as int,
      numFrames: json['num_frames'] as int,
      lowerBandLimitHz: (json['lower_band_limit_hz'] as num).toDouble(),
      upperBandLimitHz: (json['upper_band_limit_hz'] as num).toDouble(),
      featureSize: json['feature_size'] as int,
      expectedAudioSamples: json['expected_audio_samples'] as int,
      enablePcan: json['enable_pcan'] as bool,
      enableLog: json['enable_log'] as bool,
    );
  }
}

class VadConfig {
  const VadConfig({
    required this.sampleRate,
    required this.threshold,
    required this.minSpeechMs,
    required this.minSilenceMs,
    required this.speechPadMs,
  });

  final int sampleRate;
  final double threshold;
  final int minSpeechMs;
  final int minSilenceMs;
  final int speechPadMs;

  factory VadConfig.fromJson(Map<String, dynamic> json) {
    return VadConfig(
      sampleRate: json['sample_rate'] as int,
      threshold: (json['threshold'] as num).toDouble(),
      minSpeechMs: json['min_speech_ms'] as int,
      minSilenceMs: json['min_silence_ms'] as int,
      speechPadMs: json['speech_pad_ms'] as int,
    );
  }
}

class SnoreConfig {
  const SnoreConfig({
    required this.classIndex,
    required this.defaultHopSeconds,
    required this.windowSamples,
  });

  final Map<String, int> classIndex;
  final double defaultHopSeconds;
  final int windowSamples;

  int get snoringIndex => classIndex['snoring']!;

  factory SnoreConfig.fromJson(Map<String, dynamic> json) {
    return SnoreConfig(
      classIndex: (json['class_index'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v as int),
      ),
      defaultHopSeconds: (json['default_hop_seconds'] as num).toDouble(),
      windowSamples: json['window_samples'] as int,
    );
  }
}

class DecisionConfig {
  const DecisionConfig({
    required this.snoreEnter,
    required this.snoreExit,
    required this.snoreSmoothingWindowTicks,
    required this.talkEnter,
    required this.talkExit,
    required this.minSnoreSeconds,
    required this.minTalkSeconds,
    required this.mergeGapSnoreSeconds,
    required this.mergeGapTalkSeconds,
    required this.suppressionSeconds,
    required this.gridSeconds,
    required this.snoreWinsOnConflict,
  });

  final double snoreEnter;
  final double snoreExit;
  final int snoreSmoothingWindowTicks;
  final double talkEnter;
  final double talkExit;
  final double minSnoreSeconds;
  final double minTalkSeconds;
  final double mergeGapSnoreSeconds;
  final double mergeGapTalkSeconds;
  final double suppressionSeconds;
  final double gridSeconds;
  final bool snoreWinsOnConflict;

  factory DecisionConfig.fromJson(Map<String, dynamic> json) {
    double n(String key) => (json[key] as num).toDouble();
    return DecisionConfig(
      snoreEnter: n('snore_enter_threshold'),
      snoreExit: n('snore_exit_threshold'),
      snoreSmoothingWindowTicks:
          (json['snore_smoothing_window_ticks'] as num?)?.toInt() ?? 1,
      talkEnter: n('talk_enter_threshold'),
      talkExit: n('talk_exit_threshold'),
      minSnoreSeconds: n('min_snore_duration_seconds'),
      minTalkSeconds: n('min_talk_duration_seconds'),
      mergeGapSnoreSeconds: n('merge_gap_snore_seconds'),
      mergeGapTalkSeconds: n('merge_gap_talk_seconds'),
      suppressionSeconds: n('suppression_seconds'),
      gridSeconds: n('decision_grid_seconds'),
      snoreWinsOnConflict: json['snore_wins_on_conflict'] as bool,
    );
  }
}
