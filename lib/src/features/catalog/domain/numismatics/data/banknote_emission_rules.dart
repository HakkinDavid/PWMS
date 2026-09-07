import '../models/numismatic_models.dart';

/// Banknote emission rules across all supported countries and eras.
const List<NumismaticEmissionRuleData> banknoteEmissionRules = [
  // B1.1 México Billetes - Época Revolucionaria y Pre-Banco de México (1823–1924)
  // Ref General: Banco de México - Historia del billete mexicano:
  // https://www.banxico.org.mx/billetes-y-monedas/historia-billete-banco-mexico.html
  // Ref General: Numista - Mexican Banknotes:
  // https://en.numista.com/catalogue/mexico-banknotes-1.html
  // Denominación - Modelo / Referencias:
  // - 0.05, 0.10, 0.20, 0.50 Peso (Cartones y Billetes fraccionarios revolucionarios): https://en.numista.com/catalogue/pieces15170.html
  // - 1, 2, 5, 10, 20, 50, 100, 500, 1000 Pesos (Gobierno Constitucionalista, Ejército del Norte, Banco de Londres y México): https://en.numista.com/catalogue/mexico-banknotes-1.html
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1823,
    maxYear: 1924,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '0.05', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '0.10', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '0.20', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '0.50', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel', isBanknote: true),
    ],
  ),

  // B1.2 México Billetes - Primeras Emisiones Banco de México / ABNC (1925–1978)
  // Ref General: Banco de México - Billetes impresos por American Bank Note Company (ABNC):
  // https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // Ref General: Numista - Mexico - Banknotes (1925-1978):
  // https://en.numista.com/catalogue/mexico-banknotes-2.html
  // Denominación - Modelo / Referencias:
  // - 1 Peso (ABNC - Calendario Azteca / Piedra del Sol): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 2 Pesos (ABNC - Monumento a la Independencia): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 5 Pesos (ABNC - La Gitana / Josefa Ortiz de Domínguez): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 10 Pesos (ABNC - La Tehuana / Miguel Hidalgo): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 20 Pesos (ABNC - Josefa Ortiz de Domínguez): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 50 Pesos (ABNC - Ignacio Allende): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 100 Pesos (ABNC - Miguel Hidalgo y Costilla): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 500 Pesos (ABNC - José María Morelos y Pavón): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 1000 Pesos (ABNC - Cuauhtémoc): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  // - 5000, 10000 Pesos (ABNC - Niños Héroes / Matías Romero): https://www.banxico.org.mx/billetes-y-monedas/billetes-abnc-banco-mexico.html
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1925,
    maxYear: 1978,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B1.3 México Billetes - Familia AA Fábrica de Billetes Banxico (1969–1992)
  // Ref General: Banco de México - Billetes de la Familia AA desmonetizados:
  // https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
  // Denominación - Modelo / Referencias:
  // - 5 Pesos (Josefa Ortiz de Domínguez): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
  // - 10 Pesos (Miguel Hidalgo): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
  // - 20 Pesos (José María Morelos): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
  // - 50 Pesos (Benito Juárez): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
  // - 100 Pesos (Venustiano Carranza): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
  // - 500 Pesos (Francisco I. Madero): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
  // - 1000 Pesos (Sor Juana Inés de la Cruz): https://www.banxico.org.mx/billetes-y-monedas/familia-aa-desmonetizados-ban.html
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1969,
    maxYear: 1992,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B1.4 México Billetes - Familia A Altas Denominaciones Inflacionarias (1979–1992)
  // Ref General: Banco de México - Billetes de la Familia A desmonetizados:
  // https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
  // Denominación - Modelo / Referencias:
  // - 2000 Pesos (Justo Sierra): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
  // - 5000 Pesos (Niños Héroes): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
  // - 10000 Pesos (Lázaro Cárdenas): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
  // - 20000 Pesos (Andrés Quintana Roo): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
  // - 50000 Pesos (Cuauhtémoc): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
  // - 100000 Pesos (Plutarco Elías Calles): https://www.banxico.org.mx/billetes-y-monedas/familia-desmonetizados-banco.html
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1979,
    maxYear: 1992,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B1.5 México Billetes - Familia B Nuevos Pesos N$ (1993–1995)
  // Ref General: Banco de México - Billetes de la Familia B en proceso de retiro:
  // https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
  // Denominación - Modelo / Referencias:
  // - 10 Nuevos Pesos (Lázaro Cárdenas): https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
  // - 20 Nuevos Pesos (Andrés Quintana Roo): https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
  // - 50 Nuevos Pesos (Cuauhtémoc): https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
  // - 100 Nuevos Pesos (Plutarco Elías Calles): https://www.banxico.org.mx/billetes-y-monedas/familia-b-proceso-retiro-ban.html
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1993,
    maxYear: 1995,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B1.6 México Billetes - Familia C (1994–2001)
  // Ref General: Banco de México - Billetes de la Familia C en proceso de retiro:
  // https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
  // Denominación - Modelo / Referencias:
  // - 10 Pesos (Emiliano Zapata): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
  // - 20 Pesos (Benito Juárez): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
  // - 50 Pesos (José María Morelos): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
  // - 100 Pesos (Nezahualcóyotl): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
  // - 200 Pesos (Sor Juana Inés de la Cruz): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
  // - 500 Pesos (Ignacio Zaragoza): https://www.banxico.org.mx/billetes-y-monedas/familia-c-circulacion-banco-m.html
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1994,
    maxYear: 2001,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B1.7 México Billetes - Familia D y D1 Introducción de Polímero (2002–2007)
  // Ref General: Banco de México - Billetes de las Familias D y D1:
  // https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
  // Denominación - Modelo / Referencias:
  // - 10 Pesos (Emiliano Zapata): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
  // - 20 Pesos (Polímero - Benito Juárez): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
  // - 50 Pesos (José María Morelos): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
  // - 100 Pesos (Nezahualcóyotl): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
  // - 200 Pesos (Sor Juana Inés de la Cruz): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
  // - 500 Pesos (Ignacio Zaragoza): https://www.banxico.org.mx/billetes-y-monedas/familia-d1-proceso-retiro-ba.html
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2002,
    maxYear: 2007,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B1.8 México Billetes - Familia F y Conmemorativos del Centenario/Bicentenario (2006–2019)
  // Ref General: Banco de México - Billetes de la Familia F en circulación:
  // https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
  // Denominación - Modelo / Referencias:
  // - 20 Pesos (Polímero - Benito Juárez / Zona Arqueológica de Monte Albán): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
  // - 50 Pesos (Polímero - José María Morelos / Acueducto de Morelia): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
  // - 100 Pesos (Papel de algodón - Nezahualcóyotl / Centenario Revolución 2010 / Centenario Constitución 2017): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
  // - 200 Pesos (Papel de algodón - Sor Juana Inés de la Cruz / Bicentenario Independencia 2010): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
  // - 500 Pesos (Papel de algodón - Diego Rivera y Frida Kahlo): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
  // - 1000 Pesos (Papel de algodón - Miguel Hidalgo / Universidad de Guanajuato): https://www.banxico.org.mx/billetes-y-monedas/familia-f-circulacion-banco-m.html
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2006,
    maxYear: 2019,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '20', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Papel de algodón',
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
        motifs: [
          NumismaticMotifRule.standard(),
          NumismaticMotifRule('Centenario de la Revolución Mexicana (2010)', 2009, 2010),
          NumismaticMotifRule('Centenario de la Constitución Política de 1917 (2017)', 2016, 2017),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Papel de algodón',
        isBanknote: true,
        motifs: [
          NumismaticMotifRule.standard(),
          NumismaticMotifRule('Bicentenario de la Independencia de México (2010)', 2009, 2010),
        ],
      ),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B1.9 México Billetes - Familia G en Circulación y Polímeros de Vanguardia (2020–presente)
  // Ref General: Banco de México - Billetes de la Familia G:
  // https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
  // Denominación - Modelo / Referencias:
  // - 20 Pesos (Polímero - Bicentenario de la Independencia Nacional): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
  // - 50 Pesos (Polímero - Fundación de Tenochtitlan / Ajolote y Xochimilco): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
  // - 100 Pesos (Polímero - Sor Juana Inés de la Cruz / Bosques Templados y Mariposa Monarca): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
  // - 200 Pesos (Papel de algodón - Miguel Hidalgo y José María Morelos / Reserva El Pinacate): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
  // - 500 Pesos (Papel de algodón - Benito Juárez / Ballena Gris y Pastos Marinos El Vizcaíno): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
  // - 1000 Pesos (Papel de algodón - Francisco I. Madero, Hermila Galindo y Carmen Serdán / Calakmul y Jaguar): https://www.banxico.org.mx/billetes-y-monedas/familia-g-circulacion-banco-m.html
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
        isBanknote: true,
        motifs: [
          NumismaticMotifRule.standard(),
          NumismaticMotifRule('Bicentenario de la Independencia Nacional (2021)', 2021),
        ],
      ),
      NumismaticPieceDefinition(denomination: '50', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Polímero',
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
      ),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B2.1 Estados Unidos Billetes - Large Size Notes (1861–1927)
  // Ref General: US Bureau of Engraving and Printing - Large Size Currency: https://www.bep.gov
  // Ref General: Numista - United States - Banknotes (Large Size):
  // https://en.numista.com/catalogue/united-states-banknotes-1.html
  // Denominación - Modelo / Referencias:
  // - 1, 2, 5, 10, 20, 50, 100, 500, 1000, 5000, 10000 Dollars (Legal Tender, Silver & Gold Certificates, National Bank Notes): https://www.bep.gov
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    minYear: 1861,
    maxYear: 1927,
    validCurrencies: ['USD'],
    defaultCurrency: 'USD',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B2.2 Estados Unidos Billetes - Small Size Federal Reserve Notes (1928–presente)
  // Ref General: US Bureau of Engraving and Printing - Currency Denominations:
  // https://www.bep.gov/currency/denominations
  // Ref General: US Federal Reserve - Currency: https://www.federalreserve.gov
  // Denominación - Modelo / Referencias:
  // - $1 (George Washington / Great Seal): https://www.federalreserve.gov/faqs/currency_12773.htm
  // - $2 (Thomas Jefferson / Declaration of Independence): https://www.federalreserve.gov/faqs/currency_12773.htm
  // - $5 (Abraham Lincoln / Lincoln Memorial): https://www.federalreserve.gov/faqs/currency_12773.htm
  // - $10 (Alexander Hamilton / US Treasury): https://www.federalreserve.gov/faqs/currency_12773.htm
  // - $20 (Andrew Jackson / White House): https://www.federalreserve.gov/faqs/currency_12773.htm
  // - $50 (Ulysses S. Grant / US Capitol): https://www.federalreserve.gov/faqs/currency_12773.htm
  // - $100 (Benjamin Franklin / Independence Hall): https://www.federalreserve.gov/faqs/currency_12773.htm
  // - $500, $1000, $5000, $10000, $100000 (McKinley, Cleveland, Madison, Chase, Wilson): https://www.bep.gov
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    minYear: 1928,
    maxYear: 2100,
    validCurrencies: ['USD'],
    defaultCurrency: 'USD',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B3.1 España Billetes - Era de la Peseta (1874–2001)
  // Ref General: Banco de España - Billetes en pesetas:
  // https://www.bde.es/wbe/es/para-ciudadanos/billetes-y-monedas/pesetas/
  // Denominación - Modelo / Referencias:
  // - 1 a 10000 Pesetas (Cervantes, Velázquez, Goya, Rosalía de Castro, Juan Ramón Jiménez, Benito Pérez Galdós, José Celestino Mutis, Hernán Cortés, Juan Carlos I): https://www.bde.es/wbe/es/para-ciudadanos/billetes-y-monedas/pesetas/
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 1874,
    maxYear: 2001,
    validCurrencies: ['ESP'],
    defaultCurrency: 'ESP',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '25', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B3.2 España & Unión Europea Billetes - Era del Euro (2002–presente)
  // Ref General: Banco Central Europeo - Billetes en euros (Series 2002 y Europa):
  // https://www.ecb.europa.eu/euro/banknotes/html/index.es.html
  // Denominación - Modelo / Referencias:
  // - 5, 10, 20, 50, 100, 200, 500 Euros (Arquitectura Clásica, Románica, Gótica, Renacentista, Barroca, Modernista): https://www.ecb.europa.eu/euro/banknotes/html/index.es.html
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 2002,
    maxYear: 2100,
    validCurrencies: ['EUR'],
    defaultCurrency: 'EUR',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
    ],
  ),

  // B4.1 Guatemala Billetes - Quetzales Clásicos y Modernos (1948–2006)
  // Ref General: Banco de Guatemala - Historia de los Billetes de Quetzal: https://www.banguat.gob.gt
  // Denominación - Modelo / Referencias:
  // - 0.50, 1, 5, 10, 20, 50, 100, 200 Quetzales (Tecún Umán, José María Orellana, Justo Rufino Barrios, Miguel García Granados, Mariano Gálvez, Carlos Mérida, Francisco Marroquín): https://www.banguat.gob.gt
  NumismaticEmissionRuleData(
    country: 'Guatemala',
    minYear: 1948,
    maxYear: 2006,
    validCurrencies: ['GTQ'],
    defaultCurrency: 'GTQ',
    isBanknote: true,
    pieces: [
      NumismaticPieceDefinition(denomination: '0.50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100000', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '5', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Polímero', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '3', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '3', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20000', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '1', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Papel de algodón',
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
      ),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Polímero', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20000', material: 'Papel de algodón', isBanknote: true),
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
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Papel de algodón',
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Papel de algodón',
        isBanknote: true,
        allowedMaterials: ['Papel de algodón', 'Polímero'],
      ),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
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
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Polímero',
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Polímero',
        isBanknote: true,
        allowedMaterials: ['Polímero', 'Papel de algodón'],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Polímero',
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
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '5', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '20', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '200', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
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
      NumismaticPieceDefinition(denomination: '500', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '1000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '2000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '5000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '10000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '50000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '100000', material: 'Papel de algodón', isBanknote: true),
      NumismaticPieceDefinition(denomination: '500000', material: 'Papel de algodón', isBanknote: true),
    ],
  ),
];
