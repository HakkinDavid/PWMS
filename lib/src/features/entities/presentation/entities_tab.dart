import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import 'create_entity_sheet.dart';
import 'entity_tile.dart';

class EntitiesTab extends ConsumerWidget {
  const EntitiesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitiesState = ref.watch(entityListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tabEntities),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateEntitySheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.registerObjectTitle),
      ),
      body: entitiesState.when(
        data: (entities) {
          final activeEntities = entities.where((e) => !e.isArchived).toList();

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
                      'No hay objetos registrados en tu mundo',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activeEntities.length,
            itemBuilder: (context, index) {
              return EntityTile(entity: activeEntities[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
