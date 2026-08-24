import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/domain/entity_photo_helper.dart';
import '../../entities/domain/entity_template.dart';
import '../../entities/presentation/entity_photo_thumbnail.dart';
import '../domain/catalog_item.dart';
import '../domain/numismatic_data_helper.dart';
import '../domain/subspecies.dart';
import 'numismatic_camera_capture_view.dart';
import 'standard_media_picker_sheet.dart';

class SpeciesDetailView extends ConsumerWidget {
  final CatalogItem species;
  final Subspecies? subspecies;
  final String? instanceId;
  final Widget? instanceSpecificsHeader;
  final Widget? instanceSpecificsFooter;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showAttachmentAction;

  const SpeciesDetailView({
    super.key,
    required this.species,
    this.subspecies,
    this.instanceId,
    this.instanceSpecificsHeader,
    this.instanceSpecificsFooter,
    this.actions,
    this.floatingActionButton,
    this.showAttachmentAction = false,
  });

  void _invalidateAllRelatedProviders(WidgetRef ref, String speciesId, String? instanceId) {
    ref.invalidate(speciesAttachmentsProvider(speciesId));
    if (instanceId != null && instanceId.isNotEmpty) {
      ref.invalidate(instanceAttachmentsProvider(instanceId));
    }
    ref.invalidate(entityListProvider);
    ref.invalidate(catalogListProvider);
    ref.invalidate(recentEntitiesProvider);
    ref.invalidate(subspeciesListProvider);
    ref.invalidate(searchResultsProvider);
  }

  Future<void> _handleAddAttachment(
    BuildContext context,
    WidgetRef ref,
    String speciesId, {
    String? instanceId,
    List<Attachment>? currentAttachments,
  }) async {
    final isNumismatic = NumismaticDataHelper.isNumismaticSpecies(species);
    NumismaticScanOption? numismaticOption;

    if (isNumismatic) {
      final isCoin = NumismaticDataHelper.isCoin(species);
      final targetAttachments = currentAttachments ?? [];
      final hasObverse = targetAttachments.any((a) => a.fileName.toLowerCase().contains('anverso'));
      final hasReverse = targetAttachments.any((a) => a.fileName.toLowerCase().contains('reverso'));

      String? missingSide;
      if (!hasObverse && !hasReverse) {
        missingSide = 'ambos';
      } else if (!hasObverse) {
        missingSide = 'anverso';
      } else if (!hasReverse) {
        missingSide = 'reverso';
      } else {
        missingSide = null;
        return;
      }

      numismaticOption = NumismaticScanOption(
        isCoin: isCoin,
        missingSide: missingSide,
      );
    }

    final result = await StandardMediaPickerSheet.show(
      context,
      title: instanceId != null ? 'Adjuntar a esta Instancia' : 'Adjuntar a Especie',
      webSearchQuery: subspecies?.subspeciesName ?? species.name,
      numismaticOption: numismaticOption,
    );

    if (result == null) return;

    final storage = ref.read(fileStorageServiceProvider);

    try {
      String savedRelativePath;
      String finalFileName = result.fileName;

      if (result.file != null) {
        savedRelativePath = await storage.saveFile(result.file!.path);

        if (isNumismatic && result.source == 'numismatic') {
          final side = (numismaticOption?.missingSide == 'reverso') ? 'reverso' : 'anverso';
          final ext = result.file!.path.contains('.') ? result.file!.path.split('.').last : 'jpg';

          if (subspecies != null && instanceId != null) {
            finalFileName = NumismaticDataHelper.buildAttachmentFileName(
              subspeciesName: subspecies!.subspeciesName,
              instanceId: instanceId,
              side: side,
              extension: ext,
            );
          } else {
            final subName = subspecies?.subspeciesName ?? species.name;
            final instPart = instanceId != null ? ' ($instanceId)' : '';
            finalFileName = '${NumismaticDataHelper.sanitizeFileName(subName)}$instPart ($side).$ext';
          }
        }
      } else if (result.relativeStoredPath != null) {
        savedRelativePath = result.relativeStoredPath!;
      } else {
        return;
      }

      final attachment = Attachment(
        id: const Uuid().v4(),
        speciesId: speciesId,
        instanceId: instanceId,
        filePath: savedRelativePath,
        fileName: finalFileName,
        fileType: result.fileType,
        createdAt: DateTime.now(),
      );

      await ref.read(entityRepositoryProvider).addAttachment(attachment);
      _invalidateAllRelatedProviders(ref, speciesId, instanceId);

      if (context.mounted) {
        AppToast.showSuccess(context, 'Adjunto agregado correctamente.');
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    }
  }

  Future<void> _handleReplaceAttachment(
    BuildContext context,
    WidgetRef ref,
    Attachment att,
  ) async {
    final isNumismatic = NumismaticDataHelper.isNumismaticSpecies(species);
    final fileNameLower = att.fileName.toLowerCase();
    final isNumismaticSide = isNumismatic && (fileNameLower.contains('anverso') || fileNameLower.contains('reverso'));

    try {
      if (isNumismaticSide) {
        // Direct jump to numismatic camera with side preselected
        final side = fileNameLower.contains('reverso') ? 'reverso' : 'anverso';
        final isCoin = NumismaticDataHelper.isCoin(species);

        final capturedFile = await NumismaticCameraCaptureView.show(
          context,
          isCoin: isCoin,
          targetSide: side,
        );

        if (capturedFile != null && context.mounted) {
          final shouldReplace = await AppConfirmationDialog.show(
            context: context,
            title: AppStrings.confirmReplaceAttachmentTitle,
            message: '${AppStrings.confirmReplaceAttachmentMessage}\n("${att.fileName}")',
            confirmLabel: 'Reemplazar',
            cancelLabel: AppStrings.cancel,
            icon: Icons.sync,
          );
          if (!shouldReplace || !context.mounted) return;

          await ref.read(entityRepositoryProvider).replaceAttachmentFile(
                att.id,
                capturedFile.path,
                newFileType: 'image',
              );

          _invalidateAllRelatedProviders(ref, att.speciesId, att.instanceId);

          if (context.mounted) {
            AppToast.showSuccess(context, 'Adjunto numismático actualizado correctamente.');
          }
        }
        return;
      }

      // Standard media picker for non-numismatic or general attachments
      final result = await StandardMediaPickerSheet.show(
        context,
        title: 'Reemplazar Adjunto ("${att.fileName}")',
        webSearchQuery: subspecies?.subspeciesName ?? species.name,
      );

      if (result == null || !context.mounted) return;

      final newName = result.fileName ?? 'nuevo archivo';
      final shouldReplace = await AppConfirmationDialog.show(
        context: context,
        title: AppStrings.confirmReplaceAttachmentTitle,
        message: '${AppStrings.confirmReplaceAttachmentMessage}\n("${att.fileName}" ➔ "$newName")',
        confirmLabel: 'Reemplazar',
        cancelLabel: AppStrings.cancel,
        icon: Icons.sync,
      );
      if (!shouldReplace || !context.mounted) return;

      if (result.file != null) {
        await ref.read(entityRepositoryProvider).replaceAttachmentFile(
              att.id,
              result.file!.path,
              newFileName: result.fileName,
              newFileType: result.fileType,
            );
      } else if (result.relativeStoredPath != null) {
        final absPath = await ref.read(fileStorageServiceProvider).getAbsolutePath(result.relativeStoredPath!);
        await ref.read(entityRepositoryProvider).replaceAttachmentFile(
              att.id,
              absPath,
              newFileName: result.fileName,
              newFileType: result.fileType,
            );
      }

      _invalidateAllRelatedProviders(ref, att.speciesId, att.instanceId);

      if (context.mounted) {
        AppToast.showSuccess(context, 'Adjunto reemplazado correctamente.');
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, 'Error al reemplazar adjunto: $e');
      }
    }
  }

  Future<void> _handleRenameAttachment(
    BuildContext context,
    WidgetRef ref,
    Attachment att,
  ) async {
    final controller = TextEditingController(text: att.fileName);

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renombrar adjunto'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre del archivo',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                Navigator.pop(ctx, val);
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != att.fileName) {
      try {
        final updated = att.copyWith(fileName: newName);
        await ref.read(entityRepositoryProvider).updateAttachment(updated);
        _invalidateAllRelatedProviders(ref, att.speciesId, att.instanceId);
        if (context.mounted) {
          AppToast.showSuccess(context, 'Nombre actualizado correctamente.');
        }
      } catch (e) {
        if (context.mounted) {
          AppToast.showError(context, 'Error al renombrar: $e');
        }
      }
    }
  }

  Future<void> _openAttachment(BuildContext context, WidgetRef ref, Attachment att) async {
    final storage = ref.read(fileStorageServiceProvider);
    final absPath = await storage.getAbsolutePath(att.filePath);
    final file = File(absPath);

    if (!file.existsSync()) {
      if (context.mounted) {
        AppToast.showError(context, 'El archivo físico no existe en el almacenamiento.');
      }
      return;
    }

    final isImage = att.fileType == 'image' ||
        ['.jpg', '.jpeg', '.png', '.webp', '.heic', '.bmp']
            .any((ext) => att.filePath.toLowerCase().endsWith(ext));

    if (isImage) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.zero,
            child: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InteractiveViewer(
                    child: Image.file(
                      file,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image_outlined, color: Colors.white70, size: 48),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      await OpenFilex.open(absPath);
    }
  }

  Future<void> _confirmAndDeleteAttachment(BuildContext context, WidgetRef ref, Attachment att) async {
    final confirmed = await AppConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: 'Eliminar adjunto',
      message: '¿Deseas eliminar permanentemente el archivo "${att.fileName}"?',
    );

    if (confirmed == true) {
      try {
        await ref.read(entityRepositoryProvider).deleteAttachment(att.id);
        _invalidateAllRelatedProviders(ref, att.speciesId, att.instanceId);
        if (context.mounted) {
          AppToast.showSuccess(context, 'Adjunto eliminado correctamente');
        }
      } catch (e) {
        if (context.mounted) {
          AppToast.showError(context, 'Error al eliminar adjunto: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final template = EntityTemplateRegistry.getTemplate(species.type);
    final speciesAttachmentsAsync = ref.watch(speciesAttachmentsProvider(species.id));
    final instanceAttachmentsAsync = instanceId != null && instanceId!.isNotEmpty
        ? ref.watch(instanceAttachmentsProvider(instanceId!))
        : null;

    final isCustomSubspecies = subspecies != null && subspecies!.subspeciesName.toLowerCase() != 'genérica';

    final headerTitle = isCustomSubspecies
        ? '${subspecies!.subspeciesName}${subspecies!.brand != null ? " (${subspecies!.brand})" : ""}'
        : species.name;

    final bottomPadding = MediaQuery.paddingOf(context).bottom + (floatingActionButton != null ? 88.0 : 28.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          headerTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Box Preview Card with Subspecies Fallback to Species Photo / Instance Attachment
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.dividerColor, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: EntityPhotoThumbnail(
                    species: species,
                    subspecies: subspecies,
                    instanceId: instanceId,
                    size: 140,
                    borderRadius: BorderRadius.circular(18),
                    useTextBadgeFallback: false,
                    fallbackIcon: template.icon,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Badges (Type, Species Context, Barcode, Uniqueness)
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.colorScheme.primary.withAlpha(90)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(template.icon, size: 14, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            species.type,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCustomSubspecies) ...[
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.public, size: 12),
                        label: Text(
                          'Especie: ${species.name}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (subspecies!.barcode != null)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: const Icon(Icons.qr_code, size: 12),
                          label: Text('${AppStrings.barcodeLabel}: ${subspecies!.barcode}', style: const TextStyle(fontSize: 11)),
                        ),
                    ] else if (subspecies?.barcode != null) ...[
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.qr_code, size: 12),
                        label: Text('${AppStrings.barcodeLabel}: ${subspecies!.barcode}', style: const TextStyle(fontSize: 11)),
                      ),
                    ],
                    if (species.isUnique)
                      const Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: Icon(Icons.star, size: 12, color: Colors.amber),
                        label: Text(AppStrings.isUniqueLabel, style: TextStyle(fontSize: 11)),
                      ),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(
                        species.isNonPerishable ? Icons.shield_outlined : Icons.timer_outlined,
                        size: 12,
                        color: species.isNonPerishable ? Colors.green : Colors.orange,
                      ),
                      label: Text(
                        species.isNonPerishable
                            ? 'Imperecedero'
                            : 'Perecedero${species.defaultShelfLifeDays != null ? " (${species.defaultShelfLifeDays} días de vida útil)" : ""}',
                        style: TextStyle(
                          fontSize: 11,
                          color: species.isNonPerishable ? Colors.green.shade800 : Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Display ALL 4NF Multiple Magnitude Property Schemas (only in species view, not in instance view)
              if (species.magnitudes.isNotEmpty && (instanceId == null || instanceId!.isEmpty)) ...[
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.registeredPropertiesAndMagnitudes,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: species.magnitudes.length,
                          itemBuilder: (ctx, idx) {
                            final mag = species.magnitudes[idx];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.straighten, size: 14, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${mag.propertyName} (${(mag.unitSymbol != null && mag.unitSymbol!.trim().isNotEmpty) ? mag.unitSymbol!.trim() : mag.dataType})',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Instance Specific Header
              if (instanceSpecificsHeader != null) ...[
                instanceSpecificsHeader!,
                const SizedBox(height: 14),
              ],

              // Instance Specific Footer
              if (instanceSpecificsFooter != null) ...[
                instanceSpecificsFooter!,
                const SizedBox(height: 14),
              ],

              // UNIFIED ATTACHMENTS SECTION
              if (instanceId != null && instanceId!.isNotEmpty) ...[
                // Unified card for Instance View (Showing Species + Instance attachments together)
                _buildUnifiedInstanceAttachments(
                  context,
                  ref,
                  speciesAttachmentsAsync: speciesAttachmentsAsync,
                  instanceAttachmentsAsync: instanceAttachmentsAsync!,
                ),
              ] else ...[
                // Species View Attachments
                speciesAttachmentsAsync.when(
                  data: (attachments) => _UnifiedAttachmentGroupWidget(
                    title: AppStrings.attachmentsTitle,
                    attachments: attachments,
                    isEditing: showAttachmentAction,
                    isInstanceView: false,
                    onAdd: () => _handleAddAttachment(
                      context,
                      ref,
                      species.id,
                      instanceId: null,
                      currentAttachments: attachments,
                    ),
                    onOpen: (att) => _openAttachment(context, ref, att),
                    onReplace: (att) => _handleReplaceAttachment(context, ref, att),
                    onRename: (att) => _handleRenameAttachment(context, ref, att),
                    onDelete: (att) => _confirmAndDeleteAttachment(context, ref, att),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('${AppStrings.errorPrefix}$err'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedInstanceAttachments(
    BuildContext context,
    WidgetRef ref, {
    required AsyncValue<List<Attachment>> speciesAttachmentsAsync,
    required AsyncValue<List<Attachment>> instanceAttachmentsAsync,
  }) {
    if (speciesAttachmentsAsync.isLoading || instanceAttachmentsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final speciesAtts = speciesAttachmentsAsync.asData?.value ?? [];
    final instanceAtts = instanceAttachmentsAsync.asData?.value ?? [];
    final unifiedList = <Attachment>[...instanceAtts, ...speciesAtts];

    return _UnifiedAttachmentGroupWidget(
      title: AppStrings.attachmentsTitle,
      attachments: unifiedList,
      isEditing: showAttachmentAction,
      isInstanceView: true,
      onAdd: () => _handleAddAttachment(
        context,
        ref,
        species.id,
        instanceId: instanceId,
        currentAttachments: instanceAtts,
      ),
      onOpen: (att) => _openAttachment(context, ref, att),
      onReplace: (att) => _handleReplaceAttachment(context, ref, att),
      onRename: (att) => _handleRenameAttachment(context, ref, att),
      onDelete: (att) => _confirmAndDeleteAttachment(context, ref, att),
    );
  }
}

class _UnifiedAttachmentGroupWidget extends StatelessWidget {
  final String title;
  final List<Attachment> attachments;
  final bool isEditing;
  final bool isInstanceView;
  final VoidCallback onAdd;
  final Function(Attachment) onOpen;
  final Function(Attachment) onReplace;
  final Function(Attachment) onRename;
  final Function(Attachment) onDelete;

  const _UnifiedAttachmentGroupWidget({
    required this.title,
    required this.attachments,
    required this.isEditing,
    required this.isInstanceView,
    required this.onAdd,
    required this.onOpen,
    required this.onReplace,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Icon(
                  Icons.folder_open,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${attachments.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Add button if in editing mode
            if (isEditing) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                  label: Text(
                    isInstanceView ? 'Agregar adjunto a esta instancia' : AppStrings.attachFile,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Empty state or list
            if (attachments.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  AppStrings.emptyAttachments,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attachments.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final att = attachments[idx];
                  final isSpeciesLevel = att.instanceId == null || att.instanceId!.isEmpty;
                  final isEditable = isEditing && (!isInstanceView || !isSpeciesLevel);

                  final isImage = att.fileType == 'image' ||
                      ['.jpg', '.jpeg', '.png', '.webp', '.heic', '.bmp']
                          .any((ext) => att.filePath.toLowerCase().endsWith(ext));

                  return Consumer(
                    builder: (context, ref, _) {
                      return FutureBuilder<String>(
                        future: ref.read(fileStorageServiceProvider).getAbsolutePath(att.filePath),
                        builder: (context, snapshot) {
                          final absPath = snapshot.data ?? '';
                          final fileExists = absPath.isNotEmpty && File(absPath).existsSync();

                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            leading: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: fileExists
                                    ? (isImage ? Colors.blue.withAlpha(20) : Colors.amber.withAlpha(20))
                                    : Colors.red.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: !fileExists
                                    ? const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20)
                                    : (isImage
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              File(absPath),
                                              fit: BoxFit.cover,
                                              width: 38,
                                              height: 38,
                                              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 20, color: Colors.blue),
                                            ),
                                          )
                                        : const Icon(Icons.picture_as_pdf, color: Colors.amber, size: 20)),
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    att.fileName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: fileExists ? null : Colors.red.shade700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isInstanceView) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: isSpeciesLevel
                                          ? theme.colorScheme.primary.withAlpha(25)
                                          : Colors.teal.withAlpha(25),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isSpeciesLevel
                                            ? theme.colorScheme.primary.withAlpha(90)
                                            : Colors.teal.withAlpha(90),
                                      ),
                                    ),
                                    child: Text(
                                      isSpeciesLevel ? 'Especie' : 'Instancia',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: isSpeciesLevel ? theme.colorScheme.primary : Colors.teal.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            subtitle: fileExists
                                ? Text(
                                    att.createdAt.toString().split('.').first,
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  )
                                : const Text(
                                    'Archivo físico no encontrado',
                                    style: TextStyle(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                  ),
                            onTap: () => onOpen(att),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.open_in_new, size: 18),
                                  tooltip: 'Abrir adjunto',
                                  onPressed: () => onOpen(att),
                                ),
                                if (isEditable) ...[
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, size: 18),
                                    tooltip: 'Opciones de adjunto',
                                    onSelected: (value) {
                                      switch (value) {
                                        case 'replace':
                                          onReplace(att);
                                          break;
                                        case 'rename':
                                          onRename(att);
                                          break;
                                        case 'delete':
                                          onDelete(att);
                                          break;
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'replace',
                                        child: Row(
                                          children: [
                                            Icon(Icons.sync, size: 16, color: Colors.blue),
                                            SizedBox(width: 8),
                                            Text('Reemplazar archivo', style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'rename',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 16, color: Colors.amber),
                                            SizedBox(width: 8),
                                            Text('Renombrar', style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                                            SizedBox(width: 8),
                                            Text('Eliminar', style: TextStyle(fontSize: 12, color: Colors.redAccent)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
