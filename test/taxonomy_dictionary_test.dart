import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/brand_dictionary.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/product_taxonomy_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/spanish_singularizer.dart';

void main() {
  group('Atomic Singular Species Explosion Tests (PWMS V5)', () {
    const service = ProductTaxonomyService();

    test('1. Alimentos: Leche y Huevo son Especies Atómicas Singulares distintas', () {
      final resLeche = service.resolve(title: 'Leche Lala Entera 1L');
      expect(resLeche.generalSpeciesName, 'Leche');
      expect(resLeche.inferredBrand, 'Lala');

      final resHuevo = service.resolve(title: 'Huevo Blanco San Juan 30 Piezas');
      expect(resHuevo.generalSpeciesName, 'Huevo');

      final resPure = service.resolve(title: 'Puré de Tomate Del Fuerte 210g');
      expect(resPure.generalSpeciesName, 'Puré de Tomate');

      final resAzucar = service.resolve(title: 'Azúcar Estándar Zulka 1kg');
      expect(resAzucar.generalSpeciesName, 'Azúcar');
    });

    test('2. Bebidas: Refresco vs Leche vs Agua (NO megagrupos Bebida)', () {
      final resRefresco = service.resolve(title: 'Coca-Cola Original Refresco 600ml');
      expect(resRefresco.generalSpeciesName, 'Refresco');
      expect(resRefresco.inferredBrand, 'Coca-Cola');

      final resAgua = service.resolve(title: 'Ciel Agua Purificada 1L');
      expect(resAgua.generalSpeciesName, 'Agua Embotellada');
      expect(resAgua.inferredBrand, 'Ciel');
    });

    test('3. Limpieza: Cloro y Detergente son Especies Atómicas Singulares', () {
      final resCloro = service.resolve(title: 'Clorox Blanqueador Tradicional 930ml');
      expect(resCloro.generalSpeciesName, 'Cloro');
      expect(resCloro.inferredBrand, 'Clorox');

      final resDetergente = service.resolve(title: 'Ariel Detergente Líquido 3L');
      expect(resDetergente.generalSpeciesName, 'Detergente');
      expect(resDetergente.inferredBrand, 'Ariel');
    });

    test('4. Cuidado Personal: Jabón, Champú, Pasta Dental', () {
      final resJabon = service.resolve(title: 'Dove Jabón de Tocador 135g');
      expect(resJabon.generalSpeciesName, 'Jabón');
      expect(resJabon.inferredBrand, 'Dove');

      final resChampu = service.resolve(title: 'Pantene Champú Restauración 700ml');
      expect(resChampu.generalSpeciesName, 'Champú');

      final resPasta = service.resolve(title: 'Colgate Total 12 Pasta Dental 150ml');
      expect(resPasta.generalSpeciesName, 'Pasta Dental');
      expect(resPasta.inferredBrand, 'Colgate');
    });

    test('5. SpanishSingularizer Enforcement Test', () {
      expect(SpanishSingularizer.toSingular('Tomates'), 'Tomate');
      expect(SpanishSingularizer.toSingular('Audífonos'), 'Audífono');
      expect(SpanishSingularizer.toSingular('Jabones'), 'Jabón');
      expect(SpanishSingularizer.toSingular('Papas'), 'Papa');
      expect(SpanishSingularizer.toSingular('Detergentes'), 'Detergente');
    });

    test('6. Miguelito Chile en Polvo Caso Único', () {
      final resMiguelito = service.resolve(title: 'Miguelito Polvo Enchilado 250g');
      expect(resMiguelito.generalSpeciesName, 'Dulce de Chile');
    });
  });
}
