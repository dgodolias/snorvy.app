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
    // Voice runs at the raw Silero hop (~32 ms) so a real-world voice spike
    // can be 3-6 frames wide. Linear interp onto the 200 ms decision grid
    // smooths a 0.99 frame next to a 0.05 neighbour down to ~0.4, which
    // routinely drops a clean talk under the 0.7 hysteresis threshold. Use
    // max-over-window resampling so narrow spikes survive.
    final voiceOnGrid = _maxResampleToGrid(voiceTimestamps, voiceProbs, grid);

    // For the speech-suppression mask we need to detect any narrow voice
    // spike in the raw 32 ms Silero timeline — interpolating onto the 200 ms
    // decision grid would smooth a 0.73 frame down to 0.36 next to a quiet
    // neighbour, killing suppression entirely. Compute it directly from the
    // raw Silero output and check, for each grid tick, whether ANY voice
    // frame within ±2 s exceeds the threshold.
    const speechSuppressionThreshold = 0.5;
    const suppressionHalfWindowSeconds = 2.0;
    final voiceContext = _voiceContextFromRaw(
      voiceTimestamps,
      voiceProbs,
      grid,
      threshold: speechSuppressionThreshold,
      halfWindowSeconds: suppressionHalfWindowSeconds,
    );

    final snoreEvents = _hysteresis(
      grid: grid,
      target: snoreOnGrid,
      enter: config.snoreEnter,
      exitThreshold: config.snoreExit,
      label: 'snore',
      minDuration: config.minSnoreSeconds,
      suppressMask: voiceContext,
    );
    final talkEvents = _hysteresis(
      grid: grid,
      target: voiceOnGrid,
      enter: config.talkEnter,
      exitThreshold: config.talkExit,
      label: 'talk',
      minDuration: config.minTalkSeconds,
      suppressMask: List<bool>.filled(grid.length, false),
    );

    final mergedSnore = _mergeClose(snoreEvents, config.mergeGapSnoreSeconds);
    final mergedTalk = _mergeClose(talkEvents, config.mergeGapTalkSeconds);
    final all = [...mergedSnore, ...mergedTalk]
      ..sort((a, b) => a.startSeconds.compareTo(b.startSeconds));
    return all;
  }

  /// Max-pool [values] sampled at [timestamps] onto [grid]. Each grid tick
  /// gets the maximum of all source samples whose timestamp falls within ±
  /// half-step of the tick (or the nearest neighbour if none do). Use for
  /// densely-sampled streams where narrow peaks must survive downsampling.
  List<double> _maxResampleToGrid(
    List<double> timestamps,
    List<double> values,
    List<double> grid,
  ) {
    final out = List<double>.filled(grid.length, 0.0);
    if (timestamps.isEmpty || values.isEmpty) return out;
    final half = config.gridSeconds / 2;
    var cursor = 0;
    for (var i = 0; i < grid.length; i++) {
      final lo = grid[i] - half;
      final hi = grid[i] + half;
      while (cursor < timestamps.length && timestamps[cursor] < lo) {
        cursor++;
      }
      var best = 0.0;
      var found = false;
      for (var k = cursor; k < timestamps.length; k++) {
        if (timestamps[k] > hi) break;
        if (values[k] > best) best = values[k];
        found = true;
      }
      if (!found) {
        // No sample in window — fall back to nearest neighbour.
        final idx = cursor < timestamps.length ? cursor : timestamps.length - 1;
        out[i] = values[idx];
      } else {
        out[i] = best;
      }
    }
    return out;
  }

  /// For each tick in [grid], return true iff there is at least one entry in
  /// the raw [timestamps]/[values] timeline within ±[halfWindowSeconds] whose
  /// value reaches [threshold]. We work directly on the raw Silero output to
  /// avoid losing narrow voice spikes during the interp-to-grid downsampling.
  List<bool> _voiceContextFromRaw(
    List<double> timestamps,
    List<double> values,
    List<double> grid, {
    required double threshold,
    required double halfWindowSeconds,
  }) {
    final out = List<bool>.filled(grid.length, false);
    if (timestamps.isEmpty || values.isEmpty) return out;
    // Indices of all frames where voice >= threshold.
    final hits = <double>[];
    for (var i = 0; i < values.length && i < timestamps.length; i++) {
      if (values[i] >= threshold) hits.add(timestamps[i]);
    }
    if (hits.isEmpty) return out;
    var hitCursor = 0;
    for (var i = 0; i < grid.length; i++) {
      final lo = grid[i] - halfWindowSeconds;
      final hi = grid[i] + halfWindowSeconds;
      while (hitCursor < hits.length - 1 && hits[hitCursor] < lo) {
        hitCursor++;
      }
      out[i] = hits[hitCursor] >= lo && hits[hitCursor] <= hi;
    }
    return out;
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
    required List<bool> suppressMask,
  }) {
    final events = <DecisionEvent>[];
    var inEvent = false;
    var segStart = 0.0;
    final segProbs = <double>[];

    for (var i = 0; i < grid.length; i++) {
      final t = grid[i];
      final value = target[i];
      var active = inEvent ? value >= exitThreshold : value >= enter;
      if (active && suppressMask[i]) {
        active = false;
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
