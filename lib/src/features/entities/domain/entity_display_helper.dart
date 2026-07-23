import '../../../core/constants/app_strings.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import 'world_entity.dart';

class EntityDisplayHelper {
  EntityDisplayHelper._();

  /// Resolves the specific display name for a WorldEntity.
  /// If the entity has a valid, non-generic Subspecies assigned, returns the specific subspecies name
  /// (with brand if present). If the subspecies name does not contain the species name,
  /// prepends the species name for context (e.g. "Refresco - Coca Cola Zero (Coca Cola)").
  /// Otherwise, falls back to the general species name.
  static String getDisplayName({
    required WorldEntity entity,
    required List<CatalogItem> catalogItems,
    List<Subspecies>? subspeciesList,
  }) {
    final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull;
    final speciesName = species?.name ?? AppStrings.containerObjectLabel;

    if (entity.subspeciesId != null && subspeciesList != null && subspeciesList.isNotEmpty) {
      final sub = subspeciesList.where((s) => s.id == entity.subspeciesId).firstOrNull;
      if (sub != null) {
        final subNameTrimmed = sub.subspeciesName.trim();
        final isGeneric = subNameTrimmed.isEmpty ||
            subNameTrimmed.toLowerCase() == AppStrings.defaultSubspeciesName.toLowerCase();

        if (!isGeneric) {
          final brandText = (sub.brand != null && sub.brand!.trim().isNotEmpty)
              ? ' (${sub.brand!.trim()})'
              : '';
          final hasSpeciesInSub = subNameTrimmed.toLowerCase().contains(speciesName.toLowerCase());
          if (hasSpeciesInSub) {
            return '$subNameTrimmed$brandText';
          } else {
            return '$speciesName - $subNameTrimmed$brandText';
          }
        }
      }
    }

    return speciesName;
  }
}
