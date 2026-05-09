import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snorvy/src/app/snorvy_controller.dart';
import 'package:snorvy/src/data/app_database.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/audio_event_clip_store.dart';
import 'package:snorvy/src/services/audio_playback.dart';
import 'package:snorvy/src/services/bedtime_reminder_repository.dart';
import 'package:snorvy/src/services/bedtime_reminder_scheduler.dart';
import 'package:snorvy/src/services/recording_foreground_service.dart';
import 'package:snorvy/src/services/recording_exporter.dart';
import 'package:snorvy/src/services/sleep_event_analyzer.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';
import 'package:snorvy/src/services/unlock_repository.dart';

void main() {
  test('blocks free users after 7 sleep days in the current month', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final controller = _buildController(database: database, recorder: recorder);
    addTearDown(controller.dispose);

    final now = DateTime.now();
    for (var i = 0; i < 7; i++) {
      await database.createRecordedNight(
        startedAt: DateTime(now.year, now.month, i + 1, 23),
        endedAt: DateTime(now.year, now.month, i + 2, 7),
        recordingPath: 'memory://night_$i.ogg',
      );
    }

    await controller.initialize();
    await controller.startRecording();

    expect(recorder.startCalls, 0);
    expect(controller.statusMessage, contains('7 sleep days/month'));
  });

  test('counts repeated same-day recordings as one free sleep day', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final controller = _buildController(database: database, recorder: recorder);
    addTearDown(controller.dispose);

    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 7);
    final secondDay = DateTime(now.year, now.month, 8);

    await database.createRecordedNight(
      startedAt: firstDay.add(const Duration(hours: 1)),
      endedAt: firstDay.add(const Duration(hours: 3)),
      recordingPath: 'memory://nap_1.m4a',
    );
    await database.createRecordedNight(
      startedAt: firstDay.add(const Duration(hours: 14)),
      endedAt: firstDay.add(const Duration(hours: 16)),
      recordingPath: 'memory://nap_2.m4a',
    );
    await database.createRecordedNight(
      startedAt: secondDay.add(const Duration(hours: 12)),
      endedAt: secondDay.add(const Duration(minutes: 12, hours: 12)),
      recordingPath: 'memory://quick_test.m4a',
    );

    await controller.initialize();

    expect(controller.recordingsThisMonth, 1);
  });

  test('loads the newest same-day recording first', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final controller = _buildController(database: database, recorder: recorder);
    addTearDown(controller.dispose);

    final day = DateTime(2026, 5, 8);
    await database.createRecordedNight(
      startedAt: day.add(const Duration(minutes: 10)),
      endedAt: day.add(const Duration(minutes: 30)),
      recordingPath: 'memory://older.m4a',
    );
    await database.createRecordedNight(
      startedAt: day.add(const Duration(hours: 1)),
      endedAt: day.add(const Duration(hours: 1, minutes: 20)),
      recordingPath: 'memory://newer.m4a',
    );

    await controller.initialize();

    expect(controller.nights.first.recordingPath, 'memory://newer.m4a');
  });

  test('cleans incomplete zero-duration recorded nights on startup', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final controller = _buildController(database: database, recorder: recorder);
    addTearDown(controller.dispose);

    final startedAt = DateTime(2026, 5, 8, 23);
    await database.createRecordedNight(
      startedAt: startedAt,
      endedAt: startedAt,
    );

    await controller.initialize();

    expect(controller.nights, isEmpty);
  });

  test('allows unlocked users past the free monthly limit', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final controller = _buildController(
      database: database,
      recorder: recorder,
      unlockRepository: _FakeUnlockRepository(isUnlocked: true),
    );
    addTearDown(controller.dispose);

    final now = DateTime.now();
    for (var i = 0; i < 7; i++) {
      await database.createRecordedNight(
        startedAt: DateTime(now.year, now.month, i + 1, 23),
        endedAt: DateTime(now.year, now.month, i + 2, 7),
        recordingPath: 'memory://night_$i.ogg',
      );
    }

    await controller.initialize();
    await controller.startRecording();

    expect(recorder.startCalls, 1);
    expect(controller.recordingSession.status, RecordingStatus.recording);
  });

  test(
    'starts and stops the foreground notification around recording',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final recorder = _CountingSleepRecorder();
      final foregroundService = _FakeRecordingForegroundService();
      final controller = _buildController(
        database: database,
        recorder: recorder,
        foregroundService: foregroundService,
      );
      addTearDown(controller.dispose);

      await controller.initialize();
      await controller.startRecording();
      await controller.stopRecording();

      expect(foregroundService.configureCalls, 1);
      expect(foregroundService.startCalls, 1);
      expect(foregroundService.stopCalls, greaterThanOrEqualTo(1));
      expect(controller.nights, hasLength(1));
    },
  );

  test('saves locally detected audio events and snore count', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final analyzer = _FakeSleepEventAnalyzer(
      result: SleepAnalysisResult(
        snoreScore: 1,
        events: [
          AnalyzedSleepEvent(
            kind: SleepEventKind.snore,
            startsAt: DateTime(2026, 5, 7, 23, 42),
            duration: const Duration(seconds: 8),
            intensity: 72,
            filePath: 'memory://recording.wav',
          ),
        ],
      ),
    );
    final controller = _buildController(
      database: database,
      recorder: recorder,
      sleepEventAnalyzer: analyzer,
    );
    addTearDown(controller.dispose);

    await controller.initialize();
    await controller.startRecording();
    recorder.emitPowerFrame(
      const RecordingPowerFrame(elapsed: Duration(seconds: 12), decibels: 64),
    );
    await controller.stopRecording();

    expect(analyzer.framesSeen, hasLength(1));
    expect(controller.nights.single.snoreCount, 1);
    expect(controller.nights.single.events.single.kind, SleepEventKind.snore);
    expect(controller.nights.single.recordingPath, isNull);
    expect(controller.nights.single.events.single.filePath, contains('clip'));
    expect(controller.statusMessage, contains('1 local audio clips'));
  });

  test('stores subsecond event clips as at least one visible second', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final nightId = await database.createRecordedNight(
      startedAt: DateTime(2026, 5, 8, 18, 48),
      endedAt: DateTime(2026, 5, 8, 18, 49),
    );

    await database.addDetectedEvent(
      nightId: nightId,
      kind: SleepEventKind.snore,
      startsAt: DateTime(2026, 5, 8, 18, 48, 5),
      duration: const Duration(milliseconds: 640),
      intensity: 90,
      filePath: 'memory://short.wav',
    );

    final nights = await database.fetchRecentSleepNights();

    expect(nights.single.events.single.duration, const Duration(seconds: 1));
  });

  test('rotates chunks and keeps only event clips', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final analyzer = _FakeSleepEventAnalyzer(
      result: SleepAnalysisResult(
        snoreScore: 1,
        events: [
          AnalyzedSleepEvent(
            kind: SleepEventKind.snore,
            startsAt: DateTime(2026, 5, 7, 23, 30, 2),
            duration: const Duration(seconds: 4),
            intensity: 74,
            filePath: 'memory://source.wav',
          ),
        ],
      ),
    );
    final clipStore = _FakeAudioEventClipStore();
    final controller = _buildController(
      database: database,
      recorder: recorder,
      sleepEventAnalyzer: analyzer,
      audioEventClipStore: clipStore,
      recordingChunkDuration: const Duration(milliseconds: 20),
    );
    addTearDown(controller.dispose);

    await controller.initialize();
    await controller.startRecording();
    recorder.emitPowerFrame(
      const RecordingPowerFrame(elapsed: Duration(seconds: 1), decibels: 72),
    );
    await Future<void>.delayed(const Duration(milliseconds: 80));
    recorder.emitPowerFrame(
      const RecordingPowerFrame(elapsed: Duration(seconds: 1), decibels: 76),
    );
    await controller.stopRecording();

    expect(recorder.startCalls, greaterThanOrEqualTo(2));
    expect(recorder.stopCalls, greaterThanOrEqualTo(2));
    expect(controller.nights.single.recordingPath, isNull);
    expect(controller.nights.single.events, isNotEmpty);
    expect(
      controller.nights.single.events.map((event) => event.filePath),
      everyElement(startsWith('memory://clip_')),
    );
    expect(clipStore.sourcePaths.length, greaterThanOrEqualTo(2));
  });

  test('clears playback state when an event clip finishes', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final audioPlayback = _FakeAudioPlayback();
    final controller = _buildController(
      database: database,
      recorder: recorder,
      audioPlayback: audioPlayback,
    );
    addTearDown(controller.dispose);

    await controller.initialize();
    await controller.playAudio(
      'memory://clip.wav',
      playbackKey: 'event:1:memory://clip.wav',
    );

    expect(controller.playingAudioKey, 'event:1:memory://clip.wav');

    audioPlayback.onFinished?.call();

    expect(controller.playingPath, isNull);
    expect(controller.playingAudioKey, isNull);
    expect(controller.statusMessage, 'Playback finished.');
  });

  test('streams live power frames while recording', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final controller = _buildController(database: database, recorder: recorder);
    addTearDown(controller.dispose);

    await controller.initialize();
    await controller.startRecording();

    recorder.emitPowerFrame(
      const RecordingPowerFrame(
        elapsed: Duration(milliseconds: 160),
        decibels: 18,
      ),
    );
    recorder.emitPowerFrame(
      const RecordingPowerFrame(
        elapsed: Duration(milliseconds: 320),
        decibels: 62,
      ),
    );

    expect(controller.livePowerFrames.map((frame) => frame.decibels), [18, 62]);

    await controller.stopRecording();

    expect(controller.livePowerFrames, isEmpty);
  });

  test('stops recorder when foreground notification cannot start', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final foregroundService = _FakeRecordingForegroundService(
      startResult: false,
    );
    final controller = _buildController(
      database: database,
      recorder: recorder,
      foregroundService: foregroundService,
    );
    addTearDown(controller.dispose);

    await controller.initialize();
    await controller.startRecording();

    expect(recorder.startCalls, 1);
    expect(recorder.stopCalls, 1);
    expect(controller.recordingSession.status, RecordingStatus.idle);
    expect(controller.nights, isEmpty);
    expect(controller.statusMessage, contains('notification'));
  });

  test('deletes a saved night and its local recording file', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final recorder = _CountingSleepRecorder();
    final controller = _buildController(database: database, recorder: recorder);
    final tempDirectory = await Directory.systemTemp.createTemp('snorvy_test_');
    addTearDown(() async {
      controller.dispose();
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    final recordingFile = File(
      '${tempDirectory.path}${Platform.pathSeparator}night.ogg',
    );
    await recordingFile.writeAsString('fake audio');
    await database.createRecordedNight(
      startedAt: DateTime(2026, 5, 6, 23),
      endedAt: DateTime(2026, 5, 7, 7),
      recordingPath: recordingFile.path,
    );

    await controller.initialize();
    await controller.deleteNight(controller.nights.single);

    expect(controller.nights, isEmpty);
    expect(await recordingFile.exists(), isFalse);
    expect(controller.statusMessage, 'Night deleted from this phone.');
  });
}

SnorvyController _buildController({
  required AppDatabase database,
  required _CountingSleepRecorder recorder,
  RecordingForegroundService? foregroundService,
  SleepEventAnalyzer? sleepEventAnalyzer,
  AudioEventClipStore? audioEventClipStore,
  AudioPlayback? audioPlayback,
  UnlockRepository? unlockRepository,
  Duration recordingChunkDuration = const Duration(minutes: 15),
}) {
  return SnorvyController(
    database: database,
    recorder: recorder,
    audioEventClipStore: audioEventClipStore ?? _FakeAudioEventClipStore(),
    audioPlayback: audioPlayback ?? _FakeAudioPlayback(),
    recordingExporter: _FakeRecordingExporter(),
    recordingForegroundService:
        foregroundService ?? _FakeRecordingForegroundService(),
    sleepEventAnalyzer: sleepEventAnalyzer ?? const _EmptySleepEventAnalyzer(),
    bedtimeReminderRepository: BedtimeReminderRepository.inMemory(),
    bedtimeReminderScheduler: BedtimeReminderScheduler.noop(),
    unlockRepository: unlockRepository ?? _FakeUnlockRepository(),
    recordingChunkDuration: recordingChunkDuration,
  );
}

class _CountingSleepRecorder implements SleepRecorder {
  final StreamController<RecordingPowerFrame> _powerFrames =
      StreamController<RecordingPowerFrame>.broadcast(sync: true);
  int startCalls = 0;
  int stopCalls = 0;
  RecordingSession _session = const RecordingSession(
    status: RecordingStatus.idle,
  );

  @override
  Stream<RecordingPowerFrame> get powerFrames => _powerFrames.stream;

  void emitPowerFrame(RecordingPowerFrame frame) {
    _powerFrames.add(frame);
  }

  @override
  Future<RecordingSession> startNightRecording() async {
    startCalls += 1;
    _session = RecordingSession(
      status: RecordingStatus.recording,
      filePath: 'memory://recording_$startCalls.wav',
      startedAt: DateTime(
        2026,
        5,
        7,
        23,
        30,
      ).add(Duration(minutes: 15 * (startCalls - 1))),
    );
    return _session;
  }

  @override
  Future<RecordingSession> stopNightRecording() async {
    stopCalls += 1;
    _session = RecordingSession(
      status: RecordingStatus.idle,
      filePath: _session.filePath,
      startedAt: _session.startedAt,
    );
    return _session;
  }

  @override
  Future<void> dispose() async {
    await _powerFrames.close();
  }
}

class _EmptySleepEventAnalyzer implements SleepEventAnalyzer {
  const _EmptySleepEventAnalyzer();

  @override
  SleepAnalysisResult analyzeFrames({
    required List<RecordingPowerFrame> frames,
    required DateTime startedAt,
    required DateTime endedAt,
    required String recordingPath,
  }) {
    return SleepAnalysisResult.empty;
  }
}

class _FakeSleepEventAnalyzer implements SleepEventAnalyzer {
  _FakeSleepEventAnalyzer({required this.result});

  final SleepAnalysisResult result;
  List<RecordingPowerFrame> framesSeen = const [];

  @override
  SleepAnalysisResult analyzeFrames({
    required List<RecordingPowerFrame> frames,
    required DateTime startedAt,
    required DateTime endedAt,
    required String recordingPath,
  }) {
    framesSeen = frames;
    return result;
  }
}

class _FakeAudioEventClipStore implements AudioEventClipStore {
  final List<String> sourcePaths = [];
  var _nextClipId = 0;

  @override
  Future<void> deleteStaleSourceChunks() async {}

  @override
  Future<List<AnalyzedSleepEvent>> saveEventClips({
    required String sourcePath,
    required DateTime chunkStartedAt,
    required DateTime chunkEndedAt,
    required List<AnalyzedSleepEvent> events,
    required Duration preRoll,
    required Duration postRoll,
  }) async {
    sourcePaths.add(sourcePath);
    return [
      for (final event in events)
        AnalyzedSleepEvent(
          kind: event.kind,
          startsAt: event.startsAt,
          duration: event.duration,
          intensity: event.intensity,
          filePath: 'memory://clip_${_nextClipId++}.wav',
        ),
    ];
  }
}

class _FakeRecordingForegroundService implements RecordingForegroundService {
  _FakeRecordingForegroundService({this.startResult = true});

  final bool startResult;
  int configureCalls = 0;
  int startCalls = 0;
  int stopCalls = 0;

  @override
  Future<void> configure() async {
    configureCalls += 1;
  }

  @override
  Future<bool> startRecordingNotification({DateTime? startedAt}) async {
    startCalls += 1;
    return startResult;
  }

  @override
  Future<void> stopRecordingNotification() async {
    stopCalls += 1;
  }
}

class _FakeAudioPlayback implements AudioPlayback {
  void Function()? onFinished;

  @override
  Future<void> playFile(String filePath, {void Function()? onFinished}) async {
    this.onFinished = onFinished;
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

class _FakeRecordingExporter implements RecordingExporter {
  @override
  Future<String> exportRecording(String sourcePath) async {
    return 'memory://export.ogg';
  }
}

class _FakeUnlockRepository implements UnlockRepository {
  _FakeUnlockRepository({bool isUnlocked = false})
    : _state = UnlockState(
        isUnlocked: isUnlocked,
        isPending: false,
        isStoreAvailable: true,
        productConfigured: true,
        priceLabel: '\$9.99',
      );

  final StreamController<UnlockState> _updates =
      StreamController<UnlockState>.broadcast();
  UnlockState _state;

  @override
  Stream<UnlockState> get updates => _updates.stream;

  @override
  Future<UnlockState> load() async {
    return _state;
  }

  @override
  Future<void> buyLifetimeUnlock() async {
    _state = _state.copyWith(isUnlocked: true, message: 'Unlocked');
    _updates.add(_state);
  }

  @override
  Future<void> restorePurchases() async {
    _updates.add(_state);
  }

  @override
  Future<void> dispose() async {
    await _updates.close();
  }
}
