import 'dart:io';
import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../domain/numismatic_recognition_models.dart';

class NumismaticQuickFillSheet extends StatefulWidget {
  final File obversePhoto;
  final File? reversePhoto;
  final bool isCoin;
  final Function(NumismaticScanResult? result)? onResultSubmitted;

  const NumismaticQuickFillSheet({
    super.key,
    required this.obversePhoto,
    this.reversePhoto,
    required this.isCoin,
    this.onResultSubmitted,
  });

  static Future<NumismaticScanResult?> show(
    BuildContext context, {
    required File obversePhoto,
    File? reversePhoto,
    required bool isCoin,
  }) {
    return showModalBottomSheet<NumismaticScanResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final bottomPadding = mediaQuery.viewInsets.bottom > 0
            ? mediaQuery.viewInsets.bottom
            : mediaQuery.padding.bottom + 16;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: NumismaticQuickFillSheet(
            obversePhoto: obversePhoto,
            reversePhoto: reversePhoto,
            isCoin: isCoin,
          ),
        );
      },
    );
  }

  @override
  State<NumismaticQuickFillSheet> createState() => _NumismaticQuickFillSheetState();
}

class _NumismaticQuickFillSheetState extends State<NumismaticQuickFillSheet> {
  // ISO 4217 Registered Currencies & Key Numismatic Currencies
  static const Map<String, String> _currencyMap = {
    'AED': 'Dírham de los Emiratos Árabes Unidos',
    'AFN': 'Afgani Afgano',
    'ALL': 'Lek Albanés',
    'AMD': 'Dram Armenio',
    'ANG': 'Florín Antillano Holandés',
    'AOA': 'Kwanza Angoleño',
    'ARS': 'Peso Argentino',
    'AUD': 'Dólar Australiano',
    'AWG': 'Florín Arubeño',
    'AZN': 'Manat Azerbaiyano',
    'BAM': 'Marco Convertible de Bosnia-Herzegovina',
    'BBD': 'Dólar de Barbados',
    'BDT': 'Taka Bangladesí',
    'BGN': 'Lev Búlgaro',
    'BHD': 'Dinar Baréiní',
    'BIF': 'Franco Burundés',
    'BMD': 'Dólar de Bermudas',
    'BND': 'Dólar de Brunéi',
    'BOB': 'Boliviano',
    'BRL': 'Real Brasileño',
    'BSD': 'Dólar Bahameño',
    'BTN': 'Ngultrum Butanés',
    'BWP': 'Pula Botsuano',
    'BYN': 'Rublo Bielorruso',
    'BZD': 'Dólar Beliceño',
    'CAD': 'Dólar Canadiense',
    'CDF': 'Franco Congoleño',
    'CHF': 'Franco Suizo',
    'CLP': 'Peso Chileno',
    'CNY': 'Yuan Chino',
    'COP': 'Peso Colombiano',
    'CRC': 'Colón Costarricense',
    'CUC': 'Peso Cubano Convertible',
    'CUP': 'Peso Cubano',
    'CVE': 'Escudo Caboverdiano',
    'CZK': 'Corona Checa',
    'DJF': 'Franco Yibutiano',
    'DKK': 'Corona Danesa',
    'DOP': 'Peso Dominicano',
    'DZD': 'Dinar Argelino',
    'EGP': 'Libra Egipcia',
    'ERN': 'Nakfa Eritreo',
    'ESP': 'Peseta Española (Histórica)',
    'ETB': 'Birr Etíope',
    'EUR': 'Euro',
    'FJD': 'Dólar Fiyiano',
    'FKP': 'Libra de las Islas Malvinas',
    'GBP': 'Libra Esterlina',
    'GEL': 'Lari Georgiano',
    'GHS': 'Cedi Ghanés',
    'GIP': 'Libra de Gibraltar',
    'GMD': 'Dalasi Gambiano',
    'GNF': 'Franco Guineano',
    'GTQ': 'Quetzal Guatemalteco',
    'GYD': 'Dólar Guyanés',
    'HKD': 'Dólar de Hong Kong',
    'HNL': 'Lempira Hondureño',
    'HRK': 'Kuna Croata',
    'HTG': 'Gourde Haitiano',
    'HUF': 'Forinto Húngaro',
    'IDR': 'Rupia Indonesia',
    'ILS': 'Nuevo Séquel Israelí',
    'INR': 'Rupia India',
    'IQD': 'Dinar Iraquí',
    'IRR': 'Rial Iraní',
    'ISK': 'Corona Islandesa',
    'JMD': 'Dólar Jamaicano',
    'JOD': 'Dinar Jordano',
    'JPY': 'Yen Japonés',
    'KES': 'Chelín Keniano',
    'KGS': 'Som Kirguís',
    'KHR': 'Riel Camboyano',
    'KMF': 'Franco Comorense',
    'KPW': 'Won Norte-Coreano',
    'KRW': 'Won Surcoreano',
    'KWD': 'Dinar Kuwaití',
    'KYD': 'Dólar de las Islas Caimán',
    'KZT': 'Tenge Kazakh',
    'LAK': 'Kip Laosiano',
    'LBP': 'Libra Libanesa',
    'LKR': 'Rupia de Sri Lanka',
    'LRD': 'Dólar Liberiano',
    'LSL': 'Loti Lesothense',
    'LYD': 'Dinar Libio',
    'MAD': 'Dírham Marroquí',
    'MDL': 'Leu Moldavo',
    'MGA': 'Ariary Malgache',
    'MKD': 'Denar Macedonio',
    'MMK': 'Kyat de Myanmar',
    'MNT': 'Tugrik Mongol',
    'MOP': 'Pataca Macanesa',
    'MRU': 'Ouguiya Mauritana',
    'MUR': 'Rupia de Mauricio',
    'MVR': 'Rufiyaa Maldiva',
    'MWK': 'Kwacha Malauí',
    'MXN': 'Peso Mexicano',
    'MXP': 'Peso Mexicano (Antiguo - Histórico)',
    'MYR': 'Ringgit Malayo',
    'MZN': 'Metical Mozambanqueño',
    'NAD': 'Dólar Namibio',
    'NGN': 'Naira Nigeriana',
    'NIO': 'Córdoba Nicaragüense',
    'NOK': 'Corona Noruega',
    'NPR': 'Rupia Nepalí',
    'NZD': 'Dólar Neozelandés',
    'OMR': 'Rial Omaní',
    'PAB': 'Balboa Panameño',
    'PEN': 'Sol Peruano',
    'PGK': 'Kina de Papúa Nueva Guinea',
    'PHP': 'Peso Filipino',
    'PKR': 'Rupia Pakistaní',
    'PLN': 'Zloty Polaco',
    'PYG': 'Guaraní Paraguayo',
    'QAR': 'Riyal Catarí',
    'RON': 'Leu Rumano',
    'RSD': 'Dinar Serbio',
    'RUB': 'Rublo Ruso',
    'RWF': 'Franco Ruandés',
    'SAR': 'Riyal Saudí',
    'SBD': 'Dólar de las Islas Salomón',
    'SCR': 'Rupia de Seychelles',
    'SDG': 'Libra Sudanesa',
    'SEK': 'Corona Sueca',
    'SGD': 'Dólar de Singapur',
    'SHP': 'Libra de Santa Elena',
    'SLE': 'Leone de Sierra Leona',
    'SLL': 'Leone Antiguo de Sierra Leona',
    'SOS': 'Chelín Somalí',
    'SRD': 'Dólar Surinamés',
    'SSP': 'Libra Sudsudanesa',
    'STN': 'Dobra de Santo Tomé y Príncipe',
    'SVC': 'Colón Salvadoreño',
    'SYP': 'Libra Siria',
    'SZL': 'Lilangeni Esuatiní',
    'THB': 'Baht Tailandés',
    'TJS': 'Somoni Tayiko',
    'TMT': 'Manat Turkmenio',
    'TND': 'Dinar Tunecino',
    'TOP': 'Paʻanga Tongano',
    'TRY': 'Lira Turca',
    'TTD': 'Dólar de Trinidad y Tobago',
    'TWD': 'Nuevo Dólar Taiwanés',
    'TZS': 'Chelín Tanzano',
    'UAH': 'Grivna Ucraniana',
    'UGX': 'Chelín Ugandés',
    'USD': 'Dólar Estadounidense',
    'UYU': 'Peso Uruguayo',
    'UZS': 'Som Uzbeko',
    'VED': 'Bolívar Soberano Digital Venezolano',
    'VES': 'Bolívar Soberano Venezolano',
    'VND': 'Dong Vietnamita',
    'VUV': 'Vatu Vanuatuense',
    'WST': 'Tala Samoano',
    'XAF': 'Franco CFA de África Central',
    'XCD': 'Dólar del Caribe Oriental',
    'XOF': 'Franco CFA de África Occidental',
    'XPF': 'Franco CFP',
    'YER': 'Rial Yemení',
    'ZAR': 'Rand Sudafricano',
    'ZMW': 'Kwacha Zambiano',
    'ZWL': 'Dólar Zimbabuense',
  };

  // World Countries and Numismatic Issuers
  static const List<String> _countries = [
    'Afganistán', 'Albania', 'Alemania', 'Andorra', 'Angola', 'Antigua y Barbuda', 'Arabia Saudita',
    'Argelia', 'Argentina', 'Armenia', 'Aruba', 'Australia', 'Austria', 'Azerbaiyán', 'Bahamas',
    'Bangladés', 'Barbados', 'Baréin', 'Bélgica', 'Belice', 'Benín', 'Bermudas', 'Bielorrusia',
    'Birmania (Myanmar)', 'Bolivia', 'Bosnia y Herzegovina', 'Botsuana', 'Brasil', 'Brunéi',
    'Bulgaria', 'Burkina Faso', 'Burundi', 'Bután', 'Cabo Verde', 'Camboya', 'Camerún', 'Canadá',
    'Catar', 'Chad', 'Chile', 'China', 'Chipre', 'Ciudad del Vaticano', 'Colombia', 'Comoras',
    'Corea del Norte', 'Corea del Sur', 'Costa de Marfil', 'Costa Rica', 'Croacia', 'Cuba',
    'Curazao', 'Dinamarca', 'Dominica', 'Ecuador', 'Egipto', 'El Salvador', 'Emiratos Árabes Unidos',
    'Eritrea', 'Eslovaquia', 'Eslovenia', 'España', 'Estados Unidos', 'Estonia', 'Esuatini (Suazilandia)',
    'Etiopía', 'Filipinas', 'Finlandia', 'Fiyi', 'Francia', 'Gabón', 'Gambia', 'Georgia', 'Ghana',
    'Gibraltar', 'Granada', 'Grecia', 'Groenlandia', 'Guatemala', 'Guinea', 'Guinea Ecuatorial',
    'Guinea-Bisáu', 'Guyana', 'Haití', 'Honduras', 'Hong Kong', 'Hungría', 'India', 'Indonesia',
    'Irak', 'Irán', 'Irlanda', 'Islandia', 'Islas Caimán', 'Islas Cook', 'Islas Feroe', 'Islas Malvinas',
    'Islas Marshall', 'Islas Salomón', 'Israel', 'Italia', 'Jamaica', 'Japón', 'Jordania', 'Kazajistán',
    'Kenia', 'Kirguistán', 'Kiribati', 'Kuwait', 'Laos', 'Lesoto', 'Letonia', 'Líbano', 'Liberia',
    'Libia', 'Liechtenstein', 'Lituania', 'Luxemburgo', 'Macao', 'Macedonia del Norte', 'Madagascar',
    'Malasia', 'Malaui', 'Maldivas', 'Malí', 'Malta', 'Marruecos', 'Mauricio', 'Mauritania', 'México',
    'Micronesia', 'Moldavia', 'Mónaco', 'Mongolia', 'Montenegro', 'Mozambique', 'Namibia', 'Nauru',
    'Nepal', 'Nicaragua', 'Níger', 'Nigeria', 'Noruega', 'Nueva Caledonia', 'Nueva Zelanda', 'Omán',
    'Países Bajos', 'Pakistán', 'Palaos', 'Palestina', 'Panamá', 'Papúa Nueva Guinea', 'Paraguay',
    'Perú', 'Polinesia Francesa', 'Polonia', 'Portugal', 'Puerto Rico', 'Reino Unido',
    'República Centroafricana', 'República Checa', 'República del Congo', 'República Democrática del Congo',
    'República Dominicana', 'Ruanda', 'Rumanía', 'Rusia', 'Samoa', 'San Cristóbal y Nieves',
    'San Marino', 'San Vicente y las Granadinas', 'Santa Lucía', 'Santo Tomé y Príncipe', 'Senegal',
    'Serbia', 'Seychelles', 'Sierra Leona', 'Singapur', 'Siria', 'Somalia', 'Sri Lanka', 'Sudáfrica',
    'Sudán', 'Sudán del Sur', 'Suecia', 'Suiza', 'Surinam', 'Tailandia', 'Taiwán', 'Tanzania',
    'Tayikistán', 'Timor Oriental', 'Togo', 'Tonga', 'Trinidad y Tobago', 'Túnez', 'Turkmenistán',
    'Turquía', 'Tuvalu', 'Ucrania', 'Uganda', 'Unión Europea', 'Uruguay', 'Uzbekistán', 'Vanuatu',
    'Venezuela', 'Vietnam', 'Yemen', 'Yibuti', 'Zambia', 'Zimbabue', 'Otro',
  ];

  static const List<String> _denominations = [
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

  static const List<String> _grades = [
    'FDC / UNC (Sin Circular)',
    'EBC / XF (Excelente)',
    'MBC / VF (Muy Buena)',
    'BC / F (Buena)',
    'MC / G (Regular)',
  ];

  static const List<String> _coinMaterials = [
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

  static const List<String> _specialEditionReasons = [
    'Conmemorativa',
    'Prueba de acuñación (Proof)',
    'Error de acuñación / Impresión',
    'Serie limitada / Numeración especial',
    'Aniversario / Evento histórico',
    'Emisión de cambio de régimen',
    'Otro (especificar)',
  ];

  // Default values set to empty / unselected (null)
  String? _country;
  String? _currencyCode;
  String? _denomination;
  String? _grade;
  String? _composition;

  // Empty year text field by default
  final TextEditingController _yearController = TextEditingController(text: '');

  // Special Edition Controls
  bool _isSpecialEdition = false;
  String? _specialReason;
  final TextEditingController _specialNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _country = null;
    _currencyCode = null;
    _denomination = null;
    _grade = null;
    _composition = null;
    _specialReason = null;
  }

  @override
  void dispose() {
    _yearController.dispose();
    _specialNotesController.dispose();
    super.dispose();
  }

  void _submit() {
    final faceVal = _denomination != null ? double.tryParse(_denomination!) : null;
    final currName = _currencyCode != null ? (_currencyMap[_currencyCode!] ?? _currencyCode) : null;
    final yearStr = _yearController.text.trim();
    final speciesType = widget.isCoin ? 'Moneda' : 'Billete';

    final titleParts = <String>[];
    if (_denomination != null && _denomination!.isNotEmpty) {
      if (currName != null && currName.isNotEmpty) {
        titleParts.add('$_denomination $currName');
      } else {
        titleParts.add(_denomination!);
      }
    } else if (currName != null && currName.isNotEmpty) {
      titleParts.add(currName!);
    }

    if (_country != null && _country!.isNotEmpty) {
      titleParts.add(_country!);
    }
    if (yearStr.isNotEmpty) {
      titleParts.add('($yearStr)');
    }

    final title = titleParts.isNotEmpty ? titleParts.join(' - ') : speciesType;

    final result = NumismaticScanResult(
      speciesType: speciesType,
      generalSpeciesName: speciesType,
      subspeciesName: title,
      country: _country,
      year: yearStr.isNotEmpty ? yearStr : null,
      faceValueNumber: faceVal,
      currencyCode: _currencyCode,
      currencyName: currName,
      composition: _composition,
      grade: _grade,
      isSpecialEdition: _isSpecialEdition,
      specialEditionReason: _isSpecialEdition ? _specialReason : null,
      specialEditionNotes: (_isSpecialEdition && _specialReason == 'Otro (especificar)')
          ? _specialNotesController.text.trim()
          : null,
      obversePhotoPath: widget.obversePhoto.path,
      reversePhotoPath: widget.reversePhoto?.path,
      sourceEngine: 'Formulario Rápido In-App',
    );

    if (widget.onResultSubmitted != null) {
      widget.onResultSubmitted!(result);
    } else {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final speciesLabel = widget.isCoin ? 'Moneda (Circular)' : 'Billete (Rectangular)';
    final unselectedStyle = TextStyle(color: theme.disabledColor, fontStyle: FontStyle.italic);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header Title & Fixed Species Indicator
            Row(
              children: [
                Icon(widget.isCoin ? Icons.circle_outlined : Icons.crop_landscape, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Datos Numismáticos - $speciesLabel',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Country Dropdown (Default null / Sin selección)
            DropdownButtonFormField<String?>(
              value: _country,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'País / Emisor',
                hintText: 'Sin selección',
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Sin selección', style: unselectedStyle),
                ),
                ..._countries.map((c) => DropdownMenuItem<String?>(
                  value: c,
                  child: Text(c, overflow: TextOverflow.ellipsis),
                )),
              ],
              onChanged: (val) => setState(() => _country = val),
            ),
            const SizedBox(height: 12),

            // Denomination & Currency Code Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _denomination,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Denominación',
                      hintText: 'Sin selección',
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Sin selección', style: unselectedStyle),
                      ),
                      ..._denominations.map((d) => DropdownMenuItem<String?>(
                        value: d,
                        child: Text(d, overflow: TextOverflow.ellipsis),
                      )),
                    ],
                    onChanged: (val) => setState(() => _denomination = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _currencyCode,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Divisa',
                      hintText: 'Sin selección',
                      prefixIcon: const Icon(Icons.monetization_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Sin selección', style: unselectedStyle),
                      ),
                      ..._currencyMap.entries.map((e) => DropdownMenuItem<String?>(
                        value: e.key,
                        child: Text('${e.key} (${e.value})', overflow: TextOverflow.ellipsis),
                      )),
                    ],
                    onChanged: (val) => setState(() => _currencyCode = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Year & Grade Row
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Año (opcional)',
                      hintText: 'Ej: 1982',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String?>(
                    value: _grade,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Conservación',
                      hintText: 'Sin selección',
                      prefixIcon: const Icon(Icons.grade),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Sin selección', style: unselectedStyle),
                      ),
                      ..._grades.map((g) => DropdownMenuItem<String?>(
                        value: g,
                        child: Text(g, overflow: TextOverflow.ellipsis),
                      )),
                    ],
                    onChanged: (val) => setState(() => _grade = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Composition Chips Section (Only shown for Coins)
            if (widget.isCoin) ...[
              DropdownButtonFormField<String?>(
                value: _composition,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Material / Composición',
                  hintText: 'Sin selección',
                  prefixIcon: const Icon(Icons.token),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Sin selección', style: unselectedStyle),
                  ),
                  ..._coinMaterials.map((mat) => DropdownMenuItem<String?>(
                    value: mat,
                    child: Text(mat, overflow: TextOverflow.ellipsis),
                  )),
                ],
                onChanged: (val) => setState(() => _composition = val),
              ),
              const SizedBox(height: 12),
            ],

            // Special Edition Checkbox Section
            Container(
              decoration: BoxDecoration(
                color: _isSpecialEdition ? theme.colorScheme.primaryContainer.withAlpha(50) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isSpecialEdition ? theme.colorScheme.primary : Colors.grey.shade300,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text(AppStrings.specialEditionTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text(AppStrings.specialEditionCheckSubtitle),
                    value: _isSpecialEdition,
                    activeColor: theme.colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() {
                      _isSpecialEdition = val ?? false;
                      if (!_isSpecialEdition) _specialReason = null;
                    }),
                  ),
                  if (_isSpecialEdition) ...[
                    const Divider(),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String?>(
                      value: _specialReason,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: AppStrings.specialEditionReasonLabel,
                        hintText: 'Sin selección',
                        prefixIcon: const Icon(Icons.star),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Sin selección', style: unselectedStyle),
                        ),
                        ..._specialEditionReasons.map((r) => DropdownMenuItem<String?>(
                          value: r,
                          child: Text(r, overflow: TextOverflow.ellipsis),
                        )),
                      ],
                      onChanged: (val) => setState(() => _specialReason = val),
                    ),
                    if (_specialReason == 'Otro (especificar)') ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _specialNotesController,
                        decoration: InputDecoration(
                          labelText: AppStrings.specialEditionNotesLabel,
                          prefixIcon: const Icon(Icons.edit_note),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Submit Action Button
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(AppStrings.confirmAndRegisterPieceAction, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
