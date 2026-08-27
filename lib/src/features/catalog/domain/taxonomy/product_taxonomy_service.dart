import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'taxonomy_chain.dart';

class TaxonomyResolution {
  final String generalSpeciesName;
  final String department;
  final String? inferredBrand;
  final double confidence; // 0.0 to 1.0

  const TaxonomyResolution({
    required this.generalSpeciesName,
    required this.department,
    this.inferredBrand,
    this.confidence = 1.0,
  });
}

class ProductTaxonomyService {
  final ITaxonomyHandler _chain;

  ProductTaxonomyService([ITaxonomyHandler? chain])
      : _chain = chain ?? _buildDefaultChain();

  static ITaxonomyHandler _buildDefaultChain() {
    final lazyHandler = FastLazyRegistryHandler();
    final dictHandler = ProductTaxonomyDictionaryHandler();
    final nlpHandler = NlpFallbackHandler();

    lazyHandler.setNext(dictHandler).setNext(nlpHandler);
    return lazyHandler;
  }

  /// Resolver la especie general atómica en SINGULAR ESTRICTO mediante la cadena de responsabilidad
  TaxonomyResolution resolve({
    required String title,
    String? categoryHint,
    String? genericName,
    String? brandHint,
  }) {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      return const TaxonomyResolution(
        generalSpeciesName: AppStrings.typeObject,
        department: AppStrings.taxonomyDepartmentGeneral,
        confidence: 0.1,
      );
    }

    final context = TaxonomyRequestContext(
      title: title,
      cleanTitle: cleanTitle,
      categoryHint: categoryHint,
      genericName: genericName,
      brandHint: brandHint,
    );

    return _chain.handle(context);
  }
}
