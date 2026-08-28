import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../catalog/presentation/subspecies_tile.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/entity_tile.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../history/domain/activity_event.dart';
import '../../locations/domain/location_node.dart';
import '../../locations/infrastructure/location_repository.dart';
import '../../locations/presentation/location_tile.dart';
import '../domain/sql_preset.dart';
import 'sql_editor_full_screen_view.dart';

enum SqlResultViewMode {
  table,
  tiles,
}

enum HistoryDateFilterPreset {
  all,
  today,
  last7Days,
  last30Days,
  thisMonth,
  thisYear,
  customRange,
}

extension HistoryDateFilterPresetX on HistoryDateFilterPreset {
  String get displayName {
    switch (this) {
      case HistoryDateFilterPreset.all:
        return AppStrings.dateAll;
      case HistoryDateFilterPreset.today:
        return AppStrings.dateToday;
      case HistoryDateFilterPreset.last7Days:
        return AppStrings.dateLast7Days;
      case HistoryDateFilterPreset.last30Days:
        return AppStrings.dateLast30Days;
      case HistoryDateFilterPreset.thisMonth:
        return AppStrings.dateThisMonth;
      case HistoryDateFilterPreset.thisYear:
        return AppStrings.dateThisYear;
      case HistoryDateFilterPreset.customRange:
        return AppStrings.dateCustomRange;
    }
  }

  bool matches(DateTime timestamp, DateTimeRange? customRange) {
    final now = DateTime.now();
    switch (this) {
      case HistoryDateFilterPreset.all:
        return true;
      case HistoryDateFilterPreset.today:
        return now.year == timestamp.year && now.month == timestamp.month && now.day == timestamp.day;
      case HistoryDateFilterPreset.last7Days:
        return now.difference(timestamp).inDays <= 7 && !timestamp.isAfter(now);
      case HistoryDateFilterPreset.last30Days:
        return now.difference(timestamp).inDays <= 30 && !timestamp.isAfter(now);
      case HistoryDateFilterPreset.thisMonth:
        return now.year == timestamp.year && now.month == timestamp.month;
      case HistoryDateFilterPreset.thisYear:
        return now.year == timestamp.year;
      case HistoryDateFilterPreset.customRange:
        if (customRange == null) return true;
        final start = DateTime(customRange.start.year, customRange.start.month, customRange.start.day);
        final end = DateTime(customRange.end.year, customRange.end.month, customRange.end.day, 23, 59, 59);
        return timestamp.isAfter(start.subtract(const Duration(seconds: 1))) &&
            timestamp.isBefore(end.add(const Duration(seconds: 1)));
    }
  }
}

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  final String? initialScope;

  const SearchScreen({
    super.key,
    this.initialQuery,
    this.initialScope,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late String _selectedScope;
  SqlPresetCategory _selectedSqlCategory = SqlPresetCategory.all;
  late SqlPreset _selectedSqlPreset;
  SqlResultViewMode _viewMode = SqlResultViewMode.tiles; // Default to Tiles / Tarjetas (Item j)
  late final TextEditingController _sqlController;

  bool _isExecutingSql = false;
  List<String> _sqlColumns = [];
  List<List<dynamic>> _sqlRows = [];
  String? _sqlError;

  // Catalog filter by type
  String _selectedCatalogTypeFilter = AppStrings.all;

  // History filters
  String _selectedHistoryCategory = AppTechnicalStrings.categoryAll;
  HistoryDateFilterPreset _selectedHistoryDateFilter = HistoryDateFilterPreset.all;
  DateTimeRange? _customHistoryDateRange;

  final List<String> _scopes = [
    AppStrings.all,
    AppStrings.objectsCategory, // Correctly cased 'Objetos' (Item b)
    AppStrings.tabContainers,
    AppStrings.tabLocations,
    AppStrings.tabCatalog,
    AppStrings.tabHistory,
    AppStrings.arbitrarySqlQueryLabel,
  ];

  final List<String> _catalogTypes = [
    AppStrings.all,
    AppStrings.typeObject,
    AppStrings.typeLivingBeing,
    AppStrings.typeDocument,
    AppStrings.typeProject,
    AppStrings.typeMemory,
  ];

  final List<(String, String)> _historyCategories = [
    (AppTechnicalStrings.categoryAll, AppStrings.categoryFilterAll),
    (AppTechnicalStrings.categoryEntity, AppStrings.categoryFilterEntities),
    (AppTechnicalStrings.categorySpecies, AppStrings.categoryFilterSpecies),
    (AppTechnicalStrings.categoryLocation, AppStrings.categoryFilterLocations),
    (AppTechnicalStrings.categoryRelation, AppStrings.categoryFilterRelations),
    (AppTechnicalStrings.categoryBackup, AppStrings.categoryFilterBackupsAndSystem),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSqlPreset = SqlPreset.defaultPresets.first;
    _sqlController = TextEditingController(text: _selectedSqlPreset.query);

    _selectedScope = (widget.initialScope != null && _scopes.contains(widget.initialScope))
        ? widget.initialScope!
        : AppStrings.all;

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(searchQueryProvider.notifier).state = widget.initialQuery!;
        }
      });
    }

    // Automatically execute the preselected query when loading the SQL view directly
    if (_selectedScope == AppStrings.arbitrarySqlQueryLabel) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _sqlRows.isEmpty && !_isExecutingSql) {
          _executeSqlQuery();
        }
      });
    }
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialScope != null && widget.initialScope != oldWidget.initialScope) {
      if (_scopes.contains(widget.initialScope)) {
        setState(() {
          _selectedScope = widget.initialScope!;
        });
        if (widget.initialScope == AppStrings.arbitrarySqlQueryLabel && _sqlRows.isEmpty && !_isExecutingSql) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _executeSqlQuery();
          });
        }
      }
    }
    if (widget.initialQuery != null && widget.initialQuery != oldWidget.initialQuery) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(searchQueryProvider.notifier).state = widget.initialQuery!;
        }
      });
    }
  }

  @override
  void dispose() {
    _sqlController.dispose();
    super.dispose();
  }

  // --- AppWheelPicker Scope & Filter Pickers ---

  Future<void> _pickScope() async {
    final picked = await AppWheelPicker.show<String>(
      context,
      items: _scopes,
      initialValue: _selectedScope,
      labelBuilder: (s) => s,
      title: AppStrings.selectSearchScopePrompt,
    );

    if (picked != null && mounted) {
      setState(() => _selectedScope = picked);
      if (picked == AppStrings.arbitrarySqlQueryLabel && _sqlRows.isEmpty && !_isExecutingSql) {
        _executeSqlQuery();
      }
    }
  }

  Future<void> _pickCatalogType() async {
    final picked = await AppWheelPicker.show<String>(
      context,
      items: _catalogTypes,
      initialValue: _selectedCatalogTypeFilter,
      labelBuilder: (t) => t,
      title: AppStrings.selectTypeFilterPrompt,
    );

    if (picked != null && mounted) {
      setState(() => _selectedCatalogTypeFilter = picked);
    }
  }

  Future<void> _pickHistoryCategory() async {
    final currentCategoryTuple = _historyCategories.firstWhere(
      (c) => c.$1 == _selectedHistoryCategory,
      orElse: () => _historyCategories.first,
    );

    final picked = await AppWheelPicker.show<(String, String)>(
      context,
      items: _historyCategories,
      initialValue: currentCategoryTuple,
      labelBuilder: (c) => c.$2,
      title: AppStrings.selectCategoryFilterPrompt,
    );

    if (picked != null && mounted) {
      setState(() => _selectedHistoryCategory = picked.$1);
    }
  }

  Future<void> _pickHistoryDateFilter() async {
    final picked = await AppWheelPicker.show<HistoryDateFilterPreset>(
      context,
      items: HistoryDateFilterPreset.values,
      initialValue: _selectedHistoryDateFilter,
      labelBuilder: (f) => f.displayName,
      title: AppStrings.selectDateFilterPrompt,
    );

    if (picked != null && mounted) {
      if (picked == HistoryDateFilterPreset.customRange) {
        final now = DateTime.now();
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: now.add(const Duration(days: 365)),
          initialDateRange: _customHistoryDateRange ??
              DateTimeRange(
                start: now.subtract(const Duration(days: 7)),
                end: now,
              ),
        );
        if (range != null && mounted) {
          setState(() {
            _selectedHistoryDateFilter = picked;
            _customHistoryDateRange = range;
          });
        }
      } else {
        setState(() {
          _selectedHistoryDateFilter = picked;
          _customHistoryDateRange = null;
        });
      }
    }
  }

  Future<void> _pickSqlCategory() async {
    final picked = await AppWheelPicker.show<SqlPresetCategory>(
      context,
      items: SqlPresetCategory.values,
      initialValue: _selectedSqlCategory,
      labelBuilder: (cat) => cat.displayName,
      title: AppStrings.sqlCategorySelectPrompt,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedSqlCategory = picked;
        final matchingPresets = SqlPreset.defaultPresets
            .where((p) => picked == SqlPresetCategory.all || p.category == picked)
            .toList();
        if (!matchingPresets.contains(_selectedSqlPreset) && matchingPresets.isNotEmpty) {
          _selectedSqlPreset = matchingPresets.first;
          _sqlController.text = _selectedSqlPreset.query;
        }
      });
      _executeSqlQuery();
    }
  }

  Future<void> _pickSqlPreset() async {
    final presets = SqlPreset.defaultPresets
        .where((p) => _selectedSqlCategory == SqlPresetCategory.all || p.category == _selectedSqlCategory)
        .toList();

    if (presets.isEmpty) return;

    final initialP = presets.contains(_selectedSqlPreset)
        ? _selectedSqlPreset
        : (presets.isNotEmpty ? presets.first : null);

    final picked = await AppWheelPicker.show<SqlPreset>(
      context,
      items: presets,
      initialValue: initialP,
      labelBuilder: (p) => p.title,
      title: AppStrings.sqlPresetsSelectPrompt,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedSqlPreset = picked;
        _sqlController.text = picked.query;
      });
      _executeSqlQuery();
    }
  }

  Future<void> _openFullScreenSqlEditor() async {
    final updatedQuery = await SqlEditorFullScreenView.show(
      context,
      initialQuery: _sqlController.text,
      initialCategory: _selectedSqlCategory,
      initialPreset: _selectedSqlPreset,
    );

    if (updatedQuery != null && mounted) {
      setState(() {
        _sqlController.text = updatedQuery;
        final match = SqlPreset.defaultPresets.where((p) => p.query.trim() == updatedQuery.trim()).firstOrNull;
        if (match != null) {
          _selectedSqlPreset = match;
          _selectedSqlCategory = match.category;
        }
      });
      _executeSqlQuery();
    }
  }

  // --- SQL Execution Engine ---

  Future<void> _executeSqlQuery() async {
    final queryStr = _sqlController.text.trim();
    if (queryStr.isEmpty) return;

    const forbiddenKeywords = AppTechnicalStrings.sqlForbiddenKeywords;

    for (final kw in forbiddenKeywords) {
      if (RegExp(AppTechnicalStrings.wordBoundaryKeywordPattern(kw), caseSensitive: false).hasMatch(queryStr)) {
        setState(() {
          _sqlError = AppStrings.sqlSecurityError(kw);
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
        _sqlError = AppStrings.sqlSyntaxError(e.toString());
        _sqlColumns = [];
        _sqlRows = [];
      });
    } finally {
      if (mounted) setState(() => _isExecutingSql = false);
    }
  }

  // --- Exhaustive Search Matchers ---

  bool _matchesEntity(
    WorldEntity e,
    String cleanQuery,
    Map<String, CatalogItem> speciesMap,
    Map<String, Subspecies> subspeciesMap,
    Map<String, LocationNode> locationMap,
  ) {
    if (cleanQuery.isEmpty) return true;

    // ID match
    if (e.id.toLowerCase().contains(cleanQuery)) return true;

    // Species metadata match
    final species = speciesMap[e.speciesId];
    if (species != null) {
      if (species.name.toLowerCase().contains(cleanQuery) ||
          species.type.toLowerCase().contains(cleanQuery) ||
          (species.description?.toLowerCase().contains(cleanQuery) ?? false)) {
        return true;
      }
    }

    // Subspecies metadata match
    if (e.subspeciesId != null) {
      final sub = subspeciesMap[e.subspeciesId];
      if (sub != null) {
        if (sub.subspeciesName.toLowerCase().contains(cleanQuery) ||
            (sub.brand?.toLowerCase().contains(cleanQuery) ?? false) ||
            (sub.barcode?.toLowerCase().contains(cleanQuery) ?? false) ||
            (sub.notes?.toLowerCase().contains(cleanQuery) ?? false)) {
          return true;
        }
      }
    }

    // Location metadata match
    if (e.locationId != null) {
      final loc = locationMap[e.locationId];
      if (loc != null) {
        if (loc.name.toLowerCase().contains(cleanQuery) ||
            (loc.description?.toLowerCase().contains(cleanQuery) ?? false)) {
          return true;
        }
      }
    }

    // Notes
    if (e.notes?.toLowerCase().contains(cleanQuery) ?? false) return true;

    // Expiration date
    if (e.expirationDate != null) {
      final dateStr = AppStrings.formatDateDMY(e.expirationDate).toLowerCase();
      if (dateStr.contains(cleanQuery) || e.expirationDate.toString().contains(cleanQuery)) {
        return true;
      }
    }

    // Magnitudes metadata
    for (final mag in e.magnitudes) {
      if (mag.propertyName.toLowerCase().contains(cleanQuery) ||
          (mag.unitSymbol?.toLowerCase().contains(cleanQuery) ?? false) ||
          (mag.stringValue?.toLowerCase().contains(cleanQuery) ?? false) ||
          mag.dataType.toLowerCase().contains(cleanQuery) ||
          mag.displayValue.toLowerCase().contains(cleanQuery)) {
        return true;
      }
    }

    return false;
  }

  bool _matchesSpecies(CatalogItem s, String cleanQuery) {
    if (cleanQuery.isEmpty) return true;
    if (s.id.toLowerCase().contains(cleanQuery)) return true;
    if (s.name.toLowerCase().contains(cleanQuery)) return true;
    if (s.type.toLowerCase().contains(cleanQuery)) return true;
    if (s.description?.toLowerCase().contains(cleanQuery) ?? false) return true;
    if (s.isUnique && AppStrings.isUniqueLabel.toLowerCase().contains(cleanQuery)) return true;
    return false;
  }

  bool _matchesSubspecies(Subspecies sub, String cleanQuery, Map<String, CatalogItem> speciesMap) {
    if (cleanQuery.isEmpty) return true;
    if (sub.id.toLowerCase().contains(cleanQuery)) return true;
    if (sub.subspeciesName.toLowerCase().contains(cleanQuery)) return true;
    if (sub.brand?.toLowerCase().contains(cleanQuery) ?? false) return true;
    if (sub.barcode?.toLowerCase().contains(cleanQuery) ?? false) return true;
    if (sub.notes?.toLowerCase().contains(cleanQuery) ?? false) return true;

    final species = speciesMap[sub.speciesId];
    if (species != null && species.name.toLowerCase().contains(cleanQuery)) return true;

    return false;
  }

  bool _matchesLocation(LocationNode loc, String cleanQuery) {
    if (cleanQuery.isEmpty) return true;
    if (loc.id.toLowerCase().contains(cleanQuery)) return true;
    if (loc.name.toLowerCase().contains(cleanQuery)) return true;
    if (loc.description?.toLowerCase().contains(cleanQuery) ?? false) return true;
    if (loc.icon?.toLowerCase().contains(cleanQuery) ?? false) return true;
    return false;
  }

  bool _matchesHistoryEvent(ActivityEvent evt, String cleanQuery) {
    // 1. Date filter check
    if (!_selectedHistoryDateFilter.matches(evt.timestamp, _customHistoryDateRange)) {
      return false;
    }

    // 2. Category filter check
    if (_selectedHistoryCategory.isNotEmpty && _selectedHistoryCategory != AppTechnicalStrings.categoryAll) {
      if (evt.category != _selectedHistoryCategory) return false;
    }

    if (cleanQuery.isEmpty) return true;

    if (evt.description.toLowerCase().contains(cleanQuery)) return true;
    if (evt.eventType.toLowerCase().contains(cleanQuery)) return true;
    if (evt.category.toLowerCase().contains(cleanQuery)) return true;
    if (evt.entityId?.toLowerCase().contains(cleanQuery) ?? false) return true;
    if (evt.resolvedTargetId?.toLowerCase().contains(cleanQuery) ?? false) return true;
    if (evt.resolvedTargetType?.toLowerCase().contains(cleanQuery) ?? false) return true;

    final dateFormatted = AppStrings.formatDateTimeDMY(evt.timestamp).toLowerCase();
    if (dateFormatted.contains(cleanQuery) || evt.timestamp.toString().contains(cleanQuery)) return true;

    if (evt.metadata != null) {
      final metaString = jsonEncode(evt.metadata).toLowerCase();
      if (metaString.contains(cleanQuery)) return true;
    }

    return false;
  }

  IconData _getScopeIcon(String scope) {
    if (scope == AppStrings.all) return Icons.manage_search;
    if (scope == AppStrings.objectsCategory) return Icons.category_outlined;
    if (scope == AppStrings.tabContainers) return Icons.inventory_2_outlined;
    if (scope == AppStrings.tabLocations) return Icons.location_on_outlined;
    if (scope == AppStrings.tabCatalog) return Icons.menu_book_outlined;
    if (scope == AppStrings.tabHistory) return Icons.history;
    if (scope == AppStrings.arbitrarySqlQueryLabel) return Icons.terminal_outlined;
    return Icons.search;
  }

  void _showEventDetailModal(ActivityEvent event) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primary.withAlpha(40),
                        child: Icon(Icons.history, color: theme.colorScheme.primary, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.eventDetailsTitle,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              event.eventType,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    event.description,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildDetailRow(AppStrings.categoryLabel, event.category),
                  _buildDetailRow(AppStrings.exactTimestampLabel, event.timestamp.toIso8601String()),
                  if (event.resolvedTargetId != null)
                    _buildDetailRow(AppStrings.targetIdLabel, event.resolvedTargetId!),
                  if (event.resolvedTargetType != null)
                    _buildDetailRow(AppStrings.targetTypeLabel, event.resolvedTargetType!),
                  const SizedBox(height: 16),
                  if (event.metadata != null && event.metadata!.isNotEmpty) ...[
                    Text(
                      AppStrings.technicalDetailsTitle,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Text(
                        const JsonEncoder.withIndent(AppTechnicalStrings.indentTwoSpaces).convert(event.metadata),
                        style: const TextStyle(fontFamily: AppTechnicalStrings.fontFamilyMonospace, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (event.isNavigable && event.resolvedTargetId != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text(AppStrings.viewTargetAction),
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (event.resolvedTargetType == AppTechnicalStrings.categoryEntity) {
                            context.pushEntityDetail(event.resolvedTargetId!);
                          } else if (event.resolvedTargetType == AppTechnicalStrings.categorySpecies) {
                            context.pushSpeciesDetail(event.resolvedTargetId!);
                          }
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryEventCard(ActivityEvent evt) {
    final theme = Theme.of(context);
    final formattedTime = AppStrings.formatDateTimeDMY(evt.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withAlpha(50)),
      ),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: theme.colorScheme.primary.withAlpha(30),
          child: Icon(Icons.history, color: theme.colorScheme.primary, size: 18),
        ),
        title: Text(
          evt.description,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.dividerColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  evt.category,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formattedTime,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
        ),
        trailing: evt.isNavigable
            ? Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400)
            : null,
        onTap: () => _showEventDetailModal(evt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final isSqlMode = _selectedScope == AppStrings.arbitrarySqlQueryLabel;
    final theme = Theme.of(context);

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
                ref.read(searchQueryProvider.notifier).state = AppTechnicalStrings.empty;
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Top Scope Selector using AppWheelPicker (Item h)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(bottom: BorderSide(color: theme.dividerColor.withAlpha(60))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickScope,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withAlpha(70),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.primary.withAlpha(80)),
                      ),
                      child: Row(
                        children: [
                          Icon(_getScopeIcon(_selectedScope), size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppStrings.scopeWithPrefix(_selectedScope),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.unfold_more, size: 18, color: theme.colorScheme.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: isSqlMode
                ? _buildSqlRunnerView(context)
                : _buildSearchResults(context, ref, query),
          ),
        ],
      ),
    );
  }

  // --- SQL Runner View ---

  Widget _buildSqlRunnerView(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: SQL Category & Presets Pickers with AppWheelPicker (Dedicated row, explicit button styling)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickSqlCategory,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category_outlined, size: 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _selectedSqlCategory.displayName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: _pickSqlPreset,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bookmark_border, size: 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _selectedSqlPreset.title,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: SQL Query Preview Box (Clickable, clean code area without redundant header)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: theme.dividerColor.withAlpha(80)),
              ),
              child: InkWell(
                onTap: _openFullScreenSqlEditor,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, right: 8.0),
                        child: Icon(Icons.code, size: 18, color: theme.colorScheme.primary),
                      ),
                      Expanded(
                        child: Text(
                          _sqlController.text.trim().isNotEmpty
                              ? _sqlController.text
                              : AppTechnicalStrings.sqlDefaultSearchSample,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: AppTechnicalStrings.fontFamilyMonospace,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(Icons.edit_outlined, size: 16, color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Row 3: Dedicated Action Buttons Row (Separate row, prominent buttons)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _openFullScreenSqlEditor,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fullscreen, size: 18),
                        SizedBox(width: 8),
                        Text(
                          AppStrings.openSqlEditorAction,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isExecutingSql ? null : _executeSqlQuery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 20),
                        SizedBox(width: 6),
                        Text(
                          AppStrings.executeAction,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
                                  AppStrings.rowsRetrieved(_sqlRows.length),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                SegmentedButton<SqlResultViewMode>(
                                  segments: const [
                                    ButtonSegment(
                                      value: SqlResultViewMode.tiles,
                                      icon: Icon(Icons.view_agenda_outlined, size: 14),
                                      label: Text(AppStrings.viewModeTiles, style: TextStyle(fontSize: 11)),
                                    ),
                                    ButtonSegment(
                                      value: SqlResultViewMode.table,
                                      icon: Icon(Icons.table_chart_outlined, size: 14),
                                      label: Text(AppStrings.viewModeTable, style: TextStyle(fontSize: 11)),
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
          headingRowColor: WidgetStateProperty.all(theme.colorScheme.primary.withAlpha(20)),
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
                final cellStr = cell != null ? cell.toString() : AppTechnicalStrings.sqlNull;
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
        [
          AppTechnicalStrings.colId,
          AppTechnicalStrings.colInstanceId,
          AppTechnicalStrings.colEntityId,
          AppTechnicalStrings.colSourceEntityId,
          AppTechnicalStrings.colTargetEntityId,
          AppTechnicalStrings.colEntityA,
          AppTechnicalStrings.colEntityB,
        ].contains(c.toLowerCase()));

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
        [
          AppTechnicalStrings.colId,
          AppTechnicalStrings.colSpeciesId,
        ].contains(c.toLowerCase()));

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
        [
          AppTechnicalStrings.colId,
          AppTechnicalStrings.colLocationId,
          AppTechnicalStrings.colParentLocationId,
        ].contains(c.toLowerCase()));

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
            itemCount: LocationRepository.getRecursiveItemCount(matchingLocations[idx].id, allLocations, allEntities),
            onTap: () => context.goToInventory(focusNodeId: matchingLocations[idx].id),
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
                          AppTechnicalStrings.labelWithColon(_sqlColumns[i]),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Expanded(
                          child: Text(
                            row[i] != null ? row[i].toString() : AppTechnicalStrings.sqlNull,
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

  // --- Main Search Results Builder ---

  Widget _buildSearchResults(
    BuildContext context,
    WidgetRef ref,
    String query,
  ) {
    final cleanQuery = query.toLowerCase().trim();
    final bottomPadding = MediaQuery.paddingOf(context).bottom + 24.0;
    final theme = Theme.of(context);

    final allEntities = ref.watch(entityListProvider).asData?.value ?? [];
    final allCatalog = ref.watch(catalogListProvider).asData?.value ?? [];
    final allSubspecies = ref.watch(subspeciesListProvider).asData?.value ?? [];
    final allLocations = ref.watch(locationNodeListProvider).asData?.value ?? [];
    final allHistory = ref.watch(allHistoryEventsStreamProvider).asData?.value ?? [];
    final allRelations = ref.watch(relationListProvider).asData?.value ?? [];

    final speciesMap = {for (var s in allCatalog) s.id: s};
    final subspeciesMap = {for (var sub in allSubspecies) sub.id: sub};
    final locationMap = {for (var loc in allLocations) loc.id: loc};

    // 0. Contenedores (Item c: Exhaustive filtering matching subspecies, etc.)
    if (_selectedScope == AppStrings.tabContainers) {
      final containerEntityIds = allRelations
          .where((r) => r.relationType == AppTechnicalStrings.relGuardadoEn)
          .map((r) => r.targetEntityId)
          .toSet();

      final containerEntities = allEntities.where((e) {
        if (!containerEntityIds.contains(e.id)) return false;
        return _matchesEntity(e, cleanQuery, speciesMap, subspeciesMap, locationMap);
      }).toList();

      if (containerEntities.isEmpty) {
        return const Center(child: Text(AppStrings.emptyContainersSearch));
      }

      return ListView.builder(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomPadding),
        itemCount: containerEntities.length,
        itemBuilder: (ctx, idx) => EntityTile(entity: containerEntities[idx]),
      );
    }

    // 1. Ubicaciones (Item e: Standard LocationTile)
    if (_selectedScope == AppStrings.tabLocations) {
      final filteredLocs = allLocations.where((loc) => _matchesLocation(loc, cleanQuery)).toList();
      if (filteredLocs.isEmpty) return const Center(child: Text(AppStrings.emptyLocation));

      return ListView.builder(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomPadding),
        itemCount: filteredLocs.length,
        itemBuilder: (ctx, idx) {
          final node = filteredLocs[idx];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: LocationTile(
              node: node,
              itemCount: LocationRepository.getRecursiveItemCount(node.id, allLocations, allEntities),
              onTap: () => context.goToInventory(focusNodeId: node.id),
            ),
          );
        },
      );
    }

    // 2. Catálogo (Item f: Same level Species and Subspecies tiles + AppWheelPicker type filter)
    if (_selectedScope == AppStrings.tabCatalog) {
      var filteredSpecies = allCatalog.where((s) => _matchesSpecies(s, cleanQuery)).toList();
      var filteredSubspecies = allSubspecies.where((sub) => _matchesSubspecies(sub, cleanQuery, speciesMap)).toList();

      if (_selectedCatalogTypeFilter != AppStrings.all) {
        filteredSpecies = filteredSpecies.where((s) => s.type == _selectedCatalogTypeFilter).toList();
        filteredSubspecies = filteredSubspecies.where((sub) {
          final parent = speciesMap[sub.speciesId];
          return parent != null && parent.type == _selectedCatalogTypeFilter;
        }).toList();
      }

      final totalItems = filteredSpecies.length + filteredSubspecies.length;

      return Column(
        children: [
          // Filter by species type using AppWheelPicker (Item h)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(bottom: BorderSide(color: theme.dividerColor.withAlpha(40))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickCatalogType,
                    icon: const Icon(Icons.filter_list, size: 16),
                    label: Text(
                      _selectedCatalogTypeFilter == AppStrings.all
                          ? AppStrings.selectTypeFilterPrompt
                          : AppStrings.filterByTypeWithValue(_selectedCatalogTypeFilter),
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: totalItems == 0
                ? const Center(child: Text(AppStrings.emptyCatalog))
                : ListView.builder(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomPadding),
                    itemCount: totalItems,
                    itemBuilder: (ctx, idx) {
                      if (idx < filteredSpecies.length) {
                        final sp = filteredSpecies[idx];
                        return SpeciesTile(
                          species: sp,
                          onInstantiate: () {
                            InstantiateSpeciesSheet.show(context, species: sp);
                          },
                        );
                      } else {
                        final subIdx = idx - filteredSpecies.length;
                        final sub = filteredSubspecies[subIdx];
                        final parentSpecies = speciesMap[sub.speciesId];
                        return SubspeciesTile(
                          subspecies: sub,
                          speciesName: parentSpecies?.name,
                          species: parentSpecies,
                          isExpandable: false,
                          onTap: () => context.pushSpeciesDetail(sub.speciesId),
                        );
                      }
                    },
                  ),
          ),
        ],
      );
    }

    // 3. Historial (Item g: Exhaustive metadata search + date filter via AppWheelPicker)
    if (_selectedScope == AppStrings.tabHistory) {
      final filteredHistory = allHistory.where((e) => _matchesHistoryEvent(e, cleanQuery)).toList();

      return Column(
        children: [
          // Category and Date Filter Row via AppWheelPicker (Item h)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(bottom: BorderSide(color: theme.dividerColor.withAlpha(40))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickHistoryCategory,
                    icon: const Icon(Icons.category_outlined, size: 16),
                    label: Text(
                      _historyCategories.firstWhere((c) => c.$1 == _selectedHistoryCategory).$2,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _pickHistoryDateFilter,
                    icon: const Icon(Icons.date_range, size: 16),
                    label: Text(
                      _selectedHistoryDateFilter == HistoryDateFilterPreset.customRange && _customHistoryDateRange != null
                          ? AppStrings.dateRangeFormatted(
                              AppStrings.formatDateDMY(_customHistoryDateRange!.start),
                              AppStrings.formatDateDMY(_customHistoryDateRange!.end),
                            )
                          : _selectedHistoryDateFilter.displayName,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredHistory.isEmpty
                ? const Center(child: Text(AppStrings.noHistoryResults))
                : ListView.builder(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomPadding),
                    itemCount: filteredHistory.length,
                    itemBuilder: (ctx, idx) => _buildHistoryEventCard(filteredHistory[idx]),
                  ),
          ),
        ],
      );
    }

    // 4. Objetos (Instancias puras)
    if (_selectedScope == AppStrings.objectsCategory) {
      final matchingEntities = allEntities.where((e) {
        return _matchesEntity(e, cleanQuery, speciesMap, subspeciesMap, locationMap);
      }).toList();

      if (matchingEntities.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: theme.colorScheme.primary.withAlpha(100)),
              const SizedBox(height: 16),
              Text(
                AppStrings.noSearchMatches(query),
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomPadding),
        itemCount: matchingEntities.length,
        itemBuilder: (context, index) {
          return EntityTile(entity: matchingEntities[index]);
        },
      );
    }

    // 5. "Todos" (Item a: Unified search across ALL element types)
    final matchingEntities = allEntities.where((e) {
      return _matchesEntity(e, cleanQuery, speciesMap, subspeciesMap, locationMap);
    }).toList();

    final matchingSpecies = allCatalog.where((s) => _matchesSpecies(s, cleanQuery)).toList();
    final matchingSubspecies = allSubspecies.where((sub) => _matchesSubspecies(sub, cleanQuery, speciesMap)).toList();
    final matchingLocations = allLocations.where((loc) => _matchesLocation(loc, cleanQuery)).toList();
    final matchingHistory = allHistory.where((e) => _matchesHistoryEvent(e, cleanQuery)).toList();

    final totalCount = matchingEntities.length +
        matchingSpecies.length +
        matchingSubspecies.length +
        matchingLocations.length +
        matchingHistory.length;

    if (totalCount == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: theme.colorScheme.primary.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              AppStrings.noSearchMatches(query),
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomPadding),
      children: [
        // Section: Instancias
        if (matchingEntities.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            title: AppStrings.sectionInstances,
            count: matchingEntities.length,
            icon: Icons.category_outlined,
          ),
          const SizedBox(height: 8),
          ...matchingEntities.take(15).map((e) => EntityTile(entity: e)),
          const SizedBox(height: 16),
        ],

        // Section: Catálogo (Especies y Subespecies)
        if (matchingSpecies.isNotEmpty || matchingSubspecies.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            title: AppStrings.sectionCatalog,
            count: matchingSpecies.length + matchingSubspecies.length,
            icon: Icons.menu_book_outlined,
          ),
          const SizedBox(height: 8),
          ...matchingSpecies.take(10).map((sp) => SpeciesTile(
                species: sp,
                onInstantiate: () => InstantiateSpeciesSheet.show(context, species: sp),
              )),
          ...matchingSubspecies.take(10).map((sub) {
            final parentSpecies = speciesMap[sub.speciesId];
            return SubspeciesTile(
              subspecies: sub,
              speciesName: parentSpecies?.name,
              species: parentSpecies,
              isExpandable: false,
              onTap: () => context.pushSpeciesDetail(sub.speciesId),
            );
          }),
          const SizedBox(height: 16),
        ],

        // Section: Ubicaciones
        if (matchingLocations.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            title: AppStrings.sectionLocations,
            count: matchingLocations.length,
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 8),
          ...matchingLocations.take(10).map(
                (loc) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: LocationTile(
                    node: loc,
                    itemCount: LocationRepository.getRecursiveItemCount(loc.id, allLocations, allEntities),
                    onTap: () => context.goToInventory(focusNodeId: loc.id),
                  ),
                ),
              ),
          const SizedBox(height: 16),
        ],

        // Section: Historial
        if (matchingHistory.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            title: AppStrings.sectionHistory,
            count: matchingHistory.length,
            icon: Icons.history,
          ),
          const SizedBox(height: 8),
          ...matchingHistory.take(10).map((evt) => _buildHistoryEventCard(evt)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          AppStrings.sectionHeaderWithCount(title, count),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: theme.dividerColor.withAlpha(80))),
      ],
    );
  }
}
