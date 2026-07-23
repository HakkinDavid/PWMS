import 'package:flutter/material.dart';
import '../../catalog/domain/catalog_item.dart';
import 'instantiate_species_sheet.dart';

class CreateEntitySheet {
  static Future<void> show(
    BuildContext context, {
    String? initialLocationId,
    CatalogItem? initialSpecies,
  }) {
    return InstantiateSpeciesSheet.show(
      context,
      species: initialSpecies,
      initialLocationId: initialLocationId,
    );
  }
}
