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
        '0.50': '50 Centavos (Tostón)',
      },
    ),
    NumismaticCurrencyDefinition(
      code: mxr,
      name: 'Real Mexicano Colonial e Imperial',
      namePlural: 'Reales Mexicanos Coloniales e Imperiales',
      symbol: 'R',
      hasSubunit: false,
      namedDenominations: {
        '1/16': 'Tlaco (1/16 Real)',
        '1/8': 'Ochavo (1/8 Real)',
        '1/4': 'Cuartilla (1/4 Real)',
        '1/2': 'Medio Real (1/2 Real)',
        '1': '1 Real',
        '2': '2 Reales',
        '4': '4 Reales (Tostón)',
        '8': '8 Reales (Real de a 8 / Peso Fuerte)',
      },
    ),
    NumismaticCurrencyDefinition(
      code: mxe,
      name: 'Escudo Mexicano de Oro',
      namePlural: 'Escudos Mexicanos de Oro',
      symbol: 'E',
      hasSubunit: false,
      namedDenominations: {
        '1/2': 'Medio Escudo (Escudito)',
        '1': '1 Escudo',
        '2': '2 Escudos (Doblón)',
        '4': '4 Escudos',
        '8': '8 Escudos (Onza de Oro)',
      },
    ),

    // Estados Unidos y Canadá
    NumismaticCurrencyDefinition(
      code: usd,
      name: 'Dólar Estadounidense',
      namePlural: 'Dólares Estadounidenses',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Cent',
      subunitNamePlural: 'Cents',
      subunitSymbol: '¢',
      subunitRatio: 100,
      namedDenominations: {
        '0.01': '1 Cent (Penny)',
        '0.05': '5 Cents (Nickel)',
        '0.10': '10 Cents (Dime)',
        '0.25': 'Quarter Dollar (25 Cents)',
        '0.50': 'Half Dollar (50 Cents)',
      },
    ),
    NumismaticCurrencyDefinition(
      code: usc,
      name: 'Dólar Continental de EE.UU.',
      namePlural: 'Dólares Continentales de EE.UU.',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Cent',
      subunitNamePlural: 'Cents',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: cad,
      name: 'Dólar Canadiense',
      namePlural: 'Dólares Canadienses',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Cent',
      subunitNamePlural: 'Cents',
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
        '5': '5 Pesetas (Duro)',
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
        '1/4': 'Cuartilla (1/4 Real)',
        '1/2': 'Medio Real (1/2 Real)',
        '4': '4 Reales (Tostón)',
        '8': '8 Reales (Real de a 8)',
      },
    ),
    NumismaticCurrencyDefinition(
      code: esc,
      name: 'Escudo Español',
      namePlural: 'Escudos Españoles',
      symbol: 'E',
      hasSubunit: false,
      namedDenominations: {
        '2': '2 Escudos (Doblón)',
        '8': '8 Escudos (Onza Española)',
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
        '0.05': '1 Chelín (Shilling)',
        '0.10': '1 Florín (Florin)',
        '0.125': 'Media Corona (Half Crown)',
        '0.25': '1 Corona (Crown)',
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
      name: 'Real Brasileño Histórico (Réis)',
      namePlural: 'Reales Brasileños Históricos (Réis)',
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
      subunitName: 'Cent',
      subunitNamePlural: 'Cents',
      subunitSymbol: '¢',
      subunitRatio: 100,
    ),
    NumismaticCurrencyDefinition(
      code: nzd,
      name: 'Dólar Neozelandés',
      namePlural: 'Dólares Neozelandeses',
      symbol: r'$',
      hasSubunit: true,
      subunitName: 'Cent',
      subunitNamePlural: 'Cents',
      subunitSymbol: '¢',
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
      if (clean.toLowerCase().contains(c.name.toLowerCase()) ||
          clean.toLowerCase().contains(c.namePlural.toLowerCase())) {
        return c;
      }
    }
    return null;
  }
}
