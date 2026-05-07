import 'package:flutter/material.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/features/history/history_screen.dart';
import 'package:snorvy/src/features/settings/settings_screen.dart';
import 'package:snorvy/src/features/tonight/tonight_screen.dart';
import 'package:snorvy/src/features/unlock/unlock_sheet.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';
import 'package:snorvy/src/services/unlock_repository.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

void main() {
  runApp(const _SnorvySmokeApp());
}

class _SnorvySmokeApp extends StatelessWidget {
  const _SnorvySmokeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snorvy Smoke',
      debugShowCheckedModeBanner: false,
      theme: SnorvyTheme.light(),
      darkTheme: SnorvyTheme.dark(),
      home: const _SnorvySmokeShell(),
    );
  }
}

class _SnorvySmokeShell extends StatefulWidget {
  const _SnorvySmokeShell();

  @override
  State<_SnorvySmokeShell> createState() => _SnorvySmokeShellState();
}

class _SnorvySmokeShellState extends State<_SnorvySmokeShell> {
  static const _unlockState = UnlockState(
    isUnlocked: false,
    isPending: false,
    isStoreAvailable: false,
    productConfigured: false,
    priceLabel: '\$9.99',
  );

  int _selectedIndex = 0;
  int _nextNightId = 1;
  List<SleepNight> _nights = const [];
  RecordingSession _recordingSession = const RecordingSession(
    status: RecordingStatus.idle,
  );
  String? _statusMessage;
  String? _playingPath;

  @override
  Widget build(BuildContext context) {
    final screens = [
      TonightScreen(
        nights: _nights,
        recordingSession: _recordingSession,
        isBusy: false,
        isLoading: false,
        statusMessage: _statusMessage,
        playingPath: _playingPath,
        onStartRecording: _startRecording,
        onStopRecording: _stopRecording,
        onPlayAudio: _playAudio,
        onStopAudio: _stopAudio,
        onExportAudio: _exportAudio,
        onUnlockTap: _showUnlock,
      ),
      HistoryScreen(
        nights: _nights,
        isLoading: false,
        isBusy: false,
        playingPath: _playingPath,
        onPlayAudio: _playAudio,
        onStopAudio: _stopAudio,
        onDeleteNight: _deleteNight,
      ),
      SettingsScreen(
        isBusy: false,
        unlockState: _unlockState,
        recordingsThisMonth: _nights
            .where((night) => !night.isManual && night.recordingPath != null)
            .length,
        onAddManualLog: _addManualLog,
        onDeleteAllSleepData: _deleteAllSleepData,
        onUnlockTap: _showUnlock,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: screens),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bedtime_outlined),
            selectedIcon: Icon(Icons.bedtime),
            label: 'Tonight',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    setState(() {
      _recordingSession = RecordingSession(
        status: RecordingStatus.recording,
        filePath: 'browser://night_$_nextNightId.ogg',
        startedAt: DateTime(2026, 5, 7, 23, 30),
      );
      _statusMessage = 'Recording started. Audio stays on device.';
    });
  }

  Future<void> _stopRecording() async {
    final session = _recordingSession;
    setState(() {
      _recordingSession = RecordingSession(
        status: RecordingStatus.idle,
        filePath: session.filePath,
        startedAt: session.startedAt,
      );
      _nights = [_recordedNight(session), ..._nights];
      _statusMessage = 'Night recording saved with 2 local audio events.';
    });
  }

  Future<void> _addManualLog() async {
    setState(() {
      _nights = [_manualNight(), ..._nights];
      _statusMessage = 'Manual log saved locally.';
    });
  }

  Future<void> _deleteNight(SleepNight night) async {
    setState(() {
      _nights = _nights.where((candidate) => candidate.id != night.id).toList();
      if (_playingPath == night.recordingPath) {
        _playingPath = null;
      }
      _statusMessage = 'Night deleted from this phone.';
    });
  }

  Future<void> _deleteAllSleepData() async {
    setState(() {
      _nights = const [];
      _playingPath = null;
      _statusMessage = 'All local sleep data deleted.';
    });
  }

  Future<void> _playAudio(String filePath) async {
    setState(() {
      _playingPath = filePath;
      _statusMessage = 'Playing saved audio from this phone.';
    });
  }

  Future<void> _stopAudio() async {
    setState(() {
      _playingPath = null;
      _statusMessage = 'Playback stopped.';
    });
  }

  Future<void> _exportAudio(String filePath) async {
    setState(() {
      _statusMessage = 'Exported audio to $filePath';
    });
  }

  void _showUnlock() {
    showSnorvyUnlockSheet(
      context,
      state: _unlockState,
      onUnlock: () async {},
      onRestore: () async {},
    );
  }

  SleepNight _manualNight() {
    final id = _nextNightId++;
    final endedAt = DateTime(2026, 5, 7, 7, 15);
    return SleepNight(
      id: id,
      date: DateTime(2026, 5, 7),
      startedAt: endedAt.subtract(const Duration(hours: 7, minutes: 45)),
      endedAt: endedAt,
      snoreScore: 0,
      isManual: true,
      events: const [],
    );
  }

  SleepNight _recordedNight(RecordingSession session) {
    final id = _nextNightId++;
    final startedAt = session.startedAt ?? DateTime(2026, 5, 7, 23, 30);
    final endedAt = startedAt.add(const Duration(hours: 7, minutes: 45));
    return SleepNight(
      id: id,
      date: DateTime(2026, 5, 8),
      startedAt: startedAt,
      endedAt: endedAt,
      snoreScore: 38,
      recordingPath: session.filePath ?? 'browser://night_$id.ogg',
      events: [
        SleepEvent(
          id: id * 10,
          kind: SleepEventKind.snore,
          startsAt: startedAt.add(const Duration(minutes: 42)),
          duration: const Duration(seconds: 12),
          intensity: 72,
          filePath: session.filePath ?? 'browser://night_$id.ogg',
        ),
        SleepEvent(
          id: id * 10 + 1,
          kind: SleepEventKind.talk,
          startsAt: startedAt.add(const Duration(hours: 2, minutes: 8)),
          duration: const Duration(seconds: 4),
          intensity: 81,
          filePath: session.filePath ?? 'browser://night_$id.ogg',
        ),
      ],
    );
  }
}
