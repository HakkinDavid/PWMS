import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../../core/widgets/minecraft_grid_cell.dart';
import '../../entities/presentation/entity_photo_thumbnail.dart';
import '../domain/catalog_item.dart';
import 'species_quick_actions_sheet.dart';

/// Presentation adapter tile to display a Species (CatalogItem) in Minecraft Grid mode.
class SpeciesMinecraftTile extends ConsumerWidget {
  final CatalogItem species;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SpeciesMinecraftTile({
    super.key,
    required this.species,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MinecraftGridCell(
      onTap: onTap ?? () => context.pushSpeciesDetail(species.id),
      onLongPress: onLongPress ?? () => SpeciesQuickActionsSheet.show(context, ref, species),
      child: EntityPhotoThumbnail(
        species: species,
        size: 54,
        borderRadius: BorderRadius.circular(12),
        useTextBadgeFallback: true,
        fit: BoxFit.cover,
      ),
    );
  }
}
