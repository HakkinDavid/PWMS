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
import '../../locations/domain/location_resolver.dart';
import '../../locations/infrastructure/location_repository.dart';
import '../../relations/domain/entity_relation.dart';

/// Unified navigation bar for the inventory.
/// Integrates full-width breadcrumbs (starting at Mundo), real physical path resolution,
/// spring-loaded horizontal autoscroll, spring-loaded chevron & tree nodes with chevrons,
/// top/bottom vertical autoscroll edge zones in the location tree curtain,
/// and borderless active container hero tile without "Ver Ficha" badge or X button.
class InventoryBreadcrumbBar extends ConsumerStatefulWidget {
  final List<LocationNode> allLocations;
  final String? selectedLocationId;
  final List<String> containerPath;
  final Map<String, CatalogItem> catalogMap;
  final Map<String, WorldEntity> allEntitiesMap;
  final List<EntityRelation> allRelations;
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
    this.allRelations = const [],
    required this.onLocationSelected,
    required this.onDropOnLocation,
    required this.onDropIntoContainer,
    required this.onNavigateToContainerIndex,
    required this.onExitContainersToRoot,
    this.initiallyExpanded = false,
  });

  @override
  ConsumerState<InventoryBreadcrumbBar> createState() => InventoryBreadcrumbBarState();
}

class InventoryBreadcrumbBarState extends ConsumerState<InventoryBreadcrumbBar> with SingleTickerProviderStateMixin {
  late AnimationController _curtainController;
  late Animation<double> _curtainAnimation;
  late ScrollController _breadcrumbScrollController;
  late ScrollController _treeScrollController;
  bool _isCurtainExpanded = false;

  final Set<String> _expandedLocationIds = {};
  Timer? _horizontalAutoScrollTimer;
  Timer? _treeAutoScrollTimer;
  Timer? _chevronSpringTimer;

  bool get isCurtainExpanded => _isCurtainExpanded;

  void collapseCurtain() => _collapseCurtain();

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
    _breadcrumbScrollController = ScrollController();
    _treeScrollController = ScrollController();
  }

  @override
  void dispose() {
    _curtainController.dispose();
    _breadcrumbScrollController.dispose();
    _treeScrollController.dispose();
    _horizontalAutoScrollTimer?.cancel();
    _treeAutoScrollTimer?.cancel();
    _chevronSpringTimer?.cancel();
    super.dispose();
  }

  void _stopHorizontalAutoScroll() {
    _horizontalAutoScrollTimer?.cancel();
    _horizontalAutoScrollTimer = null;
  }

  void _startHorizontalAutoScroll(double step) {
    if (_horizontalAutoScrollTimer != null && _horizontalAutoScrollTimer!.isActive) return;
    _horizontalAutoScrollTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      if (!_breadcrumbScrollController.hasClients) return;
      final target = (_breadcrumbScrollController.offset + step).clamp(
        0.0,
        _breadcrumbScrollController.position.maxScrollExtent,
      );
      _breadcrumbScrollController.jumpTo(target);
    });
  }

  void _stopTreeAutoScroll() {
    _treeAutoScrollTimer?.cancel();
    _treeAutoScrollTimer = null;
  }

  void _startTreeAutoScroll(double step) {
    if (_treeAutoScrollTimer != null && _treeAutoScrollTimer!.isActive) return;
    _treeAutoScrollTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      if (!_treeScrollController.hasClients) return;
      final target = (_treeScrollController.offset + step).clamp(
        0.0,
        _treeScrollController.position.maxScrollExtent,
      );
      _treeScrollController.jumpTo(target);
    });
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

  void _collapseCurtain() {
    if (_isCurtainExpanded) {
      setState(() {
        _isCurtainExpanded = false;
        _curtainController.reverse();
      });
    }
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

  /// Resolves the real physical location ancestry.
  /// If inside a container and selectedLocationId is null, resolves the container's physical location.
  List<LocationNode> _buildLocationAncestry() {
    String? targetLocId = widget.selectedLocationId;

    if (targetLocId == null && widget.containerPath.isNotEmpty) {
      final rootContainerId = widget.containerPath.first;
      final directLocations = {for (var e in widget.allEntitiesMap.values) e.id: e.locationId};
      targetLocId = LocationResolver.getEffectiveLocationId(
        entityId: rootContainerId,
        directLocations: directLocations,
        relations: widget.allRelations,
      );
    }

    if (targetLocId == null || targetLocId == '__UNASSIGNED__') {
      return [];
    }

    final locMap = {for (var l in widget.allLocations) l.id: l};
    final ancestry = <LocationNode>[];
    String? currId = targetLocId;
    while (currId != null && locMap.containsKey(currId)) {
      final node = locMap[currId]!;
      ancestry.insert(0, node);
      currId = node.parentLocationId;
    }
    return ancestry;
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

    final isRootWorldActive = !isInsideContainer && (widget.selectedLocationId == null);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Controls Top Bar (Chevron, Add Location)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Spring-Loaded Chevron to toggle location curtain
                DragTarget<Object>(
                  onWillAcceptWithDetails: (_) => true,
                  onMove: (_) {
                    if (!_isCurtainExpanded && _chevronSpringTimer == null) {
                      _chevronSpringTimer = Timer(const Duration(milliseconds: 600), () {
                        if (mounted && !_isCurtainExpanded) {
                          _toggleCurtain();
                        }
                      });
                    }
                  },
                  onLeave: (_) {
                    _chevronSpringTimer?.cancel();
                    _chevronSpringTimer = null;
                  },
                  onAcceptWithDetails: (_) {
                    _chevronSpringTimer?.cancel();
                    _chevronSpringTimer = null;
                    if (!_isCurtainExpanded) _toggleCurtain();
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isHovered = candidateData.isNotEmpty;
                    return InkWell(
                      onTap: _toggleCurtain,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isHovered
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_tree_outlined,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ubicaciones',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 2),
                            AnimatedRotation(
                              turns: _isCurtainExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(Icons.keyboard_arrow_down, size: 18, color: theme.colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Right action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_location_alt_outlined, size: 20),
                      tooltip: AppStrings.newLocationTitle,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _showCreateLocationDialog(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Full-Width Dedicated Breadcrumb Trail Row with Horizontal Edge Autoscroll
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _breadcrumbScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Root chip: Always Mundo
                      _SpringLoadedBreadcrumbChip(
                        label: AppStrings.rootLocationName,
                        icon: Icons.public,
                        isHighlighted: isRootWorldActive,
                        onTap: () {
                          if (isInsideContainer) {
                            widget.onExitContainersToRoot();
                          }
                          widget.onLocationSelected(null);
                        },
                        onSpringLoad: () {
                          if (isInsideContainer) {
                            widget.onExitContainersToRoot();
                          }
                          widget.onLocationSelected(null);
                        },
                        onDrop: (payload) {
                          widget.onDropOnLocation(payload, null);
                        },
                      ),

                      // Intermediate location ancestry (Real physical hierarchy)
                      for (int i = 0; i < locationAncestry.length; i++) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Icon(Icons.chevron_right, size: 16, color: Colors.grey),
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
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Icon(Icons.chevron_right, size: 16, color: Colors.grey),
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

                // Left horizontal autoscroll edge zone
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 32,
                  child: DragTarget<Object>(
                    onWillAcceptWithDetails: (_) => true,
                    onMove: (_) => _startHorizontalAutoScroll(-14.0),
                    onLeave: (_) => _stopHorizontalAutoScroll(),
                    onAcceptWithDetails: (_) => _stopHorizontalAutoScroll(),
                    builder: (context, candidateData, rejectedData) => const SizedBox.expand(),
                  ),
                ),

                // Right horizontal autoscroll edge zone
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 32,
                  child: DragTarget<Object>(
                    onWillAcceptWithDetails: (_) => true,
                    onMove: (_) => _startHorizontalAutoScroll(14.0),
                    onLeave: (_) => _stopHorizontalAutoScroll(),
                    onAcceptWithDetails: (_) => _stopHorizontalAutoScroll(),
                    builder: (context, candidateData, rejectedData) => const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),

          // 3. Expandable Location Tree Curtain with Top/Bottom Autoscroll Edge Zones
          SizeTransition(
            sizeFactor: _curtainAnimation,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 280),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                border: Border(bottom: BorderSide(color: theme.dividerColor.withAlpha(40))),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _treeScrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(Icons.public),
                          title: const Text(AppStrings.rootLocationName, style: TextStyle(fontWeight: FontWeight.bold)),
                          selected: isRootWorldActive,
                          onTap: () {
                            if (isInsideContainer) widget.onExitContainersToRoot();
                            widget.onLocationSelected(null);
                            _toggleCurtain();
                          },
                        ),
                        const Divider(height: 1),
                        ...rootLocations.map(
                          (root) => _TreeItemWidget(
                            key: ValueKey(root.id),
                            node: root,
                            depth: 0,
                            allLocations: widget.allLocations,
                            selectedLocationId: widget.selectedLocationId,
                            expandedLocationIds: _expandedLocationIds,
                            onToggleExpand: (locId) {
                              setState(() {
                                if (_expandedLocationIds.contains(locId)) {
                                  _expandedLocationIds.remove(locId);
                                } else {
                                  _expandedLocationIds.add(locId);
                                }
                              });
                            },
                            onSelect: (locId) {
                              widget.onLocationSelected(locId);
                              _toggleCurtain();
                            },
                            onDrop: (payload, locId) {
                              widget.onDropOnLocation(payload, locId);
                            },
                            onOpenAddDialog: (parentId) => _showCreateLocationDialog(context, parentId: parentId),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top Vertical Autoscroll Edge Zone (Height: 36)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 36,
                    child: DragTarget<Object>(
                      onWillAcceptWithDetails: (_) => true,
                      onMove: (_) => _startTreeAutoScroll(-14.0),
                      onLeave: (_) => _stopTreeAutoScroll(),
                      onAcceptWithDetails: (_) => _stopTreeAutoScroll(),
                      builder: (context, candidateData, rejectedData) => const SizedBox.expand(),
                    ),
                  ),

                  // Bottom Vertical Autoscroll Edge Zone (Height: 36)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 36,
                    child: DragTarget<Object>(
                      onWillAcceptWithDetails: (_) => true,
                      onMove: (_) => _startTreeAutoScroll(14.0),
                      onLeave: (_) => _stopTreeAutoScroll(),
                      onAcceptWithDetails: (_) => _stopTreeAutoScroll(),
                      builder: (context, candidateData, rejectedData) => const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Active Container Hero Tile (Direct InstancePreviewCard without outer outline frame or "Ver Ficha" badge)
          if (isInsideContainer && activeContainerEntity != null)
            DragTarget<Object>(
              onWillAcceptWithDetails: (details) => true,
              onAcceptWithDetails: (details) {
                widget.onDropIntoContainer(details.data, activeContainerEntity.id);
              },
              builder: (context, candidateData, rejectedData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  child: InstancePreviewCard(
                    entity: activeContainerEntity,
                    onTap: () => context.pushEntityDetail(activeContainerEntity.id),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Isolated tree item widget with its own spring-load hover timer.
/// DragTarget is strictly attached to this node row only, not enclosing children subtrees.
class _TreeItemWidget extends StatefulWidget {
  final LocationNode node;
  final int depth;
  final List<LocationNode> allLocations;
  final String? selectedLocationId;
  final Set<String> expandedLocationIds;
  final ValueChanged<String> onToggleExpand;
  final ValueChanged<String> onSelect;
  final Function(Object payload, String locationId) onDrop;
  final Function(String parentId) onOpenAddDialog;

  const _TreeItemWidget({
    super.key,
    required this.node,
    required this.depth,
    required this.allLocations,
    required this.selectedLocationId,
    required this.expandedLocationIds,
    required this.onToggleExpand,
    required this.onSelect,
    required this.onDrop,
    required this.onOpenAddDialog,
  });

  @override
  State<_TreeItemWidget> createState() => _TreeItemWidgetState();
}

class _TreeItemWidgetState extends State<_TreeItemWidget> {
  Timer? _springTimer;

  @override
  void dispose() {
    _springTimer?.cancel();
    super.dispose();
  }

  void _cancelTimer() {
    _springTimer?.cancel();
    _springTimer = null;
  }

  void _startTimer() {
    if (_springTimer != null) return;
    final children = widget.allLocations.where((l) => l.parentLocationId == widget.node.id).toList();
    final isExpanded = widget.expandedLocationIds.contains(widget.node.id);
    if (children.isNotEmpty && !isExpanded) {
      _springTimer = Timer(const Duration(milliseconds: 600), () {
        _springTimer = null;
        if (mounted) {
          widget.onToggleExpand(widget.node.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = widget.allLocations.where((l) => l.parentLocationId == widget.node.id).toList();
    final isSelected = widget.node.id == widget.selectedLocationId;
    final isExpanded = widget.expandedLocationIds.contains(widget.node.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only this single row is the DragTarget
        DragTarget<Object>(
          onWillAcceptWithDetails: (_) => true,
          onMove: (_) => _startTimer(),
          onLeave: (_) => _cancelTimer(),
          onAcceptWithDetails: (details) {
            _cancelTimer();
            widget.onDrop(details.data, widget.node.id);
          },
          builder: (context, candidateData, rejectedData) {
            final isHovered = candidateData.isNotEmpty;
            return Container(
              margin: EdgeInsets.only(left: widget.depth * 16.0, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: isHovered
                    ? theme.colorScheme.primaryContainer
                    : (isSelected ? theme.colorScheme.primary.withAlpha(30) : null),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (children.isNotEmpty)
                      GestureDetector(
                        onTap: () => widget.onToggleExpand(widget.node.id),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                            size: 18,
                            color: isSelected ? theme.colorScheme.primary : Colors.grey,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 22),
                    Icon(
                      children.isNotEmpty ? Icons.folder_outlined : Icons.location_on_outlined,
                      color: isSelected ? theme.colorScheme.primary : Colors.grey,
                    ),
                  ],
                ),
                title: Text(
                  widget.node.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.primary : null,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                  tooltip: AppStrings.newSubLocationTitle,
                  onPressed: () => widget.onOpenAddDialog(widget.node.id),
                ),
                onTap: () => widget.onSelect(widget.node.id),
              ),
            );
          },
        ),

        // Children sub-tree placed outside the parent DragTarget
        if (children.isNotEmpty && isExpanded)
          ...children.map(
            (child) => _TreeItemWidget(
              key: ValueKey(child.id),
              node: child,
              depth: widget.depth + 1,
              allLocations: widget.allLocations,
              selectedLocationId: widget.selectedLocationId,
              expandedLocationIds: widget.expandedLocationIds,
              onToggleExpand: widget.onToggleExpand,
              onSelect: widget.onSelect,
              onDrop: widget.onDrop,
              onOpenAddDialog: widget.onOpenAddDialog,
            ),
          ),
      ],
    );
  }
}

/// Spring-loaded interactive breadcrumb chip with generous size, DragTarget and 600ms hover timer.
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
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: isHovered
                  ? theme.colorScheme.primaryContainer
                  : (widget.isHighlighted
                      ? theme.colorScheme.primary.withAlpha(25)
                      : theme.colorScheme.surfaceContainerHighest.withAlpha(90)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isHovered
                    ? theme.colorScheme.primary
                    : (widget.isHighlighted
                        ? theme.colorScheme.primary.withAlpha(130)
                        : theme.dividerColor.withAlpha(50)),
                width: (isHovered || widget.isHighlighted) ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 15,
                  color: (widget.isHighlighted || isHovered)
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: (widget.isHighlighted || isHovered) ? FontWeight.bold : FontWeight.w600,
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
