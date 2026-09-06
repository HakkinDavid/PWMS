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

  // Null checkmark states
  bool _isCountryNull = false;
  bool _isDenominationNull = false;
  bool _isCurrencyNull = false;
  bool _isYearNull = false;
  bool _isGradeNull = false;
  bool _isCompositionNull = false;

  // Custom text controllers for 'Otro'
  final TextEditingController _customCountryController = TextEditingController();
  final TextEditingController _customDenominationController = TextEditingController();
  final TextEditingController _customCurrencyController = TextEditingController();
  final TextEditingController _customGradeController = TextEditingController();
  final TextEditingController _customMaterialController = TextEditingController();
  final TextEditingController _yearController = TextEditingController(text: AppTechnicalStrings.empty);

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
    _customCountryController.dispose();
    _customDenominationController.dispose();
    _customCurrencyController.dispose();
    _customGradeController.dispose();
    _customMaterialController.dispose();
    _yearController.dispose();
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

    // 1. Effective Country
    final String? effectiveCountry;
    if (_isCountryNull) {
      effectiveCountry = null;
    } else if (_country == AppStrings.otherSpecifyOption) {
      effectiveCountry = _customCountryController.text.trim();
    } else {
      effectiveCountry = _country;
    }

    // 2. Effective Denomination
    final String? effectiveDenom;
    if (_isDenominationNull) {
      effectiveDenom = null;
    } else if (_denomination == AppStrings.otherSpecifyOption) {
      effectiveDenom = _customDenominationController.text.trim();
    } else {
      effectiveDenom = _denomination;
    }
    final faceVal = (effectiveDenom != null && effectiveDenom.isNotEmpty) ? double.tryParse(effectiveDenom) : null;

    // 3. Effective Currency
    final String? effectiveCurrencyCode;
    final String? effectiveCurrencyName;
    if (_isCurrencyNull) {
      effectiveCurrencyCode = null;
      effectiveCurrencyName = null;
    } else if (_currencyCode == AppStrings.otherSpecifyOption) {
      final customCurr = _customCurrencyController.text.trim();
      effectiveCurrencyCode = customCurr.isNotEmpty ? customCurr : null;
      effectiveCurrencyName = customCurr.isNotEmpty ? customCurr : null;
    } else if (_currencyCode != null && _currencyCode!.isNotEmpty) {
      effectiveCurrencyCode = _currencyCode;
      effectiveCurrencyName = _currencyMap[_currencyCode!] ?? _currencyCode;
    } else {
      effectiveCurrencyCode = null;
      effectiveCurrencyName = null;
    }

    // 4. Effective Year
    final String? effectiveYear;
    if (_isYearNull) {
      effectiveYear = null;
    } else {
      final yearStr = _yearController.text.trim();
      effectiveYear = yearStr.isNotEmpty ? yearStr : null;
    }

    // 5. Effective Grade
    final String? effectiveGrade;
    if (_isGradeNull) {
      effectiveGrade = null;
    } else if (_grade == AppStrings.otherSpecifyOption) {
      final customGrade = _customGradeController.text.trim();
      effectiveGrade = customGrade.isNotEmpty ? customGrade : null;
    } else {
      effectiveGrade = _grade;
    }

    // 6. Effective Composition
    final String? effectiveComposition;
    if (widget.isCoin) {
      if (_isCompositionNull) {
        effectiveComposition = null;
      } else if (_composition == AppStrings.otherSpecifyOption) {
        final customMat = _customMaterialController.text.trim();
        effectiveComposition = customMat.isNotEmpty ? customMat : null;
      } else {
        effectiveComposition = _composition;
      }
    } else {
      effectiveComposition = AppStrings.materialPaper;
    }

    final speciesType = widget.isCoin ? AppStrings.coinCircularLabel : AppStrings.banknoteRectangleLabel;

    final title = NumismaticDataHelper.buildSubspeciesName(
      faceValueStr: effectiveDenom,
      faceValueNumber: faceVal,
      currencyName: effectiveCurrencyName,
      country: effectiveCountry,
      year: effectiveYear,
    );

    final effectiveMotif = _isSpecialEdition
        ? ((_specialReason == AppStrings.otherSpecifyOption || _specialReason == AppStrings.otherSpecifyParenthesized)
            ? _specialNotesController.text.trim()
            : _specialReason)
        : null;

    final isSpecialNotesApplicable = _isSpecialEdition &&
        (_specialReason == AppStrings.otherSpecifyOption || _specialReason == AppStrings.otherSpecifyParenthesized);

    final result = NumismaticScanResult(
      speciesType: speciesType,
      generalSpeciesName: speciesType,
      subspeciesName: title,
      country: effectiveCountry,
      year: effectiveYear,
      faceValueNumber: faceVal,
      currencyCode: effectiveCurrencyCode,
      currencyName: effectiveCurrencyName,
      composition: effectiveComposition,
      grade: effectiveGrade,
      isSpecialEdition: _isSpecialEdition,
      specialEditionReason: _isSpecialEdition ? _specialReason : null,
      specialEditionNotes: isSpecialNotesApplicable
          ? _specialNotesController.text.trim()
          : null,
      motif: effectiveMotif,
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

  int? get _parsedYear => _isYearNull ? null : int.tryParse(_yearController.text.trim());

  List<String> get _availableMotifs {
    final effectiveCountry = _isCountryNull ? null : (_country == AppStrings.otherSpecifyOption ? _customCountryController.text.trim() : _country);
    final effectiveCurrency = _isCurrencyNull ? null : (_currencyCode == AppStrings.otherSpecifyOption ? _customCurrencyController.text.trim() : _currencyCode);
    final effectiveDenom = _isDenominationNull ? null : (_denomination == AppStrings.otherSpecifyOption ? _customDenominationController.text.trim() : _denomination);

    final rawMotifs = NumismaticDataHelper.getCommemorativeMotifs(
      country: effectiveCountry,
      year: _parsedYear,
      currencyCode: effectiveCurrency,
      denomination: effectiveDenom,
      isBanknote: !widget.isCoin,
    );

    final items = <String>[];
    for (final m in rawMotifs) {
      if (!items.contains(m)) items.add(m);
    }
    for (final r in _specialEditionReasons) {
      if (!items.contains(r)) items.add(r);
    }
    if (!items.contains(AppStrings.otherSpecifyOption)) {
      items.add(AppStrings.otherSpecifyOption);
    }
    return items;
  }

  void _onCountryChanged(String? val) {
    setState(() {
      _country = val;
      _recalculateInferences();
    });
  }

  void _onYearChanged() {
    setState(() {
      _recalculateInferences();
    });
  }

  void _onCurrencyChanged(String? val) {
    setState(() {
      _currencyCode = val;
      _recalculateInferences(preserveCurrency: true);
    });
  }

  void _onDenominationChanged(String? val) {
    setState(() {
      _denomination = val;
      _recalculateInferences(preserveCurrency: true, preserveDenomination: true);
    });
  }

  void _recalculateInferences({
    bool preserveCurrency = false,
    bool preserveDenomination = false,
  }) {
    final effectiveCountry = _country == AppStrings.otherSpecifyOption ? null : _country;
    final year = _parsedYear;

    // 1. Currency inference / validation
    final availableCurrencies = NumismaticDataHelper.getCurrenciesForCountry(effectiveCountry, year: year);
    if (!_isCurrencyNull && !preserveCurrency) {
      final inferredCurrency = NumismaticDataHelper.inferCurrency(country: effectiveCountry, year: year);
      if (inferredCurrency != null) {
        _currencyCode = inferredCurrency;
      } else if (_currencyCode != null &&
          _currencyCode != AppStrings.otherSpecifyOption &&
          !availableCurrencies.contains(_currencyCode)) {
        _currencyCode = null;
      }
    } else if (_currencyCode != null &&
        _currencyCode != AppStrings.otherSpecifyOption &&
        !availableCurrencies.contains(_currencyCode)) {
      _currencyCode = null;
    }

    // 2. Denomination validation
    final currCode = _currencyCode == AppStrings.otherSpecifyOption ? null : _currencyCode;
    final availableDenominations = NumismaticDataHelper.getDenominationsForCountry(
      country: effectiveCountry,
      year: year,
      currencyCode: currCode,
    );
    if (!_isDenominationNull && !preserveDenomination) {
      if (_denomination != null &&
          _denomination != AppStrings.otherSpecifyOption &&
          !availableDenominations.contains(_denomination)) {
        _denomination = null;
      }
    }

    // 3. Material inference (for coins)
    final denom = _denomination == AppStrings.otherSpecifyOption ? null : _denomination;
    if (widget.isCoin && !_isCompositionNull) {
      final inferredMat = NumismaticDataHelper.inferMaterial(
        country: effectiveCountry,
        year: year,
        currencyCode: currCode,
        denomination: denom,
      );
      if (inferredMat != null) {
        _composition = inferredMat;
      }
    }

    // 4. Special Edition auto-check
    final specialCheck = NumismaticDataHelper.checkSpecialEdition(
      country: effectiveCountry,
      year: year,
      currencyCode: currCode,
      denomination: denom,
    );
    if (specialCheck != null) {
      _isSpecialEdition = true;
      _specialReason = specialCheck.reason;
    }
  }

  Widget _buildFieldHeader({
    required String title,
    required bool isNull,
    required String nullLabel,
    required ValueChanged<bool?> onNullChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isNull ? theme.disabledColor : null,
            ),
          ),
          InkWell(
            onTap: () => onNullChanged(!isNull),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: isNull,
                      onChanged: onNullChanged,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    nullLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isNull ? theme.colorScheme.primary : theme.hintColor,
                      fontWeight: isNull ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
              _buildFieldHeader(
                title: AppStrings.countryIssuerLabel,
                isNull: _isCountryNull,
                nullLabel: AppStrings.unspecifiedCountryLabel,
                onNullChanged: (val) {
                  setState(() {
                    _isCountryNull = val ?? false;
                    if (_isCountryNull) {
                      _country = null;
                      _customCountryController.clear();
                    }
                    _recalculateInferences();
                  });
                },
              ),
              AppWheelPickerField<String?>(
                value: _country,
                enabled: !_isCountryNull,
                items: [null, ..._countries],
                labelBuilder: (c) => c ?? AppStrings.noSelectionPrompt,
                title: AppStrings.countryIssuerLabel,
                decoration: InputDecoration(
                  labelText: AppStrings.countryIssuerLabel,
                  hintText: _isCountryNull ? AppStrings.unspecifiedCountryLabel : AppStrings.noSelectionPrompt,
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) {
                  if (_isCountryNull) return null;
                  return val == null ? AppStrings.selectCountryPrompt : null;
                },
                onChanged: _onCountryChanged,
              ),
              if (!_isCountryNull && _country == AppStrings.otherSpecifyOption) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _customCountryController,
                  decoration: InputDecoration(
                    labelText: AppStrings.specifyCountryLabel,
                    hintText: AppStrings.specifyCountryLabel,
                    prefixIcon: const Icon(Icons.edit_location_alt_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) {
                    if (_isCountryNull) return null;
                    if (_country == AppStrings.otherSpecifyOption && (val == null || val.trim().isEmpty)) {
                      return AppStrings.specifyCountryPrompt;
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 14),

              // 2. Año TextField (1 campo por fila - ahora inmediatamente después de País)
              _buildFieldHeader(
                title: AppStrings.mintageYearLabel,
                isNull: _isYearNull,
                nullLabel: AppStrings.unspecifiedYearLabel,
                onNullChanged: (val) {
                  setState(() {
                    _isYearNull = val ?? false;
                    if (_isYearNull) {
                      _yearController.clear();
                    }
                    _onYearChanged();
                  });
                },
              ),
              TextFormField(
                controller: _yearController,
                enabled: !_isYearNull,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppStrings.mintageYearLabel,
                  hintText: _isYearNull ? AppStrings.unspecifiedYearLabel : AppStrings.exampleYearHint,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onChanged: (_) => _onYearChanged(),
                validator: (val) {
                  if (_isYearNull) return null;
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

              // 3. Divisa Dropdown (1 campo por fila) - Filtrado por País y Año seleccionados
              _buildFieldHeader(
                title: AppStrings.currencyLabel,
                isNull: _isCurrencyNull,
                nullLabel: AppStrings.unspecifiedCurrencyLabel,
                onNullChanged: (val) {
                  setState(() {
                    _isCurrencyNull = val ?? false;
                    if (_isCurrencyNull) {
                      _currencyCode = null;
                      _customCurrencyController.clear();
                    }
                    _recalculateInferences(preserveCurrency: true);
                  });
                },
              ),
              Builder(
                builder: (context) {
                  final availableCurrencies = NumismaticDataHelper.getCurrencyMapForCountry(
                    _country == AppStrings.otherSpecifyOption ? null : _country,
                    year: _parsedYear,
                  );
                  return AppWheelPickerField<String?>(
                    value: _currencyCode,
                    enabled: !_isCurrencyNull,
                    items: [null, ...availableCurrencies.keys, AppStrings.otherSpecifyOption],
                    labelBuilder: (code) {
                      if (code == null) return AppStrings.noSelectionPrompt;
                      if (code == AppStrings.otherSpecifyOption) return AppStrings.otherSpecifyOption;
                      final name = availableCurrencies[code] ?? _currencyMap[code] ?? code;
                      return AppStrings.currencyCodeWithName(code, name);
                    },
                    title: AppStrings.currencyLabel,
                    decoration: InputDecoration(
                      labelText: AppStrings.currencyLabel,
                      hintText: _isCurrencyNull ? AppStrings.unspecifiedCurrencyLabel : AppStrings.noSelectionPrompt,
                      prefixIcon: const Icon(Icons.monetization_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (val) {
                      if (_isCurrencyNull) return null;
                      return val == null ? AppStrings.selectCurrencyPrompt : null;
                    },
                    onChanged: _onCurrencyChanged,
                  );
                },
              ),
              if (!_isCurrencyNull && _currencyCode == AppStrings.otherSpecifyOption) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _customCurrencyController,
                  decoration: InputDecoration(
                    labelText: AppStrings.specifyCurrencyLabel,
                    hintText: AppStrings.specifyCurrencyLabel,
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) {
                    if (_isCurrencyNull) return null;
                    if (_currencyCode == AppStrings.otherSpecifyOption && (val == null || val.trim().isEmpty)) {
                      return AppStrings.specifyCurrencyPrompt;
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 14),

              // 4. Denominación Dropdown (1 campo por fila) - Filtrado por País, Año y Divisa
              _buildFieldHeader(
                title: AppStrings.denominationLabel,
                isNull: _isDenominationNull,
                nullLabel: AppStrings.unspecifiedDenominationLabel,
                onNullChanged: (val) {
                  setState(() {
                    _isDenominationNull = val ?? false;
                    if (_isDenominationNull) {
                      _denomination = null;
                      _customDenominationController.clear();
                    }
                    _recalculateInferences(preserveCurrency: true, preserveDenomination: true);
                  });
                },
              ),
              Builder(
                builder: (context) {
                  final availableDenoms = NumismaticDataHelper.getDenominationsForCountry(
                    country: _country == AppStrings.otherSpecifyOption ? null : _country,
                    year: _parsedYear,
                    currencyCode: _currencyCode == AppStrings.otherSpecifyOption ? null : _currencyCode,
                  );
                  return AppWheelPickerField<String?>(
                    value: _denomination,
                    enabled: !_isDenominationNull,
                    items: [null, ...availableDenoms],
                    labelBuilder: (d) => d ?? AppStrings.noSelectionPrompt,
                    title: AppStrings.denominationLabel,
                    decoration: InputDecoration(
                      labelText: AppStrings.denominationLabel,
                      hintText: _isDenominationNull ? AppStrings.unspecifiedDenominationLabel : AppStrings.noSelectionPrompt,
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (val) {
                      if (_isDenominationNull) return null;
                      return val == null ? AppStrings.selectDenominationPrompt : null;
                    },
                    onChanged: _onDenominationChanged,
                  );
                },
              ),
              if (!_isDenominationNull && _denomination == AppStrings.otherSpecifyOption) ...[
                const SizedBox(height: 10),
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
                    if (_isDenominationNull) return null;
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

              // 5. Material / Composición Dropdown (1 campo por fila, sólo para monedas) - Inferencia automática con override manual
              if (widget.isCoin) ...[
                _buildFieldHeader(
                  title: AppStrings.materialPropertyName,
                  isNull: _isCompositionNull,
                  nullLabel: AppStrings.unspecifiedMaterialLabel,
                  onNullChanged: (val) {
                    setState(() {
                      _isCompositionNull = val ?? false;
                      if (_isCompositionNull) {
                        _composition = null;
                        _customMaterialController.clear();
                      }
                    });
                  },
                ),
                AppWheelPickerField<String?>(
                  value: _composition,
                  enabled: !_isCompositionNull,
                  items: [null, ..._coinMaterials],
                  labelBuilder: (mat) => mat ?? AppStrings.noSelectionPrompt,
                  title: AppStrings.materialPropertyName,
                  decoration: InputDecoration(
                    labelText: AppStrings.materialPropertyName,
                    hintText: _isCompositionNull ? AppStrings.unspecifiedMaterialLabel : AppStrings.noSelectionPrompt,
                    prefixIcon: const Icon(Icons.token),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) {
                    if (_isCompositionNull) return null;
                    return val == null ? AppStrings.selectMaterialPrompt : null;
                  },
                  onChanged: (val) => setState(() => _composition = val),
                ),
                if (!_isCompositionNull && _composition == AppStrings.otherSpecifyOption) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _customMaterialController,
                    decoration: InputDecoration(
                      labelText: AppStrings.specifyMaterialLabel,
                      hintText: AppStrings.specifyMaterialLabel,
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (val) {
                      if (_isCompositionNull) return null;
                      if (_composition == AppStrings.otherSpecifyOption && (val == null || val.trim().isEmpty)) {
                        return AppStrings.specifyMaterialPrompt;
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 14),
              ],

              // 6. Conservación Dropdown (1 campo por fila)
              _buildFieldHeader(
                title: AppStrings.gradePropertyName,
                isNull: _isGradeNull,
                nullLabel: AppStrings.unspecifiedGradeLabel,
                onNullChanged: (val) {
                  setState(() {
                    _isGradeNull = val ?? false;
                    if (_isGradeNull) {
                      _grade = null;
                      _customGradeController.clear();
                    }
                  });
                },
              ),
              AppWheelPickerField<String?>(
                value: _grade,
                enabled: !_isGradeNull,
                items: [null, ..._grades],
                labelBuilder: (g) => g ?? AppStrings.noSelectionPrompt,
                title: AppStrings.gradePropertyName,
                decoration: InputDecoration(
                  labelText: AppStrings.gradePropertyName,
                  hintText: _isGradeNull ? AppStrings.unspecifiedGradeLabel : AppStrings.noSelectionPrompt,
                  prefixIcon: const Icon(Icons.grade),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (val) {
                  if (_isGradeNull) return null;
                  return val == null ? AppStrings.selectGradePrompt : null;
                },
                onChanged: (val) => setState(() => _grade = val),
              ),
              if (!_isGradeNull && _grade == AppStrings.otherSpecifyOption) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _customGradeController,
                  decoration: InputDecoration(
                    labelText: AppStrings.specifyGradeLabel,
                    hintText: AppStrings.specifyGradeLabel,
                    prefixIcon: const Icon(Icons.stars_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) {
                    if (_isGradeNull) return null;
                    if (_grade == AppStrings.otherSpecifyOption && (val == null || val.trim().isEmpty)) {
                      return AppStrings.specifyGradePrompt;
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 14),

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
                        items: [null, ..._availableMotifs],
                        labelBuilder: (r) => r ?? AppStrings.noSelectionPrompt,
                        title: AppStrings.motifLabel,
                        decoration: InputDecoration(
                          labelText: AppStrings.motifLabel,
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
