import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/presentation/web_image_picker_dialog.dart';
import '../../entities/domain/effective_entity_group.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/effective_group_tile.dart';
import '../../entities/presentation/minecraft_tile_widget.dart';
import '../../locations/domain/location_node.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../../locations/presentation/top_curtain_location_sheet.dart';

enum FinderViewMode { detailedList, standardGrid, minecraftGrid }

class InventoryFinderScreen extends ConsumerStatefulWidget {
  const InventoryFinderScreen({super.key});

  @override
  ConsumerState<InventoryFinderScreen> createState() => _InventoryFinderScreenState();
}

class _InventoryFinderScreenState extends ConsumerState<InventoryFinderScreen> {
  String? _selectedLocationId; // Null means "Todas las Ubicaciones"
  bool _isSelectionMode = false;
  final Set<String> _selectedEntityIds = {};
  String _selectedTypeFilter = AppStrings.all;
  FinderViewMode _viewMode = FinderViewMode.detailedList;

  // Set of expanded container entity IDs (for inline expansion of contained tiles)
  final Set<String> _expandedContainerEntityIds = {};

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
      AppToast.showSuccess(context, 'Movido(s) correctamente.');
    }
  }

  Future<void> _deleteSelectedEntities() async {
    if (_selectedEntityIds.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Selección'),
        content: Text('¿Deseas eliminar ${_selectedEntityIds.length} elementos seleccionados?'),
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

    if (mounted) AppToast.showSuccess(context, 'Elementos eliminados.');
  }

  Future<void> _bulkWebImageSearch() async {
    if (_selectedEntityIds.isEmpty) return;
    final allEntities = ref.read(entityListProvider).asData?.value ?? [];
    final catalog = ref.read(catalogListProvider).asData?.value ?? [];

    final firstEntity = allEntities.where((e) => _selectedEntityIds.contains(e.id)).firstOrNull;
    if (firstEntity == null) return;

    final species = catalog.where((c) => c.id == firstEntity.speciesId).firstOrNull;
    if (species == null) return;

    await WebImagePickerDialog.show(context, searchQuery: species.name, targetSpecies: species);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);

    final catalogItems = catalogState.asData?.value ?? [];
    final locationNodes = locationsState.asData?.value ?? [];
    final allEntities = entitiesState.asData?.value ?? [];

    // Map catalog items by ID for fast lookup
    final catalogMap = {for (var c in catalogItems) c.id: c};

    // Filter entities by selected location
    var filteredEntities = allEntities.toList();

    if (_selectedLocationId != null) {
      if (_selectedLocationId == '__UNASSIGNED__') {
        filteredEntities = filteredEntities.where((e) => e.locationId == null).toList();
      } else {
        filteredEntities = filteredEntities.where((e) => e.locationId == _selectedLocationId).toList();
      }
    }

    // Filter by type
    if (_selectedTypeFilter != AppStrings.all) {
      filteredEntities = filteredEntities.where((e) {
        final species = catalogMap[e.speciesId];
        return species?.type == _selectedTypeFilter;
      }).toList();
    }

    // Group into effective groups
    final groups = EffectiveEntityGroup.groupEntities(
      entities: filteredEntities,
      effectiveLocationMap: {for (var e in filteredEntities) e.id: e.locationId},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario Finder'),
        actions: [
          // 3-Way View Mode Switcher
          IconButton(
            icon: Icon(
              _viewMode == FinderViewMode.detailedList
                  ? Icons.view_list
                  : (_viewMode == FinderViewMode.standardGrid ? Icons.grid_view : Icons.apps),
            ),
            tooltip: 'Cambiar Vista (Lista / Cuadrícula / Minecraft)',
            onPressed: () {
              setState(() {
                if (_viewMode == FinderViewMode.detailedList) {
                  _viewMode = FinderViewMode.standardGrid;
                } else if (_viewMode == FinderViewMode.standardGrid) {
                  _viewMode = FinderViewMode.minecraftGrid;
                } else {
                  _viewMode = FinderViewMode.detailedList;
                }
              });
            },
          ),
          IconButton(
            icon: Icon(_isSelectionMode ? Icons.check_box : Icons.select_all),
            tooltip: _isSelectionMode ? 'Cancelar Selección' : 'Selección Múltiple',
            onPressed: () {
              setState(() {
                _isSelectionMode = !_isSelectionMode;
                _selectedEntityIds.clear();
              });
            },
          ),
        ],
      ),

      // Single Round FAB '+' (Rule 1.c - No text)
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: (_isSelectionMode && _selectedEntityIds.isNotEmpty) ? 60.0 : 0.0),
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () => context.push('/create-master'),
          tooltip: 'Crear o Instanciar',
          child: const Icon(Icons.add),
        ),
      ),

      body: Column(
        children: [
          // Top Curtain Location Sheet & Breadcrumb Route Bar (Rule 1.b)
          TopCurtainLocationSheet(
            allLocations: locationNodes,
            selectedLocationId: _selectedLocationId,
            onLocationSelected: (locId) => setState(() => _selectedLocationId = locId),
            onDropOnLocation: (payload, targetLocId) {
              if (payload is EffectiveEntityGroup) {
                final ids = payload.entities.map((e) => e.id).toList();
                _moveEntitiesToLocation(ids, targetLocId);
              } else if (payload is WorldEntity) {
                _moveEntitiesToLocation([payload.id], targetLocId);
              } else if (payload is String) {
                _moveEntitiesToLocation([payload], targetLocId);
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

          // Main Inventory Grid / List View (Supporting 3 View Modes + Universal Drag & Drop)
          Expanded(
            child: groups.isEmpty
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
                : _buildInventoryContent(groups, catalogMap),
          ),

          // Floating Bulk Actions Bar (Rule 1.d - Fixed overlap)
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
                        icon: const Icon(Icons.image_search),
                        tooltip: 'Buscar Imagen Web',
                        onPressed: _bulkWebImageSearch,
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

  Widget _buildInventoryContent(List<EffectiveEntityGroup> groups, Map<String, dynamic> catalogMap) {
    final theme = Theme.of(context);

    if (_viewMode == FinderViewMode.minecraftGrid) {
      // 3. Minecraft Grid Mode (Square tiles with quantity badge overlay & status)
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: groups.length,
        itemBuilder: (ctx, idx) {
          final grp = groups[idx];
          final primary = grp.primaryEntity;
          final species = catalogMap[grp.speciesId];
          final isSelected = _selectedEntityIds.contains(primary.id);
          final isExpired = grp.expiredCount(now: DateTime.now()) > 0;

          return MinecraftTileWidget(
            group: grp,
            title: species?.name ?? 'Elemento',
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
    } else if (_viewMode == FinderViewMode.standardGrid) {
      // 2. Standard Grid Mode
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: groups.length,
        itemBuilder: (ctx, idx) {
          final grp = groups[idx];
          return EffectiveGroupTile(group: grp);
        },
      );
    }

    // 1. Detailed List Mode
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: groups.length,
      itemBuilder: (ctx, idx) {
        final grp = groups[idx];
        final primaryId = grp.primaryEntity.id;
        final isSelected = _selectedEntityIds.contains(primaryId);

        final tileWidget = EffectiveGroupTile(group: grp);

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

        return Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleSelection(primaryId),
            ),
            Expanded(child: tileWidget),
          ],
        );
      },
    );
  }
}
