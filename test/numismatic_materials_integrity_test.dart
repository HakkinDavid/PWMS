import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';

void main() {
  group('Numismatic Materials Integrity & Centralized Registry Tests', () {
    test('1. Every material in NumismaticMaterialsRegistry is well-formed and unique', () {
      const allMaterials = NumismaticMaterialsRegistry.allMaterials;
      expect(allMaterials, isNotEmpty);

      final keys = <String>{};
      final displayNames = <String>{};

      for (final mat in allMaterials) {
        // Key uniqueness and format
        expect(keys.add(mat.key), isTrue, reason: 'Duplicate key: ${mat.key}');
        expect(mat.key.trim(), isNotEmpty);
        expect(mat.key, equals(mat.key.toLowerCase()));

        // DisplayName uniqueness and format
        expect(displayNames.add(mat.displayName), isTrue, reason: 'Duplicate displayName: ${mat.displayName}');
        expect(mat.displayName.trim(), isNotEmpty);
        expect(mat.shortName.trim(), isNotEmpty);

        // Aliases are non-empty
        for (final alias in mat.aliases) {
          expect(alias.trim(), isNotEmpty);
        }

        // Bimetallic pieces must specify components
        if (mat.structure == NumismaticMaterialStructure.bimetallic && mat.key != 'bimetallic') {
          expect(mat.coreMaterial, isNotNull, reason: '${mat.key} should specify coreMaterial');
          expect(mat.ringMaterial, isNotNull, reason: '${mat.key} should specify ringMaterial');
        }

        // Precious metal purity checks
        if (mat.fineness != null) {
          expect(mat.fineness, greaterThan(0.0));
          expect(mat.fineness, lessThanOrEqualTo(1.0));
        }
      }
    });

    test('2. 100% of materials in all emission rules originate from NumismaticMaterialsRegistry', () {
      final allRules = NumismaticDataHelper.emissionRules;
      expect(allRules, isNotEmpty);

      final validDisplayNames = NumismaticMaterialsRegistry.allDisplayNames.toSet();
      final observedMaterials = <String>{};

      for (final rule in allRules) {
        for (final piece in rule.pieces) {
          for (final motif in piece.motifs) {
            observedMaterials.add(motif.material);
            expect(
              validDisplayNames.contains(motif.material),
              isTrue,
              reason: 'Rule for ${rule.country} (${piece.denomination} ${piece.currency}) contains unregistered material: "${motif.material}" in motif "${motif.name}"',
            );
          }
        }
      }

      // Verify that no legacy duplicate phrases exist
      expect(observedMaterials.contains('Zinc recubierto de cobre'), isFalse);
      expect(observedMaterials.contains('Alpaca (Plata alemana) / Latón'), isFalse);
    });

    test('3. Semantic compatibility resolution for generic families vs exact alloys', () {
      // Silver family compatibility
      expect(NumismaticMaterialsRegistry.areCompatible('Plata', 'Plata .720'), isTrue);
      expect(NumismaticMaterialsRegistry.areCompatible('Plata .720', 'Plata'), isTrue);
      expect(NumismaticMaterialsRegistry.areCompatible('Plata', 'Plata .925'), isTrue);
      expect(NumismaticMaterialsRegistry.areCompatible('Plata .903', 'Plata .903'), isTrue);

      // Gold family compatibility
      expect(NumismaticMaterialsRegistry.areCompatible('Oro', 'Oro .900'), isTrue);
      expect(NumismaticMaterialsRegistry.areCompatible('Oro .900', 'Oro'), isTrue);
      expect(NumismaticMaterialsRegistry.areCompatible('Oro', 'Oro Fino .999'), isTrue);

      // Bimetallic family compatibility
      expect(
        NumismaticMaterialsRegistry.areCompatible(
          'Bimetálica',
          'Bimetálica (Centro Bronce de Aluminio, Anillo Acero Inoxidable)',
        ),
        isTrue,
      );

      // Genuine contradictions must evaluate to false
      expect(NumismaticMaterialsRegistry.areCompatible('Cuproníquel', 'Plata .720'), isFalse);
      expect(NumismaticMaterialsRegistry.areCompatible('Oro', 'Plata .925'), isFalse);
      expect(NumismaticMaterialsRegistry.areCompatible('Acero', 'Bronce'), isFalse);
      expect(NumismaticMaterialsRegistry.areCompatible('Aluminio', 'Oro .900'), isFalse);
    });

    test('4. NumismaticParser resolves materials, aliases, and compound configurations', () {
      expect(NumismaticParser.resolveMaterial('plata .720'), equals('Plata .720'));
      expect(NumismaticParser.resolveMaterial('silver_720'), equals('Plata .720'));
      expect(NumismaticParser.resolveMaterial('sterling silver'), equals('Plata .925'));
      expect(NumismaticParser.resolveMaterial('plata virreinal'), equals('Plata .903'));
      expect(NumismaticParser.resolveMaterial('centenario'), equals('Oro .900'));
      expect(NumismaticParser.resolveMaterial('oro 22k'), equals('Oro Crown .9167'));
      expect(NumismaticParser.resolveMaterial('copper-plated zinc'), equals('Zinc bañado en cobre'));
      expect(NumismaticParser.resolveMaterial('zinc recubierto de cobre'), equals('Zinc bañado en cobre'));
      expect(NumismaticParser.resolveMaterial('cupronickel clad copper'), equals('Cuproníquel sobre núcleo de cobre'));
      expect(NumismaticParser.resolveMaterial('cotton paper'), equals('Papel de algodón'));
      expect(NumismaticParser.resolveMaterial('polimero'), equals('Polímero'));
    });

    test('5. Exact historical inferences for Mexico, USA, Spain, and World coins', () {
      // Mexico 1982 50 Pesos -> Cuproníquel
      final matMex50 = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 1982,
        currencyCode: 'MXP',
        denomination: '50',
      );
      expect(matMex50, equals('Cuproníquel'));

      // Mexico 1978 100 Pesos Morelos -> Plata .720
      final matMex100 = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 1978,
        currencyCode: 'MXP',
        denomination: '100',
      );
      expect(matMex100, equals('Plata .720'));

      // Mexico 1947 50 Pesos Centenario -> Oro .900
      final matCentenario = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 1947,
        currencyCode: 'MXP',
        denomination: '50',
      );
      expect(matCentenario, equals('Oro .900'));

      // Mexico 2000 10 Pesos -> Bimetálica (Centro Alpaca, Anillo Bronce de Aluminio)
      final matMex10 = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 2000,
        currencyCode: 'MXN',
        denomination: '10',
      );
      expect(matMex10, equals('Bimetálica (Centro Alpaca, Anillo Bronce de Aluminio)'));

      // Mexico 2000 1 Peso -> Bimetálica (Centro Bronce de Aluminio, Anillo Acero Inoxidable)
      final matMex1 = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 2000,
        currencyCode: 'MXN',
        denomination: '1',
      );
      expect(matMex1, equals('Bimetálica (Centro Bronce de Aluminio, Anillo Acero Inoxidable)'));

      // USA 1964 0.25 -> Plata .900
      final matUsQuarter64 = NumismaticDataHelper.inferMaterial(
        country: 'Estados Unidos',
        year: 1964,
        denomination: '0.25',
      );
      expect(matUsQuarter64, equals('Plata .900'));

      // USA 1985 0.01 -> Zinc bañado en cobre
      final matUsCent85 = NumismaticDataHelper.inferMaterial(
        country: 'Estados Unidos',
        year: 1985,
        denomination: '0.01',
      );
      expect(matUsCent85, equals('Zinc bañado en cobre'));

      // Spain 2005 1 Euro -> Bimetálica (Centro Cuproníquel, Anillo Níquel-Latón)
      final matEuro1 = NumismaticDataHelper.inferMaterial(
        country: 'España',
        year: 2005,
        denomination: '1',
      );
      expect(matEuro1, equals('Bimetálica (Centro Cuproníquel, Anillo Níquel-Latón)'));

      // Spain 2005 2 Euro -> Bimetálica (Centro Níquel-Latón, Anillo Cuproníquel)
      final matEuro2 = NumismaticDataHelper.inferMaterial(
        country: 'España',
        year: 2005,
        denomination: '2',
      );
      expect(matEuro2, equals('Bimetálica (Centro Níquel-Latón, Anillo Cuproníquel)'));
    });
  });
}
