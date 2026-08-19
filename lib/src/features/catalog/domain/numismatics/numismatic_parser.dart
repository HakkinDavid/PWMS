import '../catalog_item.dart';
import '../../../entities/domain/world_entity.dart';
import 'numismatic_dictionary.dart';

class NumismaticAttributes {
  final double? faceValueNumber;
  final String? faceValueStr;
  final String? currencyName;
  final String? currencyCode;
  final String? country;
  final String? year;
  final String? material;
  final String? grade;

  const NumismaticAttributes({
    this.faceValueNumber,
    this.faceValueStr,
    this.currencyName,
    this.currencyCode,
    this.country,
    this.year,
    this.material,
    this.grade,
  });
}

class NumismaticParser {
  NumismaticParser._();

  /// Helper to convert plural currency name to singular if count == 1.
  static String adjustSingularPlural(String text, double? count) {
    if (count == 1 || count == 1.0) {
      return text
          .replaceAll('Pesos', 'Peso')
          .replaceAll('Dólares', 'Dólar')
          .replaceAll('Dolares', 'Dólar')
          .replaceAll('Soles', 'Sol')
          .replaceAll('Euros', 'Euro')
          .replaceAll('Libras', 'Libra')
          .replaceAll('Quetzales', 'Quetzal')
          .replaceAll('Florines', 'Florín')
          .replaceAll('Colones', 'Colón')
          .replaceAll('Pesetas', 'Peseta')
          .replaceAll('Mexicanos', 'Mexicano')
          .replaceAll('Estadounidenses', 'Estadounidense')
          .replaceAll('Canadienses', 'Canadiense')
          .replaceAll('Colombianos', 'Colombiano')
          .replaceAll('Chilenos', 'Chileno')
          .replaceAll('Argentinos', 'Argentino')
          .replaceAll('Cubanos', 'Cubano')
          .replaceAll('Dominicanos', 'Dominicano')
          .trim();
    }
    return text;
  }

  /// Resolves any currency string (code or name) to its ISO 4217 code (e.g. 'MXN').
  static String resolveCurrencyIsoCode(String codeOrName) {
    final clean = codeOrName.trim();
    if (clean.isEmpty) return clean;

    final upper = clean.toUpperCase();
    if (NumismaticDictionary.currencyMap.containsKey(upper)) {
      return upper;
    }

    String normalize(String text) {
      return text.toLowerCase()
          .replaceAll('pesos', 'peso')
          .replaceAll('dólares', 'dólar')
          .replaceAll('dolares', 'dólar')
          .replaceAll('soles', 'sol')
          .replaceAll('euros', 'euro')
          .replaceAll('libras', 'libra')
          .replaceAll(RegExp(r'\s+mexicanos?'), ' mexicano')
          .replaceAll(RegExp(r'\s+estadounidenses?'), ' estadounidense')
          .replaceAll(RegExp(r'\s+canadienses?'), ' canadiense')
          .replaceAll(RegExp(r'\s+colombianos?'), ' colombiano')
          .replaceAll(RegExp(r'\s+chilenos?'), ' chileno')
          .replaceAll(RegExp(r'\s+argentinos?'), ' argentino')
          .replaceAll(RegExp(r'\s+cubanos?'), ' cubano')
          .replaceAll(RegExp(r'\s+dominicanos?'), ' dominicano')
          .trim();
    }

    final normClean = normalize(clean);
    for (final entry in NumismaticDictionary.currencyMap.entries) {
      if (normalize(entry.value) == normClean) {
        return entry.key;
      }
    }

    return upper;
  }

  /// Resolves any currency string (code or name) to the strict canonical full Spanish name.
  static String resolveCurrencyName(String codeOrName, {double? count}) {
    final clean = codeOrName.trim();
    if (clean.isEmpty) return clean;

    final upperCode = clean.toUpperCase();
    if (NumismaticDictionary.currencyMap.containsKey(upperCode)) {
      return adjustSingularPlural(NumismaticDictionary.currencyMap[upperCode]!, count);
    }

    String normalize(String text) {
      return text.toLowerCase()
          .replaceAll('pesos', 'peso')
          .replaceAll('dólares', 'dólar')
          .replaceAll('dolares', 'dólar')
          .replaceAll('soles', 'sol')
          .replaceAll('euros', 'euro')
          .replaceAll('libras', 'libra')
          .replaceAll(RegExp(r'\s+mexicanos?'), ' mexicano')
          .replaceAll(RegExp(r'\s+estadounidenses?'), ' estadounidense')
          .replaceAll(RegExp(r'\s+canadienses?'), ' canadiense')
          .replaceAll(RegExp(r'\s+colombianos?'), ' colombiano')
          .replaceAll(RegExp(r'\s+chilenos?'), ' chileno')
          .replaceAll(RegExp(r'\s+argentinos?'), ' argentino')
          .replaceAll(RegExp(r'\s+cubanos?'), ' cubano')
          .replaceAll(RegExp(r'\s+dominicanos?'), ' dominicano')
          .trim();
    }

    final normClean = normalize(clean);
    for (final entry in NumismaticDictionary.currencyMap.entries) {
      if (normalize(entry.value) == normClean) {
        return adjustSingularPlural(entry.value, count);
      }
    }

    return adjustSingularPlural(clean, count);
  }

  /// Resolves grade to strict canonical item in `grades`.
  static String resolveGrade(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (NumismaticDictionary.grades.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    if (lower.contains('fdc') || lower.contains('unc') || lower.contains('sin circular')) {
      return NumismaticDictionary.grades[0];
    }
    if (lower.contains('ebc') || lower.contains('xf') || lower.contains('excelente')) {
      return NumismaticDictionary.grades[1];
    }
    if (lower.contains('mbc') || lower.contains('vf') || lower.contains('muy buena')) {
      return NumismaticDictionary.grades[2];
    }
    if (lower.contains('bc') || lower.contains('buena')) {
      return NumismaticDictionary.grades[3];
    }
    if (lower.contains('mc') || lower.contains('regular')) {
      return NumismaticDictionary.grades[4];
    }

    return clean;
  }

  /// Resolves material to strict canonical item in `coinMaterials`.
  static String resolveMaterial(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (NumismaticDictionary.coinMaterials.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    if (lower.contains('cuproníquel') || lower.contains('cuproniquel') || lower.contains('cu-ni')) {
      return 'Cuproníquel';
    }
    if (lower.contains('plata') || lower.contains('silver')) {
      return 'Plata';
    }
    if (lower.contains('bronce') || lower.contains('bronze')) {
      return 'Bronce';
    }
    if (lower.contains('oro') || lower.contains('gold')) {
      return 'Oro';
    }
    if (lower.contains('latón') || lower.contains('laton') || lower.contains('brass')) {
      return 'Latón';
    }
    if (lower.contains('aluminio') || lower.contains('aluminum')) {
      return 'Aluminio';
    }
    if (lower.contains('bimetálica') || lower.contains('bimetalica') || lower.contains('bimetal')) {
      return 'Bimetálica';
    }
    if (lower.contains('acero') || lower.contains('steel')) {
      return 'Acero';
    }
    if (lower.contains('papel') || lower.contains('paper')) {
      return 'Papel';
    }

    return clean;
  }

  /// Resolves special edition reason to strict canonical item in `specialEditionReasons`.
  static String resolveSpecialEditionReason(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (NumismaticDictionary.specialEditionReasons.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    if (lower.contains('conmemorativa') || lower.contains('commemorative')) {
      return NumismaticDictionary.specialEditionReasons[0];
    }
    if (lower.contains('proof') || lower.contains('prueba')) {
      return NumismaticDictionary.specialEditionReasons[1];
    }
    if (lower.contains('error') || lower.contains('impresión') || lower.contains('impresion')) {
      return NumismaticDictionary.specialEditionReasons[2];
    }
    if (lower.contains('limitada') || lower.contains('numeración') || lower.contains('numeracion')) {
      return NumismaticDictionary.specialEditionReasons[3];
    }
    if (lower.contains('aniversario') || lower.contains('histórico') || lower.contains('historico')) {
      return NumismaticDictionary.specialEditionReasons[4];
    }
    if (lower.contains('régimen') || lower.contains('regimen') || lower.contains('cambio')) {
      return NumismaticDictionary.specialEditionReasons[5];
    }

    return clean;
  }

  /// Checks if two currency identifiers match strictly after canonical resolution.
  static bool areCurrenciesEquivalent(String? c1, String? c2, {double? count}) {
    if (c1 == null || c1.trim().isEmpty) return c2 == null || c2.trim().isEmpty;
    if (c2 == null || c2.trim().isEmpty) return false;

    final r1 = resolveCurrencyName(c1, count: count);
    final r2 = resolveCurrencyName(c2, count: count);

    return r1.toLowerCase() == r2.toLowerCase();
  }

  /// Checks if a catalog species is a numismatic species (Moneda or Billete).
  static bool isNumismaticSpecies(CatalogItem species) {
    final nameLower = species.name.trim().toLowerCase();
    if (NumismaticDictionary.numismaticSpeciesNames.any((n) => n.toLowerCase() == nameLower)) {
      return true;
    }
    if (species.description != null &&
        species.description!.toLowerCase().contains('numismátic')) {
      return true;
    }
    return false;
  }

  /// Builds a deterministic subspecies title for coins or banknotes.
  /// Format: "[Denominación] [Divisa Estándar] - [País] ([Año])"
  static String buildSubspeciesName({
    double? faceValueNumber,
    String? faceValueStr,
    String? currencyName,
    String? currencyCode,
    String? country,
    String? year,
  }) {
    final denom = (faceValueStr != null && faceValueStr.trim().isNotEmpty)
        ? faceValueStr.trim()
        : (faceValueNumber != null
            ? (faceValueNumber % 1 == 0
                ? faceValueNumber.toInt().toString()
                : faceValueNumber.toString())
            : '');

    final countVal = double.tryParse(denom) ?? faceValueNumber;

    final rawCurr = (currencyName != null && currencyName.trim().isNotEmpty)
        ? currencyName.trim()
        : (currencyCode != null && currencyCode.trim().isNotEmpty
            ? currencyCode.trim()
            : '');

    final canonicalCurr = resolveCurrencyName(rawCurr, count: countVal);

    final cty = (country != null && country.trim().isNotEmpty)
        ? country.trim()
        : '';

    final yr = (year != null && year.trim().isNotEmpty) ? year.trim() : null;

    final firstPart = [denom, canonicalCurr].where((s) => s.isNotEmpty).join(' ');
    final titleParts = <String>[];
    if (firstPart.isNotEmpty) titleParts.add(firstPart);
    if (cty.isNotEmpty) titleParts.add(cty);

    var mainText = titleParts.join(' - ');
    if (yr != null) {
      mainText = mainText.isNotEmpty ? '$mainText ($yr)' : '($yr)';
    }

    if (mainText.isEmpty) {
      return 'Pieza Numismática';
    }

    return mainText;
  }

  /// Builds deterministic subspecies notes string.
  static String buildSubspeciesNotes({
    String? currencyName,
    String? currencyCode,
    String? year,
    String? composition,
  }) {
    final rawCurr = (currencyName != null && currencyName.trim().isNotEmpty)
        ? currencyName.trim()
        : (currencyCode != null && currencyCode.trim().isNotEmpty
            ? currencyCode.trim()
            : null);

    final canonicalCurr = rawCurr != null ? resolveCurrencyName(rawCurr) : null;
    final canonicalMat = composition != null && composition.trim().isNotEmpty
        ? resolveMaterial(composition)
        : null;

    final notesParts = <String>[];
    if (canonicalCurr != null && canonicalCurr.isNotEmpty) {
      notesParts.add('Moneda: ${canonicalCurr.trim()}');
    }
    if (year != null && year.trim().isNotEmpty) {
      notesParts.add('Año: ${year.trim()}');
    }
    if (canonicalMat != null && canonicalMat.isNotEmpty) {
      notesParts.add('Material: ${canonicalMat.trim()}');
    }
    return notesParts.join(' | ');
  }

  /// Sanitizes text for file names.
  static String sanitizeFileName(String text) {
    return text.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }

  /// Builds deterministic filename for attachments.
  static String buildAttachmentFileName({
    required String subspeciesName,
    required String instanceId,
    required String side, // 'anverso' or 'reverso'
    required String extension,
  }) {
    final sanitizedSubname = sanitizeFileName(subspeciesName);
    final ext = extension.startsWith('.') ? extension.substring(1) : extension;
    return '$sanitizedSubname ($instanceId) ($side).$ext';
  }

  /// Extracts numismatic attributes from an instance's magnitudes.
  static NumismaticAttributes extractAttributesFromInstance(WorldEntity entity) {
    double? faceVal;
    String? year;
    String? currency;
    String? material;
    String? grade;

    for (final mag in entity.magnitudes) {
      if (mag.propertyName == 'Valor nominal') {
        faceVal = mag.magnitudeValue;
      } else if (mag.propertyName == 'Acuñación') {
        if (mag.magnitudeValue > 0) {
          year = mag.magnitudeValue.toInt().toString();
        } else if (mag.stringValue != null && mag.stringValue!.isNotEmpty) {
          year = mag.stringValue;
        }
      } else if (mag.propertyName == 'Divisa') {
        currency = mag.stringValue;
      } else if (mag.propertyName == 'Material') {
        material = mag.stringValue;
      } else if (mag.propertyName == 'Grado') {
        grade = mag.stringValue;
      }
    }

    return NumismaticAttributes(
      faceValueNumber: faceVal,
      currencyName: currency,
      year: year,
      material: material,
      grade: grade,
    );
  }

  /// Parses subspecies title to extract denomination, currency, country, year.
  static NumismaticAttributes parseSubspeciesName(String name) {
    final yearRegex = RegExp(r'\(([^)]+)\)\s*$');
    final match = yearRegex.firstMatch(name);
    String? year;
    String mainText = name;

    if (match != null) {
      year = match.group(1)?.trim();
      mainText = name.substring(0, match.start).trim();
      if (mainText.endsWith('-')) {
        mainText = mainText.substring(0, mainText.length - 1).trim();
      }
    }

    final dashParts = mainText.split(' - ');
    String? denomAndCurr;
    String? country;

    if (dashParts.length >= 2) {
      denomAndCurr = dashParts[0].trim();
      country = dashParts.sublist(1).join(' - ').trim();
    } else {
      denomAndCurr = mainText.trim();
    }

    double? faceValue;
    String? faceValStr;
    String? currency;

    if (denomAndCurr != null && denomAndCurr.isNotEmpty) {
      final firstSpace = denomAndCurr.indexOf(' ');
      if (firstSpace > 0) {
        final numPart = denomAndCurr.substring(0, firstSpace).trim();
        final parsed = double.tryParse(numPart);
        if (parsed != null) {
          faceValue = parsed;
          faceValStr = numPart;
          currency = denomAndCurr.substring(firstSpace + 1).trim();
        } else {
          currency = denomAndCurr;
        }
      } else {
        final parsed = double.tryParse(denomAndCurr);
        if (parsed != null) {
          faceValue = parsed;
          faceValStr = denomAndCurr;
        } else {
          currency = denomAndCurr;
        }
      }
    }

    return NumismaticAttributes(
      faceValueNumber: faceValue,
      faceValueStr: faceValStr,
      currencyName: currency != null ? resolveCurrencyName(currency, count: faceValue) : null,
      country: country,
      year: year,
    );
  }
}
