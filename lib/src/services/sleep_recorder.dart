import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snorvy/src/services/snorvy_audio_session.dart';

enum RecordingStatus { idle, permissionDenied, recording }

class _RecordingFormat {
  const _RecordingFormat({required this.codec, required this.extension});

  final Codec codec;
  final String extension;
}

class RecordingSession {
  const RecordingSession({required this.status, this.filePath, this.startedAt});

  final RecordingStatus status;
  final String? filePath;
  final DateTime? startedAt;
}

class RecordingPowerFrame {
  const RecordingPowerFrame({required this.elapsed, required this.decibels});

  final Duration elapsed;
  final double decibels;
}

abstract interface class SleepRecorder {
  Stream<RecordingPowerFrame> get powerFrames;
  Future<RecordingSession> startNightRecording();
  Future<RecordingSession> stopNightRecording();
  Future<void> dispose();
}

class FlutterSoundSleepRecorder implements SleepRecorder {
  static const List<_RecordingFormat> _preferredFormats = [
    _RecordingFormat(codec: Codec.aacMP4, extension: '.m4a'),
    _RecordingFormat(codec: Codec.aacADTS, extension: '.aac'),
    _RecordingFormat(codec: Codec.pcm16WAV, extension: '.wav'),
  ];

  FlutterSoundSleepRecorder({FlutterSoundRecorder? recorder})
    : _recorder = recorder ?? FlutterSoundRecorder();

  final FlutterSoundRecorder _recorder;
  final StreamController<RecordingPowerFrame> _powerFrames =
      StreamController<RecordingPowerFrame>.broadcast();
  StreamSubscription<RecordingDisposition>? _progressSubscription;

  RecordingSession _session = const RecordingSession(
    status: RecordingStatus.idle,
  );

  @override
  Stream<RecordingPowerFrame> get powerFrames => _powerFrames.stream;

  @override
  Future<RecordingSession> startNightRecording() async {
    final microphone = await Permission.microphone.request();
    if (!microphone.isGranted) {
      _session = const RecordingSession(
        status: RecordingStatus.permissionDenied,
      );
      return _session;
    }

    await SnorvyAudioSession.configureForRecording();
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 160));
    await _progressSubscription?.cancel();
    _progressSubscription = _recorder.onProgress?.listen((disposition) {
      final decibels = disposition.decibels;
      if (decibels == null) {
        return;
      }

      _powerFrames.add(
        RecordingPowerFrame(elapsed: disposition.duration, decibels: decibels),
      );
    });

    final directory = await getApplicationDocumentsDirectory();
    final recordingsDirectory = Directory(p.join(directory.path, 'recordings'));
    if (!await recordingsDirectory.exists()) {
      await recordingsDirectory.create(recursive: true);
    }

    final format = await _firstSupportedFormat();
    final fileCreatedAt = DateTime.now();
    final filePath = p.join(
      recordingsDirectory.path,
      'night_${fileCreatedAt.millisecondsSinceEpoch}${format.extension}',
    );

    await _recorder.startRecorder(
      toFile: filePath,
      codec: format.codec,
      audioSource: AudioSource.microphone,
      bitRate: 64000,
      numChannels: 1,
    );
    final startedAt = DateTime.now();

    _session = RecordingSession(
      status: RecordingStatus.recording,
      filePath: filePath,
      startedAt: startedAt,
    );

    return _session;
  }

  Future<_RecordingFormat> _firstSupportedFormat() async {
    for (final format in _preferredFormats) {
      if (await _recorder.isEncoderSupported(format.codec)) {
        return format;
      }
    }

    throw Exception('No supported audio encoder is available.');
  }

  @override
  Future<RecordingSession> stopNightRecording() async {
    if (_session.status != RecordingStatus.recording) {
      return _session;
    }

    await _progressSubscription?.cancel();
    _progressSubscription = null;
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();

    _session = RecordingSession(
      status: RecordingStatus.idle,
      filePath: _session.filePath,
      startedAt: _session.startedAt,
    );

    return _session;
  }

  @override
  Future<void> dispose() async {
    await _progressSubscription?.cancel();
    await _powerFrames.close();
    try {
      if (_session.status == RecordingStatus.recording) {
        await _recorder.stopRecorder();
      }
      await _recorder.closeRecorder();
    } on Exception {
      // The native recorder may already be closed by a completed stop flow.
    }
  }
}
