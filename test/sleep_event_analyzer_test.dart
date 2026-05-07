import 'package:flutter_test/flutter_test.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/sleep_event_analyzer.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';

void main() {
  const analyzer = LocalLevelSleepEventAnalyzer();
  final startedAt = DateTime(2026, 5, 7, 23, 30);
  final endedAt = startedAt.add(const Duration(hours: 8));

  test('turns sustained loud frames into a snore event and score', () {
    final frames = [
      for (var second = 0; second < 40; second++)
        _frame(second, second >= 10 && second <= 16 ? 56 : 35),
    ];

    final result = analyzer.analyzeFrames(
      frames: frames,
      startedAt: startedAt,
      endedAt: endedAt,
      recordingPath: 'memory://night.ogg',
    );

    expect(result.snoreScore, greaterThan(0));
    expect(result.events, hasLength(1));
    expect(result.events.single.kind, SleepEventKind.snore);
    expect(
      result.events.single.startsAt,
      startedAt.add(const Duration(seconds: 10)),
    );
    expect(result.events.single.duration, const Duration(seconds: 7));
    expect(result.events.single.filePath, 'memory://night.ogg');
  });

  test('labels short high peaks as talk events', () {
    final frames = [
      for (var second = 0; second < 24; second++)
        _frame(second, second >= 8 && second <= 10 ? 58 : 34),
    ];

    final result = analyzer.analyzeFrames(
      frames: frames,
      startedAt: startedAt,
      endedAt: endedAt,
      recordingPath: 'memory://night.ogg',
    );

    expect(result.snoreScore, 0);
    expect(result.events.single.kind, SleepEventKind.talk);
    expect(result.events.single.duration, const Duration(seconds: 3));
  });

  test('keeps quiet nights empty', () {
    final frames = [
      for (var second = 0; second < 30; second++) _frame(second, 34),
    ];

    final result = analyzer.analyzeFrames(
      frames: frames,
      startedAt: startedAt,
      endedAt: endedAt,
      recordingPath: 'memory://night.ogg',
    );

    expect(result.snoreScore, 0);
    expect(result.events, isEmpty);
  });
  test('neural classifier separates sustained snore from short talk', () {
    const classifier = TinyLevelNeuralSleepClassifier();

    final snore = classifier.classify(
      const SleepClusterFeatures(
        duration: Duration(seconds: 8),
        frameCount: 8,
        peakLift: 15,
        averageLift: 11,
        variability: 1,
      ),
    );
    final talk = classifier.classify(
      const SleepClusterFeatures(
        duration: Duration(seconds: 3),
        frameCount: 3,
        peakLift: 18,
        averageLift: 13,
        variability: 4,
      ),
    );
    final noise = classifier.classify(
      const SleepClusterFeatures(
        duration: Duration(seconds: 3),
        frameCount: 3,
        peakLift: 4,
        averageLift: 1,
        variability: 9,
      ),
    );

    expect(snore, SleepEventKind.snore);
    expect(talk, SleepEventKind.talk);
    expect(noise, SleepEventKind.noise);
  });
}

RecordingPowerFrame _frame(int second, double decibels) {
  return RecordingPowerFrame(
    elapsed: Duration(seconds: second),
    decibels: decibels,
  );
}
