import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snorvy/src/app/snorvy_controller.dart';
import 'package:snorvy/src/data/app_database.dart';
import 'package:snorvy/src/services/audio_playback.dart';
import 'package:snorvy/src/services/recording_exporter.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';
import 'package:snorvy/src/services/unlock_repository.dart';

void main() {
  test('blocks free users after 7 recordings in the current month', () async {
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
    expect(controller.statusMessage, contains('7 recordings/month'));
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
  UnlockRepository? unlockRepository,
}) {
  return SnorvyController(
    database: database,
    recorder: recorder,
    audioPlayback: _FakeAudioPlayback(),
    recordingExporter: _FakeRecordingExporter(),
    unlockRepository: unlockRepository ?? _FakeUnlockRepository(),
  );
}

class _CountingSleepRecorder implements SleepRecorder {
  int startCalls = 0;
  RecordingSession _session = const RecordingSession(
    status: RecordingStatus.idle,
  );

  @override
  Future<RecordingSession> startNightRecording() async {
    startCalls += 1;
    _session = RecordingSession(
      status: RecordingStatus.recording,
      filePath: 'memory://recording.ogg',
      startedAt: DateTime(2026, 5, 7, 23, 30),
    );
    return _session;
  }

  @override
  Future<RecordingSession> stopNightRecording() async {
    _session = RecordingSession(
      status: RecordingStatus.idle,
      filePath: _session.filePath,
      startedAt: _session.startedAt,
    );
    return _session;
  }
}

class _FakeAudioPlayback implements AudioPlayback {
  @override
  Future<void> playFile(String filePath) async {}

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
