import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/location_node.dart';

class LocationPickerResult {
  final String? locationId;
  const LocationPickerResult(this.locationId);
}

class LocationTreePicker extends ConsumerStatefulWidget {
  final String? initialSelectedId;
  final String? movingNodeId; // Node being moved (for cycle prevention)
  final ValueChanged<LocationPickerResult> onSelected;

  const LocationTreePicker({
    super.key,
    this.initialSelectedId,
    this.movingNodeId,
    required this.onSelected,
  });

  static Future<LocationPickerResult?> show(
    BuildContext context, {
    String? initialSelectedId,
    String? movingNodeId,
  }) {
    return showModalBottomSheet<LocationPickerResult?>(
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
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.65,
            child: LocationTreePicker(
              initialSelectedId: initialSelectedId,
              movingNodeId: movingNodeId,
              onSelected: (result) {
                Navigator.pop(ctx, result);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  ConsumerState<LocationTreePicker> createState() => _LocationTreePickerState();
}

class _LocationTreePickerState extends ConsumerState<LocationTreePicker> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialSelectedId;
  }

  void _showAddSubLocationDialog(BuildContext context, String? parentId) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(parentId == null ? AppStrings.newLocationTitle : AppStrings.newSubLocationTitle),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: AppStrings.locationNameLabel),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final newNode = LocationNode(
                id: const Uuid().v4(),
                name: name,
                parentLocationId: parentId,
                createdAt: DateTime.now(),
              );
              await ref.read(locationNodeListProvider.notifier).saveNode(newNode);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeNode(LocationNode node, List<LocationNode> allNodes, int depth) {
    final locationRepo = ref.read(locationRepositoryProvider);
    final bool canSelect = widget.movingNodeId == null ||
        locationRepo.canMoveNode(widget.movingNodeId!, node.id, allNodes);

    final children = allNodes.where((n) => n.parentLocationId == node.id).toList();
    final isSelected = _selectedId == node.id;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: canSelect
              ? () {
                  setState(() => _selectedId = node.id);
                  widget.onSelected(LocationPickerResult(node.id));
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.only(left: 12.0 * depth + 8.0, right: 8.0, top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary.withAlpha(40) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  children.isNotEmpty ? Icons.folder_open : Icons.location_on_outlined,
                  size: 20,
                  color: canSelect
                      ? (isSelected ? theme.colorScheme.primary : theme.iconTheme.color)
                      : Colors.grey.withAlpha(100),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    node.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: canSelect
                          ? (isSelected ? theme.colorScheme.primary : null)
                          : Colors.grey,
                    ),
                  ),
                ),
                if (canSelect)
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    tooltip: AppStrings.newSubLocationTitle,
                    onPressed: () => _showAddSubLocationDialog(context, node.id),
                  ),
              ],
            ),
          ),
        ),
        if (children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              children: children.map((child) => _buildTreeNode(child, allNodes, depth + 1)).toList(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final nodesState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.selectLocationPrompt,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_location_alt_outlined),
              tooltip: AppStrings.newLocationTitle,
              onPressed: () => _showAddSubLocationDialog(context, null),
            ),
          ],
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.public),
          title: const Text(
            AppStrings.rootLocationName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          selected: _selectedId == null,
          onTap: () {
            setState(() => _selectedId = null);
            widget.onSelected(const LocationPickerResult(null));
          },
        ),
        const Divider(),
        Expanded(
          child: nodesState.when(
            data: (nodes) {
              final rootNodes = nodes.where((n) => n.parentLocationId == null).toList();
              if (rootNodes.isEmpty) {
                return const Center(child: Text(AppStrings.emptyLocation));
              }
              return ListView.builder(
                itemCount: rootNodes.length,
                itemBuilder: (context, idx) {
                  return _buildTreeNode(rootNodes[idx], nodes, 0);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('${AppStrings.errorPrefix}$err')),
          ),
        ),
      ],
    );
  }
}
