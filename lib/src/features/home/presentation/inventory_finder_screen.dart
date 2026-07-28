import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/backup_settings_dialog.dart';
import '../../catalog/presentation/web_image_picker_dialog.dart';
import '../../entities/domain/effective_entity_group.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/effective_group_tile.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../../locations/domain/location_node.dart';
import '../../locations/domain/location_path_helper.dart';
import '../../locations/presentation/location_tree_picker.dart';

class InventoryFinderScreen extends ConsumerStatefulWidget {
  const InventoryFinderScreen({super.key});

  @override
  ConsumerState<InventoryFinderScreen> createState() => _InventoryFinderScreenState();
}

class _InventoryFinderScreenState extends ConsumerState<InventoryFinderScreen> {
  bool _isSidebarOpen = true;
  String? _selectedLocationId; // Null means "Todas las Instancias"
  bool _isSelectionMode = false;
  final Set<String> _selectedEntityIds = {};
  String _selectedTypeFilter = AppStrings.all;

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

  Future<void> _moveSelectedEntitiesToLocation(String? targetLocId) async {
    if (_selectedEntityIds.isEmpty) return;

    final repo = ref.read(entityRepositoryProvider);
    for (final id in _selectedEntityIds) {
      await repo.moveEntity(id, targetLocId);
    }
    ref.read(entityListProvider.notifier).loadEntities();

    setState(() {
      _selectedEntityIds.clear();
      _isSelectionMode = false;
    });

    if (mounted) {
      AppToast.showSuccess(context, 'Elementos movidos correctamente.');
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
    ref.read(entityListProvider.notifier).loadEntities();

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
        final species = catalogItems.where((c) => c.id == e.speciesId).firstOrNull;
        return species?.type == _selectedTypeFilter;
      }).toList();
    }

    // Group into effective groups
    final groups = EffectiveEntityGroup.groupEntities(
      entities: filteredEntities,
      effectiveLocationMap: {for (var e in filteredEntities) e.id: e.locationId},
    );

    // Build Route Bar Breadcrumbs
    final currentLocationNode = locationNodes.where((n) => n.id == _selectedLocationId).firstOrNull;
    final breadcrumb = currentLocationNode != null
        ? LocationPathHelper.buildBreadcrumbPath(currentLocationNode.id, locationNodes)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario Finder'),
        leading: IconButton(
          icon: Icon(_isSidebarOpen ? Icons.view_sidebar : Icons.view_sidebar_outlined),
          tooltip: 'Conmutar Barra Lateral',
          onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
        ),
        actions: [
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
          IconButton(
            icon: const Icon(Icons.backup_outlined),
            tooltip: 'Respaldos',
            onPressed: () => BackupSettingsDialog.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.push('/create-master'),
        icon: const Icon(Icons.add),
        label: const Text('Crear / Instanciar'),
      ),
      body: Row(
        children: [
          // Sidebar Tree Navigation
          if (_isSidebarOpen)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 230,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                border: Border(right: BorderSide(color: theme.dividerColor)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Ubicaciones',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    selected: _selectedLocationId == null,
                    leading: const Icon(Icons.all_inbox, size: 18),
                    title: const Text('Todas las Instancias', style: TextStyle(fontSize: 12)),
                    onTap: () => setState(() => _selectedLocationId = null),
                  ),
                  ListTile(
                    dense: true,
                    selected: _selectedLocationId == '__UNASSIGNED__',
                    leading: const Icon(Icons.folder_off_outlined, size: 18),
                    title: const Text('Sin Ubicación', style: TextStyle(fontSize: 12)),
                    onTap: () => setState(() => _selectedLocationId = '__UNASSIGNED__'),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: locationNodes.length,
                      itemBuilder: (ctx, idx) {
                        final node = locationNodes[idx];
                        final isSelected = _selectedLocationId == node.id;

                        // Minecraft-style DragTarget for sidebar location nodes
                        return DragTarget<String>(
                          onAcceptWithDetails: (details) {
                            final entityId = details.data;
                            if (_selectedEntityIds.contains(entityId)) {
                              _moveSelectedEntitiesToLocation(node.id);
                            } else {
                              ref.read(entityRepositoryProvider).moveEntity(entityId, node.id);
                              ref.read(entityListProvider.notifier).loadEntities();
                              AppToast.showSuccess(context, 'Movido a ${node.name}');
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            final isHovered = candidateData.isNotEmpty;
                            return Container(
                              color: isHovered ? theme.colorScheme.primaryContainer.withAlpha(120) : null,
                              child: ListTile(
                                dense: true,
                                selected: isSelected,
                                leading: Icon(
                                  Icons.folder_outlined,
                                  size: 18,
                                  color: isSelected ? theme.colorScheme.primary : null,
                                ),
                                title: Text(
                                  node.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                onTap: () => setState(() => _selectedLocationId = node.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Main Finder Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route Bar Breadcrumb
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                  child: Row(
                    children: [
                      Icon(Icons.near_me_outlined, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedLocationId == null
                              ? 'Raíz > Todas las Instancias'
                              : (_selectedLocationId == '__UNASSIGNED__'
                                  ? 'Raíz > Sin Ubicación'
                                  : 'Raíz > ${breadcrumb?.ancestorPath ?? ""} ${breadcrumb?.targetName ?? ""}'),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter Chips
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

                // Inventory List View
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
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: groups.length,
                          itemBuilder: (ctx, idx) {
                            final grp = groups[idx];
                            final primaryId = grp.primaryEntity.id;
                            final isSelected = _selectedEntityIds.contains(primaryId);

                            final tileWidget = EffectiveGroupTile(group: grp);

                            if (!_isSelectionMode) {
                              // Minecraft-style Draggable item
                              return LongPressDraggable<String>(
                                data: primaryId,
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

                            // Selection mode with checkbox
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
                        ),
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
                                  await _moveSelectedEntitiesToLocation(res.locationId);
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
          ),
        ],
      ),
    );
  }
}
