import '../models/numismatic_material_definition.dart';

/// Centralized registry and single source of truth for numismatic materials, alloys, and physical configurations.
abstract final class NumismaticMaterialsRegistry {
  // ---------------------------------------------------------------------------
  // Canonical Material Display Names (String Constants for compile-time const usage)
  // ---------------------------------------------------------------------------
  static const nameSilverFine999 = 'Plata Fina .999';
  static const nameSilverBritannia958 = 'Plata Britannia .958';
  static const nameSilverSterling925 = 'Plata .925';
  static const nameSilverColonial903 = 'Plata .903';
  static const nameSilver900 = 'Plata .900';
  static const nameSilver835 = 'Plata .835';
  static const nameSilver800 = 'Plata .800';
  static const nameSilver720 = 'Plata .720';
  static const nameSilver500 = 'Plata .500';
  static const nameSilver420 = 'Plata .420';
  static const nameSilverWar350 = 'Plata .350';
  static const nameSilver300 = 'Plata .300';
  static const nameSilver100 = 'Plata .100';
  static const nameSilverGeneric = 'Plata';
  static const nameGoldFine9999 = 'Oro Puro .9999';
  static const nameGoldFine999 = 'Oro Fino .999';
  static const nameGoldCrown9167 = 'Oro Crown .9167';
  static const nameGold900 = 'Oro .900';
  static const nameGoldColonial875 = 'Oro .875';
  static const nameGoldGeneric = 'Oro';
  static const namePlatinum = 'Platino';
  static const namePalladium = 'Paladio';
  static const nameRhodium = 'Rodio';
  static const nameRuthenium = 'Rutenio';
  static const nameElectrum = 'Electro (Electrum)';
  static const nameBimetallicBronzeAlStainlessSteel = 'Bimetálica (Centro Bronce de Aluminio, Anillo Acero Inoxidable)';
  static const nameBimetallicAlpacaBronzeAl = 'Bimetálica (Centro Alpaca, Anillo Bronce de Aluminio)';
  static const nameBimetallicSilver925BronzeAl = 'Bimetálica (Centro Plata .925, Anillo Bronce de Aluminio)';
  static const nameBimetallicEuro1 = 'Bimetálica (Centro Cuproníquel, Anillo Níquel-Latón)';
  static const nameBimetallicEuro2 = 'Bimetálica (Centro Níquel-Latón, Anillo Cuproníquel)';
  static const nameBimetallicToonie = 'Bimetálica (Centro Bronce de Aluminio, Anillo Níquel/Acero)';
  static const nameBimetallicUkPound = 'Bimetálica (Centro Alpaca niquelada, Anillo Níquel-Latón)';
  static const nameBimetallicUk2Pound = 'Bimetálica (Centro Cuproníquel, Anillo Níquel-Latón)';
  static const nameBimetallicGeneric = 'Bimetálica';
  static const nameCladCuNiCopper = 'Cuproníquel sobre núcleo de cobre';
  static const nameCladSilver400 = 'Plata .400 revestida (Clad)';
  static const nameCladManganeseBrassCopper = 'Latón de manganeso sobre núcleo de cobre';
  static const nameCopperPlatedZinc = 'Zinc bañado en cobre';
  static const nameCopperPlatedSteel = 'Acero bañado en cobre';
  static const nameNickelPlatedSteel = 'Acero bañado en níquel';
  static const nameBrassPlatedSteel = 'Acero bañado en latón';
  static const nameBronzePlatedSteel = 'Acero bañado en bronce';
  static const nameZincPlatedSteel = 'Acero bañado en zinc';
  static const nameSilverPlatedCopper = 'Cobre bañado en plata';
  static const nameNickelPlatedCopper = 'Cobre bañado en níquel';
  static const nameCopper = 'Cobre';
  static const nameCupronickel = 'Cuproníquel';
  static const nameBronze = 'Bronce';
  static const nameAluminumBronze = 'Bronce de aluminio';
  static const namePhosphorBronze = 'Bronce fosforoso';
  static const nameBrass = 'Latón';
  static const nameNickelBrass = 'Níquel-Latón';
  static const nameTombac = 'Latón dorado (Tombac)';
  static const nameNickel = 'Níquel';
  static const nameAlpaca = 'Alpaca (Plata alemana)';
  static const nameNordicGold = 'Oro nórdico';
  static const nameBillon = 'Billón (Vellón)';
  static const nameZinc = 'Zinc';
  static const nameZamak = 'Zamak';
  static const nameLead = 'Plomo';
  static const nameTin = 'Estaño';
  static const namePewter = 'Peltre';
  static const nameIron = 'Hierro';
  static const nameSteel = 'Acero';
  static const nameStainlessSteel = 'Acero inoxidable';
  static const nameAluminum = 'Aluminio';
  static const nameMagnalium = 'Aluminio-Magnesio (Magnalio)';
  static const nameTitanium = 'Titanio';
  static const nameNiobium = 'Niobio';
  static const nameTantalum = 'Tántalo';
  static const nameTrimetallicGeneric = 'Trimetálica';
  static const nameCottonPaper = 'Papel de algodón';
  static const namePolymer = 'Polímero';
  static const namePaper = 'Papel';
  static const nameCardboard = 'Cartón';
  static const namePorcelain = 'Porcelana';
  static const nameCeramic = 'Cerámica';
  static const namePressedFiber = 'Fibra prensada';
  static const nameGlass = 'Vidrio';
  static const nameLeather = 'Cuero';
  static const nameWood = 'Madera';
  static const nameOther = 'Otro';

  // ---------------------------------------------------------------------------
  // 1. Precious Metals - Silver (Plata)
  // ---------------------------------------------------------------------------
  static const silverFine999 = NumismaticMaterialDefinition(
    key: 'silver_fine_999',
    displayName: nameSilverFine999,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.999,
    alloyComposition: '99.9% Ag',
    aliases: ['plata pura', 'fine silver', '.999 silver', 'plata .999', 'plata 999', 'plata fina'],
  );

  static const silverBritannia958 = NumismaticMaterialDefinition(
    key: 'silver_britannia_958',
    displayName: nameSilverBritannia958,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.958,
    alloyComposition: '95.8% Ag, 4.2% Cu',
    aliases: ['britannia silver', '.958 silver', 'plata .958', 'plata 958'],
  );

  static const silverSterling925 = NumismaticMaterialDefinition(
    key: 'silver_sterling_925',
    displayName: nameSilverSterling925,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.925,
    alloyComposition: '92.5% Ag, 7.5% Cu',
    aliases: ['plata sterling', 'sterling silver', '.925', 'plata esterlina', 'plata 925', 'plata .925 ley'],
  );

  static const silverColonial903 = NumismaticMaterialDefinition(
    key: 'silver_colonial_903',
    displayName: nameSilverColonial903,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.903,
    alloyComposition: '90.3% Ag, 9.7% Cu (Ley 0.9027 / .903)',
    aliases: ['plata virreinal', 'plata republicana', 'plata virreinal .903', '.903', 'plata 903', 'ley 0.9027', 'ley .903', 'plata colonial', 'plata de 8 reales'],
  );

  static const silver900 = NumismaticMaterialDefinition(
    key: 'silver_900',
    displayName: nameSilver900,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.900,
    alloyComposition: '90.0% Ag, 10.0% Cu',
    aliases: ['coin silver', '.900', 'plata 900', '90% silver', 'plata .900 ley'],
  );

  static const silver835 = NumismaticMaterialDefinition(
    key: 'silver_835',
    displayName: nameSilver835,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.835,
    alloyComposition: '83.5% Ag, 16.5% Cu',
    aliases: ['.835', 'plata 835', '83.5% silver', 'plata .835 ley'],
  );

  static const silver800 = NumismaticMaterialDefinition(
    key: 'silver_800',
    displayName: nameSilver800,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.800,
    alloyComposition: '80.0% Ag, 20.0% Cu',
    aliases: ['.800', 'plata 800', 'plata .800 ley', 'peso resplandor 1918'],
  );

  static const silver720 = NumismaticMaterialDefinition(
    key: 'silver_720',
    displayName: nameSilver720,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.720,
    alloyComposition: '72.0% Ag, 28.0% Cu',
    aliases: ['.720', 'plata 720', '0.720', 'plata .720 ley', 'resplandor .720', 'morelos .720', 'carranza .720', 'olimpica 68'],
  );

  static const silver500 = NumismaticMaterialDefinition(
    key: 'silver_500',
    displayName: nameSilver500,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.500,
    alloyComposition: '50.0% Ag, 40.0% Cu, 6.0% Ni, 4.0% Zn',
    aliases: ['.500', 'plata 500', 'plata .500 ley', 'morelos 1947'],
  );

  static const silver420 = NumismaticMaterialDefinition(
    key: 'silver_420',
    displayName: nameSilver420,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.420,
    alloyComposition: '42.0% Ag, 58.0% Cu/Ni',
    aliases: ['.420', 'plata 420', 'plata .420 ley'],
  );

  static const silverWar350 = NumismaticMaterialDefinition(
    key: 'silver_war_350',
    displayName: nameSilverWar350,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.350,
    alloyComposition: '35% Ag, 56% Cu, 9% Mn',
    aliases: ['war nickel', 'plata war nickel', '.350', 'plata .350', 'jefferson war nickel'],
  );

  static const silver300 = NumismaticMaterialDefinition(
    key: 'silver_300',
    displayName: nameSilver300,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.300,
    alloyComposition: '30.0% Ag, 50.0% Cu, 10.0% Ni, 10.0% Zn',
    aliases: ['.300', 'plata 300', 'plata .300 ley', 'tepalcate', 'peso tepalcate 1950'],
  );

  static const silver100 = NumismaticMaterialDefinition(
    key: 'silver_100',
    displayName: nameSilver100,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.100,
    alloyComposition: '10.0% Ag, 70.0% Cu, 10.0% Ni, 10.0% Zn',
    aliases: ['.100', 'plata 100', 'plata .100 ley', 'morelos 1957', 'peso morelos 1957'],
  );

  static const silverGeneric = NumismaticMaterialDefinition(
    key: 'silver',
    displayName: nameSilverGeneric,
    shortName: 'Plata',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['silver', 'argentum', 'ag'],
  );

  // ---------------------------------------------------------------------------
  // 2. Precious Metals - Gold (Oro)
  // ---------------------------------------------------------------------------
  static const goldFine9999 = NumismaticMaterialDefinition(
    key: 'gold_fine_9999',
    displayName: nameGoldFine9999,
    shortName: 'Oro',
    family: NumismaticMaterialFamily.gold,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.9999,
    alloyComposition: '99.99% Au (24 Kilates)',
    aliases: ['24k', 'oro 24k', '.9999 gold', 'fine gold .9999', 'oro .9999', 'gold buffalo', 'maple leaf gold'],
  );

  static const goldFine999 = NumismaticMaterialDefinition(
    key: 'gold_fine_999',
    displayName: nameGoldFine999,
    shortName: 'Oro',
    family: NumismaticMaterialFamily.gold,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.999,
    alloyComposition: '99.9% Au',
    aliases: ['oro fino', '.999 gold', 'oro libertad', 'oro .999', 'oro 999'],
  );

  static const goldCrown9167 = NumismaticMaterialDefinition(
    key: 'gold_crown_9167',
    displayName: nameGoldCrown9167,
    shortName: 'Oro',
    family: NumismaticMaterialFamily.gold,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.9167,
    alloyComposition: '91.67% Au, 8.33% Cu/Ag (22 Kilates)',
    aliases: ['22k', 'oro 22k', 'crown gold', '.9167 gold', 'oro .9167', 'gold eagle', 'american gold eagle', 'sovereign', 'soberano oro'],
  );

  static const gold900 = NumismaticMaterialDefinition(
    key: 'gold_900',
    displayName: nameGold900,
    shortName: 'Oro',
    family: NumismaticMaterialFamily.gold,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.900,
    alloyComposition: '90.0% Au, 10.0% Cu (21.6 Kilates)',
    aliases: ['oro centenario', 'centenario', 'oro azteca', 'azteca', 'oro hidalgo', 'hidalgo', 'coin gold', '.900 gold', 'oro .900', '21.6k', 'oro 900', 'centenario 50 pesos', 'azteca 20 pesos', 'hidalgo oro', 'double eagle'],
  );

  static const goldColonial875 = NumismaticMaterialDefinition(
    key: 'gold_colonial_875',
    displayName: nameGoldColonial875,
    shortName: 'Oro',
    family: NumismaticMaterialFamily.gold,
    structure: NumismaticMaterialStructure.monometallic,
    fineness: 0.875,
    alloyComposition: '87.5% Au, 12.5% Cu/Ag (21 Kilates)',
    aliases: ['oro virreinal', 'oro virreinal .875', 'oro republicano', 'oro escudos', '21k', 'oro 21k', '.875 gold', 'oro .875', '8 escudos', 'onza de oro virreinal'],
  );

  static const goldGeneric = NumismaticMaterialDefinition(
    key: 'gold',
    displayName: nameGoldGeneric,
    shortName: 'Oro',
    family: NumismaticMaterialFamily.gold,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['gold', 'aurum', 'au'],
  );

  // ---------------------------------------------------------------------------
  // 3. Precious Metals - Platinum Group & Historic Alloys
  // ---------------------------------------------------------------------------
  static const platinum = NumismaticMaterialDefinition(
    key: 'platinum',
    displayName: namePlatinum,
    shortName: 'Platino',
    family: NumismaticMaterialFamily.platinum,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['platinum', 'pt'],
  );

  static const palladium = NumismaticMaterialDefinition(
    key: 'palladium',
    displayName: namePalladium,
    shortName: 'Paladio',
    family: NumismaticMaterialFamily.palladium,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['palladium', 'pd'],
  );

  static const rhodium = NumismaticMaterialDefinition(
    key: 'rhodium',
    displayName: nameRhodium,
    shortName: 'Rodio',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['rhodium', 'rh'],
  );

  static const ruthenium = NumismaticMaterialDefinition(
    key: 'ruthenium',
    displayName: nameRuthenium,
    shortName: 'Rutenio',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['ruthenium', 'ru'],
  );

  static const electrum = NumismaticMaterialDefinition(
    key: 'electrum',
    displayName: nameElectrum,
    shortName: 'Electro',
    family: NumismaticMaterialFamily.gold,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['electro', 'electrum', 'oro verde'],
  );

  // ---------------------------------------------------------------------------
  // 4. Bimetallic Compositions (Configuraciones precisas núcleo / anillo)
  // ---------------------------------------------------------------------------
  static const bimetallicBronzeAlStainlessSteel = NumismaticMaterialDefinition(
    key: 'bimetallic_bronze_al_stainless_steel',
    displayName: nameBimetallicBronzeAlStainlessSteel,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    coreMaterial: 'Bronce de aluminio',
    ringMaterial: 'Acero inoxidable',
    alloyComposition: 'Centro: 92% Cu, 6% Al, 2% Ni | Anillo: 16-18% Cr (AISI 430)',
    aliases: [
      'bimetálica (al-br/acero)',
      'bimetalica al-br acero',
      'bimetalica 1 peso',
      'bimetalica 2 pesos',
      'bimetalica 5 pesos',
      'bimetálica centro bronce anillo acero',
      'bimetálica al-br/acero',
      'bimetálica 1, 2, 5 pesos',
      'bimetalica centro bronce de aluminio, anillo acero inoxidable',
    ],
  );

  static const bimetallicAlpacaBronzeAl = NumismaticMaterialDefinition(
    key: 'bimetallic_alpaca_bronze_al',
    displayName: nameBimetallicAlpacaBronzeAl,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    coreMaterial: 'Alpaca (Plata alemana)',
    ringMaterial: 'Bronce de aluminio',
    alloyComposition: 'Centro: 65% Cu, 10% Ni, 25% Zn | Anillo: 92% Cu, 6% Al, 2% Ni',
    aliases: [
      'bimetálica (alpaca/al-br)',
      'bimetalica alpaca bronce de aluminio',
      'bimetalica 10 pesos',
      'bimetalica 20 pesos',
      'bimetálica centro alpaca anillo bronce',
      'bimetálica alpaca/al-br',
      'bimetálica 10 y 20 pesos',
      'bimetalica centro alpaca, anillo bronce de aluminio',
    ],
  );

  static const bimetallicSilver925BronzeAl = NumismaticMaterialDefinition(
    key: 'bimetallic_silver_925_bronze_al',
    displayName: nameBimetallicSilver925BronzeAl,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    fineness: 0.925,
    coreMaterial: 'Plata .925',
    ringMaterial: 'Bronce de aluminio',
    alloyComposition: 'Centro: Plata Sterling .925 (92.5% Ag, 7.5% Cu) | Anillo: 92% Cu, 6% Al, 2% Ni',
    aliases: [
      'bimetálica (núcleo plata)',
      'bimetálica núcleo plata',
      'bimetalica nucleo plata',
      'bimetalica nuevos pesos',
      'bimetálica (centro plata .925, anillo bronce de aluminio)',
      'bimetálica (plata/al-br)',
      'bimetálica n\$10',
      'bimetálica n\$20',
      'bimetálica n\$50',
    ],
  );

  static const bimetallicEuro1 = NumismaticMaterialDefinition(
    key: 'bimetallic_euro_1',
    displayName: nameBimetallicEuro1,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    coreMaterial: 'Cuproníquel',
    ringMaterial: 'Níquel-Latón',
    alloyComposition: 'Centro: 75% Cu, 25% Ni | Anillo: 75% Cu, 20% Zn, 5% Ni',
    aliases: [
      'bimetálica 1 euro',
      'bimetalica 1 euro',
      '1 euro',
      'bimetálica (cuni/latón)',
      'bimetálica cuproníquel níquel-latón',
      '1 euro bimetálica',
    ],
  );

  static const bimetallicEuro2 = NumismaticMaterialDefinition(
    key: 'bimetallic_euro_2',
    displayName: nameBimetallicEuro2,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    coreMaterial: 'Níquel-Latón',
    ringMaterial: 'Cuproníquel',
    alloyComposition: 'Centro: 75% Cu, 20% Zn, 5% Ni multicapa | Anillo: 75% Cu, 25% Ni',
    aliases: [
      'bimetálica 2 euro',
      'bimetalica 2 euro',
      '2 euro',
      'bimetálica (latón/cuni)',
      'bimetálica níquel-latón cuproníquel',
      '2 euro bimetálica',
    ],
  );

  static const bimetallicToonie = NumismaticMaterialDefinition(
    key: 'bimetallic_toonie',
    displayName: nameBimetallicToonie,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    coreMaterial: 'Bronce de aluminio',
    ringMaterial: 'Acero bañado en níquel',
    aliases: ['toonie', 'bimetálica toonie', 'bimetálica canada 2 dollars', 'canada toonie'],
  );

  static const bimetallicUkPound = NumismaticMaterialDefinition(
    key: 'bimetallic_uk_pound',
    displayName: nameBimetallicUkPound,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    coreMaterial: 'Alpaca (Plata alemana)',
    ringMaterial: 'Níquel-Latón',
    aliases: ['1 pound bimetallic', 'bimetálica 1 libra', 'uk 1 pound bimetallic'],
  );

  static const bimetallicUk2Pound = NumismaticMaterialDefinition(
    key: 'bimetallic_uk_2_pound',
    displayName: nameBimetallicEuro1,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    coreMaterial: 'Cuproníquel',
    ringMaterial: 'Níquel-Latón',
    aliases: ['2 pounds bimetallic', 'bimetálica 2 libras', 'uk 2 pounds bimetallic'],
  );

  static const bimetallicGeneric = NumismaticMaterialDefinition(
    key: 'bimetallic',
    displayName: nameBimetallicGeneric,
    shortName: 'Bimetálica',
    family: NumismaticMaterialFamily.bimetallic,
    structure: NumismaticMaterialStructure.bimetallic,
    aliases: ['bimetalica', 'bimetal', 'bimetallic'],
  );

  // ---------------------------------------------------------------------------
  // 5. Clad & Revestidas (Sándwich metalúrgico sobre núcleo base)
  // ---------------------------------------------------------------------------
  static const cladCuNiCopper = NumismaticMaterialDefinition(
    key: 'clad_cuni_copper',
    displayName: nameCladCuNiCopper,
    shortName: 'Cuproníquel (Clad)',
    family: NumismaticMaterialFamily.cupronickel,
    structure: NumismaticMaterialStructure.clad,
    coreMaterial: 'Cobre',
    platingMaterial: 'Cuproníquel',
    alloyComposition: 'Capas exteriores 75% Cu / 25% Ni, núcleo 100% Cu',
    aliases: [
      'cupronickel clad copper',
      'cuni clad',
      'clad cuni',
      'cuproníquel clad',
      'cuproniquel sobre nucleo de cobre',
      'clad copper',
      'washington quarter clad',
      'roosevelt dime clad',
      'kennedy half clad',
    ],
  );

  static const cladSilver400 = NumismaticMaterialDefinition(
    key: 'clad_silver_400',
    displayName: nameCladSilver400,
    shortName: 'Plata .400 (Clad)',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.clad,
    fineness: 0.400,
    coreMaterial: 'Plata .210 (21% Ag, 79% Cu)',
    platingMaterial: 'Plata .800 (80% Ag, 20% Cu)',
    alloyComposition: 'Capas exteriores 80% Ag / 20% Cu, núcleo 21% Ag / 79% Cu (40% Ag neto)',
    aliases: ['silver clad', '40% silver', 'plata .400', 'plata clad', '40% silver clad', 'kennedy 40%', 'plata .400 clad'],
  );

  static const cladManganeseBrassCopper = NumismaticMaterialDefinition(
    key: 'clad_manganese_brass_copper',
    displayName: nameCladManganeseBrassCopper,
    shortName: 'Latón de manganeso (Clad)',
    family: NumismaticMaterialFamily.brass,
    structure: NumismaticMaterialStructure.clad,
    coreMaterial: 'Cobre',
    platingMaterial: 'Latón de manganeso',
    alloyComposition: 'Capas exteriores 77% Cu, 12% Zn, 7% Mn, 4% Ni, núcleo 100% Cu',
    aliases: [
      'latón de manganeso (clad)',
      'laton de manganeso',
      'manganese brass',
      'manganese brass clad copper',
      'laton de manganeso sobre nucleo de cobre',
      'sacagawea dollar',
      'presidential dollar',
      'latón de manganeso',
    ],
  );

  // ---------------------------------------------------------------------------
  // 6. Electroplated / Bañadas
  // ---------------------------------------------------------------------------
  static const copperPlatedZinc = NumismaticMaterialDefinition(
    key: 'copper_plated_zinc',
    displayName: nameCopperPlatedZinc,
    shortName: 'Zinc (Bañado en cobre)',
    family: NumismaticMaterialFamily.zinc,
    structure: NumismaticMaterialStructure.plated,
    coreMaterial: 'Zinc',
    platingMaterial: 'Cobre',
    alloyComposition: '97.5% Zn núcleo, 2.5% Cu capa exterior electrodepositada',
    aliases: [
      'zinc recubierto de cobre',
      'copper-plated zinc',
      'zinc electrodepositado con cobre',
      'zinc cobreado',
      'lincoln cent zinc',
    ],
  );

  static const copperPlatedSteel = NumismaticMaterialDefinition(
    key: 'copper_plated_steel',
    displayName: nameCopperPlatedSteel,
    shortName: 'Acero (Bañado en cobre)',
    family: NumismaticMaterialFamily.steel,
    structure: NumismaticMaterialStructure.plated,
    coreMaterial: 'Acero',
    platingMaterial: 'Cobre',
    alloyComposition: '94.35% Acero núcleo, 5.65% Cobre exterior',
    aliases: ['copper-plated steel', 'acero cobreado', 'acero electrodepositado con cobre', 'euro 1, 2, 5 centimos'],
  );

  static const nickelPlatedSteel = NumismaticMaterialDefinition(
    key: 'nickel_plated_steel',
    displayName: nameNickelPlatedSteel,
    shortName: 'Acero (Bañado en níquel)',
    family: NumismaticMaterialFamily.steel,
    structure: NumismaticMaterialStructure.plated,
    coreMaterial: 'Acero',
    platingMaterial: 'Níquel',
    aliases: ['nickel-plated steel', 'acero niquelado', 'acero electrodepositado con níquel'],
  );

  static const brassPlatedSteel = NumismaticMaterialDefinition(
    key: 'brass_plated_steel',
    displayName: nameBrassPlatedSteel,
    shortName: 'Acero (Bañado en latón)',
    family: NumismaticMaterialFamily.steel,
    structure: NumismaticMaterialStructure.plated,
    coreMaterial: 'Acero',
    platingMaterial: 'Latón',
    aliases: ['brass-plated steel', 'acero latonado', 'acero electrodepositado con latón'],
  );

  static const bronzePlatedSteel = NumismaticMaterialDefinition(
    key: 'bronze_plated_steel',
    displayName: nameBronzePlatedSteel,
    shortName: 'Acero (Bañado en bronce)',
    family: NumismaticMaterialFamily.steel,
    structure: NumismaticMaterialStructure.plated,
    coreMaterial: 'Acero',
    platingMaterial: 'Bronce',
    aliases: ['bronze-plated steel'],
  );

  static const zincPlatedSteel = NumismaticMaterialDefinition(
    key: 'zinc_plated_steel',
    displayName: nameZincPlatedSteel,
    shortName: 'Acero (Bañado en zinc)',
    family: NumismaticMaterialFamily.steel,
    structure: NumismaticMaterialStructure.plated,
    coreMaterial: 'Acero',
    platingMaterial: 'Zinc',
    aliases: ['zinc-plated steel', 'acero galvanizado', 'steel cent 1943', '1943 steel cent'],
  );

  static const silverPlatedCopper = NumismaticMaterialDefinition(
    key: 'silver_plated_copper',
    displayName: nameSilverPlatedCopper,
    shortName: 'Cobre (Plateado)',
    family: NumismaticMaterialFamily.copper,
    structure: NumismaticMaterialStructure.plated,
    coreMaterial: 'Cobre',
    platingMaterial: 'Plata',
    aliases: ['silver-plated copper', 'cobre plateado'],
  );

  static const nickelPlatedCopper = NumismaticMaterialDefinition(
    key: 'nickel_plated_copper',
    displayName: nameNickelPlatedCopper,
    shortName: 'Cobre (Niquelado)',
    family: NumismaticMaterialFamily.copper,
    structure: NumismaticMaterialStructure.plated,
    coreMaterial: 'Cobre',
    platingMaterial: 'Níquel',
    aliases: ['nickel-plated copper', 'cobre niquelado'],
  );

  // ---------------------------------------------------------------------------
  // 7. Base Metals & Traditional Alloys
  // ---------------------------------------------------------------------------
  static const copper = NumismaticMaterialDefinition(
    key: 'copper',
    displayName: nameCopper,
    shortName: 'Cobre',
    family: NumismaticMaterialFamily.copper,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['copper', 'cu'],
  );

  static const cupronickel = NumismaticMaterialDefinition(
    key: 'cupronickel',
    displayName: nameCupronickel,
    shortName: 'Cuproníquel',
    family: NumismaticMaterialFamily.cupronickel,
    structure: NumismaticMaterialStructure.monometallic,
    alloyComposition: '75% Cu, 25% Ni',
    aliases: ['cuproniquel', 'cu-ni', 'cupronickel', 'cobre-níquel', 'cobre-niquel', 'copper-nickel'],
  );

  static const bronze = NumismaticMaterialDefinition(
    key: 'bronze',
    displayName: nameBronze,
    shortName: 'Bronce',
    family: NumismaticMaterialFamily.bronze,
    structure: NumismaticMaterialStructure.monometallic,
    alloyComposition: '95% Cu, 5% Sn/Zn',
    aliases: ['bronze'],
  );

  static const aluminumBronze = NumismaticMaterialDefinition(
    key: 'aluminum_bronze',
    displayName: nameAluminumBronze,
    shortName: 'Bronce de aluminio',
    family: NumismaticMaterialFamily.bronze,
    structure: NumismaticMaterialStructure.monometallic,
    alloyComposition: '90-92% Cu, 6-10% Al, 2% Ni',
    aliases: ['aluminio-bronce', 'aluminium bronze', 'aluminum bronze', 'al-br'],
  );

  static const phosphorBronze = NumismaticMaterialDefinition(
    key: 'phosphor_bronze',
    displayName: namePhosphorBronze,
    shortName: 'Bronce fosforoso',
    family: NumismaticMaterialFamily.bronze,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['phosphor bronze'],
  );

  static const brass = NumismaticMaterialDefinition(
    key: 'brass',
    displayName: nameBrass,
    shortName: 'Latón',
    family: NumismaticMaterialFamily.brass,
    structure: NumismaticMaterialStructure.monometallic,
    alloyComposition: '60-70% Cu, 30-40% Zn',
    aliases: ['laton', 'brass', 'gilding metal', 'red brass'],
  );

  static const nickelBrass = NumismaticMaterialDefinition(
    key: 'nickel_brass',
    displayName: nameNickelBrass,
    shortName: 'Níquel-Latón',
    family: NumismaticMaterialFamily.brass,
    structure: NumismaticMaterialStructure.monometallic,
    alloyComposition: '70-75% Cu, 20-24.5% Zn, 5-5.5% Ni',
    aliases: ['niquel-laton', 'nickel-brass', 'latón de níquel', 'laton de niquel', 'níquel latón', 'niquel laton'],
  );

  static const tombac = NumismaticMaterialDefinition(
    key: 'tombac',
    displayName: nameTombac,
    shortName: 'Tombac',
    family: NumismaticMaterialFamily.brass,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['tombac', 'tombak', 'latón dorado', 'laton dorado'],
  );

  static const nickel = NumismaticMaterialDefinition(
    key: 'nickel',
    displayName: nameNickel,
    shortName: 'Níquel',
    family: NumismaticMaterialFamily.nickel,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['niquel', 'nickel', 'ni', 'níquel puro'],
  );

  static const alpaca = NumismaticMaterialDefinition(
    key: 'alpaca',
    displayName: nameAlpaca,
    shortName: 'Alpaca',
    family: NumismaticMaterialFamily.nickel,
    structure: NumismaticMaterialStructure.monometallic,
    alloyComposition: '65% Cu, 18% Ni, 17% Zn',
    aliases: ['alpaca', 'plata alemana', 'german silver', 'nickel silver', 'maillechort', 'melchior', 'alpaca plateada'],
  );

  static const nordicGold = NumismaticMaterialDefinition(
    key: 'nordic_gold',
    displayName: nameNordicGold,
    shortName: 'Oro nórdico',
    family: NumismaticMaterialFamily.brass,
    structure: NumismaticMaterialStructure.monometallic,
    alloyComposition: '89% Cu, 5% Al, 5% Zn, 1% Sn',
    aliases: ['oro nordico', 'nordic gold', 'euro 10, 20, 50 centimos'],
  );

  static const billon = NumismaticMaterialDefinition(
    key: 'billon',
    displayName: nameBillon,
    shortName: 'Billón',
    family: NumismaticMaterialFamily.silver,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['billon', 'vellón', 'vellon'],
  );

  static const zinc = NumismaticMaterialDefinition(
    key: 'zinc',
    displayName: nameZinc,
    shortName: 'Zinc',
    family: NumismaticMaterialFamily.zinc,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['cinc', 'zn'],
  );

  static const zamak = NumismaticMaterialDefinition(
    key: 'zamak',
    displayName: nameZamak,
    shortName: 'Zamak',
    family: NumismaticMaterialFamily.zinc,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['zamac'],
  );

  static const lead = NumismaticMaterialDefinition(
    key: 'lead',
    displayName: nameLead,
    shortName: 'Plomo',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['lead', 'pb'],
  );

  static const tin = NumismaticMaterialDefinition(
    key: 'tin',
    displayName: nameTin,
    shortName: 'Estaño',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['estano', 'tin', 'sn'],
  );

  static const pewter = NumismaticMaterialDefinition(
    key: 'pewter',
    displayName: namePewter,
    shortName: 'Peltre',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['pewter'],
  );

  static const iron = NumismaticMaterialDefinition(
    key: 'iron',
    displayName: nameIron,
    shortName: 'Hierro',
    family: NumismaticMaterialFamily.steel,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['iron', 'fe'],
  );

  static const steel = NumismaticMaterialDefinition(
    key: 'steel',
    displayName: nameSteel,
    shortName: 'Acero',
    family: NumismaticMaterialFamily.steel,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['steel'],
  );

  static const stainlessSteel = NumismaticMaterialDefinition(
    key: 'stainless_steel',
    displayName: nameStainlessSteel,
    shortName: 'Acero inoxidable',
    family: NumismaticMaterialFamily.steel,
    structure: NumismaticMaterialStructure.monometallic,
    alloyComposition: '16-18% Cr, 0.75% Ni max, Fe balance (AISI 430)',
    aliases: ['stainless steel', 'acero inox', 'acero inoxidable magnetico'],
  );

  static const aluminum = NumismaticMaterialDefinition(
    key: 'aluminum',
    displayName: nameAluminum,
    shortName: 'Aluminio',
    family: NumismaticMaterialFamily.aluminum,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['aluminum', 'aluminium', 'al'],
  );

  static const magnalium = NumismaticMaterialDefinition(
    key: 'magnalium',
    displayName: nameMagnalium,
    shortName: 'Magnalio',
    family: NumismaticMaterialFamily.aluminum,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['aluminio-magnesio', 'magnalio', 'magnalium'],
  );

  static const titanium = NumismaticMaterialDefinition(
    key: 'titanium',
    displayName: nameTitanium,
    shortName: 'Titanio',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['titanium', 'ti'],
  );

  static const niobium = NumismaticMaterialDefinition(
    key: 'niobium',
    displayName: nameNiobium,
    shortName: 'Niobio',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['niobium', 'nb'],
  );

  static const tantalum = NumismaticMaterialDefinition(
    key: 'tantalum',
    displayName: nameTantalum,
    shortName: 'Tántalo',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.monometallic,
    aliases: ['tantalo', 'tantalum', 'ta'],
  );

  static const trimetallicGeneric = NumismaticMaterialDefinition(
    key: 'trimetallic',
    displayName: nameTrimetallicGeneric,
    shortName: 'Trimetálica',
    family: NumismaticMaterialFamily.trimetallic,
    structure: NumismaticMaterialStructure.trimetallic,
    aliases: ['trimetalica', 'trimetallic'],
  );

  // ---------------------------------------------------------------------------
  // 8. Non-Metallic Materials & Banknotes
  // ---------------------------------------------------------------------------
  static const cottonPaper = NumismaticMaterialDefinition(
    key: 'cotton_paper',
    displayName: nameCottonPaper,
    shortName: 'Papel de algodón',
    family: NumismaticMaterialFamily.paper,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['cotton paper', 'papel de algodon', 'papel moneda', 'cotton'],
  );

  static const polymer = NumismaticMaterialDefinition(
    key: 'polymer',
    displayName: namePolymer,
    shortName: 'Polímero',
    family: NumismaticMaterialFamily.polymer,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['polimero', 'polymer', 'plástico', 'plastico', 'plastic'],
  );

  static const paper = NumismaticMaterialDefinition(
    key: 'paper',
    displayName: namePaper,
    shortName: 'Papel',
    family: NumismaticMaterialFamily.paper,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['paper'],
  );

  static const cardboard = NumismaticMaterialDefinition(
    key: 'cardboard',
    displayName: nameCardboard,
    shortName: 'Cartón',
    family: NumismaticMaterialFamily.paper,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['carton', 'cardboard'],
  );

  static const porcelain = NumismaticMaterialDefinition(
    key: 'porcelain',
    displayName: namePorcelain,
    shortName: 'Porcelana',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['porcelain'],
  );

  static const ceramic = NumismaticMaterialDefinition(
    key: 'ceramic',
    displayName: nameCeramic,
    shortName: 'Cerámica',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['ceramica', 'ceramic'],
  );

  static const pressedFiber = NumismaticMaterialDefinition(
    key: 'pressed_fiber',
    displayName: namePressedFiber,
    shortName: 'Fibra',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['fibra prensada', 'fibra', 'fiber'],
  );

  static const glass = NumismaticMaterialDefinition(
    key: 'glass',
    displayName: nameGlass,
    shortName: 'Vidrio',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['glass'],
  );

  static const leather = NumismaticMaterialDefinition(
    key: 'leather',
    displayName: nameLeather,
    shortName: 'Cuero',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['leather'],
  );

  static const wood = NumismaticMaterialDefinition(
    key: 'wood',
    displayName: nameWood,
    shortName: 'Madera',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['wood'],
  );

  static const other = NumismaticMaterialDefinition(
    key: 'other',
    displayName: nameOther,
    shortName: 'Otro',
    family: NumismaticMaterialFamily.other,
    structure: NumismaticMaterialStructure.nonMetallic,
    aliases: ['otro', 'other'],
  );

  // ---------------------------------------------------------------------------
  // All Registered Materials
  // ---------------------------------------------------------------------------
  static const List<NumismaticMaterialDefinition> allMaterials = [
    // Plata
    silverFine999,
    silverBritannia958,
    silverSterling925,
    silverColonial903,
    silver900,
    silver835,
    silver800,
    silver720,
    silver500,
    silver420,
    silverWar350,
    silver300,
    silver100,
    silverGeneric,
    // Oro
    goldFine9999,
    goldFine999,
    goldCrown9167,
    gold900,
    goldColonial875,
    goldGeneric,
    // Platino y otros preciosos
    platinum,
    palladium,
    rhodium,
    ruthenium,
    electrum,
    // Bimetálicas
    bimetallicBronzeAlStainlessSteel,
    bimetallicAlpacaBronzeAl,
    bimetallicSilver925BronzeAl,
    bimetallicEuro1,
    bimetallicEuro2,
    bimetallicToonie,
    bimetallicUkPound,
    bimetallicGeneric,
    // Clad & Revestidas
    cladCuNiCopper,
    cladSilver400,
    cladManganeseBrassCopper,
    // Bañadas
    copperPlatedZinc,
    copperPlatedSteel,
    nickelPlatedSteel,
    brassPlatedSteel,
    bronzePlatedSteel,
    zincPlatedSteel,
    silverPlatedCopper,
    nickelPlatedCopper,
    // Metales base
    copper,
    cupronickel,
    bronze,
    aluminumBronze,
    phosphorBronze,
    brass,
    nickelBrass,
    tombac,
    nickel,
    alpaca,
    nordicGold,
    billon,
    zinc,
    zamak,
    lead,
    tin,
    pewter,
    iron,
    steel,
    stainlessSteel,
    aluminum,
    magnalium,
    titanium,
    niobium,
    tantalum,
    trimetallicGeneric,
    // No metálicos
    cottonPaper,
    polymer,
    paper,
    cardboard,
    porcelain,
    ceramic,
    pressedFiber,
    glass,
    leather,
    wood,
    other,
  ];

  static final List<String> allDisplayNames = allMaterials.map((m) => m.displayName).toList();

  static final Map<String, NumismaticMaterialDefinition> _byKeyMap = {
    for (final m in allMaterials) m.key: m,
  };

  static final Map<String, NumismaticMaterialDefinition> _byDisplayNameMap = {
    for (final m in allMaterials) m.displayName.toLowerCase(): m,
  };

  static final Map<String, NumismaticMaterialDefinition> _byQueryMap = () {
    final map = <String, NumismaticMaterialDefinition>{};
    for (final m in allMaterials) {
      map[m.key.toLowerCase()] = m;
      map[m.displayName.toLowerCase()] = m;
      map[m.shortName.toLowerCase()] = m;
      for (final alias in m.aliases) {
        map[alias.trim().toLowerCase()] = m;
      }
    }
    return map;
  }();

  /// Finds a material by its technical key.
  static NumismaticMaterialDefinition? findByKey(String key) => _byKeyMap[key];

  /// Finds a material by its full display name.
  static NumismaticMaterialDefinition? findByDisplayName(String name) =>
      _byDisplayNameMap[name.trim().toLowerCase()];

  /// Resolves any query string (key, display name, short name, or alias) to its canonical material definition.
  static NumismaticMaterialDefinition? resolve(String query) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return null;
    final direct = _byQueryMap[clean];
    if (direct != null) return direct;

    // Substring fallback for compound phrases
    for (final m in allMaterials) {
      if (m.matches(clean)) return m;
    }
    return null;
  }

  /// Resolves a raw material string to its canonical display name.
  static String resolveToDisplayName(String raw) {
    final match = resolve(raw);
    if (match != null) return match.displayName;
    return raw.trim();
  }

  /// Evaluates whether two material names belong to the same metallurgical family or represent equivalent precision levels.
  static bool areCompatible(String mat1, String mat2) {
    final clean1 = mat1.trim().toLowerCase();
    final clean2 = mat2.trim().toLowerCase();
    if (clean1 == clean2) return true;

    final def1 = resolve(mat1);
    final def2 = resolve(mat2);

    if (def1 == null || def2 == null) return false;
    if (def1 == def2) return true;

    // Generic family match (e.g. 'Plata' matches 'Plata .720' or 'Plata .925')
    if (def1.family == def2.family) {
      if (def1.key == 'silver' || def2.key == 'silver') return true;
      if (def1.key == 'gold' || def2.key == 'gold') return true;
      if (def1.key == 'bimetallic' || def2.key == 'bimetallic') return true;
    }

    return false;
  }

  /// Returns all materials belonging to the specified metallurgical or substrate family.
  static List<NumismaticMaterialDefinition> getMaterialsByFamily(NumismaticMaterialFamily family) =>
      allMaterials.where((m) => m.family == family).toList();

  /// Returns all materials matching the specified physical configuration or structure.
  static List<NumismaticMaterialDefinition> getMaterialsByStructure(NumismaticMaterialStructure structure) =>
      allMaterials.where((m) => m.structure == structure).toList();

  /// Evaluates whether a material belongs to a precious metal family (gold, silver, platinum, palladium).
  static bool isPreciousMetal(String material) {
    final def = resolve(material);
    if (def == null) return false;
    return def.family == NumismaticMaterialFamily.gold ||
        def.family == NumismaticMaterialFamily.silver ||
        def.family == NumismaticMaterialFamily.platinum ||
        def.family == NumismaticMaterialFamily.palladium;
  }

  /// Calculates the pure bullion metal weight in grams given the material and total gross weight.
  /// Returns null if the material is not recognized or has no defined fineness/purity.
  static double? calculatePureMetalWeight({
    required String material,
    required double totalWeightGrams,
  }) {
    if (totalWeightGrams <= 0) return null;
    final def = resolve(material);
    if (def == null || def.fineness == null) return null;
    return double.parse((totalWeightGrams * def.fineness!).toStringAsFixed(4));
  }
}

/// Convenience facade alias matching PWMS naming conventions.
typedef AppNumismaticMaterials = NumismaticMaterialsRegistry;
