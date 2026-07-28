import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        AppToast.showSuccess(context, 'Respaldo preparado y compartido.');
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error exportando respaldo: $e');
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
        title: const Text('Confirmar Restauración'),
        content: const Text(
          'ADVERTENCIA: Importar un respaldo reemplazará todos los datos y archivos actuales de tu mundo con los datos del paquete seleccionado. ¿Deseas continuar?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restaurar Todo'),
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
        AppToast.showSuccess(context, 'Respaldo completo y archivos restaurados correctamente.');
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error importando respaldo: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.backup_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          const Text('Respaldos y Base de Datos'),
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
                  title: const Text('Exportar Respaldo Completo (Zip)'),
                  subtitle: const Text('Genera un paquete ZIP con la base de datos y todas las imágenes/archivos adjuntos.'),
                  onTap: _exportBackup,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.file_download_outlined, color: Colors.amber),
                  title: const Text('Importar Respaldo (.zip / .json)'),
                  subtitle: const Text('Restaura la base de datos e imágenes adjuntas desde un archivo de respaldo.'),
                  onTap: _importBackup,
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
