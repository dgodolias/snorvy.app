import 'dart:io';
import 'dart:typed_data';

class WavData {
  const WavData({required this.samples, required this.sampleRate});

  final Float32List samples;
  final int sampleRate;
}

class WavReader {
  /// Reads a 16-bit PCM mono WAV file and returns float32 samples in [-1, 1].
  ///
  /// Tolerates simple RIFF/WAVE headers as written by flutter_sound's pcm16WAV
  /// codec. Throws [FormatException] if the file is not 16-bit PCM mono.
  static Future<WavData> readMono16(File file) async {
    final bytes = await file.readAsBytes();
    return parseMono16(bytes);
  }

  static WavData parseMono16(Uint8List bytes) {
    if (bytes.length < 44) {
      throw const FormatException('WAV file too small');
    }
    final view = ByteData.sublistView(bytes);
    if (_ascii(bytes, 0, 4) != 'RIFF' || _ascii(bytes, 8, 4) != 'WAVE') {
      throw const FormatException('Not a RIFF/WAVE file');
    }

    var offset = 12;
    int? sampleRate;
    int? channels;
    int? bitsPerSample;
    Uint8List? pcm;

    while (offset + 8 <= bytes.length) {
      final chunkId = _ascii(bytes, offset, 4);
      final chunkSize = view.getUint32(offset + 4, Endian.little);
      final dataStart = offset + 8;
      if (chunkId == 'fmt ') {
        if (dataStart + 16 > bytes.length) {
          throw const FormatException('Truncated fmt chunk');
        }
        final audioFormat = view.getUint16(dataStart, Endian.little);
        channels = view.getUint16(dataStart + 2, Endian.little);
        sampleRate = view.getUint32(dataStart + 4, Endian.little);
        bitsPerSample = view.getUint16(dataStart + 14, Endian.little);
        if (audioFormat != 1) {
          throw FormatException('Unsupported PCM format $audioFormat');
        }
      } else if (chunkId == 'data') {
        final end = dataStart + chunkSize;
        pcm = bytes.sublist(dataStart, end > bytes.length ? bytes.length : end);
      }
      offset = dataStart + chunkSize;
      if (chunkSize.isOdd) offset += 1;
    }

    if (sampleRate == null || channels == null || bitsPerSample == null) {
      throw const FormatException('Missing fmt header');
    }
    if (bitsPerSample != 16) {
      throw FormatException('Expected 16-bit PCM, got $bitsPerSample');
    }
    if (pcm == null) {
      throw const FormatException('Missing data chunk');
    }

    final pcmView = ByteData.sublistView(pcm);
    final frameCount = pcm.length ~/ (2 * channels);
    final samples = Float32List(frameCount);
    if (channels == 1) {
      for (var i = 0; i < frameCount; i++) {
        samples[i] = pcmView.getInt16(i * 2, Endian.little) / 32768.0;
      }
    } else {
      // Mix down by averaging channels.
      for (var i = 0; i < frameCount; i++) {
        var sum = 0;
        for (var c = 0; c < channels; c++) {
          sum += pcmView.getInt16((i * channels + c) * 2, Endian.little);
        }
        samples[i] = (sum / channels) / 32768.0;
      }
    }
    return WavData(samples: samples, sampleRate: sampleRate);
  }

  static String _ascii(Uint8List bytes, int offset, int length) {
    return String.fromCharCodes(bytes.sublist(offset, offset + length));
  }
}
