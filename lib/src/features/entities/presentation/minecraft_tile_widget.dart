import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../domain/effective_entity_group.dart';
import '../domain/world_entity.dart';
import 'entity_photo_thumbnail.dart';

/// Presentation tile for the Minecraft Grid View.
/// Displays photo (via EntityPhotoThumbnail), population badge, container badge, expiration alert, and selection status.
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
    final highlightColor = theme.colorScheme.secondary;

    Widget tileContent = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected
                ? highlightColor.withAlpha(50)
                : (isDimmed
                    ? theme.colorScheme.surfaceContainerHighest.withAlpha(60)
                    : theme.colorScheme.surfaceContainerHighest.withAlpha(120)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? highlightColor
                  : (isExpired
                      ? Colors.redAccent.withAlpha(180)
                      : theme.dividerColor.withAlpha(isDimmed ? 20 : 50)),
              width: isSelected ? 3.0 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: highlightColor.withAlpha(80),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDimmed ? 5 : 15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              // Center Photo Thumbnail
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                ),
              ),

              // Top Left Status Badge (if expired)
              if (isExpired)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),

              // Bottom Right Population Badge Overlay
              if (population > 1 && !(species?.isUnique ?? false))
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
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
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (isDimmed) {
      tileContent = ColorFiltered(
        colorFilter: const ColorFilter.matrix(kGrayscaleColorMatrix),
        child: Opacity(
          opacity: 0.65,
          child: tileContent,
        ),
      );
    }

    return tileContent;
  }
}

const List<double> kGrayscaleColorMatrix = <double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0,      0,      0,      1, 0,
];
