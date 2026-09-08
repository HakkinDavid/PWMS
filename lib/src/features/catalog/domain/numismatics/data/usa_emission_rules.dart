import 'numismatic_materials_registry.dart';
import '../models/numismatic_models.dart';

/// Historical emission rules for the United States of America (Continental, Pre-Federal, Classic Silver/Gold, Clad, State Quarters, Modern Series).
const List<NumismaticEmissionRuleData> usaEmissionRules = [
  // 2.1 Estados Unidos - Período Continental y Pre-Federal (1775–1791)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USC',
        motifs: [
          NumismaticMotifRule(
            'Mind Your Business / We Are One',
            minYear: 1787,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'USC',
        motifs: [
          NumismaticMotifRule(
            'Sun Dial (Continental Currency)',
            minYear: 1776,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        currency: 'USC',
        motifs: [
          NumismaticMotifRule(
            'Spanish Milled Dollar (Libre Circulación)',
            minYear: 1775,
            maxYear: 1791,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
    ],
  ),

  // 2.2 Estados Unidos - Large Cent, Half Cent y Plata/Oro Clásica (1792–1857)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.005',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Liberty Cap / Draped Bust / Classic Head / Braided Hair',
            minYear: 1793,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Flowing Hair / Draped Bust / Classic Head / Coronet / Braided Hair',
            minYear: 1793,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Plata .892/.900 (Flowing Hair / Draped Bust / Capped Bust / Seated Liberty)',
            minYear: 1794,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Plata .892/.900 (Draped Bust / Capped Bust / Seated Liberty)',
            minYear: 1796,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Plata .892/.900 (Draped Bust / Capped Bust / Seated Liberty)',
            minYear: 1796,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Plata .892/.900 (Flowing Hair / Draped Bust / Capped Bust / Seated Liberty)',
            minYear: 1794,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Silver Dollar Plata .892/.900 (Flowing Hair, Draped Bust, Gobrecht, Seated Liberty)',
            minYear: 1794,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
          NumismaticMotifRule(
            'Gold Dollar Oro .900 (Liberty Head Type 1 / Indian Princess Type 2)',
            minYear: 1849,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Quarter Eagle Oro .900 (Draped Bust, Capped Bust, Classic Head, Coronet Liberty)',
            minYear: 1796,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Indian Princess Head (Oro .900)',
            minYear: 1854,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Half Eagle Oro .900 (Draped Bust, Capped Bust, Classic Head, Coronet Liberty)',
            minYear: 1795,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Eagle Oro .900 (Draped Bust, Coronet Liberty)',
            minYear: 1795,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Double Eagle Oro .900 (Coronet Liberty Head)',
            minYear: 1849,
            maxYear: 1857,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
    ],
  ),

  // 2.3 Estados Unidos - Small Cent, Guerra Civil y Nuevas Denominaciones (1858–1873)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Indian Head Cent / Flying Eagle Cent',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Shield (In God We Trust)',
            minYear: 1864,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.03',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Star / Liberty Head',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Shield Nickel / Seated Liberty Half Dime',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Seated Liberty Dime Plata .900',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Seated Liberty Quarter Plata .900',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Seated Liberty Half Dollar Plata .900',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Seated Liberty Dollar Plata .900',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
          NumismaticMotifRule(
            'Gold Dollar Oro .900 (Indian Princess Type 3)',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Coronet Liberty Quarter Eagle Oro .900',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Indian Princess Head (Oro .900)',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Coronet Liberty Half Eagle Oro .900',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Coronet Liberty Eagle Oro .900',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Coronet Liberty Double Eagle Oro .900',
            minYear: 1858,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
    ],
  ),

  // 2.4 Estados Unidos - Era Clásica Morgan/Peace y Oro Saint-Gaudens (1874–1933)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Indian Head Cent / Lincoln Wheat Cent',
            minYear: 1874,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Shield, Liberty "V", Indian Head / Buffalo Nickel',
            minYear: 1874,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Barber Dime / Winged Liberty Head "Mercury" Dime Plata .900',
            minYear: 1874,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Seated Liberty (Plata .900)',
            minYear: 1875,
            maxYear: 1878,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Barber Quarter / Standing Liberty Quarter / Washington Quarter Plata .900',
            minYear: 1874,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Barber Half / Walking Liberty Half Dollar Plata .900',
            minYear: 1874,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Morgan Dollar (1878-1921)',
            minYear: 1878,
            maxYear: 1921,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
          NumismaticMotifRule(
            'Peace Dollar (1921-1935)',
            minYear: 1921,
            maxYear: 1935,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
          NumismaticMotifRule(
            'Trade Dollar (1873-1885)',
            minYear: 1873,
            maxYear: 1885,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
          NumismaticMotifRule(
            'Gold Dollar Oro .900 (Indian Princess Type 3)',
            minYear: 1874,
            maxYear: 1889,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Quarter Eagle Oro .900 (Coronet Liberty / Indian Head)',
            minYear: 1874,
            maxYear: 1929,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '3',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Indian Princess Head (Oro .900)',
            minYear: 1874,
            maxYear: 1889,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Stella - Flowing Hair / Coiled Hair (Oro .900)',
            minYear: 1879,
            maxYear: 1880,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Half Eagle Oro .900 (Coronet Liberty / Indian Head)',
            minYear: 1874,
            maxYear: 1929,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Eagle Oro .900 (Coronet Liberty / Indian Head Saint-Gaudens)',
            minYear: 1874,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Double Eagle Oro .900 (Coronet Liberty / Saint-Gaudens Walking Liberty)',
            minYear: 1874,
            maxYear: 1933,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Panama-Pacific - Minerva / Búho (Oro .900)',
            minYear: 1915,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
    ],
  ),

  // 2.5 Estados Unidos - Pre-Clad Estándar Plata .900 (1934–1964)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Lincoln Wheat Cent (1909-1958)',
            minYear: 1934,
            maxYear: 1958,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
          NumismaticMotifRule(
            '1943 Steel Cent (Acero bañado en zinc)',
            minYear: 1943,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
          NumismaticMotifRule(
            'Lincoln Memorial Cent (1959-1982 Bronce)',
            minYear: 1959,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Buffalo / Indian Head Nickel (1913-1938)',
            minYear: 1934,
            maxYear: 1938,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Jefferson Nickel Estándar (1938-1942, 1946-1964)',
            minYear: 1938,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Jefferson War Nickel Plata .350 (1942-1945 Mintmark sobre Monticello)',
            minYear: 1942,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Winged Liberty Head "Mercury" Dime Plata .900 (1916-1945)',
            minYear: 1934,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
          NumismaticMotifRule(
            'Roosevelt Dime Plata .900 (1946-1964)',
            minYear: 1946,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Washington Quarter Plata .900 (1932-1964)',
            minYear: 1934,
            maxYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Walking Liberty Half Dollar Plata .900 (1916-1947)',
            minYear: 1934,
            maxYear: 1947,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
          NumismaticMotifRule(
            'Franklin Half Dollar Plata .900 (1948-1963)',
            minYear: 1948,
            maxYear: 1963,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
          NumismaticMotifRule(
            'Kennedy Half Dollar Plata .900',
            minYear: 1964,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
    ],
  ),

  // 2.6 Estados Unidos - Transición Clad & Kennedy Half Dollar 40% Plata (1965–1970)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Lincoln Memorial Cent Latón .950 Cu',
            minYear: 1965,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Jefferson Nickel Cuproníquel',
            minYear: 1965,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Roosevelt Dime Clad Cuproníquel',
            minYear: 1965,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Washington Quarter Clad Cuproníquel',
            minYear: 1965,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Kennedy Half Dollar Plata .400 (Clad Silver)',
            minYear: 1965,
            maxYear: 1970,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
    ],
  ),

  // 2.7 Estados Unidos - Era Clad Cuproníquel y Bicentenario (1971–1981)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Lincoln Memorial Cent',
            minYear: 1971,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Jefferson Nickel',
            minYear: 1971,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Roosevelt Dime Clad',
            minYear: 1971,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Washington Quarter Clad Estándar (1971-1974, 1977-1981)',
            minYear: 1971,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Bicentenario de los Estados Unidos - Tamborilero Colonial (1776-1976)',
            minYear: 1975,
            maxYear: 1976,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Kennedy Half Dollar Clad Cuproníquel (1971-1974, 1977-1981)',
            minYear: 1971,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Bicentenario de los Estados Unidos - Independence Hall (1776-1976)',
            minYear: 1975,
            maxYear: 1976,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Eisenhower Dollar Clad - Águila Apolo 11 (1971-1974, 1977-1978)',
            minYear: 1971,
            maxYear: 1978,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Eisenhower Bicentennial - Moon and Liberty Bell (1776-1976)',
            minYear: 1975,
            maxYear: 1976,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Susan B. Anthony Dollar (1979-1981)',
            minYear: 1979,
            maxYear: 1981,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 2.8 Estados Unidos - Centavos de Zinc y 50 State Quarters (1982–1999)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Lincoln Memorial Cent Core Zinc',
            minYear: 1982,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameCopperPlatedZinc,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Jefferson Nickel',
            minYear: 1982,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Roosevelt Dime Clad',
            minYear: 1982,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Washington Quarter Clad Estándar (1982-1998)',
            minYear: 1982,
            maxYear: 1998,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Delaware',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Pennsylvania',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - New Jersey',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Georgia',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Connecticut',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Kennedy Half Dollar Clad',
            minYear: 1982,
            maxYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Susan B. Anthony Dollar',
            minYear: 1999,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 2.9 Estados Unidos - Golden Dollar y Programas Modernos (2000–presente)
  NumismaticEmissionRuleData(
    country: 'Estados Unidos',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Lincoln Memorial (1959-2008)',
            minYear: 2000,
            maxYear: 2008,
            material: NumismaticMaterialsRegistry.nameCopperPlatedZinc,
          ),
          NumismaticMotifRule(
            'Lincoln Bicentennial - Birthplace',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCopperPlatedZinc,
          ),
          NumismaticMotifRule(
            'Lincoln Bicentennial - Formative Years in Indiana',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCopperPlatedZinc,
          ),
          NumismaticMotifRule(
            'Lincoln Bicentennial - Professional Life in Illinois',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCopperPlatedZinc,
          ),
          NumismaticMotifRule(
            'Lincoln Bicentennial - Presidency in Washington D.C.',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCopperPlatedZinc,
          ),
          NumismaticMotifRule(
            'Union Shield - Escudo de la Unión (2010+)',
            minYear: 2010,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCopperPlatedZinc,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Jefferson Nickel - Monticello (1938-2003)',
            minYear: 2000,
            maxYear: 2003,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Westward Journey - Peace Medal',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Westward Journey - Keelboat',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Westward Journey - American Bison',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Westward Journey - Ocean in View',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Jefferson Nickel - Return to Monticello (2006+)',
            minYear: 2006,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Roosevelt Dime Clad',
            minYear: 2000,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            '50 State Quarters - Massachusetts',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Maryland',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - South Carolina',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - New Hampshire',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Virginia',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - New York',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - North Carolina',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Rhode Island',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Vermont',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Kentucky',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Tennessee',
            minYear: 2002,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Ohio',
            minYear: 2002,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Louisiana',
            minYear: 2002,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Indiana',
            minYear: 2002,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Mississippi',
            minYear: 2002,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Illinois',
            minYear: 2003,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Alabama',
            minYear: 2003,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Maine',
            minYear: 2003,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Missouri',
            minYear: 2003,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Arkansas',
            minYear: 2003,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Michigan',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Florida',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Texas',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Iowa',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Wisconsin',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - California',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Minnesota',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Oregon',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Kansas',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - West Virginia',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Nevada',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Nebraska',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Colorado',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - North Dakota',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - South Dakota',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Montana',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Washington',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Idaho',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Wyoming',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Utah',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Oklahoma',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - New Mexico',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Arizona',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Alaska',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '50 State Quarters - Hawaii',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'District of Columbia & US Territories - District of Columbia',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'District of Columbia & US Territories - Puerto Rico',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'District of Columbia & US Territories - Guam',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'District of Columbia & US Territories - American Samoa',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'District of Columbia & US Territories - U.S. Virgin Islands',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'District of Columbia & US Territories - Northern Mariana Islands',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Hot Springs',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Yellowstone',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Yosemite',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Grand Canyon',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Mount Hood',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Gettysburg',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Glacier',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Olympic',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Vicksburg',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Chickasaw',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - El Yunque',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Chaco Culture',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Acadia',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Hawaii Volcanoes',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Denali',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - White Mountain',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Perry\'s Victory',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Great Basin',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Fort McHenry',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Mount Rushmore',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Great Smoky Mountains',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Shenandoah',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Arches',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Great Sand Dunes',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Everglades',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Homestead',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Kisatchie',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Blue Ridge Parkway',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Bombay Hook',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Saratoga',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Shawnee',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Cumberland Gap',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Harpers Ferry',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Theodore Roosevelt',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Fort Moultrie',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Effigy Mounds',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Frederick Douglass',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Ozark Riverways',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Ellis Island',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - George Rogers Clark',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Pictured Rocks',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Apostle Islands',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Voyageurs',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Cumberland Island',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Block Island',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Lowell',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - American Memorial Park',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - War in the Pacific',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - San Antonio Missions',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Frank Church River of No Return',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - National Park of American Samoa',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Weir Farm',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Salt River Bay',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Marsh-Billings-Rockefeller',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Tallgrass Prairie',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'America the Beautiful - Tuskegee Airmen',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'General George Washington Crossing the Delaware',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Maya Angelou',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Dr. Sally Ride',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Wilma Mankiller',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Nina Otero-Warren',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Anna May Wong',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Bessie Coleman',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Edith Kanakaʻole',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Eleanor Roosevelt',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Jovita Idár',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Maria Tallchief',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Rev. Dr. Pauli Murray',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Patsy Takemoto Mink',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Dr. Mary Edwards Walker',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Celia Cruz',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Zitkala-Ša',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Ida B. Wells',
            minYear: 2025,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Juliette Gordon Low',
            minYear: 2025,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Dr. Vera Rubin',
            minYear: 2025,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Althea Gibson',
            minYear: 2025,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'American Women - Stacey Park Milbern',
            minYear: 2025,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Kennedy Half Dollar Clad',
            minYear: 2000,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'USD',
        motifs: [
          NumismaticMotifRule(
            'Sacagawea Dollar - Águila en Vuelo (2000-2008)',
            minYear: 2000,
            maxYear: 2008,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Tres Hermanas Agricultura',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Gran Árbol de la Paz',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Tratado Wampanoag',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Rutas Comerciales del Siglo XVII',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Tratado con los Lenape',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Hospitalidad Nativa',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Trabajadores del Hierro Mohawk',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Codificadores de Clave',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Sequoyah',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Jim Thorpe',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Mary Golda Ross y Programa Espacial',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Elizabeth Peratrovich',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Servicio Militar Indígena',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Ely S. Parker',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Maria Tallchief',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Native American - Ley de Ciudadanía Indígena',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - George Washington',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - John Adams',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Thomas Jefferson',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - James Madison',
            minYear: 2007,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - James Monroe',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - John Quincy Adams',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Andrew Jackson',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Martin Van Buren',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - William Henry Harrison',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - John Tyler',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - James K. Polk',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Zachary Taylor',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Millard Fillmore',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Franklin Pierce',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - James Buchanan',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Abraham Lincoln',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Andrew Johnson',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Ulysses S. Grant',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Rutherford B. Hayes',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - James A. Garfield',
            minYear: 2011,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Chester A. Arthur',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Grover Cleveland - 1st Term',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Benjamin Harrison',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Grover Cleveland - 2nd Term',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - William McKinley',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Theodore Roosevelt',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - William Howard Taft',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Woodrow Wilson',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Warren G. Harding',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Calvin Coolidge',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Herbert Hoover',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Franklin D. Roosevelt',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Harry S. Truman',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Dwight D. Eisenhower',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - John F. Kennedy',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Lyndon B. Johnson',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Richard M. Nixon',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Gerald R. Ford',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - Ronald Reagan',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'Presidential Dollar - George H.W. Bush',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Primera Patente',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Delaware',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Pennsylvania',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - New Jersey',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Georgia',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Connecticut',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Massachusetts',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Maryland',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - South Carolina',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - New Hampshire',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Virginia',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - New York',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - North Carolina',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Rhode Island',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Vermont',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Kentucky',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Tennessee',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Ohio',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Louisiana',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Indiana',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Mississippi',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Illinois',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Alabama',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Maine',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
          NumismaticMotifRule(
            'American Innovation - Missouri',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameCladManganeseBrassCopper,
          ),
        ],
      ),
    ],
  ),
];
