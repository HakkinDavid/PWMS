import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../domain/catalog_item.dart';
import 'species_form_modal.dart';
import 'species_text_badge_avatar.dart';

class SpeciesTile extends ConsumerWidget {
  final CatalogItem species;
  final VoidCallback? onInstantiate;
  final VoidCallback? onTap;

  const SpeciesTile({
    super.key,
    required this.species,
    this.onInstantiate,
    this.onTap,
  });

  void _showQuickActionsMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text(AppStrings.viewSpeciesDetail),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/catalog/${species.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text(AppStrings.instantiateAction),
              onTap: () {
                Navigator.pop(ctx);
                InstantiateSpeciesSheet.show(context, species: species);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text(AppStrings.editSpeciesTitle),
              onTap: () {
                Navigator.pop(ctx);
                SpeciesFormModal.show(
                  context,
                  initialSpecies: species,
                  onSpeciesSaved: (_) {
                    ref.invalidate(catalogListProvider);
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text(AppStrings.deleteConfirmationTitle),
                    content: Text('${AppStrings.deleteConfirmationMessage} "${species.name}"?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text(AppStrings.cancel)),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(c, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        child: const Text(AppStrings.delete),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await ref.read(catalogListProvider.notifier).deleteCatalogItem(species.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final allEntities = entitiesState.asData?.value ?? [];
    final hasInstance = allEntities.any((e) => e.speciesId == species.id);

    final showInstantiateButton = !(species.isUnique && hasInstance);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onLongPress: () => _showQuickActionsMenu(context, ref),
        onTap: onTap ?? () => context.push('/catalog/${species.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: FutureBuilder<String>(
                    future: species.mainPhotoPath != null
                        ? ref.read(fileStorageServiceProvider).getAbsolutePath(species.mainPhotoPath!)
                        : Future.value(''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                        return Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.contain, // Transparent PNG support
                        );
                      }
                      return SpeciesTextBadgeAvatar(
                        speciesName: species.name,
                        size: 44,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species.name,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            species.type,
                            style: TextStyle(color: theme.colorScheme.secondary, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (species.isUnique) ...[
                          const Text(' • ', style: TextStyle(fontSize: 11)),
                          const Text(AppStrings.isUniqueLabel, style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              if (showInstantiateButton)
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  tooltip: AppStrings.instantiateAction,
                  onPressed: onInstantiate ??
                      () {
                        InstantiateSpeciesSheet.show(context, species: species);
                      },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
