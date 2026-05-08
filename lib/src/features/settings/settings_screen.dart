import 'package:flutter/material.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';
import 'package:snorvy/src/services/unlock_repository.dart';

class SettingsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 126),
      children: [
        Text('PREFERENCES', style: SnorvyTheme.labelStyle(context)),
        const SizedBox(height: 6),
        Text('Settings.', style: SnorvyTheme.displayStyle(context)),
        const SizedBox(height: 8),
        Text(
          'Privacy and purchase defaults are wired to the product promise.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 22),
        Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.phone_android),
                title: Text('Local-only audio'),
                subtitle: Text(
                  'Recordings stay on this phone unless you export them.',
                ),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.no_accounts_outlined),
                title: Text('No cloud account'),
                subtitle: Text('Snorvy v1 has no login or sync backend.'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy policy'),
                subtitle: const Text('Read how Snorvy handles local audio.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPrivacyPolicy(context),
              ),
              const Divider(height: 1),
              ListTile(
                enabled: !isBusy,
                leading: const Icon(Icons.delete_forever_outlined),
                title: const Text('Delete local sleep data'),
                subtitle: const Text(
                  'Remove history and recordings from this phone.',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: isBusy
                    ? null
                    : () async {
                        final confirmed = await _confirmDeleteAllData(context);
                        if (!confirmed) {
                          return;
                        }

                        await onDeleteAllSleepData();
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
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                SnorvyTheme.neuralMint.withValues(alpha: 0.16),
                Theme.of(context).colorScheme.surfaceContainerLow,
              ],
            ),
            border: Border.all(color: SnorvyTheme.midnightBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: SnorvyTheme.neuralMint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: SnorvyTheme.midnight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unlockState.isUnlocked
                                ? 'Lifetime unlock active'
                                : 'Free: $recordingsThisMonth/7 sleep days used',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            unlockState.isUnlocked
                                ? 'Unlimited sleep days are active on this phone.'
                                : 'Short tests do not use a free sleep day.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    foregroundColor: SnorvyTheme.midnight,
                  ),
                  onPressed: unlockState.isUnlocked ? null : onUnlockTap,
                  icon: const Icon(Icons.lock_open),
                  label: Text(
                    unlockState.isUnlocked
                        ? 'Unlocked'
                        : 'Unlock ${unlockState.priceLabel}',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: SnorvyTheme.neuralMint,
          ),
          onPressed: isBusy ? null : () => _showManualLogSheet(context),
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
                    await onAddManualLog();
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

  void _showPrivacyPolicy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Snorvy Privacy Policy'),
          content: const SingleChildScrollView(child: Text(_privacyPolicyText)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
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

const _privacyPolicyText = '''
Effective date: 2026-05-07

Snorvy is a local-only sleep recorder. It is designed to record audio on your phone and keep that audio on your phone.

What Snorvy records

Snorvy uses your microphone only when you start a sleep recording. Recordings may include snoring, speech, room noise, or other sounds near your phone.

Where your audio goes

Snorvy does not upload your audio to Snorvy servers. The MVP has no backend account system and no cloud sync. Recordings and sleep history are stored locally on your device.

If you choose to export or share a recording, your device's sharing tools or the app you choose may process that file outside Snorvy.

Purchases

Snorvy uses Google Play Billing for the lifetime unlock. Google Play processes the payment. Snorvy stores a local entitlement flag so the app knows whether lifetime unlock is active.

No medical diagnosis

Snorvy is not a medical device. Snorvy does not diagnose sleep apnea or any other medical condition. If you have health concerns, contact a qualified clinician.

Deleting your data

You can delete individual nights from History or delete all local sleep data from Settings. You can also remove Snorvy's local data by clearing app data or uninstalling the app.

Public policy URL

https://gist.github.com/dgodolias/f02725dd83693fc2486fd44169238a04

Contact

support@snorvy.app
''';
