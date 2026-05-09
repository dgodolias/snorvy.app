import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    required this.nights,
    required this.isLoading,
    required this.isBusy,
    required this.playingAudioKey,
    required this.onPlayAudio,
    required this.onStopAudio,
    required this.onDeleteNight,
    super.key,
  });

  final List<SleepNight> nights;
  final bool isLoading;
  final bool isBusy;
  final String? playingAudioKey;
  final Future<void> Function(String filePath, {String? playbackKey})
  onPlayAudio;
  final Future<void> Function() onStopAudio;
  final Future<void> Function(SleepNight night) onDeleteNight;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

enum _AudioTab { snore, talk }

extension _AudioTabPresentation on _AudioTab {
  String get label => switch (this) {
    _AudioTab.snore => 'Snore',
    _AudioTab.talk => 'Talk',
  };

  IconData get icon => switch (this) {
    _AudioTab.snore => SleepEventKind.snore.icon,
    _AudioTab.talk => SleepEventKind.talk.icon,
  };

  SleepEventKind get eventKind => switch (this) {
    _AudioTab.snore => SleepEventKind.snore,
    _AudioTab.talk => SleepEventKind.talk,
  };
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _selectedDay;
  late DateTime _visibleMonth;
  _AudioTab _selectedTab = _AudioTab.snore;

  @override
  void initState() {
    super.initState();
    final initial = _initialSelectedDay(widget.nights);
    _selectedDay = initial;
    _visibleMonth = DateTime(initial.year, initial.month);
  }

  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nights.isEmpty && widget.nights.isNotEmpty) {
      final initial = _initialSelectedDay(widget.nights);
      setState(() {
        _selectedDay = initial;
        _visibleMonth = DateTime(initial.year, initial.month);
      });
    }
  }

  static DateTime _initialSelectedDay(List<SleepNight> nights) {
    if (nights.isEmpty) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day);
    }
    final mostRecent = nights.first.date;
    return DateTime(mostRecent.year, mostRecent.month, mostRecent.day);
  }

  @override
  Widget build(BuildContext context) {
    final selectedNights = _nightsFor(_selectedDay);
    final selectedEvents = selectedNights.expand((n) => n.events).toList()
      ..sort((a, b) => b.startsAt.compareTo(a.startsAt));
    final filteredEvents = selectedEvents
        .where((e) => e.kind == _selectedTab.eventKind)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 126),
      children: [
        const _HistoryHeader(),
        const SizedBox(height: 18),
        if (widget.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (widget.nights.isEmpty)
          const _EmptyHistoryPanel()
        else ...[
          _CalendarPanel(
            visibleMonth: _visibleMonth,
            selectedDay: _selectedDay,
            nights: widget.nights,
            mode: _selectedTab,
            onMonthChanged: (m) => setState(() => _visibleMonth = m),
            onDaySelected: (d) => setState(() => _selectedDay = d),
            onModeChanged: (m) => setState(() => _selectedTab = m),
          ),
          const SizedBox(height: 14),
          _DayStats(day: _selectedDay, nights: selectedNights),
          const SizedBox(height: 18),
          if (selectedNights.isEmpty)
            _NoDataForDayPanel(day: _selectedDay)
          else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_selectedTab.label} clips',
                    style: SnorvyTheme.sectionTitleStyle(context),
                  ),
                ),
                Text(
                  '${filteredEvents.length} on this day',
                  style: SnorvyTheme.labelStyle(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (filteredEvents.isEmpty)
              _EmptyEventsPanel(
                message:
                    'No ${_selectedTab.label.toLowerCase()} events on this day.',
              )
            else
              ...filteredEvents.map(
                (event) => _EventTile(
                  event: event,
                  isBusy: widget.isBusy,
                  isPlaying:
                      widget.playingAudioKey == _eventPlaybackKey(event),
                  onPlayAudio: widget.onPlayAudio,
                  onStopAudio: widget.onStopAudio,
                ),
              ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: widget.isBusy
                    ? null
                    : () => _confirmDeleteDay(context, selectedNights),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: Text(
                  selectedNights.length > 1
                      ? 'Delete all ${selectedNights.length} sessions on this day'
                      : 'Delete this day',
                ),
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  List<SleepNight> _nightsFor(DateTime day) {
    return widget.nights.where((night) {
      return night.date.year == day.year &&
          night.date.month == day.month &&
          night.date.day == day.day;
    }).toList();
  }

  Future<void> _confirmDeleteDay(
    BuildContext context,
    List<SleepNight> nights,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this day?'),
        content: Text(
          nights.length > 1
              ? 'This removes ${nights.length} sessions and any saved audio for ${DateFormat('EEE, MMM d').format(_selectedDay)} from this phone.'
              : 'This removes the sleep log and any saved audio from this phone.',
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
      ),
    );
    if (confirmed != true) return;
    for (final night in nights) {
      await widget.onDeleteNight(night);
    }
  }
}

String _eventPlaybackKey(SleepEvent event) {
  return 'event:${event.id}:${event.filePath ?? ''}';
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
            Icons.calendar_month,
            color: SnorvyTheme.neuralMint,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SLEEP CALENDAR', style: SnorvyTheme.labelStyle(context)),
              const SizedBox(height: 3),
              Text('History', style: SnorvyTheme.screenTitleStyle(context)),
              Text(
                'Tap a day to see what happened that night.',
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

class _CalendarPanel extends StatelessWidget {
  const _CalendarPanel({
    required this.visibleMonth,
    required this.selectedDay,
    required this.nights,
    required this.mode,
    required this.onMonthChanged,
    required this.onDaySelected,
    required this.onModeChanged,
  });

  final DateTime visibleMonth;
  final DateTime selectedDay;
  final List<SleepNight> nights;
  final _AudioTab mode;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<_AudioTab> onModeChanged;

  Color get _accent => switch (mode) {
    _AudioTab.snore => SnorvyTheme.neuralMint,
    _AudioTab.talk => SnorvyTheme.talkAmber,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final monthLabel = DateFormat('MMMM yyyy').format(visibleMonth);
    final maxCount = _maxCountInMonth();

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: SnorvyTheme.midnightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => onMonthChanged(
                    DateTime(visibleMonth.year, visibleMonth.month - 1),
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      monthLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isCurrentMonth()
                      ? null
                      : () => onMonthChanged(
                          DateTime(visibleMonth.year, visibleMonth.month + 1),
                        ),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _HeatmapModeToggle(selected: mode, onSelected: onModeChanged),
            const SizedBox(height: 10),
            _WeekdayHeader(),
            const SizedBox(height: 6),
            _CalendarGrid(
              visibleMonth: visibleMonth,
              selectedDay: selectedDay,
              maxCount: maxCount,
              accent: _accent,
              countFor: _countFor,
              hasDataFor: _hasDataFor,
              onDaySelected: onDaySelected,
            ),
          ],
        ),
      ),
    );
  }

  bool _isCurrentMonth() {
    final now = DateTime.now();
    return visibleMonth.year == now.year && visibleMonth.month == now.month;
  }

  int _maxCountInMonth() {
    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    var max = 1;
    for (var d = 1; d <= daysInMonth; d++) {
      final day = DateTime(visibleMonth.year, visibleMonth.month, d);
      final count = _countFor(day);
      if (count > max) max = count;
    }
    return max;
  }

  int _countFor(DateTime day) {
    final kind = mode.eventKind;
    return nights
        .where(
          (n) =>
              n.date.year == day.year &&
              n.date.month == day.month &&
              n.date.day == day.day,
        )
        .expand((n) => n.events)
        .where((e) => e.kind == kind)
        .length;
  }

  bool _hasDataFor(DateTime day) {
    return nights.any(
      (n) =>
          n.date.year == day.year &&
          n.date.month == day.month &&
          n.date.day == day.day,
    );
  }
}

class _HeatmapModeToggle extends StatelessWidget {
  const _HeatmapModeToggle({required this.selected, required this.onSelected});

  final _AudioTab selected;
  final ValueChanged<_AudioTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        for (final tab in _AudioTab.values)
          ChoiceChip(
            avatar: Icon(
              tab.icon,
              size: 16,
              color: selected == tab
                  ? SnorvyTheme.midnight
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: Text('${tab.label} heatmap'),
            selected: selected == tab,
            selectedColor: switch (tab) {
              _AudioTab.snore => SnorvyTheme.neuralMint,
              _AudioTab.talk => SnorvyTheme.talkAmber,
            },
            labelStyle: TextStyle(
              color: selected == tab
                  ? SnorvyTheme.midnight
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onSelected(tab),
          ),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  static const _labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        for (final label in _labels)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.visibleMonth,
    required this.selectedDay,
    required this.maxCount,
    required this.accent,
    required this.countFor,
    required this.hasDataFor,
    required this.onDaySelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDay;
  final int maxCount;
  final Color accent;
  final int Function(DateTime) countFor;
  final bool Function(DateTime) hasDataFor;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(visibleMonth.year, visibleMonth.month);
    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final leadingBlanks = (firstOfMonth.weekday - 1) % 7;
    final totalCells = ((leadingBlanks + daysInMonth) / 7).ceil() * 7;

    return Column(
      children: [
        for (var row = 0; row < totalCells / 7; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: _buildCell(context, row * 7 + col, leadingBlanks,
                        daysInMonth),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCell(
    BuildContext context,
    int cellIndex,
    int leadingBlanks,
    int daysInMonth,
  ) {
    final dayNumber = cellIndex - leadingBlanks + 1;
    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return const AspectRatio(aspectRatio: 1, child: SizedBox());
    }
    final day = DateTime(visibleMonth.year, visibleMonth.month, dayNumber);
    final isSelected = day.year == selectedDay.year &&
        day.month == selectedDay.month &&
        day.day == selectedDay.day;
    final today = DateTime.now();
    final isToday = day.year == today.year &&
        day.month == today.month &&
        day.day == today.day;
    final hasData = hasDataFor(day);
    final count = countFor(day);
    final intensity = maxCount > 0
        ? (count / maxCount).clamp(0.0, 1.0).toDouble()
        : 0.0;

    final colorScheme = Theme.of(context).colorScheme;
    final dataAlpha = 0.10 + 0.65 * intensity;
    final fillColor = isSelected
        ? accent
        : hasData
            ? accent.withValues(alpha: dataAlpha)
            : Colors.transparent;
    final textColor = isSelected
        ? SnorvyTheme.midnight
        : hasData
            ? colorScheme.onSurface
            : colorScheme.onSurfaceVariant;

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Material(
          color: fillColor,
          shape: isToday && !isSelected
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: accent, width: 1.5),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onDaySelected(day),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight:
                        isSelected || isToday ? FontWeight.w800 : FontWeight.w500,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (hasData && !isSelected && count == 0)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayStats extends StatelessWidget {
  const _DayStats({required this.day, required this.nights});

  final DateTime day;
  final List<SleepNight> nights;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, MMM d').format(day);
    final snoreCount = nights.fold<int>(0, (t, n) => t + n.snoreCount);
    final talkMinutes = nights.fold<int>(0, (t, n) => t + n.talkMinutes);
    final totalDuration = nights.fold<Duration>(
      Duration.zero,
      (t, n) => t + n.duration,
    );
    final hasData = nights.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateLabel.toUpperCase(),
          style: SnorvyTheme.labelStyle(context),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Snore count',
                value: hasData ? '$snoreCount' : '-',
                sub: 'events',
                accent: SnorvyTheme.neuralMint,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricTile(
                label: 'Talk',
                value: hasData ? '${talkMinutes}m' : '-',
                sub: 'audio',
                accent: SnorvyTheme.talkAmber,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricTile(
                label: 'Tracked',
                value: hasData
                    ? '${totalDuration.inHours}h ${totalDuration.inMinutes % 60}m'
                    : '-',
                sub: nights.length > 1
                    ? '${nights.length} sessions'
                    : 'rest',
                accent: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
                style:
                    SnorvyTheme.displayStyle(context, size: 24, color: accent),
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

class _NoDataForDayPanel extends StatelessWidget {
  const _NoDataForDayPanel({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, MMM d').format(day);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SnorvyTheme.midnightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(
              Icons.nightlight_outlined,
              color: SnorvyTheme.midnightTextFaint,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('No recordings on $dateLabel.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyEventsPanel extends StatelessWidget {
  const _EmptyEventsPanel({required this.message});

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

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.isBusy,
    required this.isPlaying,
    required this.onPlayAudio,
    required this.onStopAudio,
  });

  final SleepEvent event;
  final bool isBusy;
  final bool isPlaying;
  final Future<void> Function(String filePath, {String? playbackKey})
  onPlayAudio;
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
                child: Row(
                  children: [
                    Text(
                      event.timeLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.kind.label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      event.durationLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: SnorvyTheme.midnightTextFaint,
                      ),
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
