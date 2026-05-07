import 'package:flutter/material.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';
import 'package:snorvy/src/services/unlock_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.isBusy,
    required this.unlockState,
    required this.recordingsThisMonth,
    required this.onAddManualLog,
    required this.onDeleteAllSleepData,
    required this.onUnlockTap,
    super.key,
  });

  final bool isBusy;
  final UnlockState unlockState;
  final int recordingsThisMonth;
  final Future<void> Function() onAddManualLog;
  final Future<void> Function() onDeleteAllSleepData;
  final VoidCallback onUnlockTap;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoDeleteTalkEvents = true;
  bool _keepAudioLocalOnly = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Text(
          'Settings',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'Privacy and purchase defaults are wired to the product promise.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                value: _keepAudioLocalOnly,
                onChanged: (value) => setState(() {
                  _keepAudioLocalOnly = value;
                }),
                title: const Text('Local-only audio'),
                subtitle: const Text('No cloud sync in Snorvy v1.'),
                secondary: const Icon(Icons.phone_android),
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: _autoDeleteTalkEvents,
                onChanged: (value) => setState(() {
                  _autoDeleteTalkEvents = value;
                }),
                title: const Text('Auto-delete talk clips'),
                subtitle: const Text('Default privacy window is 30 days.'),
                secondary: const Icon(Icons.auto_delete),
              ),
              const Divider(height: 1),
              ListTile(
                enabled: !widget.isBusy,
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete local sleep data'),
                subtitle: const Text(
                  'Remove history and recordings from this phone.',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: widget.isBusy
                    ? null
                    : () async {
                        final confirmed = await _confirmDeleteAllData(context);
                        if (!confirmed) {
                          return;
                        }

                        await widget.onDeleteAllSleepData();
                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Local sleep data deleted.'),
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: SnorvyTheme.mint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: SnorvyTheme.moss,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.unlockState.isUnlocked
                                ? 'Lifetime unlock active'
                                : 'Free: ${widget.recordingsThisMonth}/7 nights used',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '${widget.unlockState.priceLabel} once unlocks everything.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: widget.unlockState.isUnlocked
                      ? null
                      : widget.onUnlockTap,
                  icon: const Icon(Icons.lock_open),
                  label: Text(
                    widget.unlockState.isUnlocked
                        ? 'Unlocked'
                        : 'Unlock ${widget.unlockState.priceLabel}',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: widget.isBusy ? null : () => _showManualLogSheet(context),
          icon: const Icon(Icons.edit_calendar),
          label: const Text('Add manual sleep log'),
        ),
      ],
    );
  }

  void _showManualLogSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manual sleep log',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text('Default entry: 23:30 to 07:15.'),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () async {
                    await widget.onAddManualLog();
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Manual log saved locally.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Save log'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _confirmDeleteAllData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete all local data?'),
          content: const Text(
            'This removes every saved night and recording from this phone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete all'),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }
}
