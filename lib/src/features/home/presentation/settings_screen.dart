import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Global'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.storage, size: 64, color: theme.colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 24),
              Text(
                'Gestión de Copias de Seguridad Local',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Exporta o restaura la base de datos completa de PWMS de forma segura en tu almacenamiento local.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              if (_isProcessing)
                const CircularProgressIndicator()
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(120)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      const SizedBox(height: 16),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(120)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
