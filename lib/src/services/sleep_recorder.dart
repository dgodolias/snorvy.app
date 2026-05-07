import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum RecordingStatus { idle, permissionDenied, recording }

class RecordingSession {
  const RecordingSession({required this.status, this.filePath, this.startedAt});

  final RecordingStatus status;
  final String? filePath;
  final DateTime? startedAt;
}

abstract interface class SleepRecorder {
  Future<RecordingSession> startNightRecording();
  Future<RecordingSession> stopNightRecording();
}

class FlutterSoundSleepRecorder implements SleepRecorder {
  FlutterSoundSleepRecorder({FlutterSoundRecorder? recorder})
    : _recorder = recorder ?? FlutterSoundRecorder();

  final FlutterSoundRecorder _recorder;

  RecordingSession _session = const RecordingSession(
    status: RecordingStatus.idle,
  );

  @override
  Future<RecordingSession> startNightRecording() async {
    final microphone = await Permission.microphone.request();
    if (!microphone.isGranted) {
      _session = const RecordingSession(
        status: RecordingStatus.permissionDenied,
      );
      return _session;
    }

    await _recorder.openRecorder();

    final directory = await getApplicationDocumentsDirectory();
    final recordingsDirectory = Directory(p.join(directory.path, 'recordings'));
    if (!recordingsDirectory.existsSync()) {
      await recordingsDirectory.create(recursive: true);
    }

    final startedAt = DateTime.now();
    final filePath = p.join(
      recordingsDirectory.path,
      'night_${startedAt.millisecondsSinceEpoch}.ogg',
    );

    await _recorder.startRecorder(
      toFile: filePath,
      codec: Codec.opusOGG,
      sampleRate: 16000,
      numChannels: 1,
    );

    _session = RecordingSession(
      status: RecordingStatus.recording,
      filePath: filePath,
      startedAt: startedAt,
    );

    return _session;
  }

  @override
  Future<RecordingSession> stopNightRecording() async {
    if (_session.status != RecordingStatus.recording) {
      return _session;
    }

    await _recorder.stopRecorder();
    await _recorder.closeRecorder();

    _session = RecordingSession(
      status: RecordingStatus.idle,
      filePath: _session.filePath,
      startedAt: _session.startedAt,
    );

    return _session;
  }
}
