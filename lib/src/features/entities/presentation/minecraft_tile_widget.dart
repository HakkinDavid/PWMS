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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withAlpha(50)
                : theme.colorScheme.surfaceContainerHighest.withAlpha(120),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : (isExpired ? Colors.redAccent.withAlpha(180) : theme.dividerColor.withAlpha(50)),
              width: isSelected ? 2.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
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

              // Top Left Container Badge (if container and not expired, or next to it)
              if (isContainer && containedCount > 0)
                Positioned(
                  top: 6,
                  left: isExpired ? 26 : 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colorScheme.primary.withAlpha(120), width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 9, color: theme.colorScheme.primary),
                        const SizedBox(width: 2),
                        Text(
                          '$containedCount',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Top Right Selection Indicator
              if (isSelectionMode)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface.withAlpha(200),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),

              // Bottom Right Population Badge Overlay
              if (population > 1)
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
                      '$population',
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
  }
}
