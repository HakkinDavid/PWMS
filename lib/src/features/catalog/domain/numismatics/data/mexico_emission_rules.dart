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
        motifs: [
          NumismaticMotifRule(
            'Carlos y Juana - Monograma K-I / Columnas de Hércules (Tlaco Colonial)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/8',
        motifs: [
          NumismaticMotifRule(
            'Carlos y Juana - K-I Coronadas / Castillo y León (Ochavo Colonial)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        motifs: [
          NumismaticMotifRule(
            'Virreinal de Plata (Castillo y León)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'Tlaco / Cuartilla de Cobre',
            minYear: 1794,
            maxYear: 1821,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        motifs: [
          NumismaticMotifRule(
            'Virreinal (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Columnario / Busto',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Virreinal (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        motifs: [
          NumismaticMotifRule(
            '4 Reales (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
            currencyCode: 'MXR',
          ),
          NumismaticMotifRule(
            '4 Escudos de Oro Virreinal',
            minYear: 1732,
            maxYear: 1821,
            material: 'Oro',
            currencyCode: 'MXE',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        motifs: [
          NumismaticMotifRule(
            'Real de a Ocho / 8 Reales (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
            currencyCode: 'MXR',
          ),
          NumismaticMotifRule(
            '8 Escudos de Oro (Onza Virreinal)',
            minYear: 1732,
            maxYear: 1821,
            material: 'Oro',
            currencyCode: 'MXE',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.5',
        motifs: [
          NumismaticMotifRule(
            'Escudo de Oro Virreinal',
            minYear: 1772,
            maxYear: 1820,
            material: 'Oro',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        motifs: [
          NumismaticMotifRule(
            '4 Reales Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
            currencyCode: 'MXR',
          ),
          NumismaticMotifRule(
            '4 Escudos de Oro Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Oro',
            currencyCode: 'MXE',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        motifs: [
          NumismaticMotifRule(
            '8 Reales Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
            currencyCode: 'MXR',
          ),
          NumismaticMotifRule(
            '8 Escudos de Oro Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Oro',
            currencyCode: 'MXE',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Corona Imperial (Maximiliano)',
            minYear: 1864,
            maxYear: 1867,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Escudo Imperial (Maximiliano) / Corona de Laurel y Encino',
            minYear: 1864,
            maxYear: 1867,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Escudo Imperial (Maximiliano) / Corona de Laurel y Encino',
            minYear: 1864,
            maxYear: 1867,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            maxYear: 1867,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            maxYear: 1867,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            material: 'Oro',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Monograma Coronado de Fernando VII / León Rampante (Octavo de Real)',
            minYear: 1814,
            maxYear: 1821,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        motifs: [
          NumismaticMotifRule(
            'Virreinal de Plata (Castillo y León)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'Tlaco / Cuartilla de Cobre',
            minYear: 1794,
            maxYear: 1821,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        motifs: [
          NumismaticMotifRule(
            'Virreinal (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Columnario / Busto',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Virreinal (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        motifs: [
          NumismaticMotifRule(
            '4 Reales (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
            currencyCode: 'MXR',
          ),
          NumismaticMotifRule(
            '4 Escudos de Oro Virreinal',
            minYear: 1732,
            maxYear: 1821,
            material: 'Oro',
            currencyCode: 'MXE',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        motifs: [
          NumismaticMotifRule(
            'Real de a Ocho / 8 Reales (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: 'Plata',
            currencyCode: 'MXR',
          ),
          NumismaticMotifRule(
            '8 Escudos de Oro (Onza Virreinal)',
            minYear: 1732,
            maxYear: 1821,
            material: 'Oro',
            currencyCode: 'MXE',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        motifs: [
          NumismaticMotifRule(
            '4 Reales Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
            currencyCode: 'MXR',
          ),
          NumismaticMotifRule(
            '4 Escudos de Oro Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Oro',
            currencyCode: 'MXE',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        motifs: [
          NumismaticMotifRule(
            '8 Reales Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Plata',
            currencyCode: 'MXR',
          ),
          NumismaticMotifRule(
            '8 Escudos de Oro Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: 'Oro',
            currencyCode: 'MXE',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Águila Republicana (Cobre)',
            minYear: 1829,
            maxYear: 1863,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/8',
        motifs: [
          NumismaticMotifRule(
            'Águila Republicana',
            minYear: 1829,
            maxYear: 1863,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        motifs: [
          NumismaticMotifRule(
            'Gorro Frigio / Águila Republicana',
            minYear: 1824,
            maxYear: 1863,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        motifs: [
          NumismaticMotifRule(
            'Resplandor',
            minYear: 1824,
            maxYear: 1863,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Resplandor',
            minYear: 1824,
            maxYear: 1863,
            material: 'Plata .800',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Resplandor',
            minYear: 1824,
            maxYear: 1863,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        motifs: [
          NumismaticMotifRule(
            'Columnario / Busto / Escudos',
            minYear: 1824,
            maxYear: 1863,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        motifs: [
          NumismaticMotifRule(
            'Resplandor (Cap and Rays) / Escudos Oro',
            minYear: 1823,
            maxYear: 1897,
            material: 'Oro',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Corona Imperial (Maximiliano)',
            minYear: 1864,
            maxYear: 1867,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Escudo Imperial (Maximiliano) / Corona de Laurel y Encino',
            minYear: 1864,
            maxYear: 1867,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Escudo Imperial (Maximiliano) / Corona de Laurel y Encino',
            minYear: 1864,
            maxYear: 1867,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            maxYear: 1867,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            maxYear: 1867,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            material: 'Oro',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1879,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1873,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        motifs: [
          NumismaticMotifRule(
            'Dos y Medio Pesos Oro Balanza',
            minYear: 1870,
            maxYear: 1881,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Oro Balanza',
            minYear: 1870,
            maxYear: 1881,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Oro Balanza',
            minYear: 1870,
            maxYear: 1881,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Oro Balanza',
            minYear: 1870,
            maxYear: 1881,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        motifs: [
          NumismaticMotifRule(
            'Resplandor (Acuñación concurrente)',
            minYear: 1868,
            maxYear: 1881,
            material: 'Plata',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Numeral Romano "I" / Escudo Republicano',
            minYear: 1882,
            maxYear: 1883,
            material: 'Níquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        motifs: [
          NumismaticMotifRule(
            'Numeral Romano "II" / Escudo Republicano',
            minYear: 1882,
            maxYear: 1883,
            material: 'Níquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Numeral Romano "V" / Escudo Republicano',
            minYear: 1882,
            maxYear: 1883,
            material: 'Níquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1882,
            maxYear: 1883,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1882,
            maxYear: 1883,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1882,
            maxYear: 1883,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        motifs: [
          NumismaticMotifRule(
            'Resplandor',
            minYear: 1882,
            maxYear: 1883,
            material: 'Plata',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Numeral "1" y Corona de Laurel (Águila Porfiriana)',
            minYear: 1884,
            maxYear: 1898,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        motifs: [
          NumismaticMotifRule(
            'Numeral "2" y Corona de Laurel (Águila Porfiriana)',
            minYear: 1884,
            maxYear: 1898,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Plata Balanza / Corona',
            minYear: 1884,
            maxYear: 1904,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Plata Balanza / Corona',
            minYear: 1884,
            maxYear: 1904,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Corona Porfiriana',
            minYear: 1898,
            maxYear: 1904,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Plata Gorro Frigio y Balanza',
            minYear: 1884,
            maxYear: 1904,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Fuerte Resplandor',
            minYear: 1898,
            maxYear: 1904,
            material: 'Plata .800',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        motifs: [
          NumismaticMotifRule(
            'Resplandor (Últimas emisiones)',
            minYear: 1884,
            maxYear: 1897,
            material: 'Plata',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Porfiriano Corona de Laurel',
            minYear: 1905,
            maxYear: 1914,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        motifs: [
          NumismaticMotifRule(
            'Numeral "2" con Rama de Laurel (Águila Porfiriana)',
            minYear: 1905,
            maxYear: 1906,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Numeral Romano "V" Radiante (Porfiriano)',
            minYear: 1905,
            maxYear: 1914,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Corona',
            minYear: 1905,
            maxYear: 1914,
            material: 'Plata .800',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Corona',
            minYear: 1905,
            maxYear: 1914,
            material: 'Plata .800',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Plata Resplandor',
            minYear: 1905,
            maxYear: 1914,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Fuerte Resplandor',
            minYear: 1905,
            maxYear: 1909,
            material: 'Plata .800',
          ),
          NumismaticMotifRule(
            'Caballito - Centenario de la Independencia (1910-1914)',
            minYear: 1910,
            maxYear: 1914,
            material: 'Plata .900',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1905,
            maxYear: 1910,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1905,
            maxYear: 1910,
            material: 'Oro',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Numeral "1" y Guirnalda de Laurel (Águila Constitucionalista)',
            minYear: 1915,
            maxYear: 1919,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        motifs: [
          NumismaticMotifRule(
            'Numeral "2" y Guirnalda de Laurel (Águila Constitucionalista)',
            minYear: 1915,
            maxYear: 1916,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Bronce Constitucionalista',
            minYear: 1915,
            maxYear: 1919,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Gorro Frigio Radiante (Emisión Reducida Ley .800)',
            minYear: 1919,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Gorro Frigio Radiante (Emisión Reducida Ley .800)',
            minYear: 1919,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Resplandor Reducido',
            minYear: 1918,
            maxYear: 1919,
            material: 'Plata .800',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Resplandor Reducido',
            minYear: 1918,
            maxYear: 1919,
            material: 'Plata .800',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1919,
            maxYear: 1920,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        motifs: [
          NumismaticMotifRule(
            'Dos y Medio Pesos Oro Hidalgo',
            minYear: 1918,
            maxYear: 1920,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1919,
            maxYear: 1920,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1916,
            maxYear: 1920,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Oro Calendario Azteca',
            minYear: 1917,
            maxYear: 1921,
            material: 'Oro',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Bronce Espigas',
            minYear: 1920,
            maxYear: 1942,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        motifs: [
          NumismaticMotifRule(
            'Numeral "2" y Corona de Laurel',
            minYear: 1920,
            maxYear: 1941,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Níquel Josefa Chica',
            minYear: 1920,
            maxYear: 1935,
            material: 'Cuproníquel',
          ),
          NumismaticMotifRule(
            'Bronce Josefa Ortiz de Perfil',
            minYear: 1936,
            maxYear: 1942,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Gorro Frigio Radiante (Ley .720)',
            minYear: 1925,
            maxYear: 1935,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'Numeral "10" con Corona de Laurel',
            minYear: 1936,
            maxYear: 1940,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Plata .720 Gorro Frigio',
            minYear: 1920,
            maxYear: 1935,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Plata .720 Resplandor',
            minYear: 1920,
            maxYear: 1942,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Plata .720 Resplandor',
            minYear: 1920,
            maxYear: 1942,
            material: 'Plata .720',
          ),
        ],
      ),
      // 2 Pesos 1921 Victoria Alada - PLATA .903
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Victoria Alada - Centenario de la Consumación de la Independencia',
            minYear: 1921,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        motifs: [
          NumismaticMotifRule(
            'Oro - Centenario de la Independencia (37.5g Oro Puro)',
            minYear: 1921,
            maxYear: 1931,
            material: 'Oro',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Espigas de Trigo',
            minYear: 1943,
            maxYear: 1949,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Josefa Ortiz Grande',
            minYear: 1943,
            maxYear: 1949,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Pirámide del Sol de Teotihuacán',
            minYear: 1943,
            maxYear: 1949,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Plata .720 Resplandor',
            minYear: 1943,
            maxYear: 1945,
            material: 'Plata .720',
          ),
          NumismaticMotifRule(
            'Plata .420 Cuauhtémoc',
            minYear: 1947,
            maxYear: 1948,
            material: 'Plata .420',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Plata .500 Morelos Cachetón',
            minYear: 1947,
            maxYear: 1949,
            material: 'Plata .500',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Cuauhtémoc (1947-1948)',
            minYear: 1947,
            maxYear: 1948,
            material: 'Plata .900',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        motifs: [
          NumismaticMotifRule(
            'Oro Centenario',
            minYear: 1943,
            maxYear: 1947,
            material: 'Oro',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Espigas de Trigo',
            minYear: 1950,
            maxYear: 1956,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa',
            minYear: 1950,
            maxYear: 1956,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Latón Benito Juárez',
            minYear: 1955,
            maxYear: 1956,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Bronce Pirámide de Teotihuacán',
            minYear: 1950,
            maxYear: 1956,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        motifs: [
          NumismaticMotifRule(
            'Balanza Cuproníquel',
            minYear: 1950,
            maxYear: 1953,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Plata .300 Morelos',
            minYear: 1950,
            maxYear: 1951,
            material: 'Plata .300',
          ),
          NumismaticMotifRule(
            'Bronce Cuauhtémoc',
            minYear: 1955,
            maxYear: 1956,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Plata .300 Morelos',
            minYear: 1950,
            material: 'Plata .300',
          ),
        ],
      ),
      // 5 Pesos 1950-1956 Plata (Ferrocarril, Hidalgo Laurel, Bicentenario Hidalgo, Hidalgo Chico)
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Inauguración del Ferrocarril del Sureste',
            minYear: 1950,
            material: 'Plata .720',
          ),
          NumismaticMotifRule(
            'Hidalgo - Laurel (1951-1954)',
            minYear: 1951,
            maxYear: 1954,
            material: 'Plata .720',
          ),
          NumismaticMotifRule(
            'Año de Hidalgo - Bicentenario del Natalicio de Miguel Hidalgo',
            minYear: 1953,
            material: 'Plata .720',
          ),
          NumismaticMotifRule(
            'Hidalgo Chico (1955-1957)',
            minYear: 1955,
            maxYear: 1956,
            material: 'Plata .720',
          ),
        ],
      ),
      // 10 Pesos 1955-1956 Hidalgo
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Hidalgo Plata .900 (1955-1956)',
            minYear: 1955,
            maxYear: 1956,
            material: 'Plata .900',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Espigas de Trigo',
            minYear: 1957,
            maxYear: 1969,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa',
            minYear: 1957,
            maxYear: 1969,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Latón Benito Juárez',
            minYear: 1957,
            maxYear: 1967,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Bronce Pirámide de Teotihuacán',
            minYear: 1957,
            maxYear: 1969,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel Cuauhtémoc',
            minYear: 1964,
            maxYear: 1969,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Plata .100 Morelos Tepalcate',
            minYear: 1957,
            maxYear: 1967,
            material: 'Plata .100',
          ),
          NumismaticMotifRule(
            'Centenario de la Constitución de 1857',
            minYear: 1957,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Centenario de la Constitución de 1857',
            minYear: 1957,
            material: 'Plata .720',
          ),
          NumismaticMotifRule(
            'Hidalgo Chico',
            minYear: 1957,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Centenario de la Constitución de 1857',
            minYear: 1957,
            material: 'Plata .720',
          ),
          NumismaticMotifRule(
            '150 Aniversario de la Independencia y 50 de la Revolución',
            minYear: 1960,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        motifs: [
          NumismaticMotifRule(
            'Juegos Olímpicos México 68 - Tipo 1 (Aros rectos / alineados)',
            minYear: 1968,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos México 68 - Tipo 2 (Aros caídos / desiguales)',
            minYear: 1968,
            material: 'Plata',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa Chica',
            minYear: 1970,
            maxYear: 1973,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Bronce Pirámide',
            minYear: 1970,
            maxYear: 1971,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel Cuauhtémoc',
            minYear: 1970,
            maxYear: 1973,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel José María Morelos',
            minYear: 1970,
            maxYear: 1973,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel Vicente Guerrero',
            minYear: 1971,
            maxYear: 1973,
            material: 'Cuproníquel',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa',
            minYear: 1974,
            maxYear: 1976,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Mazorca de Maíz',
            minYear: 1974,
            maxYear: 1980,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Francisco I. Madero / Cabeza Olmeca',
            minYear: 1974,
            maxYear: 1983,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Cuauhtémoc',
            minYear: 1974,
            maxYear: 1983,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'José María Morelos',
            minYear: 1974,
            maxYear: 1983,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Vicente Guerrero / Quetzalcóatl',
            minYear: 1974,
            maxYear: 1983,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Heptagonal Miguel Hidalgo',
            minYear: 1974,
            maxYear: 1983,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Cultura Maya - Jugador de Pelota',
            minYear: 1980,
            maxYear: 1983,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        motifs: [
          NumismaticMotifRule(
            'Coyolxauhqui - Templo Mayor',
            minYear: 1982,
            maxYear: 1983,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        motifs: [
          NumismaticMotifRule(
            'José María Morelos (Plata .720)',
            minYear: 1977,
            maxYear: 1983,
            material: 'Plata .720',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Morelos Acero',
            minYear: 1984,
            maxYear: 1987,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa Ortiz',
            minYear: 1985,
            maxYear: 1987,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Miguel Hidalgo',
            minYear: 1985,
            maxYear: 1987,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Bronce Guadalupe Victoria',
            minYear: 1985,
            maxYear: 1987,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez',
            minYear: 1984,
            maxYear: 1987,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        motifs: [
          NumismaticMotifRule(
            'Venustiano Carranza',
            minYear: 1984,
            maxYear: 1987,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        motifs: [
          NumismaticMotifRule(
            '175 Aniversario de la Independencia',
            minYear: 1985,
            material: 'Cuproníquel',
          ),
          NumismaticMotifRule(
            '75 Aniversario de la Revolución',
            minYear: 1985,
            material: 'Cuproníquel',
          ),
          NumismaticMotifRule(
            'Copa Mundial de la FIFA México 1986',
            minYear: 1986,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        motifs: [
          NumismaticMotifRule(
            'Francisco I. Madero',
            minYear: 1986,
            maxYear: 1987,
            material: 'Cuproníquel',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Miguel Hidalgo',
            minYear: 1988,
            maxYear: 1990,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Guadalupe Victoria',
            minYear: 1988,
            maxYear: 1990,
            material: 'Latón',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez',
            minYear: 1988,
            maxYear: 1992,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        motifs: [
          NumismaticMotifRule(
            'Venustiano Carranza',
            minYear: 1988,
            maxYear: 1992,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        motifs: [
          NumismaticMotifRule(
            'Francisco I. Madero',
            minYear: 1988,
            maxYear: 1992,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1000',
        motifs: [
          NumismaticMotifRule(
            'Sor Juana Inés de la Cruz',
            minYear: 1988,
            maxYear: 1992,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5000',
        motifs: [
          NumismaticMotifRule(
            'Cincuentenario de la Expropiación Petrolera',
            minYear: 1988,
            material: 'Cuproníquel',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Rayos Solares del Anillo de los Quincunces (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo del Sacrificio (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de la Aceptación (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo del Resplandor (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de los Días (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de las Serpientes (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Piedra del Sol (Centro de Plata Sterling .925)',
            minYear: 1992,
            maxYear: 1995,
            material: 'Plata .925',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Don Miguel Hidalgo y Costilla (Centro de Plata Sterling .925)',
            minYear: 1993,
            maxYear: 1995,
            material: 'Plata .925',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Niños Héroes (Centro de Plata Sterling .925)',
            minYear: 1993,
            maxYear: 1995,
            material: 'Bimetálica',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Rayos Solares del Anillo de los Quincunces (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Anillo de los Días (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Anillo de las Serpientes (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 1997,
            maxYear: 2007,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Cambio de Milenio - Glifo Año 2000',
            minYear: 2000,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Cambio de Milenio - Glifo Año 2001',
            minYear: 2001,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Octavio Paz - Cambio de Milenio',
            minYear: 2000,
            maxYear: 2001,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Fuego Nuevo - Señorío de Xiuhtecuhtli',
            minYear: 2000,
            maxYear: 2001,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        motifs: [
          NumismaticMotifRule(
            '32 Estados de la República - Fase 1 (Heráldicos)',
            minYear: 2003,
            maxYear: 2005,
            material: 'Bimetálica (Núcleo Plata)',
          ),
          NumismaticMotifRule(
            '32 Estados de la República - Fase 2 (Emblemáticos)',
            minYear: 2005,
            maxYear: 2007,
            material: 'Bimetálica (Núcleo Plata)',
          ),
          NumismaticMotifRule(
            '180 Aniversario de la Unión Federal',
            minYear: 2004,
            material: 'Bimetálica (Núcleo Plata)',
          ),
          NumismaticMotifRule(
            '470 Aniversario de la Casa de Moneda de México',
            minYear: 2005,
            material: 'Bimetálica (Núcleo Plata)',
          ),
          NumismaticMotifRule(
            '80 Aniversario del Banco de México',
            minYear: 2005,
            material: 'Bimetálica (Núcleo Plata)',
          ),
          NumismaticMotifRule(
            '400 Aniversario de la Primera Edición de Don Quijote de la Mancha',
            minYear: 2005,
            material: 'Bimetálica (Núcleo Plata)',
          ),
          NumismaticMotifRule(
            'Bicentenario del Natalicio de Benito Juárez',
            minYear: 2006,
            material: 'Bimetálica (Núcleo Plata)',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Rayos Solares del Anillo de los Quincunces (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Anillo de los Días (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Ignacio López Rayón',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Francisco Xavier Mina',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Mariano Matamoros',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Carlos María de Bustamante',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Hermenegildo Galeana',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Francisco Primo de Verdad y Ramos (Con puntos)',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Francisco Primo de Verdad y Ramos (Sin puntos - Variedad especial)',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Álvaro Obregón',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'José Vasconcelos',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Francisco Villa',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Heriberto Jara',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Ricardo Flores Magón',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Francisco J. Múgica',
            minYear: 2008,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'José María Cos',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Pedro Moreno',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Servando Teresa de Mier',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Nicolás Bravo',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Leona Vicario',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Filomeno Mata',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Carmen Serdán',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Andrés Molina Enríquez',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Luis Cabrera',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Eulalio Gutiérrez',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Otilio Montaño',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Miguel Hidalgo y Costilla',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'José María Morelos y Pavón',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Vicente Guerrero',
            minYear: 2010,
            material: 'Cuproníquel',
          ),
          NumismaticMotifRule(
            'Ignacio Allende',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Guadalupe Victoria',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Josefa Ortiz de Domínguez',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Belisario Domínguez',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Francisco I. Madero',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Emiliano Zapata',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Venustiano Carranza',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'La Soldadera (Adelita)',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'José María Pino Suárez',
            minYear: 2010,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 2008,
            maxYear: 2010,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Octavio Paz - Premio Nobel de Literatura',
            minYear: 2010,
            maxYear: 2011,
            material: 'Bimetálica',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Anillo de los Días (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Anillo de las Serpientes (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 2011,
            maxYear: 2019,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '150 Aniversario de la Batalla de Puebla - General Ignacio Zaragoza',
            minYear: 2012,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            'Centenario del Ejército Mexicano',
            minYear: 2013,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '150 Aniversario del Natalicio y 100 Aniversario Luctuoso de Belisario Domínguez',
            minYear: 2013,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Centenario de la Gesta Heroica de Veracruz',
            minYear: 2014,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Centenario de la Toma de Zacatecas',
            minYear: 2014,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Centenario de la Fuerza Aérea Mexicana',
            minYear: 2015,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Bicentenario Luctuoso del Generalísimo José María Morelos y Pavón',
            minYear: 2015,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Cincuenta Aniversario de la Aplicación del Plan DN-III-E',
            minYear: 2016,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Centenario de la Promulgación de la Constitución Política de 1917',
            minYear: 2017,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '50 Aniversario de la Aplicación del Plan Marina',
            minYear: 2018,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '500 Años de la Fundación de la Ciudad y Puerto de Veracruz',
            minYear: 2019,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Centenario de la Muerte del General Emiliano Zapata Salazar',
            minYear: 2019,
            material: 'Bimetálica',
          ),
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
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: 'Acero inoxidable',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: 'Plata .720',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        motifs: [
          NumismaticMotifRule(
            'Anillo de los Días (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        motifs: [
          NumismaticMotifRule(
            'Anillo de las Serpientes (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 2020,
            maxYear: 2100,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        motifs: [
          NumismaticMotifRule(
            '500 Años de la Fundación de la Ciudad y Puerto de Veracruz (Dodecagonal 2020)',
            minYear: 2020,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Centenario de la Muerte del General Emiliano Zapata Salazar (Dodecagonal 2020)',
            minYear: 2020,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '700 Años de la Fundación Lunar de la Ciudad de México-Tenochtitlan',
            minYear: 2021,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '500 Años de Memoria Histórica de México-Tenochtitlan',
            minYear: 2021,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Bicentenario de la Independencia Nacional',
            minYear: 2021,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Bicentenario de la Marina-Armada de México (2021-2022)',
            minYear: 2021,
            maxYear: 2022,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Cien Años de la Llegada de los Menonitas a México',
            minYear: 2022,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Bicentenario del Heroico Colegio Militar',
            minYear: 2023,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Doscientos Años de Relaciones Diplomáticas México-Estados Unidos',
            minYear: 2023,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '500 Años de la Fundación de la Villa de Colima',
            minYear: 2023,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Bicentenario de la Instauración del Senado de la República',
            minYear: 2024,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Cien Años del Heroico Batallón de Infantería de Marina',
            minYear: 2024,
            material: 'Bimetálica',
          ),
        ],
      ),
    ],
  ),
];
