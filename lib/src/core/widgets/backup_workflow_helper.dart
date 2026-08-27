import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_strings.dart';
import '../constants/app_technical_strings.dart';
import '../providers/providers.dart';
import 'app_toast.dart';

class BackupWorkflowHelper {
  const BackupWorkflowHelper._();

  static Future<void> exportBackup(
    BuildContext context,
    WidgetRef ref,
    void Function(bool isProcessing) setProcessing,
  ) async {
    setProcessing(true);
    try {
      final backupService = ref.read(databaseBackupServiceProvider);
      await backupService.exportAndShareBackup();

      if (context.mounted) {
        AppToast.showSuccess(context, AppStrings.backupExportSuccess);
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, AppStrings.backupExportErrorMessage(e));
      }
    } finally {
      if (context.mounted) {
        setProcessing(false);
      }
    }
  }

  static Future<void> importBackup(
    BuildContext context,
    WidgetRef ref,
    void Function(bool isProcessing) setProcessing, {
    VoidCallback? onSuccess,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [AppTechnicalStrings.extZipClean, AppTechnicalStrings.extJsonClean],
    );

    if (result == null || result.files.single.path == null) return;
    if (!context.mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.confirmRestoreTitle),
        content: const Text(AppStrings.confirmRestoreWarningMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.restoreAllAction),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    setProcessing(true);
    try {
      final filePath = result.files.single.path!;
      final backupService = ref.read(databaseBackupServiceProvider);

      await backupService.importDatabaseFromFile(File(filePath));
      refreshAllAppProviders(ref);

      if (context.mounted) {
        onSuccess?.call();
        AppToast.showSuccess(context, AppStrings.backupImportSuccess);
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, AppStrings.backupImportErrorMessage(e));
      }
    } finally {
      if (context.mounted) {
        setProcessing(false);
      }
    }
  }
}
