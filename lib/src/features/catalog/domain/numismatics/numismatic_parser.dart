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
  final String? motif;

  const NumismaticAttributes({
    this.faceValueNumber,
    this.faceValueStr,
    this.currencyName,
    this.currencyCode,
    this.country,
    this.year,
    this.material,
    this.grade,
    this.motif,
  });
}

class NumismaticParser {
  NumismaticParser._();

  static final List<MapEntry<RegExp, String>> _singularPatterns =
      (AppTechnicalNumismatics.currencySingularReplacements.entries.toList()
            ..sort((a, b) => b.key.length.compareTo(a.key.length)))
          .map((entry) => MapEntry(
                RegExp(AppTechnicalStrings.regexWordBoundary + RegExp.escape(entry.key) + AppTechnicalStrings.regexWordBoundary, caseSensitive: false),
                entry.value,
              ))
          .toList();

  static final RegExp _multipleSpacesRegExp = RegExp(AppTechnicalStrings.regexMultipleSpaces);

  static final Map<String, String> _normalizedCurrencyToIsoMap = () {
    final map = <String, String>{};
    for (final entry in NumismaticDictionary.currencyMap.entries) {
      final norm = normalizeCurrencyText(entry.value);
      map.putIfAbsent(norm, () => entry.key);
    }
    return map;
  }();

  /// Helper to convert plural currency name to singular if count == 1.
  static String adjustSingularPlural(String text, double? count) {
    if (count == 1 || count == 1.0) {
      var result = text;
      for (final entry in _singularPatterns) {
        result = result.replaceAll(entry.key, entry.value);
      }
      return result.trim();
    }
    return text;
  }

  /// Normalizes any currency name or string to a canonical lowercase representation without accents
  /// and with all plural terms converted to singular, enabling consistent comparison and ISO resolution.
  static String normalizeCurrencyText(String text) {
    var result = text.trim();
    if (result.isEmpty) return result;

    for (final entry in _singularPatterns) {
      result = result.replaceAll(entry.key, entry.value);
    }

    var lower = result.toLowerCase();
    for (final entry in AppTechnicalBrands.accentReplacements.entries) {
      lower = lower.replaceAll(entry.key.toLowerCase(), entry.value.toLowerCase());
    }

    return lower
        .replaceAll(_multipleSpacesRegExp, AppTechnicalStrings.space)
        .trim();
  }

  /// Resolves any currency string (code or name) to its ISO 4217 code (e.g. MXN).
  static String resolveCurrencyIsoCode(String codeOrName) {
    final clean = codeOrName.trim();
    if (clean.isEmpty) return clean;

    final upper = clean.toUpperCase();
    if (NumismaticDictionary.currencyMap.containsKey(upper)) {
      return upper;
    }

    final normClean = normalizeCurrencyText(clean);
    final matchIso = _normalizedCurrencyToIsoMap[normClean];
    if (matchIso != null) {
      return matchIso;
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

    final normClean = normalizeCurrencyText(clean);
    final matchIso = _normalizedCurrencyToIsoMap[normClean];
    if (matchIso != null) {
      return adjustSingularPlural(NumismaticDictionary.currencyMap[matchIso]!, count);
    }

    return adjustSingularPlural(clean, count);
  }

  /// Resolves grade to strict canonical item in `grades`.
  static String resolveGrade(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (NumismaticDictionary.grades.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    if (AppTechnicalNumismatics.gradeKeywords.containsKey(lower)) {
      return NumismaticDictionary.grades[AppTechnicalNumismatics.gradeKeywords[lower]!];
    }
    // Check longer keywords first to avoid subword collisions
    final sortedEntries = AppTechnicalNumismatics.gradeKeywords.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in sortedEntries) {
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
    if (AppTechnicalNumismatics.materialKeywords.containsKey(lower)) {
      return AppTechnicalNumismatics.materialKeywords[lower]!;
    }
    // Check longer keywords first to prioritize compound phrases (e.g. 'german silver', 'oro nórdico') over base words
    final sortedEntries = AppTechnicalNumismatics.materialKeywords.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in sortedEntries) {
      if (lower.contains(entry.key)) {
        return entry.value;
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

    if (r1.toLowerCase() == r2.toLowerCase()) return true;

    return normalizeCurrencyText(r1) == normalizeCurrencyText(r2);
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
        !typeLower.contains(AppTechnicalStrings.numisBanknoteKeyword) &&
        !nameLower.contains(AppTechnicalStrings.numisPapelMonedaKeyword) &&
        !typeLower.contains(AppTechnicalStrings.numisPapelMonedaKeyword) &&
        !nameLower.contains(AppTechnicalStrings.numisNotafiliaKeyword) &&
        !typeLower.contains(AppTechnicalStrings.numisNotafiliaKeyword);
  }

  /// Checks if an entity is a banknote (vs coin) based on species, instance attributes, material, or title.
  static bool isBanknotePiece({
    CatalogItem? species,
    WorldEntity? instance,
    String? material,
    String? subspeciesName,
  }) {
    if (species != null) {
      if (!isCoinSpecies(species)) return true;
    }

    if (material != null && material.trim().isNotEmpty) {
      final matLower = material.trim().toLowerCase();
      if (matLower == AppTechnicalStrings.materialPapelLower ||
          matLower == AppTechnicalStrings.materialPapelAlgodonWithAccentLower ||
          matLower == AppTechnicalStrings.materialPapelAlgodonWithoutAccentLower ||
          matLower == AppTechnicalStrings.materialPolimeroWithAccentLower ||
          matLower == AppTechnicalStrings.materialPolimeroWithoutAccentLower ||
          matLower == AppTechnicalStrings.materialCottonPaperLower) {
        return true;
      }
    }

    if (instance != null) {
      final attrs = extractAttributesFromInstance(instance);
      if (attrs.material != null && attrs.material!.trim().isNotEmpty) {
        final matLower = attrs.material!.trim().toLowerCase();
        if (matLower == AppTechnicalStrings.materialPapelLower ||
            matLower == AppTechnicalStrings.materialPapelAlgodonWithAccentLower ||
            matLower == AppTechnicalStrings.materialPapelAlgodonWithoutAccentLower ||
            matLower == AppTechnicalStrings.materialPolimeroWithAccentLower ||
            matLower == AppTechnicalStrings.materialPolimeroWithoutAccentLower ||
            matLower == AppTechnicalStrings.materialCottonPaperLower) {
          return true;
        }
      }
    }

    if (subspeciesName != null && subspeciesName.trim().isNotEmpty) {
      final subLower = subspeciesName.toLowerCase();
      if (subLower.contains(AppTechnicalStrings.numisBanknoteKeyword) || subLower.contains(AppTechnicalStrings.numisPapelMonedaKeyword)) {
        return true;
      }
    }

    return false;
  }

  /// Checks if an entity is a coin (vs banknote).
  static bool isCoinPiece({
    CatalogItem? species,
    WorldEntity? instance,
    String? material,
    String? subspeciesName,
  }) =>
      !isBanknotePiece(
        species: species,
        instance: instance,
        material: material,
        subspeciesName: subspeciesName,
      );

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

  /// Builds a deterministic instance display name from its attributes.
  static String buildInstanceDisplayName(NumismaticAttributes attrs, {String? defaultSpeciesName}) {
    final title = buildSubspeciesName(
      faceValueNumber: attrs.faceValueNumber,
      faceValueStr: attrs.faceValueStr,
      currencyName: attrs.currencyName,
      currencyCode: attrs.currencyCode,
      country: attrs.country,
      year: attrs.year,
    );
    if (title == AppStrings.defaultNumismaticPiece && defaultSpeciesName != null && defaultSpeciesName.isNotEmpty) {
      return defaultSpeciesName;
    }
    return title;
  }

  /// Extracts numismatic attributes from an instance's magnitudes.
  static NumismaticAttributes extractAttributesFromInstance(WorldEntity entity) {
    double? faceVal;
    String? faceValStr;
    String? year;
    String? currency;
    String? material;
    String? grade;
    String? country;
    String? motif;

    for (final mag in entity.magnitudes) {
      final pName = mag.propertyName.trim().toLowerCase();
      if (pName == AppStrings.magValorNominal.toLowerCase() ||
          pName == AppStrings.nominalValuePropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magValorFacialLower ||
          pName == AppTechnicalStrings.magValorNominalLower) {
        faceVal = mag.magnitudeValue;
        if (faceVal == null && mag.stringValue != null && mag.stringValue!.isNotEmpty) {
          faceVal = double.tryParse(mag.stringValue!);
          faceValStr = mag.stringValue!.trim();
        }
      } else if (pName == AppStrings.magAcunacion.toLowerCase() ||
          pName == AppStrings.mintagePropertyName.toLowerCase() ||
          pName == AppStrings.mintageYearLabel.toLowerCase() ||
          pName == AppTechnicalStrings.magAcunacionWithAccentLower ||
          pName == AppTechnicalStrings.magAcunacionWithoutAccentLower ||
          pName == AppTechnicalStrings.magAnoWithAccentLower ||
          pName == AppTechnicalStrings.magAnoWithoutAccentLower ||
          pName == AppTechnicalStrings.magAnoDeAcunacionLower ||
          pName == AppTechnicalStrings.magMintageLower) {
        if (mag.magnitudeValue != null && mag.magnitudeValue! > 0) {
          year = mag.magnitudeValue!.toInt().toString();
        } else if (mag.stringValue != null && mag.stringValue!.isNotEmpty) {
          year = mag.stringValue!.trim();
        }
      } else if (pName == AppStrings.magDivisa.toLowerCase() ||
          pName == AppStrings.currencyPropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magDivisaLower ||
          pName == AppTechnicalStrings.magMonedaLower) {
        currency = mag.stringValue?.trim();
      } else if (pName == AppStrings.magMaterial.toLowerCase() ||
          pName == AppStrings.materialPropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magMaterialLower ||
          pName == AppTechnicalStrings.magMetalLower) {
        material = mag.stringValue?.trim();
      } else if (pName == AppStrings.magGrado.toLowerCase() ||
          pName == AppStrings.gradePropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magGradoLower ||
          pName == AppTechnicalStrings.magConservacionWithAccentLower ||
          pName == AppTechnicalStrings.magConservacionWithoutAccentLower) {
        grade = mag.stringValue?.trim();
      } else if (pName == AppStrings.magEmisor.toLowerCase() ||
          pName == AppStrings.issuerPropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magPaisLower ||
          pName == AppTechnicalStrings.magPaisWithoutAccentLower ||
          pName == AppTechnicalStrings.magEmisorLower) {
        country = mag.stringValue?.trim();
      } else if (pName == AppStrings.motifPropertyName.toLowerCase() ||
          pName == AppTechnicalStrings.magMotivoLower) {
        motif = mag.stringValue?.trim();
      }
    }

    return NumismaticAttributes(
      faceValueNumber: faceVal,
      faceValueStr: faceValStr,
      currencyName: currency,
      country: country,
      year: year,
      material: material,
      grade: grade,
      motif: motif,
    );
  }

  /// Derives the canonical display name for an instance of Moneda or Billete.
  static String deriveInstanceName(WorldEntity entity, {String? defaultSpeciesName}) {
    final attrs = extractAttributesFromInstance(entity);
    return buildInstanceDisplayName(attrs, defaultSpeciesName: defaultSpeciesName);
  }

  /// Checks if an entity is a numismatic piece (Moneda / Billete), based on species or instance magnitudes.
  static bool isNumismaticEntity(WorldEntity entity, [CatalogItem? species]) {
    if (species != null) {
      return isNumismaticSpecies(species);
    }
    return entity.magnitudes.any((m) {
      final p = m.propertyName.trim().toLowerCase();
      return p == AppStrings.magValorNominal.toLowerCase() ||
          p == AppStrings.nominalValuePropertyName.toLowerCase() ||
          p == AppStrings.currencyPropertyName.toLowerCase() ||
          p == AppStrings.mintagePropertyName.toLowerCase() ||
          p == AppStrings.issuerPropertyName.toLowerCase() ||
          p == AppTechnicalStrings.magValorFacialLower ||
          p == AppTechnicalStrings.magDivisaLower;
    });
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
