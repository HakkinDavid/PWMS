import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/effective_entity_group.dart';
import 'effective_group_tile.dart';

class EntitiesTab extends ConsumerStatefulWidget {
  const EntitiesTab({super.key});

  @override
  ConsumerState<EntitiesTab> createState() => _EntitiesTabState();
}

class _EntitiesTabState extends ConsumerState<EntitiesTab> {
  String _selectedTypeFilter = AppStrings.all;

  final List<String> _filters = [
    AppStrings.all,
    AppStrings.typeObject,
    AppStrings.typeDocument,
    AppStrings.typeProject,
    AppStrings.typeMemory,
  ];

  @override
  Widget build(BuildContext context) {
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tabEntities),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => context.push('/create-master'),
        tooltip: AppStrings.registerObjectTitle,
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
            child: entitiesState.when(
              data: (entities) {
                var activeEntities = entities.toList();

                if (_selectedTypeFilter != AppStrings.all) {
                  final catalogItems = catalogState.asData?.value ?? [];
                  activeEntities = activeEntities.where((e) {
                    final species = catalogItems.where((c) => c.id == e.speciesId).firstOrNull;
                    return species?.type == _selectedTypeFilter;
                  }).toList();
                }

                if (activeEntities.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: theme.colorScheme.primary.withAlpha(120)),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.noEntitiesRegistered,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final groups = EffectiveEntityGroup.groupEntities(
                  entities: activeEntities,
                  effectiveLocationMap: {for (var e in activeEntities) e.id: e.locationId},
                );

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return EffectiveGroupTile(group: groups[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('${AppStrings.errorPrefix}$err')),
            ),
          ),
        ],
      ),
    );
  }
}
