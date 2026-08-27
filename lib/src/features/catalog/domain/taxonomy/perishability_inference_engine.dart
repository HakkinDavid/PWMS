import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

class PerishabilityInferenceResult {
  final bool isNonPerishable;
  final int? suggestedShelfLifeDays;
  final DateTime? extractedExpirationDate;
  final String? inferenceReason;

  const PerishabilityInferenceResult({
    required this.isNonPerishable,
    this.suggestedShelfLifeDays,
    this.extractedExpirationDate,
    this.inferenceReason,
  });
}

class PerishabilityInferenceEngine {
  const PerishabilityInferenceEngine._();

  /// Parse GS1 Barcode Application Identifiers (AI 17 = Expiration Date, AI 15 = Best Before Date)
  /// Valid formats: (17)YYMMDD, (15)YYMMDD, ^17YYMMDD, ^15YYMMDD, or after GTIN-14 ^01\d{14}(17|15)YYMMDD
  static DateTime? parseGS1ExpirationDate(String barcode) {
    final raw = barcode.trim();
    if (raw.isEmpty) return null;

    // 1. Check for explicit parenthesis notation: (17)YYMMDD or (15)YYMMDD
    final parenRegex = RegExp(AppTechnicalStrings.regexGs1ParenExpiration);
    var match = parenRegex.firstMatch(raw);

    // 2. If no parenthesis, only match structured GS1 formats (starts with 17/15 or follows GTIN-14)
    if (match == null) {
      final clean = raw.replaceAll(RegExp(AppTechnicalStrings.regexGs1StripSpacesDashes), AppTechnicalStrings.empty);
      final structuredGs1Regex = RegExp(AppTechnicalStrings.regexGs1StructuredExpiration);
      match = structuredGs1Regex.firstMatch(clean);
    }

    if (match != null) {
      try {
        final year = 2000 + int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final day = int.parse(match.group(3)!);

        if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
          return DateTime(year, month, day);
        }
      } catch (_) {}
    }
    return null;
  }

  /// Infer perishability and shelf life based on barcode, title, category, and generic name
  static PerishabilityInferenceResult inferPerishability({
    required String type,
    String? title,
    String? category,
    String? genericName,
    String? barcode,
  }) {
    // Rule 1: Non-Object species types (Ser vivo, Documento, Proyecto, etc.) are strictly non-perishable
    if (type != AppStrings.typeObject) {
      return const PerishabilityInferenceResult(
        isNonPerishable: true,
        inferenceReason: AppStrings.perishabilityReasonNonObjectType,
      );
    }

    // Rule 2: Check GS1 Barcode for explicit expiration date
    DateTime? gs1Expiration;
    if (barcode != null && barcode.isNotEmpty) {
      gs1Expiration = parseGS1ExpirationDate(barcode);
    }

    final textToAnalyze = [
      title ?? AppTechnicalStrings.empty,
      AppTechnicalStrings.space,
      category ?? AppTechnicalStrings.empty,
      AppTechnicalStrings.space,
      genericName ?? AppTechnicalStrings.empty,
    ].join().toLowerCase();

    // Check non-perishable keywords explicitly
    for (final kw in AppTechnicalStrings.nonPerishableKeywordsElectronics) {
      if (textToAnalyze.contains(kw)) {
        return PerishabilityInferenceResult(
          isNonPerishable: true,
          extractedExpirationDate: gs1Expiration,
          inferenceReason: AppStrings.perishabilityReasonDurableObject(kw),
        );
      }
    }

    // Check perishable categories & keywords
    if (_containsAny(textToAnalyze, AppTechnicalStrings.perishableKeywordsDairy)) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 14,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: AppStrings.perishabilityReasonDairy,
      );
    }

    if (_containsAny(textToAnalyze, AppTechnicalStrings.perishableKeywordsBakery)) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 7,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: AppStrings.perishabilityReasonBakery,
      );
    }

    if (_containsAny(textToAnalyze, AppTechnicalStrings.perishableKeywordsFruitVeg)) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 7,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: AppStrings.perishabilityReasonFruitVeg,
      );
    }

    if (_containsAny(textToAnalyze, AppTechnicalStrings.perishableKeywordsMeat)) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 5,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: AppStrings.perishabilityReasonMeat,
      );
    }

    if (_containsAny(textToAnalyze, AppTechnicalStrings.perishableKeywordsBeverages)) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 30,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: AppStrings.perishabilityReasonBeverage,
      );
    }

    if (_containsAny(textToAnalyze, AppTechnicalStrings.perishableKeywordsPharmacy)) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 365,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: AppStrings.perishabilityReasonPharmacy,
      );
    }

    if (_containsAny(textToAnalyze, AppTechnicalStrings.perishableKeywordsCanned)) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 365,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: AppStrings.perishabilityReasonCanned,
      );
    }

    // Default Rule 4: If unclassified or unknown, defaults to No Perecedero
    return PerishabilityInferenceResult(
      isNonPerishable: true,
      extractedExpirationDate: gs1Expiration,
      inferenceReason: AppStrings.perishabilityReasonDefault,
    );
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((kw) => text.contains(kw));
  }
}
