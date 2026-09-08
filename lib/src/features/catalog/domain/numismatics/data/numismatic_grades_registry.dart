/// Centralized registry and single source of truth for numismatic preservation grades.
abstract final class NumismaticGradesRegistry {
  // ---------------------------------------------------------------------------
  // Canonical Grade Display Names
  // ---------------------------------------------------------------------------
  static const sinCircular = 'Sin circular';
  static const excelente = 'Excelente';
  static const muyBuena = 'Muy buena';
  static const buena = 'Buena';
  static const regular = 'Regular';
  static const otro = 'Otro';

  /// Standard ordered list of conservation grades.
  static const List<String> allGrades = [
    sinCircular,
    excelente,
    muyBuena,
    buena,
    regular,
    otro,
  ];

  /// Mapping of abbreviations and colloquial grading terms to their index in `allGrades`.
  static const Map<String, int> gradeKeywords = {
    'fdc': 0,
    'unc': 0,
    'sin circular': 0,
    'ebc': 1,
    'xf': 1,
    'excelente': 1,
    'mbc': 2,
    'vf': 2,
    'muy buena': 2,
    'bc': 3,
    'buena': 3,
    'mc': 4,
    'regular': 4,
  };

  static final List<MapEntry<String, int>> _sortedKeywords =
      gradeKeywords.entries.toList()
        ..sort((a, b) => b.key.length.compareTo(a.key.length));

  /// Resolves any raw grade string or abbreviation to its canonical display name in `allGrades`.
  static String resolve(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (allGrades.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    final directMatch = gradeKeywords[lower];
    if (directMatch != null) {
      return allGrades[directMatch];
    }

    // Check longer keywords first to avoid substring collisions
    for (final entry in _sortedKeywords) {
      if (lower.contains(entry.key)) {
        return allGrades[entry.value];
      }
    }

    return clean;
  }
}
