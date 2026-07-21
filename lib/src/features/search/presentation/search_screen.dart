import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/create_entity_sheet.dart';
import '../../entities/presentation/entity_tile.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final theme = Theme.of(context);

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
      body: searchResultsAsync.when(
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
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateEntitySheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.registerObjectTitle),
      ),
    );
  }
}
