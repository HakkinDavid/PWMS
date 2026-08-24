import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../entities/domain/effective_entity_group.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/effective_group_tile.dart';
import '../../entities/presentation/minecraft_tile_widget.dart';
import '../../entities/presentation/register_object_modal.dart';
import '../../locations/presentation/location_tile.dart';
import '../../locations/presentation/location_tree_picker.dart';
import 'inventory_breadcrumb_bar.dart';
import 'inventory_item_interaction_wrapper.dart';

import '../../entities/presentation/instance_preview_card.dart';
import '../../locations/domain/location_node.dart';
import '../../locations/infrastructure/location_repository.dart';
import '../../relations/domain/entity_relation.dart';

enum FinderViewMode { detailedList, minecraftGrid }

class InventoryFinderScreen extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final String? initialContainerId;
  final bool startWithCurtainOpen;

  const InventoryFinderScreen({
    super.key,
    this.initialLocationId,
    this.initialContainerId,
    this.startWithCurtainOpen = false,
  });

  @override
  ConsumerState<InventoryFinderScreen> createState() => _InventoryFinderScreenState();
}

class _InventoryFinderScreenState extends ConsumerState<InventoryFinderScreen> {
  final GlobalKey<InventoryBreadcrumbBarState> _breadcrumbBarKey = GlobalKey();
  String? _selectedLocationId; // Null means "Todas las Ubicaciones"
  final List<String?> _locationHistory = [];
  bool _isSelectionMode = false;
  final Set<String> _selectedEntityIds = {};
  String _selectedTypeFilter = AppStrings.all;
  FinderViewMode _viewMode = FinderViewMode.detailedList;

  List<String> _containerPath = [];

  bool _isDragging = false;
  String? _dragOriginLocationId;
  String? _dragOriginContainerId;
  bool _dragHasNavigated = false;

  late final ScrollController _scrollController;
  Timer? _autoScrollTimer;

  void _handleDragStarted() {
    _isDragging = true;
    _dragOriginLocationId = _selectedLocationId;
    _dragOriginContainerId = _containerPath.isNotEmpty ? _containerPath.last : null;
    _dragHasNavigated = false;
  }

  void _handleDragEnd() {
    _isDragging = false;
    _dragOriginLocationId = null;
    _dragOriginContainerId = null;
    _dragHasNavigated = false;
  }

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
    if (widget.initialContainerId != null && widget.initialContainerId!.isNotEmpty) {
      _containerPath.add(widget.initialContainerId!);
    }
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(InventoryFinderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLocationId != oldWidget.initialLocationId) {
      setState(() {
        _selectedLocationId = widget.initialLocationId;
      });
    }
    if (widget.initialContainerId != oldWidget.initialContainerId && widget.initialContainerId != null) {
      setState(() {
        _containerPath = [widget.initialContainerId!];
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _startAutoScroll(double step) {
    if (_autoScrollTimer != null && _autoScrollTimer!.isActive) return;
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      if (!_scrollController.hasClients) return;
      final target = (_scrollController.offset + step).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.jumpTo(target);
    });
  }

  final List<String> _filters = [
    AppStrings.all,
    AppStrings.typeObject,
    AppStrings.typeDocument,
    AppStrings.typeProject,
    AppStrings.typeMemory,
  ];

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedEntityIds.contains(id)) {
        _selectedEntityIds.remove(id);
      } else {
        _selectedEntityIds.add(id);
      }
    });
  }

  void _handleLocationSelected(String? newLocId) {
    if (newLocId == _selectedLocationId) return;
    if (_selectedLocationId != null || _locationHistory.isNotEmpty) {
      _locationHistory.add(_selectedLocationId);
    }
    if (_isDragging) {
      _dragHasNavigated = true;
    }
    setState(() {
      _selectedLocationId = newLocId;
    });
  }

  void _handleBackNavigation() {
    if (_isSelectionMode) {
      setState(() {
        _isSelectionMode = false;
        _selectedEntityIds.clear();
      });
    } else if (_breadcrumbBarKey.currentState?.isCurtainExpanded == true) {
      _breadcrumbBarKey.currentState?.collapseCurtain();
    } else if (_containerPath.isNotEmpty) {
      setState(() {
        _containerPath.removeLast();
      });
    } else if (_locationHistory.isNotEmpty) {
      setState(() {
        _selectedLocationId = _locationHistory.removeLast();
      });
    } else if (_selectedLocationId != null) {
      setState(() {
        _selectedLocationId = null;
      });
    }
  }

  void _refreshAllState() {
    ref.invalidate(entityListProvider);
    ref.invalidate(catalogListProvider);
    ref.invalidate(locationNodeListProvider);
    ref.invalidate(subspeciesListProvider);
    ref.invalidate(relationListProvider);
  }

  Future<void> _moveEntitiesToLocation(List<String> entityIds, String? targetLocId) async {
    if (entityIds.isEmpty) return;

    final repo = ref.read(entityRepositoryProvider);
    final relationRepo = ref.read(relationRepositoryProvider);
    final allRels = await relationRepo.getAllRelations();
    final allEntities = await repo.getAllEntities();
    final entityMap = {for (var e in allEntities) e.id: e};

    // Filter out entities that are already directly at targetLocId without containers
    final idsToMove = <String>[];
    for (final id in entityIds) {
      final ent = entityMap[id];
      if (ent == null) continue;
      final existingInheriting = allRels.where((r) =>
        r.sourceEntityId == id && (r.relationType == 'GUARDADO_EN' || r.relationType == 'PARTE_DE')
      ).toList();

      if (existingInheriting.isEmpty && ent.locationId == targetLocId) {
        continue; // Already directly in target location, skip!
      }
      idsToMove.add(id);
    }

    if (idsToMove.isEmpty) return;

    for (final id in idsToMove) {
      final existingInheriting = allRels.where((r) =>
        r.sourceEntityId == id && (r.relationType == 'GUARDADO_EN' || r.relationType == 'PARTE_DE')
      ).toList();
      for (final rel in existingInheriting) {
        await relationRepo.deleteRelation(rel.id);
      }
      await repo.moveEntity(id, targetLocId);
    }

    _refreshAllState();

    setState(() {
      _selectedEntityIds.removeAll(idsToMove);
      if (_selectedEntityIds.isEmpty) _isSelectionMode = false;
    });

    if (mounted) {
      AppToast.showSuccess(context, AppStrings.itemsMovedSuccess);
    }
  }

  Future<void> _moveEntitiesToContainer(List<String> entityIds, String targetContainerEntityId) async {
    if (entityIds.isEmpty) return;

    final relationRepo = ref.read(relationRepositoryProvider);
    final allRels = await relationRepo.getAllRelations();

    // Filter out entities that are already inside targetContainerEntityId or self-containment
    final idsToMove = <String>[];
    for (final sourceId in entityIds) {
      if (sourceId == targetContainerEntityId) continue;
      final isAlreadyInside = allRels.any((r) =>
        r.sourceEntityId == sourceId &&
        r.targetEntityId == targetContainerEntityId &&
        r.relationType == 'GUARDADO_EN'
      );
      if (isAlreadyInside) continue; // Already directly inside target container, skip!
      idsToMove.add(sourceId);
    }

    if (idsToMove.isEmpty) return;

    for (final sourceId in idsToMove) {
      await relationRepo.addRelation(EntityRelation(
        id: '${sourceId}_$targetContainerEntityId',
        sourceEntityId: sourceId,
        targetEntityId: targetContainerEntityId,
        relationType: 'GUARDADO_EN',
        createdAt: DateTime.now(),
      ));
    }

    _refreshAllState();

    setState(() {
      _selectedEntityIds.removeAll(idsToMove);
      if (_selectedEntityIds.isEmpty) _isSelectionMode = false;
    });

    if (mounted) {
      AppToast.showSuccess(context, AppStrings.itemsSavedInContainerSuccess);
    }
  }

  void _handleItemTap(EffectiveEntityGroup grp, bool isContainer) {
    if (_isSelectionMode) {
      _toggleSelection(grp.primaryEntity.id);
    } else if (isContainer) {
      setState(() {
        _containerPath.add(grp.primaryEntity.id);
      });
    } else if (grp.population == 1) {
      context.pushEntityDetail(grp.primaryEntity.id);
    } else {
      context.pushGroupedInstanceDetail(grp.speciesId, effectiveLocationId: grp.effectiveLocationId);
    }
  }

  void _handleDropIntoContainer(Object payload, String targetContainerEntityId) {
    if (payload is List<String>) {
      _moveEntitiesToContainer(payload, targetContainerEntityId);
    } else if (payload is EffectiveEntityGroup) {
      final ids = payload.entities.map((e) => e.id).toList();
      _moveEntitiesToContainer(ids, targetContainerEntityId);
    } else if (payload is WorldEntity) {
      _moveEntitiesToContainer([payload.id], targetContainerEntityId);
    }
  }

  Future<void> _deleteSelectedEntities() async {
    if (_selectedEntityIds.isEmpty) return;

    final confirm = await AppConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: AppStrings.deleteSelectionTitle,
      message: '${AppStrings.deleteSelectionConfirmationPrefix}${_selectedEntityIds.length}${AppStrings.deleteSelectionConfirmationSuffix}',
    );

    if (confirm != true) return;

    final repo = ref.read(entityRepositoryProvider);
    await repo.deleteEntitiesBatch(_selectedEntityIds.toList());
    _refreshAllState();

    setState(() {
      _selectedEntityIds.clear();
      _isSelectionMode = false;
    });

    if (mounted) AppToast.showSuccess(context, AppStrings.itemsDeletedSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final relationsState = ref.watch(relationListProvider);

    final catalogItems = catalogState.asData?.value ?? [];
    final locationNodes = locationsState.asData?.value ?? [];
    final allEntities = entitiesState.asData?.value ?? [];
    final relations = relationsState.asData?.value ?? [];

    // Map catalog items and entities by ID
    final catalogMap = {for (var c in catalogItems) c.id: c};
    final allEntitiesMap = {for (var e in allEntities) e.id: e};

    // Build GUARDADO_EN relations container map
    final guardadoEnRelations = relations.where((r) => r.relationType == 'GUARDADO_EN').toList();
    final Set<String> containedEntityIds = guardadoEnRelations.map((r) => r.sourceEntityId).toSet();
    final Map<String, List<String>> containerChildrenMap = {};
    for (final r in guardadoEnRelations) {
      containerChildrenMap.putIfAbsent(r.targetEntityId, () => []).add(r.sourceEntityId);
    }

    // Filter entities by selected location (direct physical location only, excluding child locations)
    var filteredEntities = allEntities.toList();

    if (_selectedLocationId != null) {
      if (_selectedLocationId == '__UNASSIGNED__') {
        filteredEntities = filteredEntities.where((e) => e.locationId == null).toList();
      } else {
        filteredEntities = filteredEntities.where((e) => e.locationId == _selectedLocationId).toList();
      }
    }

    // Grouping container IDs set
    final groupsContainerEntityIds = relations.where((r) => r.relationType == 'GUARDADO_EN').map((r) => r.targetEntityId).toSet();

    // Determine current level groups based on Drill-Down container path
    final List<EffectiveEntityGroup> currentGroups;
    final WorldEntity? activeContainerEntity;
    final CatalogItem? activeContainerSpecies;

    if (_containerPath.isNotEmpty) {
      final activeContainerId = _containerPath.last;
      activeContainerEntity = allEntitiesMap[activeContainerId];
      activeContainerSpecies = activeContainerEntity != null ? catalogMap[activeContainerEntity.speciesId] : null;

      final directChildIds = containerChildrenMap[activeContainerId] ?? <String>[];
      var childEntities = directChildIds.map((id) => allEntitiesMap[id]).whereType<WorldEntity>().toList();

      if (_selectedTypeFilter != AppStrings.all) {
        childEntities = childEntities.where((e) {
          final species = catalogMap[e.speciesId];
          return species?.type == _selectedTypeFilter;
        }).toList();
      }

      currentGroups = EffectiveEntityGroup.groupEntities(
        entities: childEntities,
        effectiveLocationMap: {for (var e in childEntities) e.id: activeContainerEntity?.locationId},
        containerEntityIds: groupsContainerEntityIds,
      );
    } else {
      activeContainerEntity = null;
      activeContainerSpecies = null;

      var topLevelEntities = filteredEntities.where((e) => !containedEntityIds.contains(e.id)).toList();

      if (_selectedTypeFilter != AppStrings.all) {
        topLevelEntities = topLevelEntities.where((e) {
          final species = catalogMap[e.speciesId];
          return species?.type == _selectedTypeFilter;
        }).toList();
      }

      currentGroups = EffectiveEntityGroup.groupEntities(
        entities: topLevelEntities,
        effectiveLocationMap: {for (var e in topLevelEntities) e.id: e.locationId},
        containerEntityIds: groupsContainerEntityIds,
      );
    }

    // Child sub-locations of current view (always displayed at the end when outside containers)
    final List<LocationNode> childLocations;
    if (_containerPath.isEmpty && _selectedTypeFilter == AppStrings.all) {
      if (_selectedLocationId == null) {
        childLocations = locationNodes.where((l) => l.parentLocationId == null).toList();
      } else {
        childLocations = locationNodes.where((l) => l.parentLocationId == _selectedLocationId).toList();
      }
    } else {
      childLocations = [];
    }

    final bool canGoBack = _containerPath.isNotEmpty || _selectedLocationId != null || _locationHistory.isNotEmpty;

    return PopScope(
      canPop: !canGoBack && !_isSelectionMode && _breadcrumbBarKey.currentState?.isCurtainExpanded != true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_containerPath.isNotEmpty ? (activeContainerSpecies?.name ?? 'Contenedor') : 'Inventario'),
          leading: canGoBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Retroceder',
                  onPressed: _handleBackNavigation,
                )
              : null,
          actions: [
            // 2-Way View Mode Switcher
            IconButton(
              icon: Icon(
                _viewMode == FinderViewMode.detailedList
                    ? Icons.view_list
                    : Icons.apps,
              ),
              tooltip: AppStrings.toggleViewModeTooltip,
              onPressed: () {
                setState(() {
                  if (_viewMode == FinderViewMode.detailedList) {
                    _viewMode = FinderViewMode.minecraftGrid;
                  } else {
                    _viewMode = FinderViewMode.detailedList;
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(_isSelectionMode ? Icons.check_box : Icons.select_all),
              tooltip: _isSelectionMode ? AppStrings.cancelSelectionTooltip : AppStrings.multipleSelectionTooltip,
              onPressed: () {
                setState(() {
                  _isSelectionMode = !_isSelectionMode;
                  _selectedEntityIds.clear();
                });
              },
            ),
          ],
        ),

        // Single Round FAB '+'
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: (_isSelectionMode && _selectedEntityIds.isNotEmpty) ? 60.0 : 0.0),
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () => RegisterObjectModal.show(context, initialLocationId: _selectedLocationId),
            tooltip: 'Crear o Instanciar',
            child: const Icon(Icons.add),
          ),
        ),

        body: Column(
          children: [
            // Unified Navigation Bar (Breadcrumbs, Location Curtain, Container Path & Hero Tile)
            InventoryBreadcrumbBar(
              key: _breadcrumbBarKey,
              allLocations: locationNodes,
              selectedLocationId: _selectedLocationId,
              containerPath: _containerPath,
              catalogMap: catalogMap,
              allEntitiesMap: allEntitiesMap,
              allRelations: relations,
              initiallyExpanded: widget.startWithCurtainOpen,
              onLocationSelected: _handleLocationSelected,
              onDropOnLocation: (payload, targetLocId) {
                final ids = _extractPayloadIds(payload);
                if (ids.isNotEmpty) {
                  _moveEntitiesToLocation(ids, targetLocId);
                }
              },
              onDropIntoContainer: (payload, targetContainerId) {
                final ids = _extractPayloadIds(payload);
                if (ids.isNotEmpty) {
                  _moveEntitiesToContainer(ids, targetContainerId);
                }
              },
              onNavigateToContainerIndex: (idx) {
                if (_isDragging) _dragHasNavigated = true;
                setState(() {
                  _containerPath.removeRange(idx + 1, _containerPath.length);
                });
              },
              onExitContainersToRoot: () {
                if (_isDragging) _dragHasNavigated = true;
                setState(() {
                  _containerPath.clear();
                  _selectedLocationId = null;
                  _locationHistory.clear();
                });
              },
            ),

            // Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: _filters.map((f) {
                  final isSel = _selectedTypeFilter == f;
                  return Padding(
                     padding: const EdgeInsets.only(right: 6),
                     child: FilterChip(
                       label: Text(f, style: const TextStyle(fontSize: 11)),
                       selected: isSel,
                       onSelected: (val) {
                         if (val) setState(() => _selectedTypeFilter = f);
                       },
                     ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1),

            // Main Inventory Content (Root or Contained items) wrapped in canvas DragTarget with edge autoscroll
            Expanded(
              child: Builder(
                builder: (canvasContext) {
                  return DragTarget<Object>(
                    onWillAcceptWithDetails: (details) => true,
                    onMove: (details) {
                      if (_breadcrumbBarKey.currentState?.isCurtainExpanded == true) {
                        _breadcrumbBarKey.currentState?.collapseCurtain();
                      }
                      final RenderBox? box = canvasContext.findRenderObject() as RenderBox?;
                      if (box == null || !box.hasSize || !_scrollController.hasClients) return;
                      final boxOffset = box.localToGlobal(Offset.zero);
                      final topEdge = boxOffset.dy;
                      final bottomEdge = boxOffset.dy + box.size.height;
                      final pointerY = details.offset.dy;

                      const double threshold = 60.0;

                      if (pointerY >= topEdge && pointerY <= topEdge + threshold) {
                        final ratio = 1.0 - ((pointerY - topEdge) / threshold).clamp(0.0, 1.0);
                        final step = -(8.0 + ratio * 16.0);
                        _startAutoScroll(step);
                      } else if (pointerY <= bottomEdge && pointerY >= bottomEdge - threshold) {
                        final ratio = 1.0 - ((bottomEdge - pointerY) / threshold).clamp(0.0, 1.0);
                        final step = (8.0 + ratio * 16.0);
                        _startAutoScroll(step);
                      } else {
                        _stopAutoScroll();
                      }
                    },
                    onLeave: (_) => _stopAutoScroll(),
                    onAcceptWithDetails: (details) {
                      _stopAutoScroll();
                      if (_breadcrumbBarKey.currentState?.isCurtainExpanded == true) {
                        _breadcrumbBarKey.currentState?.collapseCurtain();
                      }
                      final ids = _extractPayloadIds(details.data);
                      if (ids.isEmpty) {
                        _handleDragEnd();
                        return;
                      }

                      // Si se soltó en el canvas de la misma vista sin haber navegado, descartar
                      if (!_dragHasNavigated) {
                        if (_containerPath.isEmpty && _selectedLocationId == null) {
                          _handleDragEnd();
                          return;
                        }
                      }

                      if (_containerPath.isNotEmpty) {
                        _moveEntitiesToContainer(ids, _containerPath.last);
                      } else {
                        _moveEntitiesToLocation(ids, _selectedLocationId);
                      }

                      _handleDragEnd();
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovered = candidateData.isNotEmpty;

                      return Container(
                        color: isHovered ? theme.colorScheme.primary.withAlpha(15) : Colors.transparent,
                        child: (currentGroups.isEmpty && childLocations.isEmpty)
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inventory_2_outlined, size: 48, color: theme.colorScheme.primary.withAlpha(100)),
                                    const SizedBox(height: 12),
                                    Text(
                                      _containerPath.isNotEmpty
                                          ? 'Este contenedor está vacío.\nArrastra elementos aquí para guardarlos.'
                                          : 'No hay elementos en esta ubicación.',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                                    ),
                                  ],
                                ),
                              )
                            : _buildInventoryContent(
                                currentGroups,
                                childLocations,
                                catalogMap,
                                containerChildrenMap,
                                allEntities,
                                containedEntityIds,
                              ),
                      );
                    },
                  );
                },
              ),
            ),

            // Floating Bulk Actions Bar
            if (_isSelectionMode && _selectedEntityIds.isNotEmpty)
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: theme.colorScheme.primaryContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedEntityIds.length} seleccionado(s)',
                        style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.drive_file_move_outlined),
                            tooltip: 'Mover Selección',
                            onPressed: () async {
                              final res = await LocationTreePicker.show(context);
                              if (res != null) {
                                await _moveEntitiesToLocation(_selectedEntityIds.toList(), res.locationId);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Eliminar Selección',
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirmar eliminación'),
                                  content: Text('¿Eliminar ${_selectedEntityIds.length} elemento(s)?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
                                      child: const Text(AppStrings.delete, style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                final repo = ref.read(entityRepositoryProvider);
                                for (final id in _selectedEntityIds) {
                                  await repo.deleteEntity(id);
                                }
                                _refreshAllState();
                                setState(() {
                                  _selectedEntityIds.clear();
                                  _isSelectionMode = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<String> _extractPayloadIds(Object? payload) {
    if (payload is List<String>) {
      return payload;
    } else if (payload is EffectiveEntityGroup) {
      return payload.entities.map((e) => e.id).toList();
    } else if (payload is WorldEntity) {
      return [payload.id];
    }
    return [];
  }

  Widget _buildInventoryContent(
    List<EffectiveEntityGroup> currentGroups,
    List<LocationNode> childLocations,
    Map<String, CatalogItem> catalogMap,
    Map<String, List<String>> containerChildrenMap,
    List<WorldEntity> allEntities,
    Set<String> containedEntityIds,
  ) {
    final bottomClearance = MediaQuery.paddingOf(context).bottom + 84.0;
    final totalCount = currentGroups.length + childLocations.length;

    // Direct items count map for child locations
    final directItemCountMap = <String, int>{};
    for (final loc in childLocations) {
      directItemCountMap[loc.id] = allEntities
          .where((e) => e.locationId == loc.id && !containedEntityIds.contains(e.id))
          .length;
    }

    if (_viewMode == FinderViewMode.minecraftGrid) {
      // Minecraft Grid Mode
      return GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomClearance),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: totalCount,
        itemBuilder: (ctx, idx) {
          if (idx < currentGroups.length) {
            final grp = currentGroups[idx];
            final primary = grp.primaryEntity;
            final species = catalogMap[grp.speciesId];
            final isSelected = _selectedEntityIds.contains(primary.id);
            final isExpired = grp.expiredCount(now: DateTime.now()) > 0;
            final containedIds = grp.entities
                .expand((e) => containerChildrenMap[e.id] ?? <String>[])
                .toSet()
                .toList();
            final isContainer = containedIds.isNotEmpty;

            return InventoryItemInteractionWrapper(
              group: grp,
              isSelected: isSelected,
              isSelectionMode: _isSelectionMode,
              selectedEntityIds: _selectedEntityIds,
              isContainer: isContainer,
              onTap: () => _handleItemTap(grp, isContainer),
              onDropIntoContainer: _handleDropIntoContainer,
              onDragStarted: _handleDragStarted,
              onDragEnd: _handleDragEnd,
              onHoverSpringLoaded: (targetContainerId) {
                if (!_containerPath.contains(targetContainerId)) {
                  if (_isDragging) _dragHasNavigated = true;
                  setState(() => _containerPath.add(targetContainerId));
                }
              },
              child: MinecraftTileWidget(
                group: grp,
                title: species?.name ?? AppStrings.typeObject,
                isSelected: isSelected,
                isSelectionMode: _isSelectionMode,
                isContainer: isContainer,
                containedCount: containedIds.length,
                isExpired: isExpired,
                onTap: () => _handleItemTap(grp, isContainer),
              ),
            );
          } else {
            final locNode = childLocations[idx - currentGroups.length];
            return _LocationItemInteractionTile(
              key: ValueKey('loc_tile_${locNode.id}'),
              node: locNode,
              directItemCount: directItemCountMap[locNode.id] ?? 0,
              viewMode: FinderViewMode.minecraftGrid,
              onTap: () => _handleLocationSelected(locNode.id),
              onDrop: (payload, locId) {
                final ids = _extractPayloadIds(payload);
                if (ids.isNotEmpty) {
                  _moveEntitiesToLocation(ids, locId);
                }
              },
              onSpringLoad: (locId) => _handleLocationSelected(locId),
            );
          }
        },
      );
    } else {
      // Detailed List Mode
      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: bottomClearance),
        itemCount: totalCount,
        itemBuilder: (ctx, idx) {
          if (idx < currentGroups.length) {
            final grp = currentGroups[idx];
            final primary = grp.primaryEntity;
            final primaryId = primary.id;
            final isSelected = _selectedEntityIds.contains(primaryId);

            final containedIds = grp.entities
                .expand((e) => containerChildrenMap[e.id] ?? <String>[])
                .toSet()
                .toList();
            final isContainer = containedIds.isNotEmpty;

            return InventoryItemInteractionWrapper(
              group: grp,
              isSelected: isSelected,
              isSelectionMode: _isSelectionMode,
              selectedEntityIds: _selectedEntityIds,
              isContainer: isContainer,
              onTap: () => _handleItemTap(grp, isContainer),
              onDropIntoContainer: _handleDropIntoContainer,
              onDragStarted: _handleDragStarted,
              onDragEnd: _handleDragEnd,
              onHoverSpringLoaded: (targetContainerId) {
                if (!_containerPath.contains(targetContainerId)) {
                  if (_isDragging) _dragHasNavigated = true;
                  setState(() => _containerPath.add(targetContainerId));
                }
              },
              child: EffectiveGroupTile(
                group: grp,
                isSelected: isSelected,
                isSelectionMode: _isSelectionMode,
                isContainer: isContainer,
                onTap: () => _handleItemTap(grp, isContainer),
              ),
            );
          } else {
            final locNode = childLocations[idx - currentGroups.length];
            return _LocationItemInteractionTile(
              key: ValueKey('loc_tile_${locNode.id}'),
              node: locNode,
              directItemCount: directItemCountMap[locNode.id] ?? 0,
              viewMode: FinderViewMode.detailedList,
              onTap: () => _handleLocationSelected(locNode.id),
              onDrop: (payload, locId) {
                final ids = _extractPayloadIds(payload);
                if (ids.isNotEmpty) {
                  _moveEntitiesToLocation(ids, locId);
                }
              },
              onSpringLoad: (locId) => _handleLocationSelected(locId),
            );
          }
        },
      );
    }
  }
}

/// Standard immutable location tile placed at the end of the inventory list/grid.
/// Functions as a container target (DragTarget, spring-load hover navigation, tap to drill down).
class _LocationItemInteractionTile extends StatefulWidget {
  final LocationNode node;
  final int directItemCount;
  final FinderViewMode viewMode;
  final VoidCallback onTap;
  final Function(Object payload, String targetLocationId) onDrop;
  final ValueChanged<String> onSpringLoad;

  const _LocationItemInteractionTile({
    super.key,
    required this.node,
    required this.directItemCount,
    required this.viewMode,
    required this.onTap,
    required this.onDrop,
    required this.onSpringLoad,
  });

  @override
  State<_LocationItemInteractionTile> createState() => _LocationItemInteractionTileState();
}

class _LocationItemInteractionTileState extends State<_LocationItemInteractionTile> {
  Timer? _hoverTimer;

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  void _cancelTimer() {
    _hoverTimer?.cancel();
    _hoverTimer = null;
  }

  void _startTimer() {
    if (_hoverTimer != null) return;
    _hoverTimer = Timer(const Duration(milliseconds: 600), () {
      _hoverTimer = null;
      if (mounted) {
        widget.onSpringLoad(widget.node.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = LocationTile.resolveLocationIcon(widget.node.icon);

    return DragTarget<Object>(
      onWillAcceptWithDetails: (_) => true,
      onMove: (_) => _startTimer(),
      onLeave: (_) => _cancelTimer(),
      onAcceptWithDetails: (details) {
        _cancelTimer();
        widget.onDrop(details.data, widget.node.id);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        if (widget.viewMode == FinderViewMode.minecraftGrid) {
          // Grid Tile
          return InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isHovered
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest.withAlpha(90),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isHovered
                      ? theme.colorScheme.primary
                      : theme.dividerColor.withAlpha(60),
                  width: isHovered ? 2.0 : 1.0,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconData,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          widget.node.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  if (widget.directItemCount > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.directItemCount}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        // List Tile
        return Container(
          margin: const EdgeInsets.only(bottom: 6.0),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isHovered
                    ? theme.colorScheme.primaryContainer
                    : theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isHovered
                      ? theme.colorScheme.primary
                      : theme.dividerColor.withAlpha(50),
                  width: isHovered ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(6),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      iconData,
                      color: theme.colorScheme.onSecondaryContainer,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.node.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.node.description != null && widget.node.description!.isNotEmpty
                              ? widget.node.description!
                              : '${widget.directItemCount} ${AppStrings.objectsLabel}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
