import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../../locations/domain/location_node.dart';
import '../../locations/infrastructure/location_repository.dart';

/// Unified navigation bar for the inventory.
/// Integrates location breadcrumbs, drill-down container ancestry, spring-loaded navigation,
/// an expandable location tree curtain, and the active container hero tile.
class InventoryBreadcrumbBar extends ConsumerStatefulWidget {
  final List<LocationNode> allLocations;
  final String? selectedLocationId;
  final List<String> containerPath;
  final Map<String, CatalogItem> catalogMap;
  final Map<String, WorldEntity> allEntitiesMap;
  final ValueChanged<String?> onLocationSelected;
  final Function(Object payload, String? targetLocationId) onDropOnLocation;
  final Function(Object payload, String targetContainerEntityId) onDropIntoContainer;
  final Function(int targetContainerIndex) onNavigateToContainerIndex;
  final VoidCallback onExitContainersToRoot;
  final bool initiallyExpanded;

  const InventoryBreadcrumbBar({
    super.key,
    required this.allLocations,
    required this.selectedLocationId,
    required this.containerPath,
    required this.catalogMap,
    required this.allEntitiesMap,
    required this.onLocationSelected,
    required this.onDropOnLocation,
    required this.onDropIntoContainer,
    required this.onNavigateToContainerIndex,
    required this.onExitContainersToRoot,
    this.initiallyExpanded = false,
  });

  @override
  ConsumerState<InventoryBreadcrumbBar> createState() => _InventoryBreadcrumbBarState();
}

class _InventoryBreadcrumbBarState extends ConsumerState<InventoryBreadcrumbBar> with SingleTickerProviderStateMixin {
  late AnimationController _curtainController;
  late Animation<double> _curtainAnimation;
  bool _isCurtainExpanded = false;

  @override
  void initState() {
    super.initState();
    _isCurtainExpanded = widget.initiallyExpanded;
    _curtainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: widget.initiallyExpanded ? 1.0 : 0.0,
    );
    _curtainAnimation = CurvedAnimation(
      parent: _curtainController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _curtainController.dispose();
    super.dispose();
  }

  void _toggleCurtain() {
    setState(() {
      _isCurtainExpanded = !_isCurtainExpanded;
      if (_isCurtainExpanded) {
        _curtainController.forward();
      } else {
        _curtainController.reverse();
      }
    });
  }

  void _showCreateLocationDialog(BuildContext context, {String? parentId}) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(parentId == null ? AppStrings.newLocationTitle : AppStrings.newSubLocationTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: AppStrings.locationNameLabel,
                prefixIcon: Icon(Icons.account_tree_outlined),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.locationDescriptionLabel,
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
          ],
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
                description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
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

  List<LocationNode> _buildLocationAncestry() {
    if (widget.selectedLocationId == null || widget.selectedLocationId == '__UNASSIGNED__') {
      return [];
    }
    final locMap = {for (var l in widget.allLocations) l.id: l};
    final ancestry = <LocationNode>[];
    String? currId = widget.selectedLocationId;
    while (currId != null && locMap.containsKey(currId)) {
      final node = locMap[currId]!;
      ancestry.insert(0, node);
      currId = node.parentLocationId;
    }
    return ancestry;
  }

  Widget _buildTreeItem(LocationNode node, int depth) {
    final children = widget.allLocations.where((l) => l.parentLocationId == node.id).toList();
    final isSelected = node.id == widget.selectedLocationId;
    final theme = Theme.of(context);

    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        widget.onDropOnLocation(details.data, node.id);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: depth * 16.0, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: isHovered
                    ? theme.colorScheme.primaryContainer
                    : (isSelected ? theme.colorScheme.primary.withAlpha(30) : null),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  children.isNotEmpty ? Icons.folder_outlined : Icons.location_on_outlined,
                  color: isSelected ? theme.colorScheme.primary : Colors.grey,
                ),
                title: Text(
                  node.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.primary : null,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                  tooltip: AppStrings.newSubLocationTitle,
                  onPressed: () => _showCreateLocationDialog(context, parentId: node.id),
                ),
                onTap: () {
                  widget.onLocationSelected(node.id);
                  _toggleCurtain();
                },
              ),
            ),
            if (children.isNotEmpty)
              ...children.map((child) => _buildTreeItem(child, depth + 1)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInsideContainer = widget.containerPath.isNotEmpty;
    final locationAncestry = _buildLocationAncestry();
    final rootLocations = widget.allLocations.where((l) => l.parentLocationId == null).toList();

    final WorldEntity? activeContainerEntity = isInsideContainer
        ? widget.allEntitiesMap[widget.containerPath.last]
        : null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Unified Breadcrumb Route Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Row(
              children: [
                // Horizontal scrollable breadcrumbs path
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Root location chip
                        _SpringLoadedBreadcrumbChip(
                          label: widget.selectedLocationId == null
                              ? AppStrings.all
                              : (widget.selectedLocationId == '__UNASSIGNED__'
                                  ? AppStrings.badgeOrphan
                                  : (locationAncestry.isNotEmpty ? locationAncestry.first.name : AppStrings.all)),
                          icon: Icons.home_outlined,
                          isHighlighted: !isInsideContainer && locationAncestry.length <= 1,
                          onTap: () {
                            if (isInsideContainer) {
                              widget.onExitContainersToRoot();
                            } else if (locationAncestry.isNotEmpty && locationAncestry.length > 1) {
                              widget.onLocationSelected(locationAncestry.first.id);
                            } else {
                              _toggleCurtain();
                            }
                          },
                          onSpringLoad: () {
                            if (isInsideContainer) {
                              widget.onExitContainersToRoot();
                            } else if (locationAncestry.isNotEmpty && locationAncestry.length > 1) {
                              widget.onLocationSelected(locationAncestry.first.id);
                            }
                          },
                          onDrop: (payload) {
                            if (isInsideContainer) {
                              widget.onDropOnLocation(payload, widget.selectedLocationId);
                            } else if (locationAncestry.isNotEmpty) {
                              widget.onDropOnLocation(payload, locationAncestry.first.id);
                            } else {
                              widget.onDropOnLocation(payload, null);
                            }
                          },
                        ),

                        // Intermediate location ancestry
                        for (int i = 1; i < locationAncestry.length; i++) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                          ),
                          _SpringLoadedBreadcrumbChip(
                            label: locationAncestry[i].name,
                            icon: Icons.location_on_outlined,
                            isHighlighted: !isInsideContainer && i == locationAncestry.length - 1,
                            onTap: () {
                              if (isInsideContainer) widget.onExitContainersToRoot();
                              widget.onLocationSelected(locationAncestry[i].id);
                            },
                            onSpringLoad: () {
                              if (isInsideContainer) widget.onExitContainersToRoot();
                              widget.onLocationSelected(locationAncestry[i].id);
                            },
                            onDrop: (payload) {
                              widget.onDropOnLocation(payload, locationAncestry[i].id);
                            },
                          ),
                        ],

                        // Container Path Segments
                        for (int i = 0; i < widget.containerPath.length; i++) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                          ),
                          Builder(
                            builder: (context) {
                              final cId = widget.containerPath[i];
                              final isCurrent = i == widget.containerPath.length - 1;
                              final cEnt = widget.allEntitiesMap[cId];
                              final cSpecies = widget.catalogMap[cEnt?.speciesId];
                              final cTitle = cSpecies?.name ?? 'Contenedor';

                              return _SpringLoadedBreadcrumbChip(
                                label: cTitle,
                                icon: Icons.inventory_2_outlined,
                                isHighlighted: isCurrent,
                                onTap: () {
                                  if (!isCurrent) {
                                    widget.onNavigateToContainerIndex(i);
                                  }
                                },
                                onSpringLoad: () {
                                  if (!isCurrent) {
                                    widget.onNavigateToContainerIndex(i);
                                  }
                                },
                                onDrop: (payload) {
                                  widget.onDropIntoContainer(payload, cId);
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Location Curtain toggle button
                IconButton(
                  icon: AnimatedRotation(
                    turns: _isCurtainExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, size: 20),
                  ),
                  tooltip: 'Desplegar ubicaciones',
                  visualDensity: VisualDensity.compact,
                  onPressed: _toggleCurtain,
                ),

                // Create Location Shortcut
                IconButton(
                  icon: const Icon(Icons.add_location_alt_outlined, size: 20),
                  tooltip: AppStrings.newLocationTitle,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _showCreateLocationDialog(context),
                ),

                // Exit container button (if inside container)
                if (isInsideContainer)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: 'Salir a la raíz',
                    visualDensity: VisualDensity.compact,
                    onPressed: widget.onExitContainersToRoot,
                  ),
              ],
            ),
          ),

          // 2. Expandable Location Tree Curtain
          SizeTransition(
            sizeFactor: _curtainAnimation,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 280),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                border: Border(bottom: BorderSide(color: theme.dividerColor.withAlpha(40))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: const Icon(Icons.all_inbox_outlined),
                      title: const Text(AppStrings.all, style: TextStyle(fontWeight: FontWeight.bold)),
                      selected: widget.selectedLocationId == null,
                      onTap: () {
                        if (isInsideContainer) widget.onExitContainersToRoot();
                        widget.onLocationSelected(null);
                        _toggleCurtain();
                      },
                    ),
                    const Divider(height: 1),
                    ...rootLocations.map((root) => _buildTreeItem(root, 0)),
                  ],
                ),
              ),
            ),
          ),

          // 3. Active Container Hero Tile (when inside a container)
          if (isInsideContainer && activeContainerEntity != null)
            DragTarget<Object>(
              onWillAcceptWithDetails: (details) => true,
              onAcceptWithDetails: (details) {
                widget.onDropIntoContainer(details.data, activeContainerEntity.id);
              },
              builder: (context, candidateData, rejectedData) {
                final isHovered = candidateData.isNotEmpty;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? theme.colorScheme.primaryContainer.withAlpha(150)
                        : theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isHovered ? theme.colorScheme.primary : theme.colorScheme.primary.withAlpha(60),
                      width: isHovered ? 2.0 : 1.2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: InstancePreviewCard(
                    entity: activeContainerEntity,
                    onTap: () => context.pushEntityDetail(activeContainerEntity.id),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app, size: 12, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Ver Ficha',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Spring-loaded interactive breadcrumb chip with DragTarget and 600ms hover timer.
class _SpringLoadedBreadcrumbChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isHighlighted;
  final VoidCallback onTap;
  final VoidCallback onSpringLoad;
  final Function(Object payload) onDrop;

  const _SpringLoadedBreadcrumbChip({
    required this.label,
    required this.icon,
    required this.isHighlighted,
    required this.onTap,
    required this.onSpringLoad,
    required this.onDrop,
  });

  @override
  State<_SpringLoadedBreadcrumbChip> createState() => _SpringLoadedBreadcrumbChipState();
}

class _SpringLoadedBreadcrumbChipState extends State<_SpringLoadedBreadcrumbChip> {
  Timer? _springLoadTimer;

  @override
  void dispose() {
    _springLoadTimer?.cancel();
    super.dispose();
  }

  void _cancelTimer() {
    _springLoadTimer?.cancel();
    _springLoadTimer = null;
  }

  void _startTimer() {
    if (_springLoadTimer != null) return;
    _springLoadTimer = Timer(const Duration(milliseconds: 600), () {
      _springLoadTimer = null;
      if (mounted) {
        widget.onSpringLoad();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) => true,
      onMove: (details) => _startTimer(),
      onLeave: (data) => _cancelTimer(),
      onAcceptWithDetails: (details) {
        _cancelTimer();
        widget.onDrop(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isHovered
                  ? theme.colorScheme.primaryContainer
                  : (widget.isHighlighted
                      ? theme.colorScheme.primary.withAlpha(25)
                      : theme.colorScheme.surfaceContainerHighest.withAlpha(90)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHovered
                    ? theme.colorScheme.primary
                    : (widget.isHighlighted
                        ? theme.colorScheme.primary.withAlpha(120)
                        : theme.dividerColor.withAlpha(50)),
                width: (isHovered || widget.isHighlighted) ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 13,
                  color: (widget.isHighlighted || isHovered)
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: (widget.isHighlighted || isHovered) ? FontWeight.bold : FontWeight.w500,
                    color: (widget.isHighlighted || isHovered)
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
