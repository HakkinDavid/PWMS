import 'generated_species_registry.dart';
import 'product_taxonomy_dictionary.dart';
import 'spanish_singularizer.dart';

class FastLazyTaxonomyRegistry {
  FastLazyTaxonomyRegistry._();

  static bool _isInitialized = false;
  static final Map<String, CompiledSpeciesItem> _exactTermMap = {};

  /// Inicialización perezosa (lazy) en RAM con optimización de cadenas (String Interning)
  static void initialize() {
    if (_isInitialized) return;

    // String interning para nombres de departamento (ahorro de memoria)
    final Map<String, String> departmentPool = {};

    String getInternedDepartment(String dept) {
      return departmentPool.putIfAbsent(dept, () => dept);
    }

    // Indexar definiciones compiladas masivas del Sweet Spot
    for (final item in GeneratedSpeciesRegistry.items) {
      final internedItem = CompiledSpeciesItem(
        species: SpanishSingularizer.toSingular(item.species),
        department: getInternedDepartment(item.department),
        keywords: item.keywords,
      );

      for (final kw in item.keywords) {
        _exactTermMap[kw.toLowerCase()] = internedItem;
      }
    }

    // Indexar también definiciones base de ProductTaxonomyDictionary
    for (final def in ProductTaxonomyDictionary.definitions) {
      final compiled = CompiledSpeciesItem(
        species: SpanishSingularizer.toSingular(def.generalSpeciesName),
        department: getInternedDepartment(def.department),
        keywords: def.keywords,
      );
      for (final kw in def.keywords) {
        _exactTermMap[kw.toLowerCase()] = compiled;
      }
    }

    _isInitialized = true;
  }

  /// Búsqueda ultrarrápida O(1) en Hash Map
  static CompiledSpeciesItem? lookup(String text) {
    if (!_isInitialized) initialize();

    final clean = text.toLowerCase().trim();
    if (_exactTermMap.containsKey(clean)) {
      return _exactTermMap[clean];
    }

    // Búsqueda de palabra o frase contenida
    for (final entry in _exactTermMap.entries) {
      if (entry.key.length >= 4 && clean.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Resolver especie atómica singularizada desde el catálogo Sweet Spot
  static String? resolveAtomicSpecies(String title) {
    final item = lookup(title);
    if (item != null) {
      return SpanishSingularizer.toSingular(item.species);
    }
    return null;
  }
}
