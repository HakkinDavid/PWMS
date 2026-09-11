import '../models/numismatic_currency_definition.dart';

export '../models/numismatic_currency_definition.dart';

/// Centralized compile-time constants and registry for all modern and historical Numismatic currency codes and definitions.
abstract final class NumismaticCurrenciesRegistry {
  // ---------------------------------------------------------------------------
  // 1. España e Hispanoamérica histórica y moderna (1500s - presente)
  // ---------------------------------------------------------------------------
  static const real = 'REAL';
  static const esc = 'ESC';
  static const mrv = 'MRV';
  static const esp = 'ESP';
  static const rdv = 'RDV';
  static const mxn = 'MXN';
  static const mxp = 'MXP';
  static const mxr = 'MXR';
  static const mxe = 'MXE';
  static const ars = 'ARS';
  static const ara = 'ARA';
  static const arl = 'ARL';
  static const arm = 'ARM';
  static const arp = 'ARP';
  static const bob = 'BOB';
  static const bop = 'BOP';
  static const bos = 'BOS';
  static const brl = 'BRL';
  static const brr = 'BRR';
  static const bre = 'BRE';
  static const brn = 'BRN';
  static const brc = 'BRC';
  static const brb = 'BRB';
  static const brs = 'BRS';
  static const clp = 'CLP';
  static const cle = 'CLE';
  static const clf = 'CLF';
  static const cop = 'COP';
  static const copHist = 'COP_HIST';
  static const crc = 'CRC';
  static const crcHist = 'CRC_HIST';
  static const cup = 'CUP';
  static const cuc = 'CUC';
  static const dop = 'DOP';
  static const dopHist = 'DOP_HIST';
  static const gtq = 'GTQ';
  static const gtqHist = 'GTQ_HIST';
  static const gthCent = 'GTH_CENT';
  static const hnl = 'HNL';
  static const hnlHist = 'HNL_HIST';
  static const htg = 'HTG';
  static const htgHist = 'HTG_HIST';
  static const nio = 'NIO';
  static const nioHist = 'NIO_HIST';
  static const pab = 'PAB';
  static const pen = 'PEN';
  static const pei = 'PEI';
  static const peh = 'PEH';
  static const per = 'PER';
  static const pyg = 'PYG';
  static const pyp = 'PYP';
  static const svc = 'SVC';
  static const svcHist = 'SVC_HIST';
  static const uyu = 'UYU';
  static const uyp = 'UYP';
  static const ves = 'VES';
  static const ved = 'VED';
  static const vef = 'VEF';
  static const veb = 'VEB';
  static const ven = 'VEN';
  static const vesHist = 'VES_HIST';

  // ---------------------------------------------------------------------------
  // 2. Norteamérica y Caribe
  // ---------------------------------------------------------------------------
  static const usd = 'USD';
  static const usc = 'USC';
  static const csa = 'CSA';
  static const hwi = 'HWI';
  static const cad = 'CAD';
  static const cadHist = 'CAD_HIST';
  static const nfl = 'NFL';
  static const bzd = 'BZD';
  static const jmd = 'JMD';
  static const jmdHist = 'JMD_HIST';
  static const bsd = 'BSD';
  static const bbd = 'BBD';
  static const ttd = 'TTD';
  static const kyd = 'KYD';
  static const xcd = 'XCD';
  static const awg = 'AWG';
  static const ang = 'ANG';
  static const dwi = 'DWI';
  static const fkp = 'FKP';
  static const gyd = 'GYD';
  static const srd = 'SRD';
  static const srg = 'SRG';

  // ---------------------------------------------------------------------------
  // 3. Europa (1500s - presente)
  // ---------------------------------------------------------------------------
  static const eur = 'EUR';
  static const gbp = 'GBP';
  static const gbpOld = 'GBP_OLD';
  static const sco = 'SCO';
  static const frf = 'FRF';
  static const lvt = 'LVT';
  static const ecu = 'ECU';
  static const ldo = 'LDO';
  static const dem = 'DEM';
  static const ddm = 'DDM';
  static const rkm = 'RKM';
  static const rtm = 'RTM';
  static const prm = 'PRM';
  static const frg = 'FRG';
  static const gth = 'GTH';
  static const ggl = 'GGL';
  static const chf = 'CHF';
  static const chfHist = 'CHF_HIST';
  static const itl = 'ITL';
  static const vec = 'VEC';
  static const gen = 'GEN';
  static const pst = 'PST';
  static const val = 'VAL';
  static const sml = 'SML';
  static const npl = 'NPL';
  static const tos = 'TOS';
  static const sarHist = 'SAR_HIST';
  static const mil = 'MIL';
  static const mltOrd = 'MLT_ORD';
  static const mtl = 'MTL';
  static const ats = 'ATS';
  static const ath = 'ATH';
  static const atg = 'ATG';
  static const mtt = 'MTT';
  static const nlg = 'NLG';
  static const nlgHist = 'NLG_HIST';
  static const bef = 'BEF';
  static const luf = 'LUF';
  static const pte = 'PTE';
  static const por = 'POR';
  static const grd = 'GRD';
  static const phx = 'PHX';
  static const iep = 'IEP';
  static const fim = 'FIM';
  static const sek = 'SEK';
  static const sekHist = 'SEK_HIST';
  static const nok = 'NOK';
  static const nokHist = 'NOK_HIST';
  static const dkk = 'DKK';
  static const dkkHist = 'DKK_HIST';
  static const isk = 'ISK';
  static const gip = 'GIP';
  static const rub = 'RUB';
  static const rur = 'RUR';
  static const sur = 'SUR';
  static const uah = 'UAH';
  static const byn = 'BYN';
  static const mdl = 'MDL';
  static const prb = 'PRB';
  static const pln = 'PLN';
  static const plz = 'PLZ';
  static const plx = 'PLX';
  static const czk = 'CZK';
  static const csk = 'CSK';
  static const bom = 'BOM';
  static const skk = 'SKK';
  static const huf = 'HUF';
  static const hup = 'HUP';
  static const huk = 'HUK';
  static const ron = 'RON';
  static const rol = 'ROL';
  static const bgn = 'BGN';
  static const bgl = 'BGL';
  static const rsd = 'RSD';
  static const yud = 'YUD';
  static const hrk = 'HRK';
  static const hrd = 'HRD';
  static const bam = 'BAM';
  static const all = 'ALL';
  static const mkd = 'MKD';
  static const try_ = 'TRY';
  static const ote = 'OTE';
  static const cyp = 'CYP';

  // ---------------------------------------------------------------------------
  // 4. Asia, Medio Oriente y Cáucaso (1500s - presente)
  // ---------------------------------------------------------------------------
  static const jpy = 'JPY';
  static const jpnEdo = 'JPN_EDO';
  static const cny = 'CNY';
  static const chnQing = 'CHN_QING';
  static const chnRep = 'CHN_REP';
  static const mck = 'MCK';
  static const tib = 'TIB';
  static const krw = 'KRW';
  static const kpw = 'KPW';
  static const korJoseon = 'KOR_JOSEON';
  static const twd = 'TWD';
  static const hkd = 'HKD';
  static const mop = 'MOP';
  static const php = 'PHP';
  static const phpHist = 'PHP_HIST';
  static const inr = 'INR';
  static const indMug = 'IND_MUG';
  static const indEic = 'IND_EIC';
  static const indBrit = 'IND_BRIT';
  static const indPor = 'IND_POR';
  static const indFr = 'IND_FR';
  static const idr = 'IDR';
  static const nid = 'NID';
  static const myr = 'MYR';
  static const str = 'STR';
  static const mal = 'MAL';
  static const sgd = 'SGD';
  static const bnd = 'BND';
  static const thb = 'THB';
  static const thbHist = 'THB_HIST';
  static const vnd = 'VND';
  static const fic = 'FIC';
  static const ann = 'ANN';
  static const khr = 'KHR';
  static const lak = 'LAK';
  static const mmk = 'MMK';
  static const mmkHist = 'MMK_HIST';
  static const bdt = 'BDT';
  static const pkr = 'PKR';
  static const lkr = 'LKR';
  static const cey = 'CEY';
  static const npr = 'NPR';
  static const btn = 'BTN';
  static const mvr = 'MVR';
  static const afn = 'AFN';
  static const afgHist = 'AFG_HIST';
  static const irr = 'IRR';
  static const perHist = 'PER_HIST';
  static const iqd = 'IQD';
  static const syp = 'SYP';
  static const lbp = 'LBP';
  static const jod = 'JOD';
  static const ils = 'ILS';
  static const pal = 'PAL';
  static const sar = 'SAR';
  static const hej = 'HEJ';
  static const aed = 'AED';
  static const qar = 'QAR';
  static const bhd = 'BHD';
  static const kwd = 'KWD';
  static const omr = 'OMR';
  static const yer = 'YER';
  static const amd = 'AMD';
  static const azn = 'AZN';
  static const gel = 'GEL';
  static const kzt = 'KZT';
  static const kgs = 'KGS';
  static const tjs = 'TJS';
  static const tmt = 'TMT';
  static const uzs = 'UZS';
  static const mnt = 'MNT';

  // ---------------------------------------------------------------------------
  // 5. Oceanía (1500s - presente)
  // ---------------------------------------------------------------------------
  static const aud = 'AUD';
  static const aup = 'AUP';
  static const nzd = 'NZD';
  static const nzp = 'NZP';
  static const fjd = 'FJD';
  static const pgk = 'PGK';
  static const sbd = 'SBD';
  static const vuv = 'VUV';
  static const wst = 'WST';
  static const top = 'TOP';
  static const xpf = 'XPF';

  // ---------------------------------------------------------------------------
  // 6. África (1500s - presente)
  // ---------------------------------------------------------------------------
  static const egp = 'EGP';
  static const egyHist = 'EGY_HIST';
  static const zar = 'ZAR';
  static const zarHist = 'ZAR_HIST';
  static const ngn = 'NGN';
  static const ngaHist = 'NGA_HIST';
  static const bia = 'BIA';
  static const mad = 'MAD';
  static const madHist = 'MAD_HIST';
  static const dzd = 'DZD';
  static const algHist = 'ALG_HIST';
  static const tnd = 'TND';
  static const tunHist = 'TUN_HIST';
  static const lyd = 'LYD';
  static const lybHist = 'LYB_HIST';
  static const kes = 'KES';
  static const eas = 'EAS';
  static const etb = 'ETB';
  static const etbHist = 'ETB_HIST';
  static const ghs = 'GHS';
  static const ghaHist = 'GHA_HIST';
  static const xof = 'XOF';
  static const xaf = 'XAF';
  static const mur = 'MUR';
  static const bwp = 'BWP';
  static const nad = 'NAD';
  static const tzs = 'TZS';
  static const znz = 'ZNZ';
  static const ugx = 'UGX';
  static const aoa = 'AOA';
  static const angPor = 'ANG_POR';
  static const mzn = 'MZN';
  static const mozPor = 'MOZ_POR';
  static const zmw = 'ZMW';
  static const zwl = 'ZWL';
  static const rho = 'RHO';
  static const szl = 'SZL';
  static const lsl = 'LSL';
  static const bif = 'BIF';
  static const cve = 'CVE';
  static const kmf = 'KMF';
  static const cdf = 'CDF';
  static const zai = 'ZAI';
  static const kat = 'KAT';
  static const djf = 'DJF';
  static const ern = 'ERN';
  static const gmd = 'GMD';
  static const gnf = 'GNF';
  static const lrd = 'LRD';
  static const mga = 'MGA';
  static const mwk = 'MWK';
  static const mru = 'MRU';
  static const rwf = 'RWF';
  static const stn = 'STN';
  static const scr = 'SCR';
  static const sle = 'SLE';
  static const sll = 'SLL';
  static const sos = 'SOS';
  static const sdg = 'SDG';
  static const ssp = 'SSP';

  // ---------------------------------------------------------------------------
  // Canonical Currencies Definitions (Single Source of Truth)
  // ---------------------------------------------------------------------------
  static const List<NumismaticCurrencyDefinition> allCurrencies = [
    // México
    NumismaticCurrencyDefinition(
      code: mxn,
      name: 'Peso Mexicano',
      namePlural: 'Pesos Mexicanos',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: mxp,
      name: 'Peso Mexicano Antiguo',
      namePlural: 'Pesos Mexicanos Antiguos',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
      namedDenominations: {
        '0.50': 'Tostón',
      },
    ),
    NumismaticCurrencyDefinition(
      code: mxr,
      name: 'Real Mexicano Colonial e Imperial',
      namePlural: 'Reales Mexicanos Coloniales e Imperiales',
      symbol: 'R',
      hasSubunit: false,
      namedDenominations: {
        '1/16': 'Tlaco',
        '1/8': 'Ochavo',
        '1/4': 'Cuartilla',
        '1/2': 'Medio Real',
        '4': 'Tostón',
        '8': 'Real de a 8',
      },
    ),
    NumismaticCurrencyDefinition(
      code: mxe,
      name: 'Escudo Mexicano de Oro',
      namePlural: 'Escudos Mexicanos de Oro',
      symbol: 'E',
      hasSubunit: false,
      namedDenominations: {
        '1/2': 'Escudito',
        '2': 'Doblón',
        '8': 'Onza',
      },
    ),

    // Estados Unidos y Canadá
    NumismaticCurrencyDefinition(
      code: usd,
      name: 'Dólar Estadounidense',
      namePlural: 'Dólares Estadounidenses',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
      namedDenominations: {
        '0.01': 'Penny',
        '0.05': 'Nickel',
        '0.10': 'Dime',
        '0.25': 'Cuarto',
        '0.50': 'Medio',
      },
    ),
    NumismaticCurrencyDefinition(
      code: usc,
      name: 'Dólar Continental de EE.UU.',
      namePlural: 'Dólares Continentales de EE.UU.',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: cad,
      name: 'Dólar Canadiense',
      namePlural: 'Dólares Canadienses',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),

    // Europa
    NumismaticCurrencyDefinition(
      code: eur,
      name: 'Euro',
      namePlural: 'Euros',
      symbol: '€',
      hasSubunit: true,
      subunitName: 'Céntimo de Euro',
      subunitNamePlural: 'Céntimos de Euro',
      subunitSymbol: 'c',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: esp,
      name: 'Peseta Española',
      namePlural: 'Pesetas Españolas',
      symbol: 'Pta',
      hasSubunit: true,
      subunitName: 'Céntimo de Peseta',
      subunitNamePlural: 'Céntimos de Peseta',
      subunitSymbol: 'cts',
      subunitRatio: 100,
      namedDenominations: {
        '5': 'Duro',
      },
    ),
    NumismaticCurrencyDefinition(
      code: real,
      name: 'Real Español',
      namePlural: 'Reales Españoles',
      symbol: 'R',
      hasSubunit: true,
      subunitName: 'Maravedí',
      subunitNamePlural: 'Maravedíes',
      subunitSymbol: 'mrv',
      subunitRatio: 34,
      namedDenominations: {
        '1/4': 'Cuartilla',
        '1/2': 'Medio Real',
        '4': 'Tostón',
        '8': 'Real de a 8',
      },
    ),
    NumismaticCurrencyDefinition(
      code: esc,
      name: 'Escudo Español',
      namePlural: 'Escudos Españoles',
      symbol: 'E',
      hasSubunit: false,
      namedDenominations: {
        '2': 'Doblón',
        '8': 'Onza',
      },
    ),
    NumismaticCurrencyDefinition(
      code: mrv,
      name: 'Maravedí',
      namePlural: 'Maravedíes',
      symbol: 'mrv',
      hasSubunit: false,
    ),
    NumismaticCurrencyDefinition(
      code: rdv,
      name: 'Real de Vellón',
      namePlural: 'Reales de Vellón',
      symbol: 'R',
      hasSubunit: false,
    ),
    NumismaticCurrencyDefinition(
      code: gbp,
      name: 'Libra Esterlina',
      namePlural: 'Libras Esterlinas',
      symbol: '£',
      hasSubunit: true,
      subunitName: 'Penique',
      subunitNamePlural: 'Peniques',
      subunitSymbol: 'p',
      subunitRatio: 100,
      namedDenominations: {
        '0.01': 'Penny',
      },
    ),
    NumismaticCurrencyDefinition(
      code: gbpOld,
      name: 'Libra Esterlina Antigua',
      namePlural: 'Libras Esterlinas Antiguas',
      symbol: '£',
      hasSubunit: true,
      subunitName: 'Penique Antiguo',
      subunitNamePlural: 'Peniques Antiguos',
      subunitSymbol: 'd',
      subunitRatio: 240,
      namedDenominations: {
        '0.05': 'Chelín',
        '0.10': 'Florín',
        '0.125': 'Media Corona',
        '0.25': 'Corona',
      },
    ),
    NumismaticCurrencyDefinition(
      code: frf,
      name: 'Franco Francés',
      namePlural: 'Francos Franceses',
      symbol: 'F',
      hasSubunit: true,
      subunitName: 'Céntimo',
      subunitNamePlural: 'Céntimos',
      subunitSymbol: 'c',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: dem,
      name: 'Marco Alemán',
      namePlural: 'Marcos Alemanes',
      symbol: 'DM',
      hasSubunit: true,
      subunitName: 'Pfennig',
      subunitNamePlural: 'Pfennigs',
      subunitSymbol: 'pf',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: itl,
      name: 'Lira Italiana',
      namePlural: 'Liras Italianas',
      symbol: 'L.',
      hasSubunit: true,
      subunitName: 'Centésimo',
      subunitNamePlural: 'Centésimos',
      subunitSymbol: 'c.',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: chf,
      name: 'Franco Suizo',
      namePlural: 'Francos Suizos',
      symbol: 'CHF',
      hasSubunit: true,
      subunitName: 'Rappen',
      subunitNamePlural: 'Rappens',
      subunitSymbol: 'rp.',
      subunitRatio: 100,
    ),

    // Latinoamérica
    NumismaticCurrencyDefinition(
      code: ars,
      name: 'Peso Argentino',
      namePlural: 'Pesos Argentinos',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: ara,
      name: 'Austral Argentino',
      namePlural: 'Australes Argentinos',
      symbol: '₳',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: brl,
      name: 'Real Brasileño',
      namePlural: 'Reales Brasileños',
      symbol: r'R$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: brs,
      name: 'Real Brasileño Histórico',
      namePlural: 'Reales Brasileños Históricos',
      symbol: 'Rs',
      hasSubunit: false,
    ),
    NumismaticCurrencyDefinition(
      code: clp,
      name: 'Peso Chileno',
      namePlural: 'Pesos Chilenos',
      symbol: r'$',
      hasSubunit: false,
    ),
    NumismaticCurrencyDefinition(
      code: cop,
      name: 'Peso Colombiano',
      namePlural: 'Pesos Colombianos',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: crc,
      name: 'Colón Costarricense',
      namePlural: 'Colones Costarricenses',
      symbol: '₡',
      hasSubunit: true,
      subunitName: 'Céntimo',
      subunitNamePlural: 'Céntimos',
      subunitSymbol: 'c',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: cup,
      name: 'Peso Cubano',
      namePlural: 'Pesos Cubanos',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: dop,
      name: 'Peso Dominicano',
      namePlural: 'Pesos Dominicanos',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: gtq,
      name: 'Quetzal Guatemalteco',
      namePlural: 'Quetzales Guatemaltecos',
      symbol: 'Q',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: hnl,
      name: 'Lempira Hondureño',
      namePlural: 'Lempiras Hondureños',
      symbol: 'L',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: nio,
      name: 'Córdoba Nicaragüense',
      namePlural: 'Córdobas Nicaragüenses',
      symbol: r'C$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: pab,
      name: 'Balboa Panameño',
      namePlural: 'Balboas Panameños',
      symbol: 'B/.',
      hasSubunit: true,
      subunitName: 'Centésimo',
      subunitNamePlural: 'Centésimos',
      subunitSymbol: 'c',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: pen,
      name: 'Sol Peruano',
      namePlural: 'Soles Peruanos',
      symbol: 'S/',
      hasSubunit: true,
      subunitName: 'Céntimo',
      subunitNamePlural: 'Céntimos',
      subunitSymbol: 'c',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: pei,
      name: 'Inti Peruano',
      namePlural: 'Intis Peruanos',
      symbol: 'I/.',
      hasSubunit: true,
      subunitName: 'Céntimo',
      subunitNamePlural: 'Céntimos',
      subunitSymbol: 'c',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: peh,
      name: 'Sol de Oro Peruano',
      namePlural: 'Soles de Oro Peruanos',
      symbol: 'S/.',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: pyg,
      name: 'Guaraní Paraguayo',
      namePlural: 'Guaraníes Paraguayos',
      symbol: '₲',
      hasSubunit: false,
    ),
    NumismaticCurrencyDefinition(
      code: uyu,
      name: 'Peso Uruguayo',
      namePlural: 'Pesos Uruguayos',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centésimo',
      subunitNamePlural: 'Centésimos',
      subunitSymbol: 'c',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: ves,
      name: 'Bolívar Soberano Venezolano',
      namePlural: 'Bolívares Soberanos Venezolanos',
      symbol: 'Bs.S',
      hasSubunit: true,
      subunitName: 'Céntimo',
      subunitNamePlural: 'Céntimos',
      subunitSymbol: 'c',
      subunitRatio: 100,
    ),

    // Asia y Oceanía
    NumismaticCurrencyDefinition(
      code: jpy,
      name: 'Yen Japonés',
      namePlural: 'Yenes Japoneses',
      symbol: '¥',
      hasSubunit: false,
    ),
    NumismaticCurrencyDefinition(
      code: cny,
      name: 'Yuan Chino',
      namePlural: 'Yuanes Chinos',
      symbol: '¥',
      hasSubunit: true,
      subunitName: 'Fen',
      subunitNamePlural: 'Fens',
      subunitSymbol: '分',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: inr,
      name: 'Rupia India',
      namePlural: 'Rupias Indias',
      symbol: '₹',
      hasSubunit: true,
      subunitName: 'Paisa',
      subunitNamePlural: 'Paise',
      subunitSymbol: 'p',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: aud,
      name: 'Dólar Australiano',
      namePlural: 'Dólares Australianos',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: nzd,
      name: 'Dólar Neozelandés',
      namePlural: 'Dólares Neozelandeses',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Centavo',
      subunitNamePlural: 'Centavos',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: aed,
      name: 'Dírham de los Emiratos Árabes Unidos',
      namePlural: 'Dírhams de los Emiratos Árabes Unidos',
      symbol: 'د.إ',
      hasSubunit: true,
      subunitName: 'Fils',
      subunitNamePlural: 'Fils',
      subunitSymbol: 'fils',
      subunitRatio: 100,
    ),
  ];

  static final Map<String, NumismaticCurrencyDefinition> _byCodeMap = {
    for (final c in allCurrencies) c.code.toUpperCase(): c,
  };

  static final Map<String, NumismaticCurrencyDefinition> _byNameMap = () {
    final map = <String, NumismaticCurrencyDefinition>{};
    for (final c in allCurrencies) {
      map[c.name.toLowerCase()] = c;
      map[c.namePlural.toLowerCase()] = c;
    }
    return map;
  }();

  /// Finds a currency definition by its technical / ISO code.
  static NumismaticCurrencyDefinition? findByCode(String? code) {
    if (code == null || code.trim().isEmpty) return null;
    return _byCodeMap[code.trim().toUpperCase()];
  }

  /// Resolves any currency query (code, singular name, plural name) to its canonical definition.
  static NumismaticCurrencyDefinition? resolve(String? query) {
    if (query == null || query.trim().isEmpty) return null;
    final clean = query.trim();
    final upper = clean.toUpperCase();
    final direct = _byCodeMap[upper];
    if (direct != null) return direct;

    final nameDirect = _byNameMap[clean.toLowerCase()];
    if (nameDirect != null) return nameDirect;

    for (final c in allCurrencies) {
      final cleanLower = clean.toLowerCase();
      final cNameLower = c.name.toLowerCase();
      final cNamePluralLower = c.namePlural.toLowerCase();
      if (cleanLower.contains(cNameLower) ||
          cleanLower.contains(cNamePluralLower) ||
          cNameLower.contains(cleanLower) ||
          cNamePluralLower.contains(cleanLower)) {
        return c;
      }
    }
    return null;
  }

  /// Comprehensive map of modern and historical currency codes to full Spanish currency names (plural).
  static const Map<String, String> currencyMap = {
    // 1. España e Hispanoamérica histórica y moderna (1500s - presente)
    'REAL': 'Reales Españoles',
    'ESC': 'Escudos Españoles',
    'MRV': 'Maravedís',
    'ESP': 'Pesetas Españolas',
    'RDV': 'Reales de Vellón',
    'MXN': 'Pesos Mexicanos',
    'MXP': 'Pesos Mexicanos Antiguos',
    'MXR': 'Reales Mexicanos Coloniales e Imperiales',
    'MXE': 'Escudos Mexicanos de Oro',
    'ARS': 'Pesos Argentinos',
    'ARA': 'Australes Argentinos',
    'ARL': 'Pesos Ley Argentinos',
    'ARM': 'Pesos Moneda Nacional Argentinos',
    'ARP': 'Pesos Argentinos',
    'BOB': 'Bolivianos',
    'BOP': 'Pesos Bolivianos',
    'BOS': 'Soles y Bolivianos Antiguos',
    'BRL': 'Reales Brasileños',
    'BRR': 'Cruzeiros Reales Brasileños',
    'BRE': 'Cruzeiros Brasileños',
    'BRN': 'Cruzados Nuevos Brasileños',
    'BRC': 'Cruzados Brasileños',
    'BRB': 'Cruzeiros Brasileños Antiguos',
    'BRS': 'Reales Brasileños Históricos',
    'CLP': 'Pesos Chilenos',
    'CLE': 'Escudos Chilenos',
    'CLF': 'Pesos Chilenos Antiguos',
    'COP': 'Pesos Colombianos',
    'COP_HIST': 'Reales y Pesos Colombianos Antiguos',
    'CRC': 'Colones Costarricenses',
    'CRC_HIST': 'Reales y Pesos Costarricenses Antiguos',
    'CUP': 'Pesos Cubanos',
    'CUC': 'Pesos Cubanos Convertibles',
    'DOP': 'Pesos Dominicanos',
    'DOP_HIST': 'Reales y Francos Dominicanos Antiguos',
    'GTQ': 'Quetzales Guatemaltecos',
    'GTQ_HIST': 'Reales y Pesos Guatemaltecos Antiguos',
    'GTH_CENT': 'Reales y Pesos Federales Centroamericanos',
    'HNL': 'Lempiras Hondureños',
    'HNL_HIST': 'Reales y Pesos Hondureños Antiguos',
    'HTG': 'Gourdes Haitianos',
    'HTG_HIST': 'Escudos y Reales Haitianos Antiguos',
    'NIO': 'Córdobas Nicaragüenses',
    'NIO_HIST': 'Reales y Pesos Nicaragüenses Antiguos',
    'PAB': 'Balboas Panameños',
    'PEN': 'Soles Peruanos',
    'PEI': 'Intis Peruanos',
    'PEH': 'Soles de Oro Peruanos',
    'PER': 'Reales y Pesos Peruanos Antiguos',
    'PYG': 'Guaraníes Paraguayos',
    'PYP': 'Pesos y Reales Paraguayos Antiguos',
    'SVC': 'Colones Salvadoreños',
    'SVC_HIST': 'Reales y Pesos Salvadoreños Antiguos',
    'UYU': 'Pesos Uruguayos',
    'UYP': 'Pesos Uruguayos Antiguos',
    'VES': 'Bolívares Soberanos Venezolanos',
    'VED': 'Bolívares Soberanos Digitales Venezolanos',
    'VEF': 'Bolívares Fuertes Venezolanos',
    'VEB': 'Bolívares Venezolanos Históricos',
    'VEN': 'Venezolanos',
    'VES_HIST': 'Reales y Pesos Venezolanos Antiguos',

    // 2. Norteamérica y Caribe
    'USD': 'Dólares Estadounidenses',
    'USC': 'Dólares Continentales de EE.UU.',
    'CSA': 'Dólares Confederados',
    'HWI': 'Dólares de Hawái',
    'CAD': 'Dólares Canadienses',
    'CAD_HIST': 'Libras y Farthings Canadienses Antiguos',
    'NFL': 'Dólares y Libras de Terranova',
    'BZD': 'Dólares Beliceños',
    'JMD': 'Dólares Jamaicanos',
    'JMD_HIST': 'Libras Jamaicanas',
    'BSD': 'Dólares Bahameños',
    'BBD': 'Dólares de Barbados',
    'TTD': 'Dólares de Trinidad y Tobago',
    'KYD': 'Dólares de las Islas Caimán',
    'XCD': 'Dólares del Caribe Oriental',
    'AWG': 'Florines Arubeños',
    'ANG': 'Florines Antillanos Holandeses',
    'DWI': 'Dólares y Rigsdaler de las Indias Occidentales Danesas',
    'FKP': 'Libras de las Islas Malvinas',
    'GYD': 'Dólares Guyaneses',
    'SRD': 'Dólares Surinameses',
    'SRG': 'Florines Surinameses',

    // 3. Europa (1500s - presente)
    'EUR': 'Euros',
    'GBP': 'Libras Esterlinas',
    'GBP_OLD': 'Libras, Chelines y Peniques Británicos',
    'SCO': 'Libras y Chelines Escoceses',
    'FRF': 'Francos Franceses',
    'LVT': 'Libras Tornesas',
    'ECU': 'Écus Franceses',
    'LDO': 'Luises de Oro Franceses',
    'DEM': 'Marcos Alemanes',
    'DDM': 'Marcos de la República Democrática Alemana',
    'RKM': 'Reichsmark Alemanes',
    'RTM': 'Rentenmark Alemanes',
    'PRM': 'Papiermark Alemanes',
    'FRG': 'Marcos de Oro Alemanes',
    'GTH': 'Táleros Germánicos',
    'GGL': 'Florines Alemanes',
    'CHF': 'Francos Suizos',
    'CHF_HIST': 'Francos y Batzen Suizos Cantonales',
    'ITL': 'Liras Italianas',
    'VEC': 'Ducados, Zecchinos y Liras Venecianas',
    'GEN': 'Liras y Luigini Genoveses',
    'PST': 'Escudos y Baioccos Pontificios',
    'VAL': 'Liras Vaticanas',
    'SML': 'Liras de San Marino',
    'NPL': 'Ducados, Piastras y Carlini Napolitanos',
    'TOS': 'Liras y Francesconi Toscanos',
    'SAR_HIST': 'Liras Sardas',
    'MIL': 'Liras Milanesas',
    'MLT_ORD': 'Escudos y Tari de la Orden de Malta',
    'MTL': 'Liras Maltesas',
    'ATS': 'Chelines Austriacos',
    'ATH': 'Coronas Austrohúngaras',
    'ATG': 'Florines Austrohúngaros',
    'MTT': 'Táleros de María Teresa',
    'NLG': 'Florines Neerlandeses',
    'NLG_HIST': 'Ducatones, Daalders y Stuivers Neerlandeses',
    'BEF': 'Francos Belgas',
    'LUF': 'Francos Luxemburgueses',
    'PTE': 'Escudos Portugueses',
    'POR': 'Reales Portugueses',
    'GRD': 'Dracmas Griegas',
    'PHX': 'Fénix Griegos',
    'IEP': 'Libras Irlandesas',
    'FIM': 'Marcos Finlandeses',
    'SEK': 'Coronas Suecas',
    'SEK_HIST': 'Riksdaler Suecos',
    'NOK': 'Coronas Noruegas',
    'NOK_HIST': 'Speciedaler Noruegos',
    'DKK': 'Coronas Danesas',
    'DKK_HIST': 'Rigsdaler Daneses',
    'ISK': 'Coronas Islandesas',
    'GIP': 'Libras de Gibraltar',
    'RUB': 'Rublos Rusos',
    'RUR': 'Rublos Rusos Zaristas / Pre-1998',
    'SUR': 'Rublos Soviéticos',
    'UAH': 'Grivnas Ucranianas',
    'BYN': 'Rublos Bielorrusos',
    'MDL': 'Leus Moldavos',
    'PRB': 'Rublos de Transnistria',
    'PLN': 'Zlotys Polacos',
    'PLZ': 'Zlotys Polacos Antiguos',
    'PLX': 'Zlotys y Grosz Polacos Históricos',
    'CZK': 'Coronas Checas',
    'CSK': 'Coronas Checoslovacas',
    'BOM': 'Coronas de Bohemia y Moravia',
    'SKK': 'Coronas Eslovacas',
    'HUF': 'Forintos Húngaros',
    'HUP': 'Pengos Húngaros',
    'HUK': 'Coronas Húngaras',
    'RON': 'Leus Rumanos',
    'ROL': 'Leus Rumanos Antiguos',
    'BGN': 'Levs Búlgaros',
    'BGL': 'Levs Búlgaros Antiguos',
    'RSD': 'Dinares Serbios',
    'YUD': 'Dinares Yugoslavos',
    'HRK': 'Kunas Croatas',
    'HRD': 'Dinares Croatas',
    'BAM': 'Marcos Convertibles de Bosnia-Herzegovina',
    'ALL': 'Leks Albaneses',
    'MKD': 'Denares Macedonios',
    'TRY': 'Liras Turcas',
    'OTE': 'Piastras, Kurus y Akces Otomanos',
    'CYP': 'Liras Chipriotas',

    // 4. Asia, Medio Oriente y Cáucaso (1500s - presente)
    'JPY': 'Yenes Japoneses',
    'JPN_EDO': 'Mon, Ryo y Koban Japoneses',
    'CNY': 'Yuanes Chinos',
    'CHN_QING': 'Wen y Taels de la Dinastía Qing',
    'CHN_REP': 'Yuanes de la República de China',
    'MCK': 'Yuanes de Manchukuo',
    'TIB': 'Tanggas y Sangs Tibetanos',
    'KRW': 'Wones Surcoreanos',
    'KPW': 'Wones Norcoreanos',
    'KOR_JOSEON': 'Mun y Yang de Joseon',
    'TWD': 'Nuevos Dólares Taiwaneses',
    'HKD': 'Dólares de Hong Kong',
    'MOP': 'Patacas de Macao',
    'PHP': 'Pesos Filipinos',
    'PHP_HIST': 'Reales y Pesos Filipinos Coloniales',
    'INR': 'Rupias Indias',
    'IND_MUG': 'Mohurs y Rupias del Imperio Mogol',
    'IND_EIC': 'Rupias de la Compañía Británica de las Indias Orientales',
    'IND_BRIT': 'Rupias de la India Británica',
    'IND_POR': 'Rupias y Tangas de la India Portuguesa',
    'IND_FR': 'Rupias y Fanos de la India Francesa',
    'IDR': 'Rupias Indonesias',
    'NID': 'Florines de las Indias Neerlandesas',
    'MYR': 'Ringgits Malayos',
    'STR': 'Dólares de los Asentamientos de los Estrechos',
    'MAL': 'Dólares de Malaya y Borneo',
    'SGD': 'Dólares de Singapur',
    'BND': 'Dólares de Brunéi',
    'THB': 'Bahts Tailandeses',
    'THB_HIST': 'Ticals y Fuangs Siameses Antiguos',
    'VND': 'Dongs Vietnamitas',
    'FIC': 'Piastras de Comercio de Indochina Francesa',
    'ANN': 'Sapèques y Dong de Annam',
    'KHR': 'Rieles Camboyanos',
    'LAK': 'Kips Laosianos',
    'MMK': 'Kyats Birmanos',
    'MMK_HIST': 'Kyats y Peacock Rupees Birmanos Antiguos',
    'BDT': 'Takas Bangladesíes',
    'PKR': 'Rupias Pakistaníes',
    'LKR': 'Rupias de Sri Lanka',
    'CEY': 'Rupias y Rixdollars de Ceilán',
    'NPR': 'Rupias Nepalíes',
    'BTN': 'Ngultrums Butaneses',
    'MVR': 'Rupias Maldivas',
    'AFN': 'Afganis',
    'AFG_HIST': 'Rupias y Kranes Afganos Antiguos',
    'IRR': 'Riales Iraníes',
    'PER_HIST': 'Tomán, Qiran y Shahi Persas',
    'IQD': 'Dinares Iraquíes',
    'SYP': 'Libras Sirias',
    'LBP': 'Libras Libanesas',
    'JOD': 'Dinares Jordanos',
    'ILS': 'Nuevos Shekels Israelíes',
    'PAL': 'Libras Palestinas',
    'SAR': 'Riyales Saudíes',
    'HEJ': 'Riyales de Hiyaz',
    'AED': 'Dírhams de los Emiratos Árabes Unidos',
    'QAR': 'Riyales Cataríes',
    'BHD': 'Dinares Bahreiníes',
    'KWD': 'Dinares Kuwaitíes',
    'OMR': 'Riales Omaníes',
    'YER': 'Riales Yemeníes',
    'AMD': 'Drams Armenios',
    'AZN': 'Manats Azerbaiyanos',
    'GEL': 'Laris Georgianos',
    'KZT': 'Tenges Kazajos',
    'KGS': 'Soms Kirguises',
    'TJS': 'Somonis Tayikos',
    'TMT': 'Manats Turcomanos',
    'UZS': 'Soms Uzbekos',
    'MNT': 'Tugriks Mongolios',

    // 5. Oceanía (1500s - presente)
    'AUD': 'Dólares Australianos',
    'AUP': 'Libras Australianas',
    'NZD': 'Dólares Neozelandeses',
    'NZP': 'Libras Neozelandesas',
    'FJD': 'Dólares Fiyianos',
    'PGK': 'Kinas de Papúa Nueva Guinea',
    'SBD': 'Dólares de las Islas Salomón',
    'VUV': 'Vatus Vanuatuenses',
    'WST': 'Talas Samoanos',
    'TOP': 'Paangas Tonganos',
    'XPF': 'Francos CFP',

    // 6. África (1500s - presente)
    'EGP': 'Libras Egipcias',
    'EGY_HIST': 'Piastras y Milliemes Egipcios Históricos',
    'ZAR': 'Rands Sudafricanos',
    'ZAR_HIST': 'Libras y Florines Sudafricanos / Transvaal',
    'NGN': 'Nairas Nigerianas',
    'NGA_HIST': 'Libras de África Occidental / Nigeria',
    'BIA': 'Libras de Biafra',
    'MAD': 'Dírhams Marroquíes',
    'MAD_HIST': 'Riyales y Mazunas Marroquíes',
    'DZD': 'Dinares Argelinos',
    'ALG_HIST': 'Francos Argelinos',
    'TND': 'Dinares Tunecinos',
    'TUN_HIST': 'Francos y Piastras Tunecinas',
    'LYD': 'Dinares Libios',
    'LYB_HIST': 'Liras y Piastras Libias',
    'KES': 'Chelines Kenianos',
    'EAS': 'Chelines de África Oriental',
    'ETB': 'Birrs Etíopes',
    'ETB_HIST': 'Talari de Menelik y Gersh Etíopes',
    'GHS': 'Cedis Ghaneses',
    'GHA_HIST': 'Libras de la Costa de Oro',
    'XOF': 'Francos CFA de África Occidental',
    'XAF': 'Francos CFA de África Central',
    'MUR': 'Rupias Mauricianas',
    'BWP': 'Pulas Botsuanas',
    'NAD': 'Dólares Namibios',
    'TZS': 'Chelines Tanzanos',
    'ZNZ': 'Rupias y Ryales de Zanzíbar',
    'UGX': 'Chelines Ugandeses',
    'AOA': 'Kwanzas Angoleños',
    'ANG_POR': 'Escudos y Reis Angoleños Portugueses',
    'MZN': 'Meticales Mozambiqueños',
    'MOZ_POR': 'Escudos y Reis Mozambiqueños Portugueses',
    'ZMW': 'Kwanzas Zambianos',
    'ZWL': 'Dólares Zimbabuenses',
    'RHO': 'Libras y Dólares de Rodesia',
    'SZL': 'Lilangeni Suazis',
    'LSL': 'Lotis Lesotenses',
    'BIF': 'Francos Burundeses',
    'CVE': 'Escudos Caboverdianos',
    'KMF': 'Francos Comorenses',
    'CDF': 'Francos Congoleños',
    'ZAI': 'Zaires Congoleños',
    'KAT': 'Francos de Katanga',
    'DJF': 'Francos Yibutianos',
    'ERN': 'Nakfas Eritreos',
    'GMD': 'Dalasis Gambianos',
    'GNF': 'Francos Guineanos',
    'LRD': 'Dólares Liberianos',
    'MGA': 'Ariarys Malgaches',
    'MWK': 'Kwachas Malauís',
    'MRU': 'Ouguiyas Mauritanas',
    'RWF': 'Francos Ruandeses',
    'STN': 'Dobras Santotomenses',
    'SCR': 'Rupias Seychellesas',
    'SLE': 'Leones Sierraleoneses',
    'SLL': 'Leones Sierraleoneses Antiguos',
    'SOS': 'Chelines Somalíes',
    'SDG': 'Libras Sudanesas',
    'SSP': 'Libras Sursudanesas',
  };

  /// Backward compatibility aliases for historical, abbreviated or colloquial currency mentions.
  static const Map<String, String> legacyCurrencyAliases = {
    'eau': 'AED',
    'los eau': 'AED',
    'dirham de los eau': 'AED',
    'dirhams de los eau': 'AED',
    'dirham de los emiratos arabes unidos': 'AED',
    'dirhams de los emiratos arabes unidos': 'AED',
    'emiratos arabes unidos': 'AED',
    'los emiratos arabes unidos': 'AED',
    'dolar continental de ee uu': 'USC',
    'dolares continentales de ee uu': 'USC',
    'dolar continental de eeuu': 'USC',
    'dolares continentales de eeuu': 'USC',
    'dolares continentales de ee.uu.': 'USC',
    'dolar continental de ee.uu.': 'USC',
    'marco de la rda': 'DDM',
    'marcos de la rda': 'DDM'
  };

  /// Maps plural currency nouns and nationalities to their singular standard representation.
  static const Map<String, String> currencySingularReplacements = {
    // Monedas
    'Pesos': 'Peso',
    'Dólares': 'Dólar',
    'Dolares': 'Dólar',
    'Soles': 'Sol',
    'Euros': 'Euro',
    'Libras': 'Libra',
    'Quetzales': 'Quetzal',
    'Florines': 'Florín',
    'Colones': 'Colón',
    'Pesetas': 'Peseta',
    'Reales': 'Real',
    'Escudos': 'Escudo',
    'Maravedís': 'Maravedí',
    'Maravedis': 'Maravedí',
    'Táleros': 'Tálero',
    'Taler': 'Tálero',
    'Francos': 'Franco',
    'Ducados': 'Ducado',
    'Luises': 'Luis',
    'Écus': 'Écu',
    'Zecchinos': 'Zecchino',
    'Piastras': 'Piastra',
    'Coronas': 'Corona',
    'Marcos': 'Marco',
    'Rublos': 'Rublo',
    'Dinares': 'Dinar',
    'Dracmas': 'Dracma',
    'Levs': 'Lev',
    'Leus': 'Leu',
    'Kunas': 'Kuna',
    'Leks': 'Lek',
    'Denares': 'Denar',
    'Grivnas': 'Grivna',
    'Mohurs': 'Mohur',
    'Rupias': 'Rupia',
    'Chelines': 'Chelín',
    'Peniques': 'Penique',
    'Guineas': 'Guinea',
    'Soberanos': 'Soberano',
    'Riyales': 'Riyal',
    'Riales': 'Rial',
    'Dírhams': 'Dírham',
    'Dirhams': 'Dírham',
    'Shekels': 'Shekel',
    'Kips': 'Kip',
    'Dongs': 'Dong',
    'Rieles': 'Riel',
    'Kyats': 'Kyat',
    'Takas': 'Taka',
    'Ngultrums': 'Ngultrum',
    'Afganis': 'Afgani',
    'Yuanes': 'Yuan',
    'Yenes': 'Yen',
    'Wones': 'Won',
    'Bahts': 'Baht',
    'Ringgits': 'Ringgit',
    'Patacas': 'Pataca',
    'Kinas': 'Kina',
    'Vatus': 'Vatu',
    'Talas': 'Tala',
    'Paangas': 'Paanga',
    'Nairas': 'Naira',
    'Cedis': 'Cedi',
    'Pulas': 'Pula',
    'Kwanzas': 'Kwanza',
    'Kwachas': 'Kwacha',
    'Meticales': 'Metical',
    'Dobras': 'Dobra',
    'Nakfas': 'Nakfa',
    'Dalasis': 'Dalasi',
    'Ariarys': 'Ariary',
    'Ouguiyas': 'Ouguiya',
    'Leones': 'León',
    'Gourdes': 'Gourde',
    'Balboas': 'Balboa',
    'Centavos': 'Centavo',
    'Australes': 'Austral',
    'Intis': 'Inti',
    'Venezolanos': 'Venezolano',
    'Bolívares': 'Bolívar',
    'Bolivares': 'Bolívar',
    'Guaraníes': 'Guaraní',
    'Guaranies': 'Guaraní',
    'Somonis': 'Somoni',
    'Manats': 'Manat',
    'Liras': 'Lira',
    'Lira': 'Lira',
    'Laris': 'Lari',
    'Tenges': 'Tenge',
    'Soms': 'Som',
    'Tugriks': 'Tugrik',
    'Pengos': 'Pengo',
    // Nacionalidades / Adjetivos
    'Mexicanos': 'Mexicano',
    'Estadounidenses': 'Estadounidense',
    'Canadienses': 'Canadiense',
    'Colombianos': 'Colombiano',
    'Chilenos': 'Chileno',
    'Argentinos': 'Argentino',
    'Cubanos': 'Cubano',
    'Dominicanos': 'Dominicano',
    'Españoles': 'Español',
    'Alemanes': 'Alemán',
    'Franceses': 'Francés',
    'Británicos': 'Británico',
    'Britanicos': 'Británico',
    'Italianos': 'Italiano',
    'Italiana': 'Italiana',
    'Austriacos': 'Austriaco',
    'Austrohúngaros': 'Austrohúngaro',
    'Austrohungaros': 'Austrohúngaro',
    'Neerlandeses': 'Neerlandés',
    'Portugueses': 'Portugués',
    'Griegos': 'Griego',
    'Irlandeses': 'Irlandés',
    'Suecos': 'Sueco',
    'Noruegos': 'Noruego',
    'Daneses': 'Danés',
    'Rusos': 'Ruso',
    'Polacos': 'Polaco',
    'Checos': 'Checo',
    'Checoslovacos': 'Checoslovaco',
    'Eslovacos': 'Eslovaco',
    'Húngaros': 'Húngaro',
    'Hungaros': 'Húngaro',
    'Rumanos': 'Rumano',
    'Búlgaros': 'Búlgaro',
    'Bulgaros': 'Búlgaro',
    'Serbios': 'Serbio',
    'Yugoslavos': 'Yugoslavo',
    'Croatas': 'Croata',
    'Turcos': 'Turco',
    'Otomanos': 'Otomano',
    'Chinos': 'Chino',
    'Japoneses': 'Japonés',
    'Coreanos': 'Coreano',
    'Indios': 'Indio',
    'Egipcios': 'Egipcio',
    'Sudafricanos': 'Sudafricano',
    'Brasileños': 'Brasileño',
    'Brasilenos': 'Brasileño',
    'Peruanos': 'Peruano',
    'Bolivianos': 'Boliviano',
    'Guatemaltecos': 'Guatemalteco',
    'Salvadoreños': 'Salvadoreño',
    'Salvadorenos': 'Salvadoreño',
    'Hondureños': 'Hondureño',
    'Hondurenos': 'Hondureño',
    'Nicaragüenses': 'Nicaragüense',
    'Nicaraguenses': 'Nicaragüense',
    'Costarricenses': 'Costarricense',
    'Panameños': 'Panameño',
    'Panamenos': 'Panameño',
    'Uruguayos': 'Uruguayo',
    'Paraguayos': 'Paraguayo',
    'Haitianos': 'Haitiano',
    'Jamaicanos': 'Jamaicano',
    'Germánicos': 'Germánico',
    'Germanicos': 'Germánico',
    'Imperiales': 'Imperial',
    'Coloniales': 'Colonial',
    'Federales': 'Federal',
    'Cantonales': 'Cantonal',
    'Nacionales': 'Nacional',
    'Antiguos': 'Antiguo',
    'Antiguas': 'Antigua',
    'Históricos': 'Histórico',
    'Historicos': 'Histórico',
    'Históricas': 'Histórica',
    'Historicas': 'Histórica',
    'Continentales': 'Continental',
    'Confederados': 'Confederado',
    'Confederadas': 'Confederada',
    'Orientales': 'Oriental',
    'Occidentales': 'Occidental',
    // Variantes femeninas
    'Esterlinas': 'Esterlina',
    'Italianas': 'Italiana',
    'Españolas': 'Española',
    'Espanolas': 'Española',
    'Griegas': 'Griega',
    'Suecas': 'Sueca',
    'Noruegas': 'Noruega',
    'Danesas': 'Danesa',
    'Islandesas': 'Islandesa',
    'Irlandesas': 'Irlandesa',
    'Escocesas': 'Escocesa',
    'Vaticanas': 'Vaticana',
    'Maltesas': 'Maltesa',
    'Sardas': 'Sarda',
    'Milanesas': 'Milanesa',
    'Tornesas': 'Tornesa',
    'Jamaicanas': 'Jamaicana',
    'Egipcias': 'Egipcia',
    'Sirias': 'Siria',
    'Libanesas': 'Libanesa',
    'Otomanas': 'Otomana',
    'Ucranianas': 'Ucraniana',
    'Estonias': 'Estonia',
    'Letonas': 'Letona',
    'Lituanas': 'Lituana',
    'Guineanas': 'Guineana',
    'Saharauis': 'Saharaui',
    'Indias': 'India',
    'Indonesias': 'Indonesia',
    'Pakistaníes': 'Pakistaní',
    'Pakistanies': 'Pakistaní',
    'Mauricianas': 'Mauriciana',
    'Nepalesas': 'Nepalesa',
    'Belgas': 'Belga',
    'Suizas': 'Suiza',
    'Rusas': 'Rusa',
    'Polacas': 'Polaca',
    'Checas': 'Checa',
    'Eslovacas': 'Eslovaca',
    'Húngaras': 'Húngara',
    'Hungaras': 'Húngara',
    'Rumanas': 'Rumana',
    'Búlgaras': 'Búlgara',
    'Bulgaras': 'Búlgara',
    'Serbias': 'Serbia',
    'Turcas': 'Turca',
    'Chinas': 'China',
    'Japonesas': 'Japonesa',
    'Coreanas': 'Coreana',
    'Brasileñas': 'Brasileña',
    'Brasilenas': 'Brasileña',
    'Peruanas': 'Peruana',
    'Bolivianas': 'Boliviana',
    'Guatemaltecas': 'Guatemalteca',
    'Salvadoreñas': 'Salvadoreña',
    'Salvadorenas': 'Salvadoreña',
    'Hondureñas': 'Hondureña',
    'Hondurenas': 'Hondureña',
    'Panameñas': 'Panameña',
    'Panamenas': 'Panameña',
    'Uruguayas': 'Uruguaya',
    'Paraguayas': 'Paraguaya',
    'Haitianas': 'Haitiana',
  };
}
