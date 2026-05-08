import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as p;
import 'package:snorvy/src/services/snorvy_audio_session.dart';

abstract interface class AudioPlayback {
  Future<void> playFile(String filePath);
  Future<void> stop();
  Future<void> dispose();
}

class FlutterSoundAudioPlayback implements AudioPlayback {
  FlutterSoundAudioPlayback({FlutterSoundPlayer? player})
    : _player = player ?? FlutterSoundPlayer();

  final FlutterSoundPlayer _player;
  bool _isOpen = false;

  @override
  Future<void> playFile(String filePath) async {
    if (!await File(filePath).exists()) {
      throw const FileSystemException('Recording file not found');
    }

    if (!_isOpen) {
      await _player.openPlayer();
      _isOpen = true;
    }

    await SnorvyAudioSession.configureForPlayback();
    await _player.stopPlayer();
    await _player.startPlayer(
      fromURI: filePath,
      codec: _codecFor(filePath),
      whenFinished: () {},
    );
  }

  @override
  Future<void> stop() async {
    if (_isOpen) {
      await _player.stopPlayer();
    }
  }

  @override
  Future<void> dispose() async {
    if (_isOpen) {
      await _player.closePlayer();
      _isOpen = false;
    }
  }

  Codec _codecFor(String filePath) {
    return switch (p.extension(filePath).toLowerCase()) {
      '.aac' => Codec.aacADTS,
      '.m4a' || '.mp4' => Codec.aacMP4,
      '.ogg' => Codec.opusOGG,
      '.caf' => Codec.opusCAF,
      '.mp3' => Codec.mp3,
      '.wav' => Codec.pcm16WAV,
      _ => Codec.defaultCodec,
    };
  }
}
