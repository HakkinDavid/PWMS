import 'dart:io';
import 'package:flutter/material.dart';
import '../domain/numismatic_recognition_models.dart';

class NumismaticQuickFillSheet extends StatefulWidget {
  final File obversePhoto;
  final File? reversePhoto;

  const NumismaticQuickFillSheet({
    super.key,
    required this.obversePhoto,
    this.reversePhoto,
  });

  static Future<NumismaticScanResult?> show(
    BuildContext context, {
    required File obversePhoto,
    File? reversePhoto,
  }) {
    return showModalBottomSheet<NumismaticScanResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: NumismaticQuickFillSheet(
          obversePhoto: obversePhoto,
          reversePhoto: reversePhoto,
        ),
      ),
    );
  }

  @override
  State<NumismaticQuickFillSheet> createState() => _NumismaticQuickFillSheetState();
}

class _NumismaticQuickFillSheetState extends State<NumismaticQuickFillSheet> {
  String _speciesType = 'Moneda';

  // Preset lists for instant selection
  static const Map<String, String> _currencyMap = {
    'ESP': 'Pesetas',
    'EUR': 'Euros',
    'MXN': 'Pesos Mexicanos',
    'USD': 'Dólares US',
    'GBP': 'Libras Esterlinas',
    'CAD': 'Dólares Canadienses',
    'CLP': 'Pesos Chilenos',
    'ARS': 'Pesos Argentinos',
    'COP': 'Pesos Colombianos',
    'PEN': 'Soles Peruanos',
  };

  static const List<String> _countries = [
    'España',
    'México',
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

  static const List<String> _banknoteMaterials = [
    'Papel',
  ];

  late String _country;
  late String _currencyCode;
  late String _denomination;
  late String _grade;
  late String _composition;
  final TextEditingController _yearController = TextEditingController(text: '1982');

  @override
  void initState() {
    super.initState();
    _country = _countries.first;
    _currencyCode = _currencyMap.keys.first;
    _denomination = '5';
    _grade = _grades[2]; // MBC / VF
    _composition = _coinMaterials.first;
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  void _submit() {
    final faceVal = double.tryParse(_denomination);
    final currName = _currencyMap[_currencyCode] ?? _currencyCode;
    final yearStr = _yearController.text.trim();
    final title = '$_denomination $currName - $_country ($yearStr)';

    final result = NumismaticScanResult(
      speciesType: _speciesType,
      generalSpeciesName: _speciesType,
      subspeciesName: title,
      country: _country,
      year: yearStr.isNotEmpty ? yearStr : null,
      faceValueNumber: faceVal,
      currencyCode: _currencyCode,
      currencyName: currName,
      composition: _composition,
      grade: _grade,
      obversePhotoPath: widget.obversePhoto.path,
      reversePhotoPath: widget.reversePhoto?.path,
      sourceEngine: 'Formulario Rápido In-App',
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final materials = _speciesType == 'Moneda' ? _coinMaterials : _banknoteMaterials;

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

            // Header Title
            Row(
              children: [
                Icon(Icons.flash_on, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Datos Numismáticos Rápidos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Species Type Segmented Control
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Moneda', label: Text('Moneda'), icon: Icon(Icons.circle_outlined)),
                ButtonSegment(value: 'Billete', label: Text('Billete'), icon: Icon(Icons.crop_landscape)),
              ],
              selected: {_speciesType},
              onSelectionChanged: (val) {
                setState(() {
                  _speciesType = val.first;
                  _composition = (_speciesType == 'Moneda' ? _coinMaterials : _banknoteMaterials).first;
                });
              },
            ),
            const SizedBox(height: 16),

            // Country Dropdown
            DropdownButtonFormField<String>(
              initialValue: _country,
              decoration: InputDecoration(
                labelText: 'País / Emisor',
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _country = val!),
            ),
            const SizedBox(height: 12),

            // Denomination & Currency Code Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _denomination,
                    decoration: InputDecoration(
                      labelText: 'Denominación',
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _denominations.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (val) => setState(() => _denomination = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _currencyCode,
                    decoration: InputDecoration(
                      labelText: 'Divisa',
                      prefixIcon: const Icon(Icons.monetization_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _currencyMap.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text('${e.key} (${e.value})')))
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
                      labelText: 'Año',
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

            // Composition Chips Section
            Text(
              'Material / Composición',
              style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: materials.map((mat) {
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

            const SizedBox(height: 20),

            // Submit Action Button
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Confirmar y Registrar Pieza', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
