import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({required this.nights, super.key});

  final List<SleepNight> nights;

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
        ...nights.map((night) => _NightHistoryTile(night: night)),
      ],
    );
  }
}

class _NightHistoryTile extends StatelessWidget {
  const _NightHistoryTile({required this.night});

  final SleepNight night;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, MMM d').format(night.date);
    final manualSuffix = night.isManual ? ' - manual log' : '';

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
            ' - ${night.events.length} audio events',
          ),
          trailing: Text(
            '${night.snoreScore}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
