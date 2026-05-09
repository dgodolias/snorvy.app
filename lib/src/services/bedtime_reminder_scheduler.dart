import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:snorvy/src/domain/bedtime_reminder.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

const int _scheduleHorizonDays = 7;
const String _channelId = 'snorvy_bedtime_reminders';
const String _channelName = 'Bedtime reminders';
const String _channelDescription =
    'Daily nudge to start Snorvy at the time you chose.';

abstract class BedtimeReminderScheduler {
  factory BedtimeReminderScheduler() = _FlutterLocalNotificationsScheduler;

  factory BedtimeReminderScheduler.noop() = _NoopBedtimeReminderScheduler;

  Future<void> initialize();

  Future<void> reschedule(BedtimeReminder reminder);

  Future<void> cancel();

  Future<void> fireTestNotification();

  String pickPreviewMessage();
}

class _FlutterLocalNotificationsScheduler implements BedtimeReminderScheduler {
  _FlutterLocalNotificationsScheduler();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final math.Random _random = math.Random();
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      _initialized = true;
      return;
    }

    tz_data.initializeTimeZones();
    try {
      final localName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localName));
    } on Exception {
      // Fall back to UTC if the device timezone cannot be resolved.
    }

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(initSettings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
          showBadge: true,
        ),
      );
    }

    _initialized = true;
  }

  @override
  Future<void> reschedule(BedtimeReminder reminder) async {
    await initialize();
    await _plugin.cancelAll();
    if (!reminder.enabled) return;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      icon: 'ic_snorvy_notification',
      color: Color(0xFF21D8C0),
    );
    const details = NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);
    var fireAt = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      reminder.time.hour,
      reminder.time.minute,
    );
    if (!fireAt.isAfter(now)) {
      fireAt = fireAt.add(const Duration(days: 1));
    }

    for (var i = 0; i < _scheduleHorizonDays; i++) {
      final scheduled = fireAt.add(Duration(days: i));
      final message =
          bedtimeReminderMessages[_random.nextInt(bedtimeReminderMessages.length)];
      await _plugin.zonedSchedule(
        i,
        'Snorvy',
        message,
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  @override
  Future<void> cancel() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
  }

  @override
  Future<void> fireTestNotification() async {
    await initialize();
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      icon: 'ic_snorvy_notification',
      color: Color(0xFF21D8C0),
    );
    const details = NotificationDetails(android: androidDetails);
    final message = pickPreviewMessage();
    await _plugin.show(9999, 'Snorvy', message, details);
  }

  @override
  String pickPreviewMessage() {
    return bedtimeReminderMessages[
        _random.nextInt(bedtimeReminderMessages.length)];
  }
}

class _NoopBedtimeReminderScheduler implements BedtimeReminderScheduler {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> reschedule(BedtimeReminder reminder) async {}

  @override
  Future<void> cancel() async {}

  @override
  Future<void> fireTestNotification() async {}

  @override
  String pickPreviewMessage() => bedtimeReminderMessages.first;
}
