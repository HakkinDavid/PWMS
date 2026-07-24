import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/brand_dictionary.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/fast_lazy_taxonomy_registry.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/product_taxonomy_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/spanish_singularizer.dart';

void main() {
  group('PWMS Massive Taxonomy Pipeline Tests (GS1 GPC + OFF + Wikidata)', () {
    const service = ProductTaxonomyService();

    test('1. FastLazyTaxonomyRegistry initialization & O(1) lookup', () {
      FastLazyTaxonomyRegistry.initialize();
      final item = FastLazyTaxonomyRegistry.lookup('taladro');
      expect(item, isNotNull);
      expect(item!.species, 'Taladro');
      expect(item.department, contains('Herramientas'));
    });

    test('2. Ferretería, Herramientas y Automotriz Atomic Singular Resolution', () {
      final resTaladro = service.resolve(title: 'DeWalt Taladro Inalámbrico 20V');
      expect(resTaladro.generalSpeciesName, 'Taladro');
      expect(resTaladro.inferredBrand, 'DeWalt');

      final resAceite = service.resolve(title: 'Castrol Aceite de Motor Sintético 5W-30');
      expect(resAceite.generalSpeciesName, 'Aceite de Motor');
      expect(resAceite.inferredBrand, 'Castrol');

      final resTubo = service.resolve(title: 'Tubo de PVC 1/2 pulgada');
      expect(resTubo.generalSpeciesName, 'Tubo de PVC');
    });

    test('3. Alimentos, Bebidas y Abarrotes Resolution', () {
      final resLeche = service.resolve(title: 'Leche Lala Entera 1L');
      expect(resLeche.generalSpeciesName, 'Leche');
      expect(resLeche.inferredBrand, 'Lala');

      final resHuevo = service.resolve(title: 'Huevo Blanco San Juan 30 Piezas');
      expect(resHuevo.generalSpeciesName, 'Huevo');

      final resRefresco = service.resolve(title: 'Coca-Cola Original Refresco 600ml');
      expect(resRefresco.generalSpeciesName, 'Refresco');
      expect(resRefresco.inferredBrand, 'Coca-Cola');

      final resPure = service.resolve(title: 'Puré de Tomate Del Fuerte 210g');
      expect(resPure.generalSpeciesName, 'Puré de Tomate');
    });

    test('4. Electrónica, Componentes y Gaming Resolution', () {
      final resGpu = service.resolve(title: 'GIGABYTE NVIDIA RTX 4060 GAMING OC 8GB');
      expect(resGpu.generalSpeciesName, 'Tarjeta de Video');
      expect(resGpu.inferredBrand, 'Gigabyte');

      final resControl = service.resolve(title: 'DualSense Midnight Black Wireless Controller');
      expect(resControl.generalSpeciesName, 'Control de Videojuegos');
      expect(resControl.inferredBrand, 'PlayStation');
    });

    test('5. SpanishSingularizer Enforcement', () {
      expect(SpanishSingularizer.toSingular('Tomates'), 'Tomate');
      expect(SpanishSingularizer.toSingular('Audífonos'), 'Audífono');
      expect(SpanishSingularizer.toSingular('Jabones'), 'Jabón');
      expect(SpanishSingularizer.toSingular('Detergentes'), 'Detergente');
    });
  });
}
