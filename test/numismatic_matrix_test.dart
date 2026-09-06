import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';

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

    test('Mexico 1992 physical stamped year infers MXN Nuevos Pesos and regime change', () {
      final inferredCurr = NumismaticDataHelper.inferCurrency(country: 'México', year: 1992);
      expect(inferredCurr, isNotNull);
      // Stamped 1992 matches Mexico Nuevos Pesos rule (1992-1995) or 1970-1992 transition
      final rule1992 = NumismaticDataHelper.findRule('México', 1992);
      expect(rule1992, isNotNull);
      expect(rule1992!.minYear <= 1992 && rule1992.maxYear >= 1992, isTrue);

      final mat10 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1994, currencyCode: 'MXN', denomination: '10');
      expect(mat10, equals('Bimetálica'));

      final special50 = NumismaticDataHelper.checkSpecialEdition(country: 'México', year: 1993, currencyCode: 'MXN', denomination: '50');
      expect(special50, isNotNull);
      expect(special50!.isSpecial, isTrue);
      expect(special50.reason, equals('Emisión de cambio de régimen'));
    });

    test('Spain 1999 physical stamped year on Euro coins infers EUR and modern alloys', () {
      final curr1999 = NumismaticDataHelper.inferCurrency(country: 'España', year: 1999);
      expect(curr1999, equals('ESP')); // 1869-2001 Peseta is matched for 1999 in Spain

      final euroRule = NumismaticDataHelper.findRule('Unión Europea', 1999);
      expect(euroRule, isNotNull);
      expect(euroRule!.validCurrencies, contains('EUR'));

      final matEuro2 = NumismaticDataHelper.inferMaterial(country: 'España', year: 2002, denomination: '2');
      expect(matEuro2, equals('Bimetálica'));

      final special2Euro = NumismaticDataHelper.checkSpecialEdition(country: 'España', year: 2005, denomination: '2');
      expect(special2Euro, isNotNull);
      expect(special2Euro!.isSpecial, isTrue);
      expect(special2Euro.reason, equals('Conmemorativa'));
    });

    test('Modern commemorative editions for Mexico, Canada, and Colombia', () {
      // Mexico 2008 Bicentenario 5 Pesos and 2021 20 Pesos
      final specialMex5 = NumismaticDataHelper.checkSpecialEdition(country: 'México', year: 2008, denomination: '5');
      expect(specialMex5, isNotNull);
      expect(specialMex5!.isSpecial, isTrue);

      final specialMex20 = NumismaticDataHelper.checkSpecialEdition(country: 'México', year: 2021, denomination: '20');
      expect(specialMex20, isNotNull);
      expect(specialMex20!.isSpecial, isTrue);

      // Canada Loonie (1987+) and Toonie (1996+)
      final matLoonie = NumismaticDataHelper.inferMaterial(country: 'Canadá', year: 2000, denomination: '1');
      expect(matLoonie, equals('Acero bañado en latón'));

      final matToonie = NumismaticDataHelper.inferMaterial(country: 'Canadá', year: 2000, denomination: '2');
      expect(matToonie, equals('Bimetálica'));

      // Colombia 500 and 1000 Pesos bimetallics
      final matCol500 = NumismaticDataHelper.inferMaterial(country: 'Colombia', year: 2015, denomination: '500');
      expect(matCol500, equals('Bimetálica'));

      final matCol1000 = NumismaticDataHelper.inferMaterial(country: 'Colombia', year: 2015, denomination: '1000');
      expect(matCol1000, equals('Bimetálica'));
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
