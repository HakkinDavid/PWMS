import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_strings.dart';
import '../providers/providers.dart';
import 'app_toast.dart';

class BackupSettingsDialog extends ConsumerStatefulWidget {
  const BackupSettingsDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => const BackupSettingsDialog(),
    );
  }

  @override
  ConsumerState<BackupSettingsDialog> createState() => _BackupSettingsDialogState();
}

class _BackupSettingsDialogState extends ConsumerState<BackupSettingsDialog> {
  bool _isProcessing = false;

  Future<void> _exportBackup() async {
    setState(() => _isProcessing = true);
    try {
      final backupService = ref.read(databaseBackupServiceProvider);
      await backupService.exportAndShareBackup();

      if (mounted) {
        AppToast.showSuccess(context, AppStrings.backupExportSuccess);
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, '${AppStrings.backupExportErrorPrefix}$e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _importBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'json'],
    );

    if (result == null || result.files.single.path == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.confirmRestoreTitle),
        content: const Text(AppStrings.confirmRestoreWarningMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.restoreAllAction),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessing = true);
    try {
      final filePath = result.files.single.path!;
      final backupService = ref.read(databaseBackupServiceProvider);

      await backupService.importDatabaseFromFile(File(filePath));
      refreshAllAppProviders(ref);

      if (mounted) {
        Navigator.pop(context);
        AppToast.showSuccess(context, AppStrings.backupImportSuccess);
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, '${AppStrings.backupImportErrorPrefix}$e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      scrollable: true,
      title: Row(
        children: [
          Icon(Icons.backup_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              AppStrings.backupsAndDatabaseTitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      content: _isProcessing
          ? const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.file_upload_outlined, color: Colors.blueAccent),
                  title: const Text(AppStrings.exportBackupTitle),
                  subtitle: const Text(AppStrings.exportBackupSubtitle),
                  onTap: _exportBackup,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.file_download_outlined, color: Colors.amber),
                  title: const Text(AppStrings.importBackupTitle),
                  subtitle: const Text(AppStrings.importBackupSubtitle),
                  onTap: _importBackup,
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.close),
        ),
      ],
    );
  }
}
