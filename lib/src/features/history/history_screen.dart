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
    super.key,
  });

  final List<SleepNight> nights;
  final bool isLoading;
  final bool isBusy;
  final String? playingPath;
  final Future<void> Function(String filePath) onPlayAudio;
  final Future<void> Function() onStopAudio;

  @override
  Widget build(BuildContext context) {
    final orderedNights = nights.reversed.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Text(
          'History',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          '30-night local history is the v1 storage target.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (nights.isEmpty)
          const _EmptyHistoryPanel()
        else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Snore score trend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
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
                            color: SnorvyTheme.moss,
                            barWidth: 4,
                            isCurved: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: SnorvyTheme.moss.withValues(alpha: 0.12),
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
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyHistoryPanel extends StatelessWidget {
  const _EmptyHistoryPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.hotel,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
  });

  final SleepNight night;
  final bool isBusy;
  final bool isPlaying;
  final Future<void> Function(String filePath) onPlayAudio;
  final Future<void> Function() onStopAudio;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, MMM d').format(night.date);
    final manualSuffix = night.isManual ? ' - manual log' : '';
    final eventSummary = night.events.isEmpty
        ? 'raw recording saved'
        : '${night.events.length} audio events';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: SnorvyTheme.amber.withValues(alpha: 0.16),
            foregroundColor: SnorvyTheme.amber,
            child: const Icon(Icons.hotel),
          ),
          title: Text('$date$manualSuffix'),
          subtitle: Text(
            '${night.duration.inHours}h ${night.duration.inMinutes % 60}m sleep'
            ' - $eventSummary',
          ),
          trailing: night.recordingPath == null
              ? Text(
                  '${night.snoreScore}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                )
              : IconButton(
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
        ),
      ),
    );
  }
}
