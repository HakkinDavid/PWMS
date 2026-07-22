import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/register_object_modal.dart';
import '../../entities/presentation/entity_tile.dart';
import '../domain/location_node.dart';
import '../infrastructure/location_repository.dart';
import 'location_tree_picker.dart';
import 'visual_locations_graph.dart';

class LocationsGraphScreen extends ConsumerStatefulWidget {
  final String? focusNodeId;

  const LocationsGraphScreen({
    super.key,
    this.focusNodeId,
  });

  @override
  ConsumerState<LocationsGraphScreen> createState() => _LocationsGraphScreenState();
}

class _LocationsGraphScreenState extends ConsumerState<LocationsGraphScreen> {
  bool _isVisualGraphView = true;

  void _showCreateNodeModal(BuildContext context, {String? parentId}) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
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

  void _reparentLocationNode(BuildContext context, LocationNode node) async {
    final result = await LocationTreePicker.show(
      context,
      initialSelectedId: node.parentLocationId,
      movingNodeId: node.id,
    );
    if (result == null) return;
    final newParentId = result.locationId;
    if (newParentId == node.id || newParentId == node.parentLocationId) return;

    await ref.read(locationRepositoryProvider).moveNode(node.id, newParentId);
    ref.read(locationNodeListProvider.notifier).loadNodes();
  }

  void _showLocationContextMenu(BuildContext context, LocationNode node) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Instanciar objeto aquí'),
              onTap: () {
                Navigator.pop(ctx);
                RegisterObjectModal.show(context, initialLocationId: node.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_location_alt_outlined),
              title: const Text(AppStrings.newSubLocationTitle),
              onTap: () {
                Navigator.pop(ctx);
                _showCreateNodeModal(context, parentId: node.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move_outlined),
              title: const Text(AppStrings.move),
              onTap: () {
                Navigator.pop(ctx);
                _reparentLocationNode(context, node);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                Navigator.pop(ctx);
                await ref.read(locationNodeListProvider.notifier).deleteNode(node.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  int _getRecursiveItemCount(LocationNode node, List<LocationNode> allNodes, List<WorldEntity> entities) {
    return LocationRepository.getRecursiveItemCount(node.id, allNodes, entities);
  }

  Widget _buildTreeTile(BuildContext context, LocationNode node, List<LocationNode> allNodes, int depth) {
    final children = allNodes.where((n) => n.parentLocationId == node.id).toList();
    final entitiesState = ref.watch(entityListProvider);
    final theme = Theme.of(context);
    final isFocused = node.id == widget.focusNodeId;

    int totalCount = 0;
    entitiesState.whenData((entities) {
      totalCount = _getRecursiveItemCount(node, allNodes, entities);
    });

    return Card(
      margin: EdgeInsets.only(left: 12.0 * depth, bottom: 8.0),
      color: isFocused ? theme.colorScheme.primary.withAlpha(20) : null,
      child: InkWell(
        onLongPress: () => _showLocationContextMenu(context, node),
        child: ExpansionTile(
          key: ValueKey(node.id),
          initiallyExpanded: isFocused || (widget.focusNodeId != null && ref.read(locationRepositoryProvider).getDescendantIds(node.id, allNodes).contains(widget.focusNodeId)),
          leading: CircleAvatar(
            backgroundColor: isFocused ? theme.colorScheme.primary : theme.colorScheme.secondary.withAlpha(30),
            child: Icon(
              children.isNotEmpty ? Icons.folder : Icons.location_on,
              color: isFocused ? Colors.white : theme.colorScheme.secondary,
            ),
          ),
          title: Text(node.name, style: TextStyle(fontWeight: FontWeight.bold, color: isFocused ? theme.colorScheme.primary : null)),
          subtitle: Text('$totalCount objetos en esta ubicación e hijas'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.drive_file_move_outlined, size: 20),
                tooltip: AppStrings.move,
                onPressed: () => _reparentLocationNode(context, node),
              ),
              IconButton(
                icon: const Icon(Icons.add_location_alt_outlined, size: 20),
                tooltip: AppStrings.newSubLocationTitle,
                onPressed: () => _showCreateNodeModal(context, parentId: node.id),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                tooltip: AppStrings.createObjectHere,
                onPressed: () {
                  RegisterObjectModal.show(context, initialLocationId: node.id);
                },
              ),
            ],
          ),
          children: [
            if (children.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(AppStrings.childLocationsTitle, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Column(
                  children: children.map((c) => _buildTreeTile(context, c, allNodes, depth + 1)).toList(),
                ),
              ),
            ],

            ListTile(
              title: Text(AppStrings.storedObjectsTitle, style: theme.textTheme.labelLarge),
              trailing: IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () => RegisterObjectModal.show(context, initialLocationId: node.id),
                tooltip: AppStrings.createObjectHere,
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

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: nodeEntities.length,
                  itemBuilder: (ctx, i) {
                    return EntityTile(entity: nodeEntities[i]);
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nodesState = ref.watch(locationNodeListProvider);
    final entitiesState = ref.watch(entityListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.locationsGraphTitle),
        actions: [
          IconButton(
            icon: Icon(_isVisualGraphView ? Icons.account_tree_outlined : Icons.bubble_chart_outlined),
            tooltip: _isVisualGraphView ? 'Vista de Árbol' : 'Vista de Grafo',
            onPressed: () {
              setState(() => _isVisualGraphView = !_isVisualGraphView);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_locations',
        onPressed: () => _showCreateNodeModal(context),
        tooltip: AppStrings.newLocationTitle,
        child: const Icon(Icons.add_location_alt),
      ),
      body: nodesState.when(
        data: (nodes) {
          if (nodes.isEmpty) {
            return const Center(child: Text(AppStrings.emptyLocation));
          }

          if (_isVisualGraphView) {
            final allEntities = entitiesState.asData?.value ?? [];
            return VisualLocationsGraph(
              nodes: nodes,
              entities: allEntities,
              focusNodeId: widget.focusNodeId,
              onNodeSelected: (node) {
                _showLocationContextMenu(context, node);
              },
            );
          }

          final rootNodes = nodes.where((n) => n.parentLocationId == null).toList();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rootNodes.length,
            itemBuilder: (context, index) {
              return _buildTreeTile(context, rootNodes[index], nodes, 0);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
