import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:snorvy/src/data/app_database.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/audio_playback.dart';
import 'package:snorvy/src/services/recording_exporter.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';
import 'package:snorvy/src/services/unlock_repository.dart';

class SnorvyController extends ChangeNotifier {
  SnorvyController({
    required AppDatabase database,
    required SleepRecorder recorder,
    required AudioPlayback audioPlayback,
    required RecordingExporter recordingExporter,
    required UnlockRepository unlockRepository,
  }) : _database = database,
       _recorder = recorder,
       _audioPlayback = audioPlayback,
       _recordingExporter = recordingExporter,
       _unlockRepository = unlockRepository;

  factory SnorvyController.production() {
    return SnorvyController(
      database: AppDatabase.defaults(),
      recorder: FlutterSoundSleepRecorder(),
      audioPlayback: FlutterSoundAudioPlayback(),
      recordingExporter: LocalRecordingExporter(),
      unlockRepository: InAppPurchaseUnlockRepository(),
    );
  }

  final AppDatabase _database;
  final SleepRecorder _recorder;
  final AudioPlayback _audioPlayback;
  final RecordingExporter _recordingExporter;
  final UnlockRepository _unlockRepository;
  StreamSubscription<UnlockState>? _unlockSubscription;

  List<SleepNight> _nights = const [];
  RecordingSession _recordingSession = const RecordingSession(
    status: RecordingStatus.idle,
  );
  bool _isBusy = false;
  bool _isLoading = true;
  String? _playingPath;
  UnlockState _unlockState = const UnlockState.initial();
  String? _statusMessage;

  List<SleepNight> get nights => List.unmodifiable(_nights);
  RecordingSession get recordingSession => _recordingSession;
  bool get isBusy => _isBusy;
  bool get isLoading => _isLoading;
  String? get playingPath => _playingPath;
  UnlockState get unlockState => _unlockState;
  int get recordingsThisMonth {
    final now = DateTime.now();
    return _nights
        .where(
          (night) =>
              !night.isManual &&
              night.recordingPath != null &&
              night.date.year == now.year &&
              night.date.month == now.month,
        )
        .length;
  }

  String? get statusMessage => _statusMessage;

  Future<void> initialize() async {
    _unlockSubscription = _unlockRepository.updates.listen((state) {
      _unlockState = state;
      notifyListeners();
    });

    _unlockState = await _unlockRepository.load();
    await _loadNights();
  }

  Future<void> startRecording() async {
    if (_isBusy || _recordingSession.status == RecordingStatus.recording) {
      return;
    }

    _setBusy(true);
    try {
      final recordedThisMonth = await _database.countRecordedNightsForMonth(
        DateTime.now(),
      );
      if (!_unlockState.isUnlocked && recordedThisMonth >= 7) {
        _statusMessage =
            'Free plan includes 7 recordings/month. Unlock once for unlimited nights.';
        return;
      }

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

  Future<void> playAudio(String filePath) async {
    if (_isBusy) {
      return;
    }

    _setBusy(true);
    try {
      await _audioPlayback.playFile(filePath);
      _playingPath = filePath;
      _statusMessage = 'Playing saved audio from this phone.';
    } on FileSystemException {
      _statusMessage = 'Audio file is no longer on this phone.';
    } on Exception {
      _statusMessage = 'Could not play this recording.';
    } finally {
      _setBusy(false);
    }
  }

  Future<void> stopAudio() async {
    if (_isBusy || _playingPath == null) {
      return;
    }

    _setBusy(true);
    try {
      await _audioPlayback.stop();
      _playingPath = null;
      _statusMessage = 'Playback stopped.';
    } on Exception {
      _statusMessage = 'Could not stop playback.';
    } finally {
      _setBusy(false);
    }
  }

  Future<void> exportAudio(String filePath) async {
    if (_isBusy) {
      return;
    }

    _setBusy(true);
    try {
      final exportedPath = await _recordingExporter.exportRecording(filePath);
      _statusMessage = 'Exported audio to $exportedPath';
    } on FileSystemException {
      _statusMessage = 'Audio file is no longer on this phone.';
    } on Exception {
      _statusMessage = 'Could not export this recording.';
    } finally {
      _setBusy(false);
    }
  }

  Future<void> buyLifetimeUnlock() async {
    if (_isBusy) {
      return;
    }

    _setBusy(true);
    try {
      await _unlockRepository.buyLifetimeUnlock();
    } on Exception {
      _statusMessage = 'Could not start the purchase.';
    } finally {
      _setBusy(false);
    }
  }

  Future<void> restorePurchases() async {
    if (_isBusy) {
      return;
    }

    _setBusy(true);
    try {
      await _unlockRepository.restorePurchases();
    } on Exception {
      _statusMessage = 'Could not restore purchases.';
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
    unawaited(_unlockSubscription?.cancel());
    unawaited(_unlockRepository.dispose());
    unawaited(_audioPlayback.dispose());
    unawaited(_database.close());
    super.dispose();
  }
}
