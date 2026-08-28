import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/minecraft_grid_cell.dart';
import '../domain/effective_entity_group.dart';
import '../domain/world_entity.dart';
import 'entity_photo_thumbnail.dart';

const List<double> kGrayscaleColorMatrix = kMinecraftGrayscaleColorMatrix;

/// Presentation adapter tile for the Inventory Minecraft Grid View.
/// Resolves domain entity properties (species, subspecies, expiration, population count)
/// and delegates UI rendering to [MinecraftGridCell].
class MinecraftTileWidget extends ConsumerWidget {
  final EffectiveEntityGroup? group;
  final WorldEntity? entity;
  final String title;
  final String? photoPath;
  final IconData icon;
  final bool isSelected;
  final bool isSelectionMode;
  final bool isContainer;
  final int containedCount;
  final bool isExpired;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const MinecraftTileWidget({
    super.key,
    this.group,
    this.entity,
    required this.title,
    this.photoPath,
    this.icon = Icons.inventory_2_outlined,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.isContainer = false,
    this.containedCount = 0,
    this.isExpired = false,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final population = group?.population ?? 1;
    final targetEntityId = entity?.id ?? group?.primaryEntity.id;
    final speciesId = entity?.speciesId ?? group?.speciesId;
    final subspeciesId = entity?.subspeciesId ?? group?.primaryEntity.subspeciesId;

    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
    final subspeciesList = ref.watch(subspeciesListProvider).asData?.value ?? [];
    final species = speciesId != null ? catalogItems.where((c) => c.id == speciesId).firstOrNull : null;
    final subspecies = subspeciesId != null ? subspeciesList.where((s) => s.id == subspeciesId).firstOrNull : null;

    final isDimmed = isSelectionMode && !isSelected;

    Widget? populationBadge;
    if (population > 1 && !(species?.isUnique ?? false)) {
      populationBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.colorScheme.primary.withAlpha(100)),
        ),
        child: Text(
          population.toString(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }

    Widget? containerBadge;
    if (isContainer) {
      containerBadge = Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer.withAlpha(220),
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.secondary,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          Icons.inventory_2_rounded,
          size: 11,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      );
    }

    return MinecraftGridCell(
      onTap: onTap,
      onLongPress: onLongPress,
      isSelected: isSelected,
      isDimmed: isDimmed,
      isExpired: isExpired,
      isContainer: isContainer,
      topLeftBadge: containerBadge,
      topRightBadge: isExpired && containerBadge != null
          ? Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 11,
                color: Colors.white,
              ),
            )
          : null,
      bottomRightBadge: populationBadge,
      child: EntityPhotoThumbnail(
        species: species,
        subspecies: subspecies,
        subspeciesId: subspeciesId,
        instanceId: targetEntityId,
        photoPath: photoPath,
        size: 54,
        borderRadius: BorderRadius.circular(12),
        fallbackIcon: icon,
        useTextBadgeFallback: true,
        fit: BoxFit.cover,
      ),
    );
  }
}
