import 'package:flutter/material.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.isBusy,
    required this.onAddManualLog,
    required this.onUnlockTap,
    super.key,
  });

  final bool isBusy;
  final Future<void> Function() onAddManualLog;
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
                            'Free: 7 nights/month',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const Text('\$9.99 once unlocks everything.'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: widget.onUnlockTap,
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Unlock \$9.99'),
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
}
