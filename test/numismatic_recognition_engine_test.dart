import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';

void main() {
  group('Numismatic Models & 4NF Mapping Tests', () {
    test('NumismaticScanResult correctly maps SI magnitudes for 4NF', () {
      final result = NumismaticScanResult(
        speciesType: 'Moneda',
        generalSpeciesName: 'Moneda',
        subspeciesName: '5 Pesos Mexicanos - México (1982)',
        faceValueNumber: 5.0,
        year: '1982',
        obversePhotoPath: '/tmp/obverse.jpg',
        sourceEngine: 'Test Engine',
      );

      final magValues = result.toMagnitudeValues();
      expect(magValues['Unidad Monetaria'], equals(5.0));
      expect(magValues['Año'], equals(1982.0));
    });

    test('NumismaticScanResult handles missing magnitudes gracefully', () {
      final result = NumismaticScanResult(
        speciesType: 'Billete',
        generalSpeciesName: 'Billete',
        subspeciesName: '100 Pesos Mexicanos - México',
        obversePhotoPath: '/tmp/obverse.jpg',
        sourceEngine: 'Local Engine',
      );

      final magValues = result.toMagnitudeValues();
      expect(magValues.containsKey('Año'), isFalse);
      expect(magValues.containsKey('Unidad Monetaria'), isFalse);
    });
  });
}
