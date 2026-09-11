import 'numismatic_countries_registry.dart';
import 'numismatic_currencies_registry.dart';
import 'numismatic_denominations_registry.dart';
import 'numismatic_materials_registry.dart';
import '../models/numismatic_models.dart';

/// Historical emission rules for Spain and the European Union (Antiguo Régimen, Pesetas, Euro & Eurozone).
const List<NumismaticEmissionRuleData> spainEmissionRules = [
  // 3.1 España - Antiguo Régimen y Monarquía Hispánica (1500–1868)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.espana,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_16,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Medio Maravedí / Maravedí',
            minYear: 1500,
            maxYear: 1868,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_8,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            '2 Maravedís / 4 Maravedís',
            minYear: 1500,
            maxYear: 1868,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Castillo y León / Maravedís',
            minYear: 1500,
            maxYear: 1868,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Monograma Real Coronado / Columnas y Castillo',
            minYear: 1500,
            maxYear: 1868,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Escudo Real Coronado / Columnario y Busto',
            minYear: 1500,
            maxYear: 1868,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Pistolete / Dos Reales',
            minYear: 1500,
            maxYear: 1868,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Medio Duro',
            minYear: 1500,
            maxYear: 1868,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.real,
        motifs: [
          NumismaticMotifRule(
            'Real de a Ocho / Columnario / Busto / Duro',
            minYear: 1500,
            maxYear: 1868,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
    ],
  ),

  // 3.2 España - Peseta Clásica (1869–1939)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.espana,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Peseta',
            minYear: 1870,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Peseta',
            minYear: 1870,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Peseta',
            minYear: 1870,
            maxYear: 1879,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Peseta',
            minYear: 1870,
            maxYear: 1879,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Con agujero',
            minYear: 1925,
            maxYear: 1937,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Hispania Recostada / Reyes Alfonso XII y XIII',
            minYear: 1869,
            maxYear: 1926,
            material: NumismaticMaterialsRegistry.nameSilver835,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            '',
            minYear: 1869,
            maxYear: 1937,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Hispania / Bustos Reales',
            minYear: 1869,
            maxYear: 1905,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Duro',
            minYear: 1869,
            maxYear: 1899,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Alfonso XII',
            minYear: 1878,
            maxYear: 1879,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Alfonso XIII',
            minYear: 1889,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d25,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Alfonso XII',
            minYear: 1876,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Hispania de Pie / Busto de Alfonso XIII Niño',
            minYear: 1870,
            maxYear: 1897,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 3.3 España - Peseta del Estado Español y Transición (1940–1981)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.espana,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Jinete Ibérico',
            minYear: 1940,
            maxYear: 1953,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Jinete Ibérico',
            minYear: 1940,
            maxYear: 1959,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Timón y Ancla con agujero',
            minYear: 1949,
            maxYear: 1975,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Rubia de Franco / Juan Carlos I',
            minYear: 1944,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2_5,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Franco',
            minYear: 1953,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Duro de Franco / Juan Carlos I',
            minYear: 1949,
            maxYear: 1980,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d25,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Agujero',
            minYear: 1957,
            maxYear: 1980,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Franco / Juan Carlos I',
            minYear: 1957,
            maxYear: 1980,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Franco',
            minYear: 1966,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
          NumismaticMotifRule(
            'Juan Carlos I',
            minYear: 1975,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
    ],
  ),

  // 3.4 España - Peseta Moderna y Monedas Autonómicas (1982–2001)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.espana,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Busto del Rey Juan Carlos I / Escudo de España',
            minYear: 1983,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'España 82',
            minYear: 1980,
            maxYear: 1989,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Grande / Lenteja',
            minYear: 1982,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'España 82',
            minYear: 1982,
            maxYear: 1984,
            material: NumismaticMaterialsRegistry.nameAluminum,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Busto del Rey Juan Carlos I / Numeral 5 PTAS',
            minYear: 1989,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Busto del Rey Juan Carlos I / Homenajes Culturales',
            minYear: 1983,
            maxYear: 2000,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d25,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Corona Real y Letra M',
            minYear: 1990,
            maxYear: 2000,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos de Barcelona 92',
            minYear: 1990,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Castilla y León',
            minYear: 1993,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'País Vasco',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Canarias',
            minYear: 1995,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Principado de Asturias',
            minYear: 1996,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Castilla-La Mancha',
            minYear: 1997,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Melilla',
            minYear: 1997,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Ceuta',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Comunidad Foral de Navarra',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
          NumismaticMotifRule(
            'Palacio Real de Madrid',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Flor de Lis / Pantalla',
            minYear: 1990,
            maxYear: 2000,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            '20 Duros',
            minYear: 1982,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Rey Juan Carlos I y Príncipe Felipe / Patrimonio Cultural',
            minYear: 1986,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Reyes Juan Carlos I y Sofía / Escudo Nacional',
            minYear: 1987,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Asamblea del FMI y Banco Mundial - Madrid',
            minYear: 1994,
            material: NumismaticMaterialsRegistry.nameSilverSterling925,
          ),
          NumismaticMotifRule(
            'Presidencia Española del Consejo de la Unión Europea',
            minYear: 1995,
            material: NumismaticMaterialsRegistry.nameSilverSterling925,
          ),
          NumismaticMotifRule(
            'IV Centenario de Don Quijote y Sancho',
            minYear: 1996,
            material: NumismaticMaterialsRegistry.nameSilverSterling925,
          ),
          NumismaticMotifRule(
            '400 Aniversario de Juan de Herrera',
            minYear: 1997,
            material: NumismaticMaterialsRegistry.nameSilverSterling925,
          ),
          NumismaticMotifRule(
            'IV Centenario de la Muerte de Felipe II',
            minYear: 1998,
            material: NumismaticMaterialsRegistry.nameSilverSterling925,
          ),
          NumismaticMotifRule(
            'Año Santo Xacobeo',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameSilverSterling925,
          ),
          NumismaticMotifRule(
            'V Centenario del Nacimiento de Carlos V',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameSilverSterling925,
          ),
          NumismaticMotifRule(
            'Última Emisión de la Peseta - Hispania',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameSilverSterling925,
          ),
        ],
      ),
    ],
  ),

  // 3.5 España - Época del Euro (grabadas físicamente 1999–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.espana,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Catedral de Santiago de Compostela',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Catedral de Santiago de Compostela',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Catedral de Santiago de Compostela',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Miguel de Cervantes',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNordicGold,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Miguel de Cervantes',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNordicGold,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Miguel de Cervantes',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNordicGold,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Rey Juan Carlos I / Rey Felipe VI',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro1,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Efigie del Rey Juan Carlos I / Rey Felipe VI',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'IV Centenario de Don Quijote de la Mancha',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Tratado de Roma',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '10 Años de la Unión Económica y Monetaria',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Centro Histórico de Córdoba - Mezquita-Catedral',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'La Alhambra, Generalife y Albaicín de Granada',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Catedral de Burgos',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '10 Años de los Billetes y Monedas en Euros',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Real Monasterio de San Lorenzo de El Escorial',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Parque Güell - Obras de Antoni Gaudí',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Proclamación de Su Majestad el Rey Felipe VI',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Cueva de Altamira y Arte Rupestre del Norte de España',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '30 Años de la Bandera de la Unión Europea',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Acueducto de Segovia',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Monumentos de Oviedo y del Reino de Asturias',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Nacimiento del Rey Felipe VI',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Ciudad Vieja de Santiago de Compostela',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Murallas y Ciudad Vieja de Ávila',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Arquitectura Mudéjar de Aragón',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Ciudad Histórica de Toledo',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Parque Nacional de Garajonay',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'V Centenario de la Vuelta al Mundo de Juan Sebastián Elcano',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '35 Años del Programa Erasmus',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Ciudad Vieja de Cáceres',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Presidencia Española del Consejo de la Unión Europea',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Catedral, Alcázar y Archivo de Indias de Sevilla',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Policía Nacional',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            'Paisaje de la Luz de Madrid',
            minYear: 2025,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa',
            minYear: 2002,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d12,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa',
            minYear: 2002,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa',
            minYear: 2010,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d30,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa',
            minYear: 2012,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d40,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
    ],
  ),

  // 3.6 Unión Europea (Zona Euro, grabadas físicamente 1999–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.unionEuropea,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Globo Terráqueo',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Globo Terráqueo',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Globo Terráqueo',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCopperPlatedSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Globo Terráqueo',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNordicGold,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Globo Terráqueo',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNordicGold,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Globo Terráqueo',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameNordicGold,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Común',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro1,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Mapa de Europa / Unión Europea',
            minYear: 1999,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '50 Aniversario del Tratado de Roma',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '10 Años de la Unión Económica y Monetaria',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '10 Años de los Billetes y Monedas en Euros',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '30 Años de la Bandera de la Unión Europea',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
          NumismaticMotifRule(
            '35 Años del Programa Erasmus',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicEuro2,
          ),
        ],
      ),
    ],
  ),
];
