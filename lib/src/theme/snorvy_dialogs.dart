import 'package:flutter/material.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

/// Show a branded confirmation dialog with a coloured icon badge, title,
/// optional body, and two actions (cancel + confirm). Returns true if the
/// user confirmed, false otherwise.
Future<bool> showSnorvyConfirmDialog(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String body,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Confirm',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return _SnorvyDialog(
        icon: icon,
        accent: destructive ? SnorvyTheme.danger : SnorvyTheme.neuralMint,
        title: title,
        body: body,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor:
                  destructive ? SnorvyTheme.danger : SnorvyTheme.neuralMint,
              foregroundColor: SnorvyTheme.midnight,
            ),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

/// Show a branded informational dialog (single close button).
Future<void> showSnorvyInfoDialog(
  BuildContext context, {
  required IconData icon,
  required String title,
  required Widget body,
  String closeLabel = 'Close',
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return _SnorvyDialog(
        icon: icon,
        accent: SnorvyTheme.neuralMint,
        title: title,
        bodyWidget: body,
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: SnorvyTheme.neuralMint,
              foregroundColor: SnorvyTheme.midnight,
            ),
            child: Text(closeLabel),
          ),
        ],
      );
    },
  );
}

class _SnorvyDialog extends StatelessWidget {
  const _SnorvyDialog({
    required this.icon,
    required this.accent,
    required this.title,
    required this.actions,
    this.body,
    this.bodyWidget,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String? body;
  final Widget? bodyWidget;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: colorScheme.surfaceContainerLow,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              if (body != null)
                Text(
                  body!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ?bodyWidget,
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    actions[i],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
