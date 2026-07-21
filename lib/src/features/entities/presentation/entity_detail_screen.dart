import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../domain/attachment.dart';
import '../domain/world_entity.dart';
import '../../places/presentation/move_entity_sheet.dart';
import '../../relations/presentation/add_relation_sheet.dart';

class EntityDetailScreen extends ConsumerStatefulWidget {
  final String entityId;

  const EntityDetailScreen({super.key, required this.entityId});

  @override
  ConsumerState<EntityDetailScreen> createState() => _EntityDetailScreenState();
}

class _EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
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

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'herramienta':
        return Icons.build;
      case 'caja / contenedor':
      case 'caja':
        return Icons.inventory_2;
      case 'documento':
        return Icons.description;
      case 'vehículo':
        return Icons.directions_car;
      case 'animal':
        return Icons.pets;
      case 'proyecto':
        return Icons.work;
      case 'idea':
        return Icons.lightbulb;
      case 'recuerdo':
        return Icons.star;
      case 'lugar':
        return Icons.place;
      default:
        return Icons.category;
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
                        return Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.cover,
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
                            _getTypeIcon(entity.type),
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
                        await ref.read(entityListProvider.notifier).deleteEntity(entity.id);
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
                      // Concept Badge & Location Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(40),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.colorScheme.primary.withAlpha(100)),
                            ),
                            child: Row(
                              children: [
                                Icon(_getTypeIcon(entity.type), size: 16, color: theme.colorScheme.primary),
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
                          const Spacer(),
                          Text(
                            'Creado: ${DateFormat('dd/MM/yyyy').format(entity.createdAt)}',
                            style: theme.textTheme.bodyMedium,
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

                      // Attachments Gallery
                      Text('Fotografías y Archivos', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      attachmentsAsync.when(
                        data: (attachments) {
                          if (attachments.isEmpty) {
                            return Text('Sin archivos adjuntos aún.', style: theme.textTheme.bodyMedium);
                          }
                          return SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: attachments.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final att = attachments[index];
                                return FutureBuilder<String>(
                                  future: ref.read(fileStorageServiceProvider).getAbsolutePath(att.filePath),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && att.fileType == 'image' && File(snapshot.data!).existsSync()) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.file(
                                          File(snapshot.data!),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: theme.dividerColor),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.insert_drive_file, size: 32),
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

                      // Linked Relations section
                      Text('Relaciones en tu Mundo', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      relationsAsync.when(
                        data: (relations) {
                          if (relations.isEmpty) {
                            return Text('No se han registrado relaciones con otros elementos.', style: theme.textTheme.bodyMedium);
                          }
                          return Column(
                            children: relations.map((rel) {
                              final otherId = rel.sourceEntityId == entity.id ? rel.targetEntityId : rel.sourceEntityId;
                              final otherEntityAsync = ref.watch(entityDetailProvider(otherId));

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.link, color: Colors.indigoAccent),
                                  title: Text(rel.relationType),
                                  subtitle: otherEntityAsync.when(
                                    data: (other) => Text(other?.name ?? 'Elemento desconocido'),
                                    loading: () => const Text('Cargando...'),
                                    error: (_, __) => const Text('Error'),
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
