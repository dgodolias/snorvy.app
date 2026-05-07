import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract interface class RecordingExporter {
  Future<String> exportRecording(String sourcePath);
}

class LocalRecordingExporter implements RecordingExporter {
  @override
  Future<String> exportRecording(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw const FileSystemException('Recording file not found');
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final exportDirectory = Directory(
      p.join(documentsDirectory.path, 'exports'),
    );
    if (!await exportDirectory.exists()) {
      await exportDirectory.create(recursive: true);
    }

    final extension = p.extension(sourcePath);
    final exportedPath = p.join(
      exportDirectory.path,
      'snorvy_${DateTime.now().millisecondsSinceEpoch}$extension',
    );

    await sourceFile.copy(exportedPath);
    return exportedPath;
  }
}
