import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/storage/app_settings_repository.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../domain/numismatic_recognition_models.dart';
import '../domain/numismatic_data_helper.dart';

class NumismaticQuickFillSheet extends ConsumerStatefulWidget {
  final File obversePhoto;
  final File? reversePhoto;
  final bool isCoin;
  final String? initialLocationId;
  final String? initialContainerEntityId;
  final Function(NumismaticScanResult? result)? onResultSubmitted;

  const NumismaticQuickFillSheet({
    super.key,
    required this.obversePhoto,
    this.reversePhoto,
    required this.isCoin,
    this.initialLocationId,
    this.initialContainerEntityId,
    this.onResultSubmitted,
  });

  static Future<NumismaticScanResult?> show(
    BuildContext context, {
    required File obversePhoto,
    File? reversePhoto,
    required bool isCoin,
    String? initialLocationId,
    String? initialContainerEntityId,
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
            initialLocationId: initialLocationId,
            initialContainerEntityId: initialContainerEntityId,
          ),
        );
      },
    );
  }

  @override
  ConsumerState<NumismaticQuickFillSheet> createState() => _NumismaticQuickFillSheetState();
}

class _NumismaticQuickFillSheetState extends ConsumerState<NumismaticQuickFillSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  // Centralized lists and currency map from NumismaticDataHelper
  static Map<String, String> get _currencyMap => NumismaticDataHelper.currencyMap;
  static List<String> get _countries => NumismaticDataHelper.countries;
  static List<String> get _denominations => NumismaticDataHelper.denominations;
  static List<String> get _grades => NumismaticDataHelper.grades;
  static List<String> get _coinMaterials => NumismaticDataHelper.coinMaterials;
  static List<String> get _specialEditionReasons => NumismaticDataHelper.specialEditionReasons;

  // Static memory cache for auto-fill in active session
  static InstantiationLocationMode? _lastUsedLocationMode;
  static String? _lastUsedLocationId;
  static String? _lastUsedContainerEntityId;

  // Location / Container selection
  InstantiationLocationMode _locationMode = InstantiationLocationMode.physicalNode;
  String? _selectedLocationId;
  String? _selectedContainerEntityId;

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
    if (widget.initialContainerEntityId != null) {
      _locationMode = InstantiationLocationMode.containerEntity;
      _selectedContainerEntityId = widget.initialContainerEntityId;
    } else if (widget.initialLocationId != null) {
      _locationMode = InstantiationLocationMode.physicalNode;
      _selectedLocationId = widget.initialLocationId;
    } else if (_lastUsedLocationMode != null) {
      _locationMode = _lastUsedLocationMode!;
      _selectedLocationId = _lastUsedLocationId;
      _selectedContainerEntityId = _lastUsedContainerEntityId;
    } else {
      _loadLastUsedLocation();
    }
    _country = null;
    _currencyCode = null;
    _denomination = null;
    _grade = null;
    _composition = null;
    _specialReason = null;
  }

  Future<void> _loadLastUsedLocation() async {
    try {
      final settingsRepo = ref.read(appSettingsRepositoryProvider);
      final savedModeStr = await settingsRepo.getLastNumismaticLocationMode();
      final savedLocId = await settingsRepo.getLastNumismaticLocationId();
      final savedContainerId = await settingsRepo.getLastNumismaticContainerEntityId();

      if (mounted) {
        setState(() {
          if (savedModeStr != null) {
            _locationMode = savedModeStr == InstantiationLocationMode.containerEntity.name
                ? InstantiationLocationMode.containerEntity
                : InstantiationLocationMode.physicalNode;
            _lastUsedLocationMode = _locationMode;
          }
          if (savedLocId != null && savedLocId.isNotEmpty) {
            _selectedLocationId = savedLocId;
            _lastUsedLocationId = savedLocId;
          }
          if (savedContainerId != null && savedContainerId.isNotEmpty) {
            _selectedContainerEntityId = savedContainerId;
            _lastUsedContainerEntityId = savedContainerId;
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _yearController.dispose();
    _specialNotesController.dispose();
    super.dispose();
  }

  Future<void> _pickLocationFromTree() async {
    final result = await LocationTreePicker.show(context, initialSelectedId: _selectedLocationId);
    if (result != null) {
      setState(() {
        _selectedLocationId = result.locationId;
      });
    }
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

    if (_locationMode == InstantiationLocationMode.containerEntity &&
        (_selectedContainerEntityId == null || _selectedContainerEntityId!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.selectValidContainerPrompt),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Save as last used in memory and persistent storage
    _lastUsedLocationMode = _locationMode;
    _lastUsedLocationId = _selectedLocationId;
    _lastUsedContainerEntityId = _selectedContainerEntityId;

    try {
      final settingsRepo = ref.read(appSettingsRepositoryProvider);
      settingsRepo.setLastNumismaticLocationMode(_locationMode.name);
      if (_selectedLocationId != null) {
        settingsRepo.setLastNumismaticLocationId(_selectedLocationId!);
      }
      if (_selectedContainerEntityId != null) {
        settingsRepo.setLastNumismaticContainerEntityId(_selectedContainerEntityId!);
      }
    } catch (_) {}

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
      locationId: _locationMode == InstantiationLocationMode.physicalNode ? _selectedLocationId : null,
      containerEntityId: _locationMode == InstantiationLocationMode.containerEntity ? _selectedContainerEntityId : null,
      isContainer: _locationMode == InstantiationLocationMode.containerEntity,
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

    final locationsState = ref.watch(locationNodeListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final subspeciesState = ref.watch(subspeciesListProvider);

    final catalogItems = catalogState.asData?.value ?? [];
    final entities = entitiesState.asData?.value ?? [];
    final subspeciesList = subspeciesState.asData?.value ?? [];

    String locationDisplayName = AppStrings.rootLocationName;
    if (_selectedLocationId != null) {
      locationsState.whenData((nodes) {
        final found = nodes.where((n) => n.id == _selectedLocationId).firstOrNull;
        if (found != null) locationDisplayName = found.name;
      });
    }

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

              // 7. Selector de Ubicación / Contenedor
              SegmentedButton<InstantiationLocationMode>(
                segments: const [
                  ButtonSegment(
                    value: InstantiationLocationMode.physicalNode,
                    label: Text(AppStrings.physicalLocation),
                    icon: Icon(Icons.account_tree_outlined),
                  ),
                  ButtonSegment(
                    value: InstantiationLocationMode.containerEntity,
                    label: Text(AppStrings.savedInContainer),
                    icon: Icon(Icons.inventory_2_outlined),
                  ),
                ],
                selected: {_locationMode},
                onSelectionChanged: (set) {
                  setState(() => _locationMode = set.first);
                },
              ),
              const SizedBox(height: 12),

              if (_locationMode == InstantiationLocationMode.physicalNode) ...[
                Text(AppStrings.locationLabel, style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickLocationFromTree,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_tree_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            locationDisplayName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Text(AppStrings.selectContainerPrompt, style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                if (entities.isEmpty)
                  const Text(AppStrings.noContainerObjectsAvailable)
                else
                  DropdownButtonFormField<String>(
                    value: _selectedContainerEntityId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.inventory_2_outlined),
                      hintText: AppStrings.selectContainerObject,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (val) {
                      if (_locationMode == InstantiationLocationMode.containerEntity && val == null) {
                        return AppStrings.selectValidContainerPrompt;
                      }
                      return null;
                    },
                    items: entities.map((e) {
                      final name = EntityDisplayHelper.getDisplayName(
                        entity: e,
                        catalogItems: catalogItems,
                        subspeciesList: subspeciesList,
                      );
                      return DropdownMenuItem(value: e.id, child: Text(name, overflow: TextOverflow.ellipsis));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedContainerEntityId = val),
                  ),
              ],
              const SizedBox(height: 14),

              // 8. Edición Especial (Sección con checkbox y razón opcional)
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
