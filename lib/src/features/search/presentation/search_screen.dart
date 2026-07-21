import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/create_entity_sheet.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar por nombre, código, marca, notas...',
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
                    'No se encontraron elementos en tu mundo',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          final catalogItems = catalogState.asData?.value ?? [];
          final locationNodes = locationsState.asData?.value ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entities.length,
            itemBuilder: (context, index) {
              final entity = entities[index];

              final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull;
              final name = species?.name ?? 'Objeto';
              final type = species?.type ?? 'Objeto / Herramienta';

              String locationName = 'Mundo (Raíz)';
              if (entity.locationId != null) {
                final found = locationNodes.where((n) => n.id == entity.locationId).firstOrNull;
                if (found != null) locationName = found.name;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withAlpha(30),
                    child: FutureBuilder<String>(
                      future: species?.mainPhotoPath != null
                          ? ref.read(fileStorageServiceProvider).getAbsolutePath(species!.mainPhotoPath!)
                          : Future.value(''),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                          return ClipOval(
                            child: Image.file(
                              File(snapshot.data!),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return Icon(Icons.category, color: theme.colorScheme.primary);
                      },
                    ),
                  ),
                  title: Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.account_tree_outlined, size: 14, color: theme.colorScheme.secondary),
                          const SizedBox(width: 4),
                          Text('$type • $locationName', style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12)),
                        ],
                      ),
                      if (entity.notes != null && entity.notes!.isNotEmpty)
                        Text(
                          'Nota: ${entity.notes}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/entity/${entity.id}');
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error en búsqueda: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateEntitySheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Registrar Objeto'),
      ),
    );
  }
}
