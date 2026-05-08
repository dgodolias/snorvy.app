import 'package:flutter/material.dart';
import 'package:snorvy/src/app/snorvy_controller.dart';
import 'package:snorvy/src/features/history/history_screen.dart';
import 'package:snorvy/src/features/settings/settings_screen.dart';
import 'package:snorvy/src/features/tonight/tonight_screen.dart';
import 'package:snorvy/src/features/unlock/unlock_sheet.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

class SnorvyShell extends StatefulWidget {
  const SnorvyShell({required this.controller, super.key});

  final SnorvyController controller;

  @override
  State<SnorvyShell> createState() => _SnorvyShellState();
}

class _SnorvyShellState extends State<SnorvyShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final screens = [
          TonightScreen(
            nights: widget.controller.nights,
            recordingSession: widget.controller.recordingSession,
            livePowerFrames: widget.controller.livePowerFrames,
            isBusy: widget.controller.isBusy,
            isLoading: widget.controller.isLoading,
            statusMessage: widget.controller.statusMessage,
            playingAudioKey: widget.controller.playingAudioKey,
            onStartRecording: widget.controller.startRecording,
            onStopRecording: widget.controller.stopRecording,
            onPlayAudio: widget.controller.playAudio,
            onStopAudio: widget.controller.stopAudio,
            onExportAudio: widget.controller.exportAudio,
            onUnlockTap: () => showSnorvyUnlockSheet(
              context,
              state: widget.controller.unlockState,
              onUnlock: widget.controller.buyLifetimeUnlock,
              onRestore: widget.controller.restorePurchases,
            ),
          ),
          HistoryScreen(
            nights: widget.controller.nights,
            isLoading: widget.controller.isLoading,
            isBusy: widget.controller.isBusy,
            playingPath: widget.controller.playingPath,
            onPlayAudio: widget.controller.playAudio,
            onStopAudio: widget.controller.stopAudio,
            onDeleteNight: widget.controller.deleteNight,
          ),
          SettingsScreen(
            isBusy: widget.controller.isBusy,
            unlockState: widget.controller.unlockState,
            recordingsThisMonth: widget.controller.recordingsThisMonth,
            onAddManualLog: widget.controller.addDefaultManualLog,
            onDeleteAllSleepData: widget.controller.deleteAllSleepData,
            onUnlockTap: () => showSnorvyUnlockSheet(
              context,
              state: widget.controller.unlockState,
              onUnlock: widget.controller.buyLifetimeUnlock,
              onRestore: widget.controller.restorePurchases,
            ),
          ),
        ];

        return Scaffold(
          extendBody: true,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -1.12),
                radius: 1.05,
                colors: [
                  Color(0x3321D8C0),
                  SnorvyTheme.midnight,
                  SnorvyTheme.midnight,
                ],
                stops: [0, 0.48, 1],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: IndexedStack(index: _selectedIndex, children: screens),
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: SnorvyTheme.midnight2.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: SnorvyTheme.midnightBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 28,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  destinations: const [
                    NavigationDestination(
                      key: ValueKey('nav-tonight'),
                      icon: Icon(Icons.bedtime_outlined),
                      selectedIcon: Icon(Icons.bedtime),
                      label: 'Tonight',
                    ),
                    NavigationDestination(
                      key: ValueKey('nav-history'),
                      icon: Icon(Icons.insights_outlined),
                      selectedIcon: Icon(Icons.insights),
                      label: 'History',
                    ),
                    NavigationDestination(
                      key: ValueKey('nav-settings'),
                      icon: Icon(Icons.tune_outlined),
                      selectedIcon: Icon(Icons.tune),
                      label: 'Settings',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
