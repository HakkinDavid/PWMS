import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../entities/presentation/create_entity_sheet.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../locations/infrastructure/location_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentEntitiesAsync = ref.watch(recentEntitiesProvider);
    final locationsAsync = ref.watch(locationNodeListProvider);
    final catalogAsync = ref.watch(catalogListProvider);
    final entitiesAsync = ref.watch(entityListProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar Header & Search Icon Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, size: 28),
                      onPressed: () => context.push('/search'),
                    ),
                  ],
                ),
              ),
            ),

            // Section 1: Objetos recientes
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      AppStrings.recentEntitiesTitle,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 14),
                  recentEntitiesAsync.when(
                    data: (entities) {
                      if (entities.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text('Sin objetos recientes'),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: entities.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final entity = entities[index];
                            return InkWell(
                              onTap: () => context.push('/entity/${entity.id}'),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: theme.dividerColor),
                                ),
                                child: Consumer(
                                  builder: (context, ref, _) {
                                    final catalogItems = catalogAsync.asData?.value ?? [];
                                    final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull;
                                    final name = species?.name ?? AppStrings.typeObject;
                                    final type = species?.type ?? AppStrings.typeObject;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(14),
                                            child: FutureBuilder<String>(
                                              future: species?.mainPhotoPath != null
                                                  ? ref.read(fileStorageServiceProvider).getAbsolutePath(species!.mainPhotoPath!)
                                                  : Future.value(''),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                                  return Image.file(
                                                    File(snapshot.data!),
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  );
                                                }
                                                return Container(
                                                  color: theme.colorScheme.primary.withAlpha(30),
                                                  child: Center(
                                                    child: Icon(Icons.category, color: theme.colorScheme.primary),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          type,
                                          style: TextStyle(color: theme.colorScheme.secondary, fontSize: 11),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Section 2: Ubicaciones con más objetos (Most populated location nodes)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubicaciones principales',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    locationsAsync.when(
                      data: (nodes) {
                        if (nodes.isEmpty) {
                          return const Text(AppStrings.emptyLocation, style: TextStyle(color: Colors.grey));
                        }

                        final allEntities = entitiesAsync.asData?.value ?? [];

                        // Sort nodes by item count descending
                        final sortedNodes = List.of(nodes)
                          ..sort((a, b) {
                            final countA = LocationRepository.getRecursiveItemCount(a.id, nodes, allEntities);
                            final countB = LocationRepository.getRecursiveItemCount(b.id, nodes, allEntities);
                            return countB.compareTo(countA);
                          });

                        final topNodes = sortedNodes.take(4).toList();

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.3,
                          ),
                          itemCount: topNodes.length,
                          itemBuilder: (context, index) {
                            final node = topNodes[index];
                            final count = LocationRepository.getRecursiveItemCount(node.id, nodes, allEntities);

                            return InkWell(
                              onTap: () => context.push('/locations'),
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: theme.dividerColor),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.secondary.withAlpha(25),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        color: theme.colorScheme.secondary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            node.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '$count objetos',
                                            style: theme.textTheme.bodySmall,
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
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, _) => Text('Error: $err'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Section 3: Últimas especies agregadas al catálogo
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Últimas especies en el catálogo',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/catalog'),
                          child: const Text('Ver catálogo'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    catalogAsync.when(
                      data: (items) {
                        if (items.isEmpty) {
                          return const Text(AppStrings.emptyCatalog, style: TextStyle(color: Colors.grey));
                        }

                        final recentItems = items.take(4).toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentItems.length,
                          itemBuilder: (context, idx) {
                            final item = recentItems[idx];
                            return SpeciesTile(
                              species: item,
                              onInstantiate: () {
                                InstantiateSpeciesSheet.show(context, species: item);
                              },
                            );
                          },
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, _) => Text('Error: $err'),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_home', // Unique hero tag!
        onPressed: () => CreateEntitySheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.registerObjectTitle),
      ),
    );
  }
}
