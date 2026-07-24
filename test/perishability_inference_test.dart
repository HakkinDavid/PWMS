import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/perishability_inference_engine.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';

void main() {
  group('Perishability Inference & Type Restriction Tests', () {
    test('Non-Object species types are strictly non-perishable and cannot expire', () {
      final serVivo = CatalogItem(
        id: 'c1',
        name: 'Planta de Orquídea',
        type: 'Ser vivo',
        isNonPerishable: false, // Attempting to set false
        createdAt: DateTime.now(),
      );

      final documento = CatalogItem(
        id: 'c2',
        name: 'Pasaporte',
        type: 'Documento',
        isNonPerishable: true,
        createdAt: DateTime.now(),
      );

      expect(serVivo.canExpire, false);
      expect(documento.canExpire, false);

      final inference = PerishabilityInferenceEngine.inferPerishability(
        type: 'Ser vivo',
        title: 'Planta de Orquídea',
      );
      expect(inference.isNonPerishable, true);
    });

    test('Object species default to non-perishable unless explicitly marked or inferred', () {
      final defaultObject = CatalogItem(
        id: 'c3',
        name: 'Silla Ergonómica',
        type: 'Objeto',
        isNonPerishable: true, // Default
        createdAt: DateTime.now(),
      );

      final perishableFood = CatalogItem(
        id: 'c4',
        name: 'Leche Entera 1L',
        type: 'Objeto',
        isNonPerishable: false,
        defaultShelfLifeDays: 14,
        createdAt: DateTime.now(),
      );

      expect(defaultObject.canExpire, false);
      expect(perishableFood.canExpire, true);
    });

    test('PerishabilityInferenceEngine classifies food/medicine as perishable and electronics/tools as non-perishable', () {
      final milkInference = PerishabilityInferenceEngine.inferPerishability(
        type: 'Objeto',
        title: 'Leche Alpura 1L',
        category: 'Lácteos',
      );
      expect(milkInference.isNonPerishable, false);
      expect(milkInference.suggestedShelfLifeDays, 14);

      final breadInference = PerishabilityInferenceEngine.inferPerishability(
        type: 'Objeto',
        title: 'Pan Molde Blanco',
      );
      expect(breadInference.isNonPerishable, false);
      expect(breadInference.suggestedShelfLifeDays, 7);

      final laptopInference = PerishabilityInferenceEngine.inferPerishability(
        type: 'Objeto',
        title: 'MacBook Pro 16',
        category: 'Computadoras & Laptops',
      );
      expect(laptopInference.isNonPerishable, true);

      final unknownObject = PerishabilityInferenceEngine.inferPerishability(
        type: 'Objeto',
        title: 'Artículo Desconocido XYZ',
      );
      expect(unknownObject.isNonPerishable, true);
    });

    test('GS1 Barcode AI(17) expiration date parsing', () {
      // (17)261231 -> 31/12/2026
      final expiration = PerishabilityInferenceEngine.parseGS1ExpirationDate('(17)261231');
      expect(expiration, isNotNull);
      expect(expiration!.year, 2026);
      expect(expiration.month, 12);
      expect(expiration.day, 31);

      final nonGs1 = PerishabilityInferenceEngine.parseGS1ExpirationDate('7501055300075');
      expect(nonGs1, isNull);
    });

    test('WorldEntity honors canExpire flag', () {
      final now = DateTime(2026, 7, 24);
      final entity = WorldEntity(
        id: 'e1',
        speciesId: 'c1',
        expirationDate: DateTime(2026, 7, 20), // Past date
        createdAt: now,
        updatedAt: now,
      );

      // If canExpire is false (e.g. Non-perishable or Non-object), isExpired is false!
      expect(entity.isExpired(canExpire: false, now: now), false);
      expect(entity.isExpired(canExpire: true, now: now), true);
    });
  });
}
