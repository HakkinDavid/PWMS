import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/species_text_badge_avatar.dart';
import '../domain/entity_photo_helper.dart';

/// Unified widget for resolving, caching, and displaying entity, subspecies, and species photos
/// with consistent fallback avatars and error handling.
class EntityPhotoThumbnail extends ConsumerWidget {
  final CatalogItem? species;
  final Subspecies? subspecies;
  final String? subspeciesId;
  final String? instanceId;
  final String? photoPath;
  final double size;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final IconData fallbackIcon;
  final bool useTextBadgeFallback;
  final BoxFit fit;
  final Color? iconColor;
  final Color? backgroundColor;

  const EntityPhotoThumbnail({
    super.key,
    this.species,
    this.subspecies,
    this.subspeciesId,
    this.instanceId,
    this.photoPath,
    this.size = 48.0,
    this.width,
    this.height,
    this.borderRadius,
    this.fallbackIcon = Icons.inventory_2_outlined,
    this.useTextBadgeFallback = true,
    this.fit = BoxFit.cover,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveWidth = width ?? size;
    final effectiveHeight = height ?? size;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final speciesName = species?.name ?? 'Objeto';

    // 1. Resolve subspecies if not directly provided
    final effectiveSubspecies = subspecies ??
        (subspeciesId != null
            ? (ref.watch(subspeciesListProvider).asData?.value.where((s) => s.id == subspeciesId).firstOrNull)
            : null);

    final resolvedSubspeciesFuture = (subspecies == null && effectiveSubspecies == null && subspeciesId != null)
        ? ref.read(catalogRepositoryProvider).getSubspeciesById(subspeciesId!)
        : Future.value(effectiveSubspecies);

    // 2. Watch instance attachments if instanceId is present for reactive updates
    final attachmentsState = (instanceId != null && instanceId!.isNotEmpty)
        ? ref.watch(instanceAttachmentsProvider(instanceId!))
        : null;

    final attachedImagePath = attachmentsState?.asData?.value.where((a) {
      if (a.fileType == 'image') return true;
      final path = a.filePath.toLowerCase();
      return path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.png') ||
          path.endsWith('.webp') ||
          path.endsWith('.heic') ||
          path.endsWith('.bmp');
    }).firstOrNull?.filePath;

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: FutureBuilder<Subspecies?>(
          future: resolvedSubspeciesFuture,
          builder: (context, subSnapshot) {
            final currentSub = subSnapshot.data ?? effectiveSubspecies;

            final effectivePhotoFuture = (photoPath != null && photoPath!.isNotEmpty)
                ? Future.value(photoPath)
                : (attachedImagePath != null && attachedImagePath.isNotEmpty)
                    ? Future.value(attachedImagePath)
                    : resolveEffectiveEntityPhotoPath(
                        ref,
                        subspecies: currentSub,
                        species: species,
                        instanceId: instanceId,
                      );

            return FutureBuilder<String?>(
              future: effectivePhotoFuture,
              builder: (context, photoSnapshot) {
                final relPath = photoSnapshot.data;

                if (relPath != null && relPath.isNotEmpty) {
                  return FutureBuilder<String>(
                    future: ref.read(fileStorageServiceProvider).getAbsolutePath(relPath),
                    builder: (context, absSnapshot) {
                      final absPath = absSnapshot.data ?? '';
                      if (absPath.isNotEmpty && File(absPath).existsSync()) {
                        return Image.file(
                          File(absPath),
                          width: effectiveWidth,
                          height: effectiveHeight,
                          fit: fit,
                          errorBuilder: (_, __, ___) => _buildFallback(context, speciesName, effectiveWidth, effectiveHeight),
                        );
                      }
                      return _buildFallback(context, speciesName, effectiveWidth, effectiveHeight);
                    },
                  );
                }

                return _buildFallback(context, speciesName, effectiveWidth, effectiveHeight);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context, String speciesName, double w, double h) {
    final theme = Theme.of(context);

    if (useTextBadgeFallback && speciesName.isNotEmpty) {
      return SpeciesTextBadgeAvatar(
        speciesName: speciesName,
        size: size,
      );
    }

    return Container(
      width: w,
      height: h,
      color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest.withAlpha(120),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: (size * 0.6).clamp(16.0, 48.0),
          color: iconColor ?? theme.colorScheme.primary,
        ),
      ),
    );
  }
}
