import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/species_text_badge_avatar.dart';
import '../domain/entity_photo_helper.dart';

/// Unified widget for resolving, caching, and displaying entity, subspecies, and species photos
/// with consistent fallback avatars and error handling.
class EntityPhotoThumbnail extends ConsumerStatefulWidget {
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
  ConsumerState<EntityPhotoThumbnail> createState() => _EntityPhotoThumbnailState();
}

class _EntityPhotoThumbnailState extends ConsumerState<EntityPhotoThumbnail> {
  Future<String?>? _photoPathFuture;

  @override
  void initState() {
    super.initState();
    _loadPhotoPath();
  }

  @override
  void didUpdateWidget(covariant EntityPhotoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.species?.id != widget.species?.id ||
        oldWidget.subspecies?.id != widget.subspecies?.id ||
        oldWidget.subspeciesId != widget.subspeciesId ||
        oldWidget.instanceId != widget.instanceId ||
        oldWidget.photoPath != widget.photoPath) {
      _loadPhotoPath();
    }
  }

  void _loadPhotoPath() {
    _photoPathFuture = _resolvePath();
  }

  Future<String?> _resolvePath() async {
    if (widget.photoPath != null && widget.photoPath!.isNotEmpty) {
      final storage = ref.read(fileStorageServiceProvider);
      return storage.getAbsolutePath(widget.photoPath!);
    }

    Subspecies? targetSub = widget.subspecies;
    if (targetSub == null && widget.subspeciesId != null) {
      final subList = ref.read(subspeciesListProvider).asData?.value;
      targetSub = subList?.where((s) => s.id == widget.subspeciesId).firstOrNull;
      if (targetSub == null) {
        targetSub = await ref.read(catalogRepositoryProvider).getSubspeciesById(widget.subspeciesId!);
      }
    }

    final relPath = await resolveEffectiveEntityPhotoPath(
      ref,
      subspecies: targetSub,
      species: widget.species,
      instanceId: widget.instanceId,
    );

    if (relPath != null && relPath.isNotEmpty) {
      final storage = ref.read(fileStorageServiceProvider);
      return storage.getAbsolutePath(relPath);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = widget.width ?? widget.size;
    final effectiveHeight = widget.height ?? widget.size;
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    final speciesName = widget.species?.name ?? AppStrings.typeObject;

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: FutureBuilder<String?>(
          future: _photoPathFuture,
          builder: (context, snapshot) {
            final absPath = snapshot.data;
            if (absPath != null && absPath.isNotEmpty && File(absPath).existsSync()) {
              return Image.file(
                File(absPath),
                width: effectiveWidth,
                height: effectiveHeight,
                fit: widget.fit,
                errorBuilder: (_, __, ___) => _buildFallback(context, speciesName, effectiveWidth, effectiveHeight),
              );
            }
            return _buildFallback(context, speciesName, effectiveWidth, effectiveHeight);
          },
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context, String speciesName, double w, double h) {
    final theme = Theme.of(context);

    if (widget.useTextBadgeFallback && speciesName.isNotEmpty) {
      return SpeciesTextBadgeAvatar(
        speciesName: speciesName,
        size: widget.size,
      );
    }

    return Container(
      width: w,
      height: h,
      color: widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest.withAlpha(120),
      child: Center(
        child: Icon(
          widget.fallbackIcon,
          size: (widget.size * 0.6).clamp(16.0, 48.0),
          color: widget.iconColor ?? theme.colorScheme.primary,
        ),
      ),
    );
  }
}
