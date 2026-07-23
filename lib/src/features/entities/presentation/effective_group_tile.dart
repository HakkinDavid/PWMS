import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../locations/domain/location_path_helper.dart';
import '../domain/effective_entity_group.dart';
import 'grouped_instance_detail_sheet.dart';

class EffectiveGroupTile extends ConsumerWidget {
  final EffectiveEntityGroup group;

  const EffectiveGroupTile({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final locationNodes = locationsState.asData?.value ?? [];

    final species = catalogItems.where((c) => c.id == group.speciesId).firstOrNull;
    final name = species?.name ?? AppStrings.typeObject;
    final type = species?.type ?? AppStrings.typeObject;

    final breadcrumb = LocationPathHelper.buildBreadcrumbPath(group.effectiveLocationId, locationNodes);
    final firstEntity = group.primaryEntity;
    final firstMag = firstEntity.magnitudes.isNotEmpty ? firstEntity.magnitudes.first : null;

    final isSingle = group.population == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSingle ? 1 : 2,
      child: InkWell(
        onTap: () {
          if (isSingle) {
            context.push('/entity/${firstEntity.id}');
          } else {
            GroupedInstanceDetailSheet.show(context, group);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Species Photo / Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: FutureBuilder<String>(
                    future: species?.mainPhotoPath != null
                        ? ref.read(fileStorageServiceProvider).getAbsolutePath(species!.mainPhotoPath!)
                        : Future.value(''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                        return Image.file(File(snapshot.data!), fit: BoxFit.cover);
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

              // Species Name & Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
                                TextSpan(text: '$type • '),
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
                    if (firstMag != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Magnitud: ${DomainRules.formatMagnitude(firstMag.magnitudeValue, firstMag.unitSymbol)} ${firstMag.unitSymbol}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ),

              // Elegant Population Chip with WheelPicker icon trigger
              const SizedBox(width: 8),
              InkWell(
                onTap: () => GroupedInstanceDetailSheet.show(context, group),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.primary.withAlpha(60)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.unfold_more, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${group.population}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
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
