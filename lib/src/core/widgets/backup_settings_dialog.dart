import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_strings.dart';
import 'backup_workflow_helper.dart';

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

  Future<void> _exportBackup() => BackupWorkflowHelper.exportBackup(
        context,
        ref,
        (processing) => setState(() => _isProcessing = processing),
      );

  Future<void> _importBackup() => BackupWorkflowHelper.importBackup(
        context,
        ref,
        (processing) => setState(() => _isProcessing = processing),
        onSuccess: () => Navigator.pop(context),
      );

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
