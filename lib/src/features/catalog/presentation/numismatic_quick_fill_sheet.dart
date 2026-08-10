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

  // Centralized lists and currency map from NumismaticDataHelper
  static Map<String, String> get _currencyMap => NumismaticDataHelper.currencyMap;
  static List<String> get _countries => NumismaticDataHelper.countries;
  static List<String> get _denominations => NumismaticDataHelper.denominations;
  static List<String> get _grades => NumismaticDataHelper.grades;
  static List<String> get _coinMaterials => NumismaticDataHelper.coinMaterials;
  static List<String> get _specialEditionReasons => NumismaticDataHelper.specialEditionReasons;

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
