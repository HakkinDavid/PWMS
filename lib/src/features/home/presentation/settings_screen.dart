import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/updater/presentation/update_prompt_dialog.dart';
import '../../../core/widgets/app_toast.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isProcessing = false;
  bool _isCheckingUpdate = false;

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
        AppToast.showSuccess(context, AppStrings.backupImportSuccess);
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, '${AppStrings.backupImportErrorPrefix}$e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _checkForUpdates() async {
    if (_isCheckingUpdate) return;
    setState(() => _isCheckingUpdate = true);

    try {
      final updateService = ref.read(appUpdateServiceProvider);
      final updateInfo = await updateService.checkForUpdate();

      if (!mounted) return;

      if (updateInfo.isAvailable) {
        await UpdatePromptDialog.show(
          context,
          updateInfo: updateInfo,
          onConfirmUpdate: () => updateService.triggerUpdate(),
        );
      } else {
        AppToast.showSuccess(context, AppStrings.appUpToDate);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, '${AppStrings.updateError}$e');
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingUpdate = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appVersionAsync = ref.watch(currentAppVersionProvider);
    final appVersion = appVersionAsync.asData?.value ?? '1.0.0';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.globalSettingsTitle),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.settings_suggest_rounded, size: 56, color: theme.colorScheme.onPrimaryContainer),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.globalSettingsTitle,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  '${AppStrings.appName} • ${AppStrings.appVersionLabel}: v$appVersion',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Sección 1: Actualizaciones de Software
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      AppStrings.softwareUpdatesTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(120)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.system_update_alt_rounded, color: theme.colorScheme.primary),
                    ),
                    title: const Text(AppStrings.checkForUpdatesTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text(AppStrings.checkForUpdatesSubtitle),
                    trailing: _isCheckingUpdate
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: _isCheckingUpdate ? null : _checkForUpdates,
                  ),
                ),

                const SizedBox(height: 28),

                // Sección 2: Gestión de Respaldos
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      AppStrings.backupManagementTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                if (_isProcessing)
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  )
                else
                  Column(
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(120)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.file_upload_outlined, color: Colors.blueAccent),
                          ),
                          title: const Text(AppStrings.exportBackupTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text(AppStrings.exportBackupSubtitle),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _exportBackup,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(120)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.file_download_outlined, color: Colors.amber),
                          ),
                          title: const Text(AppStrings.importBackupTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text(AppStrings.importBackupSubtitle),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _importBackup,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
