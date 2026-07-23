import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/subspecies.dart';
import '../../locations/domain/location_path_helper.dart';
import '../domain/effective_entity_group.dart';
import '../domain/world_entity.dart';

class InstancePreviewCard extends ConsumerWidget {
  final WorldEntity? entity;
  final EffectiveEntityGroup? group;
  final VoidCallback? onTap;
  final Widget? trailing;

  const InstancePreviewCard({
    super.key,
    this.entity,
    this.group,
    this.onTap,
    this.trailing,
  }) : assert(entity != null || group != null, AppStrings.mustProvideEntityOrGroup);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final allEntities = ref.watch(entityListProvider).asData?.value ?? [];
    final allRelations = ref.watch(relationListProvider).asData?.value ?? [];
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final locationNodes = locationsState.asData?.value ?? [];

    final targetEntity = entity ?? group!.primaryEntity;
    final speciesId = entity?.speciesId ?? group!.speciesId;
    final effectiveLocId = entity?.locationId ?? group!.effectiveLocationId;
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
    );

    return FutureBuilder<Subspecies?>(
      future: subspeciesId != null
          ? ref.read(catalogRepositoryProvider).getSubspeciesById(subspeciesId)
          : Future.value(null),
      builder: (context, subSnapshot) {
        final subspecies = subSnapshot.data;
        final effectivePhotoPath = subspecies?.resolvePhotoPath(species?.mainPhotoPath);
        final isCustomSubspecies = subspecies != null && subspecies.subspeciesName.toLowerCase() != 'genérica';

        final primaryTitle = isCustomSubspecies
            ? '${subspecies.subspeciesName}${subspecies.brand != null ? " (${subspecies.brand})" : ""}'
            : speciesName;

        final typeAndSpeciesText = isCustomSubspecies
            ? '$speciesType • $speciesName • '
            : '$speciesType • ';

        final firstMag = targetEntity.magnitudes.isNotEmpty ? targetEntity.magnitudes.first : null;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1.5,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // Photo with Subspecies Fallback to Species
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: FutureBuilder<String>(
                        future: effectivePhotoPath != null && effectivePhotoPath.isNotEmpty
                            ? ref.read(fileStorageServiceProvider).getAbsolutePath(effectivePhotoPath)
                            : Future.value(''),
                        builder: (context, photoSnapshot) {
                          if (photoSnapshot.hasData && photoSnapshot.data!.isNotEmpty && File(photoSnapshot.data!).existsSync()) {
                            return Image.file(File(photoSnapshot.data!), fit: BoxFit.cover);
                          }
                          return Container(
                            color: theme.colorScheme.primary.withAlpha(20),
                            child: Icon(Icons.category, color: theme.colorScheme.primary, size: 24),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Info Column (Subspecies as main title, Species as secondary context)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          primaryTitle,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
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
                                        text: '${breadcrumb.ancestorPath} ',
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
                        if (subspecies?.barcode != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.qr_code, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${AppStrings.barcodeLabel}: ${subspecies!.barcode}',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                        if (firstMag != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${firstMag.propertyName}: ${DomainRules.formatMagnitude(firstMag.magnitudeValue, firstMag.unitSymbol)} ${firstMag.unitSymbol}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
