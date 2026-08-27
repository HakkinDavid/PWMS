import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

// GENERADO PROGRAMÁTICAMENTE POR scripts/build_taxonomy.dart
// NO EDITAR MANUALMENTE

class CompiledSpeciesItem {
  final String species;
  final String department;
  final List<String> keywords;
  const CompiledSpeciesItem({required this.species, required this.department, required this.keywords});
}

class GeneratedSpeciesRegistry {
  GeneratedSpeciesRegistry._();

  static const List<CompiledSpeciesItem> items = AppTechnicalTaxonomyRegistry.items;
}

