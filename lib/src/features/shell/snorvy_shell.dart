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
            bedtimeReminder: widget.controller.bedtimeReminder,
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
            onUpdateBedtimeReminder: widget.controller.updateBedtimeReminder,
            onTestBedtimeReminder:
                widget.controller.fireBedtimeReminderTest,
            onToggleEventSave: (event, saved) =>
                widget.controller.toggleEventSave(
              eventId: event.id,
              saved: saved,
            ),
          ),
          HistoryScreen(
            nights: widget.controller.nights,
            isLoading: widget.controller.isLoading,
            isBusy: widget.controller.isBusy,
            playingAudioKey: widget.controller.playingAudioKey,
            onPlayAudio: widget.controller.playAudio,
            onStopAudio: widget.controller.stopAudio,
            onDeleteNight: widget.controller.deleteNight,
          ),
          SettingsScreen(
            isBusy: widget.controller.isBusy,
            unlockState: widget.controller.unlockState,
            recordingsThisMonth: widget.controller.recordingsThisMonth,
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
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: _SnorvyBottomNav(
              selectedIndex: _selectedIndex,
              onSelected: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        );
      },
    );
  }
}

class _SnorvyBottomNav extends StatelessWidget {
  const _SnorvyBottomNav({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    _SnorvyNavItemData(
      label: 'Tonight',
      icon: Icons.bedtime_outlined,
      selectedIcon: Icons.bedtime,
    ),
    _SnorvyNavItemData(
      label: 'History',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights,
    ),
    _SnorvyNavItemData(
      label: 'Settings',
      icon: Icons.tune_outlined,
      selectedIcon: Icons.tune,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xF211141B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x38FFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            for (var index = 0; index < _items.length; index++)
              Expanded(
                child: _SnorvyNavItem(
                  item: _items[index],
                  selected: selectedIndex == index,
                  onTap: () => onSelected(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SnorvyNavItemData {
  const _SnorvyNavItemData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _SnorvyNavItem extends StatelessWidget {
  const _SnorvyNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _SnorvyNavItemData item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? SnorvyTheme.neuralMint
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              height: 54,
              decoration: BoxDecoration(
                color: selected
                    ? SnorvyTheme.neuralMint.withValues(alpha: 0.13)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? SnorvyTheme.neuralMint.withValues(alpha: 0.36)
                      : Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    selected ? item.selectedIcon : item.icon,
                    color: color,
                    size: 21,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 11.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
