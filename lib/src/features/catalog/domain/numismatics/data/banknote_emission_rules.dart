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
      NumismaticPieceDefinition(denomination: '0.05', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Cartón Fraccionario Revolucionario', isBanknote: true),
      NumismaticPieceDefinition(denomination: '0.10', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Cartón Fraccionario Revolucionario', isBanknote: true),
      NumismaticPieceDefinition(denomination: '0.20', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Cartón Fraccionario Revolucionario', isBanknote: true),
      NumismaticPieceDefinition(denomination: '0.50', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Billete Fraccionario Revolucionario', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Cuauhtémoc', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Morelos', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Hidalgo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Juárez', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Madero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Carranza', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Zaragoza', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Allende', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel', minYear: 1913, maxYear: 1916, motifName: 'Gobierno Constitucionalista / Cuauhtémoc', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1936, maxYear: 1970, motifName: 'Piedra del Sol (Calendario Azteca)', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', minYear: 1925, maxYear: 1945, motifName: 'Monumento a la Independencia', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1925, maxYear: 1978, motifName: 'La Gitana / Josefa Ortiz de Domínguez', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1925, maxYear: 1978, motifName: 'La Tehuana / Miguel Hidalgo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1925, maxYear: 1978, motifName: 'Josefa Ortiz de Domínguez', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1925, maxYear: 1978, motifName: 'Ignacio Allende', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1925, maxYear: 1978, motifName: 'Miguel Hidalgo y Costilla', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1925, maxYear: 1978, motifName: 'José María Morelos y Pavón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1925, maxYear: 1978, motifName: 'Cuauhtémoc', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', minYear: 1953, maxYear: 1978, motifName: 'Los Niños Héroes', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 1943, maxYear: 1978, motifName: 'Matías Romero', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1969, maxYear: 1972, motifName: 'Josefa Ortiz de Domínguez', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1969, maxYear: 1977, motifName: 'Miguel Hidalgo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1969, maxYear: 1977, motifName: 'José María Morelos', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1973, maxYear: 1981, motifName: 'Benito Juárez', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1974, maxYear: 1982, motifName: 'Venustiano Carranza', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1979, maxYear: 1984, motifName: 'Francisco I. Madero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1978, maxYear: 1985, motifName: 'Sor Juana Inés de la Cruz', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', minYear: 1983, maxYear: 1989, motifName: 'Justo Sierra', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', minYear: 1980, maxYear: 1989, motifName: 'Los Niños Héroes', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 1982, maxYear: 1991, motifName: 'Lázaro Cárdenas', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20000', material: 'Papel de algodón', minYear: 1985, maxYear: 1992, motifName: 'Andrés Quintana Roo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50000', material: 'Papel de algodón', minYear: 1986, maxYear: 1992, motifName: 'Cuauhtémoc', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100000', material: 'Papel de algodón', minYear: 1988, maxYear: 1992, motifName: 'Plutarco Elías Calles', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1993, maxYear: 1995, motifName: 'Lázaro Cárdenas', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1993, maxYear: 1995, motifName: 'Andrés Quintana Roo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1993, maxYear: 1995, motifName: 'Cuauhtémoc', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1993, maxYear: 1995, motifName: 'Plutarco Elías Calles', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1994, maxYear: 2000, motifName: 'Emiliano Zapata', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1994, maxYear: 2001, motifName: 'Benito Juárez', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1994, maxYear: 2001, motifName: 'José María Morelos', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1994, maxYear: 2001, motifName: 'Nezahualcóyotl', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 1994, maxYear: 2001, motifName: 'Sor Juana Inés de la Cruz', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1994, maxYear: 2001, motifName: 'Ignacio Zaragoza', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 2002, maxYear: 2004, motifName: 'Emiliano Zapata', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Polímero', minYear: 2002, maxYear: 2007, motifName: 'Benito Juárez (Polímero)', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 2002, maxYear: 2006, motifName: 'José María Morelos', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 2002, maxYear: 2007, motifName: 'Nezahualcóyotl', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2002, maxYear: 2007, motifName: 'Sor Juana Inés de la Cruz', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 2002, maxYear: 2007, motifName: 'Ignacio Zaragoza', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '20', material: 'Polímero', minYear: 2006, maxYear: 2019, motifName: 'Benito Juárez / Monte Albán', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Polímero', minYear: 2006, maxYear: 2019, motifName: 'José María Morelos / Acueducto de Morelia', isBanknote: true),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        minYear: 2006,
        maxYear: 2019,
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
        motifs: [
          NumismaticMotifRule(
            'Nezahualcóyotl / Tenochtitlan (Circulación Estándar)',
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
          NumismaticMotifRule(
            'Sor Juana Inés de la Cruz / Hacienda de Panoaya (Circulación Estándar)',
            2006,
            2019,
          ),
          NumismaticMotifRule('Bicentenario de la Independencia de México', 2009, 2010),
        ],
      ),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 2010, maxYear: 2019, motifName: 'Diego Rivera y Frida Kahlo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 2008, maxYear: 2019, motifName: 'Miguel Hidalgo / Universidad de Guanajuato', isBanknote: true),
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
          NumismaticMotifRule(
            'Benito Juárez / Monte Albán (Familia F1)',
            2020,
            2024,
          ),
          NumismaticMotifRule('Bicentenario de la Independencia Nacional', 2021),
        ],
      ),
      NumismaticPieceDefinition(denomination: '50', material: 'Polímero', minYear: 2020, maxYear: 2024, motifName: 'Fundación de Tenochtitlan / Ajolote y Xochimilco', isBanknote: true),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Polímero',
        minYear: 2020,
        maxYear: 2024,
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
        motifName: 'Sor Juana Inés de la Cruz / Bosques Templados y Mariposa Monarca',
      ),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2019, maxYear: 2024, motifName: 'Miguel Hidalgo y José María Morelos / Reserva El Pinacate', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 2018, maxYear: 2024, motifName: 'Benito Juárez / Ballena Gris El Vizcaíno', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 2020, maxYear: 2024, motifName: 'Madero, Hermila Galindo y Carmen Serdán / Calakmul', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1862, maxYear: 1923, motifName: 'George Washington / Chase / History Instructing Youth', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', minYear: 1862, maxYear: 1918, motifName: 'Alexander Hamilton / Thomas Jefferson', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1861, maxYear: 1923, motifName: 'Chief Onepapa / Abraham Lincoln / Woodchopper', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1861, maxYear: 1923, motifName: 'Bison / Daniel Webster / Michael Hillegas', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1861, maxYear: 1923, motifName: 'Alexander Hamilton / Stephen Decatur / George Washington', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1861, maxYear: 1918, motifName: 'Henry Clay / Benjamin Franklin / Ulysses S. Grant', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1861, maxYear: 1914, motifName: 'Abraham Lincoln / Thomas Hart Benton', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1861, maxYear: 1918, motifName: 'Alexander Hamilton / John Marshall', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1861, maxYear: 1918, motifName: 'Robert Morris / DeWitt Clinton / Alexander Hamilton', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', minYear: 1878, maxYear: 1918, motifName: 'James Madison', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 1878, maxYear: 1918, motifName: 'Salmon P. Chase', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1928, maxYear: 2024, motifName: 'George Washington / Great Seal', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', minYear: 1928, maxYear: 2024, motifName: 'Thomas Jefferson / Declaration of Independence', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1928, maxYear: 2024, motifName: 'Abraham Lincoln / Lincoln Memorial', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1928, maxYear: 2024, motifName: 'Alexander Hamilton / US Treasury', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1928, maxYear: 2024, motifName: 'Andrew Jackson / White House', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1928, maxYear: 2024, motifName: 'Ulysses S. Grant / US Capitol', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1928, maxYear: 2024, motifName: 'Benjamin Franklin / Independence Hall', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1928, maxYear: 1945, motifName: 'William McKinley', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1928, maxYear: 1945, motifName: 'Grover Cleveland', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', minYear: 1928, maxYear: 1945, motifName: 'James Madison', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 1928, maxYear: 1945, motifName: 'Salmon P. Chase', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100000', material: 'Papel de algodón', minYear: 1934, maxYear: 1934, motifName: 'Woodrow Wilson (Gold Certificate)', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1937, maxYear: 1953, motifName: 'Dama de Elche / Quijote', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', minYear: 1938, maxYear: 1951, motifName: 'República / Santa María', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1935, maxYear: 1954, motifName: 'Jaime I / Séneca', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1935, maxYear: 1953, motifName: 'Rosalía de Castro / Alfonso X', isBanknote: true),
      NumismaticPieceDefinition(denomination: '25', material: 'Papel de algodón', minYear: 1928, maxYear: 1954, motifName: 'Calderón de la Barca / Álvaro de Bazán', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1928, maxYear: 1971, motifName: 'Velázquez / Eduardo Rosales', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1925, maxYear: 1970, motifName: 'Cervantes / Manuel de Falla', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 1980, maxYear: 1992, motifName: 'Leopoldo Alas Clarín', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1928, maxYear: 1979, motifName: 'Francisco de Zurbarán / Rosalía de Castro / Menéndez Pidal', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1874, maxYear: 1992, motifName: 'Benito Pérez Galdós / José Celestino Mutis / Hernán Cortés', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', minYear: 1980, maxYear: 1992, motifName: 'Juan Ramón Jiménez / José Celestino Mutis', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', minYear: 1976, maxYear: 1992, motifName: 'Rey Juan Carlos I / Cristóbal Colón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 1985, maxYear: 1992, motifName: 'Rey Juan Carlos I y Príncipe Felipe', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Clásica', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Románica', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Gótica', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Renacentista', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Barroca y Rococó', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Modernista del Hierro y Cristal', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 2002, maxYear: 2019, motifName: 'Arquitectura Moderna del Siglo XX', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Clásica', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Románica', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Gótica', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Renacentista', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Barroca y Rococó', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2002, maxYear: 2024, motifName: 'Arquitectura Modernista del Hierro y Cristal', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 2002, maxYear: 2019, motifName: 'Arquitectura Moderna del Siglo XX', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '0.50', material: 'Papel de algodón', minYear: 1972, maxYear: 1998, motifName: 'Tecún Umán / Templo I de Tikal', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1948, maxYear: 2006, motifName: 'General José María Orellana', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1948, maxYear: 2006, motifName: 'General Justo Rufino Barrios', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1948, maxYear: 2006, motifName: 'General Miguel García Granados', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1948, maxYear: 2006, motifName: 'Doctor Mariano Gálvez', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1974, maxYear: 2006, motifName: 'Licenciado Carlos Mérida', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1972, maxYear: 2006, motifName: 'Obispo Francisco Marroquín', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Polímero', minYear: 2007, maxYear: 2100, motifName: 'General José María Orellana (Polímero)', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Polímero', minYear: 2011, maxYear: 2100, motifName: 'General Justo Rufino Barrios (Polímero)', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 2007, maxYear: 2100, motifName: 'General Miguel García Granados', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 2007, maxYear: 2100, motifName: 'Doctor Mariano Gálvez', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 2007, maxYear: 2100, motifName: 'Licenciado Carlos Mérida', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 2007, maxYear: 2100, motifName: 'Obispo Francisco Marroquín', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2009, maxYear: 2100, motifName: 'Compositores de Marimba (Hurtado, Valverde y Alcántara)', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1960, maxYear: 1974, motifName: 'Santander y Bolívar', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', minYear: 1960, maxYear: 1977, motifName: 'Policarpa Salavarrieta', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1960, maxYear: 1981, motifName: 'José María Córdova', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1960, maxYear: 1981, motifName: 'Antonio Nariño', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1960, maxYear: 1983, motifName: 'Francisco José de Caldas', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1960, maxYear: 1986, motifName: 'Camilo Torres', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1960, maxYear: 1992, motifName: 'Antonio Nariño', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 1974, maxYear: 1992, motifName: 'José Celestino Mutis', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1981, maxYear: 1993, motifName: 'Francisco de Paula Santander', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1982, maxYear: 1993, motifName: 'Jorge Eliécer Gaitán', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', minYear: 1984, maxYear: 1993, motifName: 'Simón Bolívar / Paso del Ejército Libertador', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', minYear: 1986, maxYear: 1993, motifName: 'Rafael Núñez / Miguel Antonio Caro', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 1992, maxYear: 1993, motifName: 'Mujer Indígena Emberá', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 2001, maxYear: 2016, motifName: 'Jorge Eliécer Gaitán', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', minYear: 2016, maxYear: 2100, motifName: 'Débora Arango / Caño Cristales', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', minYear: 2016, maxYear: 2100, motifName: 'José Asunción Silva / Páramos', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 2016, maxYear: 2100, motifName: 'Virginia Gutiérrez / Amazonia', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20000', material: 'Papel de algodón', minYear: 2016, maxYear: 2100, motifName: 'Alfonso López Michelsen / Sistema Hidráulico Zenú', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50000', material: 'Papel de algodón', minYear: 2016, maxYear: 2100, motifName: 'Gabriel García Márquez / Ciudad Perdida', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100000', material: 'Papel de algodón', minYear: 2016, maxYear: 2100, motifName: 'Carlos Lleras Restrepo / Valle de Cocora', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1973, maxYear: 1989, motifName: 'Reina Isabel II / Parlamento de Ottawa', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', minYear: 1986, maxYear: 1996, motifName: 'Reina Isabel II / Petirrojos Americanos', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 2001, maxYear: 2013, motifName: 'Sir Wilfrid Laurier / Deportes de Invierno', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 2001, maxYear: 2013, motifName: 'Sir John A. Macdonald / Recuerdo y Paz', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 2004, maxYear: 2012, motifName: 'Reina Isabel II / Arte Indígena Haida (Bill Reid)', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 2004, maxYear: 2012, motifName: 'W.L. Mackenzie King / Las Cinco Valientes', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 2004, maxYear: 2011, motifName: 'Sir Robert Borden / Innovación y Telecomunicaciones', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1988, maxYear: 2000, motifName: 'Reina Isabel II / Picogordos Sombríos', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '5', material: 'Polímero', minYear: 2013, maxYear: 2100, motifName: 'Sir Wilfrid Laurier / Innovación Espacial Canadarm2', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Polímero', minYear: 2013, maxYear: 2100, motifName: 'Viola Desmond / Tren Transcontinental de Canadá', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Polímero', minYear: 2012, maxYear: 2100, motifName: 'Reina Isabel II / Monumento Conmemorativo de Vimy', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Polímero', minYear: 2012, maxYear: 2100, motifName: 'W.L. Mackenzie King / CCGS Amundsen en el Ártico', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Polímero', minYear: 2011, maxYear: 2100, motifName: 'Sir Robert Borden / Descubrimiento de la Insulina', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1961, maxYear: 2020, motifName: 'José Martí / Entrada de Fidel Castro a La Habana', isBanknote: true),
      NumismaticPieceDefinition(denomination: '3', material: 'Papel de algodón', minYear: 1983, maxYear: 2020, motifName: 'Ernesto "Che" Guevara / Cortador de Caña', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1961, maxYear: 2020, motifName: 'Antonio Maceo / Protesta de Baraguá', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1961, maxYear: 2020, motifName: 'Máximo Gómez / Guerra de Todo el Pueblo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1961, maxYear: 2020, motifName: 'Camilo Cienfuegos / Trabajo Voluntario', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1961, maxYear: 2020, motifName: 'Calixto García / Centro de Ingeniería Genética', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1961, maxYear: 2020, motifName: 'Carlos Manuel de Céspedes / Estatua de José Martí', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2010, maxYear: 2020, motifName: 'Frank País / Ciudad Escolar 26 de Julio', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 2010, maxYear: 2020, motifName: 'Ignacio Agramonte / Asamblea de Guáimaro', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 2010, maxYear: 2020, motifName: 'Julio Antonio Mella / Universidad de La Habana', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'José Martí / Entrada de Fidel Castro a La Habana', isBanknote: true),
      NumismaticPieceDefinition(denomination: '3', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Ernesto "Che" Guevara / Cortador de Caña', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Antonio Maceo / Protesta de Baraguá', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Máximo Gómez / Guerra de Todo el Pueblo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Camilo Cienfuegos / Trabajo Voluntario', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Calixto García / Centro de Ingeniería Genética', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Carlos Manuel de Céspedes / Estatua de José Martí', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Frank País / Ciudad Escolar 26 de Julio', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Ignacio Agramonte / Asamblea de Guáimaro', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 2021, maxYear: 2100, motifName: 'Julio Antonio Mella / Universidad de La Habana', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1992, maxYear: 1995, motifName: 'Carlos Pellegrini / Congreso Nacional', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', minYear: 1992, maxYear: 2018, motifName: 'Bartolomé Mitre / Museo Mitre', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1992, maxYear: 2020, motifName: 'General José de San Martín / Monumento Cerro de la Gloria', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1992, maxYear: 2100, motifName: 'Manuel Belgrano / Monumento a la Bandera', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1992, maxYear: 2100, motifName: 'Guanaco / Estepa Patagónica', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1992, maxYear: 2100, motifName: 'Cóndor Andino / Cordillera de los Andes', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1992, maxYear: 2100, motifName: 'Taruca / Región Noroeste', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2016, maxYear: 2100, motifName: 'Ballena Franca Austral / Mar Argentino', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 2016, maxYear: 2100, motifName: 'Yaguareté / Región Noreste', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 2017, maxYear: 2100, motifName: 'Hornero / Región Pampeana', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', minYear: 2023, maxYear: 2100, motifName: 'Cecilia Grierson y Ramón Carrillo / Instituto Malbrán', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 2024, maxYear: 2100, motifName: 'Manuel Belgrano y María Remedios del Valle', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20000', material: 'Papel de algodón', minYear: 2024, maxYear: 2100, motifName: 'Juan Bautista Alberdi', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', minYear: 1994, maxYear: 2005, motifName: 'Efígie da República / Beija-flor', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', minYear: 2001, maxYear: 2100, motifName: 'Efígie da República / Tartaruga-marinha', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1994, maxYear: 2100, motifName: 'Efígie da República / Garça', isBanknote: true),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        minYear: 1994,
        maxYear: 2100,
        motifName: 'Efígie da República / Arara',
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
      ),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 2002, maxYear: 2100, motifName: 'Efígie da República / Mico-leão-dourado', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1994, maxYear: 2100, motifName: 'Efígie da República / Onça-pintada', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1994, maxYear: 2100, motifName: 'Efígie da República / Garoupa', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 2020, maxYear: 2100, motifName: 'Efígie da República / Lobo-guará', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1977, maxYear: 2000, motifName: 'Cardenal Raúl Silva Henríquez / Santuario de Maipú', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Polímero', minYear: 2011, maxYear: 2100, motifName: 'Ignacio Carrera Pinto / Torres del Paine', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Polímero', minYear: 2009, maxYear: 2100, motifName: 'Manuel Rodríguez / Reserva Nacional Nalcas', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Polímero', minYear: 2009, maxYear: 2100, motifName: 'Gabriela Mistral / Parque Nacional La Campana', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 2010, maxYear: 2100, motifName: 'Arturo Prat / Parque Nacional Alberto de Agostini', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20000', material: 'Papel de algodón', minYear: 2010, maxYear: 2100, motifName: 'Andrés Bello / Salar de Surire', isBanknote: true),
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
        minYear: 1991,
        maxYear: 2100,
        motifName: 'Chabuca Granda / Vicuña y Flor de Amancaes',
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        minYear: 1991,
        maxYear: 2100,
        motifName: 'José María Arguedas / Cóndor Andino',
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        minYear: 1991,
        maxYear: 2100,
        motifName: 'María Rostworowski / Jaguar',
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
      ),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1991, maxYear: 2100, motifName: 'Pedro Paulet / Colibrí Cola de Espátula', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 1991, maxYear: 2100, motifName: 'Tilsa Tsuchiya / Gallito de las Rocas', isBanknote: true),
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
        minYear: 2016,
        maxYear: 2100,
        motifName: 'Sir Winston Churchill / Palacio de Westminster',
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Polímero',
        minYear: 2017,
        maxYear: 2100,
        motifName: 'Jane Austen / Godmersham Park',
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Polímero',
        minYear: 2020,
        maxYear: 2100,
        motifName: 'J.M.W. Turner / El «Temerario»',
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Polímero',
        minYear: 2021,
        maxYear: 2100,
        motifName: 'Alan Turing / Bombe de Bletchley Park',
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
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
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1960, maxYear: 1970, motifName: 'Victor Hugo / Plaza de los Vosgos', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1960, maxYear: 1980, motifName: 'Hector Berlioz / Capilla de los Inválidos', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1980, maxYear: 2001, motifName: 'Claude Debussy / El Mar', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1976, maxYear: 2001, motifName: 'Antoine de Saint-Exupéry / El Principito', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1978, maxYear: 2001, motifName: 'Paul Cézanne / Montagne Sainte-Victoire', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 1981, maxYear: 2001, motifName: 'Gustave Eiffel / Torre Eiffel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1968, maxYear: 2001, motifName: 'Pierre y Marie Curie / Radium', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', minYear: 1990, maxYear: 2001, motifName: 'Bettina von Arnim / Castillo Wiepersdorf', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', minYear: 1989, maxYear: 2001, motifName: 'Carl Friedrich Gauss / Campana de Gauss', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', minYear: 1989, maxYear: 2001, motifName: 'Annette von Droste-Hülshoff / Castillo Meersburg', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', minYear: 1989, maxYear: 2001, motifName: 'Balthasar Neumann / Residencia de Wurzburgo', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', minYear: 1989, maxYear: 2001, motifName: 'Clara Schumann / Conservatorio Hoch de Fráncfort', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', minYear: 1989, maxYear: 2001, motifName: 'Paul Ehrlich / Microscopio y Quimioterapia', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1991, maxYear: 2001, motifName: 'Maria Sibylla Merian / Diente de León y Oruga', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1991, maxYear: 2001, motifName: 'Wilhelm y Jacob Grimm / Diccionario Alemán', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', minYear: 1966, maxYear: 1979, motifName: 'Cabeza de Mercurio', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', minYear: 1969, maxYear: 2001, motifName: 'Maria Montessori / Niños en clase', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', minYear: 1973, maxYear: 2001, motifName: 'Guglielmo Marconi / Yate Elettra', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', minYear: 1979, maxYear: 2001, motifName: 'Vincenzo Bellini / Teatro Massimo Bellini', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', minYear: 1976, maxYear: 2001, motifName: 'Alessandro Volta / Tempio Voltiano', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50000', material: 'Papel de algodón', minYear: 1984, maxYear: 2001, motifName: 'Gian Lorenzo Bernini / Escultura de Apolo y Dafne', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100000', material: 'Papel de algodón', minYear: 1983, maxYear: 2001, motifName: 'Michelangelo Merisi da Caravaggio / Cesto de Frutas', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500000', material: 'Papel de algodón', minYear: 1997, maxYear: 2001, motifName: 'Raffaello Sanzio / Triunfo de Galatea', isBanknote: true),
    ],
  ),
];
