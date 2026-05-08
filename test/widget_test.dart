import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snorvy/src/app/snorvy_app.dart';
import 'package:snorvy/src/app/snorvy_controller.dart';
import 'package:snorvy/src/data/app_database.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/audio_playback.dart';
import 'package:snorvy/src/services/recording_foreground_service.dart';
import 'package:snorvy/src/services/recording_exporter.dart';
import 'package:snorvy/src/services/sleep_event_analyzer.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';
import 'package:snorvy/src/services/unlock_repository.dart';

void main() {
  testWidgets('shows the Snorvy tonight surface', (tester) async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    expect(
      find.image(const AssetImage('assets/brand/snorvy_logo.png')),
      findsNothing,
    );
    expect(
      find.image(
        const AssetImage('assets/brand/snorvy_logo_text_trans_background.png'),
      ),
      findsOneWidget,
    );
    expect(find.text('Ready for tonight'), findsOneWidget);
    expect(find.text('Start local recording'), findsOneWidget);
    expect(find.text('No subscription. No trial.'), findsNothing);
  });

  testWidgets('keeps full recording inside the Full audio tab', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final startedAt = DateTime(2026, 5, 8, 0, 12);
    final nightId = await database.createRecordedNight(
      startedAt: startedAt,
      endedAt: startedAt.add(const Duration(seconds: 60)),
      recordingPath: 'memory://night.m4a',
    );
    await database.addDetectedEvent(
      nightId: nightId,
      kind: SleepEventKind.snore,
      startsAt: startedAt.add(const Duration(seconds: 10)),
      duration: const Duration(seconds: 8),
      intensity: 70,
      filePath: 'memory://night.m4a',
    );
    final controller = _buildController(database: database);
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    expect(find.text('Full-night recording'), findsNothing);
    expect(find.text('Snore (1)'), findsOneWidget);

    final fullAudioChip = tester.widget<FilterChip>(
      find.widgetWithText(FilterChip, 'Full audio'),
    );
    fullAudioChip.onSelected?.call(true);
    await tester.pumpAndSettle();

    expect(find.text('Full-night recording'), findsOneWidget);
  });

  testWidgets('persists a manual sleep log into history', (tester) async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    await _tapDestination(tester, Icons.tune_outlined);
    final addManualLogButton = find.text('Add manual sleep log');
    await _scrollUntilVisible(tester, addManualLogButton);
    await tester.pumpAndSettle();
    await tester.tap(addManualLogButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save log'));
    await tester.pumpAndSettle();
    await _tapDestination(tester, Icons.insights_outlined);

    expect(find.textContaining('manual log'), findsOneWidget);
  });

  testWidgets('starts recording from tonight controls', (tester) async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    await _tapStartRecording(tester);

    expect(find.widgetWithText(FilledButton, 'Stop recording'), findsOneWidget);

    final stopButton = find.widgetWithIcon(FilledButton, Icons.stop);
    expect(stopButton, findsOneWidget);
  });

  testWidgets('advances the live recording timer', (tester) async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    await _tapStartRecording(tester);
    expect(find.text('00:00'), findsOneWidget);

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 1100)),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:01'), findsOneWidget);
  });

  testWidgets('does not include recorder startup delay in elapsed time', (
    tester,
  ) async {
    final controller = _buildController(
      recorder: _FakeSleepRecorder(startDelay: const Duration(seconds: 9)),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    await _tapStartRecording(tester);
    await tester.pump(const Duration(seconds: 9));
    await tester.pumpAndSettle();

    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('deletes a manual sleep log from history', (tester) async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    await _tapDestination(tester, Icons.tune_outlined);
    final addManualLogButton = find.text('Add manual sleep log');
    await _scrollUntilVisible(tester, addManualLogButton);
    await tester.pumpAndSettle();
    await tester.tap(addManualLogButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save log'));
    await tester.pumpAndSettle();
    await _pumpControllerIdle(tester, controller);
    await _tapDestination(tester, Icons.insights_outlined);
    expect(find.text('History.'), findsOneWidget);

    await controller.deleteNight(controller.nights.single);
    await tester.pumpAndSettle();

    expect(
      find.text('No nights saved yet. Record or add a manual log.'),
      findsOneWidget,
    );
  });

  testWidgets('opens privacy policy text from settings', (tester) async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(SnorvyApp(controller: controller));
    await tester.pumpAndSettle();

    await _tapDestination(tester, Icons.tune_outlined);
    final privacyPolicyRow = find.text('Privacy policy');
    await tester.ensureVisible(privacyPolicyRow);
    await tester.pumpAndSettle();
    await tester.tap(privacyPolicyRow);
    await tester.pumpAndSettle();

    expect(find.text('Snorvy Privacy Policy'), findsOneWidget);
    expect(find.textContaining('local-only sleep recorder'), findsOneWidget);
    expect(find.textContaining('support@snorvy.app'), findsOneWidget);
  });
}

Future<void> _scrollUntilVisible(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    160,
    scrollable: find.byType(Scrollable).first,
  );
}

Future<void> _tapDestination(WidgetTester tester, IconData icon) async {
  final index = switch (icon) {
    Icons.bedtime_outlined => 0,
    Icons.insights_outlined => 1,
    Icons.tune_outlined => 2,
    _ => throw ArgumentError('Unknown destination icon: $icon'),
  };
  final size = tester.view.physicalSize / tester.view.devicePixelRatio;
  await tester.tapAt(Offset((index + 0.5) * size.width / 3, size.height - 42));
  await tester.pumpAndSettle();
}

Future<void> _tapStartRecording(WidgetTester tester) async {
  final startButton = find.widgetWithText(
    FilledButton,
    'Start local recording',
  );
  await tester.ensureVisible(startButton);
  await tester.pumpAndSettle();
  await tester.tap(startButton);
  await tester.pumpAndSettle();
}

Future<void> _pumpControllerIdle(
  WidgetTester tester,
  SnorvyController controller,
) async {
  for (var i = 0; i < 20 && controller.isBusy; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pumpAndSettle();
}

SnorvyController _buildController({
  SleepRecorder? recorder,
  AppDatabase? database,
}) {
  return SnorvyController(
    database: database ?? AppDatabase(NativeDatabase.memory()),
    recorder: recorder ?? _FakeSleepRecorder(),
    audioPlayback: _FakeAudioPlayback(),
    recordingExporter: _FakeRecordingExporter(),
    recordingForegroundService: const NoopRecordingForegroundService(),
    sleepEventAnalyzer: const _EmptySleepEventAnalyzer(),
    unlockRepository: _FakeUnlockRepository(),
  );
}

class _FakeSleepRecorder implements SleepRecorder {
  _FakeSleepRecorder({this.startDelay = Duration.zero});

  final Duration startDelay;
  final StreamController<RecordingPowerFrame> _powerFrames =
      StreamController<RecordingPowerFrame>.broadcast();
  RecordingSession _session = const RecordingSession(
    status: RecordingStatus.idle,
  );

  @override
  Stream<RecordingPowerFrame> get powerFrames => _powerFrames.stream;

  @override
  Future<RecordingSession> startNightRecording() async {
    if (startDelay > Duration.zero) {
      await Future<void>.delayed(startDelay);
    }

    _session = RecordingSession(
      status: RecordingStatus.recording,
      filePath: 'memory://night.ogg',
      startedAt: DateTime.now(),
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
  final StreamController<UnlockState> _updates =
      StreamController<UnlockState>.broadcast();
  UnlockState _state = const UnlockState.initial();

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
