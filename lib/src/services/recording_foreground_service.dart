import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

const snorvyForegroundNotificationId = 42117;

abstract interface class RecordingForegroundService {
  Future<void> configure();
  Future<bool> startRecordingNotification({DateTime? startedAt});
  Future<void> stopRecordingNotification();
}

RecordingForegroundService createRecordingForegroundService() {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    return const NoopRecordingForegroundService();
  }

  return FlutterRecordingForegroundService();
}

class NoopRecordingForegroundService implements RecordingForegroundService {
  const NoopRecordingForegroundService();

  @override
  Future<void> configure() async {}

  @override
  Future<bool> startRecordingNotification({DateTime? startedAt}) async {
    return true;
  }

  @override
  Future<void> stopRecordingNotification() async {}
}

class FlutterRecordingForegroundService implements RecordingForegroundService {
  FlutterRecordingForegroundService({FlutterBackgroundService? service})
    : _service = service ?? FlutterBackgroundService();

  final FlutterBackgroundService _service;
  bool _configured = false;

  @override
  Future<void> configure() async {
    if (_configured) {
      return;
    }

    await _service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: snorvyForegroundServiceOnStart,
        onBackground: snorvyIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: snorvyForegroundServiceOnStart,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        initialNotificationTitle: 'Snorvy is recording',
        initialNotificationContent:
            'Overnight audio capture is active on this phone.',
        foregroundServiceNotificationId: snorvyForegroundNotificationId,
        foregroundServiceTypes: const [AndroidForegroundType.microphone],
      ),
    );
    _configured = true;
  }

  @override
  Future<bool> startRecordingNotification({DateTime? startedAt}) async {
    await configure();
    await Permission.notification.request();

    final running = await _service.isRunning();
    final started = running || await _service.startService();
    if (started) {
      _service.invoke('recordingStarted', {
        'startedAtMillis': startedAt?.millisecondsSinceEpoch,
      });
    }

    return started;
  }

  @override
  Future<void> stopRecordingNotification() async {
    await configure();
    _service.invoke('stopService');
  }
}

@pragma('vm:entry-point')
Future<bool> snorvyIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void snorvyForegroundServiceOnStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    unawaited(service.setAsForegroundService());
    unawaited(
      service.setForegroundNotificationInfo(
        title: 'Snorvy is recording',
        content: 'Overnight audio capture is active on this phone.',
      ),
    );
  }

  service.on('recordingStarted').listen((event) {
    if (service is! AndroidServiceInstance) {
      return;
    }

    final startedAtMillis = event?['startedAtMillis'] as int?;
    final content = startedAtMillis == null
        ? 'Overnight audio capture is active on this phone.'
        : 'Started at ${_serviceTimeLabel(startedAtMillis)}. Tap to return.';

    unawaited(
      service.setForegroundNotificationInfo(
        title: 'Snorvy is recording',
        content: content,
      ),
    );
  });

  service.on('stopService').listen((event) {
    unawaited(service.stopSelf());
  });
}

String _serviceTimeLabel(int millisecondsSinceEpoch) {
  final startedAt = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  final hour = startedAt.hour.toString().padLeft(2, '0');
  final minute = startedAt.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
