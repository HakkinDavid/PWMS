import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../entities/domain/effective_entity_group.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/effective_group_tile.dart';
import '../../entities/presentation/minecraft_tile_widget.dart';
import '../../entities/presentation/register_object_modal.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../../locations/presentation/top_curtain_location_sheet.dart';
import '../../relations/domain/entity_relation.dart';

import '../../locations/infrastructure/location_repository.dart';

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

  // Set of expanded container entity IDs for inline container stacking (Point 1)
  final Set<String> _expandedContainerEntityIds = {};

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
    for (final id in entityIds) {
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

  Future<void> _deleteSelectedEntities() async {
    if (_selectedEntityIds.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.deleteSelectionTitle),
        content: Text('${AppStrings.deleteSelectionConfirmationPrefix}${_selectedEntityIds.length}${AppStrings.deleteSelectionConfirmationSuffix}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
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

    // Map catalog items by ID
    final catalogMap = {for (var c in catalogItems) c.id: c};

    // Build GUARDADO_EN relations container map (Point 1)
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

    // Filter by type
    if (_selectedTypeFilter != AppStrings.all) {
      filteredEntities = filteredEntities.where((e) {
        final species = catalogMap[e.speciesId];
        return species?.type == _selectedTypeFilter;
      }).toList();
    }

    // Separate Top-Level entities from Contained entities (Point 1)
    final topLevelEntities = filteredEntities.where((e) => !containedEntityIds.contains(e.id)).toList();

    // Group Top-Level entities into effective groups
    final groupsContainerEntityIds = relations.where((r) => r.relationType == 'GUARDADO_EN').map((r) => r.targetEntityId).toSet();
    final topGroups = EffectiveEntityGroup.groupEntities(
      entities: topLevelEntities,
      effectiveLocationMap: {for (var e in topLevelEntities) e.id: e.locationId},
      containerEntityIds: groupsContainerEntityIds,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
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
          // Top Curtain Location Sheet & Breadcrumb Route Bar
          TopCurtainLocationSheet(
            allLocations: locationNodes,
            selectedLocationId: _selectedLocationId,
            initiallyExpanded: widget.startWithCurtainOpen,
            onLocationSelected: (locId) => setState(() => _selectedLocationId = locId),
            onDropOnLocation: (payload, targetLocId) {
              if (payload is List<String>) {
                _moveEntitiesToLocation(payload, targetLocId);
              } else if (payload is EffectiveEntityGroup) {
                final ids = payload.entities.map((e) => e.id).toList();
                _moveEntitiesToLocation(ids, targetLocId);
              } else if (payload is WorldEntity) {
                _moveEntitiesToLocation([payload.id], targetLocId);
              }
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

          // Main Inventory Content with Container Stacking & Drag Logic
          Expanded(
            child: topGroups.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 48, color: theme.colorScheme.primary.withAlpha(100)),
                        const SizedBox(height: 12),
                        const Text('No hay elementos en esta ubicación.'),
                      ],
                    ),
                  )
                : _buildInventoryContent(topGroups, catalogMap, containerChildrenMap, allEntities),
          ),

          // Floating Bulk Actions Bar
          if (_isSelectionMode && _selectedEntityIds.isNotEmpty)
            Container(
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
        ],
      ),
    );
  }

  Widget _buildInventoryContent(
    List<EffectiveEntityGroup> topGroups,
    Map<String, CatalogItem> catalogMap,
    Map<String, List<String>> containerChildrenMap,
    List<WorldEntity> allEntities,
  ) {
    final theme = Theme.of(context);
    final allEntitiesMap = {for (var e in allEntities) e.id: e};

    Widget content;

    if (_viewMode == FinderViewMode.minecraftGrid) {
      // Minecraft Grid Mode
      content = GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: topGroups.length,
        itemBuilder: (ctx, idx) {
          final grp = topGroups[idx];
          final primary = grp.primaryEntity;
          final species = catalogMap[grp.speciesId];
          final isSelected = _selectedEntityIds.contains(primary.id);
          final isExpired = grp.expiredCount(now: DateTime.now()) > 0;

          return MinecraftTileWidget(
            group: grp,
            title: species?.name ?? AppStrings.typeObject,
            photoPath: species?.mainPhotoPath,
            isSelected: isSelected,
            isExpired: isExpired,
            onTap: () {
              if (_isSelectionMode) {
                _toggleSelection(primary.id);
              } else if (grp.population == 1) {
                context.push('/entity/${primary.id}');
              } else {
                context.push('/grouped-instance-detail?speciesId=${grp.speciesId}&locId=${grp.effectiveLocationId ?? ""}');
              }
            },
            onLongPress: () {
              if (!_isSelectionMode) {
                setState(() {
                  _isSelectionMode = true;
                  _selectedEntityIds.add(primary.id);
                });
              }
            },
          );
        },
      );
    } else {
      // Detailed List Mode with Container Stacking
      content = ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
      itemCount: topGroups.length,
      itemBuilder: (ctx, idx) {
        final grp = topGroups[idx];
        final primary = grp.primaryEntity;
        final primaryId = primary.id;
        final isSelected = _selectedEntityIds.contains(primaryId);

        final containedIds = grp.entities
            .expand((e) => containerChildrenMap[e.id] ?? <String>[])
            .toSet()
            .toList();
        final isContainer = containedIds.isNotEmpty;
        final isExpanded = _expandedContainerEntityIds.contains(primaryId);

        Widget tileWidget = EffectiveGroupTile(
          group: grp,
          onTap: isContainer
              ? () {
                  setState(() {
                    if (isExpanded) {
                      _expandedContainerEntityIds.remove(primaryId);
                    } else {
                      _expandedContainerEntityIds.add(primaryId);
                    }
                  });
                }
              : null,
        );

        // Container Stack Items (Point 1: First tap expands/collapses, recursive subtree)
        if (isContainer && isExpanded) {
          tileWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tileWidget,
              Padding(
                padding: const EdgeInsets.only(left: 28.0, top: 4.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: theme.colorScheme.primary.withAlpha(100), width: 2.0)),
                  ),
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildContainerSubtree(
                    parentGroup: grp,
                    containerChildrenMap: containerChildrenMap,
                    allEntitiesMap: allEntitiesMap,
                    theme: theme,
                    visited: {for (var e in grp.entities) e.id},
                  ),
                ),
              ),
            ],
          );
        }

        // Drag Target for dropping items into Container Entity (Point 1)
        final innerTileWidget = tileWidget;

        tileWidget = DragTarget<Object>(
          onWillAcceptWithDetails: (details) => details.data != grp && details.data != primaryId,
          onAcceptWithDetails: (details) {
            final data = details.data;
            if (data is List<String>) {
              _moveEntitiesToContainer(data, primaryId);
            } else if (data is EffectiveEntityGroup) {
              final ids = data.entities.map((e) => e.id).toList();
              _moveEntitiesToContainer(ids, primaryId);
            } else if (data is WorldEntity) {
              _moveEntitiesToContainer([data.id], primaryId);
            }
          },
          builder: (context, candidateData, rejectedData) {
            final isHovered = candidateData.isNotEmpty;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isHovered ? theme.colorScheme.primaryContainer.withAlpha(100) : null,
              ),
              child: innerTileWidget,
            );
          },
        );

        // Selection Mode Checkbox / Draggable Logic (Point 2 & 3)
        if (!_isSelectionMode) {
          return LongPressDraggable<Object>(
            data: grp,
            feedback: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                color: theme.colorScheme.primaryContainer,
                child: Text(
                  'Arrastrando ${grp.population} unidad(es)',
                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer),
                ),
              ),
            ),
            childWhenDragging: Opacity(opacity: 0.4, child: tileWidget),
            child: tileWidget,
          );
        }

        // Selection Mode active: Draggable carries selected entity IDs (Point 3)
        final isItemDraggableInSelection = isSelected;

        Widget selectionContent = Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleSelection(primaryId),
            ),
            Expanded(child: tileWidget),
          ],
        );

        if (isItemDraggableInSelection && _selectedEntityIds.isNotEmpty) {
          return LongPressDraggable<Object>(
            data: _selectedEntityIds.toList(),
            feedback: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                color: theme.colorScheme.primaryContainer,
                child: Text(
                  'Arrastrando ${_selectedEntityIds.length} elementos seleccionados',
                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer),
                ),
              ),
            ),
            childWhenDragging: Opacity(opacity: 0.4, child: selectionContent),
            child: selectionContent,
          );
        }

        return selectionContent;
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

  Widget _buildContainerSubtree({
    required EffectiveEntityGroup parentGroup,
    required Map<String, List<String>> containerChildrenMap,
    required Map<String, WorldEntity> allEntitiesMap,
    required ThemeData theme,
    required Set<String> visited,
  }) {
    final containedIds = parentGroup.entities
        .expand((e) => containerChildrenMap[e.id] ?? <String>[])
        .where((id) => !visited.contains(id))
        .toSet()
        .toList();

    if (containedIds.isEmpty) return const SizedBox.shrink();

    final containedEntitiesList = containedIds
        .map((cId) => allEntitiesMap[cId])
        .whereType<WorldEntity>()
        .toList();

    if (containedEntitiesList.isEmpty) return const SizedBox.shrink();

    for (final e in containedEntitiesList) {
      visited.add(e.id);
    }

    final containedGroups = EffectiveEntityGroup.groupEntities(
      entities: containedEntitiesList,
      effectiveLocationMap: {for (var e in containedEntitiesList) e.id: parentGroup.effectiveLocationId},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: containedGroups.map((cGrp) {
        final cPrimaryId = cGrp.primaryEntity.id;
        final cContainedIds = cGrp.entities
            .expand((e) => containerChildrenMap[e.id] ?? <String>[])
            .where((id) => !visited.contains(id))
            .toSet()
            .toList();

        final cIsContainer = cContainedIds.isNotEmpty;
        final cIsExpanded = _expandedContainerEntityIds.contains(cPrimaryId);

        Widget cTile = EffectiveGroupTile(
          group: cGrp,
          onTap: cIsContainer
              ? () {
                  setState(() {
                    if (cIsExpanded) {
                      _expandedContainerEntityIds.remove(cPrimaryId);
                    } else {
                      _expandedContainerEntityIds.add(cPrimaryId);
                    }
                  });
                }
              : null,
        );

        if (cIsContainer && cIsExpanded) {
          cTile = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cTile,
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 4.0, bottom: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: theme.colorScheme.primary.withAlpha(100), width: 2.0)),
                  ),
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildContainerSubtree(
                    parentGroup: cGrp,
                    containerChildrenMap: containerChildrenMap,
                    allEntitiesMap: allEntitiesMap,
                    theme: theme,
                    visited: Set.from(visited),
                  ),
                ),
              ),
            ],
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: cTile,
        );
      }).toList(),
    );
  }
}
