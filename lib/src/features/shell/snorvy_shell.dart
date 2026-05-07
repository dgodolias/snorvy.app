import 'package:flutter/material.dart';
import 'package:snorvy/src/app/snorvy_controller.dart';
import 'package:snorvy/src/features/history/history_screen.dart';
import 'package:snorvy/src/features/settings/settings_screen.dart';
import 'package:snorvy/src/features/tonight/tonight_screen.dart';
import 'package:snorvy/src/features/unlock/unlock_sheet.dart';

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
            isBusy: widget.controller.isBusy,
            isLoading: widget.controller.isLoading,
            statusMessage: widget.controller.statusMessage,
            onStartRecording: widget.controller.startRecording,
            onStopRecording: widget.controller.stopRecording,
            onUnlockTap: () => showSnorvyUnlockSheet(context),
          ),
          HistoryScreen(
            nights: widget.controller.nights,
            isLoading: widget.controller.isLoading,
          ),
          SettingsScreen(
            isBusy: widget.controller.isBusy,
            onAddManualLog: widget.controller.addDefaultManualLog,
            onUnlockTap: () => showSnorvyUnlockSheet(context),
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
      },
    );
  }
}
