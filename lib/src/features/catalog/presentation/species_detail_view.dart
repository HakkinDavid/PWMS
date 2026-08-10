import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/domain/entity_photo_helper.dart';
import '../../entities/domain/entity_template.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';

class SpeciesDetailView extends ConsumerWidget {
  final CatalogItem species;
  final Subspecies? subspecies;
  final String? instanceId;
  final Widget? instanceSpecificsHeader;
  final Widget? instanceSpecificsFooter;
  final List<Widget>? actions;
  final bool showAttachmentAction;

  const SpeciesDetailView({
    super.key,
    required this.species,
    this.subspecies,
    this.instanceId,
    this.instanceSpecificsHeader,
    this.instanceSpecificsFooter,
    this.actions,
    this.showAttachmentAction = false,
  });

  Future<void> _pickAndAddDocument(
    BuildContext context,
    WidgetRef ref,
    String speciesId, {
    String? instanceId,
  }) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final storage = ref.read(fileStorageServiceProvider);

      try {
        final savedRelativePath = await storage.saveFile(file.path!);

        final attachment = Attachment(
          id: const Uuid().v4(),
          speciesId: speciesId,
          instanceId: instanceId,
          filePath: savedRelativePath,
          fileName: file.name,
          fileType: file.extension ?? 'doc',
          createdAt: DateTime.now(),
        );

        await ref.read(entityRepositoryProvider).addAttachment(attachment);
        ref.invalidate(speciesAttachmentsProvider(speciesId));
        if (instanceId != null && instanceId.isNotEmpty) {
          ref.invalidate(instanceAttachmentsProvider(instanceId));
        }

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
            child: Stack(
              fit: StackFit.expand,
              children: [
                InteractiveViewer(
                  child: Image.file(file, fit: BoxFit.contain),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      await OpenFilex.open(absPath);
    }
  }

  Future<void> _confirmAndDeleteAttachment(BuildContext context, WidgetRef ref, Attachment att) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar adjunto'),
        content: Text('¿Deseas eliminar permanentemente el archivo "${att.fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(entityRepositoryProvider).deleteAttachment(att.id);
        ref.invalidate(speciesAttachmentsProvider(att.speciesId));
        if (att.instanceId != null && att.instanceId!.isNotEmpty) {
          ref.invalidate(instanceAttachmentsProvider(att.instanceId!));
        }
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          headerTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: actions,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: FutureBuilder<String?>(
                      future: resolveEffectiveEntityPhotoPath(
                        ref,
                        subspecies: subspecies,
                        species: species,
                        instanceId: instanceId,
                      ),
                      builder: (context, photoPathSnapshot) {
                        final effectivePhotoPath = photoPathSnapshot.data;

                        return FutureBuilder<String>(
                          future: effectivePhotoPath != null && effectivePhotoPath.isNotEmpty
                              ? ref.read(fileStorageServiceProvider).getAbsolutePath(effectivePhotoPath)
                              : Future.value(''),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                              return Image.file(
                                File(snapshot.data!),
                                fit: BoxFit.contain,
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withAlpha(180),
                                    theme.colorScheme.secondary.withAlpha(180),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  template.icon,
                                  size: 54,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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

              // Display ALL 4NF Multiple Magnitude Property Schemas
              if (species.magnitudes.isNotEmpty) ...[
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

              // Attach File Action Button (Only shown if showAttachmentAction == true, i.e. in Edit mode!)
              if (showAttachmentAction) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickAndAddDocument(
                          context,
                          ref,
                          species.id,
                          instanceId: instanceId,
                        ),
                        icon: const Icon(Icons.attach_file, size: 16),
                        label: Text(instanceId != null ? 'Adjuntar a esta Instancia' : AppStrings.attachFile),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Section 1: Species Attachments
              speciesAttachmentsAsync.when(
                data: (attachments) => _AttachmentGroupWidget(
                  title: AppStrings.attachmentsTitle,
                  attachments: attachments,
                  isEditing: showAttachmentAction,
                  onOpen: (att) => _openAttachment(context, ref, att),
                  onDelete: (att) => _confirmAndDeleteAttachment(context, ref, att),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('${AppStrings.errorPrefix}$err'),
              ),

              // Section 2: Instance Attachments (if viewing a specific instance)
              if (instanceAttachmentsAsync != null) ...[
                const SizedBox(height: 12),
                instanceAttachmentsAsync.when(
                  data: (attachments) => _AttachmentGroupWidget(
                    title: 'Adjuntos de esta Instancia',
                    attachments: attachments,
                    isEditing: showAttachmentAction,
                    onOpen: (att) => _openAttachment(context, ref, att),
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
}

class _AttachmentGroupWidget extends StatelessWidget {
  final String title;
  final List<Attachment> attachments;
  final bool isEditing;
  final Function(Attachment) onOpen;
  final Function(Attachment) onDelete;

  const _AttachmentGroupWidget({
    required this.title,
    required this.attachments,
    required this.isEditing,
    required this.onOpen,
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
            Row(
              children: [
                Icon(
                  title.contains('Instancia') ? Icons.inventory_2 : Icons.folder_open,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
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
                              width: 36,
                              height: 36,
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
                                              width: 36,
                                              height: 36,
                                              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 20, color: Colors.blue),
                                            ),
                                          )
                                        : const Icon(Icons.picture_as_pdf, color: Colors.amber, size: 20)),
                              ),
                            ),
                            title: Text(
                              att.fileName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: fileExists ? null : Colors.red.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                                if (isEditing)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                    tooltip: AppStrings.delete,
                                    onPressed: () => onDelete(att),
                                  ),
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
