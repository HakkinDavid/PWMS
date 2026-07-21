import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/create_entity_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentEntitiesAsync = ref.watch(recentEntitiesProvider);
    final recentActivityAsync = ref.watch(recentActivityProvider);

    final collections = [
      {'name': 'Objetos', 'icon': Icons.build, 'query': 'Objeto'},
      {'name': AppStrings.locationsTitle, 'icon': Icons.account_tree_outlined, 'route': '/places'},
      {'name': AppStrings.universeCatalogTitle, 'icon': Icons.public, 'route': '/catalog'},
      {'name': 'Documentos', 'icon': Icons.description, 'query': 'Documento'},
      {'name': 'Proyectos', 'icon': Icons.lightbulb, 'query': 'Proyecto'},
      {'name': 'Recuerdos', 'icon': Icons.star, 'query': 'Recuerdo'},
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, size: 28),
                      onPressed: () => context.push('/search'),
                    ),
                  ],
                ),
              ),
            ),

            // Main Hero Search Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () => context.push('/search'),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: theme.colorScheme.primary),
                        const SizedBox(width: 14),
                        Text(
                          AppStrings.searchHint,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recent Items Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.recentEntitiesTitle,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
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
                              child: Text('Sin objetos en tu mundo aún'),
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
                                    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
                                    final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull;
                                    final name = species?.name ?? 'Objeto';
                                    final type = species?.type ?? 'Objeto';

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

            // World Collections Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.collectionsTitle,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.3,
                      ),
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        final col = collections[index];
                        return InkWell(
                          onTap: () {
                            if (col.containsKey('route')) {
                              context.push(col['route'] as String);
                            } else {
                              ref.read(searchQueryProvider.notifier).state = col['query'] as String;
                              context.push('/search');
                            }
                          },
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
                                    color: theme.colorScheme.primary.withAlpha(25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    col['icon'] as IconData,
                                    color: theme.colorScheme.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    col['name'] as String,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Recent Activity Log
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.activityTitle,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    recentActivityAsync.when(
                      data: (events) {
                        if (events.isEmpty) {
                          return const Text('Sin actividad reciente.', style: TextStyle(color: Colors.grey));
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: events.length > 5 ? 5 : events.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final evt = events[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.history, size: 20),
                              title: Text(evt.description, style: const TextStyle(fontSize: 13)),
                              subtitle: Text(
                                evt.timestamp.toString().substring(0, 16),
                                style: const TextStyle(fontSize: 11),
                              ),
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
        onPressed: () => CreateEntitySheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.registerObjectTitle),
      ),
    );
  }
}
