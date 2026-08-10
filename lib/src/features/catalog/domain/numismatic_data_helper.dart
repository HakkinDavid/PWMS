import 'dart:io';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/attachment.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

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

  /// Map of ISO currency codes to full Spanish currency names.
  static const Map<String, String> currencyMap = {
    // 1. México
    'MXN': 'Peso Mexicano',
    'MXP': 'Peso Mexicano Antiguo',
    // 2. Norteamérica
    'USD': 'Dólar Estadounidense',
    'CAD': 'Dólar Canadiense',
    // 3. Centroamérica y Caribe
    'GTQ': 'Quetzal Guatemalteco',
    'BZD': 'Dólar Beliceño',
    'SVC': 'Colón Salvadoreño',
    'HNL': 'Lempira Hondureño',
    'NIO': 'Córdoba Nicaragüense',
    'CRC': 'Colón Costarricense',
    'PAB': 'Balboa Panameño',
    'CUP': 'Peso Cubano',
    'CUC': 'Peso Cubano Convertible',
    'DOP': 'Peso Dominicano',
    'HTG': 'Gourde Haitiano',
    'JMD': 'Dólar Jamaicano',
    'BSD': 'Dólar Bahameño',
    'AWG': 'Florín Arubeño',
    'ANG': 'Florín Antillano Holandés',
    'XCD': 'Dólar del Caribe Oriental',
    'KYD': 'Dólar de las Islas Caimán',
    'BBD': 'Dólar de Barbados',
    'TTD': 'Dólar de Trinidad y Tobago',
    // 4. Sudamérica
    'COP': 'Peso Colombiano',
    'VES': 'Bolívar Soberano Venezolano',
    'VED': 'Bolívar Soberano Digital Venezolano',
    'PEN': 'Sol Peruano',
    'BRL': 'Real Brasileño',
    'BOB': 'Boliviano',
    'CLP': 'Peso Chileno',
    'ARS': 'Peso Argentino',
    'UYU': 'Peso Uruguayo',
    'PYG': 'Guaraní Paraguayo',
    'GYD': 'Dólar Guyanés',
    'SRD': 'Dólar Surinamés',
    'FKP': 'Libra de las Islas Malvinas',
    // 5. Europa
    'ESP': 'Peseta Española (Histórica)',
    'EUR': 'Euro',
    'GBP': 'Libra Esterlina',
    'CHF': 'Franco Suizo',
    'SEK': 'Corona Sueca',
    'NOK': 'Corona Noruega',
    'DKK': 'Corona Danesa',
    'PLN': 'Zloty Polaco',
    'CZK': 'Corona Checa',
    'HUF': 'Forinto Húngaro',
    'RON': 'Leu Rumano',
    'BGN': 'Lev Búlgaro',
    'RSD': 'Dinar Serbio',
    'HRK': 'Kuna Croata',
    'BAM': 'Marco Convertible de Bosnia-Herzegovina',
    'ALL': 'Lek Albanés',
    'MKD': 'Denar Macedonio',
    'RUB': 'Rublo Ruso',
    'UAH': 'Grivna Ucraniana',
    'BYN': 'Rublo Bielorruso',
    'MDL': 'Leu Moldavo',
    'TRY': 'Lira Turca',
    'GIP': 'Libra de Gibraltar',
    'ISK': 'Corona Islandesa',
    // 6. Asia / Medio Oriente / Pacífico
    'JPY': 'Yen Japonés',
    'CNY': 'Yuan Chino',
    'KRW': 'Won Surcoreano',
    'KPW': 'Won Norte-Coreano',
    'TWD': 'Nuevo Dólar Taiwanés',
    'HKD': 'Dólar de Hong Kong',
    'MOP': 'Pataca Macanesa',
    'INR': 'Rupia India',
    'IDR': 'Rupia Indonesia',
    'PHP': 'Peso Filipino',
    'SGD': 'Dólar de Singapur',
    'MYR': 'Ringgit Malayo',
    'THB': 'Baht Tailandés',
    'VND': 'Dong Vietnamita',
    'PKR': 'Rupia Pakistaní',
    'BDT': 'Taka Bangladesí',
    'LKR': 'Rupia de Sri Lanka',
    'NPR': 'Rupia Nepalí',
    'ILS': 'Nuevo Séquel Israelí',
    'AED': 'Dírham de los Emiratos Árabes Unidos',
    'SAR': 'Riyal Saudí',
    'QAR': 'Riyal Catarí',
    'KWD': 'Dinar Kuwaití',
    'BHD': 'Dinar Baréiní',
    'OMR': 'Rial Omaní',
    'JOD': 'Dinar Jordano',
    'LBP': 'Libra Libanesa',
    'SYP': 'Libra Siria',
    'IQD': 'Dinar Iraquí',
    'IRR': 'Rial Iraní',
    'KZT': 'Tenge Kazakh',
    'UZS': 'Som Uzbeko',
    'AFN': 'Afgani Afgano',
    'AMD': 'Dram Armenio',
    'AZN': 'Manat Azerbaiyano',
    'GEL': 'Lari Georgiano',
    'KHR': 'Riel Camboyano',
    'LAK': 'Kip Laosiano',
    'MMK': 'Kyat de Myanmar',
    'MNT': 'Tugrik Mongol',
    'MVR': 'Rufiyaa Maldiva',
    'BTN': 'Ngultrum Butanés',
    'TJS': 'Somoni Tayiko',
    'TMT': 'Manat Turkmenio',
    'YER': 'Rial Yemení',
    // 7. Oceanía
    'AUD': 'Dólar Australiano',
    'NZD': 'Dólar Neozelandés',
    'FJD': 'Dólar Fiyiano',
    'PGK': 'Kina de Papúa Nueva Guinea',
    'SBD': 'Dólar de las Islas Salomón',
    'TOP': 'Paʻanga Tongano',
    'VUV': 'Vatu Vanuatuense',
    'WST': 'Tala Samoano',
    'XPF': 'Franco CFP',
    // 8. África
    'EGP': 'Libra Egipcia',
    'MAD': 'Dírham Marroquí',
    'DZD': 'Dinar Argelino',
    'TND': 'Dinar Tunecino',
    'LYD': 'Dinar Libio',
    'ZAR': 'Rand Sudafricano',
    'NGN': 'Naira Nigeriana',
    'KES': 'Chelín Keniano',
    'ETB': 'Birr Etíope',
    'GHS': 'Cedi Ghanés',
    'XAF': 'Franco CFA de África Central',
    'XOF': 'Franco CFA de África Occidental',
    'AOA': 'Kwanza Angoleño',
    'BWP': 'Pula Botsuano',
    'BIF': 'Franco Burundés',
    'CVE': 'Escudo Caboverdiano',
    'CDF': 'Franco Congoleño',
    'DJF': 'Franco Yibutiano',
    'ERN': 'Nakfa Eritreo',
    'GMD': 'Dalasi Gambiano',
    'GNF': 'Franco Guineano',
    'KMF': 'Franco Comorense',
    'LRD': 'Dólar Liberiano',
    'LSL': 'Loti Lesothense',
    'MGA': 'Ariary Malgache',
    'MWK': 'Kwacha Malauí',
    'MRU': 'Ouguiya Mauritana',
    'MUR': 'Rupia de Mauricio',
    'MZN': 'Metical Mozambanqueño',
    'NAD': 'Dólar Namibio',
    'RWF': 'Franco Ruandés',
    'SHP': 'Libra de Santa Elena',
    'STN': 'Dobra de Santo Tomé y Príncipe',
    'SCR': 'Rupia de Seychelles',
    'SLE': 'Leone de Sierra Leona',
    'SLL': 'Leone Antiguo de Sierra Leona',
    'SOS': 'Chelín Somalí',
    'SDG': 'Libra Sudanesa',
    'SSP': 'Libra Sudsudanesa',
    'SZL': 'Lilangeni Esuatiní',
    'TZS': 'Chelín Tanzano',
    'UGX': 'Chelín Ugandés',
    'ZMW': 'Kwacha Zambiano',
    'ZWL': 'Dólar Zimbabuense',
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

  /// Resolves any currency string (code or full name) to a standardized full name if possible.
  static String resolveCurrencyName(String codeOrName) {
    final clean = codeOrName.trim();
    if (clean.isEmpty) return clean;

    final upperCode = clean.toUpperCase();
    if (currencyMap.containsKey(upperCode)) {
      return currencyMap[upperCode]!;
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
        return entry.value;
      }
    }

    return clean;
  }

  /// Checks if two currency identifiers (codes, full names, or plural forms) are equivalent.
  static bool areCurrenciesEquivalent(String? c1, String? c2) {
    if (c1 == null || c1.trim().isEmpty) return c2 == null || c2.trim().isEmpty;
    if (c2 == null || c2.trim().isEmpty) return false;

    final s1 = c1.trim();
    final s2 = c2.trim();

    if (s1.toLowerCase() == s2.toLowerCase()) return true;

    final r1 = resolveCurrencyName(s1);
    final r2 = resolveCurrencyName(s2);

    if (r1.toLowerCase() == r2.toLowerCase()) return true;

    String getCode(String text) {
      final upper = text.toUpperCase();
      if (currencyMap.containsKey(upper)) return upper;
      final resolved = resolveCurrencyName(text);
      for (final entry in currencyMap.entries) {
        if (entry.value.toLowerCase() == resolved.toLowerCase()) {
          return entry.key;
        }
      }
      return upper;
    }

    return getCode(s1) == getCode(s2);
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
  /// Format: "[Denominación] [Divisa] - [País] ([Año])" or without year if null.
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

    final rawCurr = (currencyName != null && currencyName.trim().isNotEmpty)
        ? currencyName.trim()
        : (currencyCode != null && currencyCode.trim().isNotEmpty
            ? resolveCurrencyName(currencyCode)
            : '');

    final cty = (country != null && country.trim().isNotEmpty)
        ? country.trim()
        : '';

    final yr = (year != null && year.trim().isNotEmpty) ? year.trim() : null;

    final firstPart = [denom, rawCurr].where((s) => s.isNotEmpty).join(' ');
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
            ? resolveCurrencyName(currencyCode)
            : null);

    final notesParts = <String>[];
    if (rawCurr != null && rawCurr.isNotEmpty) {
      notesParts.add('Moneda: ${rawCurr.trim()}');
    }
    if (year != null && year.trim().isNotEmpty) {
      notesParts.add('Año: ${year.trim()}');
    }
    if (composition != null && composition.trim().isNotEmpty) {
      notesParts.add('Material: ${composition.trim()}');
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
      currencyName: currency,
      country: country,
      year: year,
    );
  }

  /// Checks if instance magnitudes are congruent with subspecies title & notes robustly.
  static String? checkInstanceSubspeciesCongruence({
    required Subspecies subspecies,
    required WorldEntity instance,
  }) {
    final instAttrs = extractAttributesFromInstance(instance);
    final subAttrs = parseSubspeciesName(subspecies.subspeciesName);

    final mismatches = <String>[];

    // Check year
    if (instAttrs.year != null &&
        subAttrs.year != null &&
        instAttrs.year != subAttrs.year) {
      mismatches.add('Año (Instancia: ${instAttrs.year} vs Subespecie: ${subAttrs.year})');
    }

    // Check face value
    if (instAttrs.faceValueNumber != null &&
        subAttrs.faceValueNumber != null &&
        (instAttrs.faceValueNumber! - subAttrs.faceValueNumber!).abs() > 0.001) {
      mismatches.add(
          'Valor Nominal (Instancia: ${instAttrs.faceValueNumber} vs Subespecie: ${subAttrs.faceValueNumber})');
    }

    // Check currency using robust equivalence matching
    if (instAttrs.currencyName != null &&
        subAttrs.currencyName != null &&
        !areCurrenciesEquivalent(instAttrs.currencyName, subAttrs.currencyName)) {
      mismatches.add(
          'Divisa (Instancia: ${instAttrs.currencyName} vs Subespecie: ${subAttrs.currencyName})');
    }

    if (mismatches.isNotEmpty) {
      return 'Incongruencia en ${mismatches.join(", ")} entre la subespecie "${subspecies.subspeciesName}" y la instancia.';
    }

    return null;
  }

  /// Identifies duplicate subspecies under the same species (same normalized title).
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

  /// Repairs subspecies title & notes from instance magnitudes deterministically.
  static Future<Subspecies> repairSubspeciesFromInstance({
    required CatalogRepository catalogRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final instAttrs = extractAttributesFromInstance(instance);
    final subAttrs = parseSubspeciesName(subspecies.subspeciesName);

    final newTitle = buildSubspeciesName(
      faceValueNumber: instAttrs.faceValueNumber ?? subAttrs.faceValueNumber,
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      country: subAttrs.country,
      year: instAttrs.year ?? subAttrs.year,
    );

    final newNotes = buildSubspeciesNotes(
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      year: instAttrs.year ?? subAttrs.year,
      composition: instAttrs.material,
    );

    final updated = subspecies.copyWith(
      subspeciesName: newTitle,
      notes: newNotes.isNotEmpty ? newNotes : subspecies.notes,
    );

    await catalogRepo.saveSubspecies(updated);
    return updated;
  }

  /// Merges duplicate subspecies into a canonical subspecies. Reassigns entities and deletes duplicates.
  static Future<void> mergeDuplicateSubspecies({
    required CatalogRepository catalogRepo,
    required EntityRepository entityRepo,
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

  /// Renames attachment files and updates database records to match current subspecies name.
  static Future<void> repairAttachmentFileNames({
    required CatalogRepository catalogRepo,
    required EntityRepository entityRepo,
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
