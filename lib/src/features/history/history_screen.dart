import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    required this.nights,
    required this.isLoading,
    required this.isBusy,
    required this.playingPath,
    required this.onPlayAudio,
    required this.onStopAudio,
    required this.onDeleteNight,
    super.key,
  });

  final List<SleepNight> nights;
  final bool isLoading;
  final bool isBusy;
  final String? playingPath;
  final Future<void> Function(String filePath) onPlayAudio;
  final Future<void> Function() onStopAudio;
  final Future<void> Function(SleepNight night) onDeleteNight;

  @override
  Widget build(BuildContext context) {
    final orderedNights = nights.reversed.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 126),
      children: [
        Text('30-NIGHT WINDOW', style: SnorvyTheme.labelStyle(context)),
        const SizedBox(height: 6),
        Text('History.', style: SnorvyTheme.displayStyle(context)),
        const SizedBox(height: 8),
        Text(
          '30-night local history is the v1 storage target.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 22),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (nights.isEmpty)
          const _EmptyHistoryPanel()
        else ...[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              border: Border.all(color: SnorvyTheme.midnightBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7-NIGHT SNORE AVG',
                    style: SnorvyTheme.labelStyle(context),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_averageScore(orderedNights)}',
                    style: SnorvyTheme.displayStyle(
                      context,
                      size: 44,
                      color: SnorvyTheme.neuralMint,
                    ),
                  ),
                  Text(
                    'average score',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 130,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 100,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              for (var i = 0; i < orderedNights.length; i++)
                                FlSpot(
                                  i.toDouble(),
                                  orderedNights[i].snoreScore.toDouble(),
                                ),
                            ],
                            color: SnorvyTheme.neuralMint,
                            barWidth: 4,
                            isCurved: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: SnorvyTheme.neuralMint.withValues(
                                alpha: 0.14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...nights.map(
            (night) => _NightHistoryTile(
              night: night,
              isBusy: isBusy,
              isPlaying: night.recordingPath == playingPath,
              onPlayAudio: onPlayAudio,
              onStopAudio: onStopAudio,
              onDeleteNight: onDeleteNight,
            ),
          ),
        ],
      ],
    );
  }

  int _averageScore(List<SleepNight> nights) {
    if (nights.isEmpty) {
      return 0;
    }
    final recent = nights.take(7).toList(growable: false);
    final total = recent.fold<int>(0, (sum, night) => sum + night.snoreScore);
    return (total / recent.length).round();
  }
}

class _EmptyHistoryPanel extends StatelessWidget {
  const _EmptyHistoryPanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.hotel, color: SnorvyTheme.neuralMint),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('No nights saved yet. Record or add a manual log.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NightHistoryTile extends StatelessWidget {
  const _NightHistoryTile({
    required this.night,
    required this.isBusy,
    required this.isPlaying,
    required this.onPlayAudio,
    required this.onStopAudio,
    required this.onDeleteNight,
  });

  final SleepNight night;
  final bool isBusy;
  final bool isPlaying;
  final Future<void> Function(String filePath) onPlayAudio;
  final Future<void> Function() onStopAudio;
  final Future<void> Function(SleepNight night) onDeleteNight;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, MMM d').format(night.date);
    final manualSuffix = night.isManual ? ' - manual log' : '';
    final eventSummary = night.isManual
        ? 'manual entry'
        : night.events.isEmpty
        ? 'no loud events detected'
        : '${night.events.length} audio events';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SnorvyTheme.midnightBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$date$manualSuffix',
                      style: SnorvyTheme.labelStyle(context),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${night.duration.inHours}h ${night.duration.inMinutes % 60}m',
                      style: SnorvyTheme.displayStyle(context, size: 24),
                    ),
                    Text(
                      eventSummary,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (night.recordingPath == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${night.snoreScore}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: SnorvyTheme.neuralMint,
                    ),
                  ),
                )
              else
                IconButton(
                  tooltip: isPlaying ? 'Stop recording' : 'Play recording',
                  onPressed: isBusy
                      ? null
                      : () async {
                          if (isPlaying) {
                            await onStopAudio();
                          } else {
                            await onPlayAudio(night.recordingPath!);
                          }
                        },
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                ),
              IconButton(
                tooltip: 'Delete night',
                onPressed: () async {
                  final confirmed = await _confirmDeleteNight(context);
                  if (confirmed) {
                    await onDeleteNight(night);
                  }
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDeleteNight(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete this night?'),
          content: const Text(
            'This removes the sleep log and any saved audio from this phone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }
}
