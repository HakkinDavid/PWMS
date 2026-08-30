import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../entities/domain/effective_entity_group.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/effective_group_tile.dart';
import '../../entities/presentation/minecraft_tile_widget.dart';
import '../../locations/presentation/location_tile.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../../locations/presentation/location_or_container_correction_sheet.dart';
import 'inventory_breadcrumb_bar.dart';
import 'inventory_item_interaction_wrapper.dart';

import '../../locations/domain/location_node.dart';
import '../../locations/domain/location_resolver.dart';
import '../../locations/infrastructure/location_repository.dart';
import '../../relations/domain/entity_relation.dart';
import '../../../core/domain/item_view_mode.dart';
import '../../../core/widgets/view_mode_toggle_button.dart';

typedef FinderViewMode = ItemViewMode;

class InventoryFinderScreen extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final String? initialContainerId;
  final String? initialTargetEntityId;
  final bool startWithCurtainOpen;

  const InventoryFinderScreen({
    super.key,
    this.initialLocationId,
    this.initialContainerId,
    this.initialTargetEntityId,
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
  final Set<String> _expandedStackKeys = {};

  List<String> _containerPath = [];

  final GlobalKey _inventoryCanvasKey = GlobalKey();
  bool _isDragging = false;
  bool _dragHasNavigated = false;
  bool _isCurtainExpanded = false;

  final Map<String, double> _scrollOffsetCache = {};
  String? _highlightEntityId;
  Timer? _highlightTimer;

  late final ScrollController _scrollController;
  Timer? _autoScrollTimer;
  double _autoScrollStep = 0.0;

  void _handleDragStarted() {
    _stopAutoScroll();
    _isDragging = true;
    _dragHasNavigated = false;
  }

  void _handleDragEnd() {
    _stopAutoScroll();
    _isDragging = false;
    _dragHasNavigated = false;
  }

  String _getCurrentLevelKey() {
    if (_containerPath.isNotEmpty) {
      return AppTechnicalStrings.containerLevelKey(_containerPath.join(AppTechnicalStrings.slash));
    }
    return AppTechnicalStrings.locationLevelKey(_selectedLocationId);
  }

  void _saveCurrentScrollOffset() {
    if (_scrollController.hasClients) {
      _scrollOffsetCache[_getCurrentLevelKey()] = _scrollController.offset;
    }
  }

  void _restoreScrollOffsetForCurrentLevel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final saved = _scrollOffsetCache[_getCurrentLevelKey()];
      if (saved != null) {
        final target = saved.clamp(0.0, _scrollController.position.maxScrollExtent);
        _scrollController.jumpTo(target);
      } else {
        _scrollController.jumpTo(0.0);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
    if (widget.initialContainerId != null && widget.initialContainerId!.isNotEmpty) {
      _containerPath.add(widget.initialContainerId!);
    }
    _isCurtainExpanded = widget.startWithCurtainOpen;
    _scrollController = ScrollController();

    if (widget.initialTargetEntityId != null && widget.initialTargetEntityId!.isNotEmpty) {
      _resolveAndScrollToTargetEntity(widget.initialTargetEntityId!);
    }
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
    if (widget.initialTargetEntityId != oldWidget.initialTargetEntityId && widget.initialTargetEntityId != null) {
      _resolveAndScrollToTargetEntity(widget.initialTargetEntityId!);
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _highlightTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _resolveAndScrollToTargetEntity(String targetEntityId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final entities = ref.read(entityListProvider).asData?.value ?? [];
      final relations = ref.read(relationListProvider).asData?.value ?? [];
      final targetEntity = entities.where((e) => e.id == targetEntityId).firstOrNull;
      if (targetEntity == null) return;

      // Tracing container ancestry
      final guardadoRels = relations.where((r) => r.relationType == AppTechnicalStrings.relGuardadoEn).toList();
      final parentMap = {for (var r in guardadoRels) r.sourceEntityId: r.targetEntityId};

      final path = <String>[];
      var currentId = targetEntity.id;
      while (parentMap.containsKey(currentId)) {
        final parentId = parentMap[currentId]!;
        if (path.contains(parentId)) break; // cycle safety
        path.insert(0, parentId);
        currentId = parentId;
      }

      if (path.isNotEmpty) {
        setState(() {
          _containerPath = path;
          _selectedLocationId = null;
        });
      } else if (targetEntity.locationId != null) {
        setState(() {
          _containerPath = [];
          _selectedLocationId = targetEntity.locationId;
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToTargetEntity(targetEntityId);
      });
    });
  }

  void _scrollToTargetEntity(String targetEntityId) {
    if (!mounted || !_scrollController.hasClients) return;
    setState(() {
      _highlightEntityId = targetEntityId;
    });
    _highlightTimer?.cancel();
    _highlightTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _highlightEntityId = null;
        });
      }
    });

    final entities = ref.read(entityListProvider).asData?.value ?? [];
    final relations = ref.read(relationListProvider).asData?.value ?? [];
    final groupsContainerEntityIds = relations.where((r) => r.relationType == AppTechnicalStrings.relGuardadoEn).map((r) => r.targetEntityId).toSet();

    List<WorldEntity> activeList;
    if (_containerPath.isNotEmpty) {
      final activeContainerId = _containerPath.last;
      final childIds = relations
          .where((r) => r.relationType == AppTechnicalStrings.relGuardadoEn && r.targetEntityId == activeContainerId)
          .map((r) => r.sourceEntityId)
          .toSet();
      activeList = entities.where((e) => childIds.contains(e.id)).toList();
    } else {
      final containedIds = relations
          .where((r) => r.relationType == AppTechnicalStrings.relGuardadoEn)
          .map((r) => r.sourceEntityId)
          .toSet();
      activeList = entities.where((e) => !containedIds.contains(e.id)).toList();
      if (_selectedLocationId != null) {
        activeList = activeList.where((e) => e.locationId == _selectedLocationId).toList();
      }
    }

    final groups = EffectiveEntityGroup.groupEntities(
      entities: activeList,
      effectiveLocationMap: {for (var e in activeList) e.id: e.locationId},
      containerEntityIds: groupsContainerEntityIds,
    );

    final targetIndex = groups.indexWhere((g) => g.entities.any((e) => e.id == targetEntityId));
    if (targetIndex >= 0) {
      final viewMode = ref.read(inventoryViewModeProvider);
      double targetOffset;
      if (viewMode == ItemViewMode.minecraftGrid) {
        final row = targetIndex ~/ 4;
        const cellHeight = 90.0;
        targetOffset = (row * cellHeight).clamp(0.0, _scrollController.position.maxScrollExtent);
      } else {
        const itemHeight = 76.0;
        targetOffset = (targetIndex * itemHeight).clamp(0.0, _scrollController.position.maxScrollExtent);
      }

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    _autoScrollStep = 0.0;
  }

  void _startAutoScroll(double step) {
    _autoScrollStep = step;
    if (_autoScrollTimer != null && _autoScrollTimer!.isActive) return;
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      if (!_scrollController.hasClients) return;
      final target = (_scrollController.offset + _autoScrollStep).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.jumpTo(target);
    });
  }

  void _handlePointerAutoScroll(Offset globalPosition) {
    if (!_isDragging) return;

    if (_breadcrumbBarKey.currentState?.isCurtainExpanded == true) {
      _breadcrumbBarKey.currentState?.collapseCurtain();
    }

    final RenderBox? box = _inventoryCanvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !_scrollController.hasClients) {
      _stopAutoScroll();
      return;
    }

    final boxOffset = box.localToGlobal(Offset.zero);
    final topEdge = boxOffset.dy;
    final bottomEdge = boxOffset.dy + box.size.height;
    final pointerY = globalPosition.dy;
    final pointerX = globalPosition.dx;

    // Boundary check for horizontal axis
    if (pointerX < boxOffset.dx || pointerX > boxOffset.dx + box.size.width) {
      _stopAutoScroll();
      return;
    }

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
    _stopAutoScroll();
    _saveCurrentScrollOffset();
    if (_selectedLocationId != null || _locationHistory.isNotEmpty) {
      _locationHistory.add(_selectedLocationId);
    }
    if (_isDragging) {
      _dragHasNavigated = true;
    }
    setState(() {
      _selectedLocationId = newLocId;
      _expandedStackKeys.clear();
    });
    _restoreScrollOffsetForCurrentLevel();
  }

  void _handleBackNavigation() {
    _stopAutoScroll();
    if (_isSelectionMode) {
      setState(() {
        _isSelectionMode = false;
        _selectedEntityIds.clear();
      });
    } else if (_isCurtainExpanded || _breadcrumbBarKey.currentState?.isCurtainExpanded == true) {
      _breadcrumbBarKey.currentState?.collapseCurtain();
      setState(() => _isCurtainExpanded = false);
    } else if (_containerPath.isNotEmpty) {
      _saveCurrentScrollOffset();
      setState(() {
        _containerPath.removeLast();
        _expandedStackKeys.clear();
      });
      _restoreScrollOffsetForCurrentLevel();
    } else if (_locationHistory.isNotEmpty) {
      _saveCurrentScrollOffset();
      setState(() {
        _selectedLocationId = _locationHistory.removeLast();
        _expandedStackKeys.clear();
      });
      _restoreScrollOffsetForCurrentLevel();
    } else if (_selectedLocationId != null) {
      _saveCurrentScrollOffset();
      setState(() {
        _selectedLocationId = null;
        _expandedStackKeys.clear();
      });
      _restoreScrollOffsetForCurrentLevel();
    } else {
      context.goToHome();
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
        r.sourceEntityId == id && (r.relationType == AppTechnicalStrings.relGuardadoEn || r.relationType == AppTechnicalStrings.relParteDe)
      ).toList();

      if (existingInheriting.isEmpty && ent.locationId == targetLocId) {
        continue; // Already directly in target location, skip!
      }
      idsToMove.add(id);
    }

    if (idsToMove.isEmpty) return;

    // If moving to root Mundo (targetLocId == null) and entities come from an assigned location or container, ask for confirmation
    if (targetLocId == null) {
      final hasAssignedSource = idsToMove.any((id) {
        final ent = entityMap[id];
        if (ent == null) return false;
        final hasLocation = ent.locationId != null;
        final hasContainer = allRels.any((r) =>
          r.sourceEntityId == id && (r.relationType == AppTechnicalStrings.relGuardadoEn || r.relationType == AppTechnicalStrings.relParteDe)
        );
        return hasLocation || hasContainer;
      });

      if (hasAssignedSource) {
        final confirm = await AppConfirmationDialog.show(
          context: context,
          title: AppStrings.moveToWorldConfirmationTitle,
          message: AppStrings.moveToWorldConfirmationMessage(idsToMove.length),
        );
        if (confirm != true) return;
      }
    }

    for (final id in idsToMove) {
      final existingInheriting = allRels.where((r) =>
        r.sourceEntityId == id && (r.relationType == AppTechnicalStrings.relGuardadoEn || r.relationType == AppTechnicalStrings.relParteDe)
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
        r.relationType == AppTechnicalStrings.relGuardadoEn
      );
      if (isAlreadyInside) continue; // Already directly inside target container, skip!
      idsToMove.add(sourceId);
    }

    if (idsToMove.isEmpty) return;

    for (final sourceId in idsToMove) {
      await relationRepo.addRelation(EntityRelation(
        id: AppTechnicalStrings.compositeId(sourceId, targetContainerEntityId),
        sourceEntityId: sourceId,
        targetEntityId: targetContainerEntityId,
        relationType: AppTechnicalStrings.relGuardadoEn,
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
      _saveCurrentScrollOffset();
      setState(() {
        _containerPath.add(grp.primaryEntity.id);
      });
      _restoreScrollOffsetForCurrentLevel();
    } else if (grp.population == 1) {
      context.pushEntityDetail(grp.primaryEntity.id);
    } else {
      setState(() {
        _expandedStackKeys.add(grp.key);
      });
    }
  }

  Future<void> _handleDropOntoItem(Object payload, String targetEntityId, bool isContainer) async {
    final ids = _extractPayloadIds(payload);
    if (ids.isEmpty) return;

    if (isContainer) {
      await _moveEntitiesToContainer(ids, targetEntityId);
      return;
    }

    // Target is not yet a container, prompt for confirmation to turn it into a container
    final allEntities = ref.read(entityListProvider).asData?.value ?? [];
    final targetEntity = allEntities.where((e) => e.id == targetEntityId).firstOrNull;
    final catalog = ref.read(catalogListProvider).asData?.value ?? [];
    final targetSpecies = catalog.where((c) => c.id == targetEntity?.speciesId).firstOrNull;
    final targetName = targetSpecies?.name ?? AppStrings.typeObject;

    if (!mounted) return;

    final confirm = await AppConfirmationDialog.show(
      context: context,
      title: AppStrings.convertToContainerTitle,
      message: AppStrings.convertToContainerMessage(targetName, ids.length),
    );

    if (confirm != true) return;

    await _moveEntitiesToContainer(ids, targetEntityId);
  }

  Future<void> _deleteSelectedEntities() async {
    if (_selectedEntityIds.isEmpty) return;

    final confirm = await AppConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: AppStrings.deleteSelectionTitle,
      message: AppStrings.deleteElementsConfirmation(_selectedEntityIds.length),
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
    final guardadoEnRelations = relations.where((r) => r.relationType == AppTechnicalStrings.relGuardadoEn).toList();
    final Set<String> containedEntityIds = guardadoEnRelations.map((r) => r.sourceEntityId).toSet();
    final Map<String, List<String>> containerChildrenMap = {};
    for (final r in guardadoEnRelations) {
      containerChildrenMap.putIfAbsent(r.targetEntityId, () => []).add(r.sourceEntityId);
    }

    final directLocationsMap = {for (var e in allEntities) e.id: e.locationId};
    final effectiveLocationsMap = LocationResolver.resolveAllEffectiveLocations(
      entities: allEntities,
      directLocations: directLocationsMap,
      relations: relations,
    );

    // Filter entities by selected location (direct physical location only, excluding child locations)
    var filteredEntities = allEntities.toList();

    if (_selectedLocationId != null) {
      if (_selectedLocationId == AppTechnicalStrings.unassignedLocationId) {
        filteredEntities = filteredEntities.where((e) => e.locationId == null).toList();
      } else {
        filteredEntities = filteredEntities.where((e) => e.locationId == _selectedLocationId).toList();
      }
    }

    // Grouping container IDs set
    final groupsContainerEntityIds = relations.where((r) => r.relationType == AppTechnicalStrings.relGuardadoEn).map((r) => r.targetEntityId).toSet();

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
    final viewMode = ref.watch(inventoryViewModeProvider);

    return PopScope(
      canPop: !canGoBack && !_isSelectionMode && !_isCurtainExpanded && _breadcrumbBarKey.currentState?.isCurtainExpanded != true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_containerPath.isNotEmpty ? (activeContainerSpecies?.name ?? AppStrings.containerLabel) : AppStrings.inventoryTitle),
          leading: canGoBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: AppStrings.goBackAction,
                  onPressed: _handleBackNavigation,
                )
              : null,
          actions: [
            // 2-Way View Mode Switcher (Persisted independently)
            ViewModeToggleButton(
              viewMode: viewMode,
              onChanged: (mode) => ref.read(inventoryViewModeProvider.notifier).setMode(mode),
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

        body: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: (event) => _handlePointerAutoScroll(event.position),
          onPointerUp: (_) => _stopAutoScroll(),
          onPointerCancel: (_) => _stopAutoScroll(),
          child: Column(
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
                onCurtainExpandedChanged: (expanded) {
                  setState(() => _isCurtainExpanded = expanded);
                },
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
                  _stopAutoScroll();
                  if (_isDragging) _dragHasNavigated = true;
                  _saveCurrentScrollOffset();
                  setState(() {
                    _containerPath.removeRange(idx + 1, _containerPath.length);
                  });
                  _restoreScrollOffsetForCurrentLevel();
                },
                onExitContainersToRoot: () {
                  _stopAutoScroll();
                  if (_isDragging) _dragHasNavigated = true;
                  _saveCurrentScrollOffset();
                  setState(() {
                    _containerPath.clear();
                    _selectedLocationId = null;
                    _locationHistory.clear();
                  });
                  _restoreScrollOffsetForCurrentLevel();
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
                    return Container(
                      key: _inventoryCanvasKey,
                      child: DragTarget<Object>(
                        onWillAcceptWithDetails: (details) => true,
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
                                              ? AppStrings.emptyContainerPrompt
                                              : AppStrings.emptyLocationPrompt,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                                        ),
                                      ],
                                    ),
                                  )
                                : _buildInventoryContent(
                                    currentGroups,
                                    childLocations,
                                    locationNodes,
                                    catalogMap,
                                    containerChildrenMap,
                                    allEntities,
                                    effectiveLocationsMap,
                                    viewMode,
                                  ),
                          );
                        },
                      ),
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
                          AppStrings.selectedCount(_selectedEntityIds.length),
                          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.drive_file_move_outlined),
                              tooltip: AppStrings.moveSelectionAction,
                              onPressed: () async {
                                final allEntities = ref.read(entityListProvider).asData?.value ?? [];
                                final selectedEntities = allEntities.where((e) => _selectedEntityIds.contains(e.id)).toList();
                                if (selectedEntities.isEmpty) return;

                                final changed = await LocationOrContainerCorrectionSheet.show(
                                  context,
                                  entities: selectedEntities,
                                );
                                if (changed == true && mounted) {
                                  _refreshAllState();
                                  setState(() {
                                    _selectedEntityIds.clear();
                                    _isSelectionMode = false;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: AppStrings.deleteSelectionAction,
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
      ),
    );
  }

  List<String> _extractPayloadIds(Object? payload) {
    if (payload is List<String>) {
      return payload;
    } else if (payload is String) {
      return [payload];
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
    List<LocationNode> allLocations,
    Map<String, CatalogItem> catalogMap,
    Map<String, List<String>> containerChildrenMap,
    List<WorldEntity> allEntities,
    Map<String, String?> effectiveLocationsMap,
    FinderViewMode viewMode,
  ) {
    final bottomClearance = MediaQuery.paddingOf(context).bottom + 84.0;

    // Flatten groups into display items: individualized in-place if expanded, or visual stack if collapsed
    final List<EffectiveEntityGroup> displayGroups = [];
    final Set<String> activeStackKeys = {};

    for (final grp in currentGroups) {
      final isContained = grp.entities
          .expand((e) => containerChildrenMap[e.id] ?? <String>[])
          .isNotEmpty;

      if (!isContained && grp.population > 1 && _expandedStackKeys.contains(grp.key)) {
        for (final entity in grp.entities) {
          displayGroups.add(EffectiveEntityGroup(
            key: AppTechnicalStrings.compositeKey(grp.key, entity.id),
            speciesId: grp.speciesId,
            effectiveLocationId: grp.effectiveLocationId,
            entities: [entity],
          ));
        }
      } else {
        displayGroups.add(grp);
        if (!isContained && grp.population > 1) {
          activeStackKeys.add(grp.key);
        }
      }
    }

    final totalCount = displayGroups.length + childLocations.length;

    // Recursive items count map for child locations (includes all descendant locations and container contents)
    final locRepo = LocationRepository(ref.read(databaseProvider));
    final recursiveItemCountMap = <String, int>{};
    for (final loc in childLocations) {
      final descendantIds = locRepo.getDescendantIds(loc.id, allLocations);
      final branchLocIds = {loc.id, ...descendantIds};
      recursiveItemCountMap[loc.id] = allEntities
          .where((e) {
            final effLoc = effectiveLocationsMap[e.id];
            return effLoc != null && branchLocIds.contains(effLoc);
          })
          .length;
    }

    if (viewMode == FinderViewMode.minecraftGrid) {
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
          if (idx < displayGroups.length) {
            final grp = displayGroups[idx];
            final primary = grp.primaryEntity;
            final species = catalogMap[grp.speciesId];
            final isSelected = _selectedEntityIds.contains(primary.id);
            final isExpired = grp.expiredCount(now: DateTime.now()) > 0;
            final containedIds = grp.entities
                .expand((e) => containerChildrenMap[e.id] ?? <String>[])
                .toSet()
                .toList();
            final isContainer = containedIds.isNotEmpty;
            final isStack = !isContainer && grp.population > 1 && !_expandedStackKeys.contains(grp.key);
            final isHighlighted = _highlightEntityId != null && grp.entities.any((e) => e.id == _highlightEntityId);

            return InventoryItemInteractionWrapper(
              group: grp,
              isSelected: isSelected,
              isSelectionMode: _isSelectionMode,
              selectedEntityIds: _selectedEntityIds,
              isContainer: isContainer,
              isStack: isStack,
              isHighlighted: isHighlighted,
              onTap: () => _handleItemTap(grp, isContainer),
              onDropIntoContainer: _handleDropOntoItem,
              onDragStarted: _handleDragStarted,
              onDragEnd: _handleDragEnd,
              onHoverSpringLoaded: (targetKey) {
                _stopAutoScroll();
                if (activeStackKeys.contains(targetKey)) {
                  if (_isDragging) _dragHasNavigated = true;
                  setState(() => _expandedStackKeys.add(targetKey));
                } else if (!_containerPath.contains(targetKey)) {
                  if (_isDragging) _dragHasNavigated = true;
                  setState(() => _containerPath.add(targetKey));
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
            final locNode = childLocations[idx - displayGroups.length];
            return _LocationItemInteractionTile(
              key: ValueKey(AppTechnicalStrings.locTileKey(locNode.id)),
              node: locNode,
              itemCount: recursiveItemCountMap[locNode.id] ?? 0,
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
          if (idx < displayGroups.length) {
            final grp = displayGroups[idx];
            final primary = grp.primaryEntity;
            final primaryId = primary.id;
            final isSelected = _selectedEntityIds.contains(primaryId);

            final containedIds = grp.entities
                .expand((e) => containerChildrenMap[e.id] ?? <String>[])
                .toSet()
                .toList();
            final isContainer = containedIds.isNotEmpty;
            final isStack = !isContainer && grp.population > 1 && !_expandedStackKeys.contains(grp.key);
            final isHighlighted = _highlightEntityId != null && grp.entities.any((e) => e.id == _highlightEntityId);

            return InventoryItemInteractionWrapper(
              group: grp,
              isSelected: isSelected,
              isSelectionMode: _isSelectionMode,
              selectedEntityIds: _selectedEntityIds,
              isContainer: isContainer,
              isStack: isStack,
              isHighlighted: isHighlighted,
              onTap: () => _handleItemTap(grp, isContainer),
              onDropIntoContainer: _handleDropOntoItem,
              onDragStarted: _handleDragStarted,
              onDragEnd: _handleDragEnd,
              onHoverSpringLoaded: (targetKey) {
                _stopAutoScroll();
                if (activeStackKeys.contains(targetKey)) {
                  if (_isDragging) _dragHasNavigated = true;
                  setState(() => _expandedStackKeys.add(targetKey));
                } else if (!_containerPath.contains(targetKey)) {
                  if (_isDragging) _dragHasNavigated = true;
                  setState(() => _containerPath.add(targetKey));
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
            final locNode = childLocations[idx - displayGroups.length];
            return _LocationItemInteractionTile(
              key: ValueKey(AppTechnicalStrings.locTileKey(locNode.id)),
              node: locNode,
              itemCount: recursiveItemCountMap[locNode.id] ?? 0,
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
  final int itemCount;
  final FinderViewMode viewMode;
  final VoidCallback onTap;
  final Function(Object payload, String targetLocationId) onDrop;
  final ValueChanged<String> onSpringLoad;

  const _LocationItemInteractionTile({
    super.key,
    required this.node,
    required this.itemCount,
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
                  if (widget.itemCount > 0)
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
                          AppStrings.countString(widget.itemCount),
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
                              : AppStrings.objectsCount(widget.itemCount),
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
