import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/updater/presentation/update_prompt_dialog.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../entities/domain/entity_photo_helper.dart';
import '../../entities/presentation/register_object_modal.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../locations/infrastructure/location_repository.dart';
import '../../locations/presentation/location_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static bool _hasCheckedForUpdateThisSession = false;

  @override
  void initState() {
    super.initState();
    if (!_hasCheckedForUpdateThisSession) {
      _hasCheckedForUpdateThisSession = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkUpdateSilently();
      });
    }
  }

  Future<void> _checkUpdateSilently() async {
    try {
      final updateService = ref.read(appUpdateServiceProvider);
      final updateInfo = await updateService.checkForUpdate();
      if (!mounted) return;
      if (updateInfo.isAvailable) {
        await UpdatePromptDialog.show(
          context,
          updateInfo: updateInfo,
          onConfirmUpdate: () => updateService.triggerUpdate(),
        );
      }
    } catch (_) {
      // Ignorar silenciosamente errores en verificación al inicio
    }
  }

  void _showFullHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final activityAsync = ref.watch(recentActivityProvider);

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(100),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.activityTitle,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: activityAsync.when(
                    data: (events) {
                      if (events.isEmpty) {
                        return const Center(child: Text(AppStrings.noActivityRegistered));
                      }
                      return ListView.separated(
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (c, idx) {
                          final evt = events[idx];
                          return ListTile(
                            leading: Icon(
                              evt.eventType == 'creation'
                                  ? Icons.add_circle_outline
                                  : evt.eventType == 'deletion'
                                      ? Icons.delete_outline
                                      : Icons.history,
                              color: theme.colorScheme.primary,
                            ),
                            title: Text(evt.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(evt.timestamp.toString().substring(0, 16)),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Text('${AppStrings.errorPrefix}$err'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recentEntitiesAsync = ref.watch(recentEntitiesProvider);
    final locationsAsync = ref.watch(locationNodeListProvider);
    final catalogAsync = ref.watch(catalogListProvider);
    final entitiesAsync = ref.watch(entityListProvider);
    final activityAsync = ref.watch(recentActivityProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar Header & Search / Notification Icons
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
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.style_outlined, size: 28, color: Colors.white),
                          tooltip: AppStrings.controlCenterTooltip,
                          onPressed: () => context.push('/control-center'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined, size: 28),
                          tooltip: AppStrings.settingsTooltip,
                          onPressed: () => context.push('/settings'),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final notificationsAsync = ref.watch(notificationListProvider);
                            final notifCount = notificationsAsync.asData?.value.length ?? 0;
                            return Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications_outlined, size: 28),
                                  onPressed: () => context.push('/notifications'),
                                  tooltip: AppStrings.notificationsTooltip,
                                ),
                                if (notifCount > 0)
                                  Positioned(
                                    right: 6,
                                    top: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Text(
                                        '$notifCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
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
                              child: Text(AppStrings.noRecentObjects),
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
                                    final speciesType = species?.type ?? AppStrings.typeObject;

                                    return FutureBuilder<Subspecies?>(
                                      future: entity.subspeciesId != null
                                          ? ref.read(catalogRepositoryProvider).getSubspeciesById(entity.subspeciesId!)
                                          : Future.value(null),
                                      builder: (context, subSnapshot) {
                                        final subspecies = subSnapshot.data;
                                        final isCustomSubspecies = subspecies != null && subspecies.subspeciesName.toLowerCase() != 'genérica';
                                        final primaryTitle = isCustomSubspecies
                                            ? '${subspecies.subspeciesName}${subspecies.brand != null ? " (${subspecies.brand})" : ""}'
                                            : (species?.name ?? AppStrings.typeObject);

                                        return FutureBuilder<String?>(
                                          future: resolveEffectiveEntityPhotoPath(
                                            ref,
                                            subspecies: subspecies,
                                            species: species,
                                            instanceId: entity.id,
                                          ),
                                          builder: (context, photoPathSnapshot) {
                                            final effectivePhotoPath = photoPathSnapshot.data;

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(14),
                                                    child: FutureBuilder<String>(
                                                      future: effectivePhotoPath != null && effectivePhotoPath.isNotEmpty
                                                          ? ref.read(fileStorageServiceProvider).getAbsolutePath(effectivePhotoPath)
                                                          : Future.value(''),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                                          return Image.file(
                                                            File(snapshot.data!),
                                                            width: double.infinity,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (_, __, ___) => Container(
                                                              color: theme.colorScheme.primary.withAlpha(30),
                                                              child: Center(
                                                                child: Icon(Icons.category, color: theme.colorScheme.primary),
                                                              ),
                                                            ),
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
                                                  primaryTitle,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  isCustomSubspecies ? '$speciesType • ${species?.name}' : speciesType,
                                                  style: TextStyle(color: theme.colorScheme.secondary, fontSize: 11),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
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
                    error: (e, _) => Text('${AppStrings.errorPrefix}$e'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.topLocationsTitle,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => context.go('/locations'),
                          child: const Text('Ver todas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    locationsAsync.when(
                      data: (nodes) {
                        if (nodes.isEmpty) {
                          return const Text(AppStrings.emptyLocation, style: TextStyle(color: Colors.grey));
                        }

                        final allEntities = entitiesAsync.asData?.value ?? [];

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

                            return LocationTile(
                              node: node,
                              itemCount: count,
                              onTap: () => context.go('/inventory?focusNodeId=${node.id}'),
                            );
                          },
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, _) => Text('${AppStrings.errorPrefix}$err'),
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
                            AppStrings.latestCatalogSpeciesTitle,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/catalog'),
                          child: const Text(AppStrings.viewCatalogAction),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    catalogAsync.when(
                      data: (items) {
                        if (items.isEmpty) {
                          return const Text(AppStrings.emptyCatalog, style: TextStyle(color: Colors.grey));
                        }

                        final sortedItems = List.of(items)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                        final recentItems = sortedItems.take(4).toList();
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
                      error: (err, _) => Text('${AppStrings.errorPrefix}$err'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Section 4: Historial de Actividad (Latest 3 + "Ver todo")
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.activityTitle,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => _showFullHistoryModal(context),
                          child: const Text(AppStrings.viewAllAction),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    activityAsync.when(
                      data: (events) {
                        if (events.isEmpty) {
                          return const Text(AppStrings.noRecentActivity, style: TextStyle(color: Colors.grey));
                        }

                        final topEvents = events.take(3).toList();
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: topEvents.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final evt = topEvents[index];
                            return ListTile(
                              leading: Icon(
                                evt.eventType == 'creation'
                                    ? Icons.add_circle_outline
                                    : evt.eventType == 'deletion'
                                        ? Icons.delete_outline
                                        : Icons.history,
                                color: theme.colorScheme.primary,
                              ),
                              title: Text(evt.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(evt.timestamp.toString().substring(0, 16)),
                            );
                          },
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, _) => Text('${AppStrings.errorPrefix}$err'),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => RegisterObjectModal.show(context),
        tooltip: AppStrings.registerObjectTitle,
        child: const Icon(Icons.add),
      ),
    );
  }
}
