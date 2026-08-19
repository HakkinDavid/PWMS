import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/fast_lazy_taxonomy_registry.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/product_taxonomy_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/taxonomy_chain.dart';

void main() {
  group('Product Taxonomy Chain of Responsibility Tests', () {
    setUpAll(() {
      FastLazyTaxonomyRegistry.initialize();
    });

    test('FastLazyRegistryHandler resolves precompiled registry items at high confidence', () {
      final handler = FastLazyRegistryHandler();
      final context = TaxonomyRequestContext(
        title: 'Taladro Percutor 18V',
        cleanTitle: 'Taladro Percutor 18V',
      );

      final result = handler.handle(context);
      expect(result.generalSpeciesName, 'Taladro');
      expect(result.confidence, 0.95);
    });

    test('ProductTaxonomyDictionaryHandler matches regex patterns and keyword rules', () {
      final handler = ProductTaxonomyDictionaryHandler();
      final context = TaxonomyRequestContext(
        title: 'Shampoo Anticaspa 400ml',
        cleanTitle: 'Shampoo Anticaspa 400ml',
      );

      final result = handler.handle(context);
      expect(result.generalSpeciesName, 'Champú');
      expect(result.department, 'Salud y Cuidado Personal');
    });

    test('NlpFallbackHandler extracts singular noun when no dictionary matches', () {
      final handler = NlpFallbackHandler();
      final context = TaxonomyRequestContext(
        title: 'GizmoWidgetPro Ultra 5000',
        cleanTitle: 'GizmoWidgetPro Ultra 5000',
      );

      final result = handler.handle(context);
      expect(result.generalSpeciesName, 'Gizmowidgetpro');
      expect(result.confidence, 0.4);
    });

    test('ProductTaxonomyService executes complete chain seamlessly', () {
      final service = ProductTaxonomyService();

      final res1 = service.resolve(title: 'Castrol Aceite de Motor Sintético 5W-30');
      expect(res1.generalSpeciesName, 'Aceite de Motor');

      final res2 = service.resolve(title: 'Galletas de Avena con Chocolate');
      expect(res2.generalSpeciesName, 'Galleta');

      final res3 = service.resolve(title: '');
      expect(res3.generalSpeciesName, 'Objeto');
    });
  });
}
