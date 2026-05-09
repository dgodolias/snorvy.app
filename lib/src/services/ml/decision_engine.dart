import 'dart:math' as math;

import 'package:snorvy/src/services/ml/pipeline_config.dart';

class DecisionEvent {
  const DecisionEvent({
    required this.startSeconds,
    required this.endSeconds,
    required this.label,
    required this.confidence,
  });

  final double startSeconds;
  final double endSeconds;
  final String label;
  final double confidence;

  double get durationSeconds => endSeconds - startSeconds;
}

class DecisionEngine {
  DecisionEngine(this.config);

  final DecisionConfig config;

  List<DecisionEvent> combine({
    required List<double> snoreTimestamps,
    required List<double> snoreProbs,
    required List<double> voiceTimestamps,
    required List<double> voiceProbs,
    required double durationSeconds,
  }) {
    final grid = _grid(durationSeconds);
    final snoreOnGrid = _resampleToGrid(snoreTimestamps, snoreProbs, grid);
    final voiceOnGrid = _resampleToGrid(voiceTimestamps, voiceProbs, grid);

    final snoreEvents = _hysteresis(
      grid: grid,
      target: snoreOnGrid,
      enter: config.snoreEnter,
      exitThreshold: config.snoreExit,
      label: 'snore',
      minDuration: config.minSnoreSeconds,
      gateBySnore: false,
      snoreOnGrid: snoreOnGrid,
    );
    final talkEvents = _hysteresis(
      grid: grid,
      target: voiceOnGrid,
      enter: config.talkEnter,
      exitThreshold: config.talkExit,
      label: 'talk',
      minDuration: config.minTalkSeconds,
      gateBySnore: config.snoreWinsOnConflict,
      snoreOnGrid: snoreOnGrid,
    );

    final mergedSnore = _mergeClose(snoreEvents, config.mergeGapSnoreSeconds);
    final mergedTalk = _mergeClose(talkEvents, config.mergeGapTalkSeconds);
    final all = [...mergedSnore, ...mergedTalk]
      ..sort((a, b) => a.startSeconds.compareTo(b.startSeconds));
    return all;
  }

  List<double> _grid(double durationSeconds) {
    final step = config.gridSeconds;
    final n = math.max(1, (durationSeconds / step).ceil() + 1);
    return List<double>.generate(n, (i) => i * step);
  }

  static List<double> _resampleToGrid(
    List<double> timestamps,
    List<double> values,
    List<double> grid,
  ) {
    final out = List<double>.filled(grid.length, 0.0);
    if (timestamps.isEmpty) return out;
    if (timestamps.length == 1) {
      out.fillRange(0, out.length, values.first);
      return out;
    }
    var j = 0;
    for (var i = 0; i < grid.length; i++) {
      final t = grid[i];
      if (t <= timestamps.first) {
        out[i] = values.first;
        continue;
      }
      if (t >= timestamps.last) {
        out[i] = values.last;
        continue;
      }
      while (j < timestamps.length - 2 && timestamps[j + 1] < t) {
        j++;
      }
      final t0 = timestamps[j];
      final t1 = timestamps[j + 1];
      final frac = (t - t0) / (t1 - t0);
      out[i] = values[j] + (values[j + 1] - values[j]) * frac;
    }
    return out;
  }

  List<DecisionEvent> _hysteresis({
    required List<double> grid,
    required List<double> target,
    required double enter,
    required double exitThreshold,
    required String label,
    required double minDuration,
    required bool gateBySnore,
    required List<double> snoreOnGrid,
  }) {
    final events = <DecisionEvent>[];
    var inEvent = false;
    var segStart = 0.0;
    final segProbs = <double>[];

    for (var i = 0; i < grid.length; i++) {
      final t = grid[i];
      final value = target[i];
      var active = inEvent ? value >= exitThreshold : value >= enter;
      if (active && gateBySnore) {
        if (snoreOnGrid[i] >= config.snoreEnter) {
          active = false;
        }
      }

      if (active && !inEvent) {
        inEvent = true;
        segStart = t;
        segProbs
          ..clear()
          ..add(value);
      } else if (active && inEvent) {
        segProbs.add(value);
      } else if (!active && inEvent) {
        final duration = t - segStart;
        if (duration >= minDuration) {
          events.add(DecisionEvent(
            startSeconds: segStart,
            endSeconds: t,
            label: label,
            confidence: _mean(segProbs),
          ));
        }
        inEvent = false;
        segProbs.clear();
      }
    }
    if (inEvent) {
      final last = grid.last;
      final duration = last - segStart;
      if (duration >= minDuration) {
        events.add(DecisionEvent(
          startSeconds: segStart,
          endSeconds: last,
          label: label,
          confidence: _mean(segProbs),
        ));
      }
    }
    return events;
  }

  List<DecisionEvent> _mergeClose(List<DecisionEvent> events, double maxGap) {
    if (events.isEmpty) return events;
    final sorted = [...events]
      ..sort((a, b) => a.startSeconds.compareTo(b.startSeconds));
    final merged = <DecisionEvent>[sorted.first];
    for (var i = 1; i < sorted.length; i++) {
      final last = merged.last;
      final ev = sorted[i];
      if (ev.label == last.label && (ev.startSeconds - last.endSeconds) <= maxGap) {
        merged[merged.length - 1] = DecisionEvent(
          startSeconds: last.startSeconds,
          endSeconds: ev.endSeconds,
          label: last.label,
          confidence: (last.confidence + ev.confidence) / 2,
        );
      } else {
        merged.add(ev);
      }
    }
    return merged;
  }

  static double _mean(List<double> xs) {
    if (xs.isEmpty) return 0.0;
    var s = 0.0;
    for (final x in xs) {
      s += x;
    }
    return s / xs.length;
  }
}
