import 'package:flutter/material.dart';

@immutable
class BedtimeReminder {
  const BedtimeReminder({required this.enabled, required this.time});

  final bool enabled;
  final TimeOfDay time;

  static const BedtimeReminder defaults = BedtimeReminder(
    enabled: false,
    time: TimeOfDay(hour: 23, minute: 30),
  );

  BedtimeReminder copyWith({bool? enabled, TimeOfDay? time}) {
    return BedtimeReminder(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BedtimeReminder &&
        other.enabled == enabled &&
        other.time == time;
  }

  @override
  int get hashCode => Object.hash(enabled, time);
}

const List<String> bedtimeReminderMessages = [
  "What will tonight reveal? Tap to start Snorvy.",
  "Tomorrow's sleep report begins right now.",
  "Your bed has stories. Snorvy listens. Tap to record.",
  "Did you know you might be a sleep talker? Find out tonight.",
  "30 seconds to set up, a whole night of answers.",
  "Last night is lost data. Don't miss tonight too.",
  "The most interesting thing you'll do today is sleep. Record it.",
  "Quiet snore? Loud snore? Sleep talk? Snorvy already knows.",
  "One tap tonight, a full picture by morning.",
  "Tonight's the night you find out what really happens at 3 AM.",
];
