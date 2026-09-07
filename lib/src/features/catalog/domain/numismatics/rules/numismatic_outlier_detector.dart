import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../../entities/domain/world_entity.dart';
import '../../catalog_item.dart';
import '../../subspecies.dart';
import '../numismatic_matrix.dart';
import '../numismatic_parser.dart';

enum NumismaticEmissionOutlierType {
  currencyAnachronism,
  materialContradiction,
  motifMismatch,
  denominationAnomaly,
  yearOutOfRange,
}

class NumismaticEmissionOutlier {
  final NumismaticEmissionOutlierType type;
  final String title;
  final String description;
  final String suggestedFixDescription;
  final String? expectedValue;
  final String? foundValue;
  final String? targetPropertyName;

  const NumismaticEmissionOutlier({
    required this.type,
    required this.title,
    required this.description,
    required this.suggestedFixDescription,
    this.expectedValue,
    this.foundValue,
    this.targetPropertyName,
  });
}

class NumismaticCongruenceIssue {
  final String subspeciesId;
  final String? instanceId;
  final String issueType; // 'currency_mismatch', 'duplicate_subspecies', 'attachment_mismatch', 'missing_magnitudes'
  final String description;
  final NumismaticAttributes expectedAttributes;
  final NumismaticAttributes? foundAttributes;

  const NumismaticCongruenceIssue({
    required this.subspeciesId,
    this.instanceId,
    required this.issueType,
    required this.description,
    required this.expectedAttributes,
    this.foundAttributes,
  });
}

/// Service dedicated to detecting numismatic anomalies, incongruences, and matrix outliers.
class NumismaticOutlierDetector {
  NumismaticOutlierDetector._();

  /// Checks if instance magnitudes match the currency subspecies and canonical standardization.
  static String? checkInstanceSubspeciesCongruence({
    required Subspecies subspecies,
    required WorldEntity instance,
  }) {
    final instAttrs = NumismaticParser.extractAttributesFromInstance(instance);
    final mismatches = <String>[];

    final parsedSub = NumismaticParser.parseSubspeciesName(subspecies.subspeciesName);
    final subCurrency = (parsedSub.currencyName != null && parsedSub.currencyName!.isNotEmpty)
        ? parsedSub.currencyName!
        : subspecies.subspeciesName;

    // 1. Currency congruence check between instance and subspecies
    if (instAttrs.currencyName != null && instAttrs.currencyName!.isNotEmpty) {
      final isEquivalent = NumismaticParser.areCurrenciesEquivalent(
        instAttrs.currencyName,
        subCurrency,
      );
      if (!isEquivalent) {
        final expectedCurr = NumismaticParser.resolveCurrencyName(subCurrency);
        mismatches.add(
          AppStrings.numisAuditCurrencyMismatch(instAttrs.currencyName!, expectedCurr),
        );
      }
    }

    // 2. Instance magnitude currency standardization check (must be ISO code)
    if (instAttrs.currencyName != null && instAttrs.currencyName!.isNotEmpty) {
      final isoCode = NumismaticParser.resolveCurrencyIsoCode(instAttrs.currencyName!);
      if (instAttrs.currencyName!.trim().toUpperCase() != isoCode) {
        mismatches.add(AppStrings.numisAuditCurrencyNotIso(instAttrs.currencyName!, isoCode));
      }
    }

    // 3. Instance magnitude grade standardization check
    if (instAttrs.grade != null && instAttrs.grade!.isNotEmpty) {
      final stdGrade = NumismaticParser.resolveGrade(instAttrs.grade!);
      if (instAttrs.grade!.trim() != stdGrade) {
        mismatches.add(AppStrings.numisAuditGradeMismatch(instAttrs.grade!, stdGrade));
      }
    }

    // 4. Instance magnitude material standardization check
    if (instAttrs.material != null && instAttrs.material!.isNotEmpty) {
      final stdMat = NumismaticParser.resolveMaterial(instAttrs.material!);
      if (instAttrs.material!.trim() != stdMat) {
        mismatches.add(AppStrings.numisAuditMaterialMismatch(instAttrs.material!, stdMat));
      }
    }

    if (mismatches.isNotEmpty) {
      return AppStrings.numisAuditIncongruence(mismatches.join(AppTechnicalStrings.pipeWithSpaces));
    }

    return null;
  }

  /// Analyzes an instance against historical emission matrix rules and returns detected outliers.
  static List<NumismaticEmissionOutlier> checkEmissionOutliers({
    required WorldEntity instance,
    CatalogItem? species,
  }) {
    if (species != null && !NumismaticParser.isNumismaticSpecies(species)) {
      return const [];
    }

    final attrs = NumismaticParser.extractAttributesFromInstance(instance);
    final country = attrs.country?.trim();
    final yearStr = attrs.year?.trim();
    final year = yearStr != null ? int.tryParse(yearStr) : null;
    final currency = attrs.currencyName?.trim();
    final material = attrs.material?.trim();

    final isBanknote = NumismaticParser.isBanknotePiece(
      species: species,
      instance: instance,
      material: material,
    );

    String? denomStr = attrs.faceValueStr?.trim();
    if (denomStr == null && attrs.faceValueNumber != null) {
      final numVal = attrs.faceValueNumber!;
      denomStr = (numVal == numVal.toInt()) ? numVal.toInt().toString() : numVal.toString();
    }

    final outliers = <NumismaticEmissionOutlier>[];

    if (country == null || country.isEmpty || country == AppStrings.otherSpecifyOption) {
      return outliers;
    }

    // 1. Year Outlier / Chronological range check
    if (year != null) {
      final currentYear = DateTime.now().year;
      if (year < 1500 || year > currentYear + 1) {
        outliers.add(NumismaticEmissionOutlier(
          type: NumismaticEmissionOutlierType.yearOutOfRange,
          title: AppStrings.numismaticEmissionOutlierCardTitle,
          description: AppStrings.numismaticYearOutOfRangeDesc(year, country),
          suggestedFixDescription: AppStrings.fixCorrectYearAction,
          foundValue: year.toString(),
          targetPropertyName: AppStrings.mintagePropertyName,
        ));
      }
    }

    // 2. Emission matrix matching
    if (year != null && year >= 1500 && year <= DateTime.now().year + 1) {
      final allRules = NumismaticMatrix.findRules(country, year, isBanknote: isBanknote);
      if (allRules.isNotEmpty) {
        // A. Currency anachronism check
        if (currency != null && currency.isNotEmpty) {
          final iso = NumismaticParser.resolveCurrencyIsoCode(currency);
          final allValidCurrencies = allRules.expand((r) => r.validCurrencies).toSet();
          if (!allValidCurrencies.contains(iso)) {
            final expectedIso = allRules.first.defaultCurrency ?? allRules.first.validCurrencies.first;
            final desc = allValidCurrencies.length > 1
                ? AppStrings.numismaticMagnitudeNotAmongExpectedDesc(AppStrings.currencyPropertyName, currentValue: currency)
                : AppStrings.numismaticCurrencyAnachronismDesc(iso, expectedIso, year, country);
            outliers.add(NumismaticEmissionOutlier(
              type: NumismaticEmissionOutlierType.currencyAnachronism,
              title: AppStrings.numismaticEmissionOutlierCardTitle,
              description: desc,
              suggestedFixDescription: AppStrings.fixCorrectCurrencyAction,
              expectedValue: expectedIso,
              foundValue: iso,
              targetPropertyName: AppStrings.currencyPropertyName,
            ));
          }
        }

        final rule = NumismaticMatrix.findRule(
          country,
          year,
          currencyCode: currency,
          denomination: denomStr,
          isBanknote: isBanknote,
        ) ?? allRules.first;

        // B. Material contradiction check
        if (denomStr != null && denomStr.isNotEmpty && material != null && material.isNotEmpty) {
          final validMaterials = NumismaticMatrix.getValidMaterials(
            country: country,
            year: year,
            currencyCode: currency,
            denomination: denomStr,
            isBanknote: isBanknote,
          );
          if (validMaterials.isNotEmpty) {
            final resolvedFoundMat = NumismaticParser.resolveMaterial(material);
            final isValid = validMaterials.any((m) {
              final cleanM = m.trim().toLowerCase();
              return cleanM == resolvedFoundMat.toLowerCase() ||
                  cleanM == material.trim().toLowerCase();
            });
            if (!isValid) {
              final expectedMat = validMaterials.first;
              final desc = validMaterials.length > 1
                  ? AppStrings.numismaticMagnitudeNotAmongExpectedDesc(AppStrings.materialPropertyName, currentValue: material)
                  : AppStrings.numismaticMaterialContradictionDesc(material, expectedMat, denomStr);
              outliers.add(NumismaticEmissionOutlier(
                type: NumismaticEmissionOutlierType.materialContradiction,
                title: AppStrings.numismaticEmissionOutlierCardTitle,
                description: desc,
                suggestedFixDescription: AppStrings.fixCorrectMaterialAction,
                expectedValue: expectedMat,
                foundValue: material,
                targetPropertyName: AppStrings.materialPropertyName,
              ));
            }
          }
        }

        // C. Commemorative Motif check
        if (denomStr != null && denomStr.isNotEmpty) {
          final motifs = NumismaticMatrix.getCommemorativeMotifs(
            country: country,
            year: year,
            currencyCode: currency,
            denomination: denomStr,
            isBanknote: isBanknote,
          );
          final effectiveMotif = attrs.motif;

          bool isMotifMismatch = false;
          if (effectiveMotif != null && effectiveMotif.trim().isNotEmpty) {
            if (motifs.isNotEmpty) {
              final matchesAny = motifs.any((m) => NumismaticEmissionRuleData.matchesMotif(m, effectiveMotif));
              if (!matchesAny) {
                isMotifMismatch = true;
              }
            } else {
              isMotifMismatch = true;
            }
          } else if (motifs.length > 1) {
            isMotifMismatch = true;
          }

          if (isMotifMismatch) {
            final expectedMotif = motifs.isNotEmpty ? motifs.first : AppStrings.motifPropertyName;
            final desc = motifs.length > 1
                ? AppStrings.numismaticMagnitudeNotAmongExpectedDesc(AppStrings.motifPropertyName, currentValue: effectiveMotif)
                : AppStrings.numismaticMotifMismatchDesc(denomStr, expectedMotif, currentMotif: effectiveMotif);
            outliers.add(NumismaticEmissionOutlier(
              type: NumismaticEmissionOutlierType.motifMismatch,
              title: AppStrings.numismaticEmissionOutlierCardTitle,
              description: desc,
              suggestedFixDescription: AppStrings.fixSetMotifAction,
              expectedValue: expectedMotif,
              foundValue: effectiveMotif,
              targetPropertyName: AppStrings.motifPropertyName,
            ));
          }
        }

        // D. Denomination anomaly check
        if (denomStr != null && denomStr.isNotEmpty) {
          final matchesDenom = allRules.any((r) => r.hasDenomination(denomStr!));
          if (!matchesDenom) {
            final allDenoms = allRules.expand((r) => r.denominations).toSet();
            final desc = allDenoms.length > 1
                ? AppStrings.numismaticMagnitudeNotAmongExpectedDesc(AppStrings.nominalValuePropertyName, currentValue: denomStr)
                : AppStrings.numismaticDenominationAnomalyDesc(denomStr, country, year);
            outliers.add(NumismaticEmissionOutlier(
              type: NumismaticEmissionOutlierType.denominationAnomaly,
              title: AppStrings.numismaticEmissionOutlierCardTitle,
              description: desc,
              suggestedFixDescription: AppStrings.fixPickDenominationAction,
              expectedValue: rule.denominations.first,
              foundValue: denomStr,
              targetPropertyName: AppStrings.nominalValuePropertyName,
            ));
          }
        }
      }
    }

    return outliers;
  }
}
