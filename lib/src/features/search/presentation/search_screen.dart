import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/entity_tile.dart';
import '../../history/domain/activity_event.dart';
import '../../locations/domain/location_node.dart';
import '../../locations/presentation/location_tile.dart';
import '../domain/sql_preset.dart';

enum SqlResultViewMode {
  table,
  tiles,
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _selectedScope = AppStrings.all;
  SqlPresetCategory _selectedSqlCategory = SqlPresetCategory.all;
  SqlResultViewMode _viewMode = SqlResultViewMode.table;
  final TextEditingController _sqlController = TextEditingController(text: 'SELECT * FROM catalog_table LIMIT 20;');

  bool _isExecutingSql = false;
  List<String> _sqlColumns = [];
  List<List<dynamic>> _sqlRows = [];
  String? _sqlError;

  final List<String> _scopes = [
    AppStrings.all,
    AppStrings.objectsLabel,
    AppStrings.tabContainers,
    AppStrings.tabLocations,
    AppStrings.tabCatalog,
    AppStrings.tabHistory,
    AppStrings.arbitrarySqlQueryLabel,
  ];

  @override
  void dispose() {
    _sqlController.dispose();
    super.dispose();
  }

  Future<void> _executeSqlQuery() async {
    final queryStr = _sqlController.text.trim();
    if (queryStr.isEmpty) return;

    final forbiddenKeywords = ['INSERT', 'UPDATE', 'DELETE', 'DROP', 'ALTER', 'CREATE', 'REPLACE', 'TRUNCATE'];

    for (final kw in forbiddenKeywords) {
      if (RegExp(r'\b' + kw + r'\b', caseSensitive: false).hasMatch(queryStr)) {
        setState(() {
          _sqlError = AppStrings.sqlSecurityErrorPrefix + kw + AppStrings.sqlSecurityErrorSuffix;
          _sqlColumns = [];
          _sqlRows = [];
        });
        return;
      }
    }

    setState(() {
      _isExecutingSql = true;
      _sqlError = null;
    });

    try {
      final db = ref.read(databaseProvider);
      final results = await db.customSelect(queryStr).get();

      if (results.isEmpty) {
        setState(() {
          _sqlColumns = [];
          _sqlRows = [];
          _sqlError = AppStrings.sqlNoRowsReturned;
        });
      } else {
        final firstRowData = results.first.data;
        final columns = firstRowData.keys.toList();
        final List<List<dynamic>> rows = [];

        for (final row in results) {
          rows.add(columns.map((col) => row.data[col]).toList());
        }

        setState(() {
          _sqlColumns = columns;
          _sqlRows = rows;
          _sqlError = null;
        });
      }
    } catch (e) {
      setState(() {
        _sqlError = AppStrings.sqlSyntaxErrorPrefix + e.toString();
        _sqlColumns = [];
        _sqlRows = [];
      });
    } finally {
      if (mounted) setState(() => _isExecutingSql = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final activityState = ref.watch(recentActivityProvider);

    final isSqlMode = _selectedScope == AppStrings.arbitrarySqlQueryLabel;

    return Scaffold(
      appBar: AppBar(
        title: isSqlMode
            ? const Text(AppStrings.arbitrarySqlConsoleTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
            : TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: AppStrings.searchDetailedHint,
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  ref.read(searchQueryProvider.notifier).state = val;
                },
              ),
        actions: [
          if (!isSqlMode && query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips (Todos, Objetos, Ubicaciones, Catálogo, Historial, Consulta SQL)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _scopes.map((scope) {
                final isSelected = _selectedScope == scope;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(scope),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedScope = scope);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: isSqlMode
                ? _buildSqlRunnerView(context)
                : _buildSearchResults(
                    context,
                    ref,
                    query,
                    searchResultsAsync,
                    locationsState,
                    catalogState,
                    activityState,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSqlRunnerView(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category filter row for SQL Presets
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: SqlPresetCategory.values.map((category) {
                final isSelected = _selectedSqlCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text(
                      category.displayName,
                      style: const TextStyle(fontSize: 11),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedSqlCategory = category);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),

          // Preset SQL Samples
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: SqlPreset.defaultPresets
                  .where((p) => _selectedSqlCategory == SqlPresetCategory.all || p.category == _selectedSqlCategory)
                  .map((preset) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ActionChip(
                    label: Text(preset.title, style: const TextStyle(fontSize: 11)),
                    onPressed: () {
                      _sqlController.text = preset.query;
                      _executeSqlQuery();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // SQL Input Field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sqlController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: AppStrings.arbitrarySqlQueryLabel,
                    hintText: AppStrings.selectSqlHint,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _isExecutingSql ? null : _executeSqlQuery,
                icon: const Icon(Icons.play_arrow),
                label: const Text(AppStrings.executeAction),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // SQL Error Banner
          if (_sqlError != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_sqlError!, style: const TextStyle(fontSize: 12, color: Colors.redAccent))),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // SQL Results View
          Expanded(
            child: _isExecutingSql
                ? const Center(child: CircularProgressIndicator())
                : _sqlColumns.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.sqlHelpHint,
                          style: TextStyle(color: theme.hintColor),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppStrings.rowsRetrievedPrefix}${_sqlRows.length}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              SegmentedButton<SqlResultViewMode>(
                                segments: const [
                                  ButtonSegment(
                                    value: SqlResultViewMode.table,
                                    icon: Icon(Icons.table_chart_outlined, size: 14),
                                    label: Text(AppStrings.viewModeTable, style: TextStyle(fontSize: 11)),
                                  ),
                                  ButtonSegment(
                                    value: SqlResultViewMode.tiles,
                                    icon: Icon(Icons.view_agenda_outlined, size: 14),
                                    label: Text(AppStrings.viewModeTiles, style: TextStyle(fontSize: 11)),
                                  ),
                                ],
                                selected: {_viewMode},
                                onSelectionChanged: (newSelection) {
                                  setState(() => _viewMode = newSelection.first);
                                },
                                style: SegmentedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _viewMode == SqlResultViewMode.table
                                ? _buildSqlTableResults(theme)
                                : _buildSqlTilesResults(context),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSqlTableResults(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.all(color: theme.dividerColor, width: 0.5),
          columnSpacing: 16,
          headingRowColor: MaterialStateProperty.all(theme.colorScheme.primary.withAlpha(20)),
          columns: _sqlColumns.map((col) {
            return DataColumn(
              label: Text(
                col,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            );
          }).toList(),
          rows: _sqlRows.map((row) {
            return DataRow(
              cells: row.map((cell) {
                final cellStr = cell != null ? cell.toString() : 'NULL';
                return DataCell(
                  Text(cellStr, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSqlTilesResults(BuildContext context) {
    final allEntities = ref.watch(entityListProvider).asData?.value ?? [];
    final allCatalog = ref.watch(catalogListProvider).asData?.value ?? [];
    final allLocations = ref.watch(locationNodeListProvider).asData?.value ?? [];

    // 1. Try to find entity IDs
    final entityIdColIndex = _sqlColumns.indexWhere((c) =>
        ['id', 'instance_id', 'entity_id', 'source_entity_id', 'target_entity_id', 'entity_a', 'entity_b']
            .contains(c.toLowerCase()));

    if (entityIdColIndex != -1) {
      final matchingEntities = <WorldEntity>[];
      final seenIds = <String>{};

      for (final row in _sqlRows) {
        final idVal = row[entityIdColIndex]?.toString();
        if (idVal != null && !seenIds.contains(idVal)) {
          final ent = allEntities.where((e) => e.id == idVal).firstOrNull;
          if (ent != null) {
            matchingEntities.add(ent);
            seenIds.add(idVal);
          }
        }
      }

      if (matchingEntities.isNotEmpty) {
        return ListView.builder(
          itemCount: matchingEntities.length,
          itemBuilder: (ctx, idx) => EntityTile(entity: matchingEntities[idx]),
        );
      }
    }

    // 2. Try to find species IDs
    final speciesIdColIndex = _sqlColumns.indexWhere((c) =>
        ['id', 'species_id'].contains(c.toLowerCase()));

    if (speciesIdColIndex != -1) {
      final matchingSpecies = <CatalogItem>[];
      final seenSpecies = <String>{};

      for (final row in _sqlRows) {
        final spId = row[speciesIdColIndex]?.toString();
        if (spId != null && !seenSpecies.contains(spId)) {
          final sp = allCatalog.where((c) => c.id == spId).firstOrNull;
          if (sp != null) {
            matchingSpecies.add(sp);
            seenSpecies.add(spId);
          }
        }
      }

      if (matchingSpecies.isNotEmpty) {
        return ListView.builder(
          itemCount: matchingSpecies.length,
          itemBuilder: (ctx, idx) => SpeciesTile(species: matchingSpecies[idx]),
        );
      }
    }

    // 3. Try to find location IDs
    final locIdColIndex = _sqlColumns.indexWhere((c) =>
        ['id', 'location_id', 'parent_location_id'].contains(c.toLowerCase()));

    if (locIdColIndex != -1) {
      final matchingLocations = <LocationNode>[];
      final seenLocs = <String>{};

      for (final row in _sqlRows) {
        final locId = row[locIdColIndex]?.toString();
        if (locId != null && !seenLocs.contains(locId)) {
          final loc = allLocations.where((l) => l.id == locId).firstOrNull;
          if (loc != null) {
            matchingLocations.add(loc);
            seenLocs.add(locId);
          }
        }
      }

      if (matchingLocations.isNotEmpty) {
        return ListView.builder(
          itemCount: matchingLocations.length,
          itemBuilder: (ctx, idx) => LocationTile(
            node: matchingLocations[idx],
            onTap: () => context.go('/locations'),
          ),
        );
      }
    }

    // 4. Generic structured Tile Cards for other queries
    return ListView.builder(
      itemCount: _sqlRows.length,
      itemBuilder: (ctx, idx) {
        final row = _sqlRows[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _sqlColumns.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_sqlColumns[i]}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Expanded(
                          child: Text(
                            row[i] != null ? row[i].toString() : 'NULL',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    WidgetRef ref,
    String query,
    AsyncValue<List<WorldEntity>> searchResultsAsync,
    AsyncValue<List<LocationNode>> locationsState,
    AsyncValue<List<CatalogItem>> catalogState,
    AsyncValue<List<ActivityEvent>> activityState,
  ) {
    final theme = Theme.of(context);
    final cleanQuery = query.toLowerCase().trim();

    // 0. Contenedores (Entities that are target of GUARDADO_EN relations)
    if (_selectedScope == AppStrings.tabContainers) {
      final relations = ref.watch(relationListProvider).asData?.value ?? [];
      final entities = ref.watch(entityListProvider).asData?.value ?? [];
      final catalogItems = catalogState.asData?.value ?? [];

      final containerEntityIds = relations
          .where((r) => r.relationType == 'GUARDADO_EN')
          .map((r) => r.targetEntityId)
          .toSet();

      final containerEntities = entities.where((e) {
        if (!containerEntityIds.contains(e.id)) return false;
        if (cleanQuery.isEmpty) return true;
        final species = catalogItems.where((c) => c.id == e.speciesId).firstOrNull;
        return (species?.name.toLowerCase().contains(cleanQuery) ?? false) ||
            e.id.toLowerCase().contains(cleanQuery) ||
            (e.notes?.toLowerCase().contains(cleanQuery) ?? false);
      }).toList();

      if (containerEntities.isEmpty) {
        return const Center(child: Text(AppStrings.emptyContainersSearch));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: containerEntities.length,
        itemBuilder: (ctx, idx) {
          return EntityTile(entity: containerEntities[idx]);
        },
      );
    }

    // 1. Ubicaciones (Strictly typed LocationNode)
    if (_selectedScope == AppStrings.tabLocations) {
      final nodes = locationsState.asData?.value ?? <LocationNode>[];
      final filtered = nodes.where((LocationNode n) =>
        n.name.toLowerCase().contains(cleanQuery) ||
        (n.description?.toLowerCase().contains(cleanQuery) ?? false)
      ).toList();
      if (filtered.isEmpty) return const Center(child: Text(AppStrings.emptyLocation));

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (ctx, idx) {
          final n = filtered[idx];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.amber),
              title: Text(n.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(n.description ?? AppStrings.locationGraphNode),
              onTap: () => context.go('/locations'),
            ),
          );
        },
      );
    }

    // 2. Catálogo (Strictly typed CatalogItem)
    if (_selectedScope == AppStrings.tabCatalog) {
      final species = catalogState.asData?.value ?? <CatalogItem>[];
      final filtered = species.where((CatalogItem s) =>
        s.name.toLowerCase().contains(cleanQuery) ||
        s.type.toLowerCase().contains(cleanQuery) ||
        (s.description?.toLowerCase().contains(cleanQuery) ?? false)
      ).toList();

      if (filtered.isEmpty) return const Center(child: Text(AppStrings.emptyCatalog));

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (ctx, idx) {
          return SpeciesTile(species: filtered[idx]);
        },
      );
    }

    // 3. Historial (Strictly typed ActivityEvent)
    if (_selectedScope == AppStrings.tabHistory) {
      final events = activityState.asData?.value ?? <ActivityEvent>[];
      final filtered = events.where((ActivityEvent e) => e.description.toLowerCase().contains(cleanQuery)).toList();
      if (filtered.isEmpty) return const Center(child: Text(AppStrings.noHistoryResults));

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (ctx, idx) {
          final evt = filtered[idx];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(evt.description),
            subtitle: Text(evt.timestamp.toString().substring(0, 16)),
          );
        },
      );
    }

    // 4. Objetos / Todos (Resultados Refactorizados con búsqueda multinivel)
    return searchResultsAsync.when(
      data: (entities) {
        if (entities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: theme.colorScheme.primary.withAlpha(100)),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noSearchMatchesPrefix + query + AppStrings.noSearchMatchesSuffix,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entities.length,
          itemBuilder: (context, index) {
            return EntityTile(entity: entities[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${AppStrings.errorPrefix}$err')),
    );
  }
}
