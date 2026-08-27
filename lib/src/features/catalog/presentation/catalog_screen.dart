import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';

import 'species_tile.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';

import '../../entities/presentation/register_object_modal.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  final String? initialSpeciesId;
  final String? initialFilter;

  const CatalogScreen({
    super.key,
    this.initialSpeciesId,
    this.initialFilter,
  });

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  late String _selectedTypeFilter;

  final List<String> _filters = [
    AppStrings.all,
    AppStrings.typeObject,
    AppStrings.typeDocument,
    AppStrings.typeProject,
    AppStrings.typeMemory,
  ];

  @override
  void initState() {
    super.initState();
    _selectedTypeFilter = (widget.initialFilter != null && _filters.contains(widget.initialFilter))
        ? widget.initialFilter!
        : AppStrings.all;
  }

  @override
  void didUpdateWidget(CatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFilter != null && widget.initialFilter != oldWidget.initialFilter) {
      if (_filters.contains(widget.initialFilter)) {
        setState(() {
          _selectedTypeFilter = widget.initialFilter!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.catalogTitle),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => RegisterObjectModal.show(context, startInCreateSpecies: true),
        tooltip: AppStrings.newSpeciesTitle,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedTypeFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedTypeFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: catalogState.when(
              data: (items) {
                var filtered = items;
                if (_selectedTypeFilter != AppStrings.all) {
                  filtered = items.where((i) => i.type == _selectedTypeFilter).toList();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.public, size: 64, color: theme.colorScheme.primary.withAlpha(120)),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.emptyCatalog,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.paddingOf(context).bottom + 84,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return SpeciesTile(
                      species: item,
                      onInstantiate: () {
                        InstantiateSpeciesSheet.show(
                          context,
                          species: item,
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text(AppStrings.errorWithDetails(err))),
            ),
          ),
        ],
      ),
    );
  }
}
