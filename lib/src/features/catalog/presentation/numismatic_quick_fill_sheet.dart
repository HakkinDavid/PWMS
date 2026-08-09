import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/numismatic_recognition_models.dart';

class NumismaticQuickFillSheet extends StatefulWidget {
  final File obversePhoto;
  final File? reversePhoto;
  final bool isCoin;

  const NumismaticQuickFillSheet({
    super.key,
    required this.obversePhoto,
    this.reversePhoto,
    required this.isCoin,
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
  // Preset lists for instant selection with Mexico defaults first
  static const Map<String, String> _currencyMap = {
    'MXN': 'Pesos Mexicanos',
    'MXP': 'Pesos Mexicanos (Antiguos)',
    'EUR': 'Euros',
    'USD': 'Dólares US',
    'ESP': 'Pesetas',
    'GBP': 'Libras Esterlinas',
    'CAD': 'Dólares Canadienses',
    'CLP': 'Pesos Chilenos',
    'ARS': 'Pesos Argentinos',
    'COP': 'Pesos Colombianos',
    'PEN': 'Soles Peruanos',
  };

  static const List<String> _countries = [
    'México',
    'España',
    'Estados Unidos',
    'Unión Europea',
    'Reino Unido',
    'Argentina',
    'Chile',
    'Colombia',
    'Perú',
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

  late String _country;
  late String _currencyCode;
  late String _denomination;
  late String _grade;
  late String _composition;

  // Empty year text field by default
  final TextEditingController _yearController = TextEditingController(text: '');

  // Special Edition Controls
  bool _isSpecialEdition = false;
  String _specialReason = _specialEditionReasons.first;
  final TextEditingController _specialNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _country = 'México';
    _currencyCode = 'MXN';
    _denomination = '5';
    _grade = _grades[2]; // MBC / VF
    _composition = widget.isCoin ? _coinMaterials.first : 'Papel';
  }

  @override
  void dispose() {
    _yearController.dispose();
    _specialNotesController.dispose();
    super.dispose();
  }

  void _submit() {
    final faceVal = double.tryParse(_denomination);
    final currName = _currencyMap[_currencyCode] ?? _currencyCode;
    final yearStr = _yearController.text.trim();
    final speciesType = widget.isCoin ? 'Moneda' : 'Billete';

    final titleParts = <String>['$_denomination $currName', _country];
    if (yearStr.isNotEmpty) titleParts.add('($yearStr)');
    final title = titleParts.join(' - ');

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

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final speciesLabel = widget.isCoin ? 'Moneda (Circular)' : 'Billete (Rectangular)';

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

            // Country Dropdown (Default México)
            DropdownButtonFormField<String>(
              initialValue: _country,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'País / Emisor',
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (val) => setState(() => _country = val!),
            ),
            const SizedBox(height: 12),

            // Denomination & Currency Code Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _denomination,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Denominación',
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _denominations.map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (val) => setState(() => _denomination = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _currencyCode,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Divisa',
                      prefixIcon: const Icon(Icons.monetization_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _currencyMap.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text('${e.key} (${e.value})', overflow: TextOverflow.ellipsis)))
                        .toList(),
                    onChanged: (val) => setState(() => _currencyCode = val!),
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
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: _grade,
                    decoration: InputDecoration(
                      labelText: 'Conservación',
                      prefixIcon: const Icon(Icons.grade),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (val) => setState(() => _grade = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Composition Chips Section (Only shown for Coins, automatically Papel for Banknotes)
            if (widget.isCoin) ...[
              Text(
                'Material / Composición',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _coinMaterials.map((mat) {
                  final isSelected = _composition == mat;
                  return ChoiceChip(
                    label: Text(mat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _composition = mat);
                    },
                  );
                }).toList(),
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
                    onChanged: (val) => setState(() => _isSpecialEdition = val ?? false),
                  ),
                  if (_isSpecialEdition) ...[
                    const Divider(),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: _specialReason,
                      decoration: InputDecoration(
                        labelText: AppStrings.specialEditionReasonLabel,
                        prefixIcon: const Icon(Icons.star),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      items: _specialEditionReasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) => setState(() => _specialReason = val!),
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
