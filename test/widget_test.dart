import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snorvy/src/app/snorvy_app.dart';
import 'package:snorvy/src/app/snorvy_controller.dart';
import 'package:snorvy/src/data/app_database.dart';
import 'package:snorvy/src/services/audio_playback.dart';
import 'package:snorvy/src/services/recording_exporter.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';

void main() {
  testWidgets('shows the Snorvy tonight surface', (tester) async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    expect(find.text('Snorvy'), findsWidgets);
    expect(find.text('Ready for tonight'), findsOneWidget);
    expect(find.text('Start local recording'), findsOneWidget);
    expect(find.text('No subscription. No trial.'), findsNothing);
  });

  testWidgets('persists a manual sleep log into history', (tester) async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add manual sleep log'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save log'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.textContaining('manual log'), findsOneWidget);
  });
}

SnorvyController _buildController() {
  return SnorvyController(
    database: AppDatabase(NativeDatabase.memory()),
    recorder: _FakeSleepRecorder(),
    audioPlayback: _FakeAudioPlayback(),
    recordingExporter: _FakeRecordingExporter(),
  );
}

class _FakeSleepRecorder implements SleepRecorder {
  RecordingSession _session = const RecordingSession(
    status: RecordingStatus.idle,
  );

  @override
  Future<RecordingSession> startNightRecording() async {
    _session = RecordingSession(
      status: RecordingStatus.recording,
      filePath: 'memory://night.ogg',
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
