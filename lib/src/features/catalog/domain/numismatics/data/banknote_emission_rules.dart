import 'numismatic_countries_registry.dart';
import 'numismatic_currencies_registry.dart';
import 'numismatic_denominations_registry.dart';
import 'numismatic_materials_registry.dart';
import '../models/numismatic_models.dart';

/// Banknote emission rules across all supported countries and eras.
const List<NumismaticEmissionRuleData> banknoteEmissionRules = [
  // B1.0 México Billetes - Primer Imperio Mexicano (1823)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.imperioMexicano,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Primer Imperio Mexicano - Águila Imperial',
            minYear: 1823,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.namePaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Primer Imperio Mexicano - Águila Imperial',
            minYear: 1823,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.namePaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Primer Imperio Mexicano - Águila Imperial',
            minYear: 1823,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.namePaper,
          ),
        ],
      ),
    ],
  ),

  // B1.0b México Billetes - Comisión Monetaria (1920)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Comisión Monetaria - Escudo Nacional',
            minYear: 1920,
            maxYear: 1920,
            material: NumismaticMaterialsRegistry.namePaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Comisión Monetaria - Escudo Nacional',
            minYear: 1920,
            maxYear: 1920,
            material: NumismaticMaterialsRegistry.namePaper,
          ),
        ],
      ),
    ],
  ),

  // B1.1 México Billetes - Época Revolucionaria y Pre-Banco de México (1913–1924)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cartón Fraccionario Revolucionario',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cartón Fraccionario Revolucionario',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cartón Fraccionario Revolucionario',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Billete Fraccionario Revolucionario',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Cuauhtémoc',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Morelos',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Hidalgo',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Juárez',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Madero',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Carranza',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Zaragoza',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Allende',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gobierno Constitucionalista / Cuauhtémoc',
            minYear: 1913,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B1.2 México Billetes - Primeras Emisiones Banco de México / ABNC (1925–1978)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 1936,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Monumento a la Independencia',
            minYear: 1925,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'La Gitana / Josefa Ortiz de Domínguez',
            minYear: 1925,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'La Tehuana / Miguel Hidalgo',
            minYear: 1925,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Josefa Ortiz de Domínguez',
            minYear: 1925,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Ignacio Allende',
            minYear: 1925,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Miguel Hidalgo y Costilla',
            minYear: 1925,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'José María Morelos y Pavón',
            minYear: 1925,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cuauhtémoc',
            minYear: 1925,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Los Niños Héroes',
            minYear: 1953,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Matías Romero',
            minYear: 1943,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B1.3 México Billetes - Familia AA Fábrica de Billetes Banxico (1969–1992)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Josefa Ortiz de Domínguez',
            minYear: 1969,
            maxYear: 1972,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Miguel Hidalgo',
            minYear: 1969,
            maxYear: 1977,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'José María Morelos',
            minYear: 1969,
            maxYear: 1977,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez',
            minYear: 1973,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Venustiano Carranza',
            minYear: 1974,
            maxYear: 1982,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Francisco I. Madero',
            minYear: 1979,
            maxYear: 1984,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Sor Juana Inés de la Cruz',
            minYear: 1978,
            maxYear: 1985,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B1.4 México Billetes - Familia A Altas Denominaciones Inflacionarias (1979–1992)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Justo Sierra',
            minYear: 1983,
            maxYear: 1989,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Los Niños Héroes',
            minYear: 1980,
            maxYear: 1989,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Lázaro Cárdenas',
            minYear: 1982,
            maxYear: 1991,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Andrés Quintana Roo',
            minYear: 1985,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cuauhtémoc',
            minYear: 1986,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plutarco Elías Calles',
            minYear: 1988,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B1.5 México Billetes - Familia B Nuevos Pesos N$ (1993–1995)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Lázaro Cárdenas',
            minYear: 1993,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Andrés Quintana Roo',
            minYear: 1993,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Cuauhtémoc',
            minYear: 1993,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Plutarco Elías Calles',
            minYear: 1993,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B1.6 México Billetes - Familia C (1994–2001)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Emiliano Zapata',
            minYear: 1994,
            maxYear: 2000,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez',
            minYear: 1994,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'José María Morelos',
            minYear: 1994,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nezahualcóyotl',
            minYear: 1994,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Sor Juana Inés de la Cruz',
            minYear: 1994,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Ignacio Zaragoza',
            minYear: 1994,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B1.7 México Billetes - Familia D y D1 Introducción de Polímero (2002–2007)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Emiliano Zapata',
            minYear: 2002,
            maxYear: 2004,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez',
            minYear: 2002,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'José María Morelos',
            minYear: 2002,
            maxYear: 2006,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nezahualcóyotl',
            minYear: 2002,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Sor Juana Inés de la Cruz',
            minYear: 2002,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Ignacio Zaragoza',
            minYear: 2002,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B1.8 México Billetes - Familia F y Conmemorativos del Centenario/Bicentenario (2006–2019)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez / Monte Albán',
            minYear: 2006,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'José María Morelos / Acueducto de Morelia',
            minYear: 2006,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nezahualcóyotl / Tenochtitlan',
            minYear: 2006,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
          NumismaticMotifRule(
            'Centenario de la Revolución Mexicana',
            minYear: 2009,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
          NumismaticMotifRule(
            'Centenario de la Constitución Política de 1917',
            minYear: 2016,
            maxYear: 2017,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Sor Juana Inés de la Cruz / Hacienda de Panoaya',
            minYear: 2006,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Independencia de México',
            minYear: 2009,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Diego Rivera y Frida Kahlo',
            minYear: 2010,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Miguel Hidalgo / Universidad de Guanajuato',
            minYear: 2008,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B1.9 México Billetes - Familia G en Circulación y Polímeros de Vanguardia (2020–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.mexico,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez / Monte Albán',
            minYear: 2020,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Independencia Nacional',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Fundación de Tenochtitlan / Ajolote y Xochimilco',
            minYear: 2020,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Sor Juana Inés de la Cruz / Bosques Templados y Mariposa Monarca',
            minYear: 2020,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Miguel Hidalgo y José María Morelos / Reserva El Pinacate',
            minYear: 2019,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez / Ballena Gris El Vizcaíno',
            minYear: 2018,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Madero, Hermila Galindo y Carmen Serdán / Calakmul',
            minYear: 2020,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B2.1 Estados Unidos Billetes - Large Size Notes (1861–1927)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.estadosUnidos,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'George Washington / Chase / History Instructing Youth',
            minYear: 1862,
            maxYear: 1923,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Alexander Hamilton / Thomas Jefferson',
            minYear: 1862,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Chief Onepapa / Abraham Lincoln / Woodchopper',
            minYear: 1861,
            maxYear: 1923,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Bison / Daniel Webster / Michael Hillegas',
            minYear: 1861,
            maxYear: 1923,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Alexander Hamilton / Stephen Decatur / George Washington',
            minYear: 1861,
            maxYear: 1923,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Henry Clay / Benjamin Franklin / Ulysses S. Grant',
            minYear: 1861,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Abraham Lincoln / Thomas Hart Benton',
            minYear: 1861,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Alexander Hamilton / John Marshall',
            minYear: 1861,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Robert Morris / DeWitt Clinton / Alexander Hamilton',
            minYear: 1861,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'James Madison',
            minYear: 1878,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Salmon P. Chase',
            minYear: 1878,
            maxYear: 1918,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B2.2 Estados Unidos Billetes - Small Size Federal Reserve Notes (1928–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.estadosUnidos,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'George Washington / Great Seal',
            minYear: 1928,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Thomas Jefferson / Declaration of Independence',
            minYear: 1928,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Abraham Lincoln / Lincoln Memorial',
            minYear: 1928,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Alexander Hamilton / US Treasury',
            minYear: 1928,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Andrew Jackson / White House',
            minYear: 1928,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Ulysses S. Grant / US Capitol',
            minYear: 1928,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Benjamin Franklin / Independence Hall',
            minYear: 1928,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'William McKinley',
            minYear: 1928,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Grover Cleveland',
            minYear: 1928,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'James Madison',
            minYear: 1928,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Salmon P. Chase',
            minYear: 1928,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100000,
        currency: NumismaticCurrenciesRegistry.usd,
        motifs: [
          NumismaticMotifRule(
            'Woodrow Wilson',
            minYear: 1934,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B3.1 España Billetes - Era de la Peseta (1874–2001)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.espana,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Dama de Elche / Quijote',
            minYear: 1937,
            maxYear: 1953,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'República / Santa María',
            minYear: 1938,
            maxYear: 1951,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Jaime I / Séneca',
            minYear: 1935,
            maxYear: 1954,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Rosalía de Castro / Alfonso X',
            minYear: 1935,
            maxYear: 1953,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d25,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Calderón de la Barca / Álvaro de Bazán',
            minYear: 1928,
            maxYear: 1954,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Velázquez / Eduardo Rosales',
            minYear: 1928,
            maxYear: 1971,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Cervantes / Manuel de Falla',
            minYear: 1925,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Leopoldo Alas Clarín',
            minYear: 1980,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Francisco de Zurbarán / Rosalía de Castro / Menéndez Pidal',
            minYear: 1928,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Benito Pérez Galdós / José Celestino Mutis / Hernán Cortés',
            minYear: 1874,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Juan Ramón Jiménez / José Celestino Mutis',
            minYear: 1980,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Rey Juan Carlos I / Cristóbal Colón',
            minYear: 1976,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.esp,
        motifs: [
          NumismaticMotifRule(
            'Rey Juan Carlos I y Príncipe Felipe',
            minYear: 1985,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B3.2 España & Unión Europea Billetes - Era del Euro (2002–presente)
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.espana,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Clásica',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Románica',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Gótica',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Renacentista',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Barroca y Rococó',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Modernista del Hierro y Cristal',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Moderna del Siglo XX',
            minYear: 2002,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.unionEuropea,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Clásica',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Románica',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Gótica',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Renacentista',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Barroca y Rococó',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Modernista del Hierro y Cristal',
            minYear: 2002,
            maxYear: 2024,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.eur,
        motifs: [
          NumismaticMotifRule(
            'Arquitectura Moderna del Siglo XX',
            minYear: 2002,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B4.1 Guatemala Billetes - Quetzales Clásicos y Modernos (1948–2006)
  // Ref General: Banco de Guatemala - Historia de los Billetes de Quetzal: https://www.banguat.gob.gt
  // Denominación - Modelo / Referencias:
  // - 0.50, 1, 5, 10, 20, 50, 100 Quetzales (Tecún Umán, José María Orellana, Justo Rufino Barrios, Miguel García Granados, Mariano Gálvez, Carlos Mérida, Francisco Marroquín): https://www.banguat.gob.gt
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.guatemala,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Tecún Umán / Templo I de Tikal',
            minYear: 1972,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'General José María Orellana',
            minYear: 1948,
            maxYear: 2006,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'General Justo Rufino Barrios',
            minYear: 1948,
            maxYear: 2006,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'General Miguel García Granados',
            minYear: 1948,
            maxYear: 2006,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Doctor Mariano Gálvez',
            minYear: 1948,
            maxYear: 2006,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Licenciado Carlos Mérida',
            minYear: 1974,
            maxYear: 2006,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Obispo Francisco Marroquín',
            minYear: 1972,
            maxYear: 2006,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B4.2 Guatemala Billetes - Era de Polímero y Familias Actuales (2007–presente)
  // Ref General: Banco de Guatemala - Billetes de 1 y 5 Quetzales en Polímero:
  // https://www.banguat.gob.gt
  // Denominación - Modelo / Referencias:
  // - 1 Quetzal (Polímero - General José María Orellana): https://www.banguat.gob.gt
  // - 5 Quetzales (Polímero - General Justo Rufino Barrios): https://www.banguat.gob.gt
  // - 10, 20, 50, 100, 200 Quetzales (Papel de algodón): https://www.banguat.gob.gt
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.guatemala,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'General José María Orellana',
            minYear: 2007,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'General Justo Rufino Barrios',
            minYear: 2011,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'General Miguel García Granados',
            minYear: 2007,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Doctor Mariano Gálvez',
            minYear: 2007,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Licenciado Carlos Mérida',
            minYear: 2007,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Obispo Francisco Marroquín',
            minYear: 2007,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.gtq,
        motifs: [
          NumismaticMotifRule(
            'Compositores de Marimba (Hurtado, Valverde y Alcántara)',
            minYear: 2009,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B5.1 Colombia Billetes - Pesos Oro (1960–1993)
  // Ref General: Banco de la República - Billetes antiguos colombianos: https://www.banrep.gov.co
  // Denominación - Modelo / Referencias:
  // - 1 a 10000 Pesos Oro (Santander, Bolívar, Nariño, Caldas, Camilo Torres, Policarpa Salavarrieta): https://www.banrep.gov.co
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.colombia,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Santander y Bolívar',
            minYear: 1960,
            maxYear: 1974,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Policarpa Salavarrieta',
            minYear: 1960,
            maxYear: 1977,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'José María Córdova',
            minYear: 1960,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Antonio Nariño',
            minYear: 1960,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Francisco José de Caldas',
            minYear: 1960,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Camilo Torres',
            minYear: 1960,
            maxYear: 1986,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Antonio Nariño',
            minYear: 1960,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'José Celestino Mutis',
            minYear: 1974,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Francisco de Paula Santander',
            minYear: 1981,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Jorge Eliécer Gaitán',
            minYear: 1982,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Simón Bolívar / Paso del Ejército Libertador',
            minYear: 1984,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Rafael Núñez / Miguel Antonio Caro',
            minYear: 1986,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Mujer Indígena Emberá',
            minYear: 1992,
            maxYear: 1993,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B5.2 Colombia Billetes - Pesos y Nueva Familia de Billetes (1994–presente)
  // Ref General: Banco de la República - Nueva Familia de Billetes:
  // https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
  // Denominación - Modelo / Referencias:
  // - 1000 Pesos (Jorge Eliécer Gaitán): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
  // - 2000 Pesos (Débora Arango / Caño Cristales): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
  // - 5000 Pesos (José Asunción Silva / Páramos): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
  // - 10000 Pesos (Virginia Gutiérrez / Amazonia): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
  // - 20000 Pesos (Alfonso López Michelsen / Canales de La Mojana): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
  // - 50000 Pesos (Gabriel García Márquez / Ciudad Perdida): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
  // - 100000 Pesos (Carlos Lleras Restrepo / Valle de Cocora): https://www.banrep.gov.co/es/billetes-monedas/billetes-circulacion
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.colombia,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Jorge Eliécer Gaitán',
            minYear: 2001,
            maxYear: 2016,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Débora Arango / Caño Cristales',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'José Asunción Silva / Páramos',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Virginia Gutiérrez / Amazonia',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Alfonso López Michelsen / Sistema Hidráulico Zenú',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Gabriel García Márquez / Ciudad Perdida',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100000,
        currency: NumismaticCurrenciesRegistry.cop,
        motifs: [
          NumismaticMotifRule(
            'Carlos Lleras Restrepo / Valle de Cocora',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B6.1 Canadá Billetes - Scenes of Canada, Birds & Journey Series (1935–2010)
  // Ref General: Bank of Canada - Bank Note Series:
  // https://www.bankofcanada.ca/banknotes/bank-note-series/
  // Denominación - Modelo / Referencias:
  // - 1, 2, 5, 10, 20, 50, 100, 1000 Dollars (Scenes of Canada, Birds of Canada, Canadian Journey Series): https://www.bankofcanada.ca/banknotes/bank-note-series/
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.canada,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Reina Isabel II / Parlamento de Ottawa',
            minYear: 1973,
            maxYear: 1989,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Reina Isabel II / Petirrojos Americanos',
            minYear: 1986,
            maxYear: 1996,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Sir Wilfrid Laurier / Deportes de Invierno',
            minYear: 2001,
            maxYear: 2013,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Sir John A. Macdonald / Recuerdo y Paz',
            minYear: 2001,
            maxYear: 2013,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Reina Isabel II / Arte Indígena Haida',
            minYear: 2004,
            maxYear: 2012,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'W.L. Mackenzie King / Las Cinco Valientes',
            minYear: 2004,
            maxYear: 2012,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Sir Robert Borden / Innovación y Telecomunicaciones',
            minYear: 2004,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Reina Isabel II / Picogordos Sombríos',
            minYear: 1988,
            maxYear: 2000,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B6.2 Canadá Billetes - Frontier Polymer Series (2011–presente)
  // Ref General: Bank of Canada - Polymer Series:
  // https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
  // Denominación - Modelo / Referencias:
  // - 5 Dollars (Polímero - Sir Wilfrid Laurier / Canadarm2): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
  // - 10 Dollars (Polímero - Sir John A. Macdonald / Viola Desmond / The Canadian Train): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
  // - 20 Dollars (Polímero - Reina Isabel II / Canadian National Vimy Memorial): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
  // - 50 Dollars (Polímero - W.L. Mackenzie King / CCGS Amundsen): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
  // - 100 Dollars (Polímero - Sir Robert Borden / Innovación Médica e Insulina): https://www.bankofcanada.ca/banknotes/bank-note-series/polymer-series/
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.canada,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Sir Wilfrid Laurier / Innovación Espacial Canadarm2',
            minYear: 2013,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Viola Desmond / Tren Transcontinental de Canadá',
            minYear: 2013,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Reina Isabel II / Monumento Conmemorativo de Vimy',
            minYear: 2012,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'W.L. Mackenzie King / CCGS Amundsen en el Ártico',
            minYear: 2012,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.cad,
        motifs: [
          NumismaticMotifRule(
            'Sir Robert Borden / Descubrimiento de la Insulina',
            minYear: 2011,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
    ],
  ),

  // B7.1 Cuba Billetes - Período Socialista y Régimen Dual (1961–2020)
  // Ref General: Banco Central de Cuba - Billetes Históricos: https://www.bc.gob.cu
  // Denominación - Modelo / Referencias:
  // - 1 a 1000 Pesos (José Martí, Che Guevara, Antonio Maceo, Máximo Gómez, Camilo Cienfuegos, Calixto García, Frank País, Ignacio Agramonte, Julio Antonio Mella): https://www.bc.gob.cu
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.cuba,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'José Martí / Entrada de Fidel Castro a La Habana',
            minYear: 1961,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Ernesto "Che" Guevara / Cortador de Caña',
            minYear: 1983,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Antonio Maceo / Protesta de Baraguá',
            minYear: 1961,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Máximo Gómez / Guerra de Todo el Pueblo',
            minYear: 1961,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Camilo Cienfuegos / Trabajo Voluntario',
            minYear: 1961,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Calixto García / Centro de Ingeniería Genética',
            minYear: 1961,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Carlos Manuel de Céspedes / Estatua de José Martí',
            minYear: 1961,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Frank País / Ciudad Escolar 26 de Julio',
            minYear: 2010,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Ignacio Agramonte / Asamblea de Guáimaro',
            minYear: 2010,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Julio Antonio Mella / Universidad de La Habana',
            minYear: 2010,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B7.2 Cuba Billetes - Unificación Monetaria (2021–presente)
  // Ref General: Banco Central de Cuba - Ordenamiento Monetario: https://www.bc.gob.cu
  // Denominación - Modelo / Referencias:
  // - 1 a 1000 Pesos (José Martí, Che Guevara, Antonio Maceo, Máximo Gómez, Camilo Cienfuegos, Calixto García, Frank País, Ignacio Agramonte, Julio Antonio Mella): https://www.bc.gob.cu
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.cuba,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'José Martí / Entrada de Fidel Castro a La Habana',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d3,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Ernesto "Che" Guevara / Cortador de Caña',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Antonio Maceo / Protesta de Baraguá',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Máximo Gómez / Guerra de Todo el Pueblo',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Camilo Cienfuegos / Trabajo Voluntario',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Calixto García / Centro de Ingeniería Genética',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Carlos Manuel de Céspedes / Estatua de José Martí',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Frank País / Ciudad Escolar 26 de Julio',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Ignacio Agramonte / Asamblea de Guáimaro',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.cup,
        motifs: [
          NumismaticMotifRule(
            'Julio Antonio Mella / Universidad de La Habana',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B8.1 Argentina Billetes - Peso Convertible y Emisiones Modernas (1992–presente)
  // Ref General: Banco Central de la República Argentina - Billetes en circulación:
  // https://www.bcra.gob.ar/mediospago/billetes_emisiones_vigentes.asp
  // Denominación - Modelo / Referencias:
  // - 1 Peso (Carlos Pellegrini): https://www.bcra.gob.ar
  // - 2 Pesos (Bartolomé Mitre): https://www.bcra.gob.ar
  // - 5 Pesos (General José de San Martín): https://www.bcra.gob.ar
  // - 10 Pesos (Manuel Belgrano): https://www.bcra.gob.ar
  // - 20 Pesos (Juan Manuel de Rosas / Guanaco): https://www.bcra.gob.ar
  // - 50 Pesos (Domingo Faustino Sarmiento / Islas Malvinas / Cóndor Andino): https://www.bcra.gob.ar
  // - 100 Pesos (Julio Argentino Roca / Eva Duarte de Perón / Taruca): https://www.bcra.gob.ar
  // - 200 Pesos (Ballena Franca Austral): https://www.bcra.gob.ar
  // - 500 Pesos (Yaguareté): https://www.bcra.gob.ar
  // - 1000 Pesos (Hornero / José de San Martín): https://www.bcra.gob.ar
  // - 2000 Pesos (Cecilia Grierson y Ramón Carrillo / Instituto Malbrán): https://www.bcra.gob.ar
  // - 10000 Pesos (Manuel Belgrano y María Remedios del Valle): https://www.bcra.gob.ar
  // - 20000 Pesos (Juan Bautista Alberdi): https://www.bcra.gob.ar
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.argentina,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Carlos Pellegrini / Congreso Nacional',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Bartolomé Mitre / Museo Mitre',
            minYear: 1992,
            maxYear: 2018,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'General José de San Martín / Monumento Cerro de la Gloria',
            minYear: 1992,
            maxYear: 2020,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Manuel Belgrano / Monumento a la Bandera',
            minYear: 1992,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Guanaco / Estepa Patagónica',
            minYear: 1992,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Cóndor Andino / Cordillera de los Andes',
            minYear: 1992,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Taruca / Región Noroeste',
            minYear: 1992,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Ballena Franca Austral / Mar Argentino',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Yaguareté / Región Noreste',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Hornero / Región Pampeana',
            minYear: 2017,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Cecilia Grierson y Ramón Carrillo / Instituto Malbrán',
            minYear: 2023,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Manuel Belgrano y María Remedios del Valle',
            minYear: 2024,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20000,
        currency: NumismaticCurrenciesRegistry.ars,
        motifs: [
          NumismaticMotifRule(
            'Juan Bautista Alberdi',
            minYear: 2024,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B9.1 Brasil Billetes - Real 1ª y 2ª Familia (1994–presente)
  // Ref General: Banco Central do Brasil - Cédulas do Real:
  // https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  // Denominación - Modelo / Referencias:
  // - 1 Real (Beija-flor): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  // - 2 Reais (Tartaruga-marinha): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  // - 5 Reais (Garça): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  // - 10 Reais (Arara / Conmemorativa Polímero Cabral 2000): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  // - 20 Reais (Mico-leão-dourado): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  // - 50 Reais (Onça-pintada): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  // - 100 Reais (Garoupa): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  // - 200 Reais (Lobo-guará): https://www.bcb.gov.br/cedulasemoedas/cedulasreal
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.brasil,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efígie da República / Beija-flor',
            minYear: 1994,
            maxYear: 2005,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efígie da República / Tartaruga-marinha',
            minYear: 2001,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efígie da República / Garça',
            minYear: 1994,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efígie da República / Arara',
            minYear: 1994,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efígie da República / Mico-leão-dourado',
            minYear: 2002,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efígie da República / Onça-pintada',
            minYear: 1994,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efígie da República / Garoupa',
            minYear: 1994,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.brl,
        motifs: [
          NumismaticMotifRule(
            'Efígie da República / Lobo-guará',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B10.1 Chile Billetes - Peso Chileno y Familias Bicentenario (1975–presente)
  // Ref General: Banco Central de Chile - Billetes en circulación:
  // https://www.bcentral.cl/billetes-y-monedas/billetes
  // Denominación - Modelo / Referencias:
  // - 500 Pesos (Papel de algodón - Raúl Silva Henríquez): https://www.bcentral.cl/billetes-y-monedas/billetes
  // - 1000 Pesos (Polímero - Ignacio Carrera Pinto / Torres del Paine): https://www.bcentral.cl/billetes-y-monedas/billetes
  // - 2000 Pesos (Polímero - Manuel Rodríguez / Reserva Nalcas): https://www.bcentral.cl/billetes-y-monedas/billetes
  // - 5000 Pesos (Polímero - Gabriela Mistral / Parque La Campana): https://www.bcentral.cl/billetes-y-monedas/billetes
  // - 10000 Pesos (Papel de algodón - Arturo Prat / Parque Alberto de Agostini): https://www.bcentral.cl/billetes-y-monedas/billetes
  // - 20000 Pesos (Papel de algodón - Andrés Bello / Salar de Surire): https://www.bcentral.cl/billetes-y-monedas/billetes
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.chile,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            'Cardenal Raúl Silva Henríquez / Santuario de Maipú',
            minYear: 1977,
            maxYear: 2000,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            'Ignacio Carrera Pinto / Torres del Paine',
            minYear: 2011,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            'Manuel Rodríguez / Reserva Nacional Nalcas',
            minYear: 2009,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            'Gabriela Mistral / Parque Nacional La Campana',
            minYear: 2009,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            'Arturo Prat / Parque Nacional Alberto de Agostini',
            minYear: 2010,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20000,
        currency: NumismaticCurrenciesRegistry.clp,
        motifs: [
          NumismaticMotifRule(
            'Andrés Bello / Salar de Surire',
            minYear: 2010,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B11.1 Perú Billetes - Nuevo Sol y Familias Bicentenario (1991–presente)
  // Ref General: Banco Central de Reserva del Perú - Billetes en circulación:
  // https://www.bcrp.gob.pe/billetes-y-monedas/billetes.html
  // Denominación - Modelo / Referencias:
  // - 10 Soles (José Abelardo Quiñones / Chabuca Granda): https://www.bcrp.gob.pe
  // - 20 Soles (Raúl Porras Barrenechea / José María Arguedas): https://www.bcrp.gob.pe
  // - 50 Soles (Abraham Valdelomar / María Rostworowski): https://www.bcrp.gob.pe
  // - 100 Soles (Jorge Basadre / Pedro Paulet): https://www.bcrp.gob.pe
  // - 200 Soles (Santa Rosa de Lima / Tilsa Tsuchiya): https://www.bcrp.gob.pe
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.peru,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            'Chabuca Granda / Vicuña y Flor de Amancaes',
            minYear: 1991,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            'José María Arguedas / Cóndor Andino',
            minYear: 1991,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            'María Rostworowski / Jaguar',
            minYear: 1991,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            'Pedro Paulet / Colibrí Cola de Espátula',
            minYear: 1991,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.pen,
        motifs: [
          NumismaticMotifRule(
            'Tilsa Tsuchiya / Gallito de las Rocas',
            minYear: 1991,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B12.1 Reino Unido Billetes - Series D, E, F y Polymer Series (1970–presente)
  // Ref General: Bank of England - Current Banknotes & Polymer Series:
  // https://www.bankofengland.co.uk/banknotes
  // Denominación - Modelo / Referencias:
  // - 5 Pounds (Polímero - Sir Winston Churchill / Queen Elizabeth II / King Charles III): https://www.bankofengland.co.uk/banknotes
  // - 10 Pounds (Polímero - Jane Austen / Queen Elizabeth II / King Charles III): https://www.bankofengland.co.uk/banknotes
  // - 20 Pounds (Polímero - J.M.W. Turner / Queen Elizabeth II / King Charles III): https://www.bankofengland.co.uk/banknotes
  // - 50 Pounds (Polímero - Alan Turing / Queen Elizabeth II / King Charles III): https://www.bankofengland.co.uk/banknotes
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.reinoUnido,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Sir Winston Churchill / Palacio de Westminster',
            minYear: 2016,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Jane Austen / Godmersham Park',
            minYear: 2017,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'J.M.W. Turner / El «Temerario»',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.gbp,
        motifs: [
          NumismaticMotifRule(
            'Alan Turing / Bombe de Bletchley Park',
            minYear: 2021,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.namePolymer,
          ),
        ],
      ),
    ],
  ),

  // B13.1 Francia Billetes - Nouveau Franc (1960–2001)
  // Ref General: Banque de France - Histoire des billets: https://www.banque-france.fr
  // Denominación - Modelo / Referencias:
  // - 5, 10, 20, 50, 100, 200, 500 Francs (Victor Hugo, Voltaire, Berlioz, Debussy, Quentin de La Tour, Saint-Exupéry, Delacroix, Cézanne, Gustave Eiffel, Pierre et Marie Curie): https://www.banque-france.fr
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.francia,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Victor Hugo / Plaza de los Vosgos',
            minYear: 1960,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Hector Berlioz / Capilla de los Inválidos',
            minYear: 1960,
            maxYear: 1980,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Claude Debussy / El Mar',
            minYear: 1980,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Antoine de Saint-Exupéry / El Principito',
            minYear: 1976,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Paul Cézanne / Montagne Sainte-Victoire',
            minYear: 1978,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Gustave Eiffel / Torre Eiffel',
            minYear: 1981,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.frf,
        motifs: [
          NumismaticMotifRule(
            'Pierre y Marie Curie / Radium',
            minYear: 1968,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B14.1 Alemania Billetes - Deutsche Mark Series (1948–2001)
  // Ref General: Deutsche Bundesbank - DM-Banknoten:
  // https://www.bundesbank.de/de/aufgaben/bargeld/dm-banknoten-und-dm-muenzen
  // Denominación - Modelo / Referencias:
  // - 5, 10, 20, 50, 100, 200, 500, 1000 DM (Bettina von Arnim, Gauss, Droste-Hülshoff, Neumann, Clara Schumann, Paul Ehrlich, Maria Sibylla Merian, Gebrüder Grimm): https://www.bundesbank.de
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.alemania,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Bettina von Arnim / Castillo Wiepersdorf',
            minYear: 1990,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Carl Friedrich Gauss / Campana de Gauss',
            minYear: 1989,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Annette von Droste-Hülshoff / Castillo Meersburg',
            minYear: 1989,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Balthasar Neumann / Residencia de Wurzburgo',
            minYear: 1989,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Clara Schumann / Conservatorio Hoch de Fráncfort',
            minYear: 1989,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Paul Ehrlich / Microscopio y Quimioterapia',
            minYear: 1989,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Maria Sibylla Merian / Diente de León y Oruga',
            minYear: 1991,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.dem,
        motifs: [
          NumismaticMotifRule(
            'Wilhelm y Jacob Grimm / Diccionario Alemán',
            minYear: 1991,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),

  // B15.1 Italia Billetes - Lira Italiana (1946–2001)
  // Ref General: Banca d'Italia - Banconote della Lira: https://www.bancaditalia.it
  // Denominación - Modelo / Referencias:
  // - 500, 1000, 2000, 5000, 10000, 50000, 100000, 500000 Liras (Mercurio, Verdi, Montessori, Galilei, Marconi, Colombo, Bellini, Volta, Bernini, Caravaggio, Raffaello): https://www.bancaditalia.it
  NumismaticEmissionRuleData(
    country: NumismaticCountriesRegistry.italia,
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Cabeza de Mercurio',
            minYear: 1966,
            maxYear: 1979,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Maria Montessori / Niños en clase',
            minYear: 1969,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2000,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Guglielmo Marconi / Yate Elettra',
            minYear: 1973,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Vincenzo Bellini / Teatro Massimo Bellini',
            minYear: 1979,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10000,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Alessandro Volta / Tempio Voltiano',
            minYear: 1976,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50000,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Gian Lorenzo Bernini / Escultura de Apolo y Dafne',
            minYear: 1984,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100000,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Michelangelo Merisi da Caravaggio / Cesto de Frutas',
            minYear: 1983,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500000,
        currency: NumismaticCurrenciesRegistry.itl,
        motifs: [
          NumismaticMotifRule(
            'Raffaello Sanzio / Triunfo de Galatea',
            minYear: 1997,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameCottonPaper,
          ),
        ],
      ),
    ],
  ),
];
