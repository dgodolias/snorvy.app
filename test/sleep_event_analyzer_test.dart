import 'package:flutter_test/flutter_test.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/sleep_event_analyzer.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';

void main() {
  const analyzer = LocalLevelSleepEventAnalyzer();
  final startedAt = DateTime(2026, 5, 7, 23, 30);
  final endedAt = startedAt.add(const Duration(hours: 8));

  test('turns sustained loud frames into a snore event and count', () async {
    final frames = [
      for (var second = 0; second < 40; second++)
        _frame(second, second >= 10 && second <= 16 ? 56 : 35),
    ];

    final result = await analyzer.analyzeFrames(
      frames: frames,
      startedAt: startedAt,
      endedAt: endedAt,
      recordingPath: 'memory://night.ogg',
    );

    expect(result.snoreScore, 1);
    expect(result.events, hasLength(1));
    expect(result.events.single.kind, SleepEventKind.snore);
    expect(
      result.events.single.startsAt,
      startedAt.add(const Duration(seconds: 10)),
    );
    expect(result.events.single.duration, const Duration(seconds: 7));
    expect(result.events.single.filePath, 'memory://night.ogg');
  });

  test('labels short high peaks as talk events', () async {
    final frames = [
      for (var second = 0; second < 24; second++)
        _frame(second, second >= 8 && second <= 9 ? 58 : 34),
    ];

    final result = await analyzer.analyzeFrames(
      frames: frames,
      startedAt: startedAt,
      endedAt: endedAt,
      recordingPath: 'memory://night.ogg',
    );

    expect(result.snoreScore, 0);
    expect(result.events.single.kind, SleepEventKind.talk);
    expect(result.events.single.duration, const Duration(seconds: 2));
  });

  test('keeps quiet nights empty', () async {
    final frames = [
      for (var second = 0; second < 30; second++) _frame(second, 34),
    ];

    final result = await analyzer.analyzeFrames(
      frames: frames,
      startedAt: startedAt,
      endedAt: endedAt,
      recordingPath: 'memory://night.ogg',
    );

    expect(result.snoreScore, 0);
    expect(result.events, isEmpty);
  });

  test('detects mixed snore and talk in a one-minute recording', () async {
    final frames = [
      for (var second = 0; second < 60; second++)
        _frame(second, switch (second) {
          >= 8 && <= 15 => second.isEven ? 66 : 49,
          >= 24 && <= 33 => 61,
          >= 42 && <= 48 => second.isEven ? 63 : 47,
          _ => 34 + (second % 2),
        }),
    ];

    final result = await analyzer.analyzeFrames(
      frames: frames,
      startedAt: startedAt,
      endedAt: startedAt.add(const Duration(seconds: 60)),
      recordingPath: 'memory://night.ogg',
    );

    expect(
      result.events.map((event) => event.kind),
      containsAll([SleepEventKind.talk, SleepEventKind.snore]),
    );
    expect(
      result.snoreScore,
      result.events.where((event) {
        return event.kind == SleepEventKind.snore;
      }).length,
    );
  });

  test('keeps two-second talk separate from three-second snore', () async {
    final shortStartedAt = DateTime(2026, 5, 8, 17, 40);
    final frames = [
      for (var second = 0; second < 11; second++)
        _frame(second, switch (second) {
          >= 1 && <= 2 => 66,
          >= 5 && <= 7 => 64,
          _ => 34,
        }),
    ];

    final result = await analyzer.analyzeFrames(
      frames: frames,
      startedAt: shortStartedAt,
      endedAt: shortStartedAt.add(const Duration(seconds: 11)),
      recordingPath: 'memory://short-snore.m4a',
    );

    expect(result.snoreScore, 1);
    expect(result.events.map((event) => event.kind), [
      SleepEventKind.talk,
      SleepEventKind.snore,
    ]);
  });

  test('detects two short snores and one talk with real recorder cadence', () async {
    final shortStartedAt = DateTime(2026, 5, 8, 18, 35);
    final frames = [
      for (var ms = 0; ms <= 12000; ms += 160)
        _frameMs(ms, switch (ms) {
          >= 1400 && <= 2200 => 64,
          >= 4300 && <= 5200 => 63,
          >= 7800 && <= 11600 => _speechLikeLevel(ms),
          _ => 34 + ((ms ~/ 160) % 2),
        }),
    ];

    final result = await analyzer.analyzeFrames(
      frames: frames,
      startedAt: shortStartedAt,
      endedAt: shortStartedAt.add(const Duration(seconds: 12)),
      recordingPath: 'memory://short-session.wav',
    );

    expect(result.snoreScore, 2);
    expect(result.events.map((event) => event.kind), [
      SleepEventKind.snore,
      SleepEventKind.snore,
      SleepEventKind.talk,
    ]);
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
    final shortSnore = classifier.classify(
      const SleepClusterFeatures(
        duration: Duration(seconds: 3),
        frameCount: 3,
        peakLift: 15,
        averageLift: 11,
        variability: 1,
      ),
    );
    final talk = classifier.classify(
      const SleepClusterFeatures(
        duration: Duration(seconds: 2),
        frameCount: 2,
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
    final steadyFourSecondTalk = classifier.classify(
      const SleepClusterFeatures(
        duration: Duration(seconds: 4),
        frameCount: 24,
        peakLift: 16,
        averageLift: 12,
        variability: 2,
      ),
    );

    expect(snore, SleepEventKind.snore);
    expect(shortSnore, SleepEventKind.snore);
    expect(talk, SleepEventKind.talk);
    expect(noise, SleepEventKind.noise);
    expect(steadyFourSecondTalk, SleepEventKind.talk);
  });
}

RecordingPowerFrame _frame(int second, double decibels) {
  return RecordingPowerFrame(
    elapsed: Duration(seconds: second),
    decibels: decibels,
  );
}

RecordingPowerFrame _frameMs(int milliseconds, double decibels) {
  return RecordingPowerFrame(
    elapsed: Duration(milliseconds: milliseconds),
    decibels: decibels,
  );
}

double _speechLikeLevel(int milliseconds) {
  return switch ((milliseconds ~/ 160) % 6) {
    0 => 66,
    1 => 49,
    2 => 61,
    3 => 53,
    4 => 68,
    _ => 47,
  };
}

