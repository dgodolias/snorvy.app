import 'package:flutter/material.dart';
import 'package:snorvy/src/domain/sample_nights.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/features/history/history_screen.dart';
import 'package:snorvy/src/features/settings/settings_screen.dart';
import 'package:snorvy/src/features/tonight/tonight_screen.dart';
import 'package:snorvy/src/features/unlock/unlock_sheet.dart';

class SnorvyShell extends StatefulWidget {
  const SnorvyShell({super.key});

  @override
  State<SnorvyShell> createState() => _SnorvyShellState();
}

class _SnorvyShellState extends State<SnorvyShell> {
  late final List<SleepNight> _nights = buildSampleNights();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      TonightScreen(
        nights: _nights,
        onUnlockTap: () => showSnorvyUnlockSheet(context),
      ),
      HistoryScreen(nights: _nights),
      SettingsScreen(onUnlockTap: () => showSnorvyUnlockSheet(context)),
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
}
