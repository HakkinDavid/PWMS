import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_matrix.dart';

void main() {
  group('NumismaticMatrix & Cascading Inference Tests', () {
    test('Mexico 1982 infers MXP currency, 1980s denominations, and Cuproníquel for 50 Pesos', () {
      final inferredCurr = NumismaticDataHelper.inferCurrency(country: 'México', year: 1982);
      expect(inferredCurr, equals('MXP'));

      final denoms = NumismaticDataHelper.getDenominationsForCountry(country: 'México', year: 1982, currencyCode: 'MXP');
      expect(denoms, containsAll(['1', '5', '10', '20', '50', '100', '200', '500', '1000', '5000', 'Otro']));

      final mat50 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1982, currencyCode: 'MXP', denomination: '50');
      expect(mat50, equals('Cuproníquel'));

      final mat100 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1982, currencyCode: 'MXP', denomination: '100');
      expect(mat100, equals('Bronce de aluminio'));
    });

    test('Mexico 1993 infers MXN Nuevos Pesos, bimetallics, and commemorative flags', () {
      final inferredCurr = NumismaticDataHelper.inferCurrency(country: 'México', year: 1993);
      expect(inferredCurr, equals('MXN'));

      final mat10 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1993, currencyCode: 'MXN', denomination: '10');
      expect(mat10, equals('Bimetálica'));

      final special20 = NumismaticDataHelper.checkSpecialEdition(country: 'México', year: 1993, currencyCode: 'MXN', denomination: '20');
      expect(special20, isNotNull);
      expect(special20!.isSpecial, isTrue);
      expect(special20.reason, equals('Emisión de cambio de régimen'));
    });

    test('Mexico 1947 Centenario infers Oro for 50 Pesos', () {
      final inferredCurr = NumismaticDataHelper.inferCurrency(country: 'México', year: 1947);
      expect(inferredCurr, equals('MXP'));

      final mat50 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1947, currencyCode: 'MXP', denomination: '50');
      expect(mat50, equals('Oro'));
    });

    test('Virreinato de Nueva España and Colonial Mexico infer Reales (MXR) and Silver', () {
      final currNuevaEspana = NumismaticDataHelper.inferCurrency(country: 'Virreinato de Nueva España', year: 1800);
      expect(currNuevaEspana, equals('MXR'));

      final mat8Reales = NumismaticDataHelper.inferMaterial(country: 'Virreinato de Nueva España', year: 1800, denomination: '8');
      expect(mat8Reales, equals('Plata'));

      final mat116 = NumismaticDataHelper.inferMaterial(country: 'Virreinato de Nueva España', year: 1800, denomination: '1/16');
      expect(mat116, equals('Cobre'));
    });

    test('USA Silver vs Clad era transition (1964 vs 1970)', () {
      final curr1964 = NumismaticDataHelper.inferCurrency(country: 'Estados Unidos', year: 1964);
      expect(curr1964, equals('USD'));

      final mat1964Quarter = NumismaticDataHelper.inferMaterial(country: 'Estados Unidos', year: 1964, denomination: '0.25');
      expect(mat1964Quarter, equals('Plata'));

      final mat1970Quarter = NumismaticDataHelper.inferMaterial(country: 'Estados Unidos', year: 1970, denomination: '0.25');
      expect(mat1970Quarter, equals('Cuproníquel'));
    });

    test('Spain Pesetas vs Euro transition (1975 vs 2005)', () {
      final curr1975 = NumismaticDataHelper.inferCurrency(country: 'España', year: 1975);
      expect(curr1975, equals('ESP'));

      final curr2005 = NumismaticDataHelper.inferCurrency(country: 'España', year: 2005);
      expect(curr2005, equals('EUR'));

      final matEuro1 = NumismaticDataHelper.inferMaterial(country: 'España', year: 2005, denomination: '1');
      expect(matEuro1, equals('Bimetálica'));
    });

    test('Fallback gracefully when country or year is unspecified or unlisted', () {
      expect(NumismaticDataHelper.inferCurrency(country: null, year: 2000), isNull);
      expect(NumismaticDataHelper.inferCurrency(country: 'Otro', year: 2000), isNull);
      expect(NumismaticDataHelper.inferCurrency(country: 'País Desconocido', year: 2000), isNull);

      final denomsFallback = NumismaticDataHelper.getDenominationsForCountry(country: null, year: null);
      expect(denomsFallback, equals(NumismaticDictionary.denominations));

      expect(NumismaticDataHelper.inferMaterial(country: null, year: null, denomination: '5'), isNull);
      expect(NumismaticDataHelper.checkSpecialEdition(country: null, year: null, denomination: '5'), isNull);
    });
  });
}
