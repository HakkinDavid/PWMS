import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/storage/app_settings_repository.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../../locations/domain/location_path_helper.dart';
import '../../locations/presentation/location_or_container_selection_sheet.dart';
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

  @visibleForTesting
  static void resetStaticCache() {
    _NumismaticQuickFillSheetState._lastUsedSelection = null;
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
  static LocationOrContainerSelection? _lastUsedSelection;

  @visibleForTesting
  static void resetStaticCache() {
    _lastUsedSelection = null;
  }

  // Location / Container selection
  LocationOrContainerSelection _selection = const LocationOrContainerSelection.physicalNode(null);

  // Default values set to empty / unselected (null)
  String? _country;
  String? _currencyCode;
  String? _denomination;
  String? _grade;
  String? _composition;

  // Empty year text field by default
  final TextEditingController _yearController = TextEditingController(text: AppTechnicalStrings.empty);

  // Custom denomination text field (when 'Otro' is selected)
  final TextEditingController _customDenominationController = TextEditingController();

  // Special Edition Controls
  bool _isSpecialEdition = false;
  String? _specialReason;
  final TextEditingController _specialNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialContainerEntityId != null) {
      _selection = LocationOrContainerSelection.containerEntity(widget.initialContainerEntityId);
    } else if (widget.initialLocationId != null) {
      _selection = LocationOrContainerSelection.physicalNode(widget.initialLocationId);
    } else if (_lastUsedSelection != null) {
      _selection = _lastUsedSelection!;
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
      if (!mounted) return;
      final settingsRepo = ref.read(appSettingsRepositoryProvider);
      final savedModeStr = await settingsRepo.getLastNumismaticLocationMode();
      if (!mounted) return;
      final savedLocId = await settingsRepo.getLastNumismaticLocationId();
      if (!mounted) return;
      final savedContainerId = await settingsRepo.getLastNumismaticContainerEntityId();
      if (!mounted) return;

      setState(() {
        if (savedModeStr == LocationSelectionMode.containerEntity.name && savedContainerId != null) {
          _selection = LocationOrContainerSelection.containerEntity(savedContainerId);
        } else {
          _selection = LocationOrContainerSelection.physicalNode(savedLocId);
        }
        _lastUsedSelection = _selection;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _yearController.dispose();
    _customDenominationController.dispose();
    _specialNotesController.dispose();
    super.dispose();
  }

  Future<void> _pickLocationOrContainer() async {
    final result = await LocationOrContainerSelectionSheet.show(
      context,
      initialSelection: _selection,
    );
    if (result != null && mounted) {
      setState(() {
        _selection = result;
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
          content: Text(AppStrings.completeAllFieldsPrompt),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selection.isContainerEntity &&
        (_selection.containerEntityId == null || _selection.containerEntityId!.isEmpty)) {
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
    _lastUsedSelection = _selection;

    try {
      final settingsRepo = ref.read(appSettingsRepositoryProvider);
      settingsRepo.setLastNumismaticLocationMode(_selection.mode.name).catchError((_) {});
      if (_selection.locationId != null) {
        settingsRepo.setLastNumismaticLocationId(_selection.locationId!).catchError((_) {});
      }
      if (_selection.containerEntityId != null) {
        settingsRepo.setLastNumismaticContainerEntityId(_selection.containerEntityId!).catchError((_) {});
      }
    } catch (_) {}

    final isCustomDenom = _denomination == AppStrings.otherSpecifyOption;
    final effectiveDenom = isCustomDenom
        ? _customDenominationController.text.trim()
        : _denomination!;
    final faceVal = double.tryParse(effectiveDenom);
    final currName = _currencyMap[_currencyCode!] ?? _currencyCode;
    final yearStr = _yearController.text.trim();
    final speciesType = widget.isCoin ? AppStrings.coinCircularLabel : AppStrings.banknoteRectangleLabel;

    final title = NumismaticDataHelper.buildSubspeciesName(
      faceValueStr: effectiveDenom,
      faceValueNumber: faceVal,
      currencyName: currName,
      country: _country,
      year: yearStr.isNotEmpty ? yearStr : null,
    );

    final isSpecialNotesApplicable = _isSpecialEdition &&
        (_specialReason == AppStrings.otherSpecifyOption || _specialReason == AppStrings.otherSpecifyParenthesized);

    final result = NumismaticScanResult(
      speciesType: speciesType,
      generalSpeciesName: speciesType,
      subspeciesName: title,
      country: _country,
      year: yearStr.isNotEmpty ? yearStr : null,
      faceValueNumber: faceVal,
      currencyCode: _currencyCode,
      currencyName: currName,
      composition: widget.isCoin ? _composition : AppStrings.materialPaper,
      grade: _grade,
      isSpecialEdition: _isSpecialEdition,
      specialEditionReason: _isSpecialEdition ? _specialReason : null,
      specialEditionNotes: isSpecialNotesApplicable
          ? _specialNotesController.text.trim()
          : null,
      obversePhotoPath: widget.obversePhoto.path,
      reversePhotoPath: widget.reversePhoto?.path,
      sourceEngine: AppStrings.inAppQuickFillSourceEngine,
      locationId: _selection.isPhysicalNode ? _selection.locationId : null,
      containerEntityId: _selection.isContainerEntity ? _selection.containerEntityId : null,
      isContainer: _selection.isContainerEntity,
    );

    if (widget.onResultSubmitted != null) {
      widget.onResultSubmitted!(result);
    } else if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final speciesLabel = widget.isCoin ? AppStrings.coinCircularDescriptor : AppStrings.banknoteRectangleDescriptor;

    final locationsState = ref.watch(locationNodeListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final subspeciesState = ref.watch(subspeciesListProvider);

    final catalogItems = catalogState.asData?.value ?? [];
    final entities = entitiesState.asData?.value ?? [];
    final subspeciesList = subspeciesState.asData?.value ?? [];
    final locations = locationsState.asData?.value ?? [];

    final locationDisplayName = LocationPathHelper.buildBreadcrumbPath(
      _selection.locationId,
      locations,
    ).fullPath;

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
                      AppStrings.numismaticDataTitlePrefix + speciesLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: AppStrings.cancel,
                    onPressed: () {
                      if (widget.onResultSubmitted != null) {
                        widget.onResultSubmitted!(null);
                      } else if (mounted && Navigator.canPop(context)) {
                        Navigator.pop(context, null);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 1. País / Emisor Dropdown (1 campo por fila)
              AppWheelPickerField<String?>(
                value: _country,
                items: [null, ..._countries],
                labelBuilder: (c) => c ?? AppStrings.noSelectionPrompt,
                title: AppStrings.countryIssuerLabel,
                decoration: InputDecoration(
                  labelText: AppStrings.countryIssuerLabel,
                  hintText: AppStrings.noSelectionPrompt,
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) => val == null ? AppStrings.selectCountryPrompt : null,
                onChanged: (val) {
                  setState(() {
                    _country = val;
                    final availableCurrencies = NumismaticDataHelper.getCurrenciesForCountry(_country);
                    if (_currencyCode != null && !availableCurrencies.contains(_currencyCode)) {
                      _currencyCode = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 14),

              // 2. Denominación Dropdown (1 campo por fila)
              AppWheelPickerField<String?>(
                value: _denomination,
                items: [null, ..._denominations],
                labelBuilder: (d) => d ?? AppStrings.noSelectionPrompt,
                title: AppStrings.denominationLabel,
                decoration: InputDecoration(
                  labelText: AppStrings.denominationLabel,
                  hintText: AppStrings.noSelectionPrompt,
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) => val == null ? AppStrings.selectDenominationPrompt : null,
                onChanged: (val) => setState(() => _denomination = val),
              ),
              if (_denomination == AppStrings.otherSpecifyOption) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _customDenominationController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(AppTechnicalStrings.digitsWithDecimalFilter)),
                  ],
                  decoration: InputDecoration(
                    labelText: AppStrings.denominationNumberLabel,
                    hintText: AppStrings.exampleDecimalHint,
                    prefixIcon: const Icon(Icons.pin),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) {
                    if (_denomination == AppStrings.otherSpecifyOption) {
                      if (val == null || val.trim().isEmpty) {
                        return AppStrings.enterDenominationNumberPrompt;
                      }
                      final parsed = double.tryParse(val.trim());
                      if (parsed == null || parsed <= 0) {
                        return AppStrings.enterValidNumericValuePrompt;
                      }
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 14),

              // 3. Divisa Dropdown (1 campo por fila) - Filtrado por País seleccionado
              Builder(
                builder: (context) {
                  final availableCurrencies = NumismaticDataHelper.getCurrencyMapForCountry(_country);
                  return AppWheelPickerField<String?>(
                    value: _currencyCode,
                    items: [null, ...availableCurrencies.keys],
                    labelBuilder: (code) {
                      if (code == null) return AppStrings.noSelectionPrompt;
                      final name = availableCurrencies[code] ?? code;
                      return AppStrings.currencyCodeWithName(code, name);
                    },
                    title: AppStrings.currencyLabel,
                    decoration: InputDecoration(
                      labelText: AppStrings.currencyLabel,
                      hintText: AppStrings.noSelectionPrompt,
                      prefixIcon: const Icon(Icons.monetization_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (val) => val == null ? AppStrings.selectCurrencyPrompt : null,
                    onChanged: (val) => setState(() => _currencyCode = val),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 4. Año TextField (1 campo por fila)
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppStrings.mintageYearLabel,
                  hintText: AppStrings.exampleYearHint,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return AppStrings.enterMintageYearPrompt;
                  }
                  final yearNum = int.tryParse(val.trim());
                  if (yearNum == null || yearNum < 500 || yearNum > 2100) {
                    return AppStrings.enterValidMintageYearPrompt;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 5. Conservación Dropdown (1 campo por fila)
              AppWheelPickerField<String?>(
                value: _grade,
                items: [null, ..._grades],
                labelBuilder: (g) => g ?? AppStrings.noSelectionPrompt,
                title: AppStrings.gradePropertyName,
                decoration: InputDecoration(
                  labelText: AppStrings.gradePropertyName,
                  hintText: AppStrings.noSelectionPrompt,
                  prefixIcon: const Icon(Icons.grade),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) => val == null ? AppStrings.selectGradePrompt : null,
                onChanged: (val) => setState(() => _grade = val),
              ),
              const SizedBox(height: 14),

              // 6. Material / Composición Dropdown (1 campo por fila, sólo para monedas)
              if (widget.isCoin) ...[
                AppWheelPickerField<String?>(
                  value: _composition,
                  items: [null, ..._coinMaterials],
                  labelBuilder: (mat) => mat ?? AppStrings.noSelectionPrompt,
                  title: AppStrings.materialPropertyName,
                  decoration: InputDecoration(
                    labelText: AppStrings.materialPropertyName,
                    hintText: AppStrings.noSelectionPrompt,
                    prefixIcon: const Icon(Icons.token),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) => val == null ? AppStrings.selectMaterialPrompt : null,
                  onChanged: (val) => setState(() => _composition = val),
                ),
                const SizedBox(height: 14),
              ],

              // 7. Selector de Ubicación / Contenedor (LocationOrContainerSelectionSheet)
              Text(AppStrings.locationLabel, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              if (_selection.isPhysicalNode) ...[
                InkWell(
                  onTap: _pickLocationOrContainer,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppStrings.physicalLocation,
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                              Text(
                                locationDisplayName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Builder(
                  builder: (context) {
                    final selectedContainer = entities.where((e) => e.id == _selection.containerEntityId).firstOrNull;
                    if (selectedContainer != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InstancePreviewCard(
                            entity: selectedContainer,
                            onTap: _pickLocationOrContainer,
                            trailing: IconButton(
                              icon: const Icon(Icons.swap_horiz),
                              tooltip: AppStrings.changeContainerAction,
                              onPressed: _pickLocationOrContainer,
                            ),
                          ),
                        ],
                      );
                    }

                    return InkWell(
                      onTap: _pickLocationOrContainer,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.inventory_2_outlined),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppStrings.savedInContainer,
                                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                  ),
                                  const Text(
                                    AppStrings.selectContainerObject,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    );
                  },
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
                      AppWheelPickerField<String?>(
                        value: _specialReason,
                        items: [null, ..._specialEditionReasons],
                        labelBuilder: (r) => r ?? AppStrings.noSelectionPrompt,
                        title: AppStrings.specialEditionReasonLabel,
                        decoration: InputDecoration(
                          labelText: AppStrings.specialEditionReasonLabel,
                          hintText: AppStrings.noSelectionPrompt,
                          prefixIcon: const Icon(Icons.star),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (val) {
                          if (_isSpecialEdition && val == null) {
                            return AppStrings.selectSpecialEditionReasonPrompt;
                          }
                          return null;
                        },
                        onChanged: (val) => setState(() => _specialReason = val),
                      ),
                      if (_specialReason == AppStrings.otherSpecifyOption || _specialReason == AppStrings.otherSpecifyParenthesized) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _specialNotesController,
                          decoration: InputDecoration(
                            labelText: AppStrings.specialEditionNotesLabel,
                            prefixIcon: const Icon(Icons.edit_note),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          validator: (val) {
                            if (_isSpecialEdition &&
                                (_specialReason == AppStrings.otherSpecifyOption || _specialReason == AppStrings.otherSpecifyParenthesized) &&
                                (val == null || val.trim().isEmpty)) {
                              return AppStrings.specifySpecialEditionNotesPrompt;
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
