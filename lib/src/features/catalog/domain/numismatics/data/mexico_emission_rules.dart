import '../models/numismatic_models.dart';

/// Historical emission rules for Mexico and colonial predecessors (Virreinato, Primer y Segundo Imperio, República, Monedas y Billetes modernos).
const List<NumismaticEmissionRuleData> mexicoEmissionRules = [
  // 1.1 Virreinato de Nueva España (1536–1821)
  NumismaticEmissionRuleData(
    country: 'Virreinato de Nueva España',
    minYear: 1536,
    maxYear: 1821,
    validCurrencies: ['MXR', 'REAL', 'MXE', 'ESC', 'MRV'],
    defaultCurrency: 'MXR',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/16',
        material: 'Cobre',
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Tlaco de Cobre', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/8',
        material: 'Cobre',
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Virreinal de Cobre', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Cobre'],
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Virreinal (Castillo y León)', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Virreinal (Columnario / Busto)', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Columnario / Busto', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Virreinal (Columnario / Busto)', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Oro'],
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Columnario / Busto / Escudos', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Oro'],
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Columnario / Busto / Escudos', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.5',
        material: 'Oro',
        minYear: 1772,
        maxYear: 1820,
        motifs: [
          NumismaticMotifRule('Escudo de Oro Virreinal', 1772, 1820),
        ],
      ),
    ],
  ),

  // 1.2 Primer Imperio Mexicano - Agustín de Iturbide (1822–1823)
  NumismaticEmissionRuleData(
    country: 'Imperio Mexicano (Primer y Segundo Imperio)',
    minYear: 1822,
    maxYear: 1823,
    validCurrencies: ['MXR', 'MXE'],
    defaultCurrency: 'MXR',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/8',
        material: 'Cobre',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Cobre',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Oro',
        allowedMaterials: ['Oro', 'Plata'],
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Oro'],
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
    ],
  ),

  // 1.3 Segundo Imperio Mexicano - Maximiliano (1864–1867)
  NumismaticEmissionRuleData(
    country: 'Imperio Mexicano (Primer y Segundo Imperio)',
    minYear: 1864,
    maxYear: 1867,
    validCurrencies: ['MXP', 'MXR'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1864,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Corona Imperial (Maximiliano)', 1864, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Plata',
        minYear: 1864,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Plata (Maximiliano)', 1864, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1864,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Plata (Maximiliano)', 1864, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1866,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Busto Emperador Maximiliano', 1866, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1866,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Busto Emperador Maximiliano', 1866, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1866,
        maxYear: 1866,
        motifs: [
          NumismaticMotifRule('Busto Emperador Maximiliano', 1866),
        ],
      ),
    ],
  ),

  // 1.4 México - Período Virreinal novohispano (1536–1821)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1536,
    maxYear: 1821,
    validCurrencies: ['MXR', 'MXE', 'REAL', 'ESC'],
    defaultCurrency: 'MXR',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/8',
        material: 'Cobre',
        minYear: 1814,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Virreinal de Cobre', 1814, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Cobre'],
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Virreinal (Castillo y León)', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Virreinal (Columnario / Busto)', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Columnario / Busto', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Virreinal (Columnario / Busto)', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Oro'],
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Columnario / Busto / Escudos', 1536, 1821),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Oro'],
        minYear: 1536,
        maxYear: 1821,
        motifs: [
          NumismaticMotifRule('Columnario / Busto / Escudos', 1536, 1821),
        ],
      ),
    ],
  ),

  // 1.5 México - Primer Imperio (1822–1823)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1822,
    maxYear: 1823,
    validCurrencies: ['MXR', 'MXE'],
    defaultCurrency: 'MXR',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/8',
        material: 'Cobre',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Cobre',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Oro',
        allowedMaterials: ['Oro', 'Plata'],
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Oro'],
        minYear: 1822,
        maxYear: 1823,
        motifs: [
          NumismaticMotifRule('Agustín de Iturbide', 1822, 1823),
        ],
      ),
    ],
  ),

  // 1.6 México - República Mexicana Sistema de Reales y Escudos (1823–1897)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1823,
    maxYear: 1897,
    validCurrencies: ['MXR', 'MXE', 'REAL', 'ESC'],
    defaultCurrency: 'MXR',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/16',
        material: 'Cobre',
        minYear: 1829,
        maxYear: 1863,
        motifs: [
          NumismaticMotifRule('Águila Republicana (Cobre)', 1829, 1863),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/8',
        material: 'Cobre',
        minYear: 1829,
        maxYear: 1863,
        motifs: [
          NumismaticMotifRule('Águila Republicana', 1829, 1863),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Cobre'],
        minYear: 1824,
        maxYear: 1863,
        motifs: [
          NumismaticMotifRule('Gorro Frigio / Águila Republicana', 1824, 1863),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1824,
        maxYear: 1863,
        motifs: [
          NumismaticMotifRule('Resplandor', 1824, 1863),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1824,
        maxYear: 1863,
        motifs: [
          NumismaticMotifRule('Resplandor', 1824, 1863),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1824,
        maxYear: 1863,
        motifs: [
          NumismaticMotifRule('Resplandor', 1824, 1863),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Oro'],
        minYear: 1824,
        maxYear: 1863,
        motifs: [
          NumismaticMotifRule('Columnario / Busto / Escudos', 1824, 1863),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Oro'],
        minYear: 1823,
        maxYear: 1897,
        motifs: [
          NumismaticMotifRule('Resplandor (Cap and Rays) / Escudos Oro', 1823, 1897),
        ],
      ),
    ],
  ),

  // 1.7 México - Segundo Imperio Serie Maximiliano Decimal (1864–1867)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1864,
    maxYear: 1867,
    validCurrencies: ['MXP', 'MXR'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1864,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Corona Imperial (Maximiliano)', 1864, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Plata',
        minYear: 1864,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Plata (Maximiliano)', 1864, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1864,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Plata (Maximiliano)', 1864, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1866,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Busto Emperador Maximiliano', 1866, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1866,
        maxYear: 1867,
        motifs: [
          NumismaticMotifRule('Busto Emperador Maximiliano', 1866, 1867),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1866,
        maxYear: 1866,
        motifs: [
          NumismaticMotifRule('Busto Emperador Maximiliano', 1866),
        ],
      ),
    ],
  ),

  // 1.8 México - República Restaurada Sistema Balanza Decimal (1868–1881)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1868,
    maxYear: 1881,
    validCurrencies: ['MXP', 'MXE', 'MXR'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1869,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Balanza', 1869, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Cobre',
        minYear: 1869,
        maxYear: 1879,
        motifs: [
          NumismaticMotifRule('Balanza', 1869, 1879),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Balanza', 1869, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Balanza', 1869, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Balanza', 1869, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Balanza', 1869, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1873,
        motifs: [
          NumismaticMotifRule('Balanza', 1869, 1873),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        material: 'Oro',
        minYear: 1870,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Dos y Medio Pesos Oro Balanza', 1870, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1870,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Oro Balanza', 1870, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1870,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Oro Balanza', 1870, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1870,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Oro Balanza', 1870, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1868,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('Resplandor (Acuñación concurrente)', 1868, 1881),
        ],
      ),
    ],
  ),

  // 1.9 México - Crisis del Níquel (1882–1883)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1882,
    maxYear: 1883,
    validCurrencies: ['MXP', 'MXE', 'MXR'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Níquel',
        allowedMaterials: ['Níquel', 'Cuproníquel'],
        minYear: 1882,
        maxYear: 1883,
        motifs: [
          NumismaticMotifRule('de Níquel', 1882, 1883),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Níquel',
        allowedMaterials: ['Níquel', 'Cuproníquel'],
        minYear: 1882,
        maxYear: 1883,
        motifs: [
          NumismaticMotifRule('de Níquel', 1882, 1883),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Níquel',
        allowedMaterials: ['Níquel', 'Cuproníquel'],
        minYear: 1882,
        maxYear: 1883,
        motifs: [
          NumismaticMotifRule('de Níquel', 1882, 1883),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1882,
        maxYear: 1883,
        motifs: [
          NumismaticMotifRule('Balanza', 1882, 1883),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Plata',
        minYear: 1882,
        maxYear: 1883,
        motifs: [
          NumismaticMotifRule('Balanza', 1882, 1883),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1882,
        maxYear: 1883,
        motifs: [
          NumismaticMotifRule('Balanza', 1882, 1883),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1882,
        maxYear: 1883,
        motifs: [
          NumismaticMotifRule('Resplandor', 1882, 1883),
        ],
      ),
    ],
  ),

  // 1.10 México - Porfiriato Decimal Resplandor (1884–1904)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1884,
    maxYear: 1904,
    validCurrencies: ['MXP', 'MXE', 'MXR'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Cobre',
        minYear: 1884,
        maxYear: 1898,
        motifs: [
          NumismaticMotifRule('Porfiriano Cobre', 1884, 1898),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Cobre',
        minYear: 1884,
        maxYear: 1898,
        motifs: [
          NumismaticMotifRule('Porfiriano Cobre', 1884, 1898),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Plata',
        minYear: 1884,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('Plata Balanza / Corona', 1884, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1884,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('Plata Balanza / Corona', 1884, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Plata',
        minYear: 1898,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('Corona Porfiriana', 1898, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1884,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('Plata Gorro Frigio y Balanza', 1884, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1898,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('Fuerte Resplandor', 1898, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1884,
        maxYear: 1897,
        motifs: [
          NumismaticMotifRule('Resplandor (Últimas emisiones)', 1884, 1897),
        ],
      ),
    ],
  ),

  // 1.11 México - Reforma Monetaria Porfiriana de 1905 (1905–1914)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1905,
    maxYear: 1914,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1905,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Porfiriano Corona de Laurel', 1905, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1905,
        maxYear: 1906,
        motifs: [
          NumismaticMotifRule('Porfiriano Bronce', 1905, 1906),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1905,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Porfiriano Níquel', 1905, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1905,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Plata .800 Corona', 1905, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Plata',
        minYear: 1905,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Plata .800 Corona', 1905, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1905,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Plata Resplandor', 1905, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1905,
        maxYear: 1909,
        motifs: [
          NumismaticMotifRule('Fuerte Resplandor', 1905, 1909),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1910,
        maxYear: 1914,
        motifs: [
          NumismaticMotifRule('Caballito - Centenario de la Independencia (1910-1914)', 1910, 1914),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1905,
        maxYear: 1910,
        motifs: [
          NumismaticMotifRule('Oro Hidalgo', 1905, 1910),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1905,
        maxYear: 1910,
        motifs: [
          NumismaticMotifRule('Oro Hidalgo', 1905, 1910),
        ],
      ),
    ],
  ),

  // 1.12 México - Período Revolucionario / Constitucionalista (1915–1919)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1915,
    maxYear: 1919,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1915,
        maxYear: 1919,
        motifs: [
          NumismaticMotifRule('Revolucionario Bronce', 1915, 1919),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1915,
        maxYear: 1916,
        motifs: [
          NumismaticMotifRule('Revolucionario', 1915, 1916),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce',
        minYear: 1915,
        maxYear: 1919,
        motifs: [
          NumismaticMotifRule('Bronce Constitucionalista', 1915, 1919),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1919,
        maxYear: 1919,
        motifs: [
          NumismaticMotifRule('Plata .800', 1919),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Plata',
        minYear: 1919,
        maxYear: 1919,
        motifs: [
          NumismaticMotifRule('Plata .800', 1919),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1918,
        maxYear: 1919,
        motifs: [
          NumismaticMotifRule('Plata .800 Resplandor Reducido', 1918, 1919),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1918,
        maxYear: 1919,
        motifs: [
          NumismaticMotifRule('Plata .800 Resplandor Reducido', 1918, 1919),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Oro',
        minYear: 1919,
        maxYear: 1920,
        motifs: [
          NumismaticMotifRule('Oro Hidalgo', 1919, 1920),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        material: 'Oro',
        minYear: 1918,
        maxYear: 1920,
        motifs: [
          NumismaticMotifRule('Dos y Medio Pesos Oro Hidalgo', 1918, 1920),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Oro',
        minYear: 1919,
        maxYear: 1920,
        motifs: [
          NumismaticMotifRule('Oro Hidalgo', 1919, 1920),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1916,
        maxYear: 1920,
        motifs: [
          NumismaticMotifRule('Oro Hidalgo', 1916, 1920),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1917,
        maxYear: 1921,
        motifs: [
          NumismaticMotifRule('Oro Calendario Azteca', 1917, 1921),
        ],
      ),
    ],
  ),

  // 1.13 México - Ley .720 y Centenario de Oro (1920–1942)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1920,
    maxYear: 1942,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1920,
        maxYear: 1942,
        motifs: [
          NumismaticMotifRule('Bronce Espigas', 1920, 1942),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1920,
        maxYear: 1941,
        motifs: [
          NumismaticMotifRule('Bronce', 1920, 1941),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Cuproníquel',
        minYear: 1920,
        maxYear: 1935,
        motifs: [
          NumismaticMotifRule('Níquel Josefa Chica', 1920, 1935),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce',
        minYear: 1936,
        maxYear: 1942,
        motifs: [
          NumismaticMotifRule('Bronce Josefa Ortiz de Perfil', 1936, 1942),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Plata',
        minYear: 1925,
        maxYear: 1935,
        motifs: [
          NumismaticMotifRule('Plata .720', 1925, 1935),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce',
        minYear: 1936,
        maxYear: 1940,
        motifs: [
          NumismaticMotifRule('Bronce', 1936, 1940),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Plata',
        minYear: 1920,
        maxYear: 1935,
        motifs: [
          NumismaticMotifRule('Plata .720 Gorro Frigio', 1920, 1935),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1920,
        maxYear: 1942,
        motifs: [
          NumismaticMotifRule('Plata .720 Resplandor', 1920, 1942),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1920,
        maxYear: 1942,
        motifs: [
          NumismaticMotifRule('Plata .720 Resplandor', 1920, 1942),
        ],
      ),
      // 2 Pesos 1921 Victoria Alada - PLATA .903
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1921,
        maxYear: 1921,
        motifs: [
          NumismaticMotifRule('Victoria Alada - Centenario de la Consumación de la Independencia', 1921),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Oro',
        minYear: 1921,
        maxYear: 1931,
        motifs: [
          NumismaticMotifRule('Oro - Centenario de la Independencia (37.5g Oro Puro)', 1921, 1931),
        ],
      ),
    ],
  ),

  // 1.14 México - Segunda Guerra y Postguerra (1943–1949)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1943,
    maxYear: 1949,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1943,
        maxYear: 1949,
        motifs: [
          NumismaticMotifRule('Espigas de Trigo', 1943, 1949),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce',
        minYear: 1943,
        maxYear: 1949,
        motifs: [
          NumismaticMotifRule('Josefa Ortiz Grande', 1943, 1949),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce',
        minYear: 1943,
        maxYear: 1949,
        motifs: [
          NumismaticMotifRule('Pirámide del Sol de Teotihuacán', 1943, 1949),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1943,
        maxYear: 1945,
        motifs: [
          NumismaticMotifRule('Plata .720 Resplandor', 1943, 1945),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1947,
        maxYear: 1948,
        motifs: [
          NumismaticMotifRule('Plata .420 Cuauhtémoc', 1947, 1948),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1947,
        maxYear: 1949,
        motifs: [
          NumismaticMotifRule('Plata .500 Morelos Cachetón', 1947, 1949),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1947,
        maxYear: 1948,
        motifs: [
          NumismaticMotifRule('Cuauhtémoc (1947-1948)', 1947, 1948),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Oro',
        minYear: 1943,
        maxYear: 1947,
        motifs: [
          NumismaticMotifRule('Oro Centenario', 1943, 1947),
        ],
      ),
    ],
  ),

  // 1.15 México - Década de 1950 (1950–1956)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1950,
    maxYear: 1956,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1950,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Espigas de Trigo', 1950, 1956),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Latón',
        minYear: 1950,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Latón Josefa', 1950, 1956),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Latón',
        minYear: 1955,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Latón Benito Juárez', 1955, 1956),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce',
        minYear: 1950,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Bronce Pirámide de Teotihuacán', 1950, 1956),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Cuproníquel',
        minYear: 1950,
        maxYear: 1953,
        motifs: [
          NumismaticMotifRule('Balanza Cuproníquel', 1950, 1953),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1950,
        maxYear: 1951,
        motifs: [
          NumismaticMotifRule('Plata .300 Morelos', 1950, 1951),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce',
        minYear: 1955,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Bronce Cuauhtémoc', 1955, 1956),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1950,
        maxYear: 1950,
        motifs: [
          NumismaticMotifRule('Plata .300 Morelos', 1950),
        ],
      ),
      // 5 Pesos 1950 Ferrocarril
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1950,
        maxYear: 1950,
        motifs: [
          NumismaticMotifRule('Inauguración del Ferrocarril del Sureste', 1950),
        ],
      ),
      // 5 Pesos 1951-1954 Hidalgo Laurel
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1951,
        maxYear: 1954,
        motifs: [
          NumismaticMotifRule('Hidalgo - Laurel (1951-1954)', 1951, 1954),
        ],
      ),
      // 5 Pesos 1953 Año de Hidalgo
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1953,
        maxYear: 1953,
        motifs: [
          NumismaticMotifRule('Año de Hidalgo - Bicentenario del Natalicio de Miguel Hidalgo', 1953),
        ],
      ),
      // 5 Pesos 1955-1957 Hidalgo Chico
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1955,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Hidalgo Chico (1955-1957)', 1955, 1957),
        ],
      ),
      // 10 Pesos 1955-1956 Hidalgo
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Plata',
        minYear: 1955,
        maxYear: 1956,
        motifs: [
          NumismaticMotifRule('Hidalgo Plata .900 (1955-1956)', 1955, 1956),
        ],
      ),
    ],
  ),

  // 1.16 México - Período de los Tepalcates y Conmemorativas (1957–1969)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1957,
    maxYear: 1969,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1957,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('Espigas de Trigo', 1957, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Latón',
        minYear: 1957,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('Latón Josefa', 1957, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Latón',
        minYear: 1957,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('Latón Benito Juárez', 1957, 1967),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce',
        minYear: 1957,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('Bronce Pirámide de Teotihuacán', 1957, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1964,
        maxYear: 1969,
        motifs: [
          NumismaticMotifRule('Cuproníquel Cuauhtémoc', 1964, 1969),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1957,
        maxYear: 1967,
        motifs: [
          NumismaticMotifRule('Plata .100 Morelos Tepalcate', 1957, 1967),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1957,
        maxYear: 1957,
        motifs: [
          NumismaticMotifRule('Centenario de la Constitución de 1857', 1957),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1957,
        maxYear: 1957,
        motifs: [
          NumismaticMotifRule('Centenario de la Constitución de 1857', 1957),
          NumismaticMotifRule('Hidalgo Chico', 1957),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Plata',
        minYear: 1957,
        maxYear: 1957,
        motifs: [
          NumismaticMotifRule('Centenario de la Constitución de 1857', 1957),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Plata',
        minYear: 1960,
        maxYear: 1960,
        motifs: [
          NumismaticMotifRule('150 Aniversario de la Independencia y 50 de la Revolución', 1960),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        material: 'Plata',
        minYear: 1968,
        maxYear: 1968,
        motifs: [
          NumismaticMotifRule('Juegos Olímpicos México 68 - Tipo 1 (Aros rectos / alineados)', 1968),
          NumismaticMotifRule('Juegos Olímpicos México 68 - Tipo 2 (Aros caídos / desiguales)', 1968),
        ],
      ),
    ],
  ),

  // 1.17 México - Transición Pirámide de Bronce y Monedas de Cuproníquel (1970–1973)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1970,
    maxYear: 1973,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Latón',
        minYear: 1970,
        maxYear: 1973,
        motifs: [
          NumismaticMotifRule('Latón Josefa Chica', 1970, 1973),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce',
        minYear: 1970,
        maxYear: 1971,
        motifs: [
          NumismaticMotifRule('Bronce Pirámide', 1970, 1971),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1970,
        maxYear: 1973,
        motifs: [
          NumismaticMotifRule('Cuproníquel Cuauhtémoc', 1970, 1973),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cuproníquel',
        minYear: 1970,
        maxYear: 1973,
        motifs: [
          NumismaticMotifRule('Cuproníquel José María Morelos', 1970, 1973),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1971,
        maxYear: 1973,
        motifs: [
          NumismaticMotifRule('Cuproníquel Vicente Guerrero', 1971, 1973),
        ],
      ),
    ],
  ),

  // 1.18 México - Serie Numismática Cuproníquel, Latón y Plata (1974–1983)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1974,
    maxYear: 1983,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Latón',
        minYear: 1974,
        maxYear: 1976,
        motifs: [
          NumismaticMotifRule('Latón Josefa', 1974, 1976),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Cuproníquel',
        minYear: 1974,
        maxYear: 1980,
        motifs: [
          NumismaticMotifRule('Mazorca de Maíz', 1974, 1980),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Latón',
        allowedMaterials: ['Latón', 'Cuproníquel'],
        minYear: 1974,
        maxYear: 1983,
        motifs: [
          NumismaticMotifRule('Francisco I. Madero / Cabeza Olmeca', 1974, 1983),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1974,
        maxYear: 1983,
        motifs: [
          NumismaticMotifRule('Cuauhtémoc', 1974, 1983),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Cuproníquel',
        minYear: 1974,
        maxYear: 1983,
        motifs: [
          NumismaticMotifRule('José María Morelos', 1974, 1983),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1974,
        maxYear: 1983,
        motifs: [
          NumismaticMotifRule('Vicente Guerrero / Quetzalcóatl', 1974, 1983),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Cuproníquel',
        minYear: 1974,
        maxYear: 1983,
        motifs: [
          NumismaticMotifRule('Heptagonal Miguel Hidalgo', 1974, 1983),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Cuproníquel',
        minYear: 1980,
        maxYear: 1983,
        motifs: [
          NumismaticMotifRule('Cultura Maya - Jugador de Pelota', 1980, 1983),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1982,
        maxYear: 1983,
        motifs: [
          NumismaticMotifRule('Coyolxauhqui - Templo Mayor', 1982, 1983),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Plata',
        minYear: 1977,
        maxYear: 1983,
        motifs: [
          NumismaticMotifRule('José María Morelos (Plata .720)', 1977, 1983),
        ],
      ),
    ],
  ),

  // 1.19 México - Acero Inoxidable, Latón y Valores Medios (1984–1987)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1984,
    maxYear: 1987,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Acero inoxidable',
        minYear: 1984,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Morelos Acero', 1984, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Latón',
        minYear: 1985,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Latón Josefa Ortiz', 1985, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Acero inoxidable',
        minYear: 1985,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Miguel Hidalgo (Acero)', 1985, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Latón',
        minYear: 1985,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Bronce Guadalupe Victoria', 1985, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        allowedMaterials: ['Cuproníquel', 'Acero inoxidable'],
        minYear: 1984,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Benito Juárez', 1984, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Bronce de aluminio',
        minYear: 1984,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Venustiano Carranza', 1984, 1987),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Cuproníquel',
        minYear: 1985,
        maxYear: 1986,
        motifs: [
          NumismaticMotifRule('175 Aniversario de la Independencia', 1985),
          NumismaticMotifRule('75 Aniversario de la Revolución', 1985),
          NumismaticMotifRule('Copa Mundial de la FIFA México 1986', 1986),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Cuproníquel',
        minYear: 1986,
        maxYear: 1987,
        motifs: [
          NumismaticMotifRule('Francisco I. Madero', 1986, 1987),
        ],
      ),
    ],
  ),

  // 1.20 México - Grandes Valores de Inflación Pre-N$ (1988–1992)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1988,
    maxYear: 1992,
    validCurrencies: ['MXP'],
    defaultCurrency: 'MXP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Acero inoxidable',
        minYear: 1988,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('Miguel Hidalgo (Acero)', 1988, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Latón',
        minYear: 1988,
        maxYear: 1990,
        motifs: [
          NumismaticMotifRule('Guadalupe Victoria', 1988, 1990),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Acero inoxidable',
        allowedMaterials: ['Acero inoxidable', 'Cuproníquel'],
        minYear: 1988,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Benito Juárez (Acero)', 1988, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Bronce de aluminio',
        minYear: 1988,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Venustiano Carranza', 1988, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Cuproníquel',
        minYear: 1988,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Francisco I. Madero', 1988, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        material: 'Bronce de aluminio',
        minYear: 1988,
        maxYear: 1992,
        motifs: [
          NumismaticMotifRule('Sor Juana Inés de la Cruz', 1988, 1992),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        material: 'Cuproníquel',
        minYear: 1988,
        maxYear: 1988,
        motifs: [
          NumismaticMotifRule('Cincuentenario de la Expropiación Petrolera', 1988),
        ],
      ),
    ],
  ),

  // 1.21 México - Nuevos Pesos (N$ grabados físicamente 1992–1995)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1992,
    maxYear: 1995,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero inoxidable',
        minYear: 1992,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Rayos Solares del Anillo de los Quincunces (Piedra del Sol)',
            1992,
            1995,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero inoxidable',
        minYear: 1992,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo del Sacrificio (Piedra del Sol)',
            1992,
            1995,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce de aluminio',
        minYear: 1992,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Ácatl - Decimotercer Día (Piedra del Sol)',
            1992,
            1995,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce de aluminio',
        minYear: 1992,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de la Aceptación (Piedra del Sol)',
            1992,
            1995,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 1992,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo del Resplandor (Piedra del Sol)',
            1992,
            1995,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 1992,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de los Días (Piedra del Sol)',
            1992,
            1995,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bimetálica',
        minYear: 1992,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de las Serpientes (Piedra del Sol)',
            1992,
            1995,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Bimetálica',
        allowedMaterials: ['Bimetálica', 'Plata'],
        minYear: 1992,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule('Nuevo Peso - Piedra del Sol (Centro de Plata Sterling .925)', 1992, 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Bimetálica',
        allowedMaterials: ['Bimetálica', 'Plata'],
        minYear: 1993,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule('Nuevo Peso - Don Miguel Hidalgo y Costilla (Centro de Plata Sterling .925)', 1993, 1995),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Bimetálica',
        allowedMaterials: ['Bimetálica', 'Plata'],
        minYear: 1993,
        maxYear: 1995,
        motifs: [
          NumismaticMotifRule('Nuevo Peso - Niños Héroes (Centro de Plata Sterling .925)', 1993, 1995),
        ],
      ),
    ],
  ),

  // 1.22 México - Familia C Primer Período (1996–2007)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 1996,
    maxYear: 2007,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero inoxidable',
        minYear: 1996,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule(
            'Rayos Solares del Anillo de los Quincunces (Piedra del Sol)',
            1996,
            2007,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero inoxidable',
        minYear: 1996,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            1996,
            2007,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce de aluminio',
        minYear: 1996,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            1996,
            2007,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce de aluminio',
        minYear: 1996,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            1996,
            2007,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 1996,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            1996,
            2007,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 1996,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule('Anillo de los Días (Piedra del Sol)', 1996, 2007),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bimetálica',
        minYear: 1996,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule('Anillo de las Serpientes (Piedra del Sol)', 1996, 2007),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Bimetálica',
        minYear: 1997,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule('Piedra del Sol', 1997, 2007),
          NumismaticMotifRule('Cambio de Milenio - Glifo Año 2000', 2000),
          NumismaticMotifRule('Cambio de Milenio - Glifo Año 2001', 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Bimetálica',
        minYear: 2000,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule('Octavio Paz - Cambio de Milenio', 2000, 2001),
          NumismaticMotifRule('Fuego Nuevo - Señorío de Xiuhtecuhtli', 2000, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Bimetálica',
        allowedMaterials: ['Bimetálica', 'Plata'],
        minYear: 2003,
        maxYear: 2007,
        motifs: [
          NumismaticMotifRule('32 Estados de la República - Fase 1 (Heráldicos)', 2003, 2005),
          NumismaticMotifRule('32 Estados de la República - Fase 2 (Emblemáticos)', 2005, 2007),
          NumismaticMotifRule('180 Aniversario de la Unión Federal', 2004),
          NumismaticMotifRule('470 Aniversario de la Casa de Moneda de México', 2005),
          NumismaticMotifRule('80 Aniversario del Banco de México', 2005),
          NumismaticMotifRule('400 Aniversario de la Primera Edición de Don Quijote de la Mancha', 2005),
          NumismaticMotifRule('Bicentenario del Natalicio de Benito Juárez', 2006),
        ],
      ),
    ],
  ),

  // 1.23 México - Familia C Bicentenario y Centenario (2008–2010)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2008,
    maxYear: 2010,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero inoxidable',
        minYear: 2008,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('Rayos Solares del Anillo de los Quincunces (Piedra del Sol)', 2008, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero inoxidable',
        minYear: 2008,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('Anillo del Sacrificio (Piedra del Sol)', 2008, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Bronce de aluminio',
        minYear: 2008,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('Ácatl - Decimotercer Día (Piedra del Sol)', 2008, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Bronce de aluminio',
        minYear: 2008,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('Anillo de la Aceptación (Piedra del Sol)', 2008, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 2008,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('Anillo del Resplandor (Piedra del Sol)', 2008, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 2008,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('Anillo de los Días (Piedra del Sol)', 2008, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bimetálica',
        minYear: 2008,
        maxYear: 2010,
        motifs: [
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
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Bimetálica',
        minYear: 2008,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('Piedra del Sol', 2008, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Bimetálica',
        minYear: 2010,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('Octavio Paz - Premio Nobel de Literatura', 2010, 2011),
        ],
      ),
    ],
  ),

  // 1.24 México - Familia C Fraccionarias Acero Inoxidable (2011–2019)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2011,
    maxYear: 2019,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero inoxidable',
        minYear: 2011,
        maxYear: 2019,
        motifs: [
          NumismaticMotifRule('Anillo del Sacrificio (Piedra del Sol)', 2011, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Acero inoxidable',
        minYear: 2011,
        maxYear: 2019,
        motifs: [
          NumismaticMotifRule('Ácatl - Decimotercer Día (Piedra del Sol)', 2011, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Acero inoxidable',
        minYear: 2011,
        maxYear: 2019,
        motifs: [
          NumismaticMotifRule('Anillo de la Aceptación (Piedra del Sol)', 2011, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 2011,
        maxYear: 2019,
        motifs: [
          NumismaticMotifRule('Anillo del Resplandor (Piedra del Sol)', 2011, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 2011,
        maxYear: 2019,
        motifs: [
          NumismaticMotifRule('Anillo de los Días (Piedra del Sol)', 2011, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bimetálica',
        minYear: 2011,
        maxYear: 2019,
        motifs: [
          NumismaticMotifRule('Anillo de las Serpientes (Piedra del Sol)', 2011, 2019),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Bimetálica',
        minYear: 2011,
        maxYear: 2019,
        motifs: [
          NumismaticMotifRule('Piedra del Sol', 2011, 2019),
          NumismaticMotifRule('150 Aniversario de la Batalla de Puebla - General Ignacio Zaragoza', 2012),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Bimetálica',
        minYear: 2013,
        maxYear: 2019,
        motifs: [
          NumismaticMotifRule('Centenario del Ejército Mexicano', 2013),
          NumismaticMotifRule('150 Aniversario del Natalicio y 100 Aniversario Luctuoso de Belisario Domínguez', 2013),
          NumismaticMotifRule('Centenario de la Gesta Heroica de Veracruz', 2014),
          NumismaticMotifRule('Centenario de la Toma de Zacatecas', 2014),
          NumismaticMotifRule('Centenario de la Fuerza Aérea Mexicana', 2015),
          NumismaticMotifRule('Bicentenario Luctuoso del Generalísimo José María Morelos y Pavón', 2015),
          NumismaticMotifRule('Cincuenta Aniversario de la Aplicación del Plan DN-III-E', 2016),
          NumismaticMotifRule('Centenario de la Promulgación de la Constitución Política de 1917', 2017),
          NumismaticMotifRule('50 Aniversario de la Aplicación del Plan Marina', 2018),
          NumismaticMotifRule('500 Años de la Fundación de la Ciudad y Puerto de Veracruz', 2019),
          NumismaticMotifRule('Centenario de la Muerte del General Emiliano Zapata Salazar', 2019),
        ],
      ),
    ],
  ),

  // 1.25 México - Familia C1 Dodecagonal (2020–presente)
  NumismaticEmissionRuleData(
    country: 'México',
    minYear: 2020,
    maxYear: 2100,
    validCurrencies: ['MXN'],
    defaultCurrency: 'MXN',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Acero inoxidable',
        minYear: 2020,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Anillo del Sacrificio (Piedra del Sol)', 2020, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Acero inoxidable',
        minYear: 2020,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Ácatl - Decimotercer Día (Piedra del Sol)', 2020, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Acero inoxidable',
        minYear: 2020,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Anillo de la Aceptación (Piedra del Sol)', 2020, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 2020,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Anillo del Resplandor (Piedra del Sol)', 2020, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 2020,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Anillo de los Días (Piedra del Sol)', 2020, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bimetálica',
        minYear: 2020,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Anillo de las Serpientes (Piedra del Sol)', 2020, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Bimetálica',
        minYear: 2020,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Piedra del Sol', 2020, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Bimetálica',
        minYear: 2020,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('500 Años de la Fundación de la Ciudad y Puerto de Veracruz (Dodecagonal 2020)', 2020),
          NumismaticMotifRule('Centenario de la Muerte del General Emiliano Zapata Salazar (Dodecagonal 2020)', 2020),
          NumismaticMotifRule('700 Años de la Fundación Lunar de la Ciudad de México-Tenochtitlan', 2021),
          NumismaticMotifRule('500 Años de Memoria Histórica de México-Tenochtitlan', 2021),
          NumismaticMotifRule('Bicentenario de la Independencia Nacional', 2021),
          NumismaticMotifRule('Bicentenario de la Marina-Armada de México (2021-2022)', 2021, 2022),
          NumismaticMotifRule('Cien Años de la Llegada de los Menonitas a México', 2022),
          NumismaticMotifRule('Bicentenario del Heroico Colegio Militar', 2023),
          NumismaticMotifRule('Doscientos Años de Relaciones Diplomáticas México-Estados Unidos', 2023),
          NumismaticMotifRule('500 Años de la Fundación de la Villa de Colima', 2023),
          NumismaticMotifRule('Bicentenario de la Instauración del Senado de la República', 2024),
          NumismaticMotifRule('Cien Años del Heroico Batallón de Infantería de Marina', 2024),
        ],
      ),
    ],
  ),
];
