import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';

void main() {
  group('Numismatic Recognition Engine & Models Tests', () {
    test('NumismaticScanResult correctly maps SI magnitudes for 4NF', () {
      final result = NumismaticScanResult(
        speciesType: 'Moneda',
        generalSpeciesName: 'Moneda',
        subspeciesName: '5 Pesetas (1982 - España)',
        massGrams: 5.75,
        diameterMm: 23.0,
        obversePhotoPath: '/tmp/obverse.jpg',
        sourceEngine: 'Test Engine',
      );

      final magValues = result.toMagnitudeValues();
      expect(magValues['Masa'], equals(5.75));
      expect(magValues['Diámetro'], equals(23.0));
    });

    test('NumismaticScanResult handles missing magnitudes gracefully', () {
      final result = NumismaticScanResult(
        speciesType: 'Billete',
        generalSpeciesName: 'Billete',
        subspeciesName: '100 Pesetas (1970)',
        obversePhotoPath: '/tmp/obverse.jpg',
        sourceEngine: 'Local Engine',
      );

      final magValues = result.toMagnitudeValues();
      expect(magValues.containsKey('Masa'), isFalse);
      expect(magValues.containsKey('Diámetro'), isFalse);
    });
  });
}
