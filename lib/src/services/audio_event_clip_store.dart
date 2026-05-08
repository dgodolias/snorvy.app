import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:snorvy/src/services/sleep_event_analyzer.dart';

abstract interface class AudioEventClipStore {
  Future<void> deleteStaleSourceChunks();

  Future<List<AnalyzedSleepEvent>> saveEventClips({
    required String sourcePath,
    required DateTime chunkStartedAt,
    required DateTime chunkEndedAt,
    required List<AnalyzedSleepEvent> events,
    required Duration preRoll,
    required Duration postRoll,
  });
}

class WavAudioEventClipStore implements AudioEventClipStore {
  const WavAudioEventClipStore();

  @override
  Future<void> deleteStaleSourceChunks() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final chunksDirectory = Directory(
      p.join(documentsDirectory.path, 'recordings', 'chunks'),
    );
    if (await chunksDirectory.exists()) {
      await chunksDirectory.delete(recursive: true);
    }
  }

  @override
  Future<List<AnalyzedSleepEvent>> saveEventClips({
    required String sourcePath,
    required DateTime chunkStartedAt,
    required DateTime chunkEndedAt,
    required List<AnalyzedSleepEvent> events,
    required Duration preRoll,
    required Duration postRoll,
  }) async {
    if (events.isEmpty) {
      return const [];
    }

    final source = await _WavFile.read(sourcePath);
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final clipsDirectory = Directory(
      p.join(documentsDirectory.path, 'recordings', 'events'),
    );
    if (!await clipsDirectory.exists()) {
      await clipsDirectory.create(recursive: true);
    }

    final chunkDuration = _minDuration(
      source.duration,
      chunkEndedAt.difference(chunkStartedAt),
    );
    final sourceStem = p.basenameWithoutExtension(sourcePath);
    final clippedEvents = <AnalyzedSleepEvent>[];

    for (var index = 0; index < events.length; index++) {
      final event = events[index];
      final eventOffset = event.startsAt.difference(chunkStartedAt);
      final clipStart = _clampDuration(
        eventOffset - preRoll,
        Duration.zero,
        chunkDuration,
      );
      final clipEnd = _clampDuration(
        eventOffset + event.duration + postRoll,
        Duration.zero,
        chunkDuration,
      );
      if (clipEnd <= clipStart) {
        continue;
      }

      final clipBytes = source.clipBytes(start: clipStart, end: clipEnd);
      final clipPath = p.join(
        clipsDirectory.path,
        'event_${sourceStem}_${index}_${event.kind.name}.wav',
      );
      await File(clipPath).writeAsBytes(clipBytes, flush: true);
      clippedEvents.add(
        AnalyzedSleepEvent(
          kind: event.kind,
          startsAt: event.startsAt,
          duration: event.duration,
          intensity: event.intensity,
          filePath: clipPath,
        ),
      );
    }

    return clippedEvents;
  }

  Duration _minDuration(Duration a, Duration b) {
    return a <= b ? a : b;
  }

  Duration _clampDuration(Duration value, Duration min, Duration max) {
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }
}

class _WavFile {
  const _WavFile({
    required this.bytes,
    required this.audioFormat,
    required this.numChannels,
    required this.sampleRate,
    required this.byteRate,
    required this.blockAlign,
    required this.bitsPerSample,
    required this.dataOffset,
    required this.dataLength,
  });

  final Uint8List bytes;
  final int audioFormat;
  final int numChannels;
  final int sampleRate;
  final int byteRate;
  final int blockAlign;
  final int bitsPerSample;
  final int dataOffset;
  final int dataLength;

  Duration get duration {
    return Duration(microseconds: dataLength * 1000000 ~/ byteRate);
  }

  static Future<_WavFile> read(String sourcePath) async {
    final file = File(sourcePath);
    if (!await file.exists()) {
      throw const FileSystemException('Recording file not found');
    }

    final bytes = await file.readAsBytes();
    if (bytes.length < 44 ||
        _ascii(bytes, 0, 4) != 'RIFF' ||
        _ascii(bytes, 8, 4) != 'WAVE') {
      throw const FormatException('Only WAV source chunks can be clipped.');
    }

    final data = ByteData.sublistView(bytes);
    int? audioFormat;
    int? numChannels;
    int? sampleRate;
    int? byteRate;
    int? blockAlign;
    int? bitsPerSample;
    int? dataOffset;
    int? dataLength;
    var offset = 12;

    while (offset + 8 <= bytes.length) {
      final chunkId = _ascii(bytes, offset, 4);
      final chunkSize = data.getUint32(offset + 4, Endian.little);
      final chunkDataOffset = offset + 8;

      if (chunkDataOffset + chunkSize > bytes.length) {
        break;
      }

      if (chunkId == 'fmt ') {
        if (chunkSize < 16) {
          throw const FormatException('Invalid WAV fmt chunk.');
        }
        audioFormat = data.getUint16(chunkDataOffset, Endian.little);
        numChannels = data.getUint16(chunkDataOffset + 2, Endian.little);
        sampleRate = data.getUint32(chunkDataOffset + 4, Endian.little);
        byteRate = data.getUint32(chunkDataOffset + 8, Endian.little);
        blockAlign = data.getUint16(chunkDataOffset + 12, Endian.little);
        bitsPerSample = data.getUint16(chunkDataOffset + 14, Endian.little);
      } else if (chunkId == 'data') {
        dataOffset = chunkDataOffset;
        dataLength = chunkSize;
      }

      offset = chunkDataOffset + chunkSize + chunkSize.isOdd.toInt();
    }

    if (audioFormat != 1 ||
        numChannels == null ||
        sampleRate == null ||
        byteRate == null ||
        blockAlign == null ||
        bitsPerSample == null ||
        dataOffset == null ||
        dataLength == null) {
      throw const FormatException('Unsupported WAV source chunk.');
    }

    return _WavFile(
      bytes: bytes,
      audioFormat: audioFormat!,
      numChannels: numChannels,
      sampleRate: sampleRate,
      byteRate: byteRate,
      blockAlign: blockAlign,
      bitsPerSample: bitsPerSample,
      dataOffset: dataOffset,
      dataLength: dataLength,
    );
  }

  Uint8List clipBytes({required Duration start, required Duration end}) {
    final startOffset = _dataByteOffsetFor(start, ceiling: false);
    final endOffset = _dataByteOffsetFor(end, ceiling: true);
    final clippedDataStart = dataOffset + startOffset;
    final clippedDataEnd = dataOffset + math.max(startOffset, endOffset);
    final clippedData = bytes.sublist(
      clippedDataStart.clamp(dataOffset, dataOffset + dataLength).toInt(),
      clippedDataEnd.clamp(dataOffset, dataOffset + dataLength).toInt(),
    );

    final header = _wavHeader(clippedData.length);
    final output = Uint8List(header.length + clippedData.length);
    output.setAll(0, header);
    output.setAll(header.length, clippedData);
    return output;
  }

  int _dataByteOffsetFor(Duration duration, {required bool ceiling}) {
    final exactFrames = duration.inMicroseconds * sampleRate / 1000000;
    final frameIndex = ceiling ? exactFrames.ceil() : exactFrames.floor();
    return (frameIndex * blockAlign).clamp(0, dataLength).toInt();
  }

  Uint8List _wavHeader(int clippedDataLength) {
    final header = ByteData(44);
    _writeAscii(header, 0, 'RIFF');
    header.setUint32(4, 36 + clippedDataLength, Endian.little);
    _writeAscii(header, 8, 'WAVE');
    _writeAscii(header, 12, 'fmt ');
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, audioFormat, Endian.little);
    header.setUint16(22, numChannels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, bitsPerSample, Endian.little);
    _writeAscii(header, 36, 'data');
    header.setUint32(40, clippedDataLength, Endian.little);
    return header.buffer.asUint8List();
  }

  static String _ascii(Uint8List bytes, int start, int length) {
    return String.fromCharCodes(bytes.sublist(start, start + length));
  }

  static void _writeAscii(ByteData data, int offset, String value) {
    for (var index = 0; index < value.length; index++) {
      data.setUint8(offset + index, value.codeUnitAt(index));
    }
  }
}

extension on bool {
  int toInt() => this ? 1 : 0;
}
