import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:snorvy/src/data/app_database.dart';
import 'package:snorvy/src/domain/bedtime_reminder.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/audio_event_clip_store.dart';
import 'package:snorvy/src/services/audio_playback.dart';
import 'package:snorvy/src/services/bedtime_reminder_repository.dart';
import 'package:snorvy/src/services/bedtime_reminder_scheduler.dart';
import 'package:snorvy/src/services/recording_foreground_service.dart';
import 'package:snorvy/src/services/ml/ml_sleep_event_analyzer.dart';
import 'package:snorvy/src/services/recording_exporter.dart';
import 'package:snorvy/src/services/sleep_event_analyzer.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';
import 'package:snorvy/src/services/unlock_repository.dart';

const _minimumQuotaRecordingDuration = Duration(minutes: 20);
const _maxLivePowerFrames = 48;
const _defaultRecordingChunkDuration = Duration(minutes: 15);
const _eventClipPreRoll = Duration(seconds: 2);
const _eventClipPostRoll = Duration(seconds: 2);

class SnorvyController extends ChangeNotifier {
  SnorvyController({
    required AppDatabase database,
    required SleepRecorder recorder,
    required AudioEventClipStore audioEventClipStore,
    required AudioPlayback audioPlayback,
    required RecordingExporter recordingExporter,
    required RecordingForegroundService recordingForegroundService,
    required SleepEventAnalyzer sleepEventAnalyzer,
    required UnlockRepository unlockRepository,
    required BedtimeReminderRepository bedtimeReminderRepository,
    required BedtimeReminderScheduler bedtimeReminderScheduler,
    Duration recordingChunkDuration = _defaultRecordingChunkDuration,
  }) : _database = database,
       _recorder = recorder,
       _audioEventClipStore = audioEventClipStore,
       _audioPlayback = audioPlayback,
       _recordingExporter = recordingExporter,
       _recordingForegroundService = recordingForegroundService,
       _sleepEventAnalyzer = sleepEventAnalyzer,
       _unlockRepository = unlockRepository,
       _bedtimeReminderRepository = bedtimeReminderRepository,
       _bedtimeReminderScheduler = bedtimeReminderScheduler,
       _recordingChunkDuration = recordingChunkDuration;

  factory SnorvyController.production() {
    return SnorvyController(
      database: AppDatabase.defaults(),
      recorder: FlutterSoundSleepRecorder(),
      audioEventClipStore: const WavAudioEventClipStore(),
      audioPlayback: FlutterSoundAudioPlayback(),
      recordingExporter: LocalRecordingExporter(),
      recordingForegroundService: createRecordingForegroundService(),
      sleepEventAnalyzer: _defaultSleepEventAnalyzer(),
      unlockRepository: createUnlockRepository(),
      bedtimeReminderRepository:
          BedtimeReminderRepository.sharedPreferences(),
      bedtimeReminderScheduler: BedtimeReminderScheduler(),
    );
  }

  final AppDatabase _database;
  final SleepRecorder _recorder;
  final AudioEventClipStore _audioEventClipStore;
  final AudioPlayback _audioPlayback;
  final RecordingExporter _recordingExporter;
  final RecordingForegroundService _recordingForegroundService;
  final SleepEventAnalyzer _sleepEventAnalyzer;
  final UnlockRepository _unlockRepository;
  final BedtimeReminderRepository _bedtimeReminderRepository;
  final BedtimeReminderScheduler _bedtimeReminderScheduler;
  final Duration _recordingChunkDuration;
  BedtimeReminder _bedtimeReminder = BedtimeReminder.defaults;
  StreamSubscription<UnlockState>? _unlockSubscription;
  StreamSubscription<RecordingPowerFrame>? _powerFrameSubscription;
  Timer? _chunkRotationTimer;
  Future<void> _chunkProcessing = Future<void>.value();
  final List<RecordingPowerFrame> _recordingPowerFrames = [];
  List<RecordingPowerFrame> _livePowerFrames = const [];

  List<SleepNight> _nights = const [];
  RecordingSession _recordingSession = const RecordingSession(
    status: RecordingStatus.idle,
  );
  bool _isBusy = false;
  bool _isLoading = true;
  bool _isRotatingChunk = false;
  int? _activeNightId;
  DateTime? _activeNightStartedAt;
  DateTime? _currentChunkStartedAt;
  String? _currentChunkPath;
  int _activeSavedEventCount = 0;
  int _activeSnoreCount = 0;
  String? _playingPath;
  String? _playingAudioKey;
  UnlockState _unlockState = const UnlockState.initial();
  String? _statusMessage;

  List<SleepNight> get nights => List.unmodifiable(_nights);
  RecordingSession get recordingSession => _recordingSession;
  bool get isBusy => _isBusy;
  bool get isLoading => _isLoading;
  String? get playingPath => _playingPath;
  String? get playingAudioKey => _playingAudioKey;
  UnlockState get unlockState => _unlockState;
  List<RecordingPowerFrame> get livePowerFrames =>
      List.unmodifiable(_livePowerFrames);
  int get recordingsThisMonth {
    final now = DateTime.now();
    return _billableSleepDatesForMonth(now, _nights).length;
  }

  String? get statusMessage => _statusMessage;

  BedtimeReminder get bedtimeReminder => _bedtimeReminder;

  Future<void> initialize() async {
    _unlockSubscription = _unlockRepository.updates.listen((state) {
      _unlockState = state;
      notifyListeners();
    });

    _unlockState = await _unlockRepository.load();
    try {
      await _recordingForegroundService.configure();
    } on Exception {
      _statusMessage = 'Overnight recording notification setup failed.';
    }
    try {
      await _audioEventClipStore.deleteStaleSourceChunks();
      await _database.deleteIncompleteRecordedNights();
    } on Exception {
      _statusMessage = 'Could not clean old temporary audio chunks.';
    }
    try {
      _bedtimeReminder = await _bedtimeReminderRepository.load();
    } on Exception {
      _bedtimeReminder = BedtimeReminder.defaults;
    }
    try {
      await _bedtimeReminderScheduler.initialize();
      await _bedtimeReminderScheduler.reschedule(_bedtimeReminder);
    } on Exception {
      _statusMessage = 'Could not schedule bedtime reminders.';
    }
    await _loadNights();
  }

  Future<void> fireBedtimeReminderTest() async {
    try {
      await _bedtimeReminderScheduler.fireTestNotification();
      _statusMessage = 'Test reminder will arrive in a few seconds.';
      notifyListeners();
    } on Exception {
      _statusMessage = 'Could not send the test reminder.';
      notifyListeners();
    }
  }

  Future<void> updateBedtimeReminder(BedtimeReminder reminder) async {
    if (reminder == _bedtimeReminder) return;
    _bedtimeReminder = reminder;
    notifyListeners();
    try {
      await _bedtimeReminderRepository.save(reminder);
    } on Exception {
      _statusMessage = 'Could not save the bedtime reminder.';
      notifyListeners();
    }
    try {
      await _bedtimeReminderScheduler.reschedule(reminder);
    } on Exception {
      _statusMessage = 'Could not schedule the bedtime reminder.';
      notifyListeners();
    }
  }

  Future<void> startRecording() async {
    if (_isBusy || _recordingSession.status == RecordingStatus.recording) {
      return;
    }

    _setBusy(true);
    try {
      final sleepDaysThisMonth = await _database.countRecordedSleepDaysForMonth(
        DateTime.now(),
        minimumDuration: _minimumQuotaRecordingDuration,
      );
      if (!_unlockState.isUnlocked && sleepDaysThisMonth >= 7) {
        _statusMessage =
            'Free plan includes 7 sleep days/month. Unlock once for unlimited nights.';
        return;
      }

      await _startCapturingPowerFrames();
      final session = await _recorder.startNightRecording();
      if (session.status != RecordingStatus.recording) {
        await _stopCapturingPowerFrames();
      }
      if (session.status == RecordingStatus.recording) {
        final foregroundStarted = await _startForegroundServiceOrStopRecorder(
          session,
        );
        if (!foregroundStarted) {
          _statusMessage =
              'Could not start the overnight recording notification.';
          return;
        }
      }

      if (session.status == RecordingStatus.recording &&
          session.startedAt != null &&
          session.filePath != null) {
        final nightId = await _database.createRecordedNight(
          startedAt: session.startedAt!,
          endedAt: session.startedAt!,
        );
        _activeNightId = nightId;
        _activeNightStartedAt = session.startedAt;
        _currentChunkStartedAt = session.startedAt;
        _currentChunkPath = session.filePath;
        _activeSavedEventCount = 0;
        _activeSnoreCount = 0;
        _scheduleChunkRotation();
        _recordingSession = RecordingSession(
          status: RecordingStatus.recording,
          filePath: session.filePath,
          startedAt: session.startedAt,
        );
        await _loadNights(notify: false);
      } else {
        _recordingSession = session;
      }
      _statusMessage = switch (session.status) {
        RecordingStatus.permissionDenied =>
          'Microphone permission is needed for overnight recording.',
        RecordingStatus.recording =>
          'Recording started. Raw audio is processed in 15-minute chunks.',
        RecordingStatus.idle => null,
      };
    } on Exception {
      try {
        final stoppedSession = await _recorder.stopNightRecording();
        final filePath = stoppedSession.filePath;
        if (filePath != null) {
          await _deleteLocalFiles([filePath]);
        }
      } on Exception {
        // The recorder may not have reached the native recording state yet.
      }
      try {
        await _recordingForegroundService.stopRecordingNotification();
      } on Exception {
        // Startup failure cleanup should keep the user-facing error focused.
      }
      await _stopCapturingPowerFrames();
      _clearActiveRecordingState();
      _statusMessage = 'Could not start the recorder.';
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> _startForegroundServiceOrStopRecorder(
    RecordingSession session,
  ) async {
    try {
      final foregroundStarted = await _recordingForegroundService
          .startRecordingNotification(startedAt: session.startedAt);
      if (foregroundStarted) {
        return true;
      }
    } on Exception {
      // The foreground notification is required for a trustworthy overnight
      // recording. Stop the mic session rather than silently recording without it.
    }

    final stoppedSession = await _recorder.stopNightRecording();
    final filePath = stoppedSession.filePath ?? session.filePath;
    if (filePath != null) {
      await _deleteLocalFiles([filePath]);
    }
    await _stopCapturingPowerFrames();
    _recordingSession = const RecordingSession(status: RecordingStatus.idle);
    return false;
  }

  Future<void> _stopForegroundNotificationSilently() async {
    try {
      await _recordingForegroundService.stopRecordingNotification();
    } on Exception {
      _statusMessage = 'Recording saved, but notification cleanup failed.';
    }
  }

  Future<void> stopRecording() async {
    if (_isBusy || _recordingSession.status != RecordingStatus.recording) {
      return;
    }

    _setBusy(true);
    try {
      _chunkRotationTimer?.cancel();
      await _waitForActiveRotation();
      final nightId = _activeNightId;
      final chunkStartedAt = _currentChunkStartedAt;
      final chunkPath = _currentChunkPath;
      final stoppedSession = await _recorder.stopNightRecording();
      final chunkEndedAt = DateTime.now();
      final frames = _takeCapturedPowerFrames();
      await _stopCapturingPowerFrames();
      await _stopForegroundNotificationSilently();
      _recordingSession = stoppedSession;

      if (nightId != null && chunkStartedAt != null && chunkPath != null) {
        await _enqueueFinishedChunk(
          nightId: nightId,
          chunkStartedAt: chunkStartedAt,
          chunkEndedAt: chunkEndedAt,
          chunkPath: chunkPath,
          frames: frames,
        );
        await _chunkProcessing;
        await _database.updateRecordedNightEnd(
          nightId: nightId,
          endedAt: chunkEndedAt,
        );
        _statusMessage = _activeSavedEventCount == 0
            ? 'Night saved locally. No loud snore or talk clips detected.'
            : 'Night saved with $_activeSavedEventCount local audio clips.';
        await _loadNights(notify: false);
      }
    } on Exception {
      await _stopCapturingPowerFrames();
      _statusMessage = 'Could not stop and save the recording.';
    } finally {
      _clearActiveRecordingState();
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

  Future<void> playAudio(String filePath, {String? playbackKey}) async {
    if (_isBusy) {
      return;
    }

    _setBusy(true);
    try {
      final audioKey = playbackKey ?? filePath;
      await _audioPlayback.playFile(
        filePath,
        onFinished: () =>
            _handlePlaybackFinished(filePath: filePath, playbackKey: audioKey),
      );
      _playingPath = filePath;
      _playingAudioKey = audioKey;
      _statusMessage = 'Playing saved audio from this phone.';
    } on FileSystemException {
      _statusMessage = 'Audio file is no longer on this phone.';
    } on Exception {
      _statusMessage = 'Could not play this recording.';
    } finally {
      _setBusy(false);
    }
  }

  void _handlePlaybackFinished({
    required String filePath,
    required String playbackKey,
  }) {
    if (_playingPath != filePath || _playingAudioKey != playbackKey) {
      return;
    }

    _playingPath = null;
    _playingAudioKey = null;
    _statusMessage = 'Playback finished.';
    notifyListeners();
  }

  Future<void> stopAudio() async {
    if (_isBusy || _playingPath == null) {
      return;
    }

    _setBusy(true);
    try {
      await _audioPlayback.stop();
      _playingPath = null;
      _playingAudioKey = null;
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

  Future<void> deleteNight(SleepNight night) async {
    if (_isBusy) {
      return;
    }

    _setBusy(true);
    try {
      await _stopAudioIfPlaying({
        ?night.recordingPath,
        for (final event in night.events) ?event.filePath,
      });

      final filePaths = await _database.deleteNight(night.id);
      final failedDeletes = await _deleteLocalFiles(filePaths);
      _statusMessage = failedDeletes == 0
          ? 'Night deleted from this phone.'
          : 'Night deleted, but some audio files could not be removed.';
      await _loadNights(notify: false);
    } on Exception {
      _statusMessage = 'Could not delete this night.';
    } finally {
      _setBusy(false);
    }
  }

  Future<void> deleteAllSleepData() async {
    if (_isBusy) {
      return;
    }
    if (_recordingSession.status == RecordingStatus.recording) {
      _statusMessage = 'Stop the active recording before deleting all data.';
      notifyListeners();
      return;
    }

    _setBusy(true);
    try {
      if (_playingPath != null) {
        await _audioPlayback.stop();
        _playingPath = null;
        _playingAudioKey = null;
      }

      final filePaths = await _database.deleteAllNights();
      final failedDeletes = await _deleteLocalFiles(filePaths);
      _statusMessage = failedDeletes == 0
          ? 'All local sleep data deleted.'
          : 'Sleep history deleted, but some audio files could not be removed.';
      await _loadNights(notify: false);
    } on Exception {
      _statusMessage = 'Could not delete local sleep data.';
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

  Future<void> _stopAudioIfPlaying(Set<String> filePaths) async {
    if (_playingPath == null || !filePaths.contains(_playingPath)) {
      return;
    }

    await _audioPlayback.stop();
    _playingPath = null;
    _playingAudioKey = null;
  }

  Future<int> _deleteLocalFiles(List<String> filePaths) async {
    var failures = 0;
    for (final filePath in filePaths.toSet()) {
      if (filePath.contains('://') && !filePath.startsWith('file://')) {
        continue;
      }

      final file = filePath.startsWith('file://')
          ? File.fromUri(Uri.parse(filePath))
          : File(filePath);

      try {
        if (await file.exists()) {
          await file.delete();
        }
      } on FileSystemException {
        failures += 1;
      }
    }

    return failures;
  }

  void _scheduleChunkRotation() {
    _chunkRotationTimer?.cancel();
    if (_recordingChunkDuration <= Duration.zero) {
      return;
    }

    _chunkRotationTimer = Timer(_recordingChunkDuration, () {
      unawaited(_rotateRecordingChunk());
    });
  }

  Future<void> _rotateRecordingChunk() async {
    if (_isRotatingChunk ||
        _recordingSession.status != RecordingStatus.recording) {
      return;
    }

    final nightId = _activeNightId;
    final chunkStartedAt = _currentChunkStartedAt;
    final chunkPath = _currentChunkPath;
    final nightStartedAt = _activeNightStartedAt;
    if (nightId == null ||
        chunkStartedAt == null ||
        chunkPath == null ||
        nightStartedAt == null) {
      return;
    }

    _isRotatingChunk = true;
    try {
      final stoppedSession = await _recorder.stopNightRecording();
      final chunkEndedAt = DateTime.now();
      final frames = _takeCapturedPowerFrames();
      final nextSession = await _recorder.startNightRecording();

      if (nextSession.status != RecordingStatus.recording ||
          nextSession.filePath == null ||
          nextSession.startedAt == null) {
        await _stopCapturingPowerFrames();
        await _stopForegroundNotificationSilently();
        _recordingSession = stoppedSession;
        _statusMessage = 'Recording stopped because chunk rotation failed.';
        notifyListeners();
        await _enqueueFinishedChunk(
          nightId: nightId,
          chunkStartedAt: chunkStartedAt,
          chunkEndedAt: chunkEndedAt,
          chunkPath: chunkPath,
          frames: frames,
        );
        return;
      }

      _currentChunkStartedAt = nextSession.startedAt;
      _currentChunkPath = nextSession.filePath;
      _recordingSession = RecordingSession(
        status: RecordingStatus.recording,
        filePath: nextSession.filePath,
        startedAt: nightStartedAt,
      );
      _scheduleChunkRotation();
      notifyListeners();

      unawaited(
        _enqueueFinishedChunk(
          nightId: nightId,
          chunkStartedAt: chunkStartedAt,
          chunkEndedAt: chunkEndedAt,
          chunkPath: chunkPath,
          frames: frames,
        ),
      );
    } on Exception {
      _statusMessage = 'Could not rotate the recording chunk.';
      notifyListeners();
    } finally {
      _isRotatingChunk = false;
    }
  }

  Future<void> _waitForActiveRotation() async {
    while (_isRotatingChunk) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _startCapturingPowerFrames() async {
    _recordingPowerFrames.clear();
    _livePowerFrames = const [];
    await _powerFrameSubscription?.cancel();
    _powerFrameSubscription = _recorder.powerFrames.listen(_addPowerFrame);
  }

  Future<List<RecordingPowerFrame>> _stopCapturingPowerFrames() async {
    await _powerFrameSubscription?.cancel();
    _powerFrameSubscription = null;
    final frames = List<RecordingPowerFrame>.unmodifiable(
      _recordingPowerFrames,
    );
    _livePowerFrames = const [];
    return frames;
  }

  List<RecordingPowerFrame> _takeCapturedPowerFrames() {
    final frames = List<RecordingPowerFrame>.unmodifiable(
      _recordingPowerFrames,
    );
    _recordingPowerFrames.clear();
    return frames;
  }

  void _addPowerFrame(RecordingPowerFrame frame) {
    _recordingPowerFrames.add(frame);
    _livePowerFrames = [..._livePowerFrames, frame]
        .skip(math.max(0, _livePowerFrames.length + 1 - _maxLivePowerFrames))
        .toList(growable: false);
    notifyListeners();
  }

  Set<DateTime> _billableSleepDatesForMonth(
    DateTime month,
    Iterable<SleepNight> nights,
  ) {
    return {
      for (final night in nights)
        if (!night.isManual &&
            night.duration >= _minimumQuotaRecordingDuration &&
            night.date.year == month.year &&
            night.date.month == month.month)
          DateTime(night.date.year, night.date.month, night.date.day),
    };
  }

  Future<void> _enqueueFinishedChunk({
    required int nightId,
    required DateTime chunkStartedAt,
    required DateTime chunkEndedAt,
    required String chunkPath,
    required List<RecordingPowerFrame> frames,
  }) {
    final queued = _chunkProcessing.then((_) async {
      final result = await _processFinishedChunk(
        nightId: nightId,
        chunkStartedAt: chunkStartedAt,
        chunkEndedAt: chunkEndedAt,
        chunkPath: chunkPath,
        frames: frames,
      );
      _activeSavedEventCount += result.savedEvents;
      _activeSnoreCount += result.savedSnoreEvents;
      await _database.updateNightSnoreScore(
        nightId: nightId,
        snoreScore: _activeSnoreCount,
      );
      await _database.updateRecordedNightEnd(
        nightId: nightId,
        endedAt: chunkEndedAt,
      );
      await _loadNights(notify: true);
    });

    _chunkProcessing = queued.catchError((Object _) {
      _statusMessage = 'Could not analyze one audio chunk.';
      notifyListeners();
    });

    return _chunkProcessing;
  }

  Future<_ProcessedChunkResult> _processFinishedChunk({
    required int nightId,
    required DateTime chunkStartedAt,
    required DateTime chunkEndedAt,
    required String chunkPath,
    required List<RecordingPowerFrame> frames,
  }) async {
    var savedEvents = 0;
    var savedSnoreEvents = 0;

    try {
      final analysis = await _sleepEventAnalyzer.analyzeFrames(
        frames: frames,
        startedAt: chunkStartedAt,
        endedAt: chunkEndedAt,
        recordingPath: chunkPath,
      );
      final clippedEvents = await _audioEventClipStore.saveEventClips(
        sourcePath: chunkPath,
        chunkStartedAt: chunkStartedAt,
        chunkEndedAt: chunkEndedAt,
        events: analysis.events,
        preRoll: _eventClipPreRoll,
        postRoll: _eventClipPostRoll,
      );

      for (final event in clippedEvents) {
        await _database.addDetectedEvent(
          nightId: nightId,
          kind: event.kind,
          startsAt: event.startsAt,
          duration: event.duration,
          intensity: event.intensity,
          filePath: event.filePath,
        );
      }

      savedEvents = clippedEvents.length;
      savedSnoreEvents = clippedEvents
          .where((event) => event.kind == SleepEventKind.snore)
          .length;
    } finally {
      if (kReleaseMode) {
        await _deleteLocalFiles([chunkPath]);
      }
    }

    return _ProcessedChunkResult(
      savedEvents: savedEvents,
      savedSnoreEvents: savedSnoreEvents,
    );
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

  void _clearActiveRecordingState() {
    _chunkRotationTimer?.cancel();
    _chunkRotationTimer = null;
    _isRotatingChunk = false;
    _activeNightId = null;
    _activeNightStartedAt = null;
    _currentChunkStartedAt = null;
    _currentChunkPath = null;
    _activeSavedEventCount = 0;
    _activeSnoreCount = 0;
  }

  @override
  void dispose() {
    unawaited(_unlockSubscription?.cancel());
    unawaited(_powerFrameSubscription?.cancel());
    _chunkRotationTimer?.cancel();
    unawaited(_stopForegroundNotificationSilently());
    unawaited(_recorder.dispose());
    unawaited(_unlockRepository.dispose());
    unawaited(_audioPlayback.dispose());
    unawaited(_database.close());
    super.dispose();
  }
}

SleepEventAnalyzer _defaultSleepEventAnalyzer() {
  // ML pipeline (Silero VAD + tiny_conv) needs native libs (tflite_flutter +
  // onnxruntime). Fall back to the level-based analyzer on web.
  const fallback = LocalLevelSleepEventAnalyzer();
  if (kIsWeb) return fallback;
  return MlSleepEventAnalyzer(fallbackAnalyzer: fallback);
}

class _ProcessedChunkResult {
  const _ProcessedChunkResult({
    required this.savedEvents,
    required this.savedSnoreEvents,
  });

  final int savedEvents;
  final int savedSnoreEvents;
}
