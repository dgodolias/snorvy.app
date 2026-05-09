import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snorvy/src/domain/bedtime_reminder.dart';

abstract class BedtimeReminderRepository {
  factory BedtimeReminderRepository.sharedPreferences() =
      _SharedPreferencesBedtimeReminderRepository;

  factory BedtimeReminderRepository.inMemory({
    BedtimeReminder initial = BedtimeReminder.defaults,
  }) {
    return _InMemoryBedtimeReminderRepository(initial);
  }

  Future<BedtimeReminder> load();
  Future<void> save(BedtimeReminder reminder);
}

class _SharedPreferencesBedtimeReminderRepository
    implements BedtimeReminderRepository {
  static const String _kEnabled = 'bedtime_reminder.enabled';
  static const String _kTime = 'bedtime_reminder.time';

  @override
  Future<BedtimeReminder> load() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled =
        prefs.getBool(_kEnabled) ?? BedtimeReminder.defaults.enabled;
    final time = _parseTime(prefs.getString(_kTime)) ??
        BedtimeReminder.defaults.time;
    return BedtimeReminder(enabled: enabled, time: time);
  }

  @override
  Future<void> save(BedtimeReminder reminder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabled, reminder.enabled);
    await prefs.setString(_kTime, _formatTime(reminder.time));
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  TimeOfDay? _parseTime(String? raw) {
    if (raw == null) return null;
    final parts = raw.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }
}

class _InMemoryBedtimeReminderRepository implements BedtimeReminderRepository {
  _InMemoryBedtimeReminderRepository(this._reminder);

  BedtimeReminder _reminder;

  @override
  Future<BedtimeReminder> load() async => _reminder;

  @override
  Future<void> save(BedtimeReminder reminder) async {
    _reminder = reminder;
  }
}
