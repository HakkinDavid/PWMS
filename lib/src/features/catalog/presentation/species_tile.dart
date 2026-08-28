import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../../core/widgets/standard_item_card.dart';
import '../../entities/presentation/entity_photo_thumbnail.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../domain/catalog_item.dart';
import 'species_quick_actions_sheet.dart';

/// Presentation card tile for a species in list view.
/// Adapts [CatalogItem] domain data into the shared [StandardItemCard] layout.
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

  static void showQuickActionsMenu(BuildContext context, WidgetRef ref, CatalogItem species) {
    SpeciesQuickActionsSheet.show(context, ref, species);
  }

  void _showQuickActionsMenu(BuildContext context, WidgetRef ref) {
    SpeciesQuickActionsSheet.show(context, ref, species);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final allEntities = entitiesState.asData?.value ?? [];
    final hasInstance = allEntities.any((e) => e.speciesId == species.id);

    final showInstantiateButton = !(species.isUnique && hasInstance);

    return StandardItemCard(
      onTap: onTap ?? () => context.pushSpeciesDetail(species.id),
      onLongPress: () => _showQuickActionsMenu(context, ref),
      leading: EntityPhotoThumbnail(
        species: species,
        size: 48,
        borderRadius: BorderRadius.circular(12),
        useTextBadgeFallback: true,
        fit: BoxFit.cover,
      ),
      title: Text(
        species.name,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
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
            const Text(AppTechnicalStrings.bulletSeparator, style: TextStyle(fontSize: 11)),
            const Text(AppStrings.isUniqueLabel, style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ],
      ),
      trailing: showInstantiateButton
          ? IconButton(
              icon: const Icon(Icons.add, size: 20),
              tooltip: AppStrings.instantiateAction,
              onPressed: onInstantiate ??
                  () {
                    InstantiateSpeciesSheet.show(context, species: species);
                  },
            )
          : null,
    );
  }
}
