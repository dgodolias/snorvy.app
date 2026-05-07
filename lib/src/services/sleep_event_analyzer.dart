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

class LocalLevelSleepEventAnalyzer implements SleepEventAnalyzer {
  const LocalLevelSleepEventAnalyzer();

  static const _minimumFrames = 3;
  static const _minimumEventSeconds = 2;
  static const _mergeGapSeconds = 2;

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
    final floor = _percentile(values, 0.35);
    final median = _percentile(values, 0.50);
    final spread = _standardDeviation(values, median);
    final threshold = math.max(floor + 8, median + math.max(4, spread * 0.65));

    final clusters = _findLoudClusters(cleanFrames, threshold);
    if (clusters.isEmpty) {
      return SleepAnalysisResult.empty;
    }

    final events = [
      for (final cluster in clusters)
        if (cluster.duration.inSeconds >= _minimumEventSeconds)
          _eventForCluster(
            cluster,
            threshold: threshold,
            startedAt: startedAt,
            recordingPath: recordingPath,
          ),
    ];

    if (events.isEmpty) {
      return SleepAnalysisResult.empty;
    }

    final snoreScore = _snoreScore(events, startedAt, endedAt);
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
        if (gap.inSeconds <= _mergeGapSeconds) {
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
    final kind = _kindForCluster(cluster, threshold: threshold);

    return AnalyzedSleepEvent(
      kind: kind,
      startsAt: startedAt.add(cluster.first.elapsed),
      duration: cluster.duration,
      intensity: intensity,
      filePath: recordingPath,
    );
  }

  SleepEventKind _kindForCluster(
    _FrameCluster cluster, {
    required double threshold,
  }) {
    final seconds = cluster.duration.inSeconds;
    final peakLift = cluster.peakDecibels - threshold;
    final averageLift = cluster.averageDecibels - threshold;

    if (seconds >= 5 && averageLift >= 1) {
      return SleepEventKind.snore;
    }
    if (seconds <= 4 && peakLift >= 5) {
      return SleepEventKind.talk;
    }
    return SleepEventKind.noise;
  }

  int _snoreScore(
    List<AnalyzedSleepEvent> events,
    DateTime startedAt,
    DateTime endedAt,
  ) {
    final sleepSeconds = math.max(1, endedAt.difference(startedAt).inSeconds);
    final snoreEvents = events
        .where((event) => event.kind == SleepEventKind.snore)
        .toList(growable: false);
    final snoreSeconds = snoreEvents.fold<int>(
      0,
      (total, event) => total + event.duration.inSeconds,
    );
    if (snoreSeconds == 0) {
      return 0;
    }

    final averageSnoreIntensity =
        snoreEvents
            .map((event) => event.intensity)
            .fold<int>(0, (total, intensity) => total + intensity) /
        math.max(1, snoreEvents.length);
    final durationWeight = snoreSeconds / sleepSeconds;
    return (durationWeight * 1500 + averageSnoreIntensity * 0.35).round().clamp(
      1,
      100,
    );
  }

  double _percentile(List<double> sortedValues, double percentile) {
    final index = ((sortedValues.length - 1) * percentile).round();
    return sortedValues[index.clamp(0, sortedValues.length - 1)];
  }

  double _standardDeviation(List<double> values, double mean) {
    final variance =
        values.fold<double>(0, (total, value) {
          final delta = value - mean;
          return total + delta * delta;
        }) /
        values.length;
    return math.sqrt(variance);
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
}
