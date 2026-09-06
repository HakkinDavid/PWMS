import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/numismatic_data_helper.dart';
import '../../catalog/domain/subspecies.dart';
import 'world_entity.dart';

class EntityDisplayHelper {
  EntityDisplayHelper._();

  /// Retrieves the custom instance name from entity magnitudes if assigned (property 'Nombre' or 'Name'),
  /// or derives it dynamically for numismatic species (Moneda and Billete) based on their attributes.
  static String? getInstanceCustomName(WorldEntity entity, [CatalogItem? species]) {
    final nameMag = entity.magnitudes.where((m) {
      final p = m.propertyName.trim().toLowerCase();
      return p == AppTechnicalStrings.propNombreLower || p == AppTechnicalStrings.propNameLower;
    }).firstOrNull;
    final val = nameMag?.stringValue?.trim();
    if (val != null && val.isNotEmpty && val != AppStrings.defaultNumismaticPiece) {
      return val;
    }

    if (NumismaticDataHelper.isNumismaticInstance(entity, species)) {
      final derived = NumismaticDataHelper.deriveInstanceName(entity, defaultSpeciesName: species?.name);
      if (derived.isNotEmpty && derived != AppStrings.defaultNumismaticPiece) {
        return derived;
      }
    }

    return null;
  }

  /// Resolves the specific display name for a WorldEntity.
  /// 1. If the entity has a custom instance name (property 'Nombre' or 'Name'), or is a numismatic piece (Moneda/Billete), returns it.
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

    // Numismatic dynamic title resolution fallback
    if (species != null && NumismaticDataHelper.isNumismaticSpecies(species)) {
      final derivedTitle = NumismaticDataHelper.deriveInstanceName(entity, defaultSpeciesName: speciesName);
      if (derivedTitle != AppStrings.defaultNumismaticPiece && derivedTitle != speciesName) {
        return derivedTitle;
      }
    }

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
