import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/entity_tile.dart';
import '../../history/domain/activity_event.dart';
import '../../locations/domain/location_node.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _selectedScope = AppStrings.all;

  final List<String> _scopes = [
    AppStrings.all,
    AppStrings.objectsLabel,
    AppStrings.tabLocations,
    AppStrings.tabCatalog,
    AppStrings.tabHistory,
  ];

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final activityState = ref.watch(recentActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: AppStrings.searchHint,
            border: InputBorder.none,
          ),
          onChanged: (val) {
            ref.read(searchQueryProvider.notifier).state = val;
          },
        ),
        actions: [
          if (query.isNotEmpty)
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
          // Filter Chips (Todos, Objetos, Ubicaciones, Catálogo, Historial)
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
            child: _buildSearchResults(
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

    // 1. Ubicaciones (Strictly typed LocationNode)
    if (_selectedScope == AppStrings.tabLocations) {
      final nodes = locationsState.asData?.value ?? <LocationNode>[];
      final filtered = nodes.where((LocationNode n) => n.name.toLowerCase().contains(cleanQuery)).toList();
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
        s.type.toLowerCase().contains(cleanQuery)
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

    // 4. Objetos / Todos
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
                  AppStrings.emptyCatalog,
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
