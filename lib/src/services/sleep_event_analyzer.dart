import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';

/// Which analyzer pipeline produced an event. Surfaces silently in logs so
/// we can tell whether the ML pipeline actually ran or fell back to the
/// dB-based heuristic without anyone noticing.
enum AnalyzerSource { ml, ruleBased }

class AnalyzedSleepEvent {
  const AnalyzedSleepEvent({
    required this.kind,
    required this.startsAt,
    required this.duration,
    required this.intensity,
    required this.filePath,
    this.peakLevel = 0,
    this.source = AnalyzerSource.ruleBased,
  });

  final SleepEventKind kind;
  final DateTime startsAt;
  final Duration duration;
  final int intensity;
  /// Peak audio loudness (0-100) computed from the saved WAV bytes. 0 until
  /// the clip is actually written by [AudioEventClipStore].
  final int peakLevel;
  final String filePath;
  final AnalyzerSource source;

  AnalyzedSleepEvent copyWith({
    SleepEventKind? kind,
    DateTime? startsAt,
    Duration? duration,
    int? intensity,
    int? peakLevel,
    String? filePath,
    AnalyzerSource? source,
  }) {
    return AnalyzedSleepEvent(
      kind: kind ?? this.kind,
      startsAt: startsAt ?? this.startsAt,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      peakLevel: peakLevel ?? this.peakLevel,
      filePath: filePath ?? this.filePath,
      source: source ?? this.source,
    );
  }
}

class SleepAnalysisResult {
  const SleepAnalysisResult({required this.snoreScore, required this.events});

  static const empty = SleepAnalysisResult(
    snoreScore: 0,
    events: <AnalyzedSleepEvent>[],
  );

  final int snoreScore;
  final List<AnalyzedSleepEvent> events;
}

abstract interface class SleepEventAnalyzer {
  Future<SleepAnalysisResult> analyzeFrames({
    required List<RecordingPowerFrame> frames,
    required DateTime startedAt,
    required DateTime endedAt,
    required String recordingPath,
  });
}

class SleepClusterFeatures {
  const SleepClusterFeatures({
    required this.duration,
    required this.frameCount,
    required this.peakLift,
    required this.averageLift,
    required this.variability,
  });

  final Duration duration;
  final int frameCount;
  final double peakLift;
  final double averageLift;
  final double variability;
}

abstract interface class SleepClusterClassifier {
  SleepEventKind classify(SleepClusterFeatures features);
}

class TinyLevelNeuralSleepClassifier implements SleepClusterClassifier {
  const TinyLevelNeuralSleepClassifier();

  @override
  SleepEventKind classify(SleepClusterFeatures features) {
    if (features.peakLift < 5 && features.averageLift < 3) {
      return SleepEventKind.noise;
    }
    if (features.duration <= const Duration(milliseconds: 1400) &&
        features.frameCount >= 3 &&
        features.peakLift >= 12 &&
        features.averageLift >= 6) {
      return SleepEventKind.snore;
    }
    if (features.duration <= const Duration(milliseconds: 3200) &&
        features.frameCount >= 3 &&
        features.averageLift >= 9 &&
        features.variability <= 2.6) {
      return SleepEventKind.snore;
    }
    if (features.duration >= const Duration(seconds: 5) &&
        features.averageLift >= 6 &&
        features.variability <= 2.8) {
      return SleepEventKind.snore;
    }
    if (features.duration <= const Duration(seconds: 16) &&
        features.variability >= 3.2 &&
        features.peakLift >= 7) {
      return SleepEventKind.talk;
    }
    if (features.duration > const Duration(milliseconds: 3200) &&
        features.duration < const Duration(seconds: 5) &&
        features.peakLift >= 7) {
      return SleepEventKind.talk;
    }
    if (features.duration <= const Duration(seconds: 2)) {
      return SleepEventKind.talk;
    }

    final input = _ClusterNetworkInput.from(features);

    final sustainedEnergy = _relu(
      -0.8 +
          input.duration * 2.0 +
          input.averageLift * 0.5 +
          input.frameCount * 0.8,
    );
    final impulse = _relu(-0.2 + input.peakLift * 1.4 - input.duration * 0.8);
    final irregularity = _relu(
      0.1 + input.variability * 1.1 - input.averageLift * 0.2,
    );
    final loudness = _relu(0.2 + input.averageLift + input.peakLift * 0.6);

    final snoreLogit =
        -1.1 + sustainedEnergy * 1.4 + loudness * 0.4 - impulse * 0.3;
    final talkLogit =
        -0.4 + impulse * 1.6 + loudness * 0.3 - sustainedEnergy * 0.7;
    final noiseLogit =
        -0.1 + irregularity - sustainedEnergy * 0.5 - impulse * 0.2;

    final logits = [snoreLogit, talkLogit, noiseLogit];
    final winner = _argmax(logits);
    return switch (winner) {
      0 => SleepEventKind.snore,
      1 => SleepEventKind.talk,
      _ => SleepEventKind.noise,
    };
  }

  double _relu(double value) => math.max(0, value);

  int _argmax(List<double> values) {
    var winner = 0;
    for (var index = 1; index < values.length; index++) {
      if (values[index] > values[winner]) {
        winner = index;
      }
    }
    return winner;
  }
}

class LocalLevelSleepEventAnalyzer implements SleepEventAnalyzer {
  const LocalLevelSleepEventAnalyzer({
    SleepClusterClassifier classifier = const TinyLevelNeuralSleepClassifier(),
  }) : _classifier = classifier;

  static const _minimumFrames = 3;
  static const _minimumEventDuration = Duration(milliseconds: 400);
  static const _minimumDynamicRange = 5.0;
  static const _mergeGap = Duration(milliseconds: 700);

  final SleepClusterClassifier _classifier;

  @override
  Future<SleepAnalysisResult> analyzeFrames({
    required List<RecordingPowerFrame> frames,
    required DateTime startedAt,
    required DateTime endedAt,
    required String recordingPath,
  }) async {
    final cleanFrames =
        frames.where((frame) => frame.decibels.isFinite).toList(growable: false)
          ..sort((a, b) => a.elapsed.compareTo(b.elapsed));
    if (cleanFrames.length < _minimumFrames) {
      return SleepAnalysisResult.empty;
    }

    final values = cleanFrames.map((frame) => frame.decibels).toList()..sort();
    final floor = _percentile(values, 0.20);
    final high = _percentile(values, 0.92);
    final peak = values.last;
    final dynamicRange = high - floor;
    if (dynamicRange < _minimumDynamicRange && peak < floor + 7) {
      return SleepAnalysisResult.empty;
    }

    final threshold = floor + math.max(3.5, math.min(10, dynamicRange * 0.30));

    final clusters = _findLoudClusters(cleanFrames, threshold);
    _logDebug(
      'frames=${cleanFrames.length} floor=${floor.toStringAsFixed(1)} '
      'high=${high.toStringAsFixed(1)} peak=${peak.toStringAsFixed(1)} '
      'threshold=${threshold.toStringAsFixed(1)} clusters=${clusters.length}',
    );
    if (clusters.isEmpty) {
      return SleepAnalysisResult.empty;
    }

    final events = <AnalyzedSleepEvent>[];
    for (final cluster in clusters) {
      if (cluster.duration < _minimumEventDuration) {
        continue;
      }

      final event = _eventForCluster(
        cluster,
        threshold: threshold,
        startedAt: startedAt,
        recordingPath: recordingPath,
      );
      _logDebug(
        'cluster offset=${cluster.first.elapsed.inMilliseconds}ms '
        'duration=${cluster.duration.inMilliseconds}ms '
        'frames=${cluster.frames.length} '
        'peakLift=${(cluster.peakDecibels - threshold).toStringAsFixed(1)} '
        'avgLift=${(cluster.averageDecibels - threshold).toStringAsFixed(1)} '
        'spread=${cluster.decibelSpread.toStringAsFixed(1)} '
        'kind=${event.kind.name}',
      );
      if (event.kind != SleepEventKind.noise) {
        events.add(event);
      }
    }

    if (events.isEmpty) {
      return SleepAnalysisResult.empty;
    }

    final snoreScore = _snoreCount(events);
    return SleepAnalysisResult(snoreScore: snoreScore, events: events);
  }

  List<_FrameCluster> _findLoudClusters(
    List<RecordingPowerFrame> frames,
    double threshold,
  ) {
    final clusters = <_FrameCluster>[];
    final frameStep = _typicalFrameStep(frames);
    final mergeGap = Duration(
      microseconds: math.max(
        _mergeGap.inMicroseconds,
        frameStep.inMicroseconds * 2,
      ),
    );
    _FrameCluster? current;
    RecordingPowerFrame? lastLoudFrame;

    for (final frame in frames) {
      final isLoud = frame.decibels >= threshold;
      if (!isLoud) {
        continue;
      }

      if (current == null) {
        current = _FrameCluster(
          first: frame,
          last: frame,
          frames: [frame],
          frameStep: frameStep,
        );
      } else {
        final gap = frame.elapsed - (lastLoudFrame?.elapsed ?? frame.elapsed);
        if (gap <= mergeGap) {
          current = current.add(frame);
        } else {
          clusters.add(current);
          current = _FrameCluster(
            first: frame,
            last: frame,
            frames: [frame],
            frameStep: frameStep,
          );
        }
      }

      lastLoudFrame = frame;
    }

    if (current != null) {
      clusters.add(current);
    }

    return clusters;
  }

  Duration _typicalFrameStep(List<RecordingPowerFrame> frames) {
    final gaps = <int>[];
    for (var index = 1; index < frames.length; index++) {
      final gap = frames[index].elapsed - frames[index - 1].elapsed;
      if (gap > Duration.zero && gap <= const Duration(seconds: 2)) {
        gaps.add(gap.inMicroseconds);
      }
    }
    if (gaps.isEmpty) {
      return const Duration(milliseconds: 160);
    }

    gaps.sort();
    return Duration(microseconds: gaps[gaps.length ~/ 2]);
  }

  AnalyzedSleepEvent _eventForCluster(
    _FrameCluster cluster, {
    required double threshold,
    required DateTime startedAt,
    required String recordingPath,
  }) {
    final peak = cluster.peakDecibels;
    final intensity = (42 + (peak - threshold) * 5).round().clamp(12, 100);
    final kind = _classifier.classify(
      SleepClusterFeatures(
        duration: cluster.duration,
        frameCount: cluster.frames.length,
        peakLift: cluster.peakDecibels - threshold,
        averageLift: cluster.averageDecibels - threshold,
        variability: cluster.decibelSpread,
      ),
    );

    return AnalyzedSleepEvent(
      kind: kind,
      startsAt: startedAt.add(cluster.first.elapsed),
      duration: cluster.duration,
      intensity: intensity,
      filePath: recordingPath,
    );
  }

  int _snoreCount(List<AnalyzedSleepEvent> events) {
    return events.where((event) => event.kind == SleepEventKind.snore).length;
  }

  double _percentile(List<double> sortedValues, double percentile) {
    final index = ((sortedValues.length - 1) * percentile).round();
    return sortedValues[index.clamp(0, sortedValues.length - 1)];
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint('[SnorvyAnalyzer] $message');
    }
  }
}

class _FrameCluster {
  const _FrameCluster({
    required this.first,
    required this.last,
    required this.frames,
    required this.frameStep,
  });

  final RecordingPowerFrame first;
  final RecordingPowerFrame last;
  final List<RecordingPowerFrame> frames;
  final Duration frameStep;

  Duration get duration {
    final elapsed = last.elapsed - first.elapsed;
    return elapsed + frameStep;
  }

  double get peakDecibels {
    return frames.fold<double>(
      frames.first.decibels,
      (peak, frame) => math.max(peak, frame.decibels),
    );
  }

  double get averageDecibels {
    return frames.fold<double>(0, (total, frame) => total + frame.decibels) /
        frames.length;
  }

  _FrameCluster add(RecordingPowerFrame frame) {
    return _FrameCluster(
      first: first,
      last: frame,
      frames: [...frames, frame],
      frameStep: frameStep,
    );
  }

  double get decibelSpread {
    final average = averageDecibels;
    final variance =
        frames.fold<double>(0, (total, frame) {
          final delta = frame.decibels - average;
          return total + delta * delta;
        }) /
        frames.length;
    return math.sqrt(variance);
  }
}

class _ClusterNetworkInput {
  const _ClusterNetworkInput({
    required this.duration,
    required this.frameCount,
    required this.peakLift,
    required this.averageLift,
    required this.variability,
  });

  factory _ClusterNetworkInput.from(SleepClusterFeatures features) {
    return _ClusterNetworkInput(
      duration: (features.duration.inSeconds / 12).clamp(0, 1),
      frameCount: (features.frameCount / 12).clamp(0, 1),
      peakLift: (features.peakLift / 24).clamp(0, 1),
      averageLift: (features.averageLift / 16).clamp(0, 1),
      variability: (features.variability / 12).clamp(0, 1),
    );
  }

  final double duration;
  final double frameCount;
  final double peakLift;
  final double averageLift;
  final double variability;
}
