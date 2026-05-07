import 'package:flutter/material.dart';
import 'package:snorvy/src/services/unlock_repository.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

void showSnorvyUnlockSheet(
  BuildContext context, {
  required UnlockState state,
  required Future<void> Function() onUnlock,
  required Future<void> Function() onRestore,
}) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) =>
        _UnlockSheet(state: state, onUnlock: onUnlock, onRestore: onRestore),
  );
}

class _UnlockSheet extends StatelessWidget {
  const _UnlockSheet({
    required this.state,
    required this.onUnlock,
    required this.onRestore,
  });

  final UnlockState state;
  final Future<void> Function() onUnlock;
  final Future<void> Function() onRestore;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('LIFETIME', style: SnorvyTheme.labelStyle(context)),
            const SizedBox(height: 6),
            Text('Snorvy.', style: SnorvyTheme.displayStyle(context, size: 42)),
            const SizedBox(height: 12),
            Text(
              '${state.priceLabel} once: everything forever',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                foregroundColor: SnorvyTheme.midnight,
              ),
              onPressed: state.isUnlocked || state.isPending
                  ? null
                  : () async {
                      await onUnlock();
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
                    },
              icon: Icon(state.isUnlocked ? Icons.check : Icons.lock_open),
              label: Text(
                state.isUnlocked
                    ? 'Unlocked'
                    : state.isPending
                    ? 'Working...'
                    : 'Unlock ${state.priceLabel}',
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: state.isPending
                  ? null
                  : () async {
                      await onRestore();
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
                    },
              icon: const Icon(Icons.restore),
              label: const Text('Restore purchase'),
            ),
            const SizedBox(height: 4),
            Text(
              state.message ?? 'No subscription. No trial.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
