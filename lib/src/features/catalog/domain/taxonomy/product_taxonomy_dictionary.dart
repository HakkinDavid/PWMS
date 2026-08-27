import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

class CategoryDefinition {
  final String generalSpeciesName; // Debe ser SIEMPRE en SINGULAR y ATÓMICA
  final String department;
  final List<String> keywords;
  final List<String>? regexPatterns;

  const CategoryDefinition({
    required this.generalSpeciesName,
    required this.department,
    required this.keywords,
    this.regexPatterns,
  });
}

class ProductTaxonomyDictionary {
  ProductTaxonomyDictionary._();

  static const List<CategoryDefinition> definitions = AppTechnicalTaxonomy.definitions;
}

