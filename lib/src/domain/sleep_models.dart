import 'package:flutter/material.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

enum SleepEventKind { snore, talk, noise }

extension SleepEventKindPresentation on SleepEventKind {
  String get label {
    return switch (this) {
      SleepEventKind.snore => 'Snore',
      SleepEventKind.talk => 'Talk',
      SleepEventKind.noise => 'Noise',
    };
  }

  IconData get icon {
    return switch (this) {
      SleepEventKind.snore => Icons.graphic_eq,
      SleepEventKind.talk => Icons.record_voice_over,
      SleepEventKind.noise => Icons.waves,
    };
  }

  Color get accent {
    return switch (this) {
      SleepEventKind.snore => SnorvyTheme.coral,
      SleepEventKind.talk => SnorvyTheme.moss,
      SleepEventKind.noise => SnorvyTheme.amber,
    };
  }
}

class SleepEvent {
  const SleepEvent({
    required this.id,
    required this.kind,
    required this.startsAt,
    required this.duration,
    required this.intensity,
  });

  final int id;
  final SleepEventKind kind;
  final DateTime startsAt;
  final Duration duration;
  final int intensity;

  String get timeLabel {
    final hour = startsAt.hour.toString().padLeft(2, '0');
    final minute = startsAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get durationLabel {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    }

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes}m ${seconds}s';
  }
}

class SleepNight {
  const SleepNight({
    required this.date,
    required this.startedAt,
    required this.endedAt,
    required this.snoreScore,
    required this.events,
    this.isManual = false,
  });

  final DateTime date;
  final DateTime startedAt;
  final DateTime endedAt;
  final int snoreScore;
  final List<SleepEvent> events;
  final bool isManual;

  Duration get duration => endedAt.difference(startedAt);

  int get snoreMinutes => _minutesFor(SleepEventKind.snore);

  int get talkMinutes => _minutesFor(SleepEventKind.talk);

  int _minutesFor(SleepEventKind kind) {
    final seconds = events
        .where((event) => event.kind == kind)
        .fold<int>(0, (total, event) => total + event.duration.inSeconds);

    return (seconds / 60).round();
  }
}
