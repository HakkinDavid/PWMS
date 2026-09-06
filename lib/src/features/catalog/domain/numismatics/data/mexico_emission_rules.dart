import '../models/numismatic_emission_rule_data.dart';
import '../models/numismatic_motif_rule.dart';

/// Historical emission rules for Mexico and colonial predecessors (Virreinato, Primer y Segundo Imperio, República, Monedas y Billetes modernos).
const List<NumismaticEmissionRuleData> mexicoEmissionRules = [
  // 1.1 Virreinato de Nueva España (1536–1821)
  NumismaticEmissionRuleData(
    country: 'Virreinato de Nueva España',
    minYear: 1536,
    maxYear: 1821,
    validCurrencies: ['MXR', 'REAL', 'MXE', 'ESC', 'MRV'],
    defaultCurrency: 'MXR',
    denominations: ['1/16', '1/8', '1/4', '1/2', '1', '2', '4', '8'],
    denominationMaterials: {
      '1/16': 'Cobre',
      '1/8': 'Cobre',
      '1/4': 'Plata',
      '1/2': 'Plata',
      '1': 'Plata',
      '2': 'Plata',
      '4': 'Plata',
      '8': 'Plata',
    },
    denominationAllowedMaterials: {
      '1/4': ['Plata', 'Cobre'],
    },
  ),

  // 1.2 Primer Imperio Mexicano - Agustín de Iturbide (1822–1823)
  NumismaticEmissionRuleData(
    country: 'Imperio Mexicano (Primer y Segundo Imperio)',
    minYear: 1822,
    maxYear: 1823,
    validCurrencies: ['MXR', 'MXE'],
    defaultCurrency: 'MXR',
    denominations: ['1/8', '1/4', '1/2', '1', '2', '4', '8'],
    denominationMaterials: {
      '1/8': 'Cobre',
      '1/4': 'Cobre',
      '1/2': 'Plata',
      '1': 'Plata',
      '2': 'Plata',
      '4': 'Oro',
      '8': 'Plata',
    },
    denominationAllowedMaterials: {
      '4': ['Oro', 'Plata'],
      '8': ['Plata', 'Oro'],
    },
  ),

  // 1.3 Segundo Imperio Mexicano - Cobres Provisionales (1864–1865)
  NumismaticEmissionRuleData(
    country: 'Imperio Mexicano (Primer y Segundo Imperio)',
    minYear: 1864,
    maxYear: 1865,
    validCurrencies: ['MXP', 'MXR'],
    defaultCurrency: 'MXP',
    denominations: ['0.01'],
    denominationMaterials: {
      '0.01': 'Cobre',
    },
  ),

  // 1.4 Segundo Imperio Mexicano - Serie Decimal Maximiliano (1866–1867)
  NumismaticEmissionRuleData(
    country: 'Imperio Mexicano (Primer y Segundo Imperio)',
    minYear: 1866,
    maxYear: 1867,
    validCurrencies: ['MXP', 'MXR'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.05', '0.10', '0.50', '1', '20'],
    denominationMaterials: {
      '0.01': 'Cobre',
      '0.05': 'Plata',
      '0.10': 'Plata',
      '0.50': 'Plata',
      '1': 'Plata',
      '20': 'Oro',
    },
  ),

  // 1.5 México - Período Virreinal novohispano (1536–1821)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1536,
    maxYear: 1821,
    validCurrencies: ['MXR', 'MXE', 'REAL', 'ESC'],
    defaultCurrency: 'MXR',
    denominations: ['1/16', '1/8', '1/4', '1/2', '1', '2', '4', '8'],
    denominationMaterials: {
      '1/16': 'Cobre',
      '1/8': 'Cobre',
      '1/4': 'Plata',
      '1/2': 'Plata',
      '1': 'Plata',
      '2': 'Plata',
      '4': 'Plata',
      '8': 'Plata',
    },
    denominationAllowedMaterials: {
      '1/4': ['Plata', 'Cobre'],
    },
  ),

  // 1.6 México - Primer Imperio (1822–1823)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1822,
    maxYear: 1823,
    validCurrencies: ['MXR', 'MXE'],
    defaultCurrency: 'MXR',
    denominations: ['1/8', '1/4', '1/2', '1', '2', '4', '8'],
    denominationMaterials: {
      '1/8': 'Cobre',
      '1/4': 'Cobre',
      '1/2': 'Plata',
      '1': 'Plata',
      '2': 'Plata',
      '4': 'Oro',
      '8': 'Plata',
    },
    denominationAllowedMaterials: {
      '4': ['Oro', 'Plata'],
      '8': ['Plata', 'Oro'],
    },
  ),

  // 1.7 México - Primera República y República Centralista (1823–1863)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1823,
    maxYear: 1863,
    validCurrencies: ['MXR', 'MXE'],
    defaultCurrency: 'MXR',
    denominations: ['1/16', '1/8', '1/4', '1/2', '1', '2', '4', '8'],
    denominationMaterials: {
      '1/16': 'Cobre',
      '1/8': 'Cobre',
      '1/4': 'Cobre',
      '1/2': 'Plata',
      '1': 'Plata',
      '2': 'Plata',
      '4': 'Plata',
      '8': 'Plata',
    },
    denominationAllowedMaterials: {
      '1/4': ['Cobre', 'Plata'],
    },
  ),

  // 1.8 México - Segundo Imperio Cobres (1864–1865)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1864,
    maxYear: 1865,
    validCurrencies: ['MXP', 'MXR'],
    defaultCurrency: 'MXP',
    denominations: ['0.01'],
    denominationMaterials: {
      '0.01': 'Cobre',
    },
  ),

  // 1.9 México - Segundo Imperio Serie Maximiliano Decimal (1866–1867)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1866,
    maxYear: 1867,
    validCurrencies: ['MXP', 'MXR'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.05', '0.10', '0.50', '1', '20'],
    denominationMaterials: {
      '0.01': 'Cobre',
      '0.05': 'Plata',
      '0.10': 'Plata',
      '0.50': 'Plata',
      '1': 'Plata',
      '20': 'Oro',
    },
  ),

  // 1.10 México - República Restaurada Sistema Balanza Decimal (1868–1881)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1868,
    maxYear: 1881,
    validCurrencies: ['MXP', 'MXE', 'MXR'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.02', '0.05', '0.10', '0.25', '0.50', '1', '2.5', '5', '10', '20', '8'],
    denominationMaterials: {
      '0.01': 'Cobre',
      '0.02': 'Cobre',
      '0.05': 'Plata',
      '0.10': 'Plata',
      '0.25': 'Plata',
      '0.50': 'Plata',
      '1': 'Plata',
      '2.5': 'Oro',
      '5': 'Oro',
      '10': 'Oro',
      '20': 'Oro',
      '8': 'Plata',
    },
  ),

  // 1.11 México - Crisis del Níquel (1882–1883)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1882,
    maxYear: 1883,
    validCurrencies: ['MXP', 'MXE', 'MXR'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.02', '0.05', '0.10', '0.25', '0.50', '1', '2.5', '5', '10', '20', '8'],
    denominationMaterials: {
      '0.01': 'Níquel',
      '0.02': 'Níquel',
      '0.05': 'Níquel',
      '0.10': 'Plata',
      '0.25': 'Plata',
      '0.50': 'Plata',
      '1': 'Plata',
      '2.5': 'Oro',
      '5': 'Oro',
      '10': 'Oro',
      '20': 'Oro',
      '8': 'Plata',
    },
    denominationAllowedMaterials: {
      '0.01': ['Níquel', 'Cuproníquel'],
      '0.02': ['Níquel', 'Cuproníquel'],
      '0.05': ['Níquel', 'Cuproníquel'],
    },
  ),

  // 1.12 México - Porfiriato Decimal Resplandor (1884–1904)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1884,
    maxYear: 1904,
    validCurrencies: ['MXP', 'MXE', 'MXR'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '2.5', '5', '10', '20', '8'],
    denominationMaterials: {
      '0.01': 'Cobre',
      '0.02': 'Cobre',
      '0.05': 'Plata',
      '0.10': 'Plata',
      '0.20': 'Plata',
      '0.25': 'Plata',
      '0.50': 'Plata',
      '1': 'Plata',
      '2.5': 'Oro',
      '5': 'Oro',
      '10': 'Oro',
      '20': 'Oro',
      '8': 'Plata',
    },
  ),

  // 1.13 México - Reforma Monetaria Porfiriana de 1905 (1905–1914)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1905,
    maxYear: 1914,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '5', '10'],
    denominationMaterials: {
      '0.01': 'Bronce',
      '0.02': 'Bronce',
      '0.05': 'Cuproníquel',
      '0.10': 'Plata',
      '0.20': 'Plata',
      '0.50': 'Plata',
      '1': 'Plata',
      '5': 'Oro',
      '10': 'Oro',
    },
    commemorativeMotifsByDenomination: {
      '1': [
        NumismaticMotifRule('Un Peso Caballito - Centenario de la Independencia (1910-1914)', 1910, 1914),
      ],
    },
    commemorativeReasons: [
      'Un Peso Caballito - Centenario de la Independencia (1910-1914)',
    ],
  ),

  // 1.14 México - Período Revolucionario / Constitucionalista (1915–1919)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1915,
    maxYear: 1919,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '2.5', '5', '10', '20'],
    denominationMaterials: {
      '0.01': 'Bronce',
      '0.02': 'Bronce',
      '0.05': 'Bronce',
      '0.10': 'Plata',
      '0.20': 'Plata',
      '0.50': 'Plata',
      '1': 'Plata',
      '2': 'Oro',
      '2.5': 'Oro',
      '5': 'Oro',
      '10': 'Oro',
      '20': 'Oro',
    },
  ),

  // 1.15 México - Ley .720 y Centenario de Oro (1920–1942)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1920,
    maxYear: 1942,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.02', '0.05', '0.10', '0.20', '0.50', '1', '2', '2.5', '5', '10', '20', '50'],
    denominationMaterials: {
      '0.01': 'Bronce',
      '0.02': 'Bronce',
      '0.05': 'Cuproníquel',
      '0.10': 'Plata',
      '0.20': 'Plata',
      '0.50': 'Plata',
      '1': 'Plata',
      '2': 'Oro',
      '2.5': 'Oro',
      '5': 'Oro',
      '10': 'Oro',
      '20': 'Oro',
      '50': 'Oro',
    },
    commemorativeDenominations: {'2'},
    commemorativeMotifsByDenomination: {
      '2': [
        NumismaticMotifRule('Victoria Alada - Centenario de la Consumación de la Independencia (1921)', 1921),
      ],
      '50': [
        NumismaticMotifRule('Centenario de la Consumación de la Independencia - 50 Pesos Oro (1921-1931)', 1921, 1931),
      ],
    },
    commemorativeReasons: [
      'Centenario de la Consumación de la Independencia (1921)',
    ],
  ),

  // 1.16 México - Segunda Guerra y Postguerra (1943–1949)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1943,
    maxYear: 1949,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.05', '0.20', '0.50', '1', '2', '2.5', '5', '50'],
    denominationMaterials: {
      '0.01': 'Bronce',
      '0.05': 'Bronce',
      '0.20': 'Bronce',
      '0.50': 'Plata',
      '1': 'Plata',
      '2': 'Oro',
      '2.5': 'Oro',
      '5': 'Plata',
      '50': 'Oro',
    },
    commemorativeMotifsByDenomination: {
      '5': [
        NumismaticMotifRule('Cuauhtémoc (1947-1948)', 1947, 1948),
      ],
    },
    commemorativeReasons: [
      'Cuauhtémoc Plata Ley .900 (1947-1948)',
    ],
  ),

  // 1.17 México - Década de 1950 (1950–1956)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1950,
    maxYear: 1956,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.05', '0.10', '0.20', '0.25', '0.50', '1', '5', '10'],
    denominationMaterials: {
      '0.01': 'Bronce',
      '0.05': 'Latón',
      '0.10': 'Latón',
      '0.20': 'Bronce',
      '0.25': 'Cuproníquel',
      '0.50': 'Bronce',
      '1': 'Plata',
      '5': 'Plata',
      '10': 'Plata',
    },
    commemorativeMotifsByDenomination: {
      '5': [
        NumismaticMotifRule('Inauguración del Ferrocarril del Sureste (1950)', 1950),
        NumismaticMotifRule('Hidalgo - Laurel (1951-1954)', 1951, 1954),
        NumismaticMotifRule('Año de Hidalgo - Bicentenario del Natalicio de Miguel Hidalgo (1953)', 1953),
      ],
    },
    commemorativeReasons: [
      'Inauguración del Ferrocarril del Sureste (1950)',
      'Año de Hidalgo - Bicentenario del Natalicio de Miguel Hidalgo (1953)',
    ],
  ),

  // 1.18 México - Período de los Tepalcates y Conmemorativas (1957–1969)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1957,
    maxYear: 1969,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['0.01', '0.05', '0.10', '0.20', '0.50', '1', '5', '10', '25'],
    denominationMaterials: {
      '0.01': 'Bronce',
      '0.05': 'Latón',
      '0.10': 'Latón',
      '0.20': 'Bronce',
      '0.50': 'Cuproníquel',
      '1': 'Plata',
      '5': 'Plata',
      '10': 'Plata',
      '25': 'Plata',
    },
    commemorativeDenominations: {'25'},
    commemorativeMotifsByDenomination: {
      '1': [
        NumismaticMotifRule('Centenario de la Constitución de 1857 (1957)', 1957),
      ],
      '5': [
        NumismaticMotifRule('Centenario de la Constitución de 1857 (1957)', 1957),
      ],
      '10': [
        NumismaticMotifRule('Centenario de la Constitución de 1857 (1957)', 1957),
        NumismaticMotifRule('150 Aniversario de la Independencia y 50 de la Revolución (1960)', 1960),
      ],
      '25': [
        NumismaticMotifRule('Juegos Olímpicos México 68 - Tipo 1 (Aros rectos / alineados)', 1968),
        NumismaticMotifRule('Juegos Olímpicos México 68 - Tipo 2 (Aros caídos / desiguales)', 1968),
      ],
    },
    commemorativeReasons: [
      'Centenario de la Constitución de 1857 (1957)',
      '150 Aniversario de la Independencia y 50 de la Revolución (1960)',
      'Juegos Olímpicos México 68 (1968)',
    ],
  ),

  // 1.19 México - Transición Pirámide de Bronce y Monedas de Cuproníquel (1970–1973)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1970,
    maxYear: 1973,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['0.05', '0.20', '0.50', '1', '5'],
    denominationMaterials: {
      '0.05': 'Latón',
      '0.20': 'Bronce',
      '0.50': 'Cuproníquel',
      '1': 'Cuproníquel',
      '5': 'Cuproníquel',
    },
  ),

  // 1.20 México - Serie Numismática Cuproníquel, Latón y Plata (1974–1983)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1974,
    maxYear: 1983,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['0.05', '0.10', '0.20', '0.50', '1', '5', '10', '20', '50', '100'],
    denominationMaterials: {
      '0.05': 'Latón',
      '0.10': 'Cuproníquel',
      '0.20': 'Latón',
      '0.50': 'Cuproníquel',
      '1': 'Cuproníquel',
      '5': 'Cuproníquel',
      '10': 'Cuproníquel',
      '20': 'Cuproníquel',
      '50': 'Cuproníquel',
      '100': 'Plata',
    },
    denominationAllowedMaterials: {
      '0.20': ['Latón', 'Cuproníquel'],
    },
    commemorativeDenominations: {'100'},
    commemorativeMotifsByDenomination: {
      '50': [
        NumismaticMotifRule('Coyolxauhqui - Templo Mayor (1982-1984)', 1982, 1984),
      ],
      '100': [
        NumismaticMotifRule('José María Morelos Plata Ley .720 (1977-1979)', 1977, 1979),
      ],
    },
    commemorativeReasons: [
      'Morelos Plata Ley .720 (1977-1979)',
    ],
  ),

  // 1.21 México - Acero Inoxidable, Latón y Valores Medios (1984–1987)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1984,
    maxYear: 1987,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['1', '5', '10', '20', '50', '100', '200', '500'],
    denominationMaterials: {
      '1': 'Acero inoxidable',
      '5': 'Latón',
      '10': 'Acero inoxidable',
      '20': 'Latón',
      '50': 'Cuproníquel',
      '100': 'Bronce de aluminio',
      '200': 'Cuproníquel',
      '500': 'Cuproníquel',
    },
    commemorativeDenominations: {'200'},
    commemorativeMotifsByDenomination: {
      '200': [
        NumismaticMotifRule('175 Aniversario de la Independencia', 1985),
        NumismaticMotifRule('75 Aniversario de la Revolución', 1985),
        NumismaticMotifRule('Copa Mundial de la FIFA México 1986', 1986),
      ],
    },
    commemorativeReasons: [
      '175 Aniversario de la Independencia',
      '75 Aniversario de la Revolución',
      'Copa Mundial de la FIFA México 1986',
    ],
  ),

  // 1.22 México - Grandes Valores de Inflación Pre-N$ (1988–1992)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1988,
    maxYear: 1992,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    denominations: ['10', '20', '50', '100', '500', '1000', '5000'],
    denominationMaterials: {
      '10': 'Acero inoxidable',
      '20': 'Latón',
      '50': 'Acero inoxidable',
      '100': 'Bronce de aluminio',
      '500': 'Cuproníquel',
      '1000': 'Bronce de aluminio',
      '5000': 'Cuproníquel',
    },
    denominationAllowedMaterials: {
      '50': ['Cuproníquel', 'Acero inoxidable'],
    },
    commemorativeDenominations: {'5000'},
    commemorativeMotifsByDenomination: {
      '5000': [
        NumismaticMotifRule('Cincuentenario de la Expropiación Petrolera (1988)', 1988),
      ],
    },
    commemorativeReasons: [
      'Cincuentenario de la Expropiación Petrolera (1988)',
    ],
  ),

  // 1.23 México - Nuevos Pesos (N$ grabados físicamente 1992–1995)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1992,
    maxYear: 1995,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    denominations: ['0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '50'],
    denominationMaterials: {
      '0.05': 'Acero inoxidable',
      '0.10': 'Acero inoxidable',
      '0.20': 'Bronce de aluminio',
      '0.50': 'Bronce de aluminio',
      '1': 'Bimetálica',
      '2': 'Bimetálica',
      '5': 'Bimetálica',
      '10': 'Bimetálica',
      '20': 'Bimetálica',
      '50': 'Bimetálica',
    },
    commemorativeDenominations: {'10', '20', '50'},
    commemorativeMotifsByDenomination: {
      '10': [
        NumismaticMotifRule('Nuevo Peso - Piedra del Sol (Centro de Plata Sterling .925)', 1992, 1995),
      ],
      '20': [
        NumismaticMotifRule('Nuevo Peso - Don Miguel Hidalgo y Costilla (Centro de Plata Sterling .925)', 1993, 1995),
      ],
      '50': [
        NumismaticMotifRule('Nuevo Peso - Niños Héroes (Centro de Plata Sterling .925)', 1993, 1995),
      ],
    },
    commemorativeReasons: [
      'Nuevo Peso',
      'Don Miguel Hidalgo y Costilla (1993-1995)',
      'Niños Héroes (1993-1995)',
    ],
  ),

  // 1.24 México - Familia C Primer Período (1996–2007)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1996,
    maxYear: 2007,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    denominations: ['0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20', '100'],
    denominationMaterials: {
      '0.05': 'Acero inoxidable',
      '0.10': 'Acero inoxidable',
      '0.20': 'Bronce de aluminio',
      '0.50': 'Bronce de aluminio',
      '1': 'Bimetálica',
      '2': 'Bimetálica',
      '5': 'Bimetálica',
      '10': 'Bimetálica',
      '20': 'Bimetálica',
      '100': 'Bimetálica',
    },
    commemorativeDenominations: {'20', '100'},
    commemorativeMotifsByDenomination: {
      '10': [
        NumismaticMotifRule('Cambio de Milenio - Glifo Año 2000 (2000)', 2000),
        NumismaticMotifRule('Cambio de Milenio - Glifo Año 2001 (2001)', 2001),
      ],
      '20': [
        NumismaticMotifRule('Octavio Paz - Cambio de Milenio (2000)', 2000, 2001),
        NumismaticMotifRule('Fuego Nuevo - Señorío de Xiuhtecuhtli (2000)', 2000, 2001),
      ],
      '100': [
        NumismaticMotifRule('32 Estados de la República - Fase 1 (Heráldicos)', 2003, 2005),
        NumismaticMotifRule('32 Estados de la República - Fase 2 (Emblemáticos)', 2005, 2007),
        NumismaticMotifRule('180 Aniversario de la Unión Federal (2004)', 2004),
        NumismaticMotifRule('470 Aniversario de la Casa de Moneda de México (2005)', 2005),
        NumismaticMotifRule('80 Aniversario del Banco de México (2005)', 2005),
        NumismaticMotifRule('400 Aniversario de la Primera Edición de Don Quijote de la Mancha (2005)', 2005),
        NumismaticMotifRule('Bicentenario del Natalicio de Benito Juárez (2006)', 2006),
      ],
    },
    commemorativeReasons: [
      'Cambio de Milenio (2000-2001)',
      'Octavio Paz - Cambio de Milenio',
      'Fuego Nuevo - Señorío de Xiuhtecuhtli',
      '32 Estados de la República',
      '470 Aniversario de la Casa de Moneda de México',
      '80 Aniversario del Banco de México',
      '400 Aniversario de Don Quijote de la Mancha',
      'Bicentenario del Natalicio de Benito Juárez',
      '180 Aniversario de la Unión Federal',
    ],
  ),

  // 1.25 México - Familia C Bicentenario y Centenario (2008–2010)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2008,
    maxYear: 2010,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    denominations: ['0.05', '0.10', '0.20', '0.50', '1', '2', '5', '10', '20'],
    denominationMaterials: {
      '0.05': 'Acero inoxidable',
      '0.10': 'Acero inoxidable',
      '0.20': 'Bronce de aluminio',
      '0.50': 'Bronce de aluminio',
      '1': 'Bimetálica',
      '2': 'Bimetálica',
      '5': 'Bimetálica',
      '10': 'Bimetálica',
      '20': 'Bimetálica',
    },
    commemorativeDenominations: {'5', '20'},
    commemorativeMotifsByDenomination: {
      '5': [
        // 2008 - Independencia
        NumismaticMotifRule('Ignacio López Rayón', 2008),
        NumismaticMotifRule('Francisco Xavier Mina', 2008),
        NumismaticMotifRule('Mariano Matamoros', 2008),
        NumismaticMotifRule('Carlos María de Bustamante', 2008),
        NumismaticMotifRule('Hermenegildo Galeana', 2008),
        NumismaticMotifRule('Francisco Primo de Verdad y Ramos (Con puntos)', 2008),
        NumismaticMotifRule('Francisco Primo de Verdad y Ramos (Sin puntos - Variedad especial)', 2008),
        // 2008 - Revolución
        NumismaticMotifRule('Álvaro Obregón', 2008),
        NumismaticMotifRule('José Vasconcelos', 2008),
        NumismaticMotifRule('Francisco Villa', 2008),
        NumismaticMotifRule('Heriberto Jara', 2008),
        NumismaticMotifRule('Ricardo Flores Magón', 2008),
        NumismaticMotifRule('Francisco J. Múgica', 2008),
        // 2009 - Independencia
        NumismaticMotifRule('José María Cos', 2009),
        NumismaticMotifRule('Pedro Moreno', 2009),
        NumismaticMotifRule('Agustín de Iturbide', 2009),
        NumismaticMotifRule('Servando Teresa de Mier', 2009),
        NumismaticMotifRule('Nicolás Bravo', 2009),
        NumismaticMotifRule('Leona Vicario', 2009),
        // 2009 - Revolución
        NumismaticMotifRule('Filomeno Mata', 2009),
        NumismaticMotifRule('Carmen Serdán', 2009),
        NumismaticMotifRule('Andrés Molina Enríquez', 2009),
        NumismaticMotifRule('Luis Cabrera', 2009),
        NumismaticMotifRule('Eulalio Gutiérrez', 2009),
        NumismaticMotifRule('Otilio Montaño', 2009),
        // 2010 - Independencia
        NumismaticMotifRule('Miguel Hidalgo y Costilla', 2010),
        NumismaticMotifRule('José María Morelos y Pavón', 2010),
        NumismaticMotifRule('Vicente Guerrero', 2010),
        NumismaticMotifRule('Ignacio Allende', 2010),
        NumismaticMotifRule('Guadalupe Victoria', 2010),
        NumismaticMotifRule('Josefa Ortiz de Domínguez', 2010),
        // 2010 - Revolución
        NumismaticMotifRule('Belisario Domínguez', 2010),
        NumismaticMotifRule('Francisco I. Madero', 2010),
        NumismaticMotifRule('Emiliano Zapata', 2010),
        NumismaticMotifRule('Venustiano Carranza', 2010),
        NumismaticMotifRule('La Soldadera (Adelita)', 2010),
        NumismaticMotifRule('José María Pino Suárez', 2010),
      ],
      '20': [
        NumismaticMotifRule('Octavio Paz - Premio Nobel de Literatura (2010)', 2010, 2011),
      ],
    },
    commemorativeReasons: [
      'Bicentenario de la Independencia de México (1810-2010)',
      'Centenario de la Revolución Mexicana (1910-2010)',
      'Octavio Paz - Premio Nobel de Literatura (2010)',
    ],
  ),

  // 1.26 México - Familia C Fraccionarias Acero Inoxidable (2011–2019)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2011,
    maxYear: 2019,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    denominations: ['0.10', '0.20', '0.50', '1', '2', '5', '10', '20'],
    denominationMaterials: {
      '0.10': 'Acero inoxidable',
      '0.20': 'Acero inoxidable',
      '0.50': 'Acero inoxidable',
      '1': 'Bimetálica',
      '2': 'Bimetálica',
      '5': 'Bimetálica',
      '10': 'Bimetálica',
      '20': 'Bimetálica',
    },
    commemorativeDenominations: {'20'},
    commemorativeMotifsByDenomination: {
      '10': [
        NumismaticMotifRule('150 Aniversario de la Batalla de Puebla - General Ignacio Zaragoza (2012)', 2012),
      ],
      '20': [
        NumismaticMotifRule('Centenario del Ejército Mexicano (2013)', 2013),
        NumismaticMotifRule('150 Aniversario del Natalicio y 100 Aniversario Luctuoso de Belisario Domínguez (2013)', 2013),
        NumismaticMotifRule('Centenario de la Gesta Heroica de Veracruz (2014)', 2014),
        NumismaticMotifRule('Centenario de la Toma de Zacatecas (2014)', 2014),
        NumismaticMotifRule('Centenario de la Fuerza Aérea Mexicana (2015)', 2015),
        NumismaticMotifRule('Bicentenario Luctuoso del Generalísimo José María Morelos y Pavón (2015)', 2015),
        NumismaticMotifRule('Cincuenta Aniversario de la Aplicación del Plan DN-III-E (2016)', 2016),
        NumismaticMotifRule('Centenario de la Promulgación de la Constitución Política de 1917 (2017)', 2017),
        NumismaticMotifRule('50 Aniversario de la Aplicación del Plan Marina (2018)', 2018),
        NumismaticMotifRule('500 Años de la Fundación de la Ciudad y Puerto de Veracruz (2019)', 2019),
        NumismaticMotifRule('Centenario de la Muerte del General Emiliano Zapata Salazar (2019)', 2019),
      ],
    },
    commemorativeReasons: [
      '150 Aniversario de la Batalla de Puebla (2012)',
      'Centenario del Ejército Mexicano (2013)',
      '150 Aniversario de Belisario Domínguez (2013)',
      'Centenario de la Gesta Heroica de Veracruz (2014)',
      'Centenario de la Toma de Zacatecas (2014)',
      'Centenario de la Fuerza Aérea Mexicana (2015)',
      'Bicentenario Luctuoso de Morelos (2015)',
      'Plan DN-III-E (2016)',
      'Centenario de la Promulgación de la Constitución Política de 1917 (2017)',
      'Centenario de la Constitución Política de 1917 (2017)',
      'Centenario de la Constitución (2017)',
      'Plan Marina (2018)',
      '500 Años del Puerto de Veracruz (2019)',
      'Emiliano Zapata (2019)',
    ],
  ),

  // 1.27 México - Familia C1 Dodecagonal (2020–presente)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2020,
    maxYear: 2100,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    denominations: ['0.10', '0.20', '0.50', '1', '2', '5', '10', '20'],
    denominationMaterials: {
      '0.10': 'Acero inoxidable',
      '0.20': 'Acero inoxidable',
      '0.50': 'Acero inoxidable',
      '1': 'Bimetálica',
      '2': 'Bimetálica',
      '5': 'Bimetálica',
      '10': 'Bimetálica',
      '20': 'Bimetálica',
    },
    commemorativeDenominations: {'20'},
    commemorativeMotifsByDenomination: {
      '20': [
        NumismaticMotifRule('500 Años de la Fundación de la Ciudad y Puerto de Veracruz (Dodecagonal 2020)', 2020),
        NumismaticMotifRule('Centenario de la Muerte del General Emiliano Zapata Salazar (Dodecagonal 2020)', 2020),
        NumismaticMotifRule('700 Años de la Fundación Lunar de la Ciudad de México-Tenochtitlan (2021)', 2021),
        NumismaticMotifRule('500 Años de Memoria Histórica de México-Tenochtitlan (2021)', 2021),
        NumismaticMotifRule('Bicentenario de la Independencia Nacional (2021)', 2021),
        NumismaticMotifRule('Bicentenario de la Marina-Armada de México (2021-2022)', 2021, 2022),
        NumismaticMotifRule('Cien Años de la Llegada de los Menonitas a México (2022)', 2022),
        NumismaticMotifRule('Bicentenario del Heroico Colegio Militar (2023)', 2023),
        NumismaticMotifRule('Doscientos Años de Relaciones Diplomáticas México-Estados Unidos (2023)', 2023),
        NumismaticMotifRule('500 Años de la Fundación de la Villa de Colima (2023)', 2023),
        NumismaticMotifRule('Bicentenario de la Instauración del Senado de la República (2024)', 2024),
        NumismaticMotifRule('Cien Años del Heroico Batallón de Infantería de Marina (2024)', 2024),
      ],
    },
    commemorativeReasons: [
      'Fundación Lunar de Tenochtitlan (2021)',
      'Memoria Histórica de Tenochtitlan (2021)',
      'Bicentenario de la Independencia (2021)',
      'Bicentenario de la Marina-Armada de México (2021-2022)',
      'Bicentenario de la Marina-Armada (1821-2021)',
      'Bicentenario de la Marina-Armada de México (2021)',
      'Marina-Armada de México / Fuerza Armada (2021)',
      'Bicentenario de la Marina-Armada (2022)',
      'Llegada de los Menonitas a México (2022)',
      'Bicentenario del Heroico Colegio Militar (2023)',
      'Relaciones Diplomáticas México-EE.UU. (2023)',
      'Villa de Colima (2023)',
      'Instauración del Senado de la República (2024)',
      'Heroico Batallón de Infantería de Marina (2024)',
    ],
  ),
];
