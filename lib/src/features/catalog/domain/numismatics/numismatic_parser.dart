import '../catalog_item.dart';
import '../../../entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'data/numismatic_currencies_registry.dart';
import 'data/numismatic_materials_registry.dart';
import 'numismatic_dictionary.dart';
import 'numismatic_naming_engine.dart';

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
      (NumismaticCurrenciesRegistry.currencySingularReplacements.entries.toList()
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
    // Backward compatibility aliases for historical, abbreviated or colloquial currency mentions
    for (final entry in NumismaticCurrenciesRegistry.legacyCurrencyAliases.entries) {
      final normKey = normalizeCurrencyText(entry.key);
      map.putIfAbsent(normKey, () => entry.value);
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
  static String resolveGrade(String raw) => NumismaticGradesRegistry.resolve(raw);

  /// Resolves material to strict canonical item in `coinMaterials` or `NumismaticMaterialsRegistry`.
  static String resolveMaterial(String raw) => NumismaticMaterialsRegistry.resolveToDisplayName(raw);

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
  /// Format: [Denominación y Divisa Completa] - [País] ([Año])
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

    final denomWithCurr = NumismaticNamingEngine.formatDenominationWithFullCurrency(
      denomination: denom,
      currencyCode: currencyCode ?? currencyName,
      faceValueNumber: faceValueNumber,
    );

    final cty = (country != null && country.trim().isNotEmpty)
        ? country.trim()
        : AppTechnicalStrings.empty;

    final yr = (year != null && year.trim().isNotEmpty) ? year.trim() : null;

    final titleParts = <String>[];
    if (denomWithCurr.isNotEmpty) titleParts.add(denomWithCurr);
    if (cty.isNotEmpty) titleParts.add(cty);

    var mainText = titleParts.join(AppTechnicalStrings.dashWithSpaces);
    if (yr != null) {
      final cleanYr = yr
          .replaceAll(AppTechnicalStrings.openParen, AppTechnicalStrings.empty)
          .replaceAll(AppTechnicalStrings.closeParen, AppTechnicalStrings.empty)
          .trim();
      mainText = mainText.isNotEmpty
          ? mainText + AppTechnicalStrings.openParenSpace + cleanYr + AppTechnicalStrings.closeParen
          : AppTechnicalStrings.openParen + cleanYr + AppTechnicalStrings.closeParen;
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
    return NumismaticNamingEngine.buildSpecimenTitle(
      attrs: attrs,
      defaultSpeciesName: defaultSpeciesName,
    );
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

  /// Parses subspecies or specimen title to extract denomination, currency, country, year, and motif.
  static NumismaticAttributes parseSubspeciesName(String name) {
    String? motif;
    String cleanName = name;

    // 1. Check for motif in square brackets `[Motif]`
    final bracketMotifRegex = RegExp(AppTechnicalStrings.regexSquareBrackets);
    final bracketMatch = bracketMotifRegex.firstMatch(cleanName);
    if (bracketMatch != null) {
      motif = bracketMatch.group(1)?.trim();
      cleanName = cleanName.replaceFirst(bracketMatch.group(0)!, AppTechnicalStrings.empty).trim();
    }

    // 2. Check for year in parentheses `(YYYY)`
    final yearRegex = RegExp(AppTechnicalStrings.regexSubspeciesYearParentheses);
    final yearMatch = yearRegex.firstMatch(cleanName);
    String? year;
    if (yearMatch != null) {
      year = yearMatch.group(1)?.trim();
      cleanName = cleanName.replaceFirst(yearMatch.group(0)!, AppTechnicalStrings.empty).trim();
    }

    // Clean any trailing/leading dashes or spaces
    cleanName = cleanName.trim();
    if (cleanName.endsWith(AppTechnicalStrings.dash)) {
      cleanName = cleanName.substring(0, cleanName.length - 1).trim();
    }
    if (cleanName.startsWith(AppTechnicalStrings.dash)) {
      cleanName = cleanName.substring(1).trim();
    }

    final dashParts = cleanName.split(AppTechnicalStrings.dashWithSpaces);
    String denomAndCurr;
    String? country;

    if (dashParts.length >= 3) {
      denomAndCurr = dashParts[0].trim();
      country = dashParts[1].trim();
      motif ??= dashParts.sublist(2).join(AppTechnicalStrings.dashWithSpaces).trim();
    } else if (dashParts.length == 2) {
      denomAndCurr = dashParts[0].trim();
      country = dashParts[1].trim();
    } else {
      denomAndCurr = cleanName.trim();
    }

    double? faceValue;
    String? faceValStr;
    String? currency;

    if (denomAndCurr.isNotEmpty) {
      // Check named denominations across currencies first
      for (final currDef in NumismaticCurrenciesRegistry.allCurrencies) {
        for (final entry in currDef.namedDenominations.entries) {
          final namedLower = entry.value.toLowerCase();
          final denomLower = denomAndCurr.toLowerCase();

          if (denomLower == namedLower ||
              denomLower.startsWith(namedLower + AppTechnicalStrings.space) ||
              denomLower.startsWith(namedLower + AppTechnicalStrings.deWithSpaces)) {
            // If the string specifies a currency name after 'de', verify it matches currDef
            final deIdx = denomLower.indexOf(AppTechnicalStrings.deWithSpaces);
            if (deIdx != -1) {
              final specifiedCurr = denomAndCurr.substring(deIdx + AppTechnicalStrings.deWithSpaces.length).trim();
              final resolvedDef = NumismaticCurrenciesRegistry.resolve(specifiedCurr);
              if (resolvedDef != null && resolvedDef.code != currDef.code) {
                continue;
              }
            }

            final keyNum = NumismaticDenominationsRegistry.parseNumber(entry.key);
            if (keyNum != null) {
              faceValue = keyNum;
              faceValStr = entry.key;
              currency = currDef.namePlural;
              break;
            }
          }
        }
        if (currency != null) break;
      }

      if (currency == null) {
        final firstSpace = denomAndCurr.indexOf(AppTechnicalStrings.space);
        if (firstSpace > 0) {
          final numPart = denomAndCurr.substring(0, firstSpace).trim();
          final parsed = double.tryParse(numPart);
          final remainder = denomAndCurr.substring(firstSpace + 1).trim();

          if (parsed != null) {
            faceValue = parsed;
            faceValStr = numPart;

            // 1. First, check if remainder is directly a recognized currency (e.g. 'Dírham de los Emiratos Árabes Unidos', 'Dólares de Barbados')
            final normRemainder = normalizeCurrencyText(remainder);
            final directIso = _normalizedCurrencyToIsoMap[normRemainder];

            if (directIso != null || NumismaticDictionary.currencyMap.containsKey(remainder.toUpperCase())) {
              currency = directIso != null ? NumismaticDictionary.currencyMap[directIso] : remainder;
            } else {
              // 2. Check if remainder is a subunit phrase like "20 Centavos de Pesos Mexicanos" or "50 Céntimos de Euro"
              final deIdx = remainder.indexOf(AppTechnicalStrings.deWithSpaces);
              if (deIdx != -1) {
                final actualCurr = remainder.substring(deIdx + AppTechnicalStrings.deWithSpaces.length).trim();
                final normActual = normalizeCurrencyText(actualCurr);
                final matchedIso = _normalizedCurrencyToIsoMap[normActual];
                final currDef = NumismaticCurrenciesRegistry.resolve(actualCurr);

                if (currDef != null && currDef.hasSubunit) {
                  faceValue = parsed / currDef.subunitRatio;
                  faceValStr = faceValue % 1 == 0 ? faceValue.toInt().toString() : faceValue.toString();
                  currency = currDef.namePlural;
                } else if (matchedIso != null) {
                  currency = NumismaticDictionary.currencyMap[matchedIso];
                } else {
                  currency = remainder;
                }
              } else {
                currency = remainder;
              }
            }
          } else if (numPart.contains(AppTechnicalStrings.slash)) {
            faceValStr = numPart;
            faceValue = NumismaticDenominationsRegistry.parseNumber(numPart);
            currency = remainder;
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
    }

    return NumismaticAttributes(
      faceValueNumber: faceValue,
      faceValueStr: faceValStr,
      currencyName: currency != null ? resolveCurrencyName(currency, count: faceValue) : null,
      country: country,
      year: year,
      motif: motif,
    );
  }
}
