import 'package:flutter_test/flutter_test.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/audio_event_clip_store.dart';
import 'package:snorvy/src/services/sleep_event_analyzer.dart';

void main() {
  test('refines longer speech-like snore candidates to talk', () {
    const refiner = WavAudioEventKindRefiner();

    final refined = refiner.refine(
      SleepEventKind.snore,
      const AudioSegmentFeatures(
        activeDuration: Duration(milliseconds: 900),
        activeZeroCrossingRate: 2700,
        activeDecibelSpread: 5.6,
      ),
    );

    expect(refined, SleepEventKind.talk);
  });

  test('keeps short bursty snore candidates as snore', () {
    const refiner = WavAudioEventKindRefiner();

    final refined = refiner.refine(
      SleepEventKind.snore,
      const AudioSegmentFeatures(
        activeDuration: Duration(milliseconds: 500),
        activeZeroCrossingRate: 2900,
        activeDecibelSpread: 10,
      ),
    );

    expect(refined, SleepEventKind.snore);
  });

  test('clips stop before the next detected event begins', () {
    const planner = AudioClipWindowPlanner();
    final chunkStartedAt = DateTime(2026, 5, 8, 19);
    final windows = planner.plan(
      chunkStartedAt: chunkStartedAt,
      chunkDuration: const Duration(seconds: 12),
      preRoll: const Duration(seconds: 2),
      postRoll: const Duration(seconds: 2),
      events: [
        AnalyzedSleepEvent(
          kind: SleepEventKind.talk,
          startsAt: chunkStartedAt.add(const Duration(seconds: 3)),
          duration: const Duration(milliseconds: 1200),
          intensity: 90,
          filePath: 'memory://chunk.wav',
        ),
        AnalyzedSleepEvent(
          kind: SleepEventKind.snore,
          startsAt: chunkStartedAt.add(const Duration(milliseconds: 4700)),
          duration: const Duration(milliseconds: 900),
          intensity: 90,
          filePath: 'memory://chunk.wav',
        ),
      ],
    );

    expect(windows, hasLength(2));
    expect(windows.first.clipStart, const Duration(seconds: 1));
    expect(windows.first.clipEnd, const Duration(milliseconds: 4700));
    expect(windows.last.clipStart, const Duration(milliseconds: 4200));
  });
}
