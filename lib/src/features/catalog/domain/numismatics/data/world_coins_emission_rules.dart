import '../models/numismatic_models.dart';

/// Historical emission rules for world coins (Guatemala, Colombia, Canadá, Cuba, Argentina, Brasil, Chile, Perú, Reino Unido, Francia, Alemania, Italia).
const List<NumismaticEmissionRuleData> worldCoinsEmissionRules = [
  // 4.1 Guatemala - Época Colonial y Reales Predecimales (1500–1859)
  NumismaticEmissionRuleData(
    country: 'Guatemala',
    minYear: 1500,
    maxYear: 1859,
    validCurrencies: ['REAL', 'ESC', 'GTH_CENT'],
    defaultCurrency: 'REAL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        minYear: 1796,
        maxYear: 1859,
        motifs: [
          NumismaticMotifRule('Cuartillo de Real Plata (Castillo y León / Busto)', 1796, 1859),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1733,
        maxYear: 1859,
        motifs: [
          NumismaticMotifRule('Medio Real Plata Colonial y República del Centro de América', 1733, 1859),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1733,
        maxYear: 1859,
        motifs: [
          NumismaticMotifRule('1 Real de Plata', 1733, 1859),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1733,
        maxYear: 1859,
        motifs: [
          NumismaticMotifRule('2 Reales de Plata', 1733, 1859),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        minYear: 1733,
        maxYear: 1859,
        motifs: [
          NumismaticMotifRule('4 Reales de Plata', 1733, 1859),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1733,
        maxYear: 1859,
        motifs: [
          NumismaticMotifRule('8 Reales de Plata (Columnario / Busto / Volcán del Centro de América)', 1733, 1859),
        ],
      ),
    ],
  ),

  // 4.2 Guatemala - Época del Peso (1860–1924)
  NumismaticEmissionRuleData(
    country: 'Guatemala',
    minYear: 1860,
    maxYear: 1924,
    validCurrencies: ['GTQ_HIST', 'REAL'],
    defaultCurrency: 'GTQ_HIST',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1871,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('1 Centavo de Peso (Cobre / Cuproníquel)', 1871, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Níquel',
        minYear: 1881,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('5 Centavos / Cuarto de Real', 1881, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1860,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('10 Centavos / 1 Real Plata .900/.720', 1860, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Plata',
        minYear: 1860,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('25 Centavos / 2 Reales Plata .900/.720', 1860, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1860,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('50 Centavos / 4 Reales Plata .900/.720', 1860, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1860,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('1 Peso de Plata .900 (Carrera / República de Guatemala)', 1860, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1860,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('2 Pesos Plata', 1860, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        minYear: 1860,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('4 Pesos Plata / Oro', 1860, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1869,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('5 Pesos Oro .900', 1869, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1869,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('10 Pesos Oro .900', 1869, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1869,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('20 Pesos Oro .900', 1869, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        minYear: 1860,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('Cuartillo de Real Plata', 1860, 1924),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1860,
        maxYear: 1924,
        motifs: [
          NumismaticMotifRule('Medio Real Plata', 1860, 1924),
        ],
      ),
    ],
  ),

  // 4.3 Guatemala - Quetzal Clásico de Plata y Oro (1925–1964)
  NumismaticEmissionRuleData(
    country: 'Guatemala',
    minYear: 1925,
    maxYear: 1964,
    validCurrencies: ['GTQ'],
    defaultCurrency: 'GTQ',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.005',
        material: 'Cuproníquel',
        minYear: 1925,
        maxYear: 1949,
        motifs: [
          NumismaticMotifRule('Medio Centavo de Quetzal', 1925, 1949),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1925,
        maxYear: 1964,
        motifs: [
          NumismaticMotifRule('1 Centavo de Quetzal (Fray Bartolomé de las Casas)', 1925, 1964),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Plata',
        minYear: 1925,
        maxYear: 1964,
        motifs: [
          NumismaticMotifRule('5 Centavos Plata .720 (Ceiba / Árbol de la Libertad)', 1925, 1964),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1925,
        maxYear: 1964,
        motifs: [
          NumismaticMotifRule('10 Centavos Plata .720 (Monolito de Quiriguá)', 1925, 1964),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Plata',
        minYear: 1925,
        maxYear: 1964,
        motifs: [
          NumismaticMotifRule('25 Centavos Plata .720 (Mujer Indígena Santiago Atitlán)', 1925, 1964),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1925,
        maxYear: 1964,
        motifs: [
          NumismaticMotifRule('50 Centavos Plata .720 (Monja Blanca)', 1925, 1964),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1925,
        maxYear: 1964,
        motifs: [
          NumismaticMotifRule('1 Quetzal Plata .720 (Quetzal sobre Columna)', 1925, 1964),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1926,
        maxYear: 1926,
        motifs: [
          NumismaticMotifRule('5 Quetzales Oro .900', 1926),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1926,
        maxYear: 1926,
        motifs: [
          NumismaticMotifRule('10 Quetzales Oro .900', 1926),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1926,
        maxYear: 1926,
        motifs: [
          NumismaticMotifRule('20 Quetzales Oro .900', 1926),
        ],
      ),
    ],
  ),

  // 4.4 Guatemala - Quetzal Moderno (1965–presente)
  NumismaticEmissionRuleData(
    country: 'Guatemala',
    minYear: 1965,
    maxYear: 2100,
    validCurrencies: ['GTQ'],
    defaultCurrency: 'GTQ',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Aluminio-Magnesio (Magnalio)',
        minYear: 1965,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('1 Centavo Fray Bartolomé de las Casas', 1965, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1965,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('5 Centavos Árbol de la Libertad (Ceiba)', 1965, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Cuproníquel',
        minYear: 1965,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('10 Centavos Monolito de Quiriguá', 1965, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Cuproníquel',
        minYear: 1965,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('25 Centavos Concepción Ramírez (Mujer Tz\', 1965, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Latón',
        minYear: 1965,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('50 Centavos Monja Blanca (Lycaste skinneri alba)', 1965, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Latón',
        allowedMaterials: ['Latón', 'Bimetálica'],
        minYear: 1996,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('1 Quetzal - Paz Firme y Duradera (1996+)', 1996, 2100),
        ],
      ),
    ],
  ),

  // 5.1 Colombia - Virreinato de Nueva Granada y Reales Predecimales (1500–1846)
  NumismaticEmissionRuleData(
    country: 'Colombia',
    minYear: 1500,
    maxYear: 1846,
    validCurrencies: ['REAL', 'ESC', 'COP_HIST'],
    defaultCurrency: 'REAL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1846,
        motifs: [
          NumismaticMotifRule('Cuartillo de Real Plata Santa Fe de Bogotá / Popayán', 1500, 1846),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1846,
        motifs: [
          NumismaticMotifRule('Medio Real Plata', 1500, 1846),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1846,
        motifs: [
          NumismaticMotifRule('1 Real de Plata', 1500, 1846),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1846,
        motifs: [
          NumismaticMotifRule('2 Reales de Plata', 1500, 1846),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1846,
        motifs: [
          NumismaticMotifRule('4 Reales de Plata', 1500, 1846),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1846,
        motifs: [
          NumismaticMotifRule('8 Reales de Plata (Columnario / Busto / Libertad de la Nueva Granada)', 1500, 1846),
        ],
      ),
    ],
  ),

  // 5.2 Colombia - Peso Histórico y Decimal Antiguo (1847–1904)
  NumismaticEmissionRuleData(
    country: 'Colombia',
    minYear: 1847,
    maxYear: 1904,
    validCurrencies: ['COP_HIST'],
    defaultCurrency: 'COP_HIST',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('1 Centavo Cobre / Bronce', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Cobre',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('2 Centavos Cobre / Cuproníquel', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Plata',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('Medio Décimo / 5 Centavos Plata .666/.835', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('1 Décimo / 10 Centavos Plata .666/.835', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Plata',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('2 Décimos / 20 Centavos Plata .666/.835', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('Medio Peso / 50 Centavos Plata .835/.900', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('1 Peso de Plata .900 (Estados Unidos de Colombia / República de Colombia)', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Oro',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('2 Pesos Oro .900', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('5 Pesos Oro .900', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('10 Pesos Oro .900', 1847, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1847,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('20 Pesos Oro .900 (Doble Cóndor)', 1847, 1904),
        ],
      ),
    ],
  ),

  // 5.3 Colombia - Peso Republicano Clásico (1905–1979)
  NumismaticEmissionRuleData(
    country: 'Colombia',
    minYear: 1905,
    maxYear: 1979,
    validCurrencies: ['COP'],
    defaultCurrency: 'COP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('1 Centavo (Cacique Calarcá / República)', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('2 Centavos (Francisco de Paula Santander)', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('5 Centavos Cuproníquel', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('10 Centavos Plata / Cuproníquel', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Plata',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('20 Centavos Plata / Cuproníquel', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('50 Centavos Plata .500 (Simón Bolívar)', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cuproníquel',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('1 Peso Cuproníquel (Simón Bolívar)', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Cuproníquel',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('2 Pesos Cuproníquel', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('5 Pesos Cuproníquel', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('10 Pesos Oro .900', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1905,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('20 Pesos Oro .900', 1905, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1970,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('50 Pesos Cuproníquel', 1970, 1979),
        ],
      ),
    ],
  ),

  // 5.4 Colombia - Familia Tradicional Árbol de Guacarí (1980–2011)
  NumismaticEmissionRuleData(
    country: 'Colombia',
    minYear: 1980,
    maxYear: 2011,
    validCurrencies: ['COP'],
    defaultCurrency: 'COP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bronce de aluminio',
        minYear: 1980,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('1 Peso Simón Bolívar', 1980, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bronce de aluminio',
        minYear: 1980,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('2 Pesos Simón Bolívar', 1980, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1980,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('5 Pesos Simón Bolívar', 1980, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Cuproníquel',
        minYear: 1980,
        maxYear: 1994,
        motifs: [
          NumismaticMotifRule('10 Pesos Simón Bolívar', 1980, 1994),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Cuproníquel',
        minYear: 1980,
        maxYear: 1994,
        motifs: [
          NumismaticMotifRule('20 Pesos Simón Bolívar', 1980, 1994),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Acero inoxidable',
        minYear: 1989,
        maxYear: 2011,
        motifs: [
          NumismaticMotifRule('50 Pesos Escudo de Colombia', 1989, 2011),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Bronce de aluminio',
        minYear: 1992,
        maxYear: 2011,
        motifs: [
          NumismaticMotifRule('100 Pesos Escudo de Colombia', 1992, 2011),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Cuproníquel',
        minYear: 1994,
        maxYear: 2011,
        motifs: [
          NumismaticMotifRule('200 Pesos Figura Quimbaya', 1994, 2011),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Bimetálica',
        minYear: 1993,
        maxYear: 2011,
        motifs: [
          NumismaticMotifRule('500 Pesos Árbol de Guacarí (Samanea saman)', 1993, 2011),
        ],
      ),
    ],
  ),

  // 5.5 Colombia - Familia Biodiversidad de Colombia (2012–presente)
  NumismaticEmissionRuleData(
    country: 'Colombia',
    minYear: 2012,
    maxYear: 2100,
    validCurrencies: ['COP'],
    defaultCurrency: 'COP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Acero bañado en níquel',
        minYear: 2012,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Oso de Anteojos (Tremarctos ornatus)', 2012, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Bronce de aluminio',
        minYear: 2012,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Frailejón (Espeletia grandiflora)', 2012, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Cuproníquel',
        minYear: 2012,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Guacamaya Bandera (Ara macao)', 2012, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Bimetálica',
        minYear: 2012,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Rana de Cristal (Anura Centrolenidae)', 2012, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Bimetálica',
        minYear: 2012,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Tortuga Caguama (Caretta caretta)', 2012, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Cuproníquel',
        minYear: 2019,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Bicentenario de la Independencia de Colombia', 2019, 2019),
          NumismaticMotifRule('Bicentenario del Sacrificio de Policarpa Salavarrieta', 2022, 2022),
          NumismaticMotifRule('Bicentenario de la Batalla Naval del Lago de Maracaibo', 2023, 2023),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20000',
        material: 'Cuproníquel',
        minYear: 2023,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Bicentenario del Museo Nacional de Colombia', 2023, 2023),
        ],
      ),
    ],
  ),

  // 6.1 Canadá - Época Victoriana, Jorge V y Jorge VI (1858–1952)
  NumismaticEmissionRuleData(
    country: 'Canadá',
    minYear: 1858,
    maxYear: 1952,
    validCurrencies: ['CAD', 'CAD_HIST'],
    defaultCurrency: 'CAD',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1858,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('Large Cent / Small Cent (Hojas de Arce)', 1858, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Níquel',
        allowedMaterials: ['Níquel', 'Plata', 'Latón dorado (Tombac)'],
        minYear: 1858,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('5 Cents Plata / Castor de Níquel / Victory Tombac', 1858, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1858,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('10 Cents Plata .800/.925 (Bluenose Schooner)', 1858, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Plata',
        minYear: 1858,
        maxYear: 1858,
        motifs: [
          NumismaticMotifRule('20 Cents Plata .925 (Victoria)', 1858),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Plata',
        minYear: 1870,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('25 Cents Plata .800/.925 (Caribou / Hojas de Arce)', 1870, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1870,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('50 Cents Plata .800/.925 (Escudo de Canadá)', 1870, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1935,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('Silver Dollar Plata .800 (Voyageur / Jorge V / Jorge VI)', 1935, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1912,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('5 Dollars Oro .900 (Jorge V)', 1912, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1912,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('10 Dollars Oro .900 (Jorge V)', 1912, 1914),
        ],
      ),
    ],
  ),

  // 6.2 Canadá - Era de Plata Isabel II (1953–1967)
  NumismaticEmissionRuleData(
    country: 'Canadá',
    minYear: 1953,
    maxYear: 1967,
    validCurrencies: ['CAD'],
    defaultCurrency: 'CAD',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1953,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('1 Cent Hojas de Arce (Isabel II)', 1953, 1967),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Níquel',
        minYear: 1953,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('5 Cents Beaver Castor (Isabel II)', 1953, 1967),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1953,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('10 Cents Plata .800 Bluenose', 1953, 1967),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Plata',
        minYear: 1953,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('25 Cents Plata .800 Caribou Estándar (1953-1966)', 1953, 1966),
          NumismaticMotifRule('Lince del Centenario de la Confederación', 1967, 1967),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1953,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('50 Cents Plata .800 Escudo de Armas (1953-1966)', 1953, 1966),
          NumismaticMotifRule('Lobo Aullador del Centenario de la Confederación', 1967, 1967),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1953,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('Silver Dollar Plata .800 Voyageur (1953-1966)', 1953, 1966),
          NumismaticMotifRule('Ganso de Canadá del Centenario de la Confederación', 1967, 1967),
        ],
      ),
    ],
  ),

  // 6.3 Canadá - Transición Níquel Puro Pre-Loonie (1968–1986)
  NumismaticEmissionRuleData(
    country: 'Canadá',
    minYear: 1968,
    maxYear: 1986,
    validCurrencies: ['CAD'],
    defaultCurrency: 'CAD',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1968,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule('1 Cent Hojas de Arce', 1968, 1986),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Níquel',
        minYear: 1968,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule('5 Cents Beaver Castor', 1968, 1986),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Níquel',
        minYear: 1968,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule('10 Cents Bluenose', 1968, 1986),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Níquel',
        minYear: 1968,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule('25 Cents Níquel Caribou Estándar (1968-1986)', 1968, 1986),
          NumismaticMotifRule('Centenario de la Policía Montada RCMP', 1973, 1973),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Níquel',
        minYear: 1968,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule('50 Cents Escudo de Armas', 1968, 1986),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Níquel',
        minYear: 1968,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule('1 Dollar Níquel Voyageur Estándar (1968-1986)', 1968, 1986),
          NumismaticMotifRule('Centenario de Manitoba', 1970, 1970),
          NumismaticMotifRule('Centenario de Columbia Británica', 1971, 1971),
          NumismaticMotifRule('Centenario de la Isla del Príncipe Eduardo', 1973, 1973),
          NumismaticMotifRule('Centenario de Winnipeg', 1974, 1974),
          NumismaticMotifRule('Ley Constitucional de Canadá', 1982, 1982),
          NumismaticMotifRule('450 Aniversario del Viaje de Jacques Cartier', 1984, 1984),
        ],
      ),
    ],
  ),

  // 6.4 Canadá - Introducción del Loonie y Toonie (1987–1999)
  NumismaticEmissionRuleData(
    country: 'Canadá',
    minYear: 1987,
    maxYear: 1999,
    validCurrencies: ['CAD'],
    defaultCurrency: 'CAD',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1987,
        maxYear: 1999,
        motifs: [
          NumismaticMotifRule('1 Cent Hojas de Arce', 1987, 1999),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1987,
        maxYear: 1999,
        motifs: [
          NumismaticMotifRule('5 Cents Beaver Castor', 1987, 1999),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Níquel',
        minYear: 1987,
        maxYear: 1999,
        motifs: [
          NumismaticMotifRule('10 Cents Bluenose', 1987, 1999),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Níquel',
        minYear: 1987,
        maxYear: 1999,
        motifs: [
          NumismaticMotifRule('25 Cents Caribou Estándar (1987-1999)', 1987, 1999),
          NumismaticMotifRule('125 Aniversario de la Confederación de Canadá', 1992, 1992),
          NumismaticMotifRule('Millennium Series - 12 Diseños Mensuales', 1999, 1999),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Níquel',
        minYear: 1987,
        maxYear: 1999,
        motifs: [
          NumismaticMotifRule('50 Cents Escudo de Armas', 1987, 1999),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Acero bañado en latón',
        minYear: 1987,
        maxYear: 1999,
        motifs: [
          NumismaticMotifRule('Loonie - Colimbo Común Estándar (1987-1999)', 1987, 1999),
          NumismaticMotifRule('125 Aniversario de Canadá', 1992, 1992),
          NumismaticMotifRule('Monumento Nacional a la Guerra', 1994, 1994),
          NumismaticMotifRule('Mantenimiento de la Paz de la ONU', 1995, 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 1996,
        maxYear: 1999,
        motifs: [
          NumismaticMotifRule('Toonie - Oso Polar Estándar (1996-1999)', 1996, 1999),
          NumismaticMotifRule('Creación del Territorio de Nunavut', 1999, 1999),
        ],
      ),
    ],
  ),

  // 6.5 Canadá - Época Multi-Ply Plated Steel (2000–presente)
  NumismaticEmissionRuleData(
    country: 'Canadá',
    minYear: 2000,
    maxYear: 2100,
    validCurrencies: ['CAD'],
    defaultCurrency: 'CAD',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero bañado en cobre',
        minYear: 2000,
        maxYear: 2012,
        motifs: [
          NumismaticMotifRule('1 Cent Hojas de Arce', 2000, 2012),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero bañado en níquel',
        minYear: 2000,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('5 Cents Beaver Castor', 2000, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero bañado en níquel',
        minYear: 2000,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('10 Cents Bluenose', 2000, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Acero bañado en níquel',
        minYear: 2000,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('25 Cents Caribou Estándar (2000+)', 2000, 2100),
          NumismaticMotifRule('Millennium Series - 12 Diseños', 2000, 2000),
          NumismaticMotifRule('Amapola del Día del Recuerdo', 2004, 2004),
          NumismaticMotifRule('Juegos Olímpicos de Invierno Vancouver 2010 (2007-2010)', 2007, 2010),
          NumismaticMotifRule('Guerra de 1812 (2012-2013)', 2012, 2013),
          NumismaticMotifRule('Canada 150 - Esperanza por un Futuro Verde', 2017, 2017),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Acero bañado en níquel',
        minYear: 2000,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('50 Cents Escudo de Armas', 2000, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Acero bañado en latón',
        minYear: 2000,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Loonie - Colimbo Común Estándar (2000+)', 2000, 2100),
          NumismaticMotifRule('Lucky Loonie (2004, 2008, 2010, 2012, 2014, 2016)', 2004, 2016),
          NumismaticMotifRule('Terry Fox', 2005, 2005),
          NumismaticMotifRule('Centenario de los Montreal Canadiens', 2009, 2009),
          NumismaticMotifRule('Centenario de la Marina Real Canadiense', 2010, 2010),
          NumismaticMotifRule('Canada 150 - Conectando una Nación', 2017, 2017),
          NumismaticMotifRule('Despenalización de la Homosexualidad', 2019, 2019),
          NumismaticMotifRule('Oscar Peterson', 2022, 2022),
          NumismaticMotifRule('Elsie MacGill', 2023, 2023),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 2000,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Toonie - Oso Polar Estándar (2000+)', 2000, 2100),
          NumismaticMotifRule('Camino del Conocimiento', 2000, 2000),
          NumismaticMotifRule('10 Aniversario del Toonie', 2006, 2006),
          NumismaticMotifRule('400 Años de la Ciudad de Quebec', 2008, 2008),
          NumismaticMotifRule('HMS Shannon', 2012, 2012),
          NumismaticMotifRule('Sir John A. Macdonald', 2015, 2015),
          NumismaticMotifRule('Batalla del Atlántico', 2016, 2016),
          NumismaticMotifRule('Canada 150 - Danza de los Espíritus', 2017, 2017),
          NumismaticMotifRule('Armisticio de 1918', 2018, 2018),
          NumismaticMotifRule('75 Aniversario del Día D', 2019, 2019),
          NumismaticMotifRule('75 Aniversario del Fin de la Segunda Guerra Mundial', 2020, 2020),
          NumismaticMotifRule('Descubrimiento de la Insulina', 2021, 2021),
          NumismaticMotifRule('Homenaje a la Reina Isabel II - Anillo Negro', 2022, 2022),
          NumismaticMotifRule('Día Nacional de los Pueblos Indígenas', 2023, 2023),
          NumismaticMotifRule('Centenario de la Real Fuerza Aérea Canadiense', 2024, 2024),
        ],
      ),
    ],
  ),

  // 7.1 Cuba - Primera República (1915–1961)
  NumismaticEmissionRuleData(
    country: 'Cuba',
    minYear: 1915,
    maxYear: 1961,
    validCurrencies: ['CUP'],
    defaultCurrency: 'CUP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cuproníquel',
        minYear: 1915,
        maxYear: 1961,
        motifs: [
          NumismaticMotifRule('1 Centavo Cuproníquel (Estrella Solitaria)', 1915, 1961),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Cuproníquel',
        minYear: 1915,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('2 Centavos Cuproníquel', 1915, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1915,
        maxYear: 1961,
        motifs: [
          NumismaticMotifRule('5 Centavos Cuproníquel', 1915, 1961),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1915,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('10 Centavos Plata .900', 1915, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Plata',
        minYear: 1915,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('20 Centavos Plata .900', 1915, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.40',
        material: 'Plata',
        minYear: 1915,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('40 Centavos Plata .900', 1915, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1915,
        maxYear: 1953,
        motifs: [
          NumismaticMotifRule('1 Peso Plata .900 Estrella Radiante (1915-1939)', 1915, 1939),
          NumismaticMotifRule('Centenario del Natalicio de José Martí', 1953, 1953),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Oro',
        minYear: 1915,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('2 Pesos Oro .900 (José Martí)', 1915, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Oro',
        minYear: 1915,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('4 Pesos Oro .900 (José Martí)', 1915, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1915,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('5 Pesos Oro .900 (José Martí)', 1915, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1915,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('10 Pesos Oro .900 (José Martí)', 1915, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1915,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('20 Pesos Oro .900 (José Martí)', 1915, 1916),
        ],
      ),
    ],
  ),

  // 7.2 Cuba - Período Socialista Pre-CUC (1962–1993)
  NumismaticEmissionRuleData(
    country: 'Cuba',
    minYear: 1962,
    maxYear: 1993,
    validCurrencies: ['CUP'],
    defaultCurrency: 'CUP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Aluminio',
        minYear: 1963,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('1 Centavo Aluminio', 1963, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Aluminio',
        minYear: 1963,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('2 Centavos Aluminio', 1963, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1963,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('5 Centavos Aluminio', 1963, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Aluminio',
        minYear: 1963,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('20 Centavos Aluminio', 1963, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.40',
        material: 'Cuproníquel',
        minYear: 1962,
        maxYear: 1962,
        motifs: [
          NumismaticMotifRule('40 Centavos Cuproníquel', 1962),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cuproníquel',
        minYear: 1962,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('1 Peso Cuproníquel (Patria o Muerte)', 1962, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Cuproníquel',
        minYear: 1990,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('3 Pesos Ernesto Che Guevara - Hasta la Victoria Siempre', 1990, 1993),
        ],
      ),
    ],
  ),

  // 7.3 Cuba - Régimen Dual CUP / CUC (1994–2020)
  NumismaticEmissionRuleData(
    country: 'Cuba',
    minYear: 1994,
    maxYear: 2020,
    validCurrencies: ['CUP', 'CUC'],
    defaultCurrency: 'CUP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Aluminio',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('1 Centavo Aluminio', 1994, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Aluminio',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('2 Centavos Aluminio', 1994, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('5 Centavos Aluminio', 1994, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero bañado en níquel',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('10 Centavos Castillo de la Real Fuerza', 1994, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Cuproníquel',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('25 Centavos Castillo del Morro', 1994, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('50 Centavos Plaza de la Revolución', 1994, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cuproníquel',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('1 Peso José Martí', 1994, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Cuproníquel',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('3 Pesos Ernesto Che Guevara', 1994, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bimetálica',
        minYear: 1994,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('5 Pesos Antonio Maceo - Protesta de Baraguá', 1994, 2020),
        ],
      ),
    ],
  ),

  // 7.4 Cuba - Unificación Monetaria (2021–presente)
  NumismaticEmissionRuleData(
    country: 'Cuba',
    minYear: 2021,
    maxYear: 2100,
    validCurrencies: ['CUP'],
    defaultCurrency: 'CUP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 2021,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('5 Centavos Aluminio', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Acero bañado en latón',
        minYear: 2021,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('20 Centavos Patria o Muerte', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Acero bañado en níquel',
        minYear: 2021,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('1 Peso José Martí', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Acero bañado en níquel',
        minYear: 2021,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('3 Pesos Ernesto Che Guevara', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Acero bañado en latón',
        minYear: 2021,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('5 Pesos Antonio Maceo', 2021, 2100),
        ],
      ),
    ],
  ),

  // 8.1 Argentina - Provincias Unidas del Río de la Plata y Confederación (1813–1880)
  NumismaticEmissionRuleData(
    country: 'Argentina',
    minYear: 1813,
    maxYear: 1880,
    validCurrencies: ['ARM', 'REAL'],
    defaultCurrency: 'ARM',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Cobre',
        minYear: 1813,
        maxYear: 1880,
        motifs: [
          NumismaticMotifRule('Cuartillo de Real Cobre', 1813, 1880),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1813,
        maxYear: 1880,
        motifs: [
          NumismaticMotifRule('Medio Real Plata Primera Moneda Patria (Sol de Mayo / Provincias del Río de la Plata)', 1813, 1880),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1813,
        maxYear: 1880,
        motifs: [
          NumismaticMotifRule('1 Real de Plata', 1813, 1880),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1813,
        maxYear: 1880,
        motifs: [
          NumismaticMotifRule('2 Reales de Plata', 1813, 1880),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        minYear: 1813,
        maxYear: 1880,
        motifs: [
          NumismaticMotifRule('4 Reales de Plata', 1813, 1880),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1813,
        maxYear: 1880,
        motifs: [
          NumismaticMotifRule('8 Reales de Plata Primera Moneda Patria (En Unión y Libertad)', 1813, 1880),
        ],
      ),
    ],
  ),

  // 8.2 Argentina - Peso Moneda Nacional (1881–1969)
  NumismaticEmissionRuleData(
    country: 'Argentina',
    minYear: 1881,
    maxYear: 1969,
    validCurrencies: ['ARM'],
    defaultCurrency: 'ARM',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1881,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('1 Centavo Bronce (Libertad de Oudiné)', 1881, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1881,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('2 Centavos Bronce (Libertad de Oudiné)', 1881, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1881,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('5 Centavos Cuproníquel / Bronce de aluminio', 1881, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Cuproníquel',
        minYear: 1881,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('10 Centavos Cuproníquel / Bronce de aluminio', 1881, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Cuproníquel',
        minYear: 1881,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('20 Centavos Cuproníquel / Bronce de aluminio', 1881, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1881,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('50 Centavos Plata .900 / Cuproníquel', 1881, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1881,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('1 Peso Patacón de Plata .900 / Cuproníquel', 1881, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Cuproníquel',
        minYear: 1940,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('2 Pesos Cuproníquel', 1940, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1881,
        maxYear: 1896,
        motifs: [
          NumismaticMotifRule('5 Pesos Argentino de Oro .900 (Oudiné)', 1881, 1896),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Cuproníquel',
        minYear: 1962,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('10 Pesos General San Martín', 1962, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Cuproníquel',
        minYear: 1962,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('20 Pesos Primera Moneda Patria', 1962, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        material: 'Acero',
        minYear: 1960,
        maxYear: 1960,
        motifs: [
          NumismaticMotifRule('25 Pesos Sesquicentenario de la Revolución de Mayo', 1960),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Acero',
        minYear: 1962,
        maxYear: 1966,
        motifs: [
          NumismaticMotifRule('Centenario de la Reorganización Nacional', 1962, 1962),
          NumismaticMotifRule('Sesquicentenario de la Declaración de la Independencia', 1966, 1966),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Acero',
        minYear: 1966,
        maxYear: 1966,
        motifs: [
          NumismaticMotifRule('100 Pesos Sesquicentenario de la Independencia (Casa de Tucumán)', 1966),
        ],
      ),
    ],
  ),

  // 8.3 Argentina - Peso Ley 18.188 (1970–1983)
  NumismaticEmissionRuleData(
    country: 'Argentina',
    minYear: 1970,
    maxYear: 1983,
    validCurrencies: ['ARL'],
    defaultCurrency: 'ARL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce de aluminio',
        minYear: 1970,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('1 Centavo Ley', 1970, 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce de aluminio',
        minYear: 1970,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('5 Centavos Ley', 1970, 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce de aluminio',
        minYear: 1970,
        maxYear: 1976,
        motifs: [
          NumismaticMotifRule('10 Centavos Ley', 1970, 1976),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce de aluminio',
        minYear: 1970,
        maxYear: 1976,
        motifs: [
          NumismaticMotifRule('20 Centavos Ley', 1970, 1976),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce de aluminio',
        minYear: 1970,
        maxYear: 1976,
        motifs: [
          NumismaticMotifRule('50 Centavos Ley', 1970, 1976),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bronce de aluminio',
        minYear: 1974,
        maxYear: 1976,
        motifs: [
          NumismaticMotifRule('1 Peso San Martín', 1974, 1976),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bronce de aluminio',
        minYear: 1976,
        maxYear: 1977,
        motifs: [
          NumismaticMotifRule('5 Pesos San Martín', 1976, 1977),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Bronce de aluminio',
        minYear: 1976,
        maxYear: 1978,
        motifs: [
          NumismaticMotifRule('10 Pesos San Martín', 1976, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Bronce de aluminio',
        minYear: 1977,
        maxYear: 1978,
        motifs: [
          NumismaticMotifRule('Mundial de Fútbol Argentina 1978 - Estadio José María Minella (1977-1978)', 1977, 1978),
          NumismaticMotifRule('Bicentenario del Natalicio del General José de San Martín', 1978, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Bronce de aluminio',
        minYear: 1977,
        maxYear: 1978,
        motifs: [
          NumismaticMotifRule('Mundial de Fútbol Argentina 1978 - Estadio Ciudad de Mendoza (1977-1978)', 1977, 1978),
          NumismaticMotifRule('Bicentenario del Natalicio del General José de San Martín', 1978, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Bronce de aluminio',
        minYear: 1977,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('Mundial de Fútbol Argentina 1978 - Estadio Monumental (1977-1978)', 1977, 1978),
          NumismaticMotifRule('Bicentenario del Natalicio del General José de San Martín', 1978, 1978),
          NumismaticMotifRule('Centenario de la Campaña del Desierto', 1979, 1979),
        ],
      ),
    ],
  ),

  // 8.4 Argentina - Peso Argentino (1983–1985)
  NumismaticEmissionRuleData(
    country: 'Argentina',
    minYear: 1983,
    maxYear: 1985,
    validCurrencies: ['ARP'],
    defaultCurrency: 'ARP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Aluminio',
        minYear: 1983,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('1 Centavo Aluminio', 1983, 1985),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1983,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('5 Centavos Aluminio', 1983, 1985),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Aluminio',
        minYear: 1983,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('10 Centavos Aluminio', 1983, 1985),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Aluminio',
        minYear: 1983,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('50 Centavos Aluminio', 1983, 1985),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Aluminio',
        minYear: 1984,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('1 Peso Argentino Cabildo', 1984, 1985),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Latón',
        minYear: 1984,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('5 Pesos Argentinos Congreso', 1984, 1985),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Latón',
        minYear: 1984,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('10 Pesos Argentinos Casa de Tucumán', 1984, 1985),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Latón',
        minYear: 1984,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('50 Pesos Argentinos Casa del Acuerdo', 1984, 1985),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Latón',
        minYear: 1985,
        maxYear: 1985,
        motifs: [
          NumismaticMotifRule('100 Pesos Argentinos Cabildo de Jujuy', 1985),
        ],
      ),
    ],
  ),

  // 8.5 Argentina - Austral (1985–1991)
  NumismaticEmissionRuleData(
    country: 'Argentina',
    minYear: 1985,
    maxYear: 1991,
    validCurrencies: ['ARA'],
    defaultCurrency: 'ARA',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.005',
        material: 'Aluminio',
        minYear: 1985,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Medio Centavo Austral Hornero', 1985, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Aluminio',
        minYear: 1985,
        maxYear: 1988,
        motifs: [
          NumismaticMotifRule('1 Centavo Ñandú', 1985, 1988),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1985,
        maxYear: 1988,
        motifs: [
          NumismaticMotifRule('5 Centavos Puma', 1985, 1988),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Aluminio',
        minYear: 1985,
        maxYear: 1988,
        motifs: [
          NumismaticMotifRule('10 Centavos Cóndor', 1985, 1988),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Aluminio',
        minYear: 1985,
        maxYear: 1988,
        motifs: [
          NumismaticMotifRule('50 Centavos Libertad', 1985, 1988),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Aluminio',
        minYear: 1989,
        maxYear: 1989,
        motifs: [
          NumismaticMotifRule('1 Austral Cabildo', 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Aluminio',
        minYear: 1989,
        maxYear: 1989,
        motifs: [
          NumismaticMotifRule('5 Australes Congreso', 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Aluminio',
        minYear: 1989,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('10 Australes Casa de Tucumán', 1989, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1989,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('50 Australes Libertad', 1989, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Cuproníquel',
        minYear: 1989,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('100 Australes Escudo de Armas', 1989, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Cuproníquel',
        minYear: 1990,
        maxYear: 1991,
        motifs: [
          NumismaticMotifRule('500 Australes Escudo de Armas', 1990, 1991),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Cuproníquel',
        minYear: 1990,
        maxYear: 1991,
        motifs: [
          NumismaticMotifRule('1000 Australes Escudo de Armas', 1990, 1991),
        ],
      ),
    ],
  ),

  // 8.6 Argentina - Peso Convertible Series Tradicionales (1992–2016)
  NumismaticEmissionRuleData(
    country: 'Argentina',
    minYear: 1992,
    maxYear: 2016,
    validCurrencies: ['ARS'],
    defaultCurrency: 'ARS',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce de aluminio',
        minYear: 1992,
        maxYear: 2000,
        motifs: [
          NumismaticMotifRule('1 Centavo Laurel', 1992, 2000),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce de aluminio',
        minYear: 1992,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('5 Centavos Sol de Mayo', 1992, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce de aluminio',
        minYear: 1992,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('10 Centavos Escudo de Armas', 1992, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Bronce de aluminio',
        minYear: 1992,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('25 Centavos Cabildo de Buenos Aires', 1992, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce de aluminio',
        minYear: 1992,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('50 Centavos Casa de Tucumán Estándar (1992-2016)', 1992, 2016),
          NumismaticMotifRule('Convención Nacional Constituyente', 1994, 1994),
          NumismaticMotifRule('50 Aniversario de UNICEF', 1994, 1994),
          NumismaticMotifRule('50 Aniversario del Voto Femenino', 1997, 1997),
          NumismaticMotifRule('Mercosur', 1998, 1998),
          NumismaticMotifRule('Centenario del Natalicio de Jorge Luis Borges', 1999, 1999),
          NumismaticMotifRule('Fallecimiento de Eva Perón - 50 Aniversario', 2002, 2002),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 1994,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('1 Peso Sol de Mayo Bimetálica Estándar (1994-2016)', 1994, 2016),
          NumismaticMotifRule('Bicentenario de la Revolución de Mayo - Pucará de Tilcara', 2010, 2010),
          NumismaticMotifRule('Bicentenario de la Revolución de Mayo - El Palmar', 2010, 2010),
          NumismaticMotifRule('Bicentenario de la Revolución de Mayo - Aconcagua', 2010, 2010),
          NumismaticMotifRule('Bicentenario de la Revolución de Mayo - Mar del Plata', 2010, 2010),
          NumismaticMotifRule('Bicentenario de la Revolución de Mayo - Glaciar Perito Moreno', 2010, 2010),
          NumismaticMotifRule('Bicentenario de la Primera Moneda Patria - Asamblea del Año XIII', 2013, 2013),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 2010,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('2 Pesos Sol de Mayo Estándar (2011-2016)', 2011, 2016),
          NumismaticMotifRule('Bicentenario de la Creación de la Bandera Nacional', 2012, 2012),
          NumismaticMotifRule('30 Aniversario de la Guerra de Malvinas', 2012, 2012),
          NumismaticMotifRule('Bicentenario del Combate de San Lorenzo', 2013, 2013),
          NumismaticMotifRule('Centenario del Vuelo de Jorge Newbery', 2014, 2014),
          NumismaticMotifRule('Bicentenario de la Declaración de la Independencia', 2016, 2016),
        ],
      ),
    ],
  ),

  // 8.7 Argentina - Serie "Árboles de la República Argentina" (2017–presente)
  NumismaticEmissionRuleData(
    country: 'Argentina',
    minYear: 2017,
    maxYear: 2100,
    validCurrencies: ['ARS'],
    defaultCurrency: 'ARS',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Acero bañado en cobre',
        minYear: 2017,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Jacarandá (Jacaranda mimosifolia)', 2017, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Acero bañado en latón',
        minYear: 2017,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Palo Borracho (Ceiba speciosa)', 2017, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Acero bañado en níquel',
        minYear: 2017,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Arrayán (Luma apiculata)', 2017, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Alpaca (Plata alemana)',
        minYear: 2018,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Caldén (Prosopis caldenia)', 2018, 2100),
        ],
      ),
    ],
  ),

  // 9.1 Brasil - Período Colonial e Imperial (1500–1941)
  NumismaticEmissionRuleData(
    country: 'Brasil',
    minYear: 1500,
    maxYear: 1941,
    validCurrencies: ['BRS'],
    defaultCurrency: 'BRS',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Cobre',
        minYear: 1868,
        maxYear: 1870,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1868, 1870),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Cobre',
        minYear: 1868,
        maxYear: 1870,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1868, 1870),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '40',
        material: 'Cobre',
        minYear: 1873,
        maxYear: 1889,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1889),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '80',
        material: 'Cobre',
        minYear: 1818,
        maxYear: 1832,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1818, 1832),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Cuproníquel',
        minYear: 1871,
        maxYear: 1940,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1871, 1940),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Cuproníquel',
        minYear: 1871,
        maxYear: 1940,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1871, 1940),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '300',
        material: 'Cuproníquel',
        minYear: 1936,
        maxYear: 1940,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1936, 1940),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '400',
        material: 'Cuproníquel',
        minYear: 1901,
        maxYear: 1940,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1901, 1940),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Plata',
        minYear: 1851,
        maxYear: 1913,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1913),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '640',
        material: 'Plata',
        minYear: 1695,
        maxYear: 1834,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1695, 1834),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '960',
        material: 'Plata',
        minYear: 1810,
        maxYear: 1834,
        motifs: [
          NumismaticMotifRule('Patacão Colonial/Imperial', 1810, 1834),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Plata',
        minYear: 1851,
        maxYear: 1913,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1913),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Plata',
        minYear: 1851,
        maxYear: 1935,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1935),
        ],
      ),
    ],
  ),

  // 9.2 Brasil - Cruzeiro (1942–1985)
  NumismaticEmissionRuleData(
    country: 'Brasil',
    minYear: 1942,
    maxYear: 1985,
    validCurrencies: ['BRB', 'BRC'],
    defaultCurrency: 'BRB',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce de aluminio',
        minYear: 1942,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1942, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce de aluminio',
        minYear: 1942,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1942, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce de aluminio',
        minYear: 1942,
        maxYear: 1979,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1942, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bronce de aluminio',
        minYear: 1942,
        maxYear: 1984,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1942, 1984),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bronce de aluminio',
        minYear: 1942,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1942, 1956),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1972,
        maxYear: 1980,
        motifs: [
          NumismaticMotifRule(
          'Mapa do Brasil e Ramo de Café (1972-1980)',
          1972,
          1980,
          ),
          NumismaticMotifRule('Sesquicentenário da Independência do Brasil', 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Cuproníquel',
        minYear: 1972,
        maxYear: 1984,
        motifs: [
          NumismaticMotifRule(
          'Cana-de-Açúcar e Brasão das Armas (1972-1984)',
          1972,
          1984,
          ),
          NumismaticMotifRule('Sesquicentenário da Independência do Brasil', 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Cuproníquel',
        minYear: 1972,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule(
          'Ramo de Soja e Brasão das Armas (1972-1986)',
          1972,
          1986,
          ),
          NumismaticMotifRule('Sesquicentenário da Independência do Brasil', 1972),
          NumismaticMotifRule('Centenário da Imigração Italiana', 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1981,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1981, 1986),
        ],
      ),
    ],
  ),

  // 9.3 Brasil - Cruzado, Cruzado Novo y Cruzeiro Real (1986–1993)
  NumismaticEmissionRuleData(
    country: 'Brasil',
    minYear: 1986,
    maxYear: 1993,
    validCurrencies: ['BRN', 'BRE', 'BRR'],
    defaultCurrency: 'BRN',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1986, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1986, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1986, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1986, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1986, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1986, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1986, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1986, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Acero inoxidable',
        minYear: 1986,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule(
          'Juscelino Kubitschek e Brasília (1986-1988)',
          1986,
          1993,
          ),
          NumismaticMotifRule('Centenário da Abolição da Escravidão - Lei Áurea', 1988),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Acero inoxidable',
        minYear: 1989,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule(
          'Centenário da República - Efigie da República (1989-1993)',
          1989,
          1993,
          ),
          NumismaticMotifRule('Centenário da Proclamação da República', 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Acero inoxidable',
        minYear: 1992,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1992, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Acero inoxidable',
        minYear: 1992,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1992, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Acero inoxidable',
        minYear: 1993,
        maxYear: 1993,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1993),
        ],
      ),
    ],
  ),

  // 9.4 Brasil - Real 1ª Familia Acero Inoxidable (1994–1997)
  NumismaticEmissionRuleData(
    country: 'Brasil',
    minYear: 1994,
    maxYear: 1997,
    validCurrencies: ['BRL'],
    defaultCurrency: 'BRL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero inoxidable',
        minYear: 1994,
        maxYear: 1997,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1994, 1997),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero inoxidable',
        minYear: 1994,
        maxYear: 1997,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1994, 1997),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero inoxidable',
        minYear: 1994,
        maxYear: 1997,
        motifs: [
          NumismaticMotifRule(
          'Efigie da República (1ª Familia 1994-1997)',
          1994,
          1997,
          ),
          NumismaticMotifRule('FAO - 50 Anos da FAO', 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Acero inoxidable',
        minYear: 1994,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
          'Efigie da República (1ª Familia 1994-1995)',
          1994,
          1995,
          ),
          NumismaticMotifRule('FAO - 50 Anos da FAO', 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Acero inoxidable',
        minYear: 1994,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1994, 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Acero inoxidable',
        minYear: 1994,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
          'Efigie da República (1ª Familia 1994-1995)',
          1994,
          1995,
          ),
          NumismaticMotifRule('30 Anos do Banco Central do Brasil', 1995),
        ],
      ),
    ],
  ),

  // 9.5 Brasil - Real 2ª Familia Bimetálica y Recubrimientos (1998–presente)
  NumismaticEmissionRuleData(
    country: 'Brasil',
    minYear: 1998,
    maxYear: 2100,
    validCurrencies: ['BRL'],
    defaultCurrency: 'BRL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero bañado en cobre',
        minYear: 1998,
        maxYear: 2004,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1998, 2004),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero bañado en cobre',
        minYear: 1998,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1998, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero bañado en bronce',
        minYear: 1998,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1998, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Acero bañado en bronce',
        minYear: 1998,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1998, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        allowedMaterials: ['Cuproníquel', 'Acero inoxidable'],
        minYear: 1998,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1998, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 1998,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule(
          'Efigie da República com Grafismos Marajoaras (2ª Familia 1998+)',
          1998,
          2024,
          ),
          NumismaticMotifRule('50 Aniversario de la Declaración Universal de los Derechos Humanos', 1998),
          NumismaticMotifRule('Centenario de Juscelino Kubitschek', 2002),
          NumismaticMotifRule('40 Aniversario del Banco Central do Brasil', 2005),
          NumismaticMotifRule('Centenario de la Inmigración Japonesa a Brasil', 2008),
          NumismaticMotifRule('Entrega de la Bandera Olímpica - Londres 2012 a Río 2016', 2012),
          NumismaticMotifRule('50 Aniversario del Banco Central do Brasil', 2015),
          NumismaticMotifRule('25 Años del Plano Real', 2019),
          // Jogos Rio 2016
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Atletismo', 2014),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Natación', 2014),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Paratriatlón', 2014),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Golf', 2014),
          // Jogos Rio 2016
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Baloncesto', 2015),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Vela', 2015),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Paracanotaje', 2015),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Rugby', 2015),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Fútbol', 2015),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Voleibol', 2015),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Atletismo Paralímpico', 2015),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Judo', 2015),
          // Jogos Rio 2016
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Boxeo', 2016),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Natación Paralímpica', 2016),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Mascota Olímpica Vinicius', 2016),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos Río 2016 - Mascota Paralímpica Tom', 2016),
        ],
      ),
    ],
  ),

  // 10.1 Chile - Período Colonial y Reales (1500–1850)
  NumismaticEmissionRuleData(
    country: 'Chile',
    minYear: 1500,
    maxYear: 1850,
    validCurrencies: ['CLF', 'REAL', 'ESC'],
    defaultCurrency: 'REAL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        minYear: 1790,
        maxYear: 1808,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1790, 1808),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1773,
        maxYear: 1817,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1773, 1817),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1773,
        maxYear: 1817,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1773, 1817),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1773,
        maxYear: 1817,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1773, 1817),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        minYear: 1773,
        maxYear: 1817,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1773, 1817),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1773,
        maxYear: 1817,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1773, 1817),
        ],
      ),
    ],
  ),

  // 10.2 Chile - Peso Antiguo Decimal (1851–1959)
  NumismaticEmissionRuleData(
    country: 'Chile',
    minYear: 1851,
    maxYear: 1959,
    validCurrencies: ['CLF'],
    defaultCurrency: 'CLF',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.005',
        material: 'Cobre',
        minYear: 1851,
        maxYear: 1853,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1853),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1851,
        maxYear: 1853,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1853),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Cobre',
        minYear: 1851,
        maxYear: 1853,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1853),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1870,
        maxYear: 1942,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1870, 1942),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Cuproníquel',
        minYear: 1870,
        maxYear: 1942,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1870, 1942),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Cuproníquel',
        minYear: 1870,
        maxYear: 1942,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1870, 1942),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1851,
        maxYear: 1888,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1888),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1851,
        maxYear: 1933,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1933),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Oro',
        minYear: 1873,
        maxYear: 1880,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1880),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1851,
        maxYear: 1894,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1894),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1851,
        maxYear: 1894,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1851, 1894),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1926,
        maxYear: 1959,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1926, 1959),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Oro',
        minYear: 1926,
        maxYear: 1959,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1926, 1959),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Oro',
        minYear: 1926,
        maxYear: 1959,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1926, 1959),
        ],
      ),
    ],
  ),

  // 10.3 Chile - Escudo Chileno (1960–1974)
  NumismaticEmissionRuleData(
    country: 'Chile',
    minYear: 1960,
    maxYear: 1974,
    validCurrencies: ['CLE'],
    defaultCurrency: 'CLE',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.005',
        material: 'Aluminio',
        minYear: 1960,
        maxYear: 1962,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1960, 1962),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Aluminio',
        minYear: 1960,
        maxYear: 1971,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1960, 1971),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Aluminio',
        minYear: 1960,
        maxYear: 1971,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1960, 1971),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1960,
        maxYear: 1971,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1960, 1971),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce de aluminio',
        minYear: 1971,
        maxYear: 1972,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce de aluminio',
        minYear: 1971,
        maxYear: 1972,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1971,
        maxYear: 1972,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cuproníquel',
        minYear: 1971,
        maxYear: 1972,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Cuproníquel',
        minYear: 1971,
        maxYear: 1972,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1971,
        maxYear: 1972,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Cuproníquel',
        minYear: 1974,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1974, 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1974,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1974, 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Cuproníquel',
        minYear: 1974,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1974, 1975),
        ],
      ),
    ],
  ),

  // 10.4 Chile - Peso Actual (1975–presente)
  NumismaticEmissionRuleData(
    country: 'Chile',
    minYear: 1975,
    maxYear: 2100,
    validCurrencies: ['CLP'],
    defaultCurrency: 'CLP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Aluminio',
        minYear: 1975,
        maxYear: 2017,
        motifs: [
          NumismaticMotifRule('Bernardo O\', 1975, 2017),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bronce de aluminio',
        allowedMaterials: ['Bronce de aluminio', 'Aluminio-Bronce'],
        minYear: 1976,
        maxYear: 2015,
        motifs: [
          NumismaticMotifRule('Bernardo O\', 1976, 2015),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Bronce de aluminio',
        allowedMaterials: ['Bronce de aluminio', 'Aluminio-Bronce'],
        minYear: 1975,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Bernardo O\'Higgins', 1975, 2024),
          NumismaticMotifRule('Ángel de la Libertad (1976-1990)', 1976, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Bronce de aluminio',
        allowedMaterials: ['Bronce de aluminio', 'Aluminio-Bronce'],
        minYear: 1981,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Bernardo O\', 1981, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Bimetálica',
        allowedMaterials: ['Bimetálica', 'Bronce de aluminio'],
        minYear: 1981,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Pueblos Originarios - Mujer Mapuche', 2001, 2024),
          NumismaticMotifRule('Escudo Nacional de 8 Lados (1981-2000)', 1981, 2000),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Bimetálica',
        minYear: 2000,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Cardenal Raúl Silva Henríquez', 2000, 2024),
        ],
      ),
    ],
  ),

  // 11.1 Perú - Época Colonial y Reales (1500–1862)
  NumismaticEmissionRuleData(
    country: 'Perú',
    minYear: 1500,
    maxYear: 1862,
    validCurrencies: ['PER', 'REAL', 'ESC'],
    defaultCurrency: 'REAL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        minYear: 1794,
        maxYear: 1808,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1794, 1808),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1772,
        maxYear: 1824,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1772, 1824),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1772,
        maxYear: 1824,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1772, 1824),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1772,
        maxYear: 1824,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1772, 1824),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        minYear: 1772,
        maxYear: 1824,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1772, 1824),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1772,
        maxYear: 1824,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1772, 1824),
        ],
      ),
    ],
  ),

  // 11.2 Perú - Sol de Oro (1863–1984)
  NumismaticEmissionRuleData(
    country: 'Perú',
    minYear: 1863,
    maxYear: 1984,
    validCurrencies: ['PEH'],
    defaultCurrency: 'PEH',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1863,
        maxYear: 1949,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1863, 1949),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Cobre',
        minYear: 1863,
        maxYear: 1949,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1863, 1949),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Latón',
        minYear: 1918,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1918, 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Latón',
        minYear: 1918,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1918, 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Latón',
        minYear: 1918,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1918, 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1864,
        maxYear: 1935,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1864, 1935),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Latón', 'Cuproníquel'],
        minYear: 1863,
        maxYear: 1977,
        motifs: [
          NumismaticMotifRule('Libertad Parada (Plata)', 1863, 1969),
          NumismaticMotifRule('Túpac Amaru II (1970-1977)', 1970, 1977),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Oro',
        minYear: 1950,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1950, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Latón',
        minYear: 1970,
        maxYear: 1977,
        motifs: [
          NumismaticMotifRule('Almirante Miguel Grau', 1970, 1977),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Latón',
        minYear: 1977,
        maxYear: 1984,
        motifs: [
          NumismaticMotifRule('Túpac Amaru II', 1977, 1984),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1950,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1950, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Oro',
        minYear: 1950,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1950, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Cuproníquel',
        allowedMaterials: ['Cuproníquel', 'Oro'],
        minYear: 1979,
        maxYear: 1980,
        motifs: [
          NumismaticMotifRule('Centenario de la Guerra del Pacífico', 1979, 1980),
        ],
      ),
    ],
  ),

  // 11.3 Perú - Inti (1985–1990)
  NumismaticEmissionRuleData(
    country: 'Perú',
    minYear: 1985,
    maxYear: 1990,
    validCurrencies: ['PEI'],
    defaultCurrency: 'PEI',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Aluminio',
        minYear: 1985,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1985, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1985,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1985, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Latón',
        minYear: 1985,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1985, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Latón',
        minYear: 1985,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1985, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Latón',
        minYear: 1985,
        maxYear: 1988,
        motifs: [
          NumismaticMotifRule('Gran Almirante Miguel Grau', 1985, 1988),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1985,
        maxYear: 1988,
        motifs: [
          NumismaticMotifRule('Gran Almirante Miguel Grau', 1985, 1988),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Cuproníquel',
        minYear: 1988,
        maxYear: 1989,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1988, 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1989,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('Andrés Avelino Cáceres', 1989, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Cuproníquel',
        minYear: 1989,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('César Vallejo', 1989, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Cuproníquel',
        minYear: 1990,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1990),
        ],
      ),
    ],
  ),

  // 11.4 Perú - Sol Moderno (1991–presente)
  NumismaticEmissionRuleData(
    country: 'Perú',
    minYear: 1991,
    maxYear: 2100,
    validCurrencies: ['PEN'],
    defaultCurrency: 'PEN',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Aluminio',
        minYear: 1991,
        maxYear: 2011,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1991, 2011),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1991,
        maxYear: 2018,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1991, 2018),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Latón',
        minYear: 1991,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1991, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Latón',
        minYear: 1991,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1991, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Alpaca (Plata alemana)',
        minYear: 1991,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1991, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Alpaca (Plata alemana)',
        minYear: 1991,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule(
          'Escudo de Armas y Ramas de Laurel y Roble (Circulación Estándar)',
          1991,
          2024,
          ),
          // Serie Riqueza y Orgullo del Perú (2010-2016)
          NumismaticMotifRule('Tumi de Oro (Lambayeque)', 2010),
          NumismaticMotifRule('Sarcófagos de Karajía (Amazonas)', 2010),
          NumismaticMotifRule('Estela de Raimondi (Áncash)', 2010),
          NumismaticMotifRule('Chullpas de Sillustani (Puno)', 2011),
          NumismaticMotifRule('Monasterio de Santa Catalina (Arequipa)', 2011),
          NumismaticMotifRule('Machu Picchu (Cusco)', 2011),
          NumismaticMotifRule('Gran Pajatén (San Martín)', 2011),
          NumismaticMotifRule('Piedra de Saywite (Apurímac)', 2012),
          NumismaticMotifRule('Fortaleza del Real Felipe (Callao)', 2012),
          NumismaticMotifRule('Templo del Sol - Vilcashuamán (Ayacucho)', 2012),
          NumismaticMotifRule('Kuntur Wasi (Cajamarca)', 2012),
          NumismaticMotifRule('Templo Inca Huaytará (Huancavelica)', 2013),
          NumismaticMotifRule('Complejo Arqueológico de Kotosh (Huánuco)', 2013),
          NumismaticMotifRule('Arte Textil Paracas (Ica)', 2013),
          NumismaticMotifRule('Complejo Arqueológico de Tunanmarca (Junín)', 2013),
          NumismaticMotifRule('Ciudad Sagrada de Caral (Lima)', 2013),
          NumismaticMotifRule('Huaca de la Luna (La Libertad)', 2014),
          NumismaticMotifRule('Antiguo Hotel Palace (Loreto)', 2014),
          NumismaticMotifRule('Catedral de Lima (Lima)', 2014),
          NumismaticMotifRule('Petroglifos de Pusharo (Madre de Dios)', 2015),
          NumismaticMotifRule('Arquitectura Moqueguana (Moquegua)', 2015),
          NumismaticMotifRule('Sitio Arqueológico de Huarautambo (Pasco)', 2015),
          NumismaticMotifRule('Complejo Arqueológico de Cabeza de Vaca (Tumbes)', 2016),
          NumismaticMotifRule('Cerámica Vicús (Piura)', 2016),
          NumismaticMotifRule('Cerámica Shipibo-Konibo (Ucayali)', 2016),
          NumismaticMotifRule('Arco Parabólico de Tacna (Tacna)', 2016),
          // Serie Recursos Naturales del Perú
          NumismaticMotifRule('El Cacao (Theobroma cacao)', 2013),
          NumismaticMotifRule('La Quinua (Chenopodium quinoa)', 2013),
          NumismaticMotifRule('La Anchoveta (Engraulis ringens)', 2013),
          // Casa Nacional de Moneda
          NumismaticMotifRule('Casa Nacional de Moneda - 450 Años', 2015),
          // Serie Fauna Silvestre Amenazada del Perú (2017-2019)
          NumismaticMotifRule('Oso Andino de Anteojos (Tremarctos ornatus)', 2017),
          NumismaticMotifRule('Cocodrilo de Tumbes (Crocodylus acutus)', 2017),
          NumismaticMotifRule('Cóndor Andino (Vultur gryphus)', 2017),
          NumismaticMotifRule('Tapir Andino (Tapirus pinchaque)', 2018),
          NumismaticMotifRule('Pava Aliblanca (Penelope albipennis)', 2018),
          NumismaticMotifRule('Jaguar (Panthera onca)', 2018),
          NumismaticMotifRule('Suri (Rhea pennata)', 2018),
          NumismaticMotifRule('Mono Choro de Cola Amarilla (Lagothrix flavicauda)', 2019),
          NumismaticMotifRule('Gato Andino (Leopardus jacobita)', 2019),
          NumismaticMotifRule('Rana Gigante del Titicaca (Telmatobius culeus)', 2019),
          // Serie Constructores de la República (2020-2022)
          NumismaticMotifRule('Juan Pablo Viscardo y Guzmán', 2020),
          NumismaticMotifRule('Hipólito Unanue', 2020),
          NumismaticMotifRule('Toribio Rodríguez de Mendoza', 2021),
          NumismaticMotifRule('Manuel Lorenzo de Vidaurre', 2021),
          NumismaticMotifRule('Francisco Xavier de Luna Pizarro', 2022),
          NumismaticMotifRule('José Baquíjano y Carrillo', 2022),
          NumismaticMotifRule('José Faustino Sánchez Carrión', 2022),
          // Serie La Mujer en el Proceso de Independencia
          NumismaticMotifRule('Brigida Silva de Ochoa', 2020),
          NumismaticMotifRule('María Parado de Bellido', 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 1994,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Líneas de Nazca - El Colibrí', 1994, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bimetálica',
        minYear: 1994,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Líneas de Nazca - El Ave Fragata', 1994, 2024),
        ],
      ),
    ],
  ),

  // 12.1 Reino Unido - Sistema Pre-Decimal (1500–1970)
  NumismaticEmissionRuleData(
    country: 'Reino Unido',
    minYear: 1500,
    maxYear: 1970,
    validCurrencies: ['GBP_OLD'],
    defaultCurrency: 'GBP_OLD',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Cobre',
        minYear: 1860,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1860, 1956),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Cobre',
        minYear: 1860,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1860, 1967),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cobre',
        minYear: 1860,
        maxYear: 1970,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1860, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Níquel-Latón',
        minYear: 1937,
        maxYear: 1970,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1937, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '6',
        material: 'Cuproníquel',
        minYear: 1947,
        maxYear: 1970,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1947, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1s',
        material: 'Cuproníquel',
        minYear: 1947,
        maxYear: 1970,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1947, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2s',
        material: 'Cuproníquel',
        minYear: 1947,
        maxYear: 1970,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1947, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5s',
        material: 'Cuproníquel',
        minYear: 1947,
        maxYear: 1970,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1947, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5s',
        material: 'Cuproníquel',
        minYear: 1951,
        maxYear: 1965,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1951, 1965),
        ],
      ),
    ],
  ),

  // 12.2 Reino Unido - Sistema Decimal 1ª Fase (1971–2016)
  NumismaticEmissionRuleData(
    country: 'Reino Unido',
    minYear: 1971,
    maxYear: 2016,
    validCurrencies: ['GBP'],
    defaultCurrency: 'GBP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.005',
        material: 'Bronce',
        minYear: 1971,
        maxYear: 1984,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 1984),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero bañado en cobre',
        allowedMaterials: ['Acero bañado en cobre', 'Bronce'],
        minYear: 1971,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Acero bañado en cobre',
        allowedMaterials: ['Acero bañado en cobre', 'Bronce'],
        minYear: 1971,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1971, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero bañado en níquel',
        allowedMaterials: ['Acero bañado en níquel', 'Cuproníquel'],
        minYear: 1968,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1968, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero bañado en níquel',
        allowedMaterials: ['Acero bañado en níquel', 'Cuproníquel'],
        minYear: 1968,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1968, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Cuproníquel',
        minYear: 1982,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1982, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1969,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule(
          'Britannia Sedente con Escudo y Tridente (1969-2008)',
          1969,
          2008,
          ),
          NumismaticMotifRule(
          'Royal Shield of Arms - Sección del Escudo Real (2008-2016)',
          2008,
          2016,
          ),
          NumismaticMotifRule('Ingreso a la Comunidad Económica Europea EEC', 1973),
          NumismaticMotifRule('Presidencia Británica de la CEE (1992-1993)', 1992, 1993),
          NumismaticMotifRule('50 Aniversario del Día D desembarco de Normandía', 1994),
          NumismaticMotifRule('50 Aniversario del NHS Servicio Nacional de Salud', 1998),
          NumismaticMotifRule('25 Años de la CEE', 1998),
          NumismaticMotifRule('150 Aniversario de las Bibliotecas Públicas', 2000),
          NumismaticMotifRule('100 Años de la Fundación de la WSPU Movimiento Sufragista', 2003),
          NumismaticMotifRule('50 Años de la Milla en Cuatro Minutos por Roger Bannister', 2004),
          NumismaticMotifRule('250 Aniversario del Diccionario de Samuel Johnson', 2005),
          NumismaticMotifRule('Bicentenario de Isambard Kingdom Brunel', 2006),
          NumismaticMotifRule('Centenario del Movimiento Scout', 2007),
          NumismaticMotifRule('250 Aniversario de los Jardines Botánicos Reales de Kew', 2009),
          NumismaticMotifRule('Juegos Olímpicos y Paralímpicos de Londres 2012 - 29 Deportes', 2011),
          NumismaticMotifRule('Centenario de Benjamin Britten', 2013),
          NumismaticMotifRule('Centenario del Inicio de la Primera Guerra Mundial', 2014),
          NumismaticMotifRule('75 Aniversario de la Batalla de Inglaterra', 2015),
          NumismaticMotifRule('950 Aniversario de la Batalla de Hastings', 2016),
          NumismaticMotifRule('Serie Beatrix Potter - Peter Rabbit', 2016),
          NumismaticMotifRule('Serie Beatrix Potter - Jemima Puddle-Duck', 2016),
          NumismaticMotifRule('Serie Beatrix Potter - Squirrel Nutkin', 2016),
          NumismaticMotifRule('Serie Beatrix Potter - Mrs. Tiggy-Winkle', 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Níquel-Latón',
        minYear: 1983,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule(
          'Royal Arms - Escudo Real de Armas del Reino Unido (1983, 1993, 2003, 2008)',
          1983,
          2016,
          ),
          NumismaticMotifRule('Puentes del Reino Unido (2004-2007)', 2004, 2007),
          NumismaticMotifRule('Ciudades Capitales Británicas (2010-2011)', 2010, 2011),
          NumismaticMotifRule('Flora Heráldica Británica (2013-2014)', 2013, 2014),
          NumismaticMotifRule('Última Emisión Redonda - The Last Round Pound', 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 1997,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule(
          'Desarrollo de la Tecnología - Anillos de la Historia Industrial (1997-2015)',
          1997,
          2015,
          ),
          NumismaticMotifRule('Rugby World Cup', 1999),
          NumismaticMotifRule('Centenario de la Radio Transatlántica de Marconi', 2001),
          NumismaticMotifRule('Commonwealth Games Manchester', 2002),
          NumismaticMotifRule('50 Aniversario del Descubrimiento del ADN', 2003),
          NumismaticMotifRule('200 Años de la Locomotora de Vapor de Trevithick', 2004),
          NumismaticMotifRule('400 Años de la Conspiración de la Pólvora', 2005),
          NumismaticMotifRule('60 Aniversario del Fin de la Segunda Guerra Mundial', 2005),
          NumismaticMotifRule('Bicentenario de Isambard Kingdom Brunel', 2006),
          NumismaticMotifRule('Bicentenario de la Abolición del Comercio de Esclavos', 2007),
          NumismaticMotifRule('Tercentenario del Acta de Unión', 2007),
          NumismaticMotifRule('Centenario de los Juegos Olímpicos de Londres 1908', 2008),
          NumismaticMotifRule('Bicentenario de Charles Darwin', 2009),
          NumismaticMotifRule('250 Aniversario del Nacimiento de Robert Burns', 2009),
          NumismaticMotifRule('Centenario de Florence Nightingale', 2010),
          NumismaticMotifRule('400 Aniversario de la Biblia del Rey Jacobo', 2011),
          NumismaticMotifRule('Bicentenario de Charles Dickens', 2012),
          NumismaticMotifRule('150 Años del Metro de Londres', 2013),
          NumismaticMotifRule('350 Aniversario de la Guinea de Oro', 2013),
          NumismaticMotifRule('Centenario de la Primera Guerra Mundial - Tu País te Necesita', 2014),
          NumismaticMotifRule('800 Aniversario de la Carta Magna', 2015),
          NumismaticMotifRule('400 Aniversario de William Shakespeare', 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1990,
        maxYear: 2016,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1990, 2016),
        ],
      ),
    ],
  ),

  // 12.3 Reino Unido - Sistema Decimal 2ª Fase Dodecagonal (2017–presente)
  NumismaticEmissionRuleData(
    country: 'Reino Unido',
    minYear: 2017,
    maxYear: 2100,
    validCurrencies: ['GBP'],
    defaultCurrency: 'GBP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero bañado en cobre',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 2017, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Acero bañado en cobre',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 2017, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero bañado en níquel',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 2017, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero bañado en níquel',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 2017, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Cuproníquel',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 2017, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule(
          'Royal Shield of Arms - Sección del Escudo Real (2017-2022)',
          2017,
          2022,
          ),
          NumismaticMotifRule(
          'Salmón del Atlántico - Rey Carlos III (2023+)',
          2023,
          2100,
          ),
          NumismaticMotifRule('Sir Isaac Newton', 2017),
          NumismaticMotifRule('Centenario de la Ley de Representación Popular', 2018),
          NumismaticMotifRule('Stephen Hawking', 2019),
          NumismaticMotifRule('Salida del Reino Unido de la Unión Europea - Brexit', 2020),
          NumismaticMotifRule('Dinosaurios de la Colección del Museo de Historia Natural - Megalosaurus', 2020),
          NumismaticMotifRule('50 Aniversario del Orgullo Gay - Pride UK', 2022),
          NumismaticMotifRule('Homenaje a la Reina Isabel II', 2022),
          NumismaticMotifRule('Coronación del Rey Carlos III', 2023),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule(
          'Nations of the Crown - Rosa, Puerro, Cardo y Trébol (2017-2022)',
          2017,
          2022,
          ),
          NumismaticMotifRule(
          'Flora y Fauna Británica - Abejas de Carlos III (2023+)',
          2023,
          2100,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule(
          'Britannia con Escudo y Tridente por Antony Dufort (2015-2022)',
          2017,
          2022,
          ),
          NumismaticMotifRule(
          'Corona de Flora Nacional - Rey Carlos III (2023+)',
          2023,
          2100,
          ),
          NumismaticMotifRule('Jane Austen', 2017),
          NumismaticMotifRule('Centenario de la RAF Royal Air Force', 2018),
          NumismaticMotifRule('75 Aniversario del Día D', 2019),
          NumismaticMotifRule('100 Años de Agatha Christie', 2020),
          NumismaticMotifRule('75 Aniversario de la Victoria en Europa VE Day', 2020),
          NumismaticMotifRule('Alexander Graham Bell', 2022),
          NumismaticMotifRule('J.R.R. Tolkien', 2023),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 2017,
        maxYear: 2024,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 2017, 2024),
        ],
      ),
    ],
  ),

  // 13.1 Francia - Ancien Régime (1500–1794)
  NumismaticEmissionRuleData(
    country: 'Francia',
    minYear: 1500,
    maxYear: 1794,
    validCurrencies: ['LVT', 'ECU', 'LDO'],
    defaultCurrency: 'LVT',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/12',
        material: 'Cobre',
        minYear: 1655,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1655, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/6',
        material: 'Cobre',
        minYear: 1655,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1655, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Cobre',
        minYear: 1655,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1655, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1641,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1641, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1641,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1641, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Oro',
        minYear: 1640,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1640, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Plata',
        minYear: 1640,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1640, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '6',
        material: 'Plata',
        minYear: 1640,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1640, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '12',
        material: 'Oro',
        minYear: 1640,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1640, 1793),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '24',
        material: 'Oro',
        minYear: 1640,
        maxYear: 1793,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1640, 1793),
        ],
      ),
    ],
  ),

  // 13.2 Francia - Franc Ancien (1795–1959)
  NumismaticEmissionRuleData(
    country: 'Francia',
    minYear: 1795,
    maxYear: 1959,
    validCurrencies: ['FRF'],
    defaultCurrency: 'FRF',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1795,
        maxYear: 1920,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1795, 1920),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1795,
        maxYear: 1920,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1795, 1920),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1945,
        maxYear: 1959,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1945, 1959),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Aluminio',
        minYear: 1945,
        maxYear: 1959,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1945, 1959),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Aluminio',
        minYear: 1945,
        maxYear: 1946,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1945, 1946),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Cuproníquel',
        minYear: 1903,
        maxYear: 1940,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1903, 1940),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Aluminio-Bronce',
        minYear: 1920,
        maxYear: 1958,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1920, 1958),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Aluminio-Bronce',
        minYear: 1920,
        maxYear: 1958,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1920, 1958),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Aluminio-Bronce',
        minYear: 1920,
        maxYear: 1958,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1920, 1958),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1933,
        maxYear: 1952,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1933, 1952),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Plata',
        minYear: 1929,
        maxYear: 1939,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1929, 1939),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Plata',
        minYear: 1929,
        maxYear: 1939,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1929, 1939),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1950,
        maxYear: 1958,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1950, 1958),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Cuproníquel',
        minYear: 1954,
        maxYear: 1958,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1954, 1958),
        ],
      ),
    ],
  ),

  // 13.3 Francia - Nouveau Franc (1960–2001)
  NumismaticEmissionRuleData(
    country: 'Francia',
    minYear: 1960,
    maxYear: 2001,
    validCurrencies: ['FRF'],
    defaultCurrency: 'FRF',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero inoxidable',
        minYear: 1960,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Épi d\', 1960, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce de aluminio',
        minYear: 1965,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Marianne de Lagriffoul', 1965, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce de aluminio',
        minYear: 1962,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Marianne de Lagriffoul', 1962, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce de aluminio',
        minYear: 1962,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Marianne de Lagriffoul', 1962, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Níquel',
        minYear: 1965,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Semeuse de Roty', 1965, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Níquel',
        minYear: 1960,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Semeuse de Roty', 1960, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Níquel',
        minYear: 1979,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Semeuse de Roty', 1979, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        allowedMaterials: ['Cuproníquel', 'Plata'],
        minYear: 1960,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Semeuse de Roty', 1960, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Bimetálica',
        minYear: 1988,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule(
          'Génie de la Bastille / Génie de la Liberté (1988-2001)',
          1988,
          2001,
          ),
          NumismaticMotifRule('Jean Monnet', 1988),
          NumismaticMotifRule('Bicentenario de la Revolución Francesa', 1989),
          NumismaticMotifRule('Centenario de la Torre Eiffel', 1989),
          NumismaticMotifRule('Guglielmo Marconi', 1992),
          NumismaticMotifRule('Mont Saint-Michel', 1992),
          NumismaticMotifRule('Gaston Phébus', 1994),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Trimetálica',
        minYear: 1992,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule(
          'Le Mont-Saint-Michel (1992-2001)',
          1992,
          2001,
          ),
          NumismaticMotifRule('Juegos Olímpicos de Albertville 1992 - Pierre de Coubertin', 1992),
          NumismaticMotifRule('Juegos del Mediterráneo', 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Plata',
        minYear: 1974,
        maxYear: 1980,
        motifs: [
          NumismaticMotifRule('Hercule de Dupré (1974-1980)', 1974, 1980),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Plata',
        minYear: 1984,
        maxYear: 1998,
        motifs: [
          NumismaticMotifRule(
          'Panthéon de París (1984-1998)',
          1984,
          1998,
          ),
          NumismaticMotifRule('Marie Curie', 1984),
          NumismaticMotifRule('Émile Zola', 1985),
          NumismaticMotifRule('Estatua de la Libertad', 1986),
          NumismaticMotifRule('La Fayette', 1987),
          NumismaticMotifRule('Fraternité', 1988),
          NumismaticMotifRule('Droits de l\'Homme', 1989),
          NumismaticMotifRule('Charlemagne', 1990),
          NumismaticMotifRule('René Descartes', 1991),
          NumismaticMotifRule('Jean Monnet', 1992),
          NumismaticMotifRule('Liberté par Louvre', 1993),
          NumismaticMotifRule('André Malraux', 1996),
          NumismaticMotifRule('Clovis', 1996),
          NumismaticMotifRule('Paul Cézanne', 1998),
        ],
      ),
    ],
  ),

  // 14.1 Alemania - Imperio Alemán Goldmark (1873–1923)
  NumismaticEmissionRuleData(
    country: 'Alemania',
    minYear: 1873,
    maxYear: 1923,
    validCurrencies: ['FRG', 'PRM'],
    defaultCurrency: 'FRG',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1873,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Cobre',
        minYear: 1873,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1873,
        maxYear: 1915,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1915),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Cuproníquel',
        minYear: 1873,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Cuproníquel',
        minYear: 1873,
        maxYear: 1877,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1877),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Níquel',
        minYear: 1909,
        maxYear: 1912,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1909, 1912),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1873,
        maxYear: 1919,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1919),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1873,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1873,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Plata',
        minYear: 1908,
        maxYear: 1918,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1908, 1918),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1874,
        maxYear: 1915,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1874, 1915),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1873,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1873,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1873, 1914),
        ],
      ),
    ],
  ),

  // 14.2 Alemania - República de Weimar y Reichsmark (1924–1947)
  NumismaticEmissionRuleData(
    country: 'Alemania',
    minYear: 1924,
    maxYear: 1947,
    validCurrencies: ['RKM', 'RTM'],
    defaultCurrency: 'RKM',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1923,
        maxYear: 1948,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1923, 1948),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1923,
        maxYear: 1940,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1923, 1940),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.04',
        material: 'Bronce',
        minYear: 1932,
        maxYear: 1932,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1932),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce de aluminio',
        minYear: 1923,
        maxYear: 1944,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1923, 1944),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce de aluminio',
        minYear: 1923,
        maxYear: 1945,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1923, 1945),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce de aluminio',
        minYear: 1927,
        maxYear: 1939,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1927, 1939),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Níquel',
        minYear: 1924,
        maxYear: 1939,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1924, 1939),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1925,
        maxYear: 1939,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1925, 1939),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Plata',
        minYear: 1924,
        maxYear: 1933,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1924, 1933),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1927,
        maxYear: 1939,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1927, 1939),
        ],
      ),
    ],
  ),

  // 14.3 Alemania - Deutsche Mark 1ª Era (1948–1974)
  NumismaticEmissionRuleData(
    country: 'Alemania',
    minYear: 1948,
    maxYear: 1974,
    validCurrencies: ['DEM', 'DDM'],
    defaultCurrency: 'DEM',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero bañado en cobre',
        minYear: 1948,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1948, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1950,
        maxYear: 1968,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1950, 1968),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero bañado en latón',
        minYear: 1949,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1949, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero bañado en latón',
        minYear: 1949,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1949, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1949,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1949, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cuproníquel',
        minYear: 1950,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1950, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Cuproníquel',
        minYear: 1951,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1951, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1951,
        maxYear: 1974,
        motifs: [
          NumismaticMotifRule(
          'Bundesadler - Águila Federal Alemana (Silberadler 1951-1974)',
          1951,
          1974,
          ),
          NumismaticMotifRule('Centenario del Germanisches Nationalmuseum', 1952),
          NumismaticMotifRule('150 Aniversario del Fallecimiento de Friedrich von Schiller', 1955),
          NumismaticMotifRule('300 Aniversario del Natalicio de Ludwig Wilhelm von Baden', 1955),
          NumismaticMotifRule('Centenario del Fallecimiento de Joseph von Eichendorff', 1957),
          NumismaticMotifRule('150 Aniversario del Natalicio de Johann Gottlieb Fichte', 1964),
          NumismaticMotifRule('250 Aniversario del Fallecimiento de Gottfried Wilhelm Leibniz', 1966),
          NumismaticMotifRule('Centenario de Wilhelm Conrad Röntgen', 1967),
          NumismaticMotifRule('Centenario del Fallecimiento de Wilhelm von Humboldt', 1967),
          NumismaticMotifRule('150 Aniversario del Natalicio de Karl Marx', 1968),
          NumismaticMotifRule('500 Aniversario del Fallecimiento de Johannes Gutenberg', 1968),
          NumismaticMotifRule('150 Aniversario del Natalicio de Friedrich Wilhelm Raiffeisen', 1968),
          NumismaticMotifRule('Centenario de la Fundación del Reichstag', 1971),
          NumismaticMotifRule('500 Aniversario del Natalicio de Alberto Durero', 1971),
          NumismaticMotifRule('500 Aniversario del Natalicio de Nicolás Copérnico', 1973),
          NumismaticMotifRule('125 Aniversario de la Asamblea Nacional de Frankfurt en Paulskirche', 1973),
          NumismaticMotifRule('25 Años de la Ley Fundamental de la RFA', 1974),
          NumismaticMotifRule('250 Aniversario del Natalicio de Immanuel Kant', 1974),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Plata',
        minYear: 1972,
        maxYear: 1972,
        motifs: [
          NumismaticMotifRule('Juegos Olímpicos de Múnich 1972 - Emblema Espiral', 1972),
          NumismaticMotifRule('Juegos Olímpicos de Múnich 1972 - Rayos de Luz', 1972),
          NumismaticMotifRule('Juegos Olímpicos de Múnich 1972 - Pareja de Atletas', 1972),
          NumismaticMotifRule('Juegos Olímpicos de Múnich 1972 - Instalaciones Deportivas Estadio Olímpico', 1972),
          NumismaticMotifRule('Juegos Olímpicos de Múnich 1972 - Bucle conmemorativo', 1972),
        ],
      ),
    ],
  ),

  // 14.4 Alemania - Deutsche Mark 2ª Era Magnimat (1975–2001)
  NumismaticEmissionRuleData(
    country: 'Alemania',
    minYear: 1975,
    maxYear: 2001,
    validCurrencies: ['DEM'],
    defaultCurrency: 'DEM',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero bañado en cobre',
        minYear: 1975,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1975, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Acero bañado en cobre',
        minYear: 1975,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1975, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero bañado en latón',
        minYear: 1975,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1975, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero bañado en latón',
        minYear: 1975,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1975, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1975,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1975, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cuproníquel',
        minYear: 1975,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1975, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Cuproníquel',
        minYear: 1975,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1975, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1975,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1975, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Plata',
        minYear: 1987,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule(
          'Bundesadler - Águila Federal Alemana (Circulación Estándar)',
          1987,
          2001,
          ),
          NumismaticMotifRule('750 Años de Berlín', 1987),
          NumismaticMotifRule('Bicentenario del Natalicio de Arthur Schopenhauer', 1988),
          NumismaticMotifRule('Centenario del Fallecimiento de Carl Zeiss', 1988),
          NumismaticMotifRule('40 Años de la República Federal de Alemania', 1989),
          NumismaticMotifRule('2000 Años de Bonn', 1989),
          NumismaticMotifRule('800 Años del Puerto de Hamburgo', 1989),
          NumismaticMotifRule('800 Años de la Orden Teutónica', 1990),
          NumismaticMotifRule('200 Aniversario de la Puerta de Brandeburgo', 1991),
          NumismaticMotifRule('125 Aniversario del Natalicio de Käthe Kollwitz', 1992),
          NumismaticMotifRule('150 Aniversario de la Orden Pour le Mérite', 1992),
          NumismaticMotifRule('1000 Años de Potsdam', 1993),
          NumismaticMotifRule('150 Aniversario del Natalicio de Robert Koch', 1993),
          NumismaticMotifRule('50 Aniversario del Levantamiento del 20 de Julio de 1944', 1994),
          NumismaticMotifRule('250 Aniversario del Natalicio de Johann Gottfried Herder', 1994),
          NumismaticMotifRule('Centenario del Descubrimiento de los Rayos X', 1995),
          NumismaticMotifRule('150 Aniversario del Descubrimiento de Neptuno por Johann Gottfried Galle', 1996),
          NumismaticMotifRule('500 Aniversario del Reformador Philipp Melanchthon', 1997),
          NumismaticMotifRule('Centenario del Motor Diesel', 1997),
          NumismaticMotifRule('350 Años de la Paz de Westfalia', 1998),
          NumismaticMotifRule('50 Años del Deutsche Mark', 1998),
          NumismaticMotifRule('900 Aniversario del Natalicio de Hildegarda de Bingen', 1998),
          NumismaticMotifRule('50 Años de la Ley Fundamental', 1999),
          NumismaticMotifRule('250 Aniversario del Natalicio de Johann Wolfgang von Goethe', 1999),
          NumismaticMotifRule('Exposición Universal Expo 2000 Hannover', 2000),
          NumismaticMotifRule('250 Aniversario del Fallecimiento de Johann Sebastian Bach', 2000),
          NumismaticMotifRule('10 Años de la Unidad Alemana', 2000),
          NumismaticMotifRule('50 Años del Tribunal Constitucional Federal', 2001),
        ],
      ),
    ],
  ),

  // 15.1 Italia - Reino de Italia (1861–1945)
  NumismaticEmissionRuleData(
    country: 'Italia',
    minYear: 1861,
    maxYear: 1945,
    validCurrencies: ['ITL'],
    defaultCurrency: 'ITL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1861,
        maxYear: 1918,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1861, 1918),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1861,
        maxYear: 1918,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1861, 1918),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce',
        minYear: 1861,
        maxYear: 1943,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1861, 1943),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce',
        minYear: 1862,
        maxYear: 1943,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1862, 1943),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Níquel',
        minYear: 1894,
        maxYear: 1943,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1894, 1943),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Níquel',
        minYear: 1861,
        maxYear: 1943,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1861, 1943),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Acero inoxidable',
        minYear: 1861,
        maxYear: 1943,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1861, 1943),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Acero inoxidable',
        minYear: 1861,
        maxYear: 1943,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1861, 1943),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1861,
        maxYear: 1941,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1861, 1941),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Plata',
        minYear: 1926,
        maxYear: 1936,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1926, 1936),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Plata',
        minYear: 1927,
        maxYear: 1936,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1927, 1936),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Oro',
        minYear: 1864,
        maxYear: 1936,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1864, 1936),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Oro',
        minYear: 1864,
        maxYear: 1937,
        motifs: [
          NumismaticMotifRule('Circulación Estándar', 1864, 1937),
        ],
      ),
    ],
  ),

  // 15.2 Italia - República Italiana 1ª Era Caravelle de Plata (1946–1981)
  NumismaticEmissionRuleData(
    country: 'Italia',
    minYear: 1946,
    maxYear: 1981,
    validCurrencies: ['ITL'],
    defaultCurrency: 'ITL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Aluminio',
        minYear: 1946,
        maxYear: 1959,
        motifs: [
          NumismaticMotifRule('Italina / Cornucopia', 1946, 1959),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Aluminio',
        minYear: 1946,
        maxYear: 1959,
        motifs: [
          NumismaticMotifRule('Spiga / Olivo', 1946, 1959),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Aluminio',
        minYear: 1946,
        maxYear: 1998,
        motifs: [
          NumismaticMotifRule('Timone / Delfino', 1946, 1998),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Aluminio',
        minYear: 1946,
        maxYear: 1998,
        motifs: [
          NumismaticMotifRule('Spighe / Aratro', 1946, 1998),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Bronce de aluminio',
        minYear: 1956,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Quercia', 1956, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Acero inoxidable',
        minYear: 1954,
        maxYear: 1989,
        motifs: [
          NumismaticMotifRule('Vulcano', 1954, 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Acero inoxidable',
        minYear: 1954,
        maxYear: 1989,
        motifs: [
          NumismaticMotifRule('Minerva', 1954, 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Bronce de aluminio',
        minYear: 1977,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Ingranaggio', 1977, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Plata',
        minYear: 1958,
        maxYear: 1981,
        motifs: [
          NumismaticMotifRule('Le Caravelle di Cristoforo Colombo (1958-1967)', 1958, 1967),
          NumismaticMotifRule('Centenario de la Unificación de Italia - Proclama del Reino de Italia', 1961),
          NumismaticMotifRule('Centenario del Nacimiento de Dante Alighieri', 1965),
          NumismaticMotifRule('Centenario del Nacimiento de Guglielmo Marconi', 1974),
          NumismaticMotifRule('Bimilenario de Virgilio', 1981),
        ],
      ),
    ],
  ),

  // 15.3 Italia - República Italiana 2ª Era Bimetálicas (1982–2001)
  NumismaticEmissionRuleData(
    country: 'Italia',
    minYear: 1982,
    maxYear: 2001,
    validCurrencies: ['ITL'],
    defaultCurrency: 'ITL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Aluminio',
        minYear: 1982,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Italina / Cornucopia', 1982, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Aluminio',
        minYear: 1982,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Spiga / Olivo', 1982, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Aluminio',
        minYear: 1982,
        maxYear: 1998,
        motifs: [
          NumismaticMotifRule('Timone / Delfino', 1982, 1998),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Aluminio',
        minYear: 1982,
        maxYear: 1998,
        motifs: [
          NumismaticMotifRule('Spighe / Aratro', 1982, 1998),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Bronce de aluminio',
        minYear: 1982,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Quercia', 1982, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Acero inoxidable',
        minYear: 1990,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Vulcano Micro', 1990, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Acero inoxidable',
        minYear: 1990,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Minerva Micro', 1990, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Bronce de aluminio',
        minYear: 1982,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule(
          'Ingranaggio - Engranaje Industrial (1977-2001)',
          1982,
          2001,
          ),
          NumismaticMotifRule('Centenario de la Aeronautica Militare', 1993),
          NumismaticMotifRule('Centenario del Nacimiento de Maria Montessori', 1990),
          NumismaticMotifRule('70 Aniversario de la Guardia di Finanza', 1996),
          NumismaticMotifRule('50 Aniversario de la Declaración Universal de los Derechos Humanos', 1998),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Bimetálica',
        minYear: 1982,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule(
          'Piazza del Quirinale y Valor en Braille (1982-2001)',
          1982,
          2001,
          ),
          NumismaticMotifRule('Centenario del Banco de Italia', 1993),
          NumismaticMotifRule('Centenario de Luca Pacioli', 1994),
          NumismaticMotifRule('70 Aniversario del ISTAT', 1996),
          NumismaticMotifRule('50 Aniversario de la Policía de Tráfico Polizia Stradale', 1997),
          NumismaticMotifRule('Centenario de la Federación Italiana de Fútbol FIGC', 1998),
          NumismaticMotifRule('20 Años del IFAD', 1998),
          NumismaticMotifRule('Elecciones al Parlamento Europeo', 1999),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Bimetálica',
        minYear: 1997,
        maxYear: 1998,
        motifs: [
          NumismaticMotifRule('Mapa de la Unión Europea con Fronteras Erróneas', 1997),
          NumismaticMotifRule('Mapa de la Unión Europea con Fronteras Corregidas (1997-1998)', 1997, 1998),
        ],
      ),
    ],
  ),
];
