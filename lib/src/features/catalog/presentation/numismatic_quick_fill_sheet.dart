import 'dart:io';
import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../domain/numismatic_recognition_models.dart';
import '../domain/numismatic_data_helper.dart';

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
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  // Currencies ordered by geographic, economic & historic proximity to Mexico
  static const Map<String, String> _currencyMap = {
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

  // Countries ordered by geographic, economic & cultural proximity to Mexico
  static const List<String> _countries = [
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
    setState(() {
      _autoValidate = true;
    });

    // Impide que se guarde si algún dato requerido está nulo o vacío
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos antes de guardar.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final faceVal = double.tryParse(_denomination!);
    final currName = _currencyMap[_currencyCode!] ?? _currencyCode;
    final yearStr = _yearController.text.trim();
    final speciesType = widget.isCoin ? 'Moneda' : 'Billete';

    final title = NumismaticDataHelper.buildSubspeciesName(
      faceValueStr: _denomination,
      currencyName: currName,
      country: _country,
      year: yearStr.isNotEmpty ? yearStr : null,
    );

    final result = NumismaticScanResult(
      speciesType: speciesType,
      generalSpeciesName: speciesType,
      subspeciesName: title,
      country: _country,
      year: yearStr.isNotEmpty ? yearStr : null,
      faceValueNumber: faceVal,
      currencyCode: _currencyCode,
      currencyName: currName,
      composition: widget.isCoin ? _composition : 'Papel',
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
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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

              // 1. País / Emisor Dropdown (1 campo por fila)
              DropdownButtonFormField<String?>(
                value: _country,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'País / Emisor',
                  hintText: 'Sin selección',
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) => val == null ? 'Selecciona un país o emisor' : null,
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
              const SizedBox(height: 14),

              // 2. Denominación Dropdown (1 campo por fila)
              DropdownButtonFormField<String?>(
                value: _denomination,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Denominación',
                  hintText: 'Sin selección',
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) => val == null ? 'Selecciona una denominación' : null,
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
              const SizedBox(height: 14),

              // 3. Divisa Dropdown (1 campo por fila)
              DropdownButtonFormField<String?>(
                value: _currencyCode,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Divisa',
                  hintText: 'Sin selección',
                  prefixIcon: const Icon(Icons.monetization_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) => val == null ? 'Selecciona una divisa' : null,
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
              const SizedBox(height: 14),

              // 4. Año TextField (1 campo por fila)
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Año de emisión',
                  hintText: 'Ej: 1982',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Ingresa el año de emisión';
                  }
                  final yearNum = int.tryParse(val.trim());
                  if (yearNum == null || yearNum < 500 || yearNum > 2100) {
                    return 'Ingresa un año válido (ej. 1982)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 5. Conservación Dropdown (1 campo por fila)
              DropdownButtonFormField<String?>(
                value: _grade,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Conservación',
                  hintText: 'Sin selección',
                  prefixIcon: const Icon(Icons.grade),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) => val == null ? 'Selecciona el estado de conservación' : null,
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
              const SizedBox(height: 14),

              // 6. Material / Composición Dropdown (1 campo por fila, sólo para monedas)
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
                  validator: (val) => val == null ? 'Selecciona el material o composición' : null,
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
                const SizedBox(height: 14),
              ],

              // 7. Edición Especial (Sección con checkbox y razón opcional)
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
                        validator: (val) {
                          if (_isSpecialEdition && val == null) {
                            return 'Selecciona la razón de edición especial';
                          }
                          return null;
                        },
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
                        TextFormField(
                          controller: _specialNotesController,
                          decoration: InputDecoration(
                            labelText: AppStrings.specialEditionNotesLabel,
                            prefixIcon: const Icon(Icons.edit_note),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          validator: (val) {
                            if (_isSpecialEdition && _specialReason == 'Otro (especificar)' && (val == null || val.trim().isEmpty)) {
                              return 'Especifica el motivo de la edición especial';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botón de Confirmación y Registro
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
      ),
    );
  }
}
