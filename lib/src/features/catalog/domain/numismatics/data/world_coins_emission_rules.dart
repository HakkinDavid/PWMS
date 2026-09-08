import 'numismatic_countries_registry.dart';
import 'numismatic_currencies_registry.dart';
import 'numismatic_denominations_registry.dart';
import 'numismatic_materials_registry.dart';
import '../models/numismatic_models.dart';

/// Historical emission rules for world coins (Guatemala, Colombia, Canadá, Cuba, Argentina, Brasil, Chile, Perú, Reino Unido, Francia, Alemania, Italia).
const List<NumismaticEmissionRuleData> worldCoinsEmissionRules = [
  // 4.1 Guatemala - Época Colonial y Reales Predecimales (1500–1859)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.guatemala,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Castillo y León / Busto',
            minYear: 1796,
            maxYear: 1859,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Colonial y República del Centro de América',
            minYear: 1733,
            maxYear: 1859,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Columnario y Busto Real / Escudo Coronado (Ceca de Guatemala)',
            minYear: 1733,
            maxYear: 1859,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Columnario de los Dos Mundos / Busto Real (Ceca de Guatemala)',
            minYear: 1733,
            maxYear: 1859,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Columnario de los Dos Mundos / Busto Real (Ceca de Guatemala)',
            minYear: 1733,
            maxYear: 1859,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Plata (Columnario / Busto / Volcán del Centro de América)',
            minYear: 1733,
            maxYear: 1859,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 4.2 Guatemala - Época del Peso (1860–1924)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.guatemala,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Peso (Cobre / Cuproníquel)',
            minYear: 1871,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Cuarto de Real',
            minYear: 1881,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            '1 Real Plata .900/.720',
            minYear: 1860,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Quetzal y Escudo Nacional',
            minYear: 1860,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Quetzal y Escudo Nacional',
            minYear: 1860,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Plata .900 (Carrera / República de Guatemala)',
            minYear: 1860,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Escudo Nacional de Guatemala',
            minYear: 1860,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Escudo Nacional de Guatemala',
            minYear: 1860,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Escudo con Quetzal',
            minYear: 1869,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Escudo con Quetzal',
            minYear: 1869,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Escudo con Quetzal',
            minYear: 1869,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Escudo de la República de Guatemala',
            minYear: 1860,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.gtqHist,
        motifs: [
          NumismaticMotifRule(
            'Busto de Rafael Carrera / Escudo de la República de Guatemala',
            minYear: 1860,
            maxYear: 1924,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 4.3 Guatemala - Quetzal Clásico de Plata y Oro (1925–1964)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.guatemala,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_005,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Quetzal sobre Pedestal (Medio Centavo) / Escudo Nacional',
            minYear: 1925,
            maxYear: 1949,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Quetzal (Fray Bartolomé de las Casas)',
            minYear: 1925,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Plata .720 (Ceiba / Árbol de la Libertad)',
            minYear: 1925,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Plata .720 (Monolito de Quiriguá)',
            minYear: 1925,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Plata .720 (Mujer Indígena Santiago Atitlán)',
            minYear: 1925,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Plata .720 (Monja Blanca)',
            minYear: 1925,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Quetzal sobre Columna (Plata .720)',
            minYear: 1925,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Quetzal sobre Columna (Oro .900)',
            minYear: 1926,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Quetzal sobre Columna (Oro .900)',
            minYear: 1926,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Quetzal sobre Columna (Oro .900)',
            minYear: 1926,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
    ],
  ),

  // 4.4 Guatemala - Quetzal Moderno (1965–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.guatemala,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Fray Bartolomé de las Casas',
            minYear: 1965,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameMagnalium,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Árbol de la Libertad (Ceiba)',
            minYear: 1965,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Monolito de Quiriguá',
            minYear: 1965,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            "Concepción Ramírez (Mujer Tz'utujil)",
            minYear: 1965,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Monja Blanca (Lycaste skinneri alba)',
            minYear: 1965,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Paz Firme y Duradera (1996+)',
            minYear: 1996,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
    ],
  ),

  // 1.8 Colombia - Virreinato de Nueva Granada y Reales Predecimales (1500–1846)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.colombia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Santa Fe de Bogotá / Popayán',
            minYear: 1500,
            maxYear: 1846,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Monograma Real Coronado / Columnas de Hércules',
            minYear: 1500,
            maxYear: 1846,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Escudo Real Coronado / Columnario Virreinal',
            minYear: 1500,
            maxYear: 1846,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Columnario Virreinal / Escudo Real Coronado',
            minYear: 1500,
            maxYear: 1846,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Columnario Virreinal / Escudo Real Coronado',
            minYear: 1500,
            maxYear: 1846,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Plata (Columnario / Busto / Libertad de la Nueva Granada)',
            minYear: 1500,
            maxYear: 1846,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 5.2 Colombia - Peso Histórico y Decimal Antiguo (1847–1904)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.colombia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Cobre / Bronce',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Cobre / Cuproníquel',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Plata .666/.835 (Libertad)',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Plata .666/.835 (Libertad)',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Plata .666/.835 (Libertad)',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Plata .835/.900 (Libertad)',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Plata .900 (Estados Unidos de Colombia / República de Colombia)',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Perfil de la Libertad / Escudo con Cóndor Andino',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Perfil de la Libertad / Escudo con Cóndor Andino',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Perfil de la Libertad / Escudo con Cóndor Andino',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.copHist,
        motifs: [
          NumismaticMotifRule(
            'Oro .900 (Doble Cóndor)',
            minYear: 1847,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
    ],
  ),

  // 5.3 Colombia - Peso Republicano Clásico (1905–1979)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.colombia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            '(Cacique Calarcá / República)',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            '(Francisco de Paula Santander)',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Corona de Laurel (o Policarpa Salavarrieta)',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar / Escudo Nacional',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar / Escudo Nacional',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Plata .500 (Simón Bolívar)',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel (Simón Bolívar)',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar / Francisco de Paula Santander (Escudo Nacional)',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar / Francisco de Paula Santander (Escudo Nacional)',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar / Escudo de Armas con Cóndor',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar / Escudo de Armas con Cóndor',
            minYear: 1905,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Camilo Torres / Escudo Nacional',
            minYear: 1970,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 5.4 Colombia - Familia Tradicional Árbol de Guacarí (1980–2011)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.colombia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar',
            minYear: 1980,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar',
            minYear: 1980,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar',
            minYear: 1980,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar',
            minYear: 1980,
            maxYear: 1994,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar',
            minYear: 1980,
            maxYear: 1994,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Colombia',
            minYear: 1989,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Colombia',
            minYear: 1992,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Figura Quimbaya',
            minYear: 1994,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Árbol de Guacarí (Samanea saman)',
            minYear: 1993,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
    ],
  ),

  // 5.5 Colombia - Familia Biodiversidad de Colombia (2012–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.colombia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Oso de Anteojos (Tremarctos ornatus)',
            minYear: 2012,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Frailejón (Espeletia grandiflora)',
            minYear: 2012,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Guacamaya Bandera (Ara macao)',
            minYear: 2012,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Rana de Cristal (Anura Centrolenidae)',
            minYear: 2012,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Tortuga Caguama (Caretta caretta)',
            minYear: 2012,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Bicentenario de la Independencia de Colombia',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Bicentenario del Sacrificio de Policarpa Salavarrieta',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Batalla Naval del Lago de Maracaibo',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Bicentenario del Museo Nacional de Colombia',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 6.1 Canadá - Época Victoriana, Jorge V y Jorge VI (1858–1952)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.canada,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Large Cent / Small Cent (Hojas de Arce)',
            minYear: 1858,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Plata / Castor de Níquel / Victory Tombac',
            minYear: 1858,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Plata .800/.925 (Bluenose Schooner)',
            minYear: 1858,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Plata .925 (Victoria)',
            minYear: 1858,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Plata .800/.925 (Caribou / Hojas de Arce)',
            minYear: 1870,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Plata .800/.925 (Escudo de Canadá)',
            minYear: 1870,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Silver Dollar Plata .800 (Voyageur / Jorge V / Jorge VI)',
            minYear: 1935,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Oro .900 (Jorge V)',
            minYear: 1912,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Oro .900 (Jorge V)',
            minYear: 1912,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
    ],
  ),

  // 6.2 Canadá - Era de Plata Isabel II (1953–1967)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.canada,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Hojas de Arce (Isabel II)',
            minYear: 1953,
            maxYear: 1967,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Beaver Castor (Isabel II)',
            minYear: 1953,
            maxYear: 1967,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Bluenose',
            minYear: 1953,
            maxYear: 1967,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Caribou Estándar (1953-1966)',
            minYear: 1953,
            maxYear: 1966,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Lince del Centenario de la Confederación',
            minYear: 1967,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Escudo de Armas (1953-1966)',
            minYear: 1953,
            maxYear: 1966,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Lobo Aullador del Centenario de la Confederación',
            minYear: 1967,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Silver Dollar Plata .800 Voyageur (1953-1966)',
            minYear: 1953,
            maxYear: 1966,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Ganso de Canadá del Centenario de la Confederación',
            minYear: 1967,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 6.3 Canadá - Transición Níquel Puro Pre-Loonie (1968–1986)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.canada,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Hojas de Arce',
            minYear: 1968,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Beaver Castor',
            minYear: 1968,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Bluenose',
            minYear: 1968,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Níquel Caribou Estándar (1968-1986)',
            minYear: 1968,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            'Centenario de la Policía Montada RCMP',
            minYear: 1973,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Armas',
            minYear: 1968,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Níquel Voyageur Estándar (1968-1986)',
            minYear: 1968,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            'Centenario de Manitoba',
            minYear: 1970,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            'Centenario de Columbia Británica',
            minYear: 1971,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            'Centenario de la Isla del Príncipe Eduardo',
            minYear: 1973,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            'Centenario de Winnipeg',
            minYear: 1974,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            'Ley Constitucional de Canadá',
            minYear: 1982,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            '450 Aniversario del Viaje de Jacques Cartier',
            minYear: 1984,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
    ],
  ),

  // 6.4 Canadá - Introducción del Loonie y Toonie (1987–1999)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.canada,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Hojas de Arce',
            minYear: 1987,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Beaver Castor',
            minYear: 1987,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Bluenose',
            minYear: 1987,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Caribou Estándar (1987-1999)',
            minYear: 1987,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            '125 Aniversario de la Confederación de Canadá',
            minYear: 1992,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
          NumismaticMotifRule(
            'Millennium Series - 12 Diseños Mensuales',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Armas',
            minYear: 1987,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Loonie - Colimbo Común Estándar (1987-1999)',
            minYear: 1987,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            '125 Aniversario de Canadá',
            minYear: 1992,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Monumento Nacional a la Guerra',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Mantenimiento de la Paz de la ONU',
            minYear: 1995,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Toonie - Oso Polar Estándar (1996-1999)',
            minYear: 1996,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Creación del Territorio de Nunavut',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
        ],
      ),
    ],
  ),

  // 6.5 Canadá - Época Multi-Ply Plated Steel (2000–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.canada,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Hojas de Arce',
            minYear: 2000,
            maxYear: 2012,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Beaver Castor',
            minYear: 2000,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Bluenose',
            minYear: 2000,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Caribou Estándar (2000+)',
            minYear: 2000,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
          NumismaticMotifRule(
            'Millennium Series - 12 Diseños',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
          NumismaticMotifRule(
            'Amapola del Día del Recuerdo',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos de Invierno Vancouver 2010 (2007-2010)',
            minYear: 2007,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
          NumismaticMotifRule(
            'Guerra de 1812 (2012-2013)',
            minYear: 2012,
            maxYear: 2013,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
          NumismaticMotifRule(
            'Canada 150 - Esperanza por un Futuro Verde',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Armas',
            minYear: 2000,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Loonie - Colimbo Común Estándar (2000+)',
            minYear: 2000,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Lucky Loonie (2004, 2008, 2010, 2012, 2014, 2016)',
            minYear: 2004,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Terry Fox',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Centenario de los Montreal Canadiens',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Centenario de la Marina Real Canadiense',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Canada 150 - Conectando una Nación',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Despenalización de la Homosexualidad',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Oscar Peterson',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
          NumismaticMotifRule(
            'Elsie MacGill',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Toonie - Oso Polar Estándar (2000+)',
            minYear: 2000,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Camino del Conocimiento',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            '10 Aniversario del Toonie',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            '400 Años de la Ciudad de Quebec',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'HMS Shannon',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Sir John A. Macdonald',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Batalla del Atlántico',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Canada 150 - Danza de los Espíritus',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Armisticio de 1918',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            '75 Aniversario del Día D',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            '75 Aniversario del Fin de la Segunda Guerra Mundial',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Descubrimiento de la Insulina',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Homenaje a la Reina Isabel II - Anillo Negro',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Día Nacional de los Pueblos Indígenas',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
          NumismaticMotifRule(
            'Centenario de la Real Fuerza Aérea Canadiense',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicToonie,
          ),
        ],
      ),
    ],
  ),

  // 7.1 Cuba - Primera República (1915–1961)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.cuba,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel (Estrella Solitaria)',
            minYear: 1915,
            maxYear: 1961,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Estrella de Cinco Puntas / Escudo de la Palma Real',
            minYear: 1915,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Estrella de Cinco Puntas / Escudo de la Palma Real',
            minYear: 1915,
            maxYear: 1961,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Estrella Radiante / Escudo de la Palma Real',
            minYear: 1915,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Estrella Radiante / Escudo de la Palma Real',
            minYear: 1915,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_40,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Estrella Radiante / Escudo de la Palma Real',
            minYear: 1915,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Plata .900 Estrella Radiante (1915-1939)',
            minYear: 1915,
            maxYear: 1939,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Natalicio de José Martí',
            minYear: 1953,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Oro .900 (José Martí)',
            minYear: 1915,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Oro .900 (José Martí)',
            minYear: 1915,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Oro .900 (José Martí)',
            minYear: 1915,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Oro .900 (José Martí)',
            minYear: 1915,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Oro .900 (José Martí)',
            minYear: 1915,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
    ],
  ),

  // 7.2 Cuba - Período Socialista Pre-CUC (1962–1993)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.cuba,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Caña de Azúcar (Patria o Muerte)',
            minYear: 1963,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Caña de Azúcar (Patria o Muerte)',
            minYear: 1963,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Caña de Azúcar (Patria o Muerte)',
            minYear: 1963,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Caña de Azúcar (Patria o Muerte)',
            minYear: 1963,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_40,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Estrella de Cinco Puntas / Escudo Nacional',
            minYear: 1962,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel (Patria o Muerte)',
            minYear: 1962,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Ernesto Che Guevara - Hasta la Victoria Siempre',
            minYear: 1990,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 7.3 Cuba - Régimen Dual CUP / CUC (1994–2020)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.cuba,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Numeral con Laureles (Patria o Muerte)',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Numeral con Laureles (Patria o Muerte)',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Numeral con Laureles (Patria o Muerte)',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Castillo de la Real Fuerza',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Castillo del Morro',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Plaza de la Revolución',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'José Martí',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Ernesto Che Guevara',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Antonio Maceo - Protesta de Baraguá',
            minYear: 1994,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
    ],
  ),

  // 7.4 Cuba - Unificación Monetaria (2021–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.cuba,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Numeral con Laureles (Patria o Muerte)',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Patria o Muerte',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'José Martí',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Ernesto Che Guevara',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Antonio Maceo',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
    ],
  ),

  // 8.1 Argentina - Provincias Unidas del Río de la Plata y Confederación (1813–1880)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.argentina,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Sol de Mayo / Corona de Laurel (Cuartillo)',
            minYear: 1813,
            maxYear: 1880,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Primera Moneda Patria (Sol de Mayo / Provincias del Río de la Plata)',
            minYear: 1813,
            maxYear: 1880,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Escudo de la Asamblea del Año XIII / Sol de Mayo',
            minYear: 1813,
            maxYear: 1880,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Sol de Mayo Radiante',
            minYear: 1813,
            maxYear: 1880,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Escudo Nacional / Sol de Mayo Radiante',
            minYear: 1813,
            maxYear: 1880,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Plata Primera Moneda Patria (En Unión y Libertad)',
            minYear: 1813,
            maxYear: 1880,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 8.2 Argentina - Peso Moneda Nacional (1881–1969)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.argentina,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Bronce (Libertad de Oudiné)',
            minYear: 1881,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Bronce (Libertad de Oudiné)',
            minYear: 1881,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Libertad de Oudiné / Escudo Nacional',
            minYear: 1881,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Libertad de Oudiné / Escudo Nacional',
            minYear: 1881,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Libertad de Oudiné / Escudo Nacional',
            minYear: 1881,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Plata .900 / Cuproníquel',
            minYear: 1881,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Patacón de Plata .900 / Cuproníquel',
            minYear: 1881,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'General José de San Martín / Escudo Nacional',
            minYear: 1940,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Argentino de Oro .900 (Oudiné)',
            minYear: 1881,
            maxYear: 1896,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'General San Martín',
            minYear: 1962,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Primera Moneda Patria',
            minYear: 1962,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d25,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Sesquicentenario de la Revolución de Mayo',
            minYear: 1960,
            material: NumismaticMaterialsRegistry.nameSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Centenario de la Reorganización Nacional',
            minYear: 1962,
            material: NumismaticMaterialsRegistry.nameSteel,
          ),
          NumismaticMotifRule(
            'Sesquicentenario de la Declaración de la Independencia',
            minYear: 1966,
            material: NumismaticMaterialsRegistry.nameSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.arm,
        motifs: [
          NumismaticMotifRule(
            'Sesquicentenario de la Independencia (Casa de Tucumán)',
            minYear: 1966,
            material: NumismaticMaterialsRegistry.nameSteel,
          ),
        ],
      ),
    ],
  ),

  // 8.3 Argentina - Peso Ley 18.188 (1970–1983)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.argentina,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'Ley',
            minYear: 1970,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'Ley',
            minYear: 1970,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'Ley',
            minYear: 1970,
            maxYear: 1976,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'Ley',
            minYear: 1970,
            maxYear: 1976,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'Ley',
            minYear: 1970,
            maxYear: 1976,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'San Martín',
            minYear: 1974,
            maxYear: 1976,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'San Martín',
            minYear: 1976,
            maxYear: 1977,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'San Martín',
            minYear: 1976,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'Mundial de Fútbol Argentina 1978 - Estadio José María Minella (1977-1978)',
            minYear: 1977,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Bicentenario del Natalicio del General José de San Martín',
            minYear: 1978,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'Mundial de Fútbol Argentina 1978 - Estadio Ciudad de Mendoza (1977-1978)',
            minYear: 1977,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Bicentenario del Natalicio del General José de San Martín',
            minYear: 1978,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.arl,
        motifs: [
          NumismaticMotifRule(
            'Mundial de Fútbol Argentina 1978 - Estadio Monumental (1977-1978)',
            minYear: 1977,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Bicentenario del Natalicio del General José de San Martín',
            minYear: 1978,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Centenario de la Campaña del Desierto',
            minYear: 1979,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
    ],
  ),

  // 8.4 Argentina - Peso Argentino (1983–1985)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.argentina,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Cabildo de Buenos Aires / Escudo Nacional',
            minYear: 1983,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Casa de Tucumán / Escudo Nacional',
            minYear: 1983,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Casa del Acuerdo de San Nicolás / Escudo Nacional',
            minYear: 1983,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Monumento Nacional a la Bandera / Escudo Nacional',
            minYear: 1983,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Argentino Cabildo',
            minYear: 1984,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Argentinos Congreso',
            minYear: 1984,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Argentinos Casa de Tucumán',
            minYear: 1984,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Argentinos Casa del Acuerdo',
            minYear: 1984,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.arp,
        motifs: [
          NumismaticMotifRule(
            'Argentinos Cabildo de Jujuy',
            minYear: 1985,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
    ],
  ),

  // 8.5 Argentina - Austral (1985–1991)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.argentina,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_005,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Austral Hornero',
            minYear: 1985,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Ñandú',
            minYear: 1985,
            maxYear: 1988,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Puma',
            minYear: 1985,
            maxYear: 1988,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Cóndor',
            minYear: 1985,
            maxYear: 1988,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Libertad',
            minYear: 1985,
            maxYear: 1988,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Cabildo',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Congreso',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Casa de Tucumán',
            minYear: 1989,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Libertad',
            minYear: 1989,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Armas',
            minYear: 1989,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Armas',
            minYear: 1990,
            maxYear: 1991,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.ara,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Armas',
            minYear: 1990,
            maxYear: 1991,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 8.6 Argentina - Peso Convertible Series Tradicionales (1992–2016)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.argentina,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Laurel',
            minYear: 1992,
            maxYear: 2000,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Sol de Mayo',
            minYear: 1992,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Armas',
            minYear: 1992,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Cabildo de Buenos Aires',
            minYear: 1992,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Casa de Tucumán Estándar (1992-2016)',
            minYear: 1992,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Convención Nacional Constituyente',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            '50 Aniversario de UNICEF',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Voto Femenino',
            minYear: 1997,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Mercosur',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Centenario del Natalicio de Jorge Luis Borges',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Fallecimiento de Eva Perón - 50 Aniversario',
            minYear: 2002,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Sol de Mayo Bimetálica Estándar (1994-2016)',
            minYear: 1994,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Revolución de Mayo - Pucará de Tilcara',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Revolución de Mayo - El Palmar',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Revolución de Mayo - Aconcagua',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Revolución de Mayo - Mar del Plata',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Revolución de Mayo - Glaciar Perito Moreno',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Primera Moneda Patria - Asamblea del Año XIII',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Sol de Mayo Estándar (2011-2016)',
            minYear: 2011,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Creación de la Bandera Nacional',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            '30 Aniversario de la Guerra de Malvinas',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario del Combate de San Lorenzo',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Vuelo de Jorge Newbery',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Declaración de la Independencia',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
    ],
  ),

  // 8.7 Argentina - Serie "Árboles de la República Argentina" (2017–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.argentina,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Jacarandá (Jacaranda mimosifolia)',
            minYear: 2017,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Palo Borracho (Ceiba speciosa)',
            minYear: 2017,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Arrayán (Luma apiculata)',
            minYear: 2017,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Caldén (Prosopis caldenia)',
            minYear: 2018,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
        ],
      ),
    ],
  ),

  // 9.1 Brasil - Período Colonial e Imperial (1500–1941)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.brasil,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1868,
            maxYear: 1870,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1868,
            maxYear: 1870,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d40,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1889,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d80,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1818,
            maxYear: 1832,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1871,
            maxYear: 1940,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1871,
            maxYear: 1940,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d300,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1936,
            maxYear: 1940,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d400,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1901,
            maxYear: 1940,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1913,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d640,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1695,
            maxYear: 1834,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d960,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            'Patacão Colonial/Imperial',
            minYear: 1810,
            maxYear: 1834,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1913,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.brs,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1935,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 9.2 Brasil - Cruzeiro (1942–1985)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.brasil,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1942,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1942,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1942,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1942,
            maxYear: 1984,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1942,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            'Mapa do Brasil e Ramo de Café (1972-1980)',
            minYear: 1972,
            maxYear: 1980,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Sesquicentenário da Independência do Brasil',
            minYear: 1972,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            'Cana-de-Açúcar e Brasão das Armas (1972-1984)',
            minYear: 1972,
            maxYear: 1984,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Sesquicentenário da Independência do Brasil',
            minYear: 1972,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            'Ramo de Soja e Brasão das Armas (1972-1986)',
            minYear: 1972,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Sesquicentenário da Independência do Brasil',
            minYear: 1972,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Centenário da Imigração Italiana',
            minYear: 1975,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.brb,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1981,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 9.3 Brasil - Cruzado, Cruzado Novo y Cruzeiro Real (1986–1993)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.brasil,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1986,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1986,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1986,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1986,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1986,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1986,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1986,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1986,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            'Juscelino Kubitschek e Brasília (1986-1988)',
            minYear: 1986,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
          NumismaticMotifRule(
            'Centenário da Abolição da Escravidão - Lei Áurea',
            minYear: 1988,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            'Centenário da República - Efigie da República (1989-1993)',
            minYear: 1989,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
          NumismaticMotifRule(
            'Centenário da Proclamação da República',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1992,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1992,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.brn,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1993,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
    ],
  ),

  // 9.4 Brasil - Real 1ª Familia Acero Inoxidable (1994–1997)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.brasil,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1994,
            maxYear: 1997,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1994,
            maxYear: 1997,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efigie da República (1ª Familia 1994-1997)',
            minYear: 1994,
            maxYear: 1997,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
          NumismaticMotifRule(
            'FAO - 50 Anos da FAO',
            minYear: 1995,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efigie da República (1ª Familia 1994-1995)',
            minYear: 1994,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
          NumismaticMotifRule(
            'FAO - 50 Anos da FAO',
            minYear: 1995,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1994,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efigie da República (1ª Familia 1994-1995)',
            minYear: 1994,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
          NumismaticMotifRule(
            '30 Anos do Banco Central do Brasil',
            minYear: 1995,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
    ],
  ),

  // 9.5 Brasil - Real 2ª Familia Bimetálica y Recubrimientos (1998–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.brasil,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1998,
            maxYear: 2004,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1998,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1998,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBronzePlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1998,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBronzePlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1998,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efigie da República com Grafismos Marajoaras (2ª Familia 1998+)',
            minYear: 1998,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            '50 Aniversario de la Declaración Universal de los Derechos Humanos',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Centenario de Juscelino Kubitschek',
            minYear: 2002,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            '40 Aniversario del Banco Central do Brasil',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Centenario de la Inmigración Japonesa a Brasil',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Entrega de la Bandera Olímpica - Londres 2012 a Río 2016',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Banco Central do Brasil',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            '25 Años del Plano Real',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Atletismo',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Natación',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Paratriatlón',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Golf',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Baloncesto',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Vela',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Paracanotaje',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Rugby',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Fútbol',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Voleibol',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Atletismo Paralímpico',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Judo',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Boxeo',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Natación Paralímpica',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Mascota Olímpica Vinicius',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos Río 2016 - Mascota Paralímpica Tom',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
    ],
  ),

  // 10.1 Chile - Período Colonial y Reales (1500–1850)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.chile,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1790,
            maxYear: 1808,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1773,
            maxYear: 1817,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1773,
            maxYear: 1817,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1773,
            maxYear: 1817,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1773,
            maxYear: 1817,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1773,
            maxYear: 1817,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 10.2 Chile - Peso Antiguo Decimal (1851–1959)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.chile,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_005,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1853,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1853,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1853,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1870,
            maxYear: 1942,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1870,
            maxYear: 1942,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1870,
            maxYear: 1942,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1888,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1880,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1894,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1851,
            maxYear: 1894,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1926,
            maxYear: 1959,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1926,
            maxYear: 1959,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.clf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1926,
            maxYear: 1959,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
    ],
  ),

  // 10.3 Chile - Escudo Chileno (1960–1974)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.chile,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_005,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1960,
            maxYear: 1962,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1960,
            maxYear: 1971,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1960,
            maxYear: 1971,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1960,
            maxYear: 1971,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 1972,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 1972,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 1972,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 1972,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 1972,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 1972,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1974,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1974,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.cle,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1974,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 10.4 Chile - Peso Actual (1975–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.chile,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            "Bernardo O'Higgins",
            minYear: 1975,
            maxYear: 2017,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            "Bernardo O'Higgins (Forma Octagonal)",
            minYear: 1976,
            maxYear: 2015,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            "Bernardo O'Higgins",
            minYear: 1975,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Ángel de la Libertad (1976-1990)',
            minYear: 1976,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            "Bernardo O'Higgins (Forma Decagonal)",
            minYear: 1981,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            'Pueblos Originarios - Mujer Mapuche',
            minYear: 2001,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Escudo Nacional de 8 Lados (1981-2000)',
            minYear: 1981,
            maxYear: 2000,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            'Cardenal Raúl Silva Henríquez',
            minYear: 2000,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
    ],
  ),

  // 11.1 Perú - Época Colonial y Reales (1500–1862)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.peru,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1794,
            maxYear: 1808,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1772,
            maxYear: 1824,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1772,
            maxYear: 1824,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1772,
            maxYear: 1824,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1772,
            maxYear: 1824,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1772,
            maxYear: 1824,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 11.2 Perú - Sol de Oro (1863–1984)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.peru,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1863,
            maxYear: 1949,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1863,
            maxYear: 1949,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1918,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1918,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1918,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1864,
            maxYear: 1935,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            'Libertad Parada (Plata)',
            minYear: 1863,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Túpac Amaru II (1970-1977)',
            minYear: 1970,
            maxYear: 1977,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1950,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            'Almirante Miguel Grau',
            minYear: 1970,
            maxYear: 1977,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            'Túpac Amaru II',
            minYear: 1977,
            maxYear: 1984,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1950,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1950,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.peh,
        motifs: [
          NumismaticMotifRule(
            'Centenario de la Guerra del Pacífico',
            minYear: 1979,
            maxYear: 1980,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 11.3 Perú - Inti (1985–1990)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.peru,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1985,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1985,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1985,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1985,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            'Gran Almirante Miguel Grau',
            minYear: 1985,
            maxYear: 1988,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            'Gran Almirante Miguel Grau',
            minYear: 1985,
            maxYear: 1988,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1988,
            maxYear: 1989,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            'Andrés Avelino Cáceres',
            minYear: 1989,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            'César Vallejo',
            minYear: 1989,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.pei,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1990,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 11.4 Perú - Sol Moderno (1991–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.peru,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1991,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1991,
            maxYear: 2018,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1991,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1991,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1991,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Armas y Ramas de Laurel y Roble',
            minYear: 1991,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Tumi de Oro (Lambayeque)',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Sarcófagos de Karajía (Amazonas)',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Estela de Raimondi (Áncash)',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Chullpas de Sillustani (Puno)',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Monasterio de Santa Catalina (Arequipa)',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Machu Picchu (Cusco)',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Gran Pajatén (San Martín)',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Piedra de Saywite (Apurímac)',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Fortaleza del Real Felipe (Callao)',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Templo del Sol - Vilcashuamán (Ayacucho)',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Kuntur Wasi (Cajamarca)',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Templo Inca Huaytará (Huancavelica)',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Complejo Arqueológico de Kotosh (Huánuco)',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Arte Textil Paracas (Ica)',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Complejo Arqueológico de Tunanmarca (Junín)',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Ciudad Sagrada de Caral (Lima)',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Huaca de la Luna (La Libertad)',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Antiguo Hotel Palace (Loreto)',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Catedral de Lima (Lima)',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Petroglifos de Pusharo (Madre de Dios)',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Arquitectura Moqueguana (Moquegua)',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Sitio Arqueológico de Huarautambo (Pasco)',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Complejo Arqueológico de Cabeza de Vaca (Tumbes)',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Cerámica Vicús (Piura)',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Cerámica Shipibo-Konibo (Ucayali)',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Arco Parabólico de Tacna (Tacna)',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'El Cacao (Theobroma cacao)',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'La Quinua (Chenopodium quinoa)',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'La Anchoveta (Engraulis ringens)',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Casa Nacional de Moneda - 450 Años',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Oso Andino de Anteojos (Tremarctos ornatus)',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Cocodrilo de Tumbes (Crocodylus acutus)',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Cóndor Andino (Vultur gryphus)',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Tapir Andino (Tapirus pinchaque)',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Pava Aliblanca (Penelope albipennis)',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Jaguar (Panthera onca)',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Suri (Rhea pennata)',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Mono Choro de Cola Amarilla (Lagothrix flavicauda)',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Gato Andino (Leopardus jacobita)',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Rana Gigante del Titicaca (Telmatobius culeus)',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Juan Pablo Viscardo y Guzmán',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Hipólito Unanue',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Toribio Rodríguez de Mendoza',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Manuel Lorenzo de Vidaurre',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Francisco Xavier de Luna Pizarro',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'José Baquíjano y Carrillo',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'José Faustino Sánchez Carrión',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'Brigida Silva de Ochoa',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
          NumismaticMotifRule(
            'María Parado de Bellido',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameAlpaca,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            'Líneas de Nazca - El Colibrí',
            minYear: 1994,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            'Líneas de Nazca - El Ave Fragata',
            minYear: 1994,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
    ],
  ),

  // 12.1 Reino Unido - Sistema Pre-Decimal (1500–1970)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.reinoUnido,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1860,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1860,
            maxYear: 1967,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1860,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1937,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameNickelBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d6,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1947,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1s,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1947,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2s,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1947,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2_5s,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1947,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5s,
        currency: NumismaticCurrenciesRegistry.gbpOld,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1951,
            maxYear: 1965,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 12.2 Reino Unido - Sistema Decimal 1ª Fase (1971–2016)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.reinoUnido,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_005,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 1984,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1971,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1968,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1968,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1982,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Britannia Sedente con Escudo y Tridente (1969-2008)',
            minYear: 1969,
            maxYear: 2008,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Royal Shield of Arms - Sección del Escudo Real (2008-2016)',
            minYear: 2008,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Ingreso a la Comunidad Económica Europea EEC',
            minYear: 1973,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Presidencia Británica de la CEE (1992-1993)',
            minYear: 1992,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Día D desembarco de Normandía',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 Aniversario del NHS Servicio Nacional de Salud',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '25 Años de la CEE',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '150 Aniversario de las Bibliotecas Públicas',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '100 Años de la Fundación de la WSPU Movimiento Sufragista',
            minYear: 2003,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 Años de la Milla en Cuatro Minutos por Roger Bannister',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '250 Aniversario del Diccionario de Samuel Johnson',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Bicentenario de Isambard Kingdom Brunel',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Centenario del Movimiento Scout',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '250 Aniversario de los Jardines Botánicos Reales de Kew',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos y Paralímpicos de Londres 2012 - 29 Deportes',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Centenario de Benjamin Britten',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Centenario del Inicio de la Primera Guerra Mundial',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '75 Aniversario de la Batalla de Inglaterra',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '950 Aniversario de la Batalla de Hastings',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Serie Beatrix Potter - Peter Rabbit',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Serie Beatrix Potter - Jemima Puddle-Duck',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Serie Beatrix Potter - Squirrel Nutkin',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Serie Beatrix Potter - Mrs. Tiggy-Winkle',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Royal Arms - Escudo Real de Armas del Reino Unido (1983, 1993, 2003, 2008)',
            minYear: 1983,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameNickelBrass,
          ),
          NumismaticMotifRule(
            'Puentes del Reino Unido (2004-2007)',
            minYear: 2004,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameNickelBrass,
          ),
          NumismaticMotifRule(
            'Ciudades Capitales Británicas (2010-2011)',
            minYear: 2010,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameNickelBrass,
          ),
          NumismaticMotifRule(
            'Flora Heráldica Británica (2013-2014)',
            minYear: 2013,
            maxYear: 2014,
            material: NumismaticMaterialsRegistry.nameNickelBrass,
          ),
          NumismaticMotifRule(
            'Última Emisión Redonda - The Last Round Pound',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameNickelBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Desarrollo de la Tecnología - Anillos de la Historia Industrial (1997-2015)',
            minYear: 1997,
            maxYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Rugby World Cup',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Centenario de la Radio Transatlántica de Marconi',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Commonwealth Games Manchester',
            minYear: 2002,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Descubrimiento del ADN',
            minYear: 2003,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '200 Años de la Locomotora de Vapor de Trevithick',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '400 Años de la Conspiración de la Pólvora',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '60 Aniversario del Fin de la Segunda Guerra Mundial',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Bicentenario de Isambard Kingdom Brunel',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Abolición del Comercio de Esclavos',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Tercentenario del Acta de Unión',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Centenario de los Juegos Olímpicos de Londres 1908',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Bicentenario de Charles Darwin',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '250 Aniversario del Nacimiento de Robert Burns',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Centenario de Florence Nightingale',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '400 Aniversario de la Biblia del Rey Jacobo',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Bicentenario de Charles Dickens',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '150 Años del Metro de Londres',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '350 Aniversario de la Guinea de Oro',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Centenario de la Primera Guerra Mundial - Tu País te Necesita',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '800 Aniversario de la Carta Magna',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '400 Aniversario de William Shakespeare',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1990,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 12.3 Reino Unido - Sistema Decimal 2ª Fase Dodecagonal (2017–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.reinoUnido,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 2017,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 2017,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 2017,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 2017,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameNickelPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 2017,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Royal Shield of Arms - Sección del Escudo Real (2017-2022)',
            minYear: 2017,
            maxYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Salmón del Atlántico - Rey Carlos III (2023+)',
            minYear: 2023,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Sir Isaac Newton',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Centenario de la Ley de Representación Popular',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Stephen Hawking',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Salida del Reino Unido de la Unión Europea - Brexit',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Dinosaurios de la Colección del Museo de Historia Natural - Megalosaurus',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Orgullo Gay - Pride UK',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Homenaje a la Reina Isabel II',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Coronación del Rey Carlos III',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Nations of the Crown - Rosa, Puerro, Cardo y Trébol (2017-2022)',
            minYear: 2017,
            maxYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicUkPound,
          ),
          NumismaticMotifRule(
            'Flora y Fauna Británica - Abejas de Carlos III (2023+)',
            minYear: 2023,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicUkPound,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Britannia con Escudo y Tridente por Antony Dufort (2015-2022)',
            minYear: 2017,
            maxYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Corona de Flora Nacional - Rey Carlos III (2023+)',
            minYear: 2023,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Jane Austen',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Centenario de la RAF Royal Air Force',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '75 Aniversario del Día D',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '100 Años de Agatha Christie',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            '75 Aniversario de la Victoria en Europa VE Day',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'Alexander Graham Bell',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
          NumismaticMotifRule(
            'J.R.R. Tolkien',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameBimetallicUk2Pound,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 2017,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 13.1 Francia - Ancien Régime (1500–1794)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.francia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_12,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1655,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_6,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1655,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1655,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1641,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1641,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1640,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1640,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d6,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1640,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d12,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1640,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d24,
        currency: NumismaticCurrenciesRegistry.lvt,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1640,
            maxYear: 1793,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
    ],
  ),

  // 13.2 Francia - Franc Ancien (1795–1959)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.francia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1795,
            maxYear: 1920,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1795,
            maxYear: 1920,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1945,
            maxYear: 1959,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1945,
            maxYear: 1959,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1945,
            maxYear: 1946,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1903,
            maxYear: 1940,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1920,
            maxYear: 1958,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1920,
            maxYear: 1958,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1920,
            maxYear: 1958,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1933,
            maxYear: 1952,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1929,
            maxYear: 1939,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1929,
            maxYear: 1939,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1950,
            maxYear: 1958,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1954,
            maxYear: 1958,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 13.3 Francia - Nouveau Franc (1960–2001)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.francia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            "Épi d'épi",
            minYear: 1960,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Marianne de Lagriffoul',
            minYear: 1965,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Marianne de Lagriffoul',
            minYear: 1962,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Marianne de Lagriffoul',
            minYear: 1962,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Semeuse de Roty',
            minYear: 1965,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Semeuse de Roty',
            minYear: 1960,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Semeuse de Roty',
            minYear: 1979,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Semeuse de Roty',
            minYear: 1960,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Génie de la Bastille / Génie de la Liberté (1988-2001)',
            minYear: 1988,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Jean Monnet',
            minYear: 1988,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Revolución Francesa',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Centenario de la Torre Eiffel',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Guglielmo Marconi',
            minYear: 1992,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Mont Saint-Michel',
            minYear: 1992,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Gaston Phébus',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Le Mont-Saint-Michel (1992-2001)',
            minYear: 1992,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameTrimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos de Albertville 1992 - Pierre de Coubertin',
            minYear: 1992,
            material: NumismaticMaterialsRegistry.nameTrimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Juegos del Mediterráneo',
            minYear: 1993,
            material: NumismaticMaterialsRegistry.nameTrimetallicGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Hercule de Dupré (1974-1980)',
            minYear: 1974,
            maxYear: 1980,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Panthéon de París (1984-1998)',
            minYear: 1984,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Marie Curie',
            minYear: 1984,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Émile Zola',
            minYear: 1985,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Estatua de la Libertad',
            minYear: 1986,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'La Fayette',
            minYear: 1987,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Fraternité',
            minYear: 1988,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Droits de l\'Homme',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Charlemagne',
            minYear: 1990,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'René Descartes',
            minYear: 1991,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Jean Monnet',
            minYear: 1992,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Liberté par Louvre',
            minYear: 1993,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'André Malraux',
            minYear: 1996,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Clovis',
            minYear: 1996,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Paul Cézanne',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 14.1 Alemania - Imperio Alemán Goldmark (1873–1923)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.alemania,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1915,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1877,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1909,
            maxYear: 1912,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1919,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1908,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1874,
            maxYear: 1915,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.frg,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1873,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
    ],
  ),

  // 14.2 Alemania - República de Weimar y Reichsmark (1924–1947)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.alemania,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1923,
            maxYear: 1948,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1923,
            maxYear: 1940,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_04,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1932,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1923,
            maxYear: 1944,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1923,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1927,
            maxYear: 1939,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1924,
            maxYear: 1939,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1925,
            maxYear: 1939,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1924,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.rkm,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1927,
            maxYear: 1939,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 14.3 Alemania - Deutsche Mark 1ª Era (1948–1974)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.alemania,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1948,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1950,
            maxYear: 1968,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1949,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1949,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1949,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1950,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1951,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Bundesadler - Águila Federal Alemana (Silberadler 1951-1974)',
            minYear: 1951,
            maxYear: 1974,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Germanisches Nationalmuseum',
            minYear: 1952,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '150 Aniversario del Fallecimiento de Friedrich von Schiller',
            minYear: 1955,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '300 Aniversario del Natalicio de Ludwig Wilhelm von Baden',
            minYear: 1955,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Fallecimiento de Joseph von Eichendorff',
            minYear: 1957,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '150 Aniversario del Natalicio de Johann Gottlieb Fichte',
            minYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '250 Aniversario del Fallecimiento de Gottfried Wilhelm Leibniz',
            minYear: 1966,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario de Wilhelm Conrad Röntgen',
            minYear: 1967,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Fallecimiento de Wilhelm von Humboldt',
            minYear: 1967,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '150 Aniversario del Natalicio de Karl Marx',
            minYear: 1968,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '500 Aniversario del Fallecimiento de Johannes Gutenberg',
            minYear: 1968,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '150 Aniversario del Natalicio de Friedrich Wilhelm Raiffeisen',
            minYear: 1968,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario de la Fundación del Reichstag',
            minYear: 1971,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '500 Aniversario del Natalicio de Alberto Durero',
            minYear: 1971,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '500 Aniversario del Natalicio de Nicolás Copérnico',
            minYear: 1973,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '125 Aniversario de la Asamblea Nacional de Frankfurt en Paulskirche',
            minYear: 1973,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '25 Años de la Ley Fundamental de la RFA',
            minYear: 1974,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '250 Aniversario del Natalicio de Immanuel Kant',
            minYear: 1974,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Juegos Olímpicos de Múnich 1972 - Emblema Espiral',
            minYear: 1972,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos de Múnich 1972 - Rayos de Luz',
            minYear: 1972,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos de Múnich 1972 - Pareja de Atletas',
            minYear: 1972,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos de Múnich 1972 - Instalaciones Deportivas Estadio Olímpico',
            minYear: 1972,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos de Múnich 1972 - Bucle conmemorativo',
            minYear: 1972,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 14.4 Alemania - Deutsche Mark 2ª Era Magnimat (1975–2001)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.alemania,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1975,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1975,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1975,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1975,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameBrassPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1975,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1975,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1975,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1975,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Bundesadler - Águila Federal Alemana',
            minYear: 1987,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '750 Años de Berlín',
            minYear: 1987,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Bicentenario del Natalicio de Arthur Schopenhauer',
            minYear: 1988,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Fallecimiento de Carl Zeiss',
            minYear: 1988,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '40 Años de la República Federal de Alemania',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '2000 Años de Bonn',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '800 Años del Puerto de Hamburgo',
            minYear: 1989,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '800 Años de la Orden Teutónica',
            minYear: 1990,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '200 Aniversario de la Puerta de Brandeburgo',
            minYear: 1991,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '125 Aniversario del Natalicio de Käthe Kollwitz',
            minYear: 1992,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '150 Aniversario de la Orden Pour le Mérite',
            minYear: 1992,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '1000 Años de Potsdam',
            minYear: 1993,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '150 Aniversario del Natalicio de Robert Koch',
            minYear: 1993,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Levantamiento del 20 de Julio de 1944',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '250 Aniversario del Natalicio de Johann Gottfried Herder',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Descubrimiento de los Rayos X',
            minYear: 1995,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '150 Aniversario del Descubrimiento de Neptuno por Johann Gottfried Galle',
            minYear: 1996,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '500 Aniversario del Reformador Philipp Melanchthon',
            minYear: 1997,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Motor Diesel',
            minYear: 1997,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '350 Años de la Paz de Westfalia',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '50 Años del Deutsche Mark',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '900 Aniversario del Natalicio de Hildegarda de Bingen',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '50 Años de la Ley Fundamental',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '250 Aniversario del Natalicio de Johann Wolfgang von Goethe',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Exposición Universal Expo 2000 Hannover',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '250 Aniversario del Fallecimiento de Johann Sebastian Bach',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '10 Años de la Unidad Alemana',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            '50 Años del Tribunal Constitucional Federal',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 15.1 Italia - Reino de Italia (1861–1945)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.italia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1861,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1861,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1861,
            maxYear: 1943,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1862,
            maxYear: 1943,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1894,
            maxYear: 1943,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1861,
            maxYear: 1943,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1861,
            maxYear: 1943,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1861,
            maxYear: 1943,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1861,
            maxYear: 1941,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1926,
            maxYear: 1936,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1927,
            maxYear: 1936,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1864,
            maxYear: 1936,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1864,
            maxYear: 1937,
            material: NumismaticMaterialsRegistry.nameGoldGeneric,
          ),
        ],
      ),
    ],
  ),

  // 15.2 Italia - República Italiana 1ª Era Caravelle de Plata (1946–1981)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.italia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Italina / Cornucopia',
            minYear: 1946,
            maxYear: 1959,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Spiga / Olivo',
            minYear: 1946,
            maxYear: 1959,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Timone / Delfino',
            minYear: 1946,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Spighe / Aratro',
            minYear: 1946,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Quercia',
            minYear: 1956,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Vulcano',
            minYear: 1954,
            maxYear: 1989,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Minerva',
            minYear: 1954,
            maxYear: 1989,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Ingranaggio',
            minYear: 1977,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Le Caravelle di Cristoforo Colombo (1958-1967)',
            minYear: 1958,
            maxYear: 1967,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario de la Unificación de Italia - Proclama del Reino de Italia',
            minYear: 1961,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Nacimiento de Dante Alighieri',
            minYear: 1965,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Nacimiento de Guglielmo Marconi',
            minYear: 1974,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
          NumismaticMotifRule(
            'Bimilenario de Virgilio',
            minYear: 1981,
            material: NumismaticMaterialsRegistry.nameSilverGeneric,
          ),
        ],
      ),
    ],
  ),

  // 15.3 Italia - República Italiana 2ª Era Bimetálicas (1982–2001)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.italia,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Italina / Cornucopia',
            minYear: 1982,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Spiga / Olivo',
            minYear: 1982,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Timone / Delfino',
            minYear: 1982,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Spighe / Aratro',
            minYear: 1982,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Quercia',
            minYear: 1982,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Vulcano Micro',
            minYear: 1990,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Minerva Micro',
            minYear: 1990,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Ingranaggio - Engranaje Industrial (1977-2001)',
            minYear: 1982,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Centenario de la Aeronautica Militare',
            minYear: 1993,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Centenario del Nacimiento de Maria Montessori',
            minYear: 1990,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            '70 Aniversario de la Guardia di Finanza',
            minYear: 1996,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            '50 Aniversario de la Declaración Universal de los Derechos Humanos',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Piazza del Quirinale y Valor en Braille (1982-2001)',
            minYear: 1982,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Centenario del Banco de Italia',
            minYear: 1993,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Centenario de Luca Pacioli',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            '70 Aniversario del ISTAT',
            minYear: 1996,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            '50 Aniversario de la Policía de Tráfico Polizia Stradale',
            minYear: 1997,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Centenario de la Federación Italiana de Fútbol FIGC',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            '20 Años del IFAD',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Elecciones al Parlamento Europeo',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Mapa de la Unión Europea con Fronteras Erróneas',
            minYear: 1997,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
          NumismaticMotifRule(
            'Mapa de la Unión Europea con Fronteras Corregidas (1997-1998)',
            minYear: 1997,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameBimetallicGeneric,
          ),
        ],
      ),
    ],
  ),
];
