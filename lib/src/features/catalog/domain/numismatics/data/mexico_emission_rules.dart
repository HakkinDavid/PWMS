import 'numismatic_currencies_registry.dart';
import 'numismatic_denominations_registry.dart';
import 'numismatic_materials_registry.dart';
import '../models/numismatic_models.dart';

/// Historical emission rules for Mexico and colonial predecessors (Virreinato, Primer y Segundo Imperio, República, Monedas y Billetes modernos).
const List<NumismaticEmissionRuleData> mexicoEmissionRules = [
  // 1.1 Virreinato de Nueva España (1536–1821)
  NumismaticEmissionRuleData(
    country: 'Virreinato de Nueva España',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_16,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Carlos y Juana - Monograma K-I / Columnas de Hércules (Tlaco Colonial)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Carlos y Juana - K-I Coronadas / Castillo y León (Ochavo Colonial)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Virreinal de Plata (Castillo y León)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
          NumismaticMotifRule(
            'Tlaco / Cuartilla de Cobre',
            minYear: 1794,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Virreinal (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Columnario / Busto',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Virreinal (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            '4 Reales (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            '4 Escudos de Oro Virreinal',
            minYear: 1732,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Real de a Ocho / 8 Reales (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            '8 Escudos de Oro (Onza Virreinal)',
            minYear: 1732,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_5,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            'Escudo de Oro Virreinal',
            minYear: 1772,
            maxYear: 1820,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.2 Primer Imperio Mexicano - Agustín de Iturbide (1822–1823)
  NumismaticEmissionRuleData(
    country: 'Imperio Mexicano (Primer y Segundo Imperio)',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            '4 Reales Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            '4 Escudos de Oro Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            '8 Reales Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            '8 Escudos de Oro Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.3 Segundo Imperio Mexicano - Maximiliano (1864–1867)
  NumismaticEmissionRuleData(
    country: 'Imperio Mexicano (Primer y Segundo Imperio)',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Corona Imperial (Maximiliano)',
            minYear: 1864,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            'Escudo Imperial (Maximiliano) / Corona de Laurel y Encino',
            minYear: 1864,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            'Escudo Imperial (Maximiliano) / Corona de Laurel y Encino',
            minYear: 1864,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.4 México - Período Virreinal novohispano (1536–1821)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Monograma Coronado de Fernando VII / León Rampante (Octavo de Real)',
            minYear: 1814,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Virreinal de Plata (Castillo y León)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
          NumismaticMotifRule(
            'Tlaco / Cuartilla de Cobre',
            minYear: 1794,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Virreinal (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Columnario / Busto',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Virreinal (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            '4 Reales (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            '4 Escudos de Oro Virreinal',
            minYear: 1732,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Real de a Ocho / 8 Reales (Columnario / Busto)',
            minYear: 1536,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            '8 Escudos de Oro (Onza Virreinal)',
            minYear: 1732,
            maxYear: 1821,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.5 México - Primer Imperio (1822–1823)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            '4 Reales Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            '4 Escudos de Oro Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            '8 Reales Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxe,
        motifs: [
          NumismaticMotifRule(
            '8 Escudos de Oro Agustín de Iturbide',
            minYear: 1822,
            maxYear: 1823,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.6 México - República Mexicana Sistema de Reales y Escudos (1823–1897)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_16,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Águila Republicana (Cobre)',
            minYear: 1829,
            maxYear: 1863,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Águila Republicana',
            minYear: 1829,
            maxYear: 1863,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Gorro Frigio / Águila Republicana',
            minYear: 1824,
            maxYear: 1863,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1_2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Resplandor',
            minYear: 1824,
            maxYear: 1863,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Resplandor',
            minYear: 1824,
            maxYear: 1863,
            material: NumismaticMaterialsRegistry.nameSilver800,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Resplandor',
            minYear: 1824,
            maxYear: 1863,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d4,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Columnario / Busto / Escudos',
            minYear: 1824,
            maxYear: 1863,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxr,
        motifs: [
          NumismaticMotifRule(
            'Resplandor (Cap and Rays) / Escudos Oro',
            minYear: 1823,
            maxYear: 1897,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.7 México - Segundo Imperio Serie Maximiliano Decimal (1864–1867)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Corona Imperial (Maximiliano)',
            minYear: 1864,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Escudo Imperial (Maximiliano) / Corona de Laurel y Encino',
            minYear: 1864,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Escudo Imperial (Maximiliano) / Corona de Laurel y Encino',
            minYear: 1864,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            maxYear: 1867,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Busto Emperador Maximiliano',
            minYear: 1866,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.8 México - República Restaurada Sistema Balanza Decimal (1868–1881)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1879,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1869,
            maxYear: 1873,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2_5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Dos y Medio Pesos Oro Balanza',
            minYear: 1870,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Balanza',
            minYear: 1870,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Balanza',
            minYear: 1870,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Balanza',
            minYear: 1870,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Resplandor (Acuñación concurrente)',
            minYear: 1868,
            maxYear: 1881,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
    ],
  ),

  // 1.9 México - Crisis del Níquel (1882–1883)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral Romano "I" / Escudo Republicano',
            minYear: 1882,
            maxYear: 1883,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral Romano "II" / Escudo Republicano',
            minYear: 1882,
            maxYear: 1883,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral Romano "V" / Escudo Republicano',
            minYear: 1882,
            maxYear: 1883,
            material: NumismaticMaterialsRegistry.nameNickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1882,
            maxYear: 1883,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1882,
            maxYear: 1883,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza',
            minYear: 1882,
            maxYear: 1883,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Resplandor',
            minYear: 1882,
            maxYear: 1883,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
    ],
  ),

  // 1.10 México - Porfiriato Decimal Resplandor (1884–1904)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral "1" y Corona de Laurel (Águila Porfiriana)',
            minYear: 1884,
            maxYear: 1898,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral "2" y Corona de Laurel (Águila Porfiriana)',
            minYear: 1884,
            maxYear: 1898,
            material: NumismaticMaterialsRegistry.nameCopper,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata Balanza / Corona',
            minYear: 1884,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata Balanza / Corona',
            minYear: 1884,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Corona Porfiriana',
            minYear: 1898,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata Gorro Frigio y Balanza',
            minYear: 1884,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Fuerte Resplandor',
            minYear: 1898,
            maxYear: 1904,
            material: NumismaticMaterialsRegistry.nameSilver800,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d8,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Resplandor (Últimas emisiones)',
            minYear: 1884,
            maxYear: 1897,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
    ],
  ),

  // 1.11 México - Reforma Monetaria Porfiriana de 1905 (1905–1914)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Porfiriano Corona de Laurel',
            minYear: 1905,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral "2" con Rama de Laurel (Águila Porfiriana)',
            minYear: 1905,
            maxYear: 1906,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral Romano "V" Radiante (Porfiriano)',
            minYear: 1905,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Corona',
            minYear: 1905,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameSilver800,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Corona',
            minYear: 1905,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameSilver800,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata Resplandor',
            minYear: 1905,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Fuerte Resplandor',
            minYear: 1905,
            maxYear: 1909,
            material: NumismaticMaterialsRegistry.nameSilver800,
          ),
          NumismaticMotifRule(
            'Caballito - Centenario de la Independencia (1910-1914)',
            minYear: 1910,
            maxYear: 1914,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1905,
            maxYear: 1910,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1905,
            maxYear: 1910,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.12 México - Período Revolucionario / Constitucionalista (1915–1919)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral "1" y Guirnalda de Laurel (Águila Constitucionalista)',
            minYear: 1915,
            maxYear: 1919,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral "2" y Guirnalda de Laurel (Águila Constitucionalista)',
            minYear: 1915,
            maxYear: 1916,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Bronce Constitucionalista',
            minYear: 1915,
            maxYear: 1919,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gorro Frigio Radiante (Emisión Reducida Ley .800)',
            minYear: 1919,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gorro Frigio Radiante (Emisión Reducida Ley .800)',
            minYear: 1919,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Resplandor Reducido',
            minYear: 1918,
            maxYear: 1919,
            material: NumismaticMaterialsRegistry.nameSilver800,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .800 Resplandor Reducido',
            minYear: 1918,
            maxYear: 1919,
            material: NumismaticMaterialsRegistry.nameSilver800,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1919,
            maxYear: 1920,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2_5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Dos y Medio Pesos Oro Hidalgo',
            minYear: 1918,
            maxYear: 1920,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1919,
            maxYear: 1920,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Hidalgo',
            minYear: 1916,
            maxYear: 1920,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Calendario Azteca',
            minYear: 1917,
            maxYear: 1921,
            material: NumismaticMaterialsRegistry.nameGoldColonial875,
          ),
        ],
      ),
    ],
  ),

  // 1.13 México - Ley .720 y Centenario de Oro (1920–1942)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Bronce Espigas',
            minYear: 1920,
            maxYear: 1942,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_02,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Numeral "2" y Corona de Laurel',
            minYear: 1920,
            maxYear: 1941,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Níquel Josefa Chica',
            minYear: 1920,
            maxYear: 1935,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Bronce Josefa Ortiz de Perfil',
            minYear: 1936,
            maxYear: 1942,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Gorro Frigio Radiante (Ley .720)',
            minYear: 1925,
            maxYear: 1935,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
          NumismaticMotifRule(
            'Numeral "10" con Corona de Laurel',
            minYear: 1936,
            maxYear: 1940,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .720 Gorro Frigio',
            minYear: 1920,
            maxYear: 1935,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .720 Resplandor',
            minYear: 1920,
            maxYear: 1942,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .720 Resplandor',
            minYear: 1920,
            maxYear: 1942,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Victoria Alada - Centenario de la Consumación de la Independencia',
            minYear: 1921,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro - Centenario de la Independencia (37.5g Oro Puro)',
            minYear: 1921,
            maxYear: 1931,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
    ],
  ),

  // 1.14 México - Segunda Guerra y Postguerra (1943–1949)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Espigas de Trigo',
            minYear: 1943,
            maxYear: 1949,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Josefa Ortiz Grande',
            minYear: 1943,
            maxYear: 1949,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Pirámide del Sol de Teotihuacán',
            minYear: 1943,
            maxYear: 1949,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .720 Resplandor',
            minYear: 1943,
            maxYear: 1945,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
          NumismaticMotifRule(
            'Plata .420 Cuauhtémoc',
            minYear: 1947,
            maxYear: 1948,
            material: NumismaticMaterialsRegistry.nameSilver420,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .500 Morelos Cachetón',
            minYear: 1947,
            maxYear: 1949,
            material: NumismaticMaterialsRegistry.nameSilver500,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cuauhtémoc (1947-1948)',
            minYear: 1947,
            maxYear: 1948,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Oro Centenario',
            minYear: 1943,
            maxYear: 1947,
            material: NumismaticMaterialsRegistry.nameGold900,
          ),
        ],
      ),
    ],
  ),

  // 1.15 México - Década de 1950 (1950–1956)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Espigas de Trigo',
            minYear: 1950,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa',
            minYear: 1950,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Latón Benito Juárez',
            minYear: 1955,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Bronce Pirámide de Teotihuacán',
            minYear: 1950,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_25,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Balanza Cuproníquel',
            minYear: 1950,
            maxYear: 1953,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .300 Morelos',
            minYear: 1950,
            maxYear: 1951,
            material: NumismaticMaterialsRegistry.nameSilver300,
          ),
          NumismaticMotifRule(
            'Bronce Cuauhtémoc',
            minYear: 1955,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .300 Morelos',
            minYear: 1950,
            material: NumismaticMaterialsRegistry.nameSilver300,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Inauguración del Ferrocarril del Sureste',
            minYear: 1950,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
          NumismaticMotifRule(
            'Hidalgo - Laurel (1951-1954)',
            minYear: 1951,
            maxYear: 1954,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
          NumismaticMotifRule(
            'Año de Hidalgo - Bicentenario del Natalicio de Miguel Hidalgo',
            minYear: 1953,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
          NumismaticMotifRule(
            'Hidalgo Chico (1955-1957)',
            minYear: 1955,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Hidalgo Plata .900 (1955-1956)',
            minYear: 1955,
            maxYear: 1956,
            material: NumismaticMaterialsRegistry.nameSilver900,
          ),
        ],
      ),
    ],
  ),

  // 1.16 México - Período de los Tepalcates y Conmemorativas (1957–1969)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_01,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Espigas de Trigo',
            minYear: 1957,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa',
            minYear: 1957,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Latón Benito Juárez',
            minYear: 1957,
            maxYear: 1967,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Bronce Pirámide de Teotihuacán',
            minYear: 1957,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel Cuauhtémoc',
            minYear: 1964,
            maxYear: 1969,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Plata .100 Morelos Tepalcate',
            minYear: 1957,
            maxYear: 1967,
            material: NumismaticMaterialsRegistry.nameSilver100,
          ),
          NumismaticMotifRule(
            'Centenario de la Constitución de 1857',
            minYear: 1957,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Centenario de la Constitución de 1857',
            minYear: 1957,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
          NumismaticMotifRule(
            'Hidalgo Chico',
            minYear: 1957,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Centenario de la Constitución de 1857',
            minYear: 1957,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
          NumismaticMotifRule(
            '150 Aniversario de la Independencia y 50 de la Revolución',
            minYear: 1960,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d25,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Juegos Olímpicos México 68 - Tipo 1 (Aros rectos / alineados)',
            minYear: 1968,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos México 68 - Tipo 2 (Aros caídos / desiguales)',
            minYear: 1968,
            material: NumismaticMaterialsRegistry.nameSilverColonial903,
          ),
        ],
      ),
    ],
  ),

  // 1.17 México - Transición Pirámide de Bronce y Monedas de Cuproníquel (1970–1973)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa Chica',
            minYear: 1970,
            maxYear: 1973,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Bronce Pirámide',
            minYear: 1970,
            maxYear: 1971,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel Cuauhtémoc',
            minYear: 1970,
            maxYear: 1973,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel José María Morelos',
            minYear: 1970,
            maxYear: 1973,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cuproníquel Vicente Guerrero',
            minYear: 1971,
            maxYear: 1973,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 1.18 México - Serie Numismática Cuproníquel, Latón y Plata (1974–1983)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa',
            minYear: 1974,
            maxYear: 1976,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Mazorca de Maíz',
            minYear: 1974,
            maxYear: 1980,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Francisco I. Madero',
            minYear: 1974,
            maxYear: 1977,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Cabeza Olmeca',
            minYear: 1977,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cuauhtémoc',
            minYear: 1974,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'José María Morelos',
            minYear: 1974,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Vicente Guerrero / Quetzalcóatl',
            minYear: 1974,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Heptagonal Miguel Hidalgo',
            minYear: 1974,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cultura Maya - Jugador de Pelota',
            minYear: 1980,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Coyolxauhqui - Templo Mayor',
            minYear: 1982,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'José María Morelos (Plata .720)',
            minYear: 1977,
            maxYear: 1983,
            material: NumismaticMaterialsRegistry.nameSilver720,
          ),
        ],
      ),
    ],
  ),

  // 1.19 México - Acero Inoxidable, Latón y Valores Medios (1984–1987)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Morelos Acero',
            minYear: 1984,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Latón Josefa Ortiz',
            minYear: 1985,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Miguel Hidalgo',
            minYear: 1985,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Bronce Guadalupe Victoria',
            minYear: 1985,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez',
            minYear: 1984,
            maxYear: 1988,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Venustiano Carranza',
            minYear: 1984,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d200,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            '175 Aniversario de la Independencia',
            minYear: 1985,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            '75 Aniversario de la Revolución',
            minYear: 1985,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Copa Mundial de la FIFA México 1986',
            minYear: 1986,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Francisco I. Madero',
            minYear: 1986,
            maxYear: 1987,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 1.20 México - Grandes Valores de Inflación Pre-N$ (1988–1992)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Miguel Hidalgo',
            minYear: 1988,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Guadalupe Victoria',
            minYear: 1988,
            maxYear: 1990,
            material: NumismaticMaterialsRegistry.nameBrass,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Benito Juárez',
            minYear: 1988,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Venustiano Carranza',
            minYear: 1988,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d500,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Francisco I. Madero',
            minYear: 1988,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Sor Juana Inés de la Cruz',
            minYear: 1988,
            maxYear: 1992,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5000,
        currency: NumismaticCurrenciesRegistry.mxp,
        motifs: [
          NumismaticMotifRule(
            'Cincuentenario de la Expropiación Petrolera',
            minYear: 1988,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
        ],
      ),
    ],
  ),

  // 1.21 México - Nuevos Pesos (N$ grabados físicamente 1992–1995)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Rayos Solares del Anillo de los Quincunces (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo del Sacrificio (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de la Aceptación (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo del Resplandor (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de los Días (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Anillo de las Serpientes (Piedra del Sol)',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Piedra del Sol (Centro de Plata Sterling .925)',
            minYear: 1992,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Don Miguel Hidalgo y Costilla (Centro de Plata Sterling .925)',
            minYear: 1993,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Nuevo Peso - Niños Héroes (Centro de Plata Sterling .925)',
            minYear: 1993,
            maxYear: 1995,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
        ],
      ),
    ],
  ),

  // 1.22 México - Familia C Primer Período (1996–2007)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Rayos Solares del Anillo de los Quincunces (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de los Días (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de las Serpientes (Piedra del Sol)',
            minYear: 1996,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 1997,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Cambio de Milenio - Glifo Año 2000',
            minYear: 2000,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Cambio de Milenio - Glifo Año 2001',
            minYear: 2001,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Octavio Paz - Cambio de Milenio',
            minYear: 2000,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Fuego Nuevo - Señorío de Xiuhtecuhtli',
            minYear: 2000,
            maxYear: 2001,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d100,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            '32 Estados de la República - Fase 1 (Heráldicos)',
            minYear: 2003,
            maxYear: 2005,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
          NumismaticMotifRule(
            '32 Estados de la República - Fase 2 (Emblemáticos)',
            minYear: 2005,
            maxYear: 2007,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
          NumismaticMotifRule(
            '180 Aniversario de la Unión Federal',
            minYear: 2004,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
          NumismaticMotifRule(
            '470 Aniversario de la Casa de Moneda de México',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
          NumismaticMotifRule(
            '80 Aniversario del Banco de México',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
          NumismaticMotifRule(
            '400 Aniversario de la Primera Edición de Don Quijote de la Mancha',
            minYear: 2005,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
          NumismaticMotifRule(
            'Bicentenario del Natalicio de Benito Juárez',
            minYear: 2006,
            material: NumismaticMaterialsRegistry.nameBimetallicSilver925BronzeAl,
          ),
        ],
      ),
    ],
  ),

  // 1.23 México - Familia C Bicentenario y Centenario (2008–2010)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_05,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Rayos Solares del Anillo de los Quincunces (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameAluminumBronze,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de los Días (Piedra del Sol)',
            minYear: 2008,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Ignacio López Rayón',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Francisco Xavier Mina',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Mariano Matamoros',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Carlos María de Bustamante',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Hermenegildo Galeana',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Francisco Primo de Verdad y Ramos (Con puntos)',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Francisco Primo de Verdad y Ramos (Sin puntos - Variedad especial)',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Álvaro Obregón',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'José Vasconcelos',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Francisco Villa',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Heriberto Jara',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Ricardo Flores Magón',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Francisco J. Múgica',
            minYear: 2008,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'José María Cos',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Pedro Moreno',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Agustín de Iturbide',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Servando Teresa de Mier',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Nicolás Bravo',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Leona Vicario',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Filomeno Mata',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Carmen Serdán',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Andrés Molina Enríquez',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Luis Cabrera',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Eulalio Gutiérrez',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Otilio Montaño',
            minYear: 2009,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Miguel Hidalgo y Costilla',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'José María Morelos y Pavón',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Vicente Guerrero',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameCupronickel,
          ),
          NumismaticMotifRule(
            'Ignacio Allende',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Guadalupe Victoria',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Josefa Ortiz de Domínguez',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Belisario Domínguez',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Francisco I. Madero',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Emiliano Zapata',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'Venustiano Carranza',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'La Soldadera (Adelita)',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
          NumismaticMotifRule(
            'José María Pino Suárez',
            minYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 2008,
            maxYear: 2010,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Octavio Paz - Premio Nobel de Literatura',
            minYear: 2010,
            maxYear: 2011,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
        ],
      ),
    ],
  ),

  // 1.24 México - Familia C Fraccionarias Acero Inoxidable (2011–2019)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de los Días (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de las Serpientes (Piedra del Sol)',
            minYear: 2011,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 2011,
            maxYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            '150 Aniversario de la Batalla de Puebla - General Ignacio Zaragoza',
            minYear: 2012,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Centenario del Ejército Mexicano',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            '150 Aniversario del Natalicio y 100 Aniversario Luctuoso de Belisario Domínguez',
            minYear: 2013,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Centenario de la Gesta Heroica de Veracruz',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Centenario de la Toma de Zacatecas',
            minYear: 2014,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Centenario de la Fuerza Aérea Mexicana',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Bicentenario Luctuoso del Generalísimo José María Morelos y Pavón',
            minYear: 2015,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Cincuenta Aniversario de la Aplicación del Plan DN-III-E',
            minYear: 2016,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Centenario de la Promulgación de la Constitución Política de 1917',
            minYear: 2017,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            '50 Aniversario de la Aplicación del Plan Marina',
            minYear: 2018,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            '500 Años de la Fundación de la Ciudad y Puerto de Veracruz',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Centenario de la Muerte del General Emiliano Zapata Salazar',
            minYear: 2019,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
        ],
      ),
    ],
  ),

  // 1.25 México - Familia C1 Dodecagonal (2020–presente)
  NumismaticEmissionRuleData(
    country: 'México',
    pieces: [
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Sacrificio (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Ácatl - Decimotercer Día (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d0_50,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de la Aceptación (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d1,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo del Resplandor (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d2,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de los Días (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d5,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Anillo de las Serpientes (Piedra del Sol)',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicBronzeAlStainlessSteel,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d10,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            'Piedra del Sol',
            minYear: 2020,
            maxYear: 2100,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: NumismaticDenominationsRegistry.d20,
        currency: NumismaticCurrenciesRegistry.mxn,
        motifs: [
          NumismaticMotifRule(
            '500 Años de la Fundación de la Ciudad y Puerto de Veracruz (Dodecagonal 2020)',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Centenario de la Muerte del General Emiliano Zapata Salazar (Dodecagonal 2020)',
            minYear: 2020,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            '700 Años de la Fundación Lunar de la Ciudad de México-Tenochtitlan',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            '500 Años de Memoria Histórica de México-Tenochtitlan',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Independencia Nacional',
            minYear: 2021,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Marina-Armada de México (2021-2022)',
            minYear: 2021,
            maxYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Cien Años de la Llegada de los Menonitas a México',
            minYear: 2022,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Bicentenario del Heroico Colegio Militar',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Doscientos Años de Relaciones Diplomáticas México-Estados Unidos',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            '500 Años de la Fundación de la Villa de Colima',
            minYear: 2023,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Bicentenario de la Instauración del Senado de la República',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
          NumismaticMotifRule(
            'Cien Años del Heroico Batallón de Infantería de Marina',
            minYear: 2024,
            material: NumismaticMaterialsRegistry.nameBimetallicAlpacaBronzeAl,
          ),
        ],
      ),
    ],
  ),
];
