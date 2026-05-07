import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

class TonightScreen extends StatefulWidget {
  const TonightScreen({
    required this.nights,
    required this.recordingSession,
    required this.isBusy,
    required this.isLoading,
    required this.statusMessage,
    required this.playingPath,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onPlayAudio,
    required this.onStopAudio,
    required this.onExportAudio,
    required this.onUnlockTap,
    super.key,
  });

  final List<SleepNight> nights;
  final RecordingSession recordingSession;
  final bool isBusy;
  final bool isLoading;
  final String? statusMessage;
  final String? playingPath;
  final Future<void> Function() onStartRecording;
  final Future<void> Function() onStopRecording;
  final Future<void> Function(String filePath) onPlayAudio;
  final Future<void> Function() onStopAudio;
  final Future<void> Function(String filePath) onExportAudio;
  final VoidCallback onUnlockTap;

  @override
  State<TonightScreen> createState() => _TonightScreenState();
}

class _TonightScreenState extends State<TonightScreen> {
  SleepEventKind? _filter;

  @override
  Widget build(BuildContext context) {
    final latestNight = widget.nights.isEmpty ? null : widget.nights.first;
    final events = (latestNight?.events ?? const <SleepEvent>[])
        .where((event) => _filter == null || event.kind == _filter)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        _Header(onUnlockTap: widget.onUnlockTap),
        const SizedBox(height: 18),
        _RecordingPanel(
          session: widget.recordingSession,
          isBusy: widget.isBusy,
          statusMessage: widget.statusMessage,
          onStartRecording: widget.onStartRecording,
          onStopRecording: widget.onStopRecording,
        ),
        if (latestNight != null) ...[
          const SizedBox(height: 14),
          _TonightStats(night: latestNight),
        ],
        if (latestNight?.recordingPath case final recordingPath?) ...[
          const SizedBox(height: 14),
          _FullNightRecordingPanel(
            recordingPath: recordingPath,
            isBusy: widget.isBusy,
            isPlaying: widget.playingPath == recordingPath,
            onPlayAudio: widget.onPlayAudio,
            onStopAudio: widget.onStopAudio,
            onExportAudio: widget.onExportAudio,
          ),
        ],
        const SizedBox(height: 18),
        Text(
          'Last night timeline',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        _TimelineFilters(
          selected: _filter,
          onSelected: (kind) => setState(() => _filter = kind),
        ),
        const SizedBox(height: 10),
        if (widget.isLoading)
          const _LoadingPanel()
        else if (events.isEmpty)
          const _EmptyTimelinePanel()
        else
          ...events.map((event) => _TimelineEventTile(event: event)),
      ],
    );
  }
}

class _FullNightRecordingPanel extends StatelessWidget {
  const _FullNightRecordingPanel({
    required this.recordingPath,
    required this.isBusy,
    required this.isPlaying,
    required this.onPlayAudio,
    required this.onStopAudio,
    required this.onExportAudio,
  });

  final String recordingPath;
  final bool isBusy;
  final bool isPlaying;
  final Future<void> Function(String filePath) onPlayAudio;
  final Future<void> Function() onStopAudio;
  final Future<void> Function(String filePath) onExportAudio;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.library_music, color: SnorvyTheme.moss),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Full-night recording',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: isBusy
                      ? null
                      : () async {
                          if (isPlaying) {
                            await onStopAudio();
                          } else {
                            await onPlayAudio(recordingPath);
                          }
                        },
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  label: Text(isPlaying ? 'Stop' : 'Play'),
                ),
                OutlinedButton.icon(
                  onPressed: isBusy
                      ? null
                      : () async => onExportAudio(recordingPath),
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Export'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onUnlockTap});

  final VoidCallback onUnlockTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Snorvy',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Records locally. Playback stays unlocked.',
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: onUnlockTap,
          icon: const Icon(Icons.lock_open),
          label: const Text('\$9.99'),
        ),
      ],
    );
  }
}

class _RecordingPanel extends StatelessWidget {
  const _RecordingPanel({
    required this.session,
    required this.isBusy,
    required this.statusMessage,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  final RecordingSession session;
  final bool isBusy;
  final String? statusMessage;
  final Future<void> Function() onStartRecording;
  final Future<void> Function() onStopRecording;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRecording = session.status == RecordingStatus.recording;
    final statusColor = isRecording ? SnorvyTheme.coral : SnorvyTheme.moss;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isRecording ? Icons.mic : Icons.mic_none,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRecording
                            ? 'Recording overnight'
                            : 'Ready for tonight',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        isRecording
                            ? 'Audio is being kept on this phone.'
                            : 'Local mic capture with snore and talk events.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: isBusy
                  ? null
                  : () async {
                      if (isRecording) {
                        await onStopRecording();
                      } else {
                        await onStartRecording();
                      }
                    },
              icon: Icon(isRecording ? Icons.stop : Icons.nightlight),
              label: Text(
                isBusy
                    ? 'Working...'
                    : isRecording
                    ? 'Stop recording'
                    : 'Start local recording',
              ),
            ),
            if (statusMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                statusMessage!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TonightStats extends StatelessWidget {
  const _TonightStats({required this.night});

  final SleepNight night;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, MMM d');

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _MetricTile(
          label: 'Snore score',
          value: '${night.snoreScore}',
          icon: Icons.speed,
          accent: SnorvyTheme.coral,
        ),
        _MetricTile(
          label: 'Snore audio',
          value: '${night.snoreMinutes}m',
          icon: Icons.graphic_eq,
          accent: SnorvyTheme.amber,
        ),
        _MetricTile(
          label: formatter.format(night.date),
          value: '${night.duration.inHours}h ${night.duration.inMinutes % 60}m',
          icon: Icons.schedule,
          accent: SnorvyTheme.moss,
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accent),
              const SizedBox(height: 10),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineFilters extends StatelessWidget {
  const _TimelineFilters({required this.selected, required this.onSelected});

  final SleepEventKind? selected;
  final ValueChanged<SleepEventKind?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(
          label: const Text('All'),
          selected: selected == null,
          onSelected: (_) => onSelected(null),
        ),
        for (final kind in [SleepEventKind.snore, SleepEventKind.talk])
          FilterChip(
            avatar: Icon(kind.icon, size: 18),
            label: Text(kind.label),
            selected: selected == kind,
            onSelected: (_) => onSelected(kind),
          ),
      ],
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _EmptyTimelinePanel extends StatelessWidget {
  const _EmptyTimelinePanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.timeline,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'No saved audio events yet. Start recording tonight.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineEventTile extends StatelessWidget {
  const _TimelineEventTile({required this.event});

  final SleepEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: event.kind.accent.withValues(alpha: 0.16),
            foregroundColor: event.kind.accent,
            child: Icon(event.kind.icon),
          ),
          title: Text('${event.kind.label} at ${event.timeLabel}'),
          subtitle: Text(
            '${event.durationLabel} - intensity ${event.intensity}%',
          ),
          trailing: IconButton(
            tooltip: 'Play event',
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Playback preview: ${event.kind.label.toLowerCase()} clip '
                    '${event.timeLabel}',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
