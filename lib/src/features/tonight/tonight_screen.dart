import 'dart:math' as math;

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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 126),
      children: [
        _Header(onUnlockTap: widget.onUnlockTap),
        const SizedBox(height: 22),
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
        const SizedBox(height: 26),
        RichText(
          text: TextSpan(
            style: SnorvyTheme.displayStyle(context, size: 30),
            children: [
              const TextSpan(text: 'Last night '),
              TextSpan(
                text: 'timeline',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
          ...events.map(
            (event) => _TimelineEventTile(
              event: event,
              isBusy: widget.isBusy,
              isPlaying:
                  event.filePath != null &&
                  widget.playingPath == event.filePath,
              onPlayAudio: widget.onPlayAudio,
              onStopAudio: widget.onStopAudio,
            ),
          ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.library_music,
                    color: SnorvyTheme.neuralMint,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Full-night recording',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
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
    final now = DateTime.now();
    final dayLabel = DateFormat('EEE - d MMM').format(now);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Snorvy', style: SnorvyTheme.labelStyle(context)),
                  Text(' - $dayLabel', style: SnorvyTheme.labelStyle(context)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Tonight.',
                style: SnorvyTheme.displayStyle(
                  context,
                ).copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                'Records locally. Playback stays unlocked.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerLowest.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: SnorvyTheme.midnightBorder),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onUnlockTap,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_open,
                    size: 15,
                    color: SnorvyTheme.neuralMint,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '\$9.99',
                    style: TextStyle(
                      color: SnorvyTheme.neuralMint,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    final statusColor = isRecording
        ? SnorvyTheme.neuralMint
        : SnorvyTheme.midnightTextFaint;
    final elapsed = session.startedAt == null
        ? Duration.zero
        : DateTime.now().difference(session.startedAt!);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: isRecording
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x3321D8C0), SnorvyTheme.midnightSurface],
              )
            : null,
        color: isRecording ? null : colorScheme.surfaceContainerLow,
        border: Border.all(
          color: isRecording
              ? const Color(0x4471E3CF)
              : SnorvyTheme.midnightBorder,
        ),
        boxShadow: [
          if (isRecording)
            const BoxShadow(
              color: Color(0x2221D8C0),
              blurRadius: 44,
              offset: Offset(0, 18),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      boxShadow: isRecording
                          ? [
                              BoxShadow(
                                color: SnorvyTheme.neuralMint.withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: 14,
                                spreadRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isRecording
                          ? 'Recording - local mic'
                          : 'Ready for tonight',
                      style: SnorvyTheme.labelStyle(context).copyWith(
                        color: isRecording
                            ? SnorvyTheme.neuralMint
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    _durationLabel(elapsed),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _Waveform(active: isRecording, color: SnorvyTheme.neuralMint),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: isRecording
                      ? colorScheme.onSurface
                      : SnorvyTheme.neuralMint,
                  foregroundColor: isRecording
                      ? SnorvyTheme.midnight
                      : SnorvyTheme.midnight,
                ),
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
      ),
    );
  }

  String _durationLabel(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform({required this.active, required this.color});

  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dim = Theme.of(context).colorScheme.outlineVariant;

    return SizedBox(
      height: 66,
      width: double.infinity,
      child: CustomPaint(
        painter: _WaveformPainter(
          active: active,
          color: color,
          dimColor: dim,
          bars: 48,
        ),
      ),
    );
  }
}

class _StaticWaveform extends StatelessWidget {
  const _StaticWaveform({required this.color, required this.intensity});

  final Color color;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      width: 92,
      child: CustomPaint(
        painter: _WaveformPainter(
          active: true,
          color: color,
          dimColor: color,
          bars: 28,
          intensity: intensity,
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  const _WaveformPainter({
    required this.active,
    required this.color,
    required this.dimColor,
    required this.bars,
    this.intensity = 1,
  });

  final bool active;
  final Color color;
  final Color dimColor;
  final int bars;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = active ? color : dimColor
      ..style = PaintingStyle.fill;
    final gap = size.width / bars;
    final barWidth = math.max(1.6, gap * 0.34);
    final center = size.height / 2;

    for (var i = 0; i < bars; i++) {
      final seed =
          0.28 + 0.72 * (math.sin(i * 1.7).abs() * math.cos(i * 0.41).abs());
      final activeScale = active
          ? 0.42 + 0.58 * math.sin(i * 0.43 + intensity).abs()
          : 0.44;
      final height = math.max<double>(
        2,
        seed * size.height * activeScale * intensity,
      );
      final x = i * gap + (gap - barWidth) / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, center - height / 2, barWidth, height),
        Radius.circular(barWidth),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.active != active ||
        oldDelegate.color != color ||
        oldDelegate.dimColor != dimColor ||
        oldDelegate.intensity != intensity ||
        oldDelegate.bars != bars;
  }
}

class _TonightStats extends StatelessWidget {
  const _TonightStats({required this.night});

  final SleepNight night;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, MMM d');

    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            label: 'Snore',
            value: '${night.snoreScore}',
            sub: 'score',
            accent: SnorvyTheme.neuralMint,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MetricTile(
            label: 'Talk',
            value: '${night.talkMinutes}m',
            sub: 'audio',
            accent: SnorvyTheme.talkAmber,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MetricTile(
            label: formatter.format(night.date),
            value:
                '${night.duration.inHours}h ${night.duration.inMinutes % 60}m',
            sub: 'rest',
            accent: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.sub,
    required this.accent,
  });

  final String label;
  final String value;
  final String sub;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: SnorvyTheme.labelStyle(context)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: SnorvyTheme.displayStyle(
                  context,
                  size: 26,
                  color: accent,
                ),
              ),
            ),
            Text(
              sub,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
      spacing: 6,
      runSpacing: 6,
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
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.timeline,
                color: SnorvyTheme.neuralMint,
                size: 20,
              ),
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
  const _TimelineEventTile({
    required this.event,
    required this.isBusy,
    required this.isPlaying,
    required this.onPlayAudio,
    required this.onStopAudio,
  });

  final SleepEvent event;
  final bool isBusy;
  final bool isPlaying;
  final Future<void> Function(String filePath) onPlayAudio;
  final Future<void> Function() onStopAudio;

  @override
  Widget build(BuildContext context) {
    final filePath = event.filePath;
    final color = event.kind == SleepEventKind.talk
        ? SnorvyTheme.talkAmber
        : SnorvyTheme.neuralMint;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SnorvyTheme.midnightBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              IconButton.filledTonal(
                tooltip: isPlaying
                    ? 'Stop source recording'
                    : 'Play source recording',
                onPressed: isBusy || filePath == null
                    ? null
                    : () async {
                        if (isPlaying) {
                          await onStopAudio();
                        } else {
                          await onPlayAudio(filePath);
                        }
                      },
                icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                color: color,
                style: IconButton.styleFrom(
                  backgroundColor: color.withValues(alpha: 0.14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          event.timeLabel,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          event.kind.label,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          event.durationLabel,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: SnorvyTheme.midnightTextFaint),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _StaticWaveform(
                      color: color,
                      intensity: math.max(0.45, event.intensity / 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
