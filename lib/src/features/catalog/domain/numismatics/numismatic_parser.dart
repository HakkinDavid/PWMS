import '../catalog_item.dart';
import '../../../entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
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
      var result = text;
      for (final entry in AppTechnicalNumismatics.currencySingularReplacements.entries) {
        result = result.replaceAll(entry.key, entry.value);
      }
      return result.trim();
    }
    return text;
  }

  /// Resolves any currency string (code or name) to its ISO 4217 code (e.g. MXN).
  static String resolveCurrencyIsoCode(String codeOrName) {
    final clean = codeOrName.trim();
    if (clean.isEmpty) return clean;

    final upper = clean.toUpperCase();
    if (NumismaticDictionary.currencyMap.containsKey(upper)) {
      return upper;
    }

    String normalize(String text) {
      var result = text.toLowerCase();
      for (final entry in AppTechnicalNumismatics.normalizeCurrencyReplacements.entries) {
        result = result.replaceAll(entry.key, entry.value);
      }
      for (final entry in AppTechnicalNumismatics.regexNationalityReplacements.entries) {
        result = result.replaceAll(RegExp(entry.key), entry.value);
      }
      return result.trim();
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
      var result = text.toLowerCase();
      for (final entry in AppTechnicalNumismatics.normalizeCurrencyReplacements.entries) {
        result = result.replaceAll(entry.key, entry.value);
      }
      for (final entry in AppTechnicalNumismatics.regexNationalityReplacements.entries) {
        result = result.replaceAll(RegExp(entry.key), entry.value);
      }
      return result.trim();
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
    for (final entry in AppTechnicalNumismatics.gradeKeywords.entries) {
      if (lower.contains(entry.key)) {
        return NumismaticDictionary.grades[entry.value];
      }
    }

    return clean;
  }

  /// Resolves material to strict canonical item in `coinMaterials`.
  static String resolveMaterial(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (NumismaticDictionary.coinMaterials.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    for (final entry in AppTechnicalNumismatics.materialKeywords.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }

    return clean;
  }

  /// Resolves special edition reason to strict canonical item in `specialEditionReasons`.
  static String resolveSpecialEditionReason(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (NumismaticDictionary.specialEditionReasons.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    for (final entry in AppTechnicalNumismatics.specialEditionKeywords.entries) {
      if (lower.contains(entry.key)) {
        return NumismaticDictionary.specialEditionReasons[entry.value];
      }
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
    final typeLower = species.type.trim().toLowerCase();
    if (NumismaticDictionary.numismaticSpeciesNames.any((n) {
      final nLower = n.toLowerCase();
      return nameLower == nLower ||
          nameLower.startsWith(nLower + AppTechnicalStrings.space) ||
          typeLower == nLower ||
          typeLower.startsWith(nLower + AppTechnicalStrings.space);
    })) {
      return true;
    }
    if (species.description != null &&
        species.description!.toLowerCase().contains(AppTechnicalStrings.numisNumismaticKeyword)) {
      return true;
    }
    return false;
  }

  /// Checks if a numismatic species is a coin (circular) vs banknote (rectangular).
  static bool isCoinSpecies(CatalogItem species) {
    final nameLower = species.name.trim().toLowerCase();
    final typeLower = species.type.trim().toLowerCase();
    return !nameLower.contains(AppTechnicalStrings.numisBanknoteKeyword) &&
        !typeLower.contains(AppTechnicalStrings.numisBanknoteKeyword);
  }

  /// Builds a deterministic subspecies title for coins or banknotes.
  /// Format: [Denominación] [Divisa Estándar] - [País] ([Año])
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
            : AppTechnicalStrings.empty);

    final countVal = double.tryParse(denom) ?? faceValueNumber;

    final rawCurr = (currencyName != null && currencyName.trim().isNotEmpty)
        ? currencyName.trim()
        : (currencyCode != null && currencyCode.trim().isNotEmpty
            ? currencyCode.trim()
            : AppTechnicalStrings.empty);

    final canonicalCurr = resolveCurrencyName(rawCurr, count: countVal);

    final cty = (country != null && country.trim().isNotEmpty)
        ? country.trim()
        : AppTechnicalStrings.empty;

    final yr = (year != null && year.trim().isNotEmpty) ? year.trim() : null;

    final firstPart = [denom, canonicalCurr].where((s) => s.isNotEmpty).join(AppTechnicalStrings.space);
    final titleParts = <String>[];
    if (firstPart.isNotEmpty) titleParts.add(firstPart);
    if (cty.isNotEmpty) titleParts.add(cty);

    var mainText = titleParts.join(AppTechnicalStrings.dashWithSpaces);
    if (yr != null) {
      mainText = mainText.isNotEmpty
          ? mainText + AppTechnicalStrings.openParenSpace + yr + AppTechnicalStrings.closeParen
          : AppTechnicalStrings.openParen + yr + AppTechnicalStrings.closeParen;
    }

    if (mainText.isEmpty) {
      return AppStrings.defaultNumismaticPiece;
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
      notesParts.add(AppStrings.noteCoinPrefix + canonicalCurr.trim());
    }
    if (year != null && year.trim().isNotEmpty) {
      notesParts.add(AppStrings.noteYearPrefix + year.trim());
    }
    if (canonicalMat != null && canonicalMat.isNotEmpty) {
      notesParts.add(AppStrings.noteMaterialPrefix + canonicalMat.trim());
    }
    return notesParts.join(AppTechnicalStrings.pipeWithSpaces);
  }

  /// Sanitizes text for file names.
  static String sanitizeFileName(String text) {
    return text.replaceAll(RegExp(AppTechnicalStrings.regexIllegalFileNameChars), AppTechnicalStrings.underscore);
  }

  /// Builds deterministic filename for attachments.
  static String buildAttachmentFileName({
    required String subspeciesName,
    required String instanceId,
    required String side,
    required String extension,
  }) {
    final sanitizedSubname = sanitizeFileName(subspeciesName);
    final ext = extension.startsWith(AppTechnicalStrings.dot) ? extension.substring(1) : extension;
    return sanitizedSubname +
        AppTechnicalStrings.openParenSpace +
        instanceId +
        AppTechnicalStrings.closeParenOpenParen +
        side +
        AppTechnicalStrings.closeParenDot +
        ext;
  }

  /// Extracts numismatic attributes from an instance's magnitudes.
  static NumismaticAttributes extractAttributesFromInstance(WorldEntity entity) {
    double? faceVal;
    String? year;
    String? currency;
    String? material;
    String? grade;

    for (final mag in entity.magnitudes) {
      if (mag.propertyName == AppStrings.magValorNominal) {
        faceVal = mag.magnitudeValue;
      } else if (mag.propertyName == AppStrings.magAcunacion) {
        if (mag.magnitudeValue > 0) {
          year = mag.magnitudeValue.toInt().toString();
        } else if (mag.stringValue != null && mag.stringValue!.isNotEmpty) {
          year = mag.stringValue;
        }
      } else if (mag.propertyName == AppStrings.magDivisa) {
        currency = mag.stringValue;
      } else if (mag.propertyName == AppStrings.magMaterial) {
        material = mag.stringValue;
      } else if (mag.propertyName == AppStrings.magGrado) {
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
    final yearRegex = RegExp(AppTechnicalStrings.regexParenthesizedEndYear);
    final match = yearRegex.firstMatch(name);
    String? year;
    String mainText = name;

    if (match != null) {
      year = match.group(1)?.trim();
      mainText = name.substring(0, match.start).trim();
      if (mainText.endsWith(AppTechnicalStrings.dash)) {
        mainText = mainText.substring(0, mainText.length - 1).trim();
      }
    }

    final dashParts = mainText.split(AppTechnicalStrings.dashWithSpaces);
    String denomAndCurr;
    String? country;

    if (dashParts.length >= 2) {
      denomAndCurr = dashParts[0].trim();
      country = dashParts.sublist(1).join(AppTechnicalStrings.dashWithSpaces).trim();
    } else {
      denomAndCurr = mainText.trim();
    }

    double? faceValue;
    String? faceValStr;
    String? currency;

    if (denomAndCurr.isNotEmpty) {
      final firstSpace = denomAndCurr.indexOf(AppTechnicalStrings.space);
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
