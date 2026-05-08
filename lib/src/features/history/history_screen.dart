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
        const _HistoryHeader(),
        const SizedBox(height: 18),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (nights.isEmpty)
          const _EmptyHistoryPanel()
        else ...[
          _TrendPanel(
            orderedNights: orderedNights,
            averageSnoreCount: _averageSnoreCount(orderedNights),
            maxSnoreCount: _maxSnoreCount(orderedNights),
          ),
          const SizedBox(height: 14),
          _HistorySectionHeader(
            title: 'Recent nights',
            detail: '${nights.length}/30 stored',
          ),
          const SizedBox(height: 8),
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

  int _averageSnoreCount(List<SleepNight> nights) {
    if (nights.isEmpty) {
      return 0;
    }
    final recent = nights.take(7).toList(growable: false);
    final total = recent.fold<int>(0, (sum, night) => sum + night.snoreCount);
    return (total / recent.length).round();
  }

  int _maxSnoreCount(List<SleepNight> nights) {
    return nights.fold<int>(
      3,
      (maximum, night) =>
          night.snoreCount > maximum ? night.snoreCount : maximum,
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: SnorvyTheme.neuralMint.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SnorvyTheme.midnightBorder),
          ),
          child: const Icon(
            Icons.insights,
            color: SnorvyTheme.neuralMint,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('30-NIGHT WINDOW', style: SnorvyTheme.labelStyle(context)),
              const SizedBox(height: 3),
              Text('History', style: SnorvyTheme.screenTitleStyle(context)),
              Text(
                'Local sleep logs and event counts.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendPanel extends StatelessWidget {
  const _TrendPanel({
    required this.orderedNights,
    required this.averageSnoreCount,
    required this.maxSnoreCount,
  });

  final List<SleepNight> orderedNights;
  final int averageSnoreCount;
  final int maxSnoreCount;

  @override
  Widget build(BuildContext context) {
    final recentNight = orderedNights.isEmpty ? null : orderedNights.last;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border.all(color: SnorvyTheme.midnightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _TrendMetric(
                    label: '7-night average',
                    value: '$averageSnoreCount',
                    detail: 'snore count',
                    accent: SnorvyTheme.neuralMint,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TrendMetric(
                    label: 'Latest night',
                    value: '${recentNight?.snoreCount ?? 0}',
                    detail: recentNight == null
                        ? 'no data'
                        : DateFormat('MMM d').format(recentNight.date),
                    accent: SnorvyTheme.talkAmber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 92,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxSnoreCount.toDouble(),
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
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < orderedNights.length; i++)
                          FlSpot(
                            i.toDouble(),
                            orderedNights[i].snoreCount.toDouble(),
                          ),
                      ],
                      color: SnorvyTheme.neuralMint,
                      barWidth: 3,
                      isCurved: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: SnorvyTheme.neuralMint.withValues(alpha: 0.10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendMetric extends StatelessWidget {
  const _TrendMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.accent,
  });

  final String label;
  final String value;
  final String detail;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: SnorvyTheme.labelStyle(context)),
        const SizedBox(height: 3),
        Text(
          value,
          style: SnorvyTheme.displayStyle(context, size: 30, color: accent),
        ),
        Text(
          detail,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HistorySectionHeader extends StatelessWidget {
  const _HistorySectionHeader({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: SnorvyTheme.sectionTitleStyle(context)),
        ),
        Text(detail, style: SnorvyTheme.labelStyle(context)),
      ],
    );
  }
}

class _EmptyHistoryPanel extends StatelessWidget {
  const _EmptyHistoryPanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
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
    final talkCount = night.events
        .where((event) => event.kind == SleepEventKind.talk)
        .length;
    final clipSummary = night.events.isEmpty
        ? eventSummary
        : '${night.snoreCount} snore, $talkCount talk';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SnorvyTheme.midnightBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$date$manualSuffix',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: SnorvyTheme.labelStyle(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${night.duration.inHours}h ${night.duration.inMinutes % 60}m',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '${night.snoreCount}',
                          style: SnorvyTheme.displayStyle(
                            context,
                            size: 24,
                            color: SnorvyTheme.neuralMint,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            clipSummary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (night.recordingPath != null)
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
