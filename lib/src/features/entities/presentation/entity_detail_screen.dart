import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../domain/attachment.dart';
import '../domain/entity_template.dart';
import '../domain/world_entity.dart';
import 'edit_entity_sheet.dart';
import '../../relations/presentation/add_relation_sheet.dart';

class EntityDetailScreen extends ConsumerStatefulWidget {
  final String entityId;

  const EntityDetailScreen({super.key, required this.entityId});

  @override
  ConsumerState<EntityDetailScreen> createState() => _EntityDetailScreenState();
}

class _EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
  Future<void> _pickAndAddDocument(WorldEntity entity) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final storage = ref.read(fileStorageServiceProvider);
      final savedRelativePath = await storage.saveFile(file.path!);

      final attachment = Attachment(
        id: const Uuid().v4(),
        entityId: entity.id,
        filePath: savedRelativePath,
        fileName: file.name,
        fileType: file.extension ?? 'doc',
        createdAt: DateTime.now(),
      );

      await ref.read(entityRepositoryProvider).addAttachment(attachment);
      ref.invalidate(entityAttachmentsProvider(entity.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final entityAsync = ref.watch(entityDetailProvider(widget.entityId));
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: entityAsync.when(
        data: (entity) {
          if (entity == null) {
            return const Center(child: Text('Elemento no encontrado en tu mundo'));
          }

          final catalogItems = catalogState.asData?.value ?? [];
          final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull ??
              CatalogItem(
                id: entity.speciesId,
                name: 'Objeto Instanciado',
                type: 'Objeto / Herramienta',
                createdAt: DateTime.now(),
              );

          final template = EntityTemplateRegistry.getTemplate(species.type);

          String locationName = 'Mundo (Raíz)';
          if (entity.locationId != null) {
            locationsState.whenData((nodes) {
              final found = nodes.where((n) => n.id == entity.locationId).firstOrNull;
              if (found != null) locationName = found.name;
            });
          }

          final attachmentsAsync = ref.watch(entityAttachmentsProvider(entity.id));

          return CustomScrollView(
            slivers: [
              // Hero Photo / Header
              SliverAppBar(
                expandedHeight: 260.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    species.name,
                    style: const TextStyle(
                      shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                    ),
                  ),
                  background: FutureBuilder<String>(
                    future: species.mainPhotoPath != null
                        ? ref.read(fileStorageServiceProvider).getAbsolutePath(species.mainPhotoPath!)
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
                          content: Text('¿Seguro que deseas eliminar "${species.name}"?'),
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
                        await ref.read(activityLoggerServiceProvider).logEntityDeleted(entity.id, species.name);
                        ref.read(entityListProvider.notifier).loadEntities();

                        if (context.mounted) {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('"${species.name}" eliminado de tu mundo')),
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
                      // Concept Badge, Barcode & Quantity Controls
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
                                  species.type,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (species.barcode != null && species.barcode!.isNotEmpty)
                            Chip(
                              avatar: const Icon(Icons.qr_code_scanner, size: 14),
                              label: Text(species.barcode!),
                            ),
                          if (template.hasQuantity)
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
                                      final newQty = currentQty - 1.0;
                                      if (newQty <= 0) {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('¿Eliminar elemento?'),
                                            content: Text('La cantidad llegó a 0. ¿Deseas eliminar "${species.name}"?'),
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
                                          ref.read(entityListProvider.notifier).loadEntities();
                                          if (context.mounted) context.pop();
                                        }
                                      } else {
                                        final updated = entity.copyWith(quantity: newQty, updatedAt: DateTime.now());
                                        await ref.read(entityListProvider.notifier).saveEntity(updated);
                                      }
                                    },
                                  ),
                                  Text(
                                    '${entity.quantity ?? 1.0} ${entity.unit ?? species.defaultUnit ?? "unidades"}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.secondary,
                                      fontSize: 13,
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
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Location Node in Location Graph
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
                                child: const Icon(Icons.account_tree_outlined, color: Colors.amber),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ubicación en el Grafo',
                                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                                    ),
                                    Text(
                                      locationName,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Notes / Custom Serial
                      if (entity.notes != null && entity.notes!.isNotEmpty) ...[
                        Text('Notas / Número de Serie', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(entity.notes!, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 24),
                      ],

                      // Description from Catalog
                      if (species.description != null && species.description!.isNotEmpty) ...[
                        Text('Descripción del Objeto Maestro', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(species.description!, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 24),
                      ],

                      // Quick Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => AddRelationSheet.show(context, entity),
                              icon: const Icon(Icons.link),
                              label: const Text('Relacionar'),
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _pickAndAddDocument(entity),
                              icon: const Icon(Icons.attach_file),
                              label: const Text('Adjuntar Archivo'),
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Attachments
                      Text('Archivos y Fotografías Adjuntas', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      attachmentsAsync.when(
                        data: (attachments) {
                          if (attachments.isEmpty) {
                            return const Text('Sin archivos adjuntos.', style: TextStyle(color: Colors.grey));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: attachments.length,
                            itemBuilder: (context, idx) {
                              final att = attachments[idx];
                              return ListTile(
                                leading: Icon(att.fileType == 'image' ? Icons.image : Icons.picture_as_pdf),
                                title: Text(att.fileName),
                                trailing: IconButton(
                                  icon: const Icon(Icons.open_in_new),
                                  onPressed: () async {
                                    final path = await ref.read(fileStorageServiceProvider).getAbsolutePath(att.filePath);
                                    await OpenFile.open(path);
                                  },
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => Text('Error: $err'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
      ),
    );
  }
}
