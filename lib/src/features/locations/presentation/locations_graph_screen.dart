import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/create_entity_sheet.dart';
import '../domain/location_node.dart';

class LocationsGraphScreen extends ConsumerWidget {
  const LocationsGraphScreen({super.key});

  void _showCreateNodeModal(BuildContext context, WidgetRef ref, {String? parentId}) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                parentId == null ? AppStrings.newLocationTitle : AppStrings.newSubLocationTitle,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: AppStrings.locationNameLabel,
                  prefixIcon: Icon(Icons.account_tree_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: AppStrings.locationDescriptionLabel,
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;

                    final node = LocationNode(
                      id: const Uuid().v4(),
                      name: name,
                      parentLocationId: parentId,
                      description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
                      createdAt: DateTime.now(),
                    );

                    await ref.read(locationNodeListProvider.notifier).saveNode(node);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(AppStrings.save, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTreeTile(BuildContext context, WidgetRef ref, LocationNode node, List<LocationNode> allNodes, int depth) {
    final children = allNodes.where((n) => n.parentLocationId == node.id).toList();
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    int count = 0;
    entitiesState.whenData((entities) {
      count = entities.where((e) => e.locationId == node.id).length;
    });

    return Card(
      margin: EdgeInsets.only(left: 12.0 * depth, bottom: 8.0),
      child: ExpansionTile(
        key: ValueKey(node.id),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondary.withAlpha(30),
          child: Icon(children.isNotEmpty ? Icons.folder : Icons.location_on, color: theme.colorScheme.secondary),
        ),
        title: Text(node.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$count objetos almacenados'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add_location_alt_outlined),
              tooltip: AppStrings.newSubLocationTitle,
              onPressed: () => _showCreateNodeModal(context, ref, parentId: node.id),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: AppStrings.createObjectHere,
              onPressed: () {
                CreateEntitySheet.show(context, initialLocationId: node.id);
              },
            ),
          ],
        ),
        children: [
          if (children.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                children: children.map((c) => _buildTreeTile(context, ref, c, allNodes, depth + 1)).toList(),
              ),
            ),

          // Items inside this node
          ListTile(
            title: Text(AppStrings.storedObjectsTitle, style: theme.textTheme.labelLarge),
            trailing: TextButton.icon(
              onPressed: () => CreateEntitySheet.show(context, initialLocationId: node.id),
              icon: const Icon(Icons.add, size: 16),
              label: const Text(AppStrings.createObjectHere),
            ),
          ),
          entitiesState.when(
            data: (entities) {
              final nodeEntities = entities.where((e) => e.locationId == node.id).toList();
              if (nodeEntities.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(AppStrings.emptyLocation, style: TextStyle(color: Colors.grey)),
                );
              }

              final catalogItems = catalogState.asData?.value ?? [];

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: nodeEntities.length,
                itemBuilder: (ctx, i) {
                  final ent = nodeEntities[i];
                  final species = catalogItems.where((c) => c.id == ent.speciesId).firstOrNull;
                  final name = species?.name ?? 'Objeto';

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    leading: const Icon(Icons.inventory_2_outlined, size: 20),
                    title: Text(name),
                    subtitle: Text('Cantidad: ${ent.quantity ?? 1} ${ent.unit ?? ""}'),
                    onTap: () => context.push('/entity/${ent.id}'),
                  );
                },
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.locationsGraphTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateNodeModal(context, ref),
        icon: const Icon(Icons.add_location_alt),
        label: const Text(AppStrings.newLocationTitle),
      ),
      body: nodesState.when(
        data: (nodes) {
          final rootNodes = nodes.where((n) => n.parentLocationId == null).toList();
          if (rootNodes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_tree_outlined, size: 64, color: theme.colorScheme.primary.withAlpha(120)),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.emptyLocation,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rootNodes.length,
            itemBuilder: (context, index) {
              return _buildTreeTile(context, ref, rootNodes[index], nodes, 0);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
