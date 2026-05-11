import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snorvy/src/domain/bedtime_reminder.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/services/sleep_recorder.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

const _snorvyBannerAsset = 'assets/brand/snorvy_logo_text_trans_background.png';
const _snorvyBannerAspectRatio = 1967 / 799;
const _brandHeaderHeight = 68.0;

typedef AudioPlayCallback =
    Future<void> Function(String filePath, {String? playbackKey});

enum _AudioTab { snore, talk }

extension _AudioTabPresentation on _AudioTab {
  String get label {
    return switch (this) {
      _AudioTab.snore => 'Snore',
      _AudioTab.talk => 'Talk',
    };
  }

  IconData get icon {
    return switch (this) {
      _AudioTab.snore => SleepEventKind.snore.icon,
      _AudioTab.talk => SleepEventKind.talk.icon,
    };
  }

  SleepEventKind? get eventKind {
    return switch (this) {
      _AudioTab.snore => SleepEventKind.snore,
      _AudioTab.talk => SleepEventKind.talk,
    };
  }
}

class TonightScreen extends StatefulWidget {
  const TonightScreen({
    required this.nights,
    required this.recordingSession,
    required this.livePowerFrames,
    required this.isBusy,
    required this.isLoading,
    required this.statusMessage,
    required this.playingAudioKey,
    required this.bedtimeReminder,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onPlayAudio,
    required this.onStopAudio,
    required this.onExportAudio,
    required this.onUnlockTap,
    required this.onUpdateBedtimeReminder,
    required this.onTestBedtimeReminder,
    required this.onToggleEventSave,
    super.key,
  });

  final List<SleepNight> nights;
  final RecordingSession recordingSession;
  final List<RecordingPowerFrame> livePowerFrames;
  final bool isBusy;
  final bool isLoading;
  final String? statusMessage;
  final String? playingAudioKey;
  final BedtimeReminder bedtimeReminder;
  final Future<void> Function() onStartRecording;
  final Future<void> Function() onStopRecording;
  final AudioPlayCallback onPlayAudio;
  final Future<void> Function() onStopAudio;
  final Future<void> Function(String filePath) onExportAudio;
  final VoidCallback onUnlockTap;
  final Future<void> Function(BedtimeReminder reminder)
      onUpdateBedtimeReminder;
  final Future<void> Function() onTestBedtimeReminder;
  final Future<void> Function(SleepEvent event, bool saved) onToggleEventSave;

  @override
  State<TonightScreen> createState() => _TonightScreenState();
}

class _TonightScreenState extends State<TonightScreen> {
  _AudioTab _selectedTab = _AudioTab.snore;

  @override
  Widget build(BuildContext context) {
    final latestNight = widget.nights.isEmpty ? null : widget.nights.first;
    final todayNights = latestNight == null
        ? const <SleepNight>[]
        : widget.nights.where((night) {
            return night.date.year == latestNight.date.year &&
                night.date.month == latestNight.date.month &&
                night.date.day == latestNight.date.day;
          }).toList();
    final allTodayEvents = todayNights.expand((n) => n.events).toList()
      ..sort((a, b) => b.startsAt.compareTo(a.startsAt));
    final selectedKind = _selectedTab.eventKind;
    final allEventsOfKind = allTodayEvents
        .where((event) => event.kind == selectedKind)
        .toList();
    // For snore, the model fires once per breath cycle, so we keep every
    // event in the database (so the total-snore-time stat stays accurate)
    // but only surface the loudest 5 in the UI - the user wants to hear
    // themselves snoring like an animal a handful of times, not 200.
    final isSnore = selectedKind == SleepEventKind.snore;
    const snoreHighlightCount = 5;
    final events = isSnore && allEventsOfKind.length > snoreHighlightCount
        ? (allEventsOfKind.toList()
            ..sort((a, b) => b.intensity.compareTo(a.intensity)))
            .take(snoreHighlightCount)
            .toList()
        : allEventsOfKind;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            _brandHeaderHeight + 14,
            20,
            126,
          ),
          children: [
            const _TonightHeader(),
            const SizedBox(height: 18),
            _RecordingPanel(
              session: widget.recordingSession,
              livePowerFrames: widget.livePowerFrames,
              isBusy: widget.isBusy,
              statusMessage: widget.statusMessage,
              onStartRecording: widget.onStartRecording,
              onStopRecording: widget.onStopRecording,
            ),
            const SizedBox(height: 14),
            _BedtimeReminderPanel(
              reminder: widget.bedtimeReminder,
              onUpdate: widget.onUpdateBedtimeReminder,
              onTest: widget.onTestBedtimeReminder,
            ),
            if (latestNight != null) ...[
              const SizedBox(height: 14),
              _TonightStats(nights: todayNights),
            ],
            const SizedBox(height: 22),
            _SectionHeader(
              title: isSnore && allEventsOfKind.length > snoreHighlightCount
                  ? 'Top $snoreHighlightCount loudest snores'
                  : 'Audio clips',
              actionLabel: allTodayEvents.isEmpty
                  ? null
                  : '${allTodayEvents.length} saved today',
            ),
            const SizedBox(height: 12),
            _AudioTabs(
              selected: _selectedTab,
              events: allTodayEvents,
              onSelected: (tab) => setState(() => _selectedTab = tab),
            ),
            const SizedBox(height: 10),
            if (widget.isLoading)
              const _LoadingPanel()
            else if (events.isEmpty)
              _EmptyTimelinePanel(
                message:
                    'No ${_selectedTab.label.toLowerCase()} events saved yet.',
              )
            else
              ...events.map(
                (event) => _TimelineEventTile(
                  event: event,
                  isBusy: widget.isBusy,
                  isPlaying: widget.playingAudioKey == _eventPlaybackKey(event),
                  onPlayAudio: widget.onPlayAudio,
                  onStopAudio: widget.onStopAudio,
                  onToggleSave: widget.onToggleEventSave,
                ),
              ),
          ],
        ),
        _BrandHeader(onUnlockTap: widget.onUnlockTap),
      ],
    );
  }
}

String _eventPlaybackKey(SleepEvent event) {
  return 'event:${event.id}:${event.filePath ?? ''}';
}

class _TonightHeader extends StatelessWidget {
  const _TonightHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            Icons.bedtime,
            color: SnorvyTheme.neuralMint,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("TONIGHT'S SESSION", style: SnorvyTheme.labelStyle(context)),
              const SizedBox(height: 3),
              Text('Tonight', style: SnorvyTheme.screenTitleStyle(context)),
              Text(
                'Record, listen back, and decide what to keep.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.onUnlockTap});

  final VoidCallback onUnlockTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 20,
      right: 20,
      child: SizedBox(
        height: _brandHeaderHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xEEF5FAFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x66FFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 7, 8, 7),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AspectRatio(
                      aspectRatio: _snorvyBannerAspectRatio,
                      child: Image.asset(
                        _snorvyBannerAsset,
                        semanticLabel: 'Snorvy banner',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _UnlockPill(onUnlockTap: onUnlockTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnlockPill extends StatelessWidget {
  const _UnlockPill({required this.onUnlockTap});

  final VoidCallback onUnlockTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerLowest.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: SnorvyTheme.midnightBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onUnlockTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_open, size: 15, color: SnorvyTheme.neuralMint),
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
    );
  }
}

class _RecordingPanel extends StatefulWidget {
  const _RecordingPanel({
    required this.session,
    required this.livePowerFrames,
    required this.isBusy,
    required this.statusMessage,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  final RecordingSession session;
  final List<RecordingPowerFrame> livePowerFrames;
  final bool isBusy;
  final String? statusMessage;
  final Future<void> Function() onStartRecording;
  final Future<void> Function() onStopRecording;

  @override
  State<_RecordingPanel> createState() => _RecordingPanelState();
}

class _RecordingPanelState extends State<_RecordingPanel> {
  Timer? _elapsedTimer;

  @override
  void initState() {
    super.initState();
    _syncElapsedTimer();
  }

  @override
  void didUpdateWidget(covariant _RecordingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.status != widget.session.status ||
        oldWidget.session.startedAt != widget.session.startedAt) {
      _syncElapsedTimer();
    }
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    super.dispose();
  }

  void _syncElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    if (widget.session.status != RecordingStatus.recording ||
        widget.session.startedAt == null) {
      return;
    }

    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRecording = widget.session.status == RecordingStatus.recording;
    final statusColor = isRecording
        ? SnorvyTheme.neuralMint
        : SnorvyTheme.midnightTextFaint;
    final elapsed = !isRecording || widget.session.startedAt == null
        ? Duration.zero
        : DateTime.now().difference(widget.session.startedAt!);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isRecording
            ? const Color(0xFF15252A)
            : colorScheme.surfaceContainerLow,
        border: Border.all(
          color: isRecording
              ? const Color(0x4471E3CF)
              : SnorvyTheme.midnightBorder,
        ),
        boxShadow: [
          if (isRecording)
            const BoxShadow(
              color: Color(0x1F21D8C0),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 14),
              _Waveform(
                active: isRecording,
                color: SnorvyTheme.neuralMint,
                frames: widget.livePowerFrames,
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: isRecording
                      ? colorScheme.onSurface
                      : SnorvyTheme.neuralMint,
                  foregroundColor: isRecording
                      ? SnorvyTheme.midnight
                      : SnorvyTheme.midnight,
                ),
                onPressed: widget.isBusy
                    ? null
                    : () async {
                        if (isRecording) {
                          await widget.onStopRecording();
                        } else {
                          await widget.onStartRecording();
                        }
                      },
                icon: Icon(isRecording ? Icons.stop : Icons.nightlight),
                label: Text(
                  widget.isBusy
                      ? 'Working...'
                      : isRecording
                      ? 'Stop recording'
                      : 'Start local recording',
                ),
              ),
              if (widget.statusMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.statusMessage!,
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
  const _Waveform({
    required this.active,
    required this.color,
    this.frames = const [],
  });

  final bool active;
  final Color color;
  final List<RecordingPowerFrame> frames;

  @override
  Widget build(BuildContext context) {
    final dim = Theme.of(context).colorScheme.outlineVariant;

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: CustomPaint(
        painter: _WaveformPainter(
          active: active,
          color: color,
          dimColor: dim,
          bars: 48,
          meterMode: true,
          levels: frames.map((frame) => frame.decibels).toList(growable: false),
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
          meterMode: false,
          levels: const [],
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
    required this.meterMode,
    required this.levels,
    this.intensity = 1,
  });

  final bool active;
  final Color color;
  final Color dimColor;
  final int bars;
  final bool meterMode;
  final List<double> levels;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = active ? color : dimColor
      ..style = PaintingStyle.fill;
    final gap = size.width / bars;
    final barWidth = math.max(1.6, gap * 0.34);
    final center = size.height / 2;

    final meterLevels = _expandedMeterLevels();
    for (var i = 0; i < bars; i++) {
      final level = meterLevels?[i];
      final seed =
          0.28 + 0.72 * (math.sin(i * 1.7).abs() * math.cos(i * 0.41).abs());
      final height = level == null
          ? math.max<double>(
              2,
              seed *
                  size.height *
                  (active
                      ? 0.42 + 0.58 * math.sin(i * 0.43 + intensity).abs()
                      : 0.44) *
                  intensity,
            )
          : 2 + level * (size.height - 4);
      final x = i * gap + (gap - barWidth) / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, center - height / 2, barWidth, height),
        Radius.circular(barWidth),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  List<double>? _expandedMeterLevels() {
    if (!meterMode) {
      return null;
    }
    if (!active || levels.isEmpty) {
      return List<double>.filled(bars, 0);
    }

    final normalized = _normalizeLevels(levels);
    return [
      for (var i = 0; i < bars; i++)
        normalized[(i * normalized.length / bars)
            .floor()
            .clamp(0, normalized.length - 1)
            .toInt()],
    ];
  }

  List<double> _normalizeLevels(List<double> values) {
    final finiteValues = values.where((value) => value.isFinite).toList();
    if (finiteValues.isEmpty) {
      return const [0];
    }

    final rawLevels = finiteValues.map(_rawLevel).toList(growable: false);
    final floor = _percentile(rawLevels, 0.35);
    final peak = _percentile(rawLevels, 0.95);
    final dynamicRange = math.max(8, peak - floor);

    return [
      for (final raw in rawLevels)
        math
            .pow(
              ((raw - floor - 3) / dynamicRange).clamp(0, 1).toDouble(),
              0.72,
            )
            .toDouble(),
    ];
  }

  double _rawLevel(double decibels) {
    if (decibels < 0) {
      return (decibels + 60).clamp(0, 80).toDouble();
    }

    return decibels.clamp(0, 90).toDouble();
  }

  double _percentile(List<double> values, double percentile) {
    final sorted = [...values]..sort();
    final index = ((sorted.length - 1) * percentile).round();
    return sorted[index.clamp(0, sorted.length - 1).toInt()];
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.active != active ||
        oldDelegate.color != color ||
        oldDelegate.dimColor != dimColor ||
        oldDelegate.intensity != intensity ||
        oldDelegate.bars != bars ||
        oldDelegate.meterMode != meterMode ||
        oldDelegate.levels != levels;
  }
}

String _formatMinutes(int totalMinutes) {
  if (totalMinutes < 60) return '${totalMinutes}m';
  final hours = totalMinutes ~/ 60;
  final mins = totalMinutes % 60;
  return mins == 0 ? '${hours}h' : '${hours}h ${mins}m';
}

class _TonightStats extends StatelessWidget {
  const _TonightStats({required this.nights});

  final List<SleepNight> nights;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, MMM d');
    final referenceDate = nights.isEmpty ? DateTime.now() : nights.first.date;
    final snoreMinutes = nights.fold<int>(0, (t, n) => t + n.snoreMinutes);
    final snoreCount = nights.fold<int>(0, (t, n) => t + n.snoreCount);
    final talkMinutes = nights.fold<int>(0, (t, n) => t + n.talkMinutes);
    final totalDuration = nights.fold<Duration>(
      Duration.zero,
      (t, n) => t + n.duration,
    );

    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            label: 'Snoring',
            value: _formatMinutes(snoreMinutes),
            sub: '$snoreCount events',
            accent: SnorvyTheme.neuralMint,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MetricTile(
            label: 'Talk',
            value: _formatMinutes(talkMinutes),
            sub: 'audio',
            accent: SnorvyTheme.talkAmber,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MetricTile(
            label: formatter.format(referenceDate),
            value:
                '${totalDuration.inHours}h ${totalDuration.inMinutes % 60}m',
            sub: nights.length > 1 ? '${nights.length} sessions' : 'rest',
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
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SnorvyTheme.labelStyle(context),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: SnorvyTheme.displayStyle(
                  context,
                  size: 24,
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

class _AudioTabs extends StatelessWidget {
  const _AudioTabs({
    required this.selected,
    required this.events,
    required this.onSelected,
  });

  final _AudioTab selected;
  final List<SleepEvent> events;
  final ValueChanged<_AudioTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final tab in _AudioTab.values)
          FilterChip(
            avatar: Icon(tab.icon, size: 18),
            label: Text(_labelFor(tab)),
            selected: selected == tab,
            onSelected: (_) => onSelected(tab),
          ),
      ],
    );
  }

  String _labelFor(_AudioTab tab) {
    if (events.isEmpty) {
      return tab.label;
    }
    final count = events.where((event) => event.kind == tab.eventKind).length;
    return '${tab.label} ($count)';
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final actionLabel = this.actionLabel;

    return Row(
      children: [
        Expanded(
          child: Text(title, style: SnorvyTheme.sectionTitleStyle(context)),
        ),
        if (actionLabel != null)
          Text(
            actionLabel,
            style: SnorvyTheme.labelStyle(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
  const _EmptyTimelinePanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.timeline,
                color: SnorvyTheme.neuralMint,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
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
    required this.onToggleSave,
  });

  final SleepEvent event;
  final bool isBusy;
  final bool isPlaying;
  final AudioPlayCallback onPlayAudio;
  final Future<void> Function() onStopAudio;
  final Future<void> Function(SleepEvent event, bool saved) onToggleSave;

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
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SnorvyTheme.midnightBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          await onPlayAudio(
                            filePath,
                            playbackKey: _eventPlaybackKey(event),
                          );
                        }
                      },
                icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                color: color,
                style: IconButton.styleFrom(
                  backgroundColor: color.withValues(alpha: 0.14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
              const SizedBox(width: 4),
              IconButton(
                tooltip: event.isSaved
                    ? 'Saved - tap to forget'
                    : 'Save (keep past today)',
                onPressed: isBusy
                    ? null
                    : () => onToggleSave(event, !event.isSaved),
                icon: Icon(
                  event.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: event.isSaved
                      ? SnorvyTheme.neuralMint
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BedtimeReminderPanel extends StatelessWidget {
  const _BedtimeReminderPanel({
    required this.reminder,
    required this.onUpdate,
    required this.onTest,
  });

  final BedtimeReminder reminder;
  final Future<void> Function(BedtimeReminder reminder) onUpdate;
  final Future<void> Function() onTest;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = reminder.enabled;
    final timeLabel =
        '${reminder.time.hour.toString().padLeft(2, '0')}:'
        '${reminder.time.minute.toString().padLeft(2, '0')}';
    final nextFireLabel = _nextFireLabel(reminder.time);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: SnorvyTheme.midnightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: 18,
                  color: enabled
                      ? SnorvyTheme.neuralMint
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bedtime reminder',
                    style: SnorvyTheme.labelStyle(context).copyWith(
                      color: enabled
                          ? SnorvyTheme.neuralMint
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Switch(
                  value: enabled,
                  onChanged: (value) =>
                      onUpdate(reminder.copyWith(enabled: value)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: enabled ? 1 : 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Remind me at',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurface),
                        ),
                      ),
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.surfaceContainerHigh,
                          foregroundColor: colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: enabled
                            ? () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: reminder.time,
                                  builder: (context, child) => MediaQuery(
                                    data: MediaQuery.of(context).copyWith(
                                      alwaysUse24HourFormat: true,
                                    ),
                                    child: child ?? const SizedBox.shrink(),
                                  ),
                                );
                                if (picked != null) {
                                  await onUpdate(
                                    reminder.copyWith(time: picked),
                                  );
                                }
                              }
                            : null,
                        child: Text(
                          timeLabel,
                          style: const TextStyle(
                            fontFeatures: [FontFeature.tabularFigures()],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: SnorvyTheme.neuralMint.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          size: 16,
                          color: SnorvyTheme.neuralMint,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Next reminder: $nextFireLabel',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A daily nudge to open Snorvy. You can turn it off anytime.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onTest,
                      icon: const Icon(Icons.send_outlined, size: 16),
                      label: const Text('Send test reminder now'),
                      style: TextButton.styleFrom(
                        foregroundColor: SnorvyTheme.neuralMint,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _nextFireLabel(TimeOfDay time) {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    final nextDay = DateTime(next.year, next.month, next.day);
    if (nextDay == today) return 'today $hh:$mm';
    if (nextDay == tomorrow) return 'tomorrow $hh:$mm';
    return '$hh:$mm';
  }
}
