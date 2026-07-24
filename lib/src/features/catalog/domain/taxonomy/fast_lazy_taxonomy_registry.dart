import 'generated_species_registry.dart';
import 'product_taxonomy_dictionary.dart';
import 'spanish_singularizer.dart';

class FastLazyTaxonomyRegistry {
  FastLazyTaxonomyRegistry._();

  static bool _isInitialized = false;
  static final Map<String, CompiledSpeciesItem> _exactTermMap = {};

  static void initialize() {
    if (_isInitialized) return;

    // Indexar definiciones compiladas masivas
    for (final item in GeneratedSpeciesRegistry.items) {
      for (final kw in item.keywords) {
        _exactTermMap[kw.toLowerCase()] = item;
      }
    }

    // Indexar también definiciones de ProductTaxonomyDictionary
    for (final def in ProductTaxonomyDictionary.definitions) {
      final compiled = CompiledSpeciesItem(
        species: def.generalSpeciesName,
        department: def.department,
        keywords: def.keywords,
      );
      for (final kw in def.keywords) {
        _exactTermMap[kw.toLowerCase()] = compiled;
      }
    }

    _isInitialized = true;
  }

  /// Buscar coincidencia atómica ultra-rápida O(1)
  static CompiledSpeciesItem? lookup(String text) {
    if (!_isInitialized) initialize();

    final clean = text.toLowerCase().trim();
    if (_exactTermMap.containsKey(clean)) {
      return _exactTermMap[clean];
    }

    // Buscar si alguna frase o palabra clave está contenida como término completo
    for (final entry in _exactTermMap.entries) {
      if (entry.key.length >= 4 && clean.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Resolver especie atómica singularizada desde el catálogo masivo
  static String? resolveAtomicSpecies(String title) {
    final item = lookup(title);
    if (item != null) {
      return SpanishSingularizer.toSingular(item.species);
    }
    return null;
  }
}
