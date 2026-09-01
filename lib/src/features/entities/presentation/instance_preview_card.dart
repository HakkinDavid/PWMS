import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../../core/widgets/minecraft_grid_cell.dart';
import '../../../core/widgets/standard_item_card.dart';
import '../../catalog/domain/subspecies.dart';
import '../../locations/domain/location_path_helper.dart';
import '../domain/effective_entity_group.dart';
import '../domain/entity_display_helper.dart';
import '../domain/world_entity.dart';
import 'entity_photo_thumbnail.dart';

enum InstanceCardLayout {
  list,
  compactCard,
}

const List<double> kGrayscaleColorMatrix = kMinecraftGrayscaleColorMatrix;

/// Presentation card tile for an instance/entity or group in list or compact card view.
/// Adapts [WorldEntity] / [EffectiveEntityGroup] domain data into the shared [StandardItemCard] or compact vertical card layout.
class InstancePreviewCard extends ConsumerWidget {
  final WorldEntity? entity;
  final EffectiveEntityGroup? group;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isSelected;
  final bool isSelectionMode;
  final InstanceCardLayout layout;

  const InstancePreviewCard({
    super.key,
    this.entity,
    this.group,
    this.onTap,
    this.trailing,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.layout = InstanceCardLayout.list,
  }) : assert(entity != null || group != null, AppStrings.mustProvideEntityOrGroup);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final allEntities = ref.watch(entityListProvider).asData?.value ?? [];
    final allRelations = ref.watch(relationListProvider).asData?.value ?? [];
    final subspeciesList = ref.watch(subspeciesListProvider).asData?.value ?? [];
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final locationNodes = locationsState.asData?.value ?? [];

    final targetEntity = entity ?? group?.primaryEntity;
    if (targetEntity == null) return const SizedBox.shrink();

    final speciesId = entity?.speciesId ?? group?.speciesId;
    final effectiveLocId = entity?.locationId ?? group?.effectiveLocationId;
    final subspeciesId = targetEntity.subspeciesId;

    final species = catalogItems.where((c) => c.id == speciesId).firstOrNull;
    final speciesName = species?.name ?? AppStrings.typeObject;
    final speciesType = species?.type ?? AppStrings.typeObject;

    final breadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
      entityId: targetEntity.id,
      effectiveLocationId: effectiveLocId,
      allEntities: allEntities,
      allRelations: allRelations,
      allNodes: locationNodes,
      catalogItems: catalogItems,
      subspeciesList: subspeciesList,
    );

    return FutureBuilder<Subspecies?>(
      future: subspeciesId != null
          ? ref.read(catalogRepositoryProvider).getSubspeciesById(subspeciesId)
          : Future.value(null),
      builder: (context, subSnapshot) {
        final subspecies = subSnapshot.data;

        final customInstanceName = EntityDisplayHelper.getInstanceCustomName(targetEntity);
        final isCustomSub = subspecies != null && subspecies.subspeciesName.toLowerCase() != AppTechnicalStrings.genericSubspeciesLower;
        final String primaryTitle;
        final String typeAndSpeciesText;

        if (customInstanceName != null && customInstanceName.isNotEmpty) {
          primaryTitle = customInstanceName;
          if (isCustomSub) {
            final subText = AppStrings.subspeciesNameWithBrand(subspecies.subspeciesName, subspecies.brand);
            typeAndSpeciesText = AppStrings.speciesTypeWithSpeciesNamePrefix(speciesType, subText);
          } else {
            typeAndSpeciesText = AppStrings.speciesTypeWithSpeciesNamePrefix(speciesType, speciesName);
          }
        } else if (isCustomSub) {
          primaryTitle = AppStrings.subspeciesNameWithBrand(subspecies.subspeciesName, subspecies.brand);
          typeAndSpeciesText = AppStrings.speciesTypeWithSpeciesNamePrefix(speciesType, speciesName);
        } else {
          primaryTitle = speciesName;
          typeAndSpeciesText = AppStrings.speciesTypeBulletPrefix(speciesType);
        }

        final firstMag = targetEntity.magnitudes.isNotEmpty ? targetEntity.magnitudes.first : null;

        if (layout == InstanceCardLayout.compactCard) {
          final highlightColor = theme.colorScheme.secondary;
          final effectiveIsDimmed = isSelectionMode && !isSelected;

          Widget card = Container(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? highlightColor.withAlpha(35)
                  : (effectiveIsDimmed ? theme.cardColor.withAlpha(160) : theme.cardColor),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? highlightColor
                    : theme.dividerColor.withAlpha(effectiveIsDimmed ? 20 : 60),
                width: isSelected ? 2.5 : 1.0,
              ),
            ),
            child: InkWell(
              onTap: onTap ?? () => context.pushEntityDetail(targetEntity.id),
              borderRadius: BorderRadius.circular(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: double.infinity,
                      height: 85,
                      child: EntityPhotoThumbnail(
                        species: species,
                        subspecies: subspecies,
                        instanceId: targetEntity.id,
                        size: 85,
                        width: double.infinity,
                        height: 85,
                        borderRadius: BorderRadius.circular(14),
                        useTextBadgeFallback: true,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    primaryTitle,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isCustomSub ? AppStrings.speciesTypeWithBullet(speciesType, species?.name) : speciesType,
                    style: TextStyle(color: theme.colorScheme.secondary, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildBadges(
                    species: species,
                    allRelations: allRelations,
                    targetEntity: targetEntity,
                    entity: entity,
                    group: group,
                  ),
                ],
              ),
            ),
          );

          if (effectiveIsDimmed) {
            card = ColorFiltered(
              colorFilter: const ColorFilter.matrix(kMinecraftGrayscaleColorMatrix),
              child: Opacity(
                opacity: 0.65,
                child: card,
              ),
            );
          }

          return card;
        }

        return StandardItemCard(
          onTap: onTap ?? () => context.pushEntityDetail(targetEntity.id),
          isSelected: isSelected,
          isSelectionMode: isSelectionMode,
          leading: EntityPhotoThumbnail(
            species: species,
            subspecies: subspecies,
            instanceId: targetEntity.id,
            size: 48,
            borderRadius: BorderRadius.circular(12),
            useTextBadgeFallback: true,
            fit: BoxFit.cover,
          ),
          title: Text(
            primaryTitle,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Icon(Icons.account_tree_outlined, size: 12, color: theme.colorScheme.secondary),
              const SizedBox(width: 4),
              Expanded(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    children: [
                      TextSpan(text: typeAndSpeciesText),
                      if (breadcrumb.ancestorPath.isNotEmpty)
                        TextSpan(
                          text: AppStrings.ancestorPathWithSpace(breadcrumb.ancestorPath),
                          style: TextStyle(color: theme.colorScheme.secondary.withAlpha(160)),
                        ),
                      TextSpan(
                        text: breadcrumb.targetName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          extraContent: [
            if (subspecies?.barcode != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.qr_code, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      AppStrings.barcodeWithColon(subspecies!.barcode!),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (firstMag != null) ...[
              const SizedBox(height: 2),
              Text(
                AppStrings.propertyWithColon(firstMag.propertyName, firstMag.displayValue),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
            _buildBadges(
              species: species,
              allRelations: allRelations,
              targetEntity: targetEntity,
              entity: entity,
              group: group,
            ),
          ],
          trailing: trailing,
        );
      },
    );
  }

  Widget _buildBadges({
    required CatalogItem? species,
    required List<dynamic> allRelations,
    required WorldEntity targetEntity,
    required WorldEntity? entity,
    required EffectiveEntityGroup? group,
  }) {
    final canExpire = species?.canExpire ?? false;
    final warningDays = species?.warningDaysBeforeExpiration ?? 7;
    final now = DateTime.now();

    final isContained = allRelations.any((r) => r.sourceEntityId == targetEntity.id && r.relationType == AppTechnicalStrings.relGuardadoEn);
    final isOrphan = entity != null && targetEntity.locationId == null && !isContained;
    final isMissingExpiration = entity != null && (species?.isNonPerishable == false) && targetEntity.expirationDate == null;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        if (isOrphan)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber.shade900.withAlpha(40),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.amber.shade700, width: 0.8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, size: 10, color: Colors.amber),
                SizedBox(width: 3),
                Flexible(
                  child: Text(
                    AppStrings.badgeOrphan,
                    style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        if (isMissingExpiration)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900.withAlpha(40),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blueGrey.shade300, width: 0.8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_busy, size: 10, color: Colors.blueGrey),
                SizedBox(width: 3),
                Flexible(
                  child: Text(
                    AppStrings.badgeMissingExpiration,
                    style: TextStyle(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        if (canExpire && entity != null) ...[
          if (entity.isExpired(canExpire: canExpire, now: now))
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red.shade400, width: 0.8),
              ),
              child: const Text(
                AppStrings.statusExpired,
                style: TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            )
          else if (entity.isExpiringSoon(warningDays: warningDays, canExpire: canExpire, now: now))
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade900.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange.shade400, width: 0.8),
              ),
              child: const Text(
                AppStrings.statusWarning,
                style: TextStyle(fontSize: 10, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
              ),
            ),
        ],
        if (canExpire && group != null) ...[
          Builder(
            builder: (context) {
              final expiredCnt = group.expiredCount(canExpire: canExpire, now: now);
              final warningCnt = group.expiringSoonCount(warningDays: warningDays, canExpire: canExpire, now: now);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (expiredCnt > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 4, right: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.red.shade400, width: 0.8),
                      ),
                      child: Text(
                        AppStrings.countWithStatus(expiredCnt, AppStrings.statusExpired),
                        style: const TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (warningCnt > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade900.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.orange.shade400, width: 0.8),
                      ),
                      child: Text(
                        AppStrings.countWithStatus(warningCnt, AppStrings.statusWarning),
                        style: const TextStyle(fontSize: 10, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}
