import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileStorageService {
  Directory? _appDir;

  Future<Directory> get _storageDir async {
    if (_appDir != null) return _appDir!;
    final docsDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(docsDir.path, 'pwms_media'));
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    _appDir = mediaDir;
    return mediaDir;
  }

  /// Copies a file from sourcePath to the local PWMS media directory.
  /// Returns the relative file path stored.
  Future<String> saveFile(String sourcePath) async {
    final file = File(sourcePath);
    if (!await file.exists()) {
      throw Exception('Source file does not exist at path: $sourcePath');
    }

    final ext = p.extension(sourcePath);
    final filename = '${const Uuid().v4()}$ext';
    final targetDir = await _storageDir;
    final targetPath = p.join(targetDir.path, filename);

    await file.copy(targetPath);
    return filename; // Relative path stored in DB
  }

  /// Resolves the absolute path from a relative path stored in DB.
  Future<String> getAbsolutePath(String relativePath) async {
    if (p.isAbsolute(relativePath)) return relativePath;
    final targetDir = await _storageDir;
    return p.join(targetDir.path, relativePath);
  }

  /// Deletes a file given its relative path.
  Future<void> deleteFile(String relativePath) async {
    final absPath = await getAbsolutePath(relativePath);
    final file = File(absPath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
