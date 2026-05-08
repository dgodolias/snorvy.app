import 'dart:math' as math;

import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';

class AnalyzedSleepEvent {
  const AnalyzedSleepEvent({
    required this.kind,
    required this.startsAt,
    required this.duration,
    required this.intensity,
    required this.filePath,
  });

  final SleepEventKind kind;
  final DateTime startsAt;
  final Duration duration;
  final int intensity;
  final String filePath;
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
  SleepAnalysisResult analyzeFrames({
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
    if (features.duration <= const Duration(seconds: 2)) {
      return SleepEventKind.talk;
    }
    if (features.duration <= const Duration(seconds: 4) &&
        features.frameCount >= 3 &&
        features.averageLift >= 8 &&
        features.variability <= 4.2) {
      return SleepEventKind.snore;
    }
    if (features.duration <= const Duration(seconds: 16) &&
        features.variability >= 4.5 &&
        features.peakLift >= 7) {
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
  static const _minimumEventSeconds = 2;
  static const _minimumDynamicRange = 5.0;
  static const _mergeGap = Duration(milliseconds: 1200);

  final SleepClusterClassifier _classifier;

  @override
  SleepAnalysisResult analyzeFrames({
    required List<RecordingPowerFrame> frames,
    required DateTime startedAt,
    required DateTime endedAt,
    required String recordingPath,
  }) {
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

    final threshold = floor + math.max(5, math.min(12, dynamicRange * 0.38));

    final clusters = _findLoudClusters(cleanFrames, threshold);
    if (clusters.isEmpty) {
      return SleepAnalysisResult.empty;
    }

    final events = <AnalyzedSleepEvent>[];
    for (final cluster in clusters) {
      if (cluster.duration.inSeconds < _minimumEventSeconds) {
        continue;
      }

      final event = _eventForCluster(
        cluster,
        threshold: threshold,
        startedAt: startedAt,
        recordingPath: recordingPath,
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
    _FrameCluster? current;
    RecordingPowerFrame? lastLoudFrame;

    for (final frame in frames) {
      final isLoud = frame.decibels >= threshold;
      if (!isLoud) {
        continue;
      }

      if (current == null) {
        current = _FrameCluster(first: frame, last: frame, frames: [frame]);
      } else {
        final gap = frame.elapsed - (lastLoudFrame?.elapsed ?? frame.elapsed);
        if (gap <= _mergeGap) {
          current = current.add(frame);
        } else {
          clusters.add(current);
          current = _FrameCluster(first: frame, last: frame, frames: [frame]);
        }
      }

      lastLoudFrame = frame;
    }

    if (current != null) {
      clusters.add(current);
    }

    return clusters;
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
}

class _FrameCluster {
  const _FrameCluster({
    required this.first,
    required this.last,
    required this.frames,
  });

  final RecordingPowerFrame first;
  final RecordingPowerFrame last;
  final List<RecordingPowerFrame> frames;

  Duration get duration {
    final elapsed = last.elapsed - first.elapsed;
    return elapsed + const Duration(seconds: 1);
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
    return _FrameCluster(first: first, last: frame, frames: [...frames, frame]);
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
