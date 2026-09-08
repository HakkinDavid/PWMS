import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';

void main() {
  group('NumismaticMatrix & Cascading Inference Tests', () {
    test('Mexico 1982 infers MXP currency, 1980s denominations, and Cuproníquel for 50 Pesos', () {
      final inferredCurr = NumismaticDataHelper.inferCurrency(country: 'México', year: 1982);
      expect(inferredCurr, equals('MXP'));

      final denoms1982 = NumismaticDataHelper.getDenominationsForCountry(country: 'México', year: 1982, currencyCode: 'MXP');
      expect(denoms1982, containsAll(['1', '5', '10', '20', '50', '100', 'Otro']));

      final denoms1988 = NumismaticDataHelper.getDenominationsForCountry(country: 'México', year: 1988, currencyCode: 'MXP');
      expect(denoms1988, containsAll(['50', '100', '500', '1000', '5000', 'Otro']));

      final mat50 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1982, currencyCode: 'MXP', denomination: '50');
      expect(mat50, equals(NumismaticMaterialsRegistry.nameCupronickel));

      final mat20c = NumismaticDataHelper.inferMaterial(country: 'México', year: 1982, currencyCode: 'MXP', denomination: '0.20');
      expect(mat20c, equals(NumismaticMaterialsRegistry.nameBrass));

      final mat100Plata = NumismaticDataHelper.inferMaterial(country: 'México', year: 1978, currencyCode: 'MXP', denomination: '100');
      expect(mat100Plata, equals(NumismaticMaterialsRegistry.nameSilver720));

      final mat100AlBr = NumismaticDataHelper.inferMaterial(country: 'México', year: 1985, currencyCode: 'MXP', denomination: '100');
      expect(mat100AlBr, equals(NumismaticMaterialsRegistry.nameAluminumBronze));
    });

    test('Mexico 1993 infers MXN Nuevos Pesos, bimetallics for standard circulation', () {
      final inferredCurr = NumismaticDataHelper.inferCurrency(country: 'México', year: 1993);
      expect(inferredCurr, equals('MXN'));

      final mat10 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1993, currencyCode: 'MXN', denomination: '10');
      expect(mat10, equals(NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl));

      final mat2 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1993, currencyCode: 'MXN', denomination: '2');
      expect(mat2, equals(NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel));

      final motifs2 = NumismaticDataHelper.getCommemorativeMotifs(country: 'México', year: 1993, currencyCode: 'MXN', denomination: '2');
      expect(motifs2, equals(['Nuevo Peso - Anillo de los Días (Piedra del Sol)']));
    });

    test('Mexico 1947 Centenario infers Oro for 50 Pesos', () {
      final inferredCurr = NumismaticDataHelper.inferCurrency(country: 'México', year: 1947);
      expect(inferredCurr, equals('MXP'));

      final mat50 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1947, currencyCode: 'MXP', denomination: '50');
      expect(mat50, equals(NumismaticMaterialsRegistry.nameGold900));
    });

    test('Virreinato de Nueva España and Colonial Mexico infer Reales (MXR) and Silver', () {
      final currNuevaEspana = NumismaticDataHelper.inferCurrency(country: 'Virreinato de Nueva España', year: 1800);
      expect(currNuevaEspana, equals('MXR'));

      final mat8Reales = NumismaticDataHelper.inferMaterial(country: 'Virreinato de Nueva España', year: 1800, denomination: '8');
      expect(mat8Reales, equals(NumismaticMaterialsRegistry.nameSilverColonial903));

      final mat116 = NumismaticDataHelper.inferMaterial(country: 'Virreinato de Nueva España', year: 1800, denomination: '1/16');
      expect(mat116, equals(NumismaticMaterialsRegistry.nameCopper));
    });

    test('USA Silver vs Clad vs Alloy transitions (1964 vs 1970 vs 1980 vs 1985)', () {
      final curr1964 = NumismaticDataHelper.inferCurrency(country: 'Estados Unidos', year: 1964);
      expect(curr1964, equals('USD'));

      final mat1964Quarter = NumismaticDataHelper.inferMaterial(country: 'Estados Unidos', year: 1964, denomination: '0.25');
      expect(mat1964Quarter, equals(NumismaticMaterialsRegistry.nameSilver900));

      final mat1970Quarter = NumismaticDataHelper.inferMaterial(country: 'Estados Unidos', year: 1970, denomination: '0.25');
      expect(mat1970Quarter, equals(NumismaticMaterialsRegistry.nameCupronickel));

      // US Cent 1980 is Red Brass / Gilding Metal (95% Cu, 5% Zn) -> Bronce
      final mat1980Cent = NumismaticDataHelper.inferMaterial(country: 'Estados Unidos', year: 1980, denomination: '0.01');
      expect(mat1980Cent, equals(NumismaticMaterialsRegistry.nameBronze));

      // US Cent 1985 is Copper-plated Zinc (Zinc bañado en cobre)
      final mat1985Cent = NumismaticDataHelper.inferMaterial(country: 'Estados Unidos', year: 1985, denomination: '0.01');
      expect(mat1985Cent, equals(NumismaticMaterialsRegistry.nameCopperPlatedZinc));
    });

    test('Spain Pesetas vs Euro transition (1975 vs 2005)', () {
      final curr1975 = NumismaticDataHelper.inferCurrency(country: 'España', year: 1975);
      expect(curr1975, equals('ESP'));

      final curr2005 = NumismaticDataHelper.inferCurrency(country: 'España', year: 2005);
      expect(curr2005, equals('EUR'));

      final matEuro1 = NumismaticDataHelper.inferMaterial(country: 'España', year: 2005, denomination: '1');
      expect(matEuro1, equals(NumismaticMaterialsRegistry.nameBimetallicEuro1));
    });

    test('Mexico 1992 transition supports both MXP (old pesos) and MXN (Nuevos Pesos)', () {
      final rules1992 = NumismaticDataHelper.findRules('México', 1992);
      expect(rules1992.length, greaterThanOrEqualTo(2));

      // MXP check (1988-1992)
      final ruleMxp = NumismaticDataHelper.findRule('México', 1992, currencyCode: 'MXP');
      expect(ruleMxp, isNotNull);
      expect(ruleMxp!.validCurrencies, contains('MXP'));
      final matMxp1000 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1992, currencyCode: 'MXP', denomination: '1000');
      expect(matMxp1000, equals(NumismaticMaterialsRegistry.nameAluminumBronze));

      // MXN check (1992-1995 N$)
      final ruleMxn = NumismaticDataHelper.findRule('México', 1992, currencyCode: 'MXN');
      expect(ruleMxn, isNotNull);
      expect(ruleMxn!.validCurrencies, contains('MXN'));
      final matMxn2 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1992, currencyCode: 'MXN', denomination: '2');
      expect(matMxn2, equals(NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel));

      final motifs2 = NumismaticDataHelper.getCommemorativeMotifs(country: 'México', year: 1992, currencyCode: 'MXN', denomination: '2');
      expect(motifs2, equals(['Nuevo Peso - Anillo de los Días (Piedra del Sol)']));
    });

    test('Brasil 2017 1 Real is standard circulation BRL bimetallic and not commemorative', () {
      final curr2017 = NumismaticDataHelper.inferCurrency(country: 'Brasil', year: 2017);
      expect(curr2017, equals('BRL'));

      final mat1Real = NumismaticDataHelper.inferMaterial(country: 'Brasil', year: 2017, denomination: '1');
      expect(mat1Real, equals(NumismaticMaterialsRegistry.nameBimetallicGeneric));
    });

    test('Spain 1999 physical stamped year on Euro coins infers EUR and modern alloys', () {
      final curr1999 = NumismaticDataHelper.inferCurrency(country: 'España', year: 1999);
      expect(curr1999, equals('ESP')); // 1869-2001 Peseta is matched for 1999 in Spain

      final euroRule = NumismaticDataHelper.findRule('Unión Europea', 1999);
      expect(euroRule, isNotNull);
      expect(euroRule!.validCurrencies, contains('EUR'));

      final matEuro2 = NumismaticDataHelper.inferMaterial(country: 'España', year: 2002, denomination: '2');
      expect(matEuro2, equals(NumismaticMaterialsRegistry.nameBimetallicEuro2));
    });

    test('Modern commemorative editions for Mexico, Canada, and Colombia', () {
      // Mexico 2008 Bicentenario 5 Pesos and 2021 20 Pesos
      final motifsMex5 = NumismaticDataHelper.getCommemorativeMotifs(country: 'México', year: 2008, denomination: '5');
      expect(motifsMex5, isNotEmpty);

      final motifsMex20 = NumismaticDataHelper.getCommemorativeMotifs(country: 'México', year: 2021, denomination: '20');
      expect(motifsMex20, isNotEmpty);

      // Canada Loonie (1987+) and Toonie (1996+)
      final matLoonie = NumismaticDataHelper.inferMaterial(country: 'Canadá', year: 2000, denomination: '1');
      expect(matLoonie, equals(NumismaticMaterialsRegistry.nameBrassPlatedSteel));

      final matToonie = NumismaticDataHelper.inferMaterial(country: 'Canadá', year: 2000, denomination: '2');
      expect(matToonie, equals(NumismaticMaterialsRegistry.nameBimetallicToonie));

      // Colombia 500 and 1000 Pesos bimetallics
      final matCol500 = NumismaticDataHelper.inferMaterial(country: 'Colombia', year: 2015, denomination: '500');
      expect(matCol500, equals(NumismaticMaterialsRegistry.nameBimetallicGeneric));

      final matCol1000 = NumismaticDataHelper.inferMaterial(country: 'Colombia', year: 2015, denomination: '1000');
      expect(matCol1000, equals(NumismaticMaterialsRegistry.nameBimetallicGeneric));
    });

    test('Decimal coin denominations (0.1, 0.2, 0.5) match 0.10, 0.20, 0.50 and infer correct materials', () {
      // 10 centavos 1992 N$ (Acero inoxidable)
      final mat10c = NumismaticDataHelper.inferMaterial(country: 'México', year: 1992, currencyCode: 'MXN', denomination: '0.1');
      expect(mat10c, equals('Acero inoxidable'));

      final mat10cFull = NumismaticDataHelper.inferMaterial(country: 'México', year: 1992, currencyCode: 'MXN', denomination: '0.10');
      expect(mat10cFull, equals('Acero inoxidable'));

      // 20 centavos 1992 N$ (Bronce de aluminio)
      final mat20c = NumismaticDataHelper.inferMaterial(country: 'México', year: 1992, currencyCode: 'MXN', denomination: '0.2');
      expect(mat20c, equals('Bronce de aluminio'));

      final mat20cFull = NumismaticDataHelper.inferMaterial(country: 'México', year: 1992, currencyCode: 'MXN', denomination: '0.20');
      expect(mat20cFull, equals('Bronce de aluminio'));

      // 50 centavos 1992 N$ (Bronce de aluminio)
      final mat50c = NumismaticDataHelper.inferMaterial(country: 'México', year: 1992, currencyCode: 'MXN', denomination: '0.5');
      expect(mat50c, equals('Bronce de aluminio'));

      final mat50cFull = NumismaticDataHelper.inferMaterial(country: 'México', year: 1992, currencyCode: 'MXN', denomination: '0.50');
      expect(mat50cFull, equals('Bronce de aluminio'));
    });

    test('Banknote rules (isBanknote: true) correctly infer banknote denominations and materials', () {
      // Mexico Familia G 2020 $100 (Sor Juana) -> Polímero
      final matMex100Note = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 2020,
        currencyCode: 'MXN',
        denomination: '100',
        isBanknote: true,
      );
      expect(matMex100Note, equals('Polímero'));

      // Mexico Familia G 2021 $20 (Bicentenario) -> Polímero
      final matMex20Note = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 2021,
        currencyCode: 'MXN',
        denomination: '20',
        isBanknote: true,
      );
      expect(matMex20Note, equals('Polímero'));

      // Mexico Familia G 2020 $500 (Benito Juárez) -> Papel de algodón
      final matMex500Note = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 2020,
        currencyCode: 'MXN',
        denomination: '500',
        isBanknote: true,
      );
      expect(matMex500Note, equals('Papel de algodón'));

      // Mexico Familia AA 1978 $100 (Hidalgo) -> Papel de algodón
      final matMex1978Note = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 1978,
        currencyCode: 'MXP',
        denomination: '100',
        isBanknote: true,
      );
      expect(matMex1978Note, equals('Papel de algodón'));

      // US 2013 $100 Federal Reserve Note -> Papel de algodón
      final matUs100Note = NumismaticDataHelper.inferMaterial(
        country: 'Estados Unidos',
        year: 2013,
        currencyCode: 'USD',
        denomination: '100',
        isBanknote: true,
      );
      expect(matUs100Note, equals('Papel de algodón'));

      // Euro 2002 500 Euro Note -> Papel de algodón
      final matEuro500Note = NumismaticDataHelper.inferMaterial(
        country: 'España',
        year: 2002,
        currencyCode: 'EUR',
        denomination: '500',
        isBanknote: true,
      );
      expect(matEuro500Note, equals('Papel de algodón'));
    });

    test('Coin vs Banknote rules separation (Mexico 2020)', () {
      // For coins (isBanknote: false), 100 is not a regular circulating denomination
      final coinDenoms = NumismaticDataHelper.getDenominationsForCountry(
        country: 'México',
        year: 2020,
        currencyCode: 'MXN',
        isBanknote: false,
      );
      expect(coinDenoms, containsAll(['0.10', '0.20', '0.50', '1', '2', '5', '10', '20']));
      expect(coinDenoms, isNot(contains('100')));

      // For banknotes (isBanknote: true), 100 is a standard denomination
      final noteDenoms = NumismaticDataHelper.getDenominationsForCountry(
        country: 'México',
        year: 2020,
        currencyCode: 'MXN',
        isBanknote: true,
      );
      expect(noteDenoms, containsAll(['20', '50', '100', '200', '500', '1000']));
    });

    test('Fallback gracefully when country or year is unspecified or unlisted', () {
      expect(NumismaticDataHelper.inferCurrency(country: null, year: 2000), isNull);
      expect(NumismaticDataHelper.inferCurrency(country: 'Otro', year: 2000), isNull);
      expect(NumismaticDataHelper.inferCurrency(country: 'País Desconocido', year: 2000), isNull);

      final denomsFallback = NumismaticDataHelper.getDenominationsForCountry(country: null, year: null);
      expect(denomsFallback, equals(NumismaticDictionary.denominations));

      expect(NumismaticDataHelper.inferMaterial(country: null, year: null, denomination: '5'), isNull);
      expect(NumismaticDataHelper.getCommemorativeMotifs(country: null, year: null, denomination: '5'), isEmpty);
    });

    test('1. USA \$1 2000+ infers Clad Manganese Brass and allows canonical composition', () {
      final inferredMat = NumismaticDataHelper.inferMaterial(
        country: 'Estados Unidos',
        year: 2000,
        currencyCode: 'USD',
        denomination: '1',
      );
      expect(inferredMat, equals(NumismaticMaterialsRegistry.nameCladManganeseBrassCopper));

      final validMats = NumismaticDataHelper.getValidMaterialsForCountry(
        country: 'Estados Unidos',
        year: 2000,
        currencyCode: 'USD',
        denomination: '1',
      );
      expect(validMats, contains(NumismaticMaterialsRegistry.nameCladManganeseBrassCopper));
    });

    test('2. Mexico 100 MXN 2019 Banknote infers Cotton Paper (Familia F) and allows Polymer', () {
      final inferredMat = NumismaticDataHelper.inferMaterial(
        country: 'México',
        year: 2019,
        currencyCode: 'MXN',
        denomination: '100',
        isBanknote: true,
      );
      expect(inferredMat, equals('Papel de algodón'));

      final validMats = NumismaticDataHelper.getValidMaterialsForCountry(
        country: 'México',
        year: 2019,
        currencyCode: 'MXN',
        denomination: '100',
        isBanknote: true,
      );
      expect(validMats, containsAll(['Papel de algodón', 'Polímero']));
    });

    test('3. Mexico 50 MXP 1988 transition year allows both Cuproníquel and Acero inoxidable', () {
      final validMats1988 = NumismaticDataHelper.getValidMaterialsForCountry(
        country: 'México',
        year: 1988,
        currencyCode: 'MXP',
        denomination: '50',
      );
      expect(validMats1988, containsAll([NumismaticMaterialsRegistry.nameCupronickel, NumismaticMaterialsRegistry.nameStainlessSteel]));

      final inferred1987 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1987, currencyCode: 'MXP', denomination: '50');
      expect(inferred1987, equals(NumismaticMaterialsRegistry.nameCupronickel));

      final inferred1989 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1989, currencyCode: 'MXP', denomination: '50');
      expect(inferred1989, equals(NumismaticMaterialsRegistry.nameStainlessSteel));
    });

    test('4. Mexico 20 MXP 1988 and 1989 (Guadalupe Victoria) is in valid denominations and infers Latón', () {
      final denoms1988 = NumismaticDataHelper.getDenominationsForCountry(
        country: 'México',
        year: 1988,
        currencyCode: 'MXP',
      );
      expect(denoms1988, contains('20'));

      final denoms1989 = NumismaticDataHelper.getDenominationsForCountry(
        country: 'México',
        year: 1989,
        currencyCode: 'MXP',
      );
      expect(denoms1989, contains('20'));

      final mat20_1988 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1988, currencyCode: 'MXP', denomination: '20');
      expect(mat20_1988, equals(NumismaticMaterialsRegistry.nameBrass));

      final mat20_1989 = NumismaticDataHelper.inferMaterial(country: 'México', year: 1989, currencyCode: 'MXP', denomination: '20');
      expect(mat20_1989, equals(NumismaticMaterialsRegistry.nameBrass));
    });

    test('5. Commemorative motifs are atomic arrays per denomination without concatenated slashes', () {
      // 1985 Mexico $200
      final motifs1985 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 1985,
        currencyCode: 'MXP',
        denomination: '200',
      );
      expect(motifs1985, containsAll(['175 Aniversario de la Independencia', '75 Aniversario de la Revolución']));
      expect(motifs1985.any((m) => m.contains(' / ')), isFalse);

      // 1986 Mexico $200
      final motifs1986 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 1986,
        currencyCode: 'MXP',
        denomination: '200',
      );
      expect(motifs1986, contains('Copa Mundial de la FIFA México 1986'));
      expect(motifs1986.any((m) => m.contains(' / ')), isFalse);

      // 2008 Mexico $5 (Independencia y Revolución 2008)
      final motifs2008 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2008,
        currencyCode: 'MXN',
        denomination: '5',
      );
      expect(motifs2008, containsAll([
        'Ignacio López Rayón',
        'Francisco Primo de Verdad y Ramos (Con puntos)',
        'Francisco Primo de Verdad y Ramos (Sin puntos - Variedad especial)',
        'Francisco Villa',
        'Álvaro Obregón',
      ]));
      expect(motifs2008, isNot(contains('Miguel Hidalgo y Costilla'))); // Hidalgo was minted in 2010

      // 2010 Mexico $5 (Bicentenario / Centenario 2010)
      final motifs2010 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2010,
        currencyCode: 'MXN',
        denomination: '5',
      );
      expect(motifs2010, containsAll([
        'Miguel Hidalgo y Costilla',
        'José María Morelos y Pavón',
        'Ignacio Allende',
        'Emiliano Zapata',
        'Venustiano Carranza',
      ]));
      expect(motifs2010, isNot(contains('Francisco Villa'))); // Villa was strictly 2008

      // 2021 Mexico $20
      final motifs2021 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2021,
        currencyCode: 'MXN',
        denomination: '20',
      );
      expect(motifs2021, containsAll([
        'Bicentenario de la Independencia Nacional',
        '500 Años de Memoria Histórica de México-Tenochtitlan',
        '700 Años de la Fundación Lunar de la Ciudad de México-Tenochtitlan',
      ]));

      // 2005 Spain 2 Euro
      final motifsSpain2005 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'España',
        year: 2005,
        currencyCode: 'EUR',
        denomination: '2',
      );
      expect(motifsSpain2005, contains('IV Centenario de Don Quijote de la Mancha'));

      // 1972 Germany 10 Mark
      final motifsDem1972 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'Alemania',
        year: 1972,
        currencyCode: 'DEM',
        denomination: '10',
      );
      expect(motifsDem1972, contains('Juegos Olímpicos de Múnich 1972 - Emblema Espiral'));
    });

    test('6. Strict temporal bounding and missing official motifs tests', () {
      // Temporal Bounding: USA 1 Cent Lincoln (2005 vs 2009)
      final lincoln2005 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'Estados Unidos',
        year: 2005,
        currencyCode: 'USD',
        denomination: '0.01',
      );
      expect(lincoln2005, contains('Lincoln Memorial (1959-2008)'));

      final lincoln2009 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'Estados Unidos',
        year: 2009,
        currencyCode: 'USD',
        denomination: '0.01',
      );
      expect(lincoln2009, hasLength(4));
      expect(lincoln2009, containsAll([
        'Lincoln Bicentennial - Birthplace',
        'Lincoln Bicentennial - Formative Years in Indiana',
        'Lincoln Bicentennial - Professional Life in Illinois',
        'Lincoln Bicentennial - Presidency in Washington D.C.',
      ]));

      // Temporal Bounding: Eurozone 2 Euro (2002 vs 2007)
      final euroSpain2002 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'España',
        year: 2002,
        currencyCode: 'EUR',
        denomination: '2',
      );
      expect(euroSpain2002, contains('Efigie del Rey Juan Carlos I / Rey Felipe VI (Circulación Estándar)'));

      final euroSpain2007 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'España',
        year: 2007,
        currencyCode: 'EUR',
        denomination: '2',
      );
      expect(euroSpain2007, contains('50 Aniversario del Tratado de Roma'));

      // USA 50 State Quarters: 2005 25c gives exactly the 5 states of 2005
      final usQuarters2005 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'Estados Unidos',
        year: 2005,
        currencyCode: 'USD',
        denomination: '0.25',
      );
      expect(usQuarters2005, containsAll([
        '50 State Quarters - California',
        '50 State Quarters - Minnesota',
        '50 State Quarters - Oregon',
        '50 State Quarters - Kansas',
        '50 State Quarters - West Virginia',
      ]));
      expect(usQuarters2005, isNot(contains('50 State Quarters - Delaware')));

      // Missing official motifs: Mexico 10 MXN Cambio de Milenio (2000, 2001)
      final mex10_2000 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2000,
        currencyCode: 'MXN',
        denomination: '10',
      );
      expect(mex10_2000, contains('Cambio de Milenio - Glifo Año 2000'));

      final mex10_2001 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2001,
        currencyCode: 'MXN',
        denomination: '10',
      );
      expect(mex10_2001, contains('Cambio de Milenio - Glifo Año 2001'));

      // Missing official motifs: Mexico 10 MXN 150 Aniversario Batalla de Puebla (2012)
      final mex10_2012 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2012,
        currencyCode: 'MXN',
        denomination: '10',
      );
      expect(mex10_2012, contains('150 Aniversario de la Batalla de Puebla - General Ignacio Zaragoza'));

      // Missing official motifs: Mexico N$ 20 & N$ 50 Centro de Plata (1993-1995)
      final mexN20_1993 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 1993,
        currencyCode: 'MXN',
        denomination: '20',
      );
      expect(mexN20_1993, contains('Nuevo Peso - Don Miguel Hidalgo y Costilla (Centro de Plata Sterling .925)'));

      final mexN50_1993 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 1993,
        currencyCode: 'MXN',
        denomination: '50',
      );
      expect(mexN50_1993, contains('Nuevo Peso - Niños Héroes (Centro de Plata Sterling .925)'));

      // Distinct die varieties: Mexico 1968 25 Pesos Type 1 vs Type 2
      final mex25_1968 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 1968,
        currencyCode: 'MXP',
        denomination: '25',
      );
      expect(mex25_1968, containsAll([
        'Juegos Olímpicos México 68 - Tipo 1 (Aros rectos / alineados)',
        'Juegos Olímpicos México 68 - Tipo 2 (Aros caídos / desiguales)',
      ]));

      // 7. Mexico 100 MXN Banknote Centenario de la Constitución Política de 1917 (2016-2017)
      final note100_2016 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2016,
        currencyCode: 'MXN',
        denomination: '100',
        isBanknote: true,
      );
      expect(note100_2016, contains('Centenario de la Constitución Política de 1917'));

      final note100_2017 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2017,
        currencyCode: 'MXN',
        denomination: '100',
        isBanknote: true,
      );
      expect(note100_2017, contains('Centenario de la Constitución Política de 1917'));

      // 8. Mexico 20 MXN Coin Marina-Armada / Fuerza Armada (2021-2022)
      final coin20_2021 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2021,
        currencyCode: 'MXN',
        denomination: '20',
        isBanknote: false,
      );
      expect(coin20_2021, contains('Bicentenario de la Marina-Armada de México (2021-2022)'));

      final coin20_2022 = NumismaticDataHelper.getCommemorativeMotifs(
        country: 'México',
        year: 2022,
        currencyCode: 'MXN',
        denomination: '20',
        isBanknote: false,
      );
      expect(coin20_2022, contains('Bicentenario de la Marina-Armada de México (2021-2022)'));

      // 9. Mexico 20 Centavos Madero (1974-1977 Cuproníquel) & Cabeza Olmeca (1977-1983 Latón)
      final madero1983Materials = NumismaticDataHelper.getValidMaterialsForCountry(
        country: 'México',
        year: 1983,
        currencyCode: 'MXP',
        denomination: '0.20',
      );
      expect(madero1983Materials, contains(NumismaticMaterialsRegistry.nameBrass));

      final madero1974Materials = NumismaticDataHelper.getValidMaterialsForCountry(
        country: 'México',
        year: 1974,
        currencyCode: 'MXP',
        denomination: '0.20',
      );
      expect(madero1974Materials, contains(NumismaticMaterialsRegistry.nameCupronickel));

      final madero1977Materials = NumismaticDataHelper.getValidMaterialsForCountry(
        country: 'México',
        year: 1977,
        currencyCode: 'MXP',
        denomination: '0.20',
      );
      expect(madero1977Materials, containsAll([NumismaticMaterialsRegistry.nameBrass, NumismaticMaterialsRegistry.nameCupronickel]));

      // 10. Robust motif matching
      expect(
        NumismaticEmissionRuleData.matchesMotif(
          'Centenario de la Constitución Política de 1917 (2017)',
          'Centenario de la Constitución Política de 1917',
        ),
        isTrue,
      );
      expect(
        NumismaticEmissionRuleData.matchesMotif(
          'Centenario de la Constitución Política de 1917 (2017)',
          'Centenario de la Constitución Política (2017)',
        ),
        isTrue,
      );
      expect(
        NumismaticEmissionRuleData.matchesMotif(
          'Bicentenario de la Marina-Armada de México (2021-2022)',
          'Bicentenario de la Marina-Armada de México (2021)',
        ),
        isTrue,
      );
      expect(
        NumismaticEmissionRuleData.matchesMotif(
          'Marina-Armada de México / Fuerza Armada (2021)',
          'Fuerza Armada',
        ),
        isTrue,
      );
    });
  });
}
