import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../domain/attachment.dart';
import '../domain/entity_template.dart';
import '../domain/world_entity.dart';
import '../../places/presentation/move_entity_sheet.dart';
import '../../relations/presentation/add_relation_sheet.dart';
import 'container_contents_view.dart';
import 'edit_entity_sheet.dart';
import 'photo_viewer_dialog.dart';

class EntityDetailScreen extends ConsumerStatefulWidget {
  final String entityId;

  const EntityDetailScreen({super.key, required this.entityId});

  @override
  ConsumerState<EntityDetailScreen> createState() => _EntityDetailScreenState();
}

class _EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
  Future<void> _openFile(Attachment attachment) async {
    final storage = ref.read(fileStorageServiceProvider);
    final absPath = await storage.getAbsolutePath(attachment.filePath);
    if (File(absPath).existsSync()) {
      await OpenFile.open(absPath);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El archivo local no fue encontrado')),
        );
      }
    }
  }

  Future<void> _deleteAttachment(Attachment attachment, WorldEntity entity) async {
    await ref.read(entityRepositoryProvider).deleteAttachment(attachment.id);
    await ref.read(fileStorageServiceProvider).deleteFile(attachment.filePath);
    await ref.read(activityLoggerServiceProvider).logAttachmentRemoved(entity.id, entity.name, attachment.fileName);

    ref.invalidate(entityAttachmentsProvider(entity.id));
  }

  Future<void> _addAttachmentFromSource(ImageSource source, WorldEntity entity) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 85);
    if (file == null) return;

    final storage = ref.read(fileStorageServiceProvider);
    final relativePath = await storage.saveFile(file.path);

    final attachment = Attachment(
      id: const Uuid().v4(),
      entityId: entity.id,
      filePath: relativePath,
      fileName: file.name,
      fileType: 'image',
      createdAt: DateTime.now(),
    );

    await ref.read(entityRepositoryProvider).addAttachment(attachment);
    await ref.read(activityLoggerServiceProvider).logAttachmentAdded(entity.id, entity.name, file.name);

    ref.invalidate(entityAttachmentsProvider(entity.id));
  }

  Future<void> _addFileAttachment(WorldEntity entity) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) return;

    final filePath = result.files.single.path!;
    final fileName = result.files.single.name;

    final storage = ref.read(fileStorageServiceProvider);
    final relativePath = await storage.saveFile(filePath);

    final attachment = Attachment(
      id: const Uuid().v4(),
      entityId: entity.id,
      filePath: relativePath,
      fileName: fileName,
      fileType: 'file',
      createdAt: DateTime.now(),
    );

    await ref.read(entityRepositoryProvider).addAttachment(attachment);
    await ref.read(activityLoggerServiceProvider).logAttachmentAdded(entity.id, entity.name, fileName);

    ref.invalidate(entityAttachmentsProvider(entity.id));
  }

  Future<void> _showConsumeQuantityDialog(WorldEntity entity) async {
    final controller = TextEditingController(text: entity.quantity?.toString() ?? '1');
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ajustar Cantidad (${entity.unit ?? "unidades"})'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nueva cantidad disponible'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              final parsed = double.tryParse(controller.text.trim());
              Navigator.pop(ctx, parsed);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (result != null) {
      final updated = entity.copyWith(quantity: result, updatedAt: DateTime.now());
      await ref.read(entityListProvider.notifier).saveEntity(updated);
      await ref.read(activityLoggerServiceProvider).logQuantityConsumed(
            entity.id,
            entity.name,
            result,
            entity.unit ?? 'unidades',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entityAsync = ref.watch(entityDetailProvider(widget.entityId));
    final theme = Theme.of(context);

    return Scaffold(
      body: entityAsync.when(
        data: (entity) {
          if (entity == null) {
            return const Center(child: Text('Elemento no encontrado en tu mundo'));
          }

          final template = EntityTemplateRegistry.getTemplate(entity.type);
          final placesState = ref.watch(placeListProvider);
          String placeName = 'Sin ubicación asignada';
          if (entity.placeId != null) {
            placesState.whenData((places) {
              final found = places.where((p) => p.id == entity.placeId).firstOrNull;
              if (found != null) placeName = found.name;
            });
          }

          final attachmentsAsync = ref.watch(entityAttachmentsProvider(entity.id));
          final relationsAsync = ref.watch(entityRelationsProvider(entity.id));

          return CustomScrollView(
            slivers: [
              // Hero Photo / Header
              SliverAppBar(
                expandedHeight: 260.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    entity.name,
                    style: const TextStyle(
                      shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                    ),
                  ),
                  background: FutureBuilder<String>(
                    future: entity.mainPhotoPath != null
                        ? ref.read(fileStorageServiceProvider).getAbsolutePath(entity.mainPhotoPath!)
                        : Future.value(''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                        return GestureDetector(
                          onTap: () {
                            PhotoViewerDialog.show(
                              context,
                              entity: entity,
                              imagePath: snapshot.data!,
                              onChangePhoto: () async {
                                final picker = ImagePicker();
                                final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                                if (img != null) {
                                  final rel = await ref.read(fileStorageServiceProvider).saveFile(img.path);
                                  final upd = entity.copyWith(mainPhotoPath: rel, updatedAt: DateTime.now());
                                  await ref.read(entityListProvider.notifier).saveEntity(upd);
                                  await ref.read(activityLoggerServiceProvider).logPhotoChanged(entity.id, entity.name);
                                }
                              },
                              onDeletePhoto: () async {
                                final upd = entity.copyWith(mainPhotoPath: null, updatedAt: DateTime.now());
                                await ref.read(entityListProvider.notifier).saveEntity(upd);
                                await ref.read(activityLoggerServiceProvider).logPhotoRemoved(entity.id, entity.name);
                              },
                            );
                          },
                          child: Image.file(
                            File(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            template.icon,
                            size: 80,
                            color: Colors.white.withAlpha(150),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(entity.isArchived ? Icons.unarchive : Icons.archive_outlined),
                    onPressed: () async {
                      final updated = entity.copyWith(isArchived: !entity.isArchived, updatedAt: DateTime.now());
                      await ref.read(entityListProvider.notifier).saveEntity(updated);
                      await ref.read(activityLoggerServiceProvider).logEntityEdited(
                            entity.id,
                            entity.name,
                            details: entity.isArchived ? 'Desarchivado en tu mundo' : 'Archivado de tu mundo',
                          );
                    },
                    tooltip: entity.isArchived ? 'Desarchivar' : 'Archivar',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => EditEntitySheet.show(context, entity),
                    tooltip: 'Editar elemento',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('¿Eliminar de tu Mundo?'),
                          content: Text('¿Seguro que deseas eliminar "${entity.name}"?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                        await ref.read(activityLoggerServiceProvider).logEntityDeleted(entity.id, entity.name);
                        ref.read(entityListProvider.notifier).loadEntities();

                        if (context.mounted) {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('"${entity.name}" eliminado de tu mundo')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),

              // Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Concept Badge, Barcode & Quantity Row with +/- controls
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(40),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.colorScheme.primary.withAlpha(100)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(template.icon, size: 16, color: theme.colorScheme.primary),
                                const SizedBox(width: 6),
                                Text(
                                  entity.type,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (entity.barcode != null && entity.barcode!.isNotEmpty)
                            Chip(
                              avatar: const Icon(Icons.qr_code_scanner, size: 14),
                              label: Text(entity.barcode!),
                            ),
                          // Quantity +/- controls
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.colorScheme.secondary.withAlpha(80)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  icon: const Icon(Icons.remove, size: 16),
                                  onPressed: () async {
                                    final currentQty = entity.quantity ?? 1.0;
                                    if (currentQty > 0) {
                                      final newQty = currentQty - 1.0;
                                      final updated = entity.copyWith(quantity: newQty, updatedAt: DateTime.now());
                                      await ref.read(entityListProvider.notifier).saveEntity(updated);
                                      await ref.read(activityLoggerServiceProvider).logQuantityConsumed(
                                            entity.id,
                                            entity.name,
                                            newQty,
                                            entity.unit ?? 'unidades',
                                          );
                                    }
                                  },
                                ),
                                GestureDetector(
                                  onTap: () => _showConsumeQuantityDialog(entity),
                                  child: Text(
                                    '${entity.quantity ?? 1.0} ${entity.unit ?? "unidades"}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.secondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  icon: const Icon(Icons.add, size: 16),
                                  onPressed: () async {
                                    final currentQty = entity.quantity ?? 0.0;
                                    final newQty = currentQty + 1.0;
                                    final updated = entity.copyWith(quantity: newQty, updatedAt: DateTime.now());
                                    await ref.read(entityListProvider.notifier).saveEntity(updated);
                                    await ref.read(activityLoggerServiceProvider).logQuantityConsumed(
                                          entity.id,
                                          entity.name,
                                          newQty,
                                          entity.unit ?? 'unidades',
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Location Card with quick Move Action (<10s)
                      Card(
                        color: theme.cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on, color: Colors.amber),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ubicación actual',
                                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                                    ),
                                    Text(
                                      placeName,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => MoveEntitySheet.show(context, entity),
                                icon: const Icon(Icons.near_me, size: 16),
                                label: const Text('Mover'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Template View Container: Display contained items if container or place
                      if (entity.isContainer || entity.isPlace || template.primaryView == TemplateViewKind.contents) ...[
                        ContainerContentsView(parentEntity: entity),
                        const SizedBox(height: 24),
                      ],

                      // Quick Action Row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => AddRelationSheet.show(context, entity),
                              icon: const Icon(Icons.link),
                              label: const Text('Relacionar'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => SafeArea(
                                    child: Wrap(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Tomar Foto'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _addAttachmentFromSource(ImageSource.camera, entity);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo_library),
                                          title: const Text('Foto de Galería'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _addAttachmentFromSource(ImageSource.gallery, entity);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.attach_file),
                                          title: const Text('Adjuntar Archivo'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _addFileAttachment(entity);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.attach_file),
                              label: const Text('Adjuntar'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Custom Attributes section
                      if (entity.customAttributes.isNotEmpty) ...[
                        Text('Atributos Personalizados', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: entity.customAttributes.entries.map((entry) {
                            return Chip(
                              avatar: const Icon(Icons.tune, size: 14),
                              label: Text('${entry.key}: ${entry.value}'),
                              backgroundColor: theme.colorScheme.surface,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Notes section
                      if (entity.notes != null && entity.notes!.isNotEmpty) ...[
                        Text('Notas', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Text(entity.notes!, style: theme.textTheme.bodyMedium),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Tags section
                      if (entity.tags.isNotEmpty) ...[
                        Text('Etiquetas', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: entity.tags.map((tag) {
                            return Chip(
                              label: Text('#$tag'),
                              backgroundColor: theme.colorScheme.surface,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Attachments Gallery with Open and Delete capabilities
                      Text('Fotografías y Archivos', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      attachmentsAsync.when(
                        data: (attachments) {
                          if (attachments.isEmpty) {
                            return Text('Sin archivos adjuntos aún.', style: theme.textTheme.bodyMedium);
                          }
                          return SizedBox(
                            height: 110,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: attachments.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final att = attachments[index];
                                return FutureBuilder<String>(
                                  future: ref.read(fileStorageServiceProvider).getAbsolutePath(att.filePath),
                                  builder: (context, snapshot) {
                                    final hasFile = snapshot.hasData && File(snapshot.data!).existsSync();
                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _openFile(att),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: theme.cardColor,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: theme.dividerColor),
                                            ),
                                            child: hasFile && att.fileType == 'image'
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: Image.file(
                                                      File(snapshot.data!),
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        att.fileType == 'image' ? Icons.image : Icons.insert_drive_file,
                                                        size: 32,
                                                        color: theme.colorScheme.primary,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        att.fileName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(fontSize: 10),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.black.withAlpha(180),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(Icons.close, size: 14, color: Colors.white),
                                              onPressed: () => _deleteAttachment(att, entity),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                      ),
                      const SizedBox(height: 24),

                      // Linked Directed Relations section
                      Text('Relaciones Dirigidas', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      relationsAsync.when(
                        data: (relations) {
                          if (relations.isEmpty) {
                            return Text('No se han registrado relaciones con otros elementos.', style: theme.textTheme.bodyMedium);
                          }
                          return Column(
                            children: relations.map((rel) {
                              final isSource = rel.sourceEntityId == entity.id;
                              final otherId = isSource ? rel.targetEntityId : rel.sourceEntityId;
                              final otherEntityAsync = ref.watch(entityDetailProvider(otherId));

                              final displayRelation = isSource ? rel.relationType : 'recibe ${rel.relationType}';

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.swap_horiz, color: Colors.indigoAccent),
                                  title: Text(displayRelation, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: otherEntityAsync.when(
                                    data: (other) => Text(other?.name ?? 'Elemento desconocido'),
                                    loading: () => const Text('Cargando...'),
                                    error: (_, __) => const Text('Error'),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: Colors.redAccent),
                                    onPressed: () async {
                                      await ref.read(relationRepositoryProvider).deleteRelation(rel.id);
                                      final other = await ref.read(entityRepositoryProvider).getEntityById(otherId);
                                      await ref.read(activityLoggerServiceProvider).logRelationRemoved(
                                            entity.name,
                                            other?.name ?? 'Elemento',
                                            rel.relationType,
                                          );
                                      ref.invalidate(entityRelationsProvider(entity.id));
                                    },
                                  ),
                                  onTap: () {
                                    context.push('/entity/$otherId');
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error al cargar elemento: $err')),
      ),
    );
  }
}
