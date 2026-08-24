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
  final bool startWithCurtainOpen;

  const InventoryFinderScreen({
    super.key,
    this.initialLocationId,
    this.startWithCurtainOpen = false,
  });

  @override
  ConsumerState<InventoryFinderScreen> createState() => _InventoryFinderScreenState();
}

class _InventoryFinderScreenState extends ConsumerState<InventoryFinderScreen> {
  String? _selectedLocationId; // Null means "Todas las Ubicaciones"
  bool _isSelectionMode = false;
  final Set<String> _selectedEntityIds = {};
  String _selectedTypeFilter = AppStrings.all;
  FinderViewMode _viewMode = FinderViewMode.detailedList;

  final List<String> _containerPath = [];

  late final ScrollController _scrollController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
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

  void _handlePointerMove(PointerMoveEvent event, BuildContext scrollableContext) {
    final RenderBox? box = scrollableContext.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !_scrollController.hasClients) return;

    final boxOffset = box.localToGlobal(Offset.zero);
    final topEdge = boxOffset.dy;
    final bottomEdge = boxOffset.dy + box.size.height;
    final pointerY = event.position.dy;

    const double threshold = 80.0;

    if (pointerY >= topEdge && pointerY <= topEdge + threshold) {
      final ratio = 1.0 - ((pointerY - topEdge) / threshold).clamp(0.0, 1.0);
      final step = -(8.0 + ratio * 18.0);
      _startAutoScroll(step);
    } else if (pointerY <= bottomEdge && pointerY >= bottomEdge - threshold) {
      final ratio = 1.0 - ((bottomEdge - pointerY) / threshold).clamp(0.0, 1.0);
      final step = (8.0 + ratio * 18.0);
      _startAutoScroll(step);
    } else {
      _stopAutoScroll();
    }
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

    for (final id in entityIds) {
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
      _selectedEntityIds.removeAll(entityIds);
      if (_selectedEntityIds.isEmpty) _isSelectionMode = false;
    });

    if (mounted) {
      AppToast.showSuccess(context, AppStrings.itemsMovedSuccess);
    }
  }

  Future<void> _moveEntitiesToContainer(List<String> entityIds, String targetContainerEntityId) async {
    if (entityIds.isEmpty) return;

    final relationRepo = ref.read(relationRepositoryProvider);

    for (final sourceId in entityIds) {
      if (sourceId == targetContainerEntityId) continue; // Prevent self-containment
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
      _selectedEntityIds.removeAll(entityIds);
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

    // Filter entities by selected location
    var filteredEntities = allEntities.toList();

    if (_selectedLocationId != null) {
      if (_selectedLocationId == '__UNASSIGNED__') {
        filteredEntities = filteredEntities.where((e) => e.locationId == null).toList();
      } else {
        final descendantLocIds = LocationRepository(ref.read(databaseProvider)).getDescendantIds(_selectedLocationId!, locationNodes);
        final targetLocIds = {_selectedLocationId!, ...descendantLocIds};
        filteredEntities = filteredEntities.where((e) => e.locationId != null && targetLocIds.contains(e.locationId)).toList();
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

    return PopScope(
      canPop: _containerPath.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _containerPath.isNotEmpty) {
          setState(() {
            _containerPath.removeLast();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_containerPath.isNotEmpty ? (activeContainerSpecies?.name ?? 'Contenedor') : 'Inventario'),
          leading: _containerPath.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Subir nivel',
                  onPressed: () => setState(() => _containerPath.removeLast()),
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
              allLocations: locationNodes,
              selectedLocationId: _selectedLocationId,
              containerPath: _containerPath,
              catalogMap: catalogMap,
              allEntitiesMap: allEntitiesMap,
              initiallyExpanded: widget.startWithCurtainOpen,
              onLocationSelected: (locId) => setState(() => _selectedLocationId = locId),
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
                setState(() {
                  _containerPath.removeRange(idx + 1, _containerPath.length);
                });
              },
              onExitContainersToRoot: () {
                setState(() {
                  _containerPath.clear();
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

            // Main Inventory Content (Root or Contained items) wrapped in canvas DragTarget
            Expanded(
              child: DragTarget<Object>(
                onWillAcceptWithDetails: (details) => true,
                onAcceptWithDetails: (details) {
                  final ids = _extractPayloadIds(details.data);
                  if (ids.isEmpty) return;
                  if (_containerPath.isNotEmpty) {
                    _moveEntitiesToContainer(ids, _containerPath.last);
                  } else {
                    _moveEntitiesToLocation(ids, _selectedLocationId);
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovered = candidateData.isNotEmpty;

                  return Container(
                    color: isHovered ? theme.colorScheme.primary.withAlpha(15) : Colors.transparent,
                    child: currentGroups.isEmpty
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
                        : _buildInventoryContent(currentGroups, catalogMap, containerChildrenMap, allEntities),
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
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            tooltip: 'Eliminar Selección',
                            onPressed: _deleteSelectedEntities,
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
    Map<String, CatalogItem> catalogMap,
    Map<String, List<String>> containerChildrenMap,
    List<WorldEntity> allEntities,
  ) {
    Widget content;

    final bottomClearance = MediaQuery.paddingOf(context).bottom + 84.0;

    if (_viewMode == FinderViewMode.minecraftGrid) {
      // Minecraft Grid Mode
      content = GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomClearance),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: currentGroups.length,
        itemBuilder: (ctx, idx) {
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
            onHoverSpringLoaded: (targetContainerId) {
              if (!_containerPath.contains(targetContainerId)) {
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
        },
      );
    } else {
      // Detailed List Mode
      content = ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: bottomClearance),
        itemCount: currentGroups.length,
        itemBuilder: (ctx, idx) {
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
            onHoverSpringLoaded: (targetContainerId) {
              if (!_containerPath.contains(targetContainerId)) {
                setState(() => _containerPath.add(targetContainerId));
              }
            },
            child: EffectiveGroupTile(
              group: grp,
              isSelected: isSelected,
              isSelectionMode: _isSelectionMode,
              onTap: () => _handleItemTap(grp, isContainer),
            ),
          );
        },
      );
    }

    return Builder(
      builder: (contentContext) {
        return Listener(
          onPointerMove: (event) => _handlePointerMove(event, contentContext),
          onPointerUp: (_) => _stopAutoScroll(),
          onPointerCancel: (_) => _stopAutoScroll(),
          child: content,
        );
      },
    );
  }
}
