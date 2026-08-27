import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

class FileStorageService {
  Directory? _appDir;

  Future<Directory> get _storageDir async {
    if (_appDir != null) return _appDir!;
    final docsDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(docsDir.path, AppTechnicalStorage.dirMedia));
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
      throw Exception(AppStrings.sourceFileNotFoundAtPath(sourcePath));
    }

    final ext = p.extension(sourcePath);
    final filename = AppTechnicalStrings.fileNameWithExtension(const Uuid().v4(), ext);
    final targetDir = await _storageDir;
    final targetPath = p.join(targetDir.path, filename);

    await file.copy(targetPath);
    return filename; // Relative path stored in DB
  }

  /// Saves raw bytes to the local PWMS media directory and returns the relative filename.
  Future<String> saveBytes(List<int> bytes, {String extension = AppTechnicalStorage.extJpg}) async {
    final ext = AppTechnicalStrings.withDotPrefix(extension);
    final filename = AppTechnicalStrings.fileNameWithExtension(const Uuid().v4(), ext);
    final targetDir = await _storageDir;
    final targetPath = p.join(targetDir.path, filename);

    final file = File(targetPath);
    await file.writeAsBytes(bytes);
    return filename;
  }

  /// Resolves the absolute path from a relative path stored in DB,
  /// with backward-compatible fallback for legacy 'product_images' directory.
  Future<String> getAbsolutePath(String relativePath) async {
    if (p.isAbsolute(relativePath)) {
      if (await File(relativePath).exists()) return relativePath;
    }
    final targetDir = await _storageDir;
    final primaryPath = p.join(targetDir.path, relativePath);
    if (await File(primaryPath).exists()) return primaryPath;

    // Fallback: check legacy product_images directory
    final docsDir = await getApplicationDocumentsDirectory();
    final legacyPath = p.join(docsDir.path, AppTechnicalStorage.dirProductImages, relativePath);
    if (await File(legacyPath).exists()) return legacyPath;

    return primaryPath;
  }

  /// Checks if a file exists given its relative or absolute path.
  Future<bool> fileExists(String relativeOrAbsolutePath) async {
    if (relativeOrAbsolutePath.trim().isEmpty) return false;
    final absPath = await getAbsolutePath(relativeOrAbsolutePath);
    return await File(absPath).exists();
  }

  /// Deletes a file given its relative or absolute path.
  Future<void> deleteFile(String relativeOrAbsolutePath) async {
    if (relativeOrAbsolutePath.trim().isEmpty) return;
    final absPath = await getAbsolutePath(relativeOrAbsolutePath);
    final file = File(absPath);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (_) {}
    }
  }
}

