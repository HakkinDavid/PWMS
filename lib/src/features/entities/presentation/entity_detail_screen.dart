import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_detail_view.dart';
import '../domain/entity_template.dart';
import 'edit_entity_sheet.dart';

class EntityDetailScreen extends ConsumerWidget {
  final String entityId;

  const EntityDetailScreen({super.key, required this.entityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityAsync = ref.watch(entityDetailProvider(entityId));
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: entityAsync.when(
        data: (entity) {
          if (entity == null) {
            return const Center(child: Text(AppStrings.appName));
          }

          final catalogItems = catalogState.asData?.value ?? [];
          final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull ??
              CatalogItem(
                id: entity.speciesId,
                name: AppStrings.typeObject,
                type: AppStrings.typeObject,
                createdAt: DateTime.now(),
              );

          final template = EntityTemplateRegistry.getTemplate(species.type);

          String locationName = AppStrings.rootLocationName;
          if (entity.locationId != null) {
            locationsState.whenData((nodes) {
              final found = nodes.where((n) => n.id == entity.locationId).firstOrNull;
              if (found != null) locationName = found.name;
            });
          }

          // Instance-specific Header (Location card & Quantity controls)
          final instanceHeader = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quantity controls if template allows quantity
              if (template.hasQuantity) ...[
                Row(
                  children: [
                    Text(
                      AppStrings.quantityLabel,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.secondary.withAlpha(80)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            onPressed: () async {
                              final currentQty = entity.quantity ?? 1.0;
                              final newQty = currentQty - 1.0;
                              if (newQty <= 0) {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text(AppStrings.deleteConfirmationTitle),
                                    content: Text('${AppStrings.zeroQuantityMessage} "${species.name}"?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        child: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
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
                            '${entity.quantity ?? 1.0} ${entity.unit ?? species.defaultUnit ?? ""}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
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
                const SizedBox(height: 16),
              ],

              // Location Node Card
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
                              AppStrings.locationGraphNode,
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
            ],
          );

          // Instance-specific Footer (Notes / Serial)
          final instanceFooter = (entity.notes != null && entity.notes!.isNotEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.notesLabel, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(entity.notes!, style: theme.textTheme.bodyMedium),
                  ],
                )
              : null;

          return SpeciesDetailView(
            species: species,
            instanceSpecificsHeader: instanceHeader,
            instanceSpecificsFooter: instanceFooter,
            actions: [
              IconButton(
                icon: Icon(entity.isArchived ? Icons.unarchive : Icons.archive_outlined),
                onPressed: () async {
                  final updated = entity.copyWith(isArchived: !entity.isArchived, updatedAt: DateTime.now());
                  await ref.read(entityListProvider.notifier).saveEntity(updated);
                },
                tooltip: entity.isArchived ? AppStrings.unarchive : AppStrings.archive,
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => EditEntitySheet.show(context, entity),
                tooltip: AppStrings.edit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text(AppStrings.deleteConfirmationTitle),
                      content: Text('${AppStrings.deleteConfirmationMessage} "${species.name}"?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
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
                    }
                  }
                },
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
