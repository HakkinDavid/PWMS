import '../models/numismatic_models.dart';

/// Banknote emission rules across all supported countries and eras.
const List<NumismaticEmissionRuleData> banknoteEmissionRules = [
  // B1.1 México Billetes - Época Revolucionaria y Pre-Banco de México (1823–1924)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1823,
    maxYear: 1924,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cartón Fraccionario Revolucionario', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cartón Fraccionario Revolucionario', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cartón Fraccionario Revolucionario', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Billete Fraccionario Revolucionario', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Cuauhtémoc', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Morelos', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Hidalgo', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Juárez', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Madero', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Carranza', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Zaragoza', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Allende', 1913, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel',
        minYear: 1913,
        maxYear: 1916,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gobierno Constitucionalista / Cuauhtémoc', 1913, 1916),
        ],
      ),
    ],
  ),

  // B1.2 México Billetes - Primeras Emisiones Banco de México / ABNC (1925–1978)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1925,
    maxYear: 1978,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1936,
        maxYear: 1970,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Piedra del Sol (Calendario Azteca)', 1936, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1945,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Monumento a la Independencia', 1925, 1945),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('La Gitana / Josefa Ortiz de Domínguez', 1925, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('La Tehuana / Miguel Hidalgo', 1925, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Josefa Ortiz de Domínguez', 1925, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ignacio Allende', 1925, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Miguel Hidalgo y Costilla', 1925, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José María Morelos y Pavón', 1925, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cuauhtémoc', 1925, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Papel de algodón',
        minYear: 1953,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Los Niños Héroes', 1953, 1978),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 1943,
        maxYear: 1978,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Matías Romero', 1943, 1978),
        ],
      ),
    ],
  ),

  // B1.3 México Billetes - Familia AA Fábrica de Billetes Banxico (1969–1992)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1969,
    maxYear: 1992,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1969,
        maxYear: 1972,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Josefa Ortiz de Domínguez', 1969, 1972),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1969,
        maxYear: 1977,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Miguel Hidalgo', 1969, 1977),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1969,
        maxYear: 1977,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José María Morelos', 1969, 1977),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1973,
        maxYear: 1981,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Benito Juárez', 1973, 1981),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1974,
        maxYear: 1982,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Venustiano Carranza', 1974, 1982),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1979,
        maxYear: 1984,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Francisco I. Madero', 1979, 1984),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1978,
        maxYear: 1985,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sor Juana Inés de la Cruz', 1978, 1985),
        ],
      ),
    ],
  ),

  // B1.4 México Billetes - Familia A Altas Denominaciones Inflacionarias (1979–1992)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1979,
    maxYear: 1992,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Papel de algodón',
        minYear: 1983,
        maxYear: 1989,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Justo Sierra', 1983, 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Papel de algodón',
        minYear: 1980,
        maxYear: 1989,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Los Niños Héroes', 1980, 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 1982,
        maxYear: 1991,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Lázaro Cárdenas', 1982, 1991),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20000',
        material: 'Papel de algodón',
        minYear: 1985,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Andrés Quintana Roo', 1985, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50000',
        material: 'Papel de algodón',
        minYear: 1986,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cuauhtémoc', 1986, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100000',
        material: 'Papel de algodón',
        minYear: 1988,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Plutarco Elías Calles', 1988, 1992),
        ],
      ),
    ],
  ),

  // B1.5 México Billetes - Familia B Nuevos Pesos N$ (1993–1995)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1993,
    maxYear: 1995,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1993,
        maxYear: 1995,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Lázaro Cárdenas', 1993, 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1993,
        maxYear: 1995,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Andrés Quintana Roo', 1993, 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1993,
        maxYear: 1995,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cuauhtémoc', 1993, 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1993,
        maxYear: 1995,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Plutarco Elías Calles', 1993, 1995),
        ],
      ),
    ],
  ),

  // B1.6 México Billetes - Familia C (1994–2001)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1994,
    maxYear: 2001,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2000,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Emiliano Zapata', 1994, 2000),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Benito Juárez', 1994, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José María Morelos', 1994, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Nezahualcóyotl', 1994, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sor Juana Inés de la Cruz', 1994, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ignacio Zaragoza', 1994, 2001),
        ],
      ),
    ],
  ),

  // B1.7 México Billetes - Familia D y D1 Introducción de Polímero (2002–2007)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2002,
    maxYear: 2007,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2004,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Emiliano Zapata', 2002, 2004),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Polímero',
        minYear: 2002,
        maxYear: 2007,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Benito Juárez (Polímero)', 2002, 2007),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2006,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José María Morelos', 2002, 2006),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2007,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Nezahualcóyotl', 2002, 2007),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2007,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sor Juana Inés de la Cruz', 2002, 2007),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2007,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ignacio Zaragoza', 2002, 2007),
        ],
      ),
    ],
  ),

  // B1.8 México Billetes - Familia F y Conmemorativos del Centenario/Bicentenario (2006–2019)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2006,
    maxYear: 2019,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Polímero',
        minYear: 2006,
        maxYear: 2019,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Benito Juárez / Monte Albán', 2006, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Polímero',
        minYear: 2006,
        maxYear: 2019,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José María Morelos / Acueducto de Morelia', 2006, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        allowedMaterials: ['Papel de algodón', 'Polímero'],
        minYear: 2006,
        maxYear: 2019,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Nezahualcóyotl / Tenochtitlan (Circulación Estándar)',
          2006,
          2019,
          ),
          NumismaticMotifRule('Centenario de la Revolución Mexicana', 2009, 2010),
          NumismaticMotifRule('Centenario de la Constitución Política de 1917', 2016, 2017),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2006,
        maxYear: 2019,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sor Juana Inés de la Cruz / Hacienda de Panoaya (Circulación Estándar)',
          2006,
          2019,
          ),
          NumismaticMotifRule('Bicentenario de la Independencia de México', 2009, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 2010,
        maxYear: 2019,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Diego Rivera y Frida Kahlo', 2010, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 2008,
        maxYear: 2019,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Miguel Hidalgo / Universidad de Guanajuato', 2008, 2019),
        ],
      ),
    ],
  ),

  // B1.9 México Billetes - Familia G en Circulación y Polímeros de Vanguardia (2020–presente)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2020,
    maxYear: 2100,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Polímero',
        minYear: 2020,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Benito Juárez / Monte Albán (Familia F1)',
          2020,
          2024,
          ),
          NumismaticMotifRule('Bicentenario de la Independencia Nacional', 2021),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Polímero',
        minYear: 2020,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Fundación de Tenochtitlan / Ajolote y Xochimilco', 2020, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Polímero',
        minYear: 2020,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sor Juana Inés de la Cruz / Bosques Templados y Mariposa Monarca', 2020, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2019,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Miguel Hidalgo y José María Morelos / Reserva El Pinacate', 2019, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 2018,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Benito Juárez / Ballena Gris El Vizcaíno', 2018, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 2020,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Madero, Hermila Galindo y Carmen Serdán / Calakmul', 2020, 2024),
        ],
      ),
    ],
  ),

  // B2.1 Estados Unidos Billetes - Large Size Notes (1861–1927)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    minYear: 1861,
    maxYear: 1927,
    validCurrencies: ['USD'],
    defaultCurrency: 'USD',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1862,
        maxYear: 1923,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('George Washington / Chase / History Instructing Youth', 1862, 1923),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel de algodón',
        minYear: 1862,
        maxYear: 1918,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Alexander Hamilton / Thomas Jefferson', 1862, 1918),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1861,
        maxYear: 1923,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Chief Onepapa / Abraham Lincoln / Woodchopper', 1861, 1923),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1861,
        maxYear: 1923,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Bison / Daniel Webster / Michael Hillegas', 1861, 1923),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1861,
        maxYear: 1923,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Alexander Hamilton / Stephen Decatur / George Washington', 1861, 1923),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1861,
        maxYear: 1918,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Henry Clay / Benjamin Franklin / Ulysses S. Grant', 1861, 1918),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1861,
        maxYear: 1914,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Abraham Lincoln / Thomas Hart Benton', 1861, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1861,
        maxYear: 1918,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Alexander Hamilton / John Marshall', 1861, 1918),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1861,
        maxYear: 1918,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Robert Morris / DeWitt Clinton / Alexander Hamilton', 1861, 1918),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Papel de algodón',
        minYear: 1878,
        maxYear: 1918,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('James Madison', 1878, 1918),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 1878,
        maxYear: 1918,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Salmon P. Chase', 1878, 1918),
        ],
      ),
    ],
  ),

  // B2.2 Estados Unidos Billetes - Small Size Federal Reserve Notes (1928–presente)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    minYear: 1928,
    maxYear: 2100,
    validCurrencies: ['USD'],
    defaultCurrency: 'USD',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('George Washington / Great Seal', 1928, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Thomas Jefferson / Declaration of Independence', 1928, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Abraham Lincoln / Lincoln Memorial', 1928, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Alexander Hamilton / US Treasury', 1928, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Andrew Jackson / White House', 1928, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ulysses S. Grant / US Capitol', 1928, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Benjamin Franklin / Independence Hall', 1928, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 1945,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('William McKinley', 1928, 1945),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 1945,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Grover Cleveland', 1928, 1945),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 1945,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('James Madison', 1928, 1945),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 1945,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Salmon P. Chase', 1928, 1945),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100000',
        material: 'Papel de algodón',
        minYear: 1934,
        maxYear: 1934,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Woodrow Wilson (Gold Certificate)', 1934),
        ],
      ),
    ],
  ),

  // B3.1 España Billetes - Era de la Peseta (1874–2001)
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 1874,
    maxYear: 2001,
    validCurrencies: ['ESP'],
    defaultCurrency: 'ESP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1937,
        maxYear: 1953,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Dama de Elche / Quijote', 1937, 1953),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel de algodón',
        minYear: 1938,
        maxYear: 1951,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('República / Santa María', 1938, 1951),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1935,
        maxYear: 1954,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Jaime I / Séneca', 1935, 1954),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1935,
        maxYear: 1953,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Rosalía de Castro / Alfonso X', 1935, 1953),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 1954,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Calderón de la Barca / Álvaro de Bazán', 1928, 1954),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 1971,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Velázquez / Eduardo Rosales', 1928, 1971),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1925,
        maxYear: 1970,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cervantes / Manuel de Falla', 1925, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 1980,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Leopoldo Alas Clarín', 1980, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1928,
        maxYear: 1979,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Francisco de Zurbarán / Rosalía de Castro / Menéndez Pidal', 1928, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1874,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Benito Pérez Galdós / José Celestino Mutis / Hernán Cortés', 1874, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Papel de algodón',
        minYear: 1980,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Juan Ramón Jiménez / José Celestino Mutis', 1980, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Papel de algodón',
        minYear: 1976,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Rey Juan Carlos I / Cristóbal Colón', 1976, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 1985,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Rey Juan Carlos I y Príncipe Felipe', 1985, 1992),
        ],
      ),
    ],
  ),

  // B3.2 España & Unión Europea Billetes - Era del Euro (2002–presente)
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 2002,
    maxYear: 2100,
    validCurrencies: ['EUR'],
    defaultCurrency: 'EUR',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Clásica', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Románica', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Gótica', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Renacentista', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Barroca y Rococó', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Modernista del Hierro y Cristal', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2019,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Moderna del Siglo XX', 2002, 2019),
        ],
      ),
    ],
  ),
  NumismaticEmissionRuleData(
    country: 'Unión Europea',
    minYear: 2002,
    maxYear: 2100,
    validCurrencies: ['EUR'],
    defaultCurrency: 'EUR',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Clásica', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Románica', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Gótica', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Renacentista', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Barroca y Rococó', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2024,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Modernista del Hierro y Cristal', 2002, 2024),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2019,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arquitectura Moderna del Siglo XX', 2002, 2019),
        ],
      ),
    ],
  ),

  // B4.1 Guatemala Billetes - Quetzales Clásicos y Modernos (1948–2006)
  // Ref General: Banco de Guatemala - Historia de los Billetes de Quetzal: https://www.banguat.gob.gt
  // Denominación - Modelo / Referencias:
  // - 0.50, 1, 5, 10, 20, 50, 100 Quetzales (Tecún Umán, José María Orellana, Justo Rufino Barrios, Miguel García Granados, Mariano Gálvez, Carlos Mérida, Francisco Marroquín): https://www.banguat.gob.gt
  NumismaticEmissionRuleData(
    country: 'Guatemala',
    minYear: 1948,
    maxYear: 2006,
    validCurrencies: ['GTQ'],
    defaultCurrency: 'GTQ',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Papel de algodón',
        minYear: 1972,
        maxYear: 1998,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Tecún Umán / Templo I de Tikal', 1972, 1998),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1948,
        maxYear: 2006,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('General José María Orellana', 1948, 2006),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1948,
        maxYear: 2006,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('General Justo Rufino Barrios', 1948, 2006),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1948,
        maxYear: 2006,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('General Miguel García Granados', 1948, 2006),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1948,
        maxYear: 2006,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Doctor Mariano Gálvez', 1948, 2006),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1974,
        maxYear: 2006,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Licenciado Carlos Mérida', 1974, 2006),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1972,
        maxYear: 2006,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Obispo Francisco Marroquín', 1972, 2006),
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
    country: 'Guatemala',
    minYear: 2007,
    maxYear: 2100,
    validCurrencies: ['GTQ'],
    defaultCurrency: 'GTQ',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Polímero',
        minYear: 2007,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('General José María Orellana (Polímero)', 2007, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Polímero',
        minYear: 2011,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('General Justo Rufino Barrios (Polímero)', 2011, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 2007,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('General Miguel García Granados', 2007, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 2007,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Doctor Mariano Gálvez', 2007, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 2007,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Licenciado Carlos Mérida', 2007, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 2007,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Obispo Francisco Marroquín', 2007, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2009,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Compositores de Marimba (Hurtado, Valverde y Alcántara)', 2009, 2100),
        ],
      ),
    ],
  ),

  // B5.1 Colombia Billetes - Pesos Oro (1960–1993)
  // Ref General: Banco de la República - Billetes antiguos colombianos: https://www.banrep.gov.co
  // Denominación - Modelo / Referencias:
  // - 1 a 10000 Pesos Oro (Santander, Bolívar, Nariño, Caldas, Camilo Torres, Policarpa Salavarrieta): https://www.banrep.gov.co
  NumismaticEmissionRuleData(
    country: 'Colombia',
    minYear: 1960,
    maxYear: 1993,
    validCurrencies: ['COP'],
    defaultCurrency: 'COP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1974,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Santander y Bolívar', 1960, 1974),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1977,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Policarpa Salavarrieta', 1960, 1977),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1981,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José María Córdova', 1960, 1981),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1981,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Antonio Nariño', 1960, 1981),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1983,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Francisco José de Caldas', 1960, 1983),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1986,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Camilo Torres', 1960, 1986),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Antonio Nariño', 1960, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 1974,
        maxYear: 1992,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José Celestino Mutis', 1974, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1981,
        maxYear: 1993,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Francisco de Paula Santander', 1981, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1982,
        maxYear: 1993,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Jorge Eliécer Gaitán', 1982, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Papel de algodón',
        minYear: 1984,
        maxYear: 1993,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Simón Bolívar / Paso del Ejército Libertador', 1984, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Papel de algodón',
        minYear: 1986,
        maxYear: 1993,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Rafael Núñez / Miguel Antonio Caro', 1986, 1993),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 1992,
        maxYear: 1993,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Mujer Indígena Emberá', 1992, 1993),
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
    country: 'Colombia',
    minYear: 1994,
    maxYear: 2100,
    validCurrencies: ['COP'],
    defaultCurrency: 'COP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 2001,
        maxYear: 2016,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Jorge Eliécer Gaitán', 2001, 2016),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Papel de algodón',
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Débora Arango / Caño Cristales', 2016, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Papel de algodón',
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José Asunción Silva / Páramos', 2016, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Virginia Gutiérrez / Amazonia', 2016, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20000',
        material: 'Papel de algodón',
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Alfonso López Michelsen / Sistema Hidráulico Zenú', 2016, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50000',
        material: 'Papel de algodón',
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gabriel García Márquez / Ciudad Perdida', 2016, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100000',
        material: 'Papel de algodón',
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Carlos Lleras Restrepo / Valle de Cocora', 2016, 2100),
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
    country: 'Canadá',
    minYear: 1935,
    maxYear: 2010,
    validCurrencies: ['CAD'],
    defaultCurrency: 'CAD',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1973,
        maxYear: 1989,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Reina Isabel II / Parlamento de Ottawa', 1973, 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel de algodón',
        minYear: 1986,
        maxYear: 1996,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Reina Isabel II / Petirrojos Americanos', 1986, 1996),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 2001,
        maxYear: 2013,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sir Wilfrid Laurier / Deportes de Invierno', 2001, 2013),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 2001,
        maxYear: 2013,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sir John A. Macdonald / Recuerdo y Paz', 2001, 2013),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 2004,
        maxYear: 2012,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Reina Isabel II / Arte Indígena Haida (Bill Reid)', 2004, 2012),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 2004,
        maxYear: 2012,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('W.L. Mackenzie King / Las Cinco Valientes', 2004, 2012),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 2004,
        maxYear: 2011,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sir Robert Borden / Innovación y Telecomunicaciones', 2004, 2011),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1988,
        maxYear: 2000,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Reina Isabel II / Picogordos Sombríos', 1988, 2000),
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
    country: 'Canadá',
    minYear: 2011,
    maxYear: 2100,
    validCurrencies: ['CAD'],
    defaultCurrency: 'CAD',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Polímero',
        minYear: 2013,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sir Wilfrid Laurier / Innovación Espacial Canadarm2', 2013, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Polímero',
        minYear: 2013,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Viola Desmond / Tren Transcontinental de Canadá', 2013, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Polímero',
        minYear: 2012,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Reina Isabel II / Monumento Conmemorativo de Vimy', 2012, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Polímero',
        minYear: 2012,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('W.L. Mackenzie King / CCGS Amundsen en el Ártico', 2012, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Polímero',
        minYear: 2011,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sir Robert Borden / Descubrimiento de la Insulina', 2011, 2100),
        ],
      ),
    ],
  ),

  // B7.1 Cuba Billetes - Período Socialista y Régimen Dual (1961–2020)
  // Ref General: Banco Central de Cuba - Billetes Históricos: https://www.bc.gob.cu
  // Denominación - Modelo / Referencias:
  // - 1 a 1000 Pesos (José Martí, Che Guevara, Antonio Maceo, Máximo Gómez, Camilo Cienfuegos, Calixto García, Frank País, Ignacio Agramonte, Julio Antonio Mella): https://www.bc.gob.cu
  NumismaticEmissionRuleData(
    country: 'Cuba',
    minYear: 1961,
    maxYear: 2020,
    validCurrencies: ['CUP', 'CUC'],
    defaultCurrency: 'CUP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1961,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José Martí / Entrada de Fidel Castro a La Habana', 1961, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Papel de algodón',
        minYear: 1983,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ernesto "Che" Guevara / Cortador de Caña', 1983, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1961,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Antonio Maceo / Protesta de Baraguá', 1961, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1961,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Máximo Gómez / Guerra de Todo el Pueblo', 1961, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1961,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Camilo Cienfuegos / Trabajo Voluntario', 1961, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1961,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Calixto García / Centro de Ingeniería Genética', 1961, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1961,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Carlos Manuel de Céspedes / Estatua de José Martí', 1961, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2010,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Frank País / Ciudad Escolar 26 de Julio', 2010, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 2010,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ignacio Agramonte / Asamblea de Guáimaro', 2010, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 2010,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Julio Antonio Mella / Universidad de La Habana', 2010, 2020),
        ],
      ),
    ],
  ),

  // B7.2 Cuba Billetes - Unificación Monetaria (2021–presente)
  // Ref General: Banco Central de Cuba - Ordenamiento Monetario: https://www.bc.gob.cu
  // Denominación - Modelo / Referencias:
  // - 1 a 1000 Pesos (José Martí, Che Guevara, Antonio Maceo, Máximo Gómez, Camilo Cienfuegos, Calixto García, Frank País, Ignacio Agramonte, Julio Antonio Mella): https://www.bc.gob.cu
  NumismaticEmissionRuleData(
    country: 'Cuba',
    minYear: 2021,
    maxYear: 2100,
    validCurrencies: ['CUP'],
    defaultCurrency: 'CUP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José Martí / Entrada de Fidel Castro a La Habana', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ernesto "Che" Guevara / Cortador de Caña', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Antonio Maceo / Protesta de Baraguá', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Máximo Gómez / Guerra de Todo el Pueblo', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Camilo Cienfuegos / Trabajo Voluntario', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Calixto García / Centro de Ingeniería Genética', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Carlos Manuel de Céspedes / Estatua de José Martí', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Frank País / Ciudad Escolar 26 de Julio', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ignacio Agramonte / Asamblea de Guáimaro', 2021, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Julio Antonio Mella / Universidad de La Habana', 2021, 2100),
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
    country: 'Argentina',
    minYear: 1992,
    maxYear: 2100,
    validCurrencies: ['ARS'],
    defaultCurrency: 'ARS',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1992,
        maxYear: 1995,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Carlos Pellegrini / Congreso Nacional', 1992, 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel de algodón',
        minYear: 1992,
        maxYear: 2018,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Bartolomé Mitre / Museo Mitre', 1992, 2018),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1992,
        maxYear: 2020,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('General José de San Martín / Monumento Cerro de la Gloria', 1992, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1992,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Manuel Belgrano / Monumento a la Bandera', 1992, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1992,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Guanaco / Estepa Patagónica', 1992, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1992,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cóndor Andino / Cordillera de los Andes', 1992, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1992,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Taruca / Región Noroeste', 1992, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ballena Franca Austral / Mar Argentino', 2016, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Yaguareté / Región Noreste', 2016, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 2017,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Hornero / Región Pampeana', 2017, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Papel de algodón',
        minYear: 2023,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cecilia Grierson y Ramón Carrillo / Instituto Malbrán', 2023, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 2024,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Manuel Belgrano y María Remedios del Valle', 2024, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20000',
        material: 'Papel de algodón',
        minYear: 2024,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Juan Bautista Alberdi', 2024, 2100),
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
    country: 'Brasil',
    minYear: 1994,
    maxYear: 2100,
    validCurrencies: ['BRL'],
    defaultCurrency: 'BRL',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2005,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Efígie da República / Beija-flor', 1994, 2005),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Papel de algodón',
        minYear: 2001,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Efígie da República / Tartaruga-marinha', 2001, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Efígie da República / Garça', 1994, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        allowedMaterials: ['Papel de algodón', 'Polímero'],
        minYear: 1994,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Efígie da República / Arara', 1994, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 2002,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Efígie da República / Mico-leão-dourado', 2002, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Efígie da República / Onça-pintada', 1994, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Efígie da República / Garoupa', 1994, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 2020,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Efígie da República / Lobo-guará', 2020, 2100),
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
    country: 'Chile',
    minYear: 1975,
    maxYear: 2100,
    validCurrencies: ['CLP'],
    defaultCurrency: 'CLP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1977,
        maxYear: 2000,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cardenal Raúl Silva Henríquez / Santuario de Maipú', 1977, 2000),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Polímero',
        minYear: 2011,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Ignacio Carrera Pinto / Torres del Paine', 2011, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Polímero',
        minYear: 2009,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Manuel Rodríguez / Reserva Nacional Nalcas', 2009, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Polímero',
        minYear: 2009,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gabriela Mistral / Parque Nacional La Campana', 2009, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 2010,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Arturo Prat / Parque Nacional Alberto de Agostini', 2010, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20000',
        material: 'Papel de algodón',
        minYear: 2010,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Andrés Bello / Salar de Surire', 2010, 2100),
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
    country: 'Perú',
    minYear: 1991,
    maxYear: 2100,
    validCurrencies: ['PEN'],
    defaultCurrency: 'PEN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        allowedMaterials: ['Papel de algodón', 'Polímero'],
        minYear: 1991,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Chabuca Granda / Vicuña y Flor de Amancaes', 1991, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        allowedMaterials: ['Papel de algodón', 'Polímero'],
        minYear: 1991,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('José María Arguedas / Cóndor Andino', 1991, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        allowedMaterials: ['Papel de algodón', 'Polímero'],
        minYear: 1991,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('María Rostworowski / Jaguar', 1991, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1991,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Pedro Paulet / Colibrí Cola de Espátula', 1991, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 1991,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Tilsa Tsuchiya / Gallito de las Rocas', 1991, 2100),
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
    country: 'Reino Unido',
    minYear: 1970,
    maxYear: 2100,
    validCurrencies: ['GBP'],
    defaultCurrency: 'GBP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Polímero',
        allowedMaterials: ['Polímero', 'Papel de algodón'],
        minYear: 2016,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Sir Winston Churchill / Palacio de Westminster', 2016, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Polímero',
        allowedMaterials: ['Polímero', 'Papel de algodón'],
        minYear: 2017,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Jane Austen / Godmersham Park', 2017, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Polímero',
        allowedMaterials: ['Polímero', 'Papel de algodón'],
        minYear: 2020,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('J.M.W. Turner / El «Temerario»', 2020, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Polímero',
        allowedMaterials: ['Polímero', 'Papel de algodón'],
        minYear: 2021,
        maxYear: 2100,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Alan Turing / Bombe de Bletchley Park', 2021, 2100),
        ],
      ),
    ],
  ),

  // B13.1 Francia Billetes - Nouveau Franc (1960–2001)
  // Ref General: Banque de France - Histoire des billets: https://www.banque-france.fr
  // Denominación - Modelo / Referencias:
  // - 5, 10, 20, 50, 100, 200, 500 Francs (Victor Hugo, Voltaire, Berlioz, Debussy, Quentin de La Tour, Saint-Exupéry, Delacroix, Cézanne, Gustave Eiffel, Pierre et Marie Curie): https://www.banque-france.fr
  NumismaticEmissionRuleData(
    country: 'Francia',
    minYear: 1960,
    maxYear: 2001,
    validCurrencies: ['FRF'],
    defaultCurrency: 'FRF',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1970,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Victor Hugo / Plaza de los Vosgos', 1960, 1970),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1960,
        maxYear: 1980,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Hector Berlioz / Capilla de los Inválidos', 1960, 1980),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1980,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Claude Debussy / El Mar', 1980, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1976,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Antoine de Saint-Exupéry / El Principito', 1976, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1978,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Paul Cézanne / Montagne Sainte-Victoire', 1978, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 1981,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gustave Eiffel / Torre Eiffel', 1981, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1968,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Pierre y Marie Curie / Radium', 1968, 2001),
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
    country: 'Alemania',
    minYear: 1948,
    maxYear: 2001,
    validCurrencies: ['DEM', 'DDM'],
    defaultCurrency: 'DEM',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Papel de algodón',
        minYear: 1990,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Bettina von Arnim / Castillo Wiepersdorf', 1990, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1989,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Carl Friedrich Gauss / Campana de Gauss', 1989, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1989,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Annette von Droste-Hülshoff / Castillo Meersburg', 1989, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1989,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Balthasar Neumann / Residencia de Wurzburgo', 1989, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 1989,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Clara Schumann / Conservatorio Hoch de Fráncfort', 1989, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        minYear: 1989,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Paul Ehrlich / Microscopio y Quimioterapia', 1989, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1991,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Maria Sibylla Merian / Diente de León y Oruga', 1991, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1991,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Wilhelm y Jacob Grimm / Diccionario Alemán', 1991, 2001),
        ],
      ),
    ],
  ),

  // B15.1 Italia Billetes - Lira Italiana (1946–2001)
  // Ref General: Banca d'Italia - Banconote della Lira: https://www.bancaditalia.it
  // Denominación - Modelo / Referencias:
  // - 500, 1000, 2000, 5000, 10000, 50000, 100000, 500000 Liras (Mercurio, Verdi, Montessori, Galilei, Marconi, Colombo, Bellini, Volta, Bernini, Caravaggio, Raffaello): https://www.bancaditalia.it
  NumismaticEmissionRuleData(
    country: 'Italia',
    minYear: 1946,
    maxYear: 2001,
    validCurrencies: ['ITL'],
    defaultCurrency: 'ITL',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Papel de algodón',
        minYear: 1966,
        maxYear: 1979,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Cabeza de Mercurio', 1966, 1979),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Papel de algodón',
        minYear: 1969,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Maria Montessori / Niños en clase', 1969, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Papel de algodón',
        minYear: 1973,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Guglielmo Marconi / Yate Elettra', 1973, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Papel de algodón',
        minYear: 1979,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Vincenzo Bellini / Teatro Massimo Bellini', 1979, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10000',
        material: 'Papel de algodón',
        minYear: 1976,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Alessandro Volta / Tempio Voltiano', 1976, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50000',
        material: 'Papel de algodón',
        minYear: 1984,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Gian Lorenzo Bernini / Escultura de Apolo y Dafne', 1984, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100000',
        material: 'Papel de algodón',
        minYear: 1983,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Michelangelo Merisi da Caravaggio / Cesto de Frutas', 1983, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500000',
        material: 'Papel de algodón',
        minYear: 1997,
        maxYear: 2001,
        isBanknote: true,
        motifs: [
          NumismaticMotifRule('Raffaello Sanzio / Triunfo de Galatea', 1997, 2001),
        ],
      ),
    ],
  ),
];
