import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import 'world_entity.dart';

class EntityDisplayHelper {
  EntityDisplayHelper._();

  /// Retrieves the custom instance name from entity magnitudes if assigned (property 'Nombre' or 'Name').
  static String? getInstanceCustomName(WorldEntity entity, [CatalogItem? species]) {
    final nameMag = entity.magnitudes.where((m) {
      final p = m.propertyName.trim().toLowerCase();
      return p == AppTechnicalStrings.propNombreLower || p == AppTechnicalStrings.propNameLower;
    }).firstOrNull;
    final val = nameMag?.stringValue?.trim();
    if (val != null && val.isNotEmpty && val != AppStrings.defaultNumismaticPiece) {
      return val;
    }

    return null;
  }

  /// Resolves the specific display name for a WorldEntity.
  /// 1. If the entity has a custom instance name (property 'Nombre' or 'Name'), returns it.
  /// 2. If the entity has a valid, non-generic Subspecies assigned, returns the specific subspecies name
  ///    (with brand if present).
  /// 3. Otherwise, falls back to the general species name.
  static String getDisplayName({
    required WorldEntity entity,
    required List<CatalogItem> catalogItems,
    List<Subspecies>? subspeciesList,
  }) {
    final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull;
    final customName = getInstanceCustomName(entity, species);
    if (customName != null) {
      return customName;
    }

    final speciesName = species?.name ?? AppStrings.containerObjectLabel;

    if (entity.subspeciesId != null && subspeciesList != null && subspeciesList.isNotEmpty) {
      final sub = subspeciesList.where((s) => s.id == entity.subspeciesId).firstOrNull;
      if (sub != null) {
        final subNameTrimmed = sub.subspeciesName.trim();
        final isGeneric = subNameTrimmed.isEmpty ||
            subNameTrimmed.toLowerCase() == AppStrings.defaultSubspeciesName.toLowerCase();

        if (!isGeneric) {
          final subWithBrand = AppStrings.subspeciesNameWithBrand(subNameTrimmed, sub.brand?.trim());
          final hasSpeciesInSub = subNameTrimmed.toLowerCase().contains(speciesName.toLowerCase());
          if (hasSpeciesInSub) {
            return subWithBrand;
          } else {
            return AppStrings.speciesWithSubspeciesDisplay(speciesName, subWithBrand);
          }
        }
      }
    }

    return speciesName;
  }
}
