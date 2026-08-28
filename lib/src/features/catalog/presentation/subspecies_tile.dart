import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/entity_tile.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';
import 'species_text_badge_avatar.dart';

class SubspeciesTile extends ConsumerWidget {
  final Subspecies subspecies;
  final String? speciesName;
  final CatalogItem? species;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isExpandable;
  final bool initiallyExpanded;
  final List<WorldEntity>? instances;

  const SubspeciesTile({
    super.key,
    required this.subspecies,
    this.speciesName,
    this.species,
    this.onTap,
    this.trailing,
    this.isExpandable = false,
    this.initiallyExpanded = false,
    this.instances,
  });

  Widget _buildLeadingThumbnail(BuildContext context, WidgetRef ref) {
    final photoPath = subspecies.photoPath;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 40,
        height: 40,
        child: FutureBuilder<String>(
          future: photoPath != null && photoPath.isNotEmpty
              ? ref.read(fileStorageServiceProvider).getAbsolutePath(photoPath)
              : Future.value(AppTechnicalStrings.empty),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
              return Image.file(
                File(snapshot.data!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => SpeciesTextBadgeAvatar(
                  speciesName: speciesName ?? subspecies.subspeciesName,
                  size: 40,
                ),
              );
            }
            return SpeciesTextBadgeAvatar(
              speciesName: speciesName ?? subspecies.subspeciesName,
              size: 40,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final titleText = AppStrings.subspeciesNameWithBrand(subspecies.subspeciesName, subspecies.brand);
    final subtitleText = subspecies.barcode != null && subspecies.barcode!.isNotEmpty
        ? AppStrings.barcodeWithColon(subspecies.barcode!)
        : (subspecies.notes ?? AppTechnicalStrings.empty);

    if (!isExpandable) {
      return Card(
        margin: const EdgeInsets.only(bottom: 6),
        elevation: 1.0,
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          onTap: onTap ?? () => context.pushSpeciesDetail(subspecies.speciesId),
          leading: _buildLeadingThumbnail(context, ref),
          title: Text(
            titleText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          subtitle: subtitleText.isNotEmpty
              ? Text(
                  subtitleText,
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: trailing,
        ),
      );
    }

    final targetInstances = instances ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.dividerColor.withAlpha(40), width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: ValueKey<String>(subspecies.id),
        initiallyExpanded: initiallyExpanded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide.none,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide.none,
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 2),
        leading: _buildLeadingThumbnail(context, ref),
        title: Text(
          titleText,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitleText.isNotEmpty)
              Text(
                subtitleText,
                style: TextStyle(fontSize: 11, color: theme.colorScheme.secondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 12,
                  color: targetInstances.isNotEmpty ? theme.colorScheme.primary : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  AppStrings.instancesCount(targetInstances.length),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: targetInstances.isNotEmpty ? theme.colorScheme.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: trailing != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  trailing!,
                  const Icon(Icons.expand_more, size: 20),
                ],
              )
            : null,
        children: [
          if (targetInstances.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      AppStrings.notInstantiatedYet,
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ),
                  if (species != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text(AppStrings.instantiateAction, style: TextStyle(fontSize: 11)),
                      onPressed: () {
                        InstantiateSpeciesSheet.show(
                          context,
                          species: species!,
                          initialSubspecies: subspecies,
                        );
                      },
                    ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: targetInstances.length,
              itemBuilder: (ctx, idx) {
                return EntityTile(entity: targetInstances[idx]);
              },
            ),
        ],
      ),
    );
  }
}
