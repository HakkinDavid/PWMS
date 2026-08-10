import 'dart:io';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/attachment.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/i_entity_repository.dart';

class NumismaticAttributes {
  final double? faceValueNumber;
  final String? faceValueStr;
  final String? currencyName;
  final String? currencyCode;
  final String? country;
  final String? year;
  final String? material;
  final String? grade;

  const NumismaticAttributes({
    this.faceValueNumber,
    this.faceValueStr,
    this.currencyName,
    this.currencyCode,
    this.country,
    this.year,
    this.material,
    this.grade,
  });
}

class NumismaticCongruenceIssue {
  final String subspeciesId;
  final String? instanceId;
  final String issueType; // 'magnitude_mismatch', 'duplicate_subspecies', 'attachment_mismatch', 'missing_magnitudes'
  final String description;
  final NumismaticAttributes expectedAttributes;
  final NumismaticAttributes? foundAttributes;

  const NumismaticCongruenceIssue({
    required this.subspeciesId,
    this.instanceId,
    required this.issueType,
    required this.description,
    required this.expectedAttributes,
    this.foundAttributes,
  });
}

class NumismaticDataHelper {
  static const List<String> numismaticSpeciesNames = ['Moneda', 'Billete'];

  /// Map of ISO currency codes to standard full Spanish currency names (plural).
  static const Map<String, String> currencyMap = {
    // 1. México
    'MXN': 'Pesos Mexicanos',
    'MXP': 'Pesos Mexicanos Antiguos',
    // 2. Norteamérica
    'USD': 'Dólares Estadounidenses',
    'CAD': 'Dólares Canadienses',
    // 3. Centroamérica y Caribe
    'GTQ': 'Quetzales Guatemaltecos',
    'BZD': 'Dólares Beliceños',
    'SVC': 'Colones Salvadoreños',
    'HNL': 'Lempiras Hondureños',
    'NIO': 'Córdobas Nicaragüenses',
    'CRC': 'Colones Costarricenses',
    'PAB': 'Balboas Panameños',
    'CUP': 'Pesos Cubanos',
    'CUC': 'Pesos Cubanos Convertibles',
    'DOP': 'Pesos Dominicanos',
    'HTG': 'Gourdes Haitianos',
    'JMD': 'Dólares Jamaicanos',
    'BSD': 'Dólares Bahameños',
    'AWG': 'Florines Arubeños',
    'ANG': 'Florines Antillanos Holandeses',
    'XCD': 'Dólares del Caribe Oriental',
    'KYD': 'Dólares de las Islas Caimán',
    'BBD': 'Dólares de Barbados',
    'TTD': 'Dólares de Trinidad y Tobago',
    // 4. Sudamérica
    'COP': 'Pesos Colombianos',
    'VES': 'Bolívares Soberanos Venezolanos',
    'VED': 'Bolívares Soberanos Digitales Venezolanos',
    'PEN': 'Soles Peruanos',
    'BRL': 'Reales Brasileños',
    'BOB': 'Bolivianos',
    'CLP': 'Pesos Chilenos',
    'ARS': 'Pesos Argentinos',
    'UYU': 'Pesos Uruguayos',
    'PYG': 'Guaraníes Paraguayos',
    'GYD': 'Dólares Guyaneses',
    'SRD': 'Dólares Surinameses',
    'FKP': 'Libras de las Islas Malvinas',
    // 5. Europa
    'ESP': 'Pesetas Españolas',
    'EUR': 'Euros',
    'GBP': 'Libras Esterlinas',
    'CHF': 'Francos Suizos',
    'SEK': 'Coronas Suecas',
    'NOK': 'Coronas Noruegas',
    'DKK': 'Coronas Danesas',
    'PLN': 'Zlotys Polacos',
    'CZK': 'Coronas Checas',
    'HUF': 'Forintos Húngaros',
    'RON': 'Leus Rumanos',
    'BGN': 'Levs Búlgaros',
    'RSD': 'Dinares Serbios',
    'HRK': 'Kunas Croatas',
    'BAM': 'Marcos Convertibles de Bosnia-Herzegovina',
    'ALL': 'Leks Albaneses',
    'MKD': 'Denares Macedonios',
    'RUB': 'Rublos Rusos',
    'UAH': 'Grivnas Ucranianas',
    'BYN': 'Rublos Bielorrusos',
    'MDL': 'Leus Moldavos',
    'TRY': 'Liras Turcas',
    'GIP': 'Libras de Gibraltar',
    'ISK': 'Coronas Islandesas',
    // 6. Asia / Medio Oriente / Pacífico
    'JPY': 'Yenes Japoneses',
    'CNY': 'Yuanes Chinos',
    'KRW': 'Wones Surcoreanos',
    'KPW': 'Wones Norte-Coreanos',
    'TWD': 'Nuevos Dólares Taiwaneses',
    'HKD': 'Dólares de Hong Kong',
    'MOP': 'Patacas Macanesas',
    'INR': 'Rupias Indias',
    'IDR': 'Rupias Indonesias',
    'PHP': 'Pesos Filipinos',
    'SGD': 'Dólares de Singapur',
    'MYR': 'Ringgits Malayos',
    'THB': 'Bahts Tailandeses',
    'VND': 'Dongs Vietnamitas',
    'PKR': 'Rupias Pakistaníes',
    'BDT': 'Takas Bangladesíes',
    'LKR': 'Rupias de Sri Lanka',
    'NPR': 'Rupias Nepalíes',
    'ILS': 'Nuevos Séqueis Israelíes',
    'AED': 'Dírhams de los Emiratos Árabes Unidos',
    'SAR': 'Riyales Saudíes',
    'QAR': 'Riyales Cataríes',
    'KWD': 'Dinares Kuwaitíes',
    'BHD': 'Dinares Baréiníes',
    'OMR': 'Riales Omaníes',
    'JOD': 'Dinares Jordanos',
    'LBP': 'Libras Libanesas',
    'SYP': 'Libras Sirias',
    'IQD': 'Dinares Iraquíes',
    'IRR': 'Riales Iraníes',
    'KZT': 'Tenges Kazakhs',
    'UZS': 'Soms Uzbekos',
    'AFN': 'Afganis Afganos',
    'AMD': 'Drams Armenios',
    'AZN': 'Manats Azerbaiyanos',
    'GEL': 'Laris Georgianos',
    'KHR': 'Rieles Camboyanos',
    'LAK': 'Kips Laosianos',
    'MMK': 'Kyats de Myanmar',
    'MNT': 'Tugriks Mongoles',
    'MVR': 'Rufiyaas Maldivas',
    'BTN': 'Ngultrums Butaneses',
    'TJS': 'Somonis Tayikos',
    'TMT': 'Manats Turkmenios',
    'YER': 'Riales Yemeníes',
    // 7. Oceanía
    'AUD': 'Dólares Australianos',
    'NZD': 'Dólares Neozelandeses',
    'FJD': 'Dólares Fiyianos',
    'PGK': 'Kinas de Papúa Nueva Guinea',
    'SBD': 'Dólares de las Islas Salomón',
    'TOP': 'Paʻangas Tonganos',
    'VUV': 'Vatus Vanuatuenses',
    'WST': 'Talas Samoanos',
    'XPF': 'Francos CFP',
    // 8. África
    'EGP': 'Libras Egipcias',
    'MAD': 'Dírhams Marroquíes',
    'DZD': 'Dinares Argelinos',
    'TND': 'Dinares Tunecinos',
    'LYD': 'Dinares Libios',
    'ZAR': 'Rands Sudafricanos',
    'NGN': 'Nairas Nigerianas',
    'KES': 'Chelines Kenianos',
    'ETB': 'Birrs Etíopes',
    'GHS': 'Cedis Ghaneses',
    'XAF': 'Francos CFA de África Central',
    'XOF': 'Francos CFA de África Occidental',
    'AOA': 'Kwanzas Angoleños',
    'BWP': 'Pulas Botsuanos',
    'BIF': 'Francos Burundeses',
    'CVE': 'Escudos Caboverdianos',
    'CDF': 'Francos Congoleños',
    'DJF': 'Francos Yibutianos',
    'ERN': 'Nakfas Eritreos',
    'GMD': 'Dalasis Gambianos',
    'GNF': 'Francos Guineanos',
    'KMF': 'Francos Comorenses',
    'LRD': 'Dólares Liberianos',
    'LSL': 'Lotis Lesothenses',
    'MGA': 'Ariarys Malgaches',
    'MWK': 'Kwachas Malauíes',
    'MRU': 'Ouguiyas Mauritanas',
    'MUR': 'Rupias de Mauricio',
    'MZN': 'Meticales Mozambanqueños',
    'NAD': 'Dólares Namibios',
    'RWF': 'Francos Ruandeses',
    'SHP': 'Libras de Santa Elena',
    'STN': 'Dobras de Santo Tomé y Príncipe',
    'SCR': 'Rupias de Seychelles',
    'SLE': 'Leones de Sierra Leona',
    'SLL': 'Leones Antiguos de Sierra Leona',
    'SOS': 'Chelines Somalíes',
    'SDG': 'Libras Sudanesas',
    'SSP': 'Libras Sudsudanesas',
    'SZL': 'Lilangeni Esuatiníes',
    'TZS': 'Chelines Tanzanos',
    'UGX': 'Chelines Ugandeses',
    'ZMW': 'Kwachas Zambianos',
    'ZWL': 'Dólares Zimbabuenses',
  };

  /// Countries ordered by geographic, economic & cultural proximity to Mexico.
  static const List<String> countries = [
    // 1. México
    'México',
    // 2. Norteamérica
    'Estados Unidos', 'Canadá',
    // 3. Centroamérica y Caribe
    'Guatemala', 'Belice', 'El Salvador', 'Honduras', 'Nicaragua', 'Costa Rica', 'Panamá',
    'Cuba', 'Puerto Rico', 'República Dominicana', 'Haití', 'Jamaica', 'Bahamas', 'Aruba', 'Curazao',
    'Bermudas', 'Antigua y Barbuda', 'Barbados', 'Dominica', 'Granada', 'San Cristóbal y Nieves',
    'Santa Lucía', 'San Vicente y las Granadinas', 'Trinidad y Tobago', 'Islas Caimán',
    // 4. Sudamérica
    'Colombia', 'Venezuela', 'Ecuador', 'Perú', 'Brasil', 'Bolivia', 'Chile', 'Argentina',
    'Paraguay', 'Uruguay', 'Guyana', 'Surinam', 'Islas Malvinas',
    // 5. Europa
    'España', 'Unión Europea', 'Reino Unido', 'Francia', 'Alemania', 'Italia', 'Portugal', 'Suiza',
    'Bélgica', 'Países Bajos', 'Irlanda', 'Austria', 'Ciudad del Vaticano', 'San Marino', 'Andorra',
    'Dinamarca', 'Noruega', 'Suecia', 'Finlandia', 'Islandia', 'Polonia', 'República Checa',
    'Eslovaquia', 'Hungría', 'Rumanía', 'Bulgaria', 'Grecia', 'Chipre', 'Turquía', 'Rusia', 'Ucrania',
    'Bielorrusia', 'Moldavia', 'Lituania', 'Letonia', 'Estonia', 'Albania', 'Bosnia y Herzegovina',
    'Croacia', 'Eslovenia', 'Macedonia del Norte', 'Montenegro', 'Serbia', 'Gibraltar', 'Groenlandia',
    'Islas Feroe', 'Liechtenstein', 'Luxemburgo', 'Mónaco', 'Malta',
    // 6. Asia y Medio Oriente
    'Japón', 'China', 'Corea del Sur', 'Corea del Norte', 'Taiwán', 'Hong Kong', 'Macao', 'Filipinas',
    'India', 'Indonesia', 'Malasia', 'Singapur', 'Tailandia', 'Vietnam', 'Camboya', 'Laos',
    'Birmania (Myanmar)', 'Bangladés', 'Pakistán', 'Sri Lanka', 'Nepal', 'Bután', 'Maldivas',
    'Afganistán', 'Israel', 'Palestina', 'Jordania', 'Líbano', 'Siria', 'Irak', 'Irán', 'Arabia Saudita',
    'Emiratos Árabes Unidos', 'Catar', 'Baréin', 'Kuwait', 'Omán', 'Yemen', 'Armenia',
    'Azerbaiyán', 'Georgia', 'Kazajistán', 'Kirguistán', 'Tayikistán', 'Turkmenistán', 'Uzbekistán',
    'Brunéi', 'Mongolia', 'Timor Oriental',
    // 7. Oceanía
    'Australia', 'Nueva Zelanda', 'Fiyi', 'Islas Cook', 'Islas Marshall', 'Islas Salomón',
    'Micronesia', 'Nauru', 'Nueva Caledonia', 'Palaos', 'Papúa Nueva Guinea', 'Polinesia Francesa',
    'Samoa', 'Tonga', 'Tuvalu', 'Vanuatu', 'Kiribati',
    // 8. África
    'Egipto', 'Marruecos', 'Argelia', 'Túnez', 'Libia', 'Sudáfrica', 'Nigeria', 'Kenia', 'Etiopía',
    'Angola', 'Benín', 'Botsuana', 'Burkina Faso', 'Burundi', 'Cabo Verde', 'Camerún', 'Chad',
    'Comoras', 'Costa de Marfil', 'Eritrea', 'Esuatini (Suazilandia)', 'Gabón', 'Gambia', 'Ghana',
    'Guinea', 'Guinea Ecuatorial', 'Guinea-Bisáu', 'Lesoto', 'Liberia', 'Madagascar', 'Malaui',
    'Malí', 'Mauricio', 'Mauritania', 'Mozambique', 'Namibia', 'Níger', 'República Centroafricana',
    'República del Congo', 'República Democrática del Congo', 'Ruanda', 'Santo Tomé y Príncipe',
    'Senegal', 'Seychelles', 'Sierra Leona', 'Somalia', 'Sudán', 'Sudán del Sur', 'Tanzania',
    'Togo', 'Uganda', 'Yibuti', 'Zambia', 'Zimbabue',
    // 9. Otro
    'Otro',
  ];

  static const List<String> denominations = [
    '1',
    '2',
    '5',
    '10',
    '20',
    '50',
    '100',
    '200',
    '500',
    '1000',
    '2000',
    '5000',
  ];

  static const List<String> grades = [
    'Sin circular',
    'Excelente',
    'Muy buena',
    'Buena',
    'Regular',
  ];

  static const List<String> coinMaterials = [
    'Cuproníquel',
    'Plata',
    'Bronce',
    'Oro',
    'Latón',
    'Aluminio',
    'Bimetálica',
    'Acero',
    'Papel',
  ];

  static const List<String> specialEditionReasons = [
    'Conmemorativa',
    'Prueba de acuñación',
    'Error de impresión',
    'Serie limitada',
    'Aniversario',
    'Emisión de cambio de régimen',
    'Otro',
  ];

  /// Helper to convert plural currency name to singular if count == 1.
  static String _adjustSingularPlural(String text, double? count) {
    if (count == 1 || count == 1.0) {
      return text
          .replaceAll('Pesos', 'Peso')
          .replaceAll('Dólares', 'Dólar')
          .replaceAll('Dolares', 'Dólar')
          .replaceAll('Soles', 'Sol')
          .replaceAll('Euros', 'Euro')
          .replaceAll('Libras', 'Libra')
          .replaceAll('Quetzales', 'Quetzal')
          .replaceAll('Florines', 'Florín')
          .replaceAll('Colones', 'Colón')
          .replaceAll('Pesetas', 'Peseta')
          .replaceAll('Mexicanos', 'Mexicano')
          .replaceAll('Estadounidenses', 'Estadounidense')
          .replaceAll('Canadienses', 'Canadiense')
          .replaceAll('Colombianos', 'Colombiano')
          .replaceAll('Chilenos', 'Chileno')
          .replaceAll('Argentinos', 'Argentino')
          .replaceAll('Cubanos', 'Cubano')
          .replaceAll('Dominicanos', 'Dominicano')
          .trim();
    }
    return text;
  }

  /// Resolves any currency string (code or name) to its ISO 4217 code (e.g. 'MXN').
  static String resolveCurrencyIsoCode(String codeOrName) {
    final clean = codeOrName.trim();
    if (clean.isEmpty) return clean;

    final upper = clean.toUpperCase();
    if (currencyMap.containsKey(upper)) {
      return upper;
    }

    String normalize(String text) {
      return text.toLowerCase()
          .replaceAll('pesos', 'peso')
          .replaceAll('dólares', 'dólar')
          .replaceAll('dolares', 'dólar')
          .replaceAll('soles', 'sol')
          .replaceAll('euros', 'euro')
          .replaceAll('libras', 'libra')
          .replaceAll(RegExp(r'\s+mexicanos?'), ' mexicano')
          .replaceAll(RegExp(r'\s+estadounidenses?'), ' estadounidense')
          .replaceAll(RegExp(r'\s+canadienses?'), ' canadiense')
          .replaceAll(RegExp(r'\s+colombianos?'), ' colombiano')
          .replaceAll(RegExp(r'\s+chilenos?'), ' chileno')
          .replaceAll(RegExp(r'\s+argentinos?'), ' argentino')
          .replaceAll(RegExp(r'\s+cubanos?'), ' cubano')
          .replaceAll(RegExp(r'\s+dominicanos?'), ' dominicano')
          .trim();
    }

    final normClean = normalize(clean);
    for (final entry in currencyMap.entries) {
      if (normalize(entry.value) == normClean) {
        return entry.key;
      }
    }

    return upper;
  }

  /// Resolves any currency string (code or name) to the strict canonical full Spanish name.
  static String resolveCurrencyName(String codeOrName, {double? count}) {
    final clean = codeOrName.trim();
    if (clean.isEmpty) return clean;

    final upperCode = clean.toUpperCase();
    if (currencyMap.containsKey(upperCode)) {
      return _adjustSingularPlural(currencyMap[upperCode]!, count);
    }

    String normalize(String text) {
      return text.toLowerCase()
          .replaceAll('pesos', 'peso')
          .replaceAll('dólares', 'dólar')
          .replaceAll('dolares', 'dólar')
          .replaceAll('soles', 'sol')
          .replaceAll('euros', 'euro')
          .replaceAll('libras', 'libra')
          .replaceAll(RegExp(r'\s+mexicanos?'), ' mexicano')
          .replaceAll(RegExp(r'\s+estadounidenses?'), ' estadounidense')
          .replaceAll(RegExp(r'\s+canadienses?'), ' canadiense')
          .replaceAll(RegExp(r'\s+colombianos?'), ' colombiano')
          .replaceAll(RegExp(r'\s+chilenos?'), ' chileno')
          .replaceAll(RegExp(r'\s+argentinos?'), ' argentino')
          .replaceAll(RegExp(r'\s+cubanos?'), ' cubano')
          .replaceAll(RegExp(r'\s+dominicanos?'), ' dominicano')
          .trim();
    }

    final normClean = normalize(clean);
    for (final entry in currencyMap.entries) {
      if (normalize(entry.value) == normClean) {
        return _adjustSingularPlural(entry.value, count);
      }
    }

    return _adjustSingularPlural(clean, count);
  }

  /// Resolves grade to strict canonical item in `grades`.
  static String resolveGrade(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (grades.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    if (lower.contains('fdc') || lower.contains('unc') || lower.contains('sin circular')) {
      return grades[0];
    }
    if (lower.contains('ebc') || lower.contains('xf') || lower.contains('excelente')) {
      return grades[1];
    }
    if (lower.contains('mbc') || lower.contains('vf') || lower.contains('muy buena')) {
      return grades[2];
    }
    if (lower.contains('bc') || lower.contains('buena')) {
      return grades[3];
    }
    if (lower.contains('mc') || lower.contains('regular')) {
      return grades[4];
    }

    return clean;
  }

  /// Resolves material to strict canonical item in `coinMaterials`.
  static String resolveMaterial(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (coinMaterials.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    if (lower.contains('cuproníquel') || lower.contains('cuproniquel') || lower.contains('cu-ni')) {
      return 'Cuproníquel';
    }
    if (lower.contains('plata') || lower.contains('silver')) {
      return 'Plata';
    }
    if (lower.contains('bronce') || lower.contains('bronze')) {
      return 'Bronce';
    }
    if (lower.contains('oro') || lower.contains('gold')) {
      return 'Oro';
    }
    if (lower.contains('latón') || lower.contains('laton') || lower.contains('brass')) {
      return 'Latón';
    }
    if (lower.contains('aluminio') || lower.contains('aluminum')) {
      return 'Aluminio';
    }
    if (lower.contains('bimetálica') || lower.contains('bimetalica') || lower.contains('bimetal')) {
      return 'Bimetálica';
    }
    if (lower.contains('acero') || lower.contains('steel')) {
      return 'Acero';
    }
    if (lower.contains('papel') || lower.contains('paper')) {
      return 'Papel';
    }

    return clean;
  }

  /// Resolves special edition reason to strict canonical item in `specialEditionReasons`.
  static String resolveSpecialEditionReason(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return clean;
    if (specialEditionReasons.contains(clean)) return clean;

    final lower = clean.toLowerCase();
    if (lower.contains('conmemorativa') || lower.contains('commemorative')) {
      return specialEditionReasons[0];
    }
    if (lower.contains('proof') || lower.contains('prueba')) {
      return specialEditionReasons[1];
    }
    if (lower.contains('error') || lower.contains('impresión') || lower.contains('impresion')) {
      return specialEditionReasons[2];
    }
    if (lower.contains('limitada') || lower.contains('numeración') || lower.contains('numeracion')) {
      return specialEditionReasons[3];
    }
    if (lower.contains('aniversario') || lower.contains('histórico') || lower.contains('historico')) {
      return specialEditionReasons[4];
    }
    if (lower.contains('régimen') || lower.contains('regimen') || lower.contains('cambio')) {
      return specialEditionReasons[5];
    }

    return clean;
  }

  /// Checks if two currency identifiers match strictly after canonical resolution.
  static bool areCurrenciesEquivalent(String? c1, String? c2, {double? count}) {
    if (c1 == null || c1.trim().isEmpty) return c2 == null || c2.trim().isEmpty;
    if (c2 == null || c2.trim().isEmpty) return false;

    final r1 = resolveCurrencyName(c1, count: count);
    final r2 = resolveCurrencyName(c2, count: count);

    return r1.toLowerCase() == r2.toLowerCase();
  }

  /// Checks if a catalog species is a numismatic species (Moneda or Billete).
  static bool isNumismaticSpecies(CatalogItem species) {
    final nameLower = species.name.trim().toLowerCase();
    if (numismaticSpeciesNames.any((n) => n.toLowerCase() == nameLower)) {
      return true;
    }
    if (species.description != null &&
        species.description!.toLowerCase().contains('numismátic')) {
      return true;
    }
    return false;
  }

  /// Builds a deterministic subspecies title for coins or banknotes.
  /// Format: "[Denominación] [Divisa Estándar] - [País] ([Año])"
  static String buildSubspeciesName({
    double? faceValueNumber,
    String? faceValueStr,
    String? currencyName,
    String? currencyCode,
    String? country,
    String? year,
  }) {
    final denom = (faceValueStr != null && faceValueStr.trim().isNotEmpty)
        ? faceValueStr.trim()
        : (faceValueNumber != null
            ? (faceValueNumber % 1 == 0
                ? faceValueNumber.toInt().toString()
                : faceValueNumber.toString())
            : '');

    final countVal = double.tryParse(denom) ?? faceValueNumber;

    final rawCurr = (currencyName != null && currencyName.trim().isNotEmpty)
        ? currencyName.trim()
        : (currencyCode != null && currencyCode.trim().isNotEmpty
            ? currencyCode.trim()
            : '');

    final canonicalCurr = resolveCurrencyName(rawCurr, count: countVal);

    final cty = (country != null && country.trim().isNotEmpty)
        ? country.trim()
        : '';

    final yr = (year != null && year.trim().isNotEmpty) ? year.trim() : null;

    final firstPart = [denom, canonicalCurr].where((s) => s.isNotEmpty).join(' ');
    final titleParts = <String>[];
    if (firstPart.isNotEmpty) titleParts.add(firstPart);
    if (cty.isNotEmpty) titleParts.add(cty);

    var mainText = titleParts.join(' - ');
    if (yr != null) {
      mainText = mainText.isNotEmpty ? '$mainText ($yr)' : '($yr)';
    }

    if (mainText.isEmpty) {
      return 'Pieza Numismática';
    }

    return mainText;
  }

  /// Builds deterministic subspecies notes string.
  static String buildSubspeciesNotes({
    String? currencyName,
    String? currencyCode,
    String? year,
    String? composition,
  }) {
    final rawCurr = (currencyName != null && currencyName.trim().isNotEmpty)
        ? currencyName.trim()
        : (currencyCode != null && currencyCode.trim().isNotEmpty
            ? currencyCode.trim()
            : null);

    final canonicalCurr = rawCurr != null ? resolveCurrencyName(rawCurr) : null;
    final canonicalMat = composition != null && composition.trim().isNotEmpty
        ? resolveMaterial(composition)
        : null;

    final notesParts = <String>[];
    if (canonicalCurr != null && canonicalCurr.isNotEmpty) {
      notesParts.add('Moneda: ${canonicalCurr.trim()}');
    }
    if (year != null && year.trim().isNotEmpty) {
      notesParts.add('Año: ${year.trim()}');
    }
    if (canonicalMat != null && canonicalMat.isNotEmpty) {
      notesParts.add('Material: ${canonicalMat.trim()}');
    }
    return notesParts.join(' | ');
  }

  /// Sanitizes text for file names.
  static String sanitizeFileName(String text) {
    return text.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }

  /// Builds deterministic filename for attachments.
  static String buildAttachmentFileName({
    required String subspeciesName,
    required String instanceId,
    required String side, // 'anverso' or 'reverso'
    required String extension,
  }) {
    final sanitizedSubname = sanitizeFileName(subspeciesName);
    final ext = extension.startsWith('.') ? extension.substring(1) : extension;
    return '$sanitizedSubname ($instanceId) ($side).$ext';
  }

  /// Extracts numismatic attributes from an instance's magnitudes.
  static NumismaticAttributes extractAttributesFromInstance(WorldEntity entity) {
    double? faceVal;
    String? year;
    String? currency;
    String? material;
    String? grade;

    for (final mag in entity.magnitudes) {
      if (mag.propertyName == 'Valor nominal') {
        faceVal = mag.magnitudeValue;
      } else if (mag.propertyName == 'Acuñación') {
        if (mag.magnitudeValue > 0) {
          year = mag.magnitudeValue.toInt().toString();
        } else if (mag.stringValue != null && mag.stringValue!.isNotEmpty) {
          year = mag.stringValue;
        }
      } else if (mag.propertyName == 'Divisa') {
        currency = mag.stringValue;
      } else if (mag.propertyName == 'Material') {
        material = mag.stringValue;
      } else if (mag.propertyName == 'Grado') {
        grade = mag.stringValue;
      }
    }

    return NumismaticAttributes(
      faceValueNumber: faceVal,
      currencyName: currency,
      year: year,
      material: material,
      grade: grade,
    );
  }

  /// Parses subspecies title to extract denomination, currency, country, year.
  static NumismaticAttributes parseSubspeciesName(String name) {
    final yearRegex = RegExp(r'\(([^)]+)\)\s*$');
    final match = yearRegex.firstMatch(name);
    String? year;
    String mainText = name;

    if (match != null) {
      year = match.group(1)?.trim();
      mainText = name.substring(0, match.start).trim();
      if (mainText.endsWith('-')) {
        mainText = mainText.substring(0, mainText.length - 1).trim();
      }
    }

    final dashParts = mainText.split(' - ');
    String? denomAndCurr;
    String? country;

    if (dashParts.length >= 2) {
      denomAndCurr = dashParts[0].trim();
      country = dashParts.sublist(1).join(' - ').trim();
    } else {
      denomAndCurr = mainText.trim();
    }

    double? faceValue;
    String? faceValStr;
    String? currency;

    if (denomAndCurr != null && denomAndCurr.isNotEmpty) {
      final firstSpace = denomAndCurr.indexOf(' ');
      if (firstSpace > 0) {
        final numPart = denomAndCurr.substring(0, firstSpace).trim();
        final parsed = double.tryParse(numPart);
        if (parsed != null) {
          faceValue = parsed;
          faceValStr = numPart;
          currency = denomAndCurr.substring(firstSpace + 1).trim();
        } else {
          currency = denomAndCurr;
        }
      } else {
        final parsed = double.tryParse(denomAndCurr);
        if (parsed != null) {
          faceValue = parsed;
          faceValStr = denomAndCurr;
        } else {
          currency = denomAndCurr;
        }
      }
    }

    return NumismaticAttributes(
      faceValueNumber: faceValue,
      faceValueStr: faceValStr,
      currencyName: currency != null ? resolveCurrencyName(currency, count: faceValue) : null,
      country: country,
      year: year,
    );
  }

  /// Checks if instance magnitudes and subspecies title follow the strict canonical pattern.
  static String? checkInstanceSubspeciesCongruence({
    required Subspecies subspecies,
    required WorldEntity instance,
  }) {
    final instAttrs = extractAttributesFromInstance(instance);
    final subAttrs = parseSubspeciesName(subspecies.subspeciesName);

    final mismatches = <String>[];

    // 1. Strict subspecies title pattern check
    final canonicalTitle = buildSubspeciesName(
      faceValueNumber: instAttrs.faceValueNumber ?? subAttrs.faceValueNumber,
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      country: subAttrs.country,
      year: instAttrs.year ?? subAttrs.year,
    );

    if (subspecies.subspeciesName.trim() != canonicalTitle.trim()) {
      mismatches.add('Título no estandarizado (Actual: "${subspecies.subspeciesName}" vs Estándar: "$canonicalTitle")');
    }

    // 2. Year check
    if (instAttrs.year != null &&
        subAttrs.year != null &&
        instAttrs.year != subAttrs.year) {
      mismatches.add('Año (Instancia: ${instAttrs.year} vs Subespecie: ${subAttrs.year})');
    }

    // 3. Face value check
    if (instAttrs.faceValueNumber != null &&
        subAttrs.faceValueNumber != null &&
        (instAttrs.faceValueNumber! - subAttrs.faceValueNumber!).abs() > 0.001) {
      mismatches.add(
          'Valor Nominal (Instancia: ${instAttrs.faceValueNumber} vs Subespecie: ${subAttrs.faceValueNumber})');
    }

    // 4. Instance magnitude currency standardization check (must be ISO code)
    if (instAttrs.currencyName != null) {
      final isoCode = resolveCurrencyIsoCode(instAttrs.currencyName!);
      if (instAttrs.currencyName!.trim().toUpperCase() != isoCode) {
        mismatches.add(
            'Divisa de instancia no es código ISO (Actual: "${instAttrs.currencyName}" vs Código ISO: "$isoCode")');
      }
    }

    // 5. Instance magnitude grade standardization check
    if (instAttrs.grade != null && instAttrs.grade!.isNotEmpty) {
      final stdGrade = resolveGrade(instAttrs.grade!);
      if (instAttrs.grade!.trim() != stdGrade) {
        mismatches.add('Grado de conservación no estandarizado (Actual: "${instAttrs.grade}" vs Estándar: "$stdGrade")');
      }
    }

    // 6. Instance magnitude material standardization check
    if (instAttrs.material != null && instAttrs.material!.isNotEmpty) {
      final stdMat = resolveMaterial(instAttrs.material!);
      if (instAttrs.material!.trim() != stdMat) {
        mismatches.add('Material no estandarizado (Actual: "${instAttrs.material}" vs Estándar: "$stdMat")');
      }
    }

    if (mismatches.isNotEmpty) {
      return 'Incongruencia: ${mismatches.join(" | ")}';
    }

    return null;
  }

  /// Identifies duplicate subspecies under the same species (same canonical title).
  static Map<String, List<Subspecies>> findDuplicateSubspeciesGroups(
      List<Subspecies> subspeciesList) {
    final Map<String, List<Subspecies>> grouped = {};

    for (final sub in subspeciesList) {
      if (sub.subspeciesName.toLowerCase() == 'genérica') continue;

      final parsed = parseSubspeciesName(sub.subspeciesName);
      final normTitle = buildSubspeciesName(
        faceValueNumber: parsed.faceValueNumber,
        currencyName: parsed.currencyName,
        country: parsed.country,
        year: parsed.year,
      );

      final key = '${sub.speciesId}_${normTitle.trim().toLowerCase()}';
      grouped.putIfAbsent(key, () => []).add(sub);
    }

    grouped.removeWhere((key, list) => list.length <= 1);
    return grouped;
  }

  /// Repairs subspecies title, notes, instance magnitudes & attachment file names to strict canonical standards.
  static Future<Subspecies> repairSubspeciesFromInstance({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final instAttrs = extractAttributesFromInstance(instance);
    final subAttrs = parseSubspeciesName(subspecies.subspeciesName);

    final canonicalTitle = buildSubspeciesName(
      faceValueNumber: instAttrs.faceValueNumber ?? subAttrs.faceValueNumber,
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      country: subAttrs.country,
      year: instAttrs.year ?? subAttrs.year,
    );

    final canonicalNotes = buildSubspeciesNotes(
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      year: instAttrs.year ?? subAttrs.year,
      composition: instAttrs.material != null ? resolveMaterial(instAttrs.material!) : null,
    );

    final updatedSub = subspecies.copyWith(
      subspeciesName: canonicalTitle,
      notes: canonicalNotes.isNotEmpty ? canonicalNotes : subspecies.notes,
    );

    await catalogRepo.saveSubspecies(updatedSub);

    // Standardize instance magnitudes ('Divisa', 'Grado', 'Material') if present
    final updatedMags = instance.magnitudes.map((m) {
      if (m.propertyName == 'Divisa' && m.stringValue != null) {
        return m.copyWith(stringValue: resolveCurrencyIsoCode(m.stringValue!));
      }
      if (m.propertyName == 'Grado' && m.stringValue != null) {
        return m.copyWith(stringValue: resolveGrade(m.stringValue!));
      }
      if (m.propertyName == 'Material' && m.stringValue != null) {
        return m.copyWith(stringValue: resolveMaterial(m.stringValue!));
      }
      return m;
    }).toList();

    final updatedInstance = instance.copyWith(magnitudes: updatedMags);
    await entityRepo.saveEntity(updatedInstance);

    // Standardize attachment file names
    await repairAttachmentFileNames(
      catalogRepo: catalogRepo,
      entityRepo: entityRepo,
      subspecies: updatedSub,
      instance: updatedInstance,
    );

    return updatedSub;
  }

  /// Merges duplicate subspecies into a canonical subspecies. Reassigns entities and deletes duplicates.
  static Future<void> mergeDuplicateSubspecies({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies canonicalSubspecies,
    required List<Subspecies> duplicateSubspeciesList,
  }) async {
    final allEntities = await entityRepo.getAllEntities();

    for (final dup in duplicateSubspeciesList) {
      if (dup.id == canonicalSubspecies.id) continue;

      // Reassign entities belonging to dup
      final entitiesToMove = allEntities.where((e) => e.subspeciesId == dup.id);
      for (final entity in entitiesToMove) {
        final updated = entity.copyWith(subspeciesId: canonicalSubspecies.id);
        await entityRepo.saveEntity(updated);
      }

      // Delete duplicate subspecies
      await catalogRepo.deleteSubspecies(dup.id);
    }
  }

  /// Renames attachment files and updates database records to match current canonical subspecies name.
  static Future<void> repairAttachmentFileNames({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final attachments = await entityRepo.getAttachmentsForInstance(instance.id);
    for (final att in attachments) {
      final isObverse = att.fileName.toLowerCase().contains('(anverso)') ||
          att.fileName.toLowerCase().contains('anverso');
      final side = isObverse ? 'anverso' : 'reverso';

      final file = File(att.filePath);
      final ext = file.path.contains('.') ? file.path.split('.').last : 'jpg';

      final expectedName = buildAttachmentFileName(
        subspeciesName: subspecies.subspeciesName,
        instanceId: instance.id,
        side: side,
        extension: ext,
      );

      if (att.fileName != expectedName) {
        // Renombrar archivo en disco si existe
        if (await file.exists()) {
          final parentDir = file.parent.path;
          final newPath = '$parentDir/$expectedName';
          final renamedFile = await file.rename(newPath);

          // Actualizar en base de datos
          final updatedAtt = att.copyWith(
            fileName: expectedName,
            filePath: renamedFile.path,
          );
          await catalogRepo.updateAttachment(updatedAtt);
        } else {
          // Solo actualizar nombre en DB
          final updatedAtt = att.copyWith(fileName: expectedName);
          await catalogRepo.updateAttachment(updatedAtt);
        }
      }
    }
  }
}
