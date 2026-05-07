import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:snorvy/src/data/app_database.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';

class SnorvyController extends ChangeNotifier {
  SnorvyController({
    required AppDatabase database,
    required SleepRecorder recorder,
  }) : _database = database,
       _recorder = recorder;

  factory SnorvyController.production() {
    return SnorvyController(
      database: AppDatabase.defaults(),
      recorder: FlutterSoundSleepRecorder(),
    );
  }

  final AppDatabase _database;
  final SleepRecorder _recorder;

  List<SleepNight> _nights = const [];
  RecordingSession _recordingSession = const RecordingSession(
    status: RecordingStatus.idle,
  );
  bool _isBusy = false;
  bool _isLoading = true;
  String? _statusMessage;

  List<SleepNight> get nights => List.unmodifiable(_nights);
  RecordingSession get recordingSession => _recordingSession;
  bool get isBusy => _isBusy;
  bool get isLoading => _isLoading;
  String? get statusMessage => _statusMessage;

  Future<void> initialize() async {
    await _loadNights();
  }

  Future<void> startRecording() async {
    if (_isBusy || _recordingSession.status == RecordingStatus.recording) {
      return;
    }

    _setBusy(true);
    try {
      final session = await _recorder.startNightRecording();
      _recordingSession = session;
      _statusMessage = switch (session.status) {
        RecordingStatus.permissionDenied =>
          'Microphone permission is needed for overnight recording.',
        RecordingStatus.recording =>
          'Recording started. Audio stays on device.',
        RecordingStatus.idle => null,
      };
    } on Exception {
      _statusMessage = 'Could not start the recorder.';
    } finally {
      _setBusy(false);
    }
  }

  Future<void> stopRecording() async {
    if (_isBusy || _recordingSession.status != RecordingStatus.recording) {
      return;
    }

    _setBusy(true);
    try {
      final startedAt = _recordingSession.startedAt;
      final filePath = _recordingSession.filePath;
      final stoppedSession = await _recorder.stopNightRecording();
      _recordingSession = stoppedSession;

      if (startedAt != null && filePath != null) {
        await _database.createRecordedNight(
          startedAt: startedAt,
          endedAt: DateTime.now(),
          recordingPath: filePath,
        );
        _statusMessage = 'Night recording saved locally.';
        await _loadNights(notify: false);
      }
    } on Exception {
      _statusMessage = 'Could not stop and save the recording.';
    } finally {
      _setBusy(false);
    }
  }

  Future<void> addDefaultManualLog() async {
    if (_isBusy) {
      return;
    }

    _setBusy(true);
    try {
      final now = DateTime.now();
      final endedAt = DateTime(now.year, now.month, now.day, 7, 15);
      final startedAt = endedAt.subtract(const Duration(hours: 7, minutes: 45));

      await _database.createManualNight(
        startedAt: startedAt,
        endedAt: endedAt,
        notes: 'Manual sleep log',
      );
      _statusMessage = 'Manual sleep log saved locally.';
      await _loadNights(notify: false);
    } on Exception {
      _statusMessage = 'Could not save the manual log.';
    } finally {
      _setBusy(false);
    }
  }

  Future<void> _loadNights({bool notify = true}) async {
    _nights = await _database.fetchRecentSleepNights();
    _isLoading = false;

    if (notify) {
      notifyListeners();
    }
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_database.close());
    super.dispose();
  }
}
