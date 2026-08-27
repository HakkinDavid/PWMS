import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'brand_dictionary.dart';
import 'fast_lazy_taxonomy_registry.dart';
import 'product_taxonomy_dictionary.dart';
import 'product_taxonomy_service.dart';
import 'spanish_singularizer.dart';

class TaxonomyRequestContext {
  final String title;
  final String cleanTitle;
  final String? categoryHint;
  final String? genericName;
  final String? brandHint;
  final String combinedText;
  final String? inferredBrand;

  TaxonomyRequestContext({
    required this.title,
    required this.cleanTitle,
    this.categoryHint,
    this.genericName,
    this.brandHint,
  })  : inferredBrand = (brandHint != null && brandHint.trim().isNotEmpty)
            ? brandHint.trim()
            : BrandDictionary.inferBrand(cleanTitle),
        combinedText = AppStrings.taxonomyCombinedText(genericName, categoryHint, cleanTitle).toLowerCase();
}

abstract class ITaxonomyHandler {
  ITaxonomyHandler? _nextHandler;

  ITaxonomyHandler setNext(ITaxonomyHandler handler) {
    _nextHandler = handler;
    return handler;
  }

  TaxonomyResolution handle(TaxonomyRequestContext context) {
    final result = process(context);
    if (result != null) {
      return result;
    }
    if (_nextHandler != null) {
      return _nextHandler!.handle(context);
    }
    return const TaxonomyResolution(
      generalSpeciesName: AppStrings.typeObject,
      department: AppStrings.taxonomyDepartmentGeneral,
      confidence: 0.1,
    );
  }

  TaxonomyResolution? process(TaxonomyRequestContext context);
}

/// Handler 1: FastLazyTaxonomyRegistry (Lookup O(1) in massive precompiled registry)
class FastLazyRegistryHandler extends ITaxonomyHandler {
  @override
  TaxonomyResolution? process(TaxonomyRequestContext context) {
    final lazyMatch = FastLazyTaxonomyRegistry.lookup(context.combinedText);
    if (lazyMatch != null) {
      final singularName = SpanishSingularizer.toSingular(lazyMatch.species);
      return TaxonomyResolution(
        generalSpeciesName: singularName,
        department: lazyMatch.department,
        inferredBrand: context.inferredBrand,
        confidence: 0.95,
      );
    }
    return null;
  }
}

/// Handler 2: ProductTaxonomyDictionary (Rule-based Regex and Keyword scoring)
class ProductTaxonomyDictionaryHandler extends ITaxonomyHandler {
  @override
  TaxonomyResolution? process(TaxonomyRequestContext context) {
    CategoryDefinition? bestMatch;
    int highestScore = 0;

    for (final def in ProductTaxonomyDictionary.definitions) {
      int score = 0;

      if (def.regexPatterns != null) {
        for (final pattern in def.regexPatterns!) {
          if (RegExp(pattern, caseSensitive: false).hasMatch(context.combinedText)) {
            score += 50;
            break;
          }
        }
      }

      for (final kw in def.keywords) {
        if (context.combinedText.contains(kw.toLowerCase())) {
          score += (kw.length >= 5) ? 15 : 10;
        }
      }

      if (score > highestScore) {
        highestScore = score;
        bestMatch = def;
      }
    }

    if (bestMatch != null && highestScore >= 10) {
      final singularSpeciesName = SpanishSingularizer.toSingular(bestMatch.generalSpeciesName);

      return TaxonomyResolution(
        generalSpeciesName: singularSpeciesName,
        department: bestMatch.department,
        inferredBrand: context.inferredBrand,
        confidence: (highestScore / 50.0).clamp(0.5, 1.0),
      );
    }

    return null;
  }
}

/// Handler 3: NlpFallbackHandler (NLP extraction + Singularizer)
class NlpFallbackHandler extends ITaxonomyHandler {
  @override
  TaxonomyResolution? process(TaxonomyRequestContext context) {
    final nlpSpeciesName = _extractNounFromTitle(context.cleanTitle, context.inferredBrand);

    return TaxonomyResolution(
      generalSpeciesName: SpanishSingularizer.toSingular(nlpSpeciesName),
      department: AppStrings.taxonomyDepartmentGeneral,
      inferredBrand: context.inferredBrand,
      confidence: 0.4,
    );
  }

  String _extractNounFromTitle(String title, String? brand) {
    var cleaned = title;
    if (brand != null && brand.isNotEmpty) {
      cleaned = cleaned.replaceAll(RegExp(brand, caseSensitive: false), AppTechnicalStrings.empty);
    }

    cleaned = cleaned.replaceAll(
        RegExp(AppTechnicalStrings.regexUnitsStrip, caseSensitive: false), AppTechnicalStrings.empty);
    cleaned = cleaned.replaceAll(RegExp(AppTechnicalStrings.regexYearNumberStrip, caseSensitive: false), AppTechnicalStrings.empty);
    cleaned = cleaned.replaceAll(RegExp(AppTechnicalStrings.regexNonAlphaNumeric, unicode: true), AppTechnicalStrings.space);

    final words = cleaned.trim().split(RegExp(AppTechnicalStrings.regexMultipleSpaces)).where((w) => w.length >= 3).toList();

    if (words.isNotEmpty) {
      final firstWord = words.first;
      return firstWord[0].toUpperCase() + firstWord.substring(1).toLowerCase();
    }

    return AppStrings.typeObject;
  }
}
