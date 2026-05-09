import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:snorvy/src/domain/sleep_models.dart';
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

  static const _clipWindowPlanner = AudioClipWindowPlanner();

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
    final clipWindows = _clipWindowPlanner.plan(
      events: events,
      chunkStartedAt: chunkStartedAt,
      chunkDuration: chunkDuration,
      preRoll: preRoll,
      postRoll: postRoll,
    );

    var refinerFlips = 0;
    for (var index = 0; index < clipWindows.length; index++) {
      final window = clipWindows[index];
      final event = window.event;
      if (window.clipEnd <= window.clipStart ||
          window.coreEnd <= window.coreStart) {
        continue;
      }

      final features = source.featuresFor(
        start: window.coreStart,
        end: window.coreEnd,
      );
      final kind = const WavAudioEventKindRefiner().refine(
        event.kind,
        features,
      );
      if (kind != event.kind) {
        refinerFlips++;
        if (kDebugMode) {
          debugPrint(
            '[Refiner] flipped ${event.kind.name} -> ${kind.name} '
            '(source=${event.source.name}, '
            'index=$index, dur=${(window.coreEnd - window.coreStart).inMilliseconds}ms)',
          );
        }
      }
      final clipDuration = window.clipEnd - window.clipStart;
      final clipBytes = source.clipBytes(
        start: window.clipStart,
        end: window.clipEnd,
      );
      final clipPath = p.join(
        clipsDirectory.path,
        'event_${sourceStem}_${index}_${kind.name}.wav',
      );
      await File(clipPath).writeAsBytes(clipBytes, flush: true);
      clippedEvents.add(
        AnalyzedSleepEvent(
          kind: kind,
          startsAt: event.startsAt,
          duration: clipDuration,
          intensity: event.intensity,
          filePath: clipPath,
          source: event.source,
        ),
      );
    }

    if (kDebugMode && events.isNotEmpty) {
      final pct = (100 * refinerFlips / events.length).toStringAsFixed(0);
      debugPrint(
        '[Refiner] flipped $refinerFlips/${events.length} events ($pct%)',
      );
    }
    return clippedEvents;
  }

  Duration _minDuration(Duration a, Duration b) {
    return a <= b ? a : b;
  }
}

class AudioClipWindow {
  const AudioClipWindow({
    required this.event,
    required this.clipStart,
    required this.clipEnd,
    required this.coreStart,
    required this.coreEnd,
  });

  final AnalyzedSleepEvent event;
  final Duration clipStart;
  final Duration clipEnd;
  final Duration coreStart;
  final Duration coreEnd;
}

class AudioClipWindowPlanner {
  const AudioClipWindowPlanner();

  List<AudioClipWindow> plan({
    required List<AnalyzedSleepEvent> events,
    required DateTime chunkStartedAt,
    required Duration chunkDuration,
    required Duration preRoll,
    required Duration postRoll,
  }) {
    final orderedEvents = [...events]
      ..sort((left, right) => left.startsAt.compareTo(right.startsAt));

    return [
      for (var index = 0; index < orderedEvents.length; index++)
        _windowFor(
          orderedEvents: orderedEvents,
          index: index,
          chunkStartedAt: chunkStartedAt,
          chunkDuration: chunkDuration,
          preRoll: preRoll,
          postRoll: postRoll,
        ),
    ];
  }

  AudioClipWindow _windowFor({
    required List<AnalyzedSleepEvent> orderedEvents,
    required int index,
    required DateTime chunkStartedAt,
    required Duration chunkDuration,
    required Duration preRoll,
    required Duration postRoll,
  }) {
    final event = orderedEvents[index];
    final coreStart = _clampDuration(
      event.startsAt.difference(chunkStartedAt),
      Duration.zero,
      chunkDuration,
    );
    final coreEnd = _clampDuration(
      coreStart + event.duration,
      coreStart,
      chunkDuration,
    );

    final previousCoreEnd = index == 0
        ? Duration.zero
        : _eventCoreEnd(
            orderedEvents[index - 1],
            chunkStartedAt: chunkStartedAt,
            chunkDuration: chunkDuration,
          );
    final nextCoreStart = index == orderedEvents.length - 1
        ? chunkDuration
        : _eventCoreStart(
            orderedEvents[index + 1],
            chunkStartedAt: chunkStartedAt,
            chunkDuration: chunkDuration,
          );

    final clipStart = _maxDuration(
      _clampDuration(coreStart - preRoll, Duration.zero, chunkDuration),
      previousCoreEnd,
    );
    final clipEnd = _minDuration(
      _clampDuration(coreEnd + postRoll, Duration.zero, chunkDuration),
      nextCoreStart,
    );

    return AudioClipWindow(
      event: event,
      clipStart: clipStart,
      clipEnd: clipEnd,
      coreStart: coreStart,
      coreEnd: coreEnd,
    );
  }

  Duration _eventCoreStart(
    AnalyzedSleepEvent event, {
    required DateTime chunkStartedAt,
    required Duration chunkDuration,
  }) {
    return _clampDuration(
      event.startsAt.difference(chunkStartedAt),
      Duration.zero,
      chunkDuration,
    );
  }

  Duration _eventCoreEnd(
    AnalyzedSleepEvent event, {
    required DateTime chunkStartedAt,
    required Duration chunkDuration,
  }) {
    final start = _eventCoreStart(
      event,
      chunkStartedAt: chunkStartedAt,
      chunkDuration: chunkDuration,
    );
    return _clampDuration(start + event.duration, start, chunkDuration);
  }

  Duration _minDuration(Duration a, Duration b) {
    return a <= b ? a : b;
  }

  Duration _maxDuration(Duration a, Duration b) {
    return a >= b ? a : b;
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

class AudioSegmentFeatures {
  const AudioSegmentFeatures({
    required this.activeDuration,
    required this.activeZeroCrossingRate,
    required this.activeDecibelSpread,
  });

  final Duration activeDuration;
  final double activeZeroCrossingRate;
  final double activeDecibelSpread;
}

class WavAudioEventKindRefiner {
  const WavAudioEventKindRefiner();

  SleepEventKind refine(
    SleepEventKind analyzerKind,
    AudioSegmentFeatures features,
  ) {
    if (analyzerKind == SleepEventKind.snore && _looksLikeTalk(features)) {
      return SleepEventKind.talk;
    }
    if (analyzerKind == SleepEventKind.talk && _looksLikeShortSnore(features)) {
      return SleepEventKind.snore;
    }
    return analyzerKind;
  }

  bool _looksLikeTalk(AudioSegmentFeatures features) {
    final activeMs = features.activeDuration.inMilliseconds;
    if (activeMs >= 1600 && features.activeZeroCrossingRate >= 1300) {
      return true;
    }
    return activeMs >= 700 && features.activeZeroCrossingRate >= 2200;
  }

  bool _looksLikeShortSnore(AudioSegmentFeatures features) {
    return features.activeDuration <= const Duration(milliseconds: 1200) &&
        features.activeZeroCrossingRate < 1800 &&
        features.activeDecibelSpread <= 4.8;
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

  AudioSegmentFeatures featuresFor({
    required Duration start,
    required Duration end,
  }) {
    final startOffset = _dataByteOffsetFor(start, ceiling: false);
    final endOffset = _dataByteOffsetFor(end, ceiling: true);
    final startByte = (dataOffset + startOffset)
        .clamp(dataOffset, dataOffset + dataLength)
        .toInt();
    final endByte = (dataOffset + math.max(startOffset, endOffset))
        .clamp(dataOffset, dataOffset + dataLength)
        .toInt();
    final segment = bytes.sublist(startByte, endByte);
    if (segment.length < blockAlign || bitsPerSample != 16) {
      return const AudioSegmentFeatures(
        activeDuration: Duration.zero,
        activeZeroCrossingRate: 0,
        activeDecibelSpread: 0,
      );
    }

    const windowDuration = Duration(milliseconds: 100);
    final framesPerWindow = math.max(
      1,
      sampleRate * windowDuration.inMicroseconds ~/ 1000000,
    );
    final bytesPerWindow = framesPerWindow * blockAlign;
    final activeDecibels = <double>[];
    var activeCrossings = 0;
    var activeSamples = 0;
    var activeWindows = 0;

    for (var offset = 0; offset + blockAlign <= segment.length;) {
      final windowEnd = math.min(offset + bytesPerWindow, segment.length);
      final window = segment.sublist(offset, windowEnd);
      final metrics = _windowMetrics(window);
      if (metrics.decibels > -50) {
        activeWindows += 1;
        activeDecibels.add(metrics.decibels);
        activeCrossings += metrics.zeroCrossings;
        activeSamples += metrics.samples;
      }
      offset = windowEnd;
    }

    if (activeWindows == 0 || activeSamples == 0) {
      return const AudioSegmentFeatures(
        activeDuration: Duration.zero,
        activeZeroCrossingRate: 0,
        activeDecibelSpread: 0,
      );
    }

    final activeDuration = Duration(
      microseconds: activeWindows * windowDuration.inMicroseconds,
    );
    final activeSeconds = activeSamples / sampleRate;
    final averageDb =
        activeDecibels.reduce((left, right) => left + right) /
        activeDecibels.length;
    final variance =
        activeDecibels.fold<double>(0, (total, value) {
          final delta = value - averageDb;
          return total + delta * delta;
        }) /
        activeDecibels.length;

    return AudioSegmentFeatures(
      activeDuration: activeDuration,
      activeZeroCrossingRate: activeCrossings / activeSeconds,
      activeDecibelSpread: math.sqrt(variance),
    );
  }

  _WindowMetrics _windowMetrics(Uint8List window) {
    var squareSum = 0.0;
    var samples = 0;
    var zeroCrossings = 0;
    int? previous;

    for (var offset = 0; offset + 1 < window.length; offset += blockAlign) {
      final sample = _readInt16LittleEndian(window, offset);
      squareSum += sample * sample;
      if (previous != null &&
          ((previous >= 0 && sample < 0) || (previous < 0 && sample >= 0))) {
        zeroCrossings += 1;
      }
      previous = sample;
      samples += 1;
    }

    if (samples == 0) {
      return const _WindowMetrics(decibels: -120, zeroCrossings: 0, samples: 0);
    }

    final rms = math.sqrt(squareSum / samples);
    final decibels = rms <= 0 ? -120.0 : 20 * math.log(rms / 32768) / math.ln10;
    return _WindowMetrics(
      decibels: decibels,
      zeroCrossings: zeroCrossings,
      samples: samples,
    );
  }

  int _readInt16LittleEndian(Uint8List data, int offset) {
    final value = data[offset] | (data[offset + 1] << 8);
    return value >= 0x8000 ? value - 0x10000 : value;
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

class _WindowMetrics {
  const _WindowMetrics({
    required this.decibels,
    required this.zeroCrossings,
    required this.samples,
  });

  final double decibels;
  final int zeroCrossings;
  final int samples;
}

extension on bool {
  int toInt() => this ? 1 : 0;
}
