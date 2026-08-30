import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../../../core/domain/property_data_type.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/domain/entity_template.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../domain/catalog_item.dart';
import '../domain/species_magnitude.dart';
import '../domain/subspecies.dart';
import 'subspecies_section_widget.dart';
import 'add_edit_subspecies_modal.dart';
import 'standard_media_picker_sheet.dart';
import 'subspecies_tile.dart';

class SpeciesFormModal extends ConsumerStatefulWidget {
  final CatalogItem? initialSpecies; // Null for Create mode, Non-null for Edit mode
  final Function(CatalogItem savedSpecies)? onSpeciesSaved;
  final dynamic scannedResult;
  final bool isEmbedded;

  const SpeciesFormModal({
    super.key,
    this.initialSpecies,
    this.onSpeciesSaved,
    this.scannedResult,
    this.isEmbedded = false,
  });

  static Future<CatalogItem?> show(
    BuildContext context, {
    CatalogItem? initialSpecies,
    Function(CatalogItem savedSpecies)? onSpeciesSaved,
    dynamic scannedResult,
  }) {
    return showModalBottomSheet<CatalogItem?>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpeciesFormModal(
        initialSpecies: initialSpecies,
        onSpeciesSaved: onSpeciesSaved,
        scannedResult: scannedResult,
      ),
    );
  }

  @override
  ConsumerState<SpeciesFormModal> createState() => _SpeciesFormModalState();
}

class _SpeciesFormModalState extends ConsumerState<SpeciesFormModal> {
  late bool _isEditMode;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _defaultShelfLifeController = TextEditingController();
  final _warningDaysController = TextEditingController();

  String _selectedType = AppStrings.typeObject;
  bool _isUnique = false;
  bool _isNonPerishable = true;
  XFile? _selectedImage;
  String? _speciesPhotoPath;
  bool _photoDeleted = false;
  bool _isSaving = false;

  // Multiplicity of Units & Magnitudes
  final List<SpeciesMagnitude> _magnitudes = [];
  bool _hasNameProperty = false;

  final List<String> _entityTypes = [
    AppStrings.typeObject,
    AppStrings.typeLivingBeing,
    AppStrings.typeDocument,
    AppStrings.typeProject,
    AppStrings.typeMemory,
  ];

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.initialSpecies != null;

    if (_isEditMode) {
      final s = widget.initialSpecies!;
      _nameController.text = s.name;
      _descController.text = s.description ?? AppTechnicalStrings.empty;
      _defaultShelfLifeController.text = s.defaultShelfLifeDays?.toString() ?? AppTechnicalStrings.empty;
      _warningDaysController.text = s.warningDaysBeforeExpiration?.toString() ?? AppTechnicalStrings.empty;
      _selectedType = s.type;
      _isUnique = s.isUnique;
      _isNonPerishable = s.isNonPerishable;
      _speciesPhotoPath = s.mainPhotoPath;
      _magnitudes.addAll(s.magnitudes);
      _hasNameProperty = _magnitudes.any((m) {
        final p = m.propertyName.trim().toLowerCase();
        return (p == AppTechnicalStrings.propNombreLower || p == AppTechnicalStrings.propNameLower) &&
            m.dataType == AppTechnicalStrings.datatypeStringLower;
      });
    } else if (widget.scannedResult != null) {
      final res = widget.scannedResult;
      final genName = res.generalSpeciesName?.toString() ?? AppTechnicalStrings.empty;
      final subName = res.subspeciesName?.toString() ?? AppTechnicalStrings.empty;

      _nameController.text = genName.isNotEmpty ? genName : (subName.isNotEmpty ? subName : AppStrings.defaultNewObjectName);
      _descController.text = res.description?.toString() ?? AppTechnicalStrings.empty;
      _selectedType = res.type?.toString() ?? AppStrings.typeObject;
      _speciesPhotoPath = res.localPhotoPath?.toString() ?? res.photoUrl?.toString();

      if (subName.isNotEmpty) {
        _draftSubspecies.add(Subspecies(
          id: const Uuid().v4(),
          speciesId: AppTechnicalStrings.empty,
          subspeciesName: subName,
          brand: res.brand?.toString(),
          barcode: res.barcode?.toString(),
          photoPath: res.localPhotoPath?.toString() ?? res.photoUrl?.toString(),
          notes: res.description?.toString(),
          createdAt: DateTime.now(),
        ));
      }
      _applySubgroupConstraints(_selectedType);
    } else {
      _applySubgroupConstraints(_selectedType);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _defaultShelfLifeController.dispose();
    _warningDaysController.dispose();
    super.dispose();
  }

  bool _forceClose = false;

  bool _hasUnsavedChanges() {
    if (_isEditMode && widget.initialSpecies != null) {
      final s = widget.initialSpecies!;
      if (_nameController.text.trim() != s.name.trim()) return true;
      if (_descController.text.trim() != (s.description ?? AppTechnicalStrings.empty).trim()) return true;
      final defaultShelf = s.defaultShelfLifeDays?.toString() ?? AppTechnicalStrings.empty;
      if (_defaultShelfLifeController.text.trim() != defaultShelf.trim()) return true;
      final warnDays = s.warningDaysBeforeExpiration?.toString() ?? AppTechnicalStrings.empty;
      if (_warningDaysController.text.trim() != warnDays.trim()) return true;
      if (_selectedType != s.type) return true;
      if (_isUnique != s.isUnique) return true;
      if (_isNonPerishable != s.isNonPerishable) return true;
      if (_selectedImage != null || _photoDeleted) return true;
      if (_magnitudes.length != s.magnitudes.length) return true;
      if (_draftSubspecies.isNotEmpty) return true;
      return false;
    } else {
      if (_nameController.text.trim().isNotEmpty) return true;
      if (_descController.text.trim().isNotEmpty) return true;
      if (_defaultShelfLifeController.text.trim().isNotEmpty) return true;
      if (_warningDaysController.text.trim().isNotEmpty) return true;
      if (_selectedImage != null || _photoDeleted) return true;
      if (_magnitudes.isNotEmpty) return true;
      if (_draftSubspecies.isNotEmpty) return true;
      return false;
    }
  }

  Future<bool> _requestClose() async {
    if (_hasUnsavedChanges()) {
      final discard = await AppConfirmationDialog.showDiscardChangesDialog(context);
      if (!discard) return false;
    }
    _forceClose = true;
    return true;
  }

  void _applySubgroupConstraints(String type) {
    final template = EntityTemplateRegistry.getTemplate(type);
    setState(() {
      _selectedType = type;
      if (template.isAlwaysUnique) {
        _isUnique = true;
      }
      if (type != AppStrings.typeObject) {
        _isNonPerishable = true;
      }
    });
  }

  Future<void> _pickAndAddDocument(String speciesId) async {
    final result = await StandardMediaPickerSheet.show(
      context,
      title: AppStrings.attachToSpeciesAction,
      webSearchQuery: _nameController.text.trim(),
    );
    if (result == null) return;

    final storage = ref.read(fileStorageServiceProvider);
    try {
      final savedRelativePath = result.file != null
          ? await storage.saveFile(result.file!.path)
          : result.relativeStoredPath;
      if (savedRelativePath == null) return;

      final attachment = Attachment(
        id: const Uuid().v4(),
        speciesId: speciesId,
        filePath: savedRelativePath,
        fileName: result.fileName,
        fileType: result.fileType,
        createdAt: DateTime.now(),
      );

      await ref.read(entityRepositoryProvider).addAttachment(attachment);
      ref.invalidate(speciesAttachmentsProvider(speciesId));
      ref.invalidate(catalogListProvider);
      ref.invalidate(entityListProvider);
      ref.invalidate(recentEntitiesProvider);

      if (mounted) {
        AppToast.showSuccess(context, AppStrings.fileAttachedToSpecies(result.fileName));
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty));
      }
    }
  }

  final List<Subspecies> _draftSubspecies = [];

  void _toggleNameProperty(bool value) {
    setState(() {
      _hasNameProperty = value;
      if (value) {
        final alreadyHas = _magnitudes.any((m) {
          final p = m.propertyName.trim().toLowerCase();
          return (p == AppTechnicalStrings.propNombreLower || p == AppTechnicalStrings.propNameLower) &&
              m.dataType == AppTechnicalStrings.datatypeStringLower;
        });
        if (!alreadyHas) {
          _magnitudes.insert(
            0,
            SpeciesMagnitude(
              id: const Uuid().v4(),
              speciesId: widget.initialSpecies?.id ?? AppTechnicalStrings.empty,
              propertyName: AppStrings.propertyNameNombre,
              dataType: AppTechnicalStrings.datatypeStringLower,
              unitSymbol: null,
              createdAt: DateTime.now(),
            ),
          );
        }
      } else {
        _magnitudes.removeWhere((m) {
          final p = m.propertyName.trim().toLowerCase();
          return (p == AppTechnicalStrings.propNombreLower || p == AppTechnicalStrings.propNameLower) &&
              m.dataType == AppTechnicalStrings.datatypeStringLower;
        });
      }
    });
  }

  void _addMagnitudeRow() async {
    final allowedUnits = DomainRules.getAllowedUnitsForSpecies(isUnique: _isUnique);
    String chosenUnit = allowedUnits.first;
    PropertyDataType chosenType = DomainRules.suggestDataTypeForUnit(chosenUnit);
    final propCtrl = TextEditingController(text: DomainRules.suggestPropertyNameForUnit(chosenUnit));

    final result = await showDialog<SpeciesMagnitude>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (c, setStateDialog) => AlertDialog(
          title: const Text(AppStrings.addPropertyOrMagnitudeTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: propCtrl,
                  decoration: const InputDecoration(labelText: AppStrings.propertyNameHint),
                ),
                const SizedBox(height: 12),
                const Text(AppStrings.primitiveDataTypeLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                AppWheelPickerField<PropertyDataType>(
                  value: chosenType,
                  items: PropertyDataType.values,
                  labelBuilder: (t) => t.label,
                  title: AppStrings.primitiveDataTypeLabel,
                  decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                  onChanged: (val) {
                    if (val != null) {
                      setStateDialog(() {
                        chosenType = val;
                      });
                    }
                  },
                ),
                if (chosenType.isNumeric) ...[
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final picked = await AppWheelPicker.show<String>(
                        context,
                        items: allowedUnits,
                        initialValue: chosenUnit,
                        labelBuilder: (u) => u,
                        title: AppStrings.selectUnitPrompt,
                      );
                      if (picked != null) {
                        setStateDialog(() {
                          chosenUnit = picked;
                          chosenType = DomainRules.suggestDataTypeForUnit(picked);
                          propCtrl.text = DomainRules.suggestPropertyNameForUnit(picked);
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: AppStrings.unitLabel),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chosenUnit,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Icon(Icons.swap_vert),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
            ElevatedButton(
              onPressed: () {
                final propName = propCtrl.text.trim();
                if (propName.isNotEmpty) {
                  Navigator.pop(
                    ctx,
                    SpeciesMagnitude(
                      id: const Uuid().v4(),
                      speciesId: widget.initialSpecies?.id ?? AppTechnicalStrings.empty,
                      propertyName: propName,
                      dataType: chosenType.code,
                      unitSymbol: chosenType.isNumeric ? chosenUnit : null,
                      createdAt: DateTime.now(),
                    ),
                  );
                }
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _magnitudes.add(result);
        _hasNameProperty = _magnitudes.any((m) {
          final p = m.propertyName.trim().toLowerCase();
          return (p == AppTechnicalStrings.propNombreLower || p == AppTechnicalStrings.propNameLower) &&
              m.dataType == AppTechnicalStrings.datatypeStringLower;
        });
      });
    }
  }

  Future<void> _removeMagnitudeRow(int index) async {
    final mag = _magnitudes[index];
    final confirm = await AppConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: AppStrings.confirmDeletePropertyTitle,
      message: AppStrings.confirmDeletePropertyNamed(mag.propertyName),
    );
    if (confirm && mounted) {
      setState(() {
        _magnitudes.removeAt(index);
        _hasNameProperty = _magnitudes.any((m) {
          final p = m.propertyName.trim().toLowerCase();
          return (p == AppTechnicalStrings.propNombreLower || p == AppTechnicalStrings.propNameLower) &&
              m.dataType == AppTechnicalStrings.datatypeStringLower;
        });
      });
    }
  }

  Future<void> _addOrEditDraftSubspeciesModal({Subspecies? initial, int? editIndex}) async {
    final resultSub = await AddEditSubspeciesModal.show(
      context,
      initialSubspecies: initial,
      defaultSpeciesName: _nameController.text.trim(),
      isObject: EntityTemplateRegistry.hasBarcodeAndBrand(_selectedType),
    );

    if (resultSub != null) {
      setState(() {
        if (editIndex != null) {
          _draftSubspecies[editIndex] = resultSub;
        } else {
          _draftSubspecies.add(resultSub);
        }
      });
    }
  }

  Future<void> _saveSpecies() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppToast.showRestriction(context, AppStrings.nameLabel);
      return;
    }

    final template = EntityTemplateRegistry.getTemplate(_selectedType);
    final effectiveUnique = template.isAlwaysUnique || _isUnique;

    final List<Subspecies> subspeciesToSave = List.of(_draftSubspecies);

    if (!_isEditMode && subspeciesToSave.isEmpty) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(AppStrings.noSubspeciesWarningTitle),
          content: const Text(AppStrings.noSubspeciesWarningMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(AppStrings.confirm),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return;
      }

      subspeciesToSave.add(
        Subspecies(
          id: const Uuid().v4(),
          speciesId: AppTechnicalStrings.empty,
          subspeciesName: AppStrings.genericSubspeciesName,
          createdAt: DateTime.now(),
        ),
      );
    }

    final allCatalog = await ref.read(catalogRepositoryProvider).getAllCatalogItems();
    final existingWithSameName = allCatalog.where((c) => c.id != (widget.initialSpecies?.id ?? AppTechnicalStrings.empty) && c.name.toLowerCase() == name.toLowerCase()).firstOrNull;

    if (existingWithSameName != null) {
      final choice = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(AppStrings.duplicateSpeciesDialogTitle),
          content: Text(AppStrings.duplicateSpeciesPrompt(name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, AppTechnicalStrings.actionCancel),
              child: const Text(AppStrings.cancel),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, AppTechnicalStrings.actionCreateSeparate),
              child: const Text(AppStrings.createSeparateSpeciesAction),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, AppTechnicalStrings.actionMerge),
              child: const Text(AppStrings.mergeWithExistingSpeciesAction),
            ),
          ],
        ),
      );

      if (choice == null || choice == AppTechnicalStrings.actionCancel) {
        return;
      }

      if (choice == AppTechnicalStrings.actionMerge) {
        setState(() => _isSaving = true);
        try {
          final catalogRepo = ref.read(catalogRepositoryProvider);
          for (final draft in subspeciesToSave) {
            final sub = draft.copyWith(speciesId: existingWithSameName.id);
            await catalogRepo.saveSubspecies(sub);
          }
          for (final mag in _magnitudes) {
            await catalogRepo.addSpeciesMagnitude(
              existingWithSameName.id,
              mag.propertyName,
              dataType: mag.dataType,
              unitSymbol: mag.unitSymbol,
            );
          }
          ref.invalidate(catalogListProvider);
          ref.invalidate(subspeciesListProvider);
          if (mounted) {
            AppToast.showSuccess(context, AppStrings.duplicateSpeciesMergedSuccess);
            _forceClose = true;
            Navigator.pop(context, existingWithSameName);
          }
        } catch (e) {
          if (mounted) {
            AppToast.showError(context, e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty));
          }
        } finally {
          if (mounted) setState(() => _isSaving = false);
        }
        return;
      }
    }

    if (_speciesPhotoPath != null && _speciesPhotoPath!.isNotEmpty) {
      final existingWithSamePhoto = allCatalog.where((c) => c.id != (widget.initialSpecies?.id ?? AppTechnicalStrings.empty) && c.mainPhotoPath == _speciesPhotoPath).firstOrNull;
      if (existingWithSamePhoto != null && _selectedImage == null) {
        final photoChoice = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(AppStrings.duplicatePhotoDialogTitle),
            content: Text(AppStrings.duplicatePhotoPrompt(existingWithSamePhoto.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text(AppStrings.cancel),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(AppStrings.reusePhotoAction),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(AppStrings.changePhotoAction),
              ),
            ],
          ),
        );
        if (photoChoice != true) {
          return;
        }
      }
    }

    final hasBarcodeOrBrand = !EntityTemplateRegistry.hasBarcodeAndBrand(_selectedType) &&
        subspeciesToSave.any((s) => (s.brand != null && s.brand!.isNotEmpty) || (s.barcode != null && s.barcode!.isNotEmpty));
    if (hasBarcodeOrBrand) {
      final subChoice = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(AppStrings.subgroupDeviationTitle),
          content: Text(AppStrings.subgroupDeviationPrompt(_selectedType, AppStrings.brandLabel)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(AppStrings.correctDataAction),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(AppStrings.confirmExceptionAction),
            ),
          ],
        ),
      );
      if (subChoice != true) {
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final storage = ref.read(fileStorageServiceProvider);

      String? photoPath = _speciesPhotoPath;
      if (_selectedImage != null) {
        photoPath = await storage.saveFile(_selectedImage!.path);
      } else if (_photoDeleted || photoPath == null) {
        photoPath = null;
        if (widget.initialSpecies?.mainPhotoPath != null && widget.initialSpecies!.mainPhotoPath!.isNotEmpty) {
          await storage.deleteFile(widget.initialSpecies!.mainPhotoPath!);
        }
      }

      final speciesId = widget.initialSpecies?.id ?? const Uuid().v4();
      final updatedMagnitudes = _magnitudes.map((m) => m.copyWith(speciesId: speciesId)).toList();

      final defaultShelfLife = int.tryParse(_defaultShelfLifeController.text.trim());
      final warningDays = int.tryParse(_warningDaysController.text.trim());

      final effectiveType = _isEditMode ? widget.initialSpecies!.type : _selectedType;
      final effectiveNonPerishable = effectiveType == AppStrings.typeObject ? _isNonPerishable : true;

      final savedItem = CatalogItem(
        id: speciesId,
        name: name,
        type: effectiveType,
        description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : null,
        magnitudes: updatedMagnitudes,
        isUnique: effectiveUnique,
        isNonPerishable: effectiveNonPerishable,
        mainPhotoPath: photoPath,
        defaultShelfLifeDays: !effectiveNonPerishable ? defaultShelfLife : null,
        warningDaysBeforeExpiration: !effectiveNonPerishable ? warningDays : null,
        createdAt: widget.initialSpecies?.createdAt ?? DateTime.now(),
      );

      final catalogRepo = ref.read(catalogRepositoryProvider);

      await ref.read(catalogListProvider.notifier).saveCatalogItem(savedItem);

      // Save all draft subspecies (including Genérica if confirmed) AFTER saving catalog item to respect foreign keys
      if (subspeciesToSave.isNotEmpty) {
        for (final draft in subspeciesToSave) {
          final sub = draft.copyWith(speciesId: speciesId);
          await catalogRepo.saveSubspecies(sub);
        }
      }

      if (widget.onSpeciesSaved != null) {
        _forceClose = true;
        widget.onSpeciesSaved!(savedItem);
      } else {
        if (mounted) {
          final navCtx = Navigator.of(context).context;
          _forceClose = true;
          Navigator.pop(context, savedItem);

          if (!_isEditMode) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (navCtx.mounted) {
                InstantiateSpeciesSheet.show(navCtx, species: savedItem);
              }
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final template = EntityTemplateRegistry.getTemplate(_selectedType);

    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom + 16
        : mediaQuery.padding.bottom + 16;

    final formContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isEmbedded) ...[
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _isEditMode ? AppStrings.editSpeciesTitle : AppStrings.createSpeciesTitle,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: AppStrings.close,
                onPressed: () async {
                  final canClose = await _requestClose();
                  if (canClose && mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo Picker (Point 2: BoxFit.contain)
                    GestureDetector(
                      onTap: () async {
                        final result = await StandardMediaPickerSheet.show(
                          context,
                          title: AppStrings.speciesPhotoTitle,
                          webSearchQuery: _nameController.text.trim(),
                          allowDocuments: false,
                        );
                        if (result != null && mounted) {
                          if (result.file != null) {
                            setState(() {
                              _selectedImage = XFile(result.file!.path);
                              _speciesPhotoPath = null;
                            });
                          } else if (result.relativeStoredPath != null) {
                            setState(() {
                              _speciesPhotoPath = result.relativeStoredPath;
                              _selectedImage = null;
                            });
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 85,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _selectedImage != null
                                  ? Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                                    )
                                  : (_speciesPhotoPath != null && _speciesPhotoPath!.isNotEmpty)
                                      ? (_speciesPhotoPath!.startsWith(AppTechnicalStrings.httpPrefix)
                                          ? Image.network(
                                              _speciesPhotoPath!,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                                            )
                                          : FutureBuilder<String>(
                                              future: ref.read(fileStorageServiceProvider).getAbsolutePath(_speciesPhotoPath!),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                                  return Image.file(
                                                    File(snapshot.data!),
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                                                  );
                                                }
                                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                              },
                                            ))
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo_outlined, size: 22, color: theme.colorScheme.primary),
                                            const SizedBox(height: 2),
                                            Text(
                                              AppStrings.photoLabel,
                                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                                            ),
                                          ],
                                        ),
                            ),
                          ),
                          if (_selectedImage != null || (_speciesPhotoPath != null && _speciesPhotoPath!.isNotEmpty))
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Material(
                                color: Colors.redAccent.withAlpha(220),
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () async {
                                    final confirm = await AppConfirmationDialog.show(
                                      context: context,
                                      title: AppStrings.confirmRemovePhotoTitle,
                                      message: AppStrings.confirmRemovePhotoMessage,
                                      confirmLabel: AppStrings.delete,
                                      isDestructive: true,
                                      icon: Icons.delete_outline,
                                    );
                                    if (confirm && mounted) {
                                      setState(() {
                                        _selectedImage = null;
                                        _speciesPhotoPath = null;
                                        _photoDeleted = true;
                                      });
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(Icons.delete_outline, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.nameLabel,
                        prefixIcon: Icon(Icons.auto_awesome),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subgroup Type Chips (Read-only in edit mode - Rule #4)
                    Text(AppStrings.typeLabel, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _entityTypes.map((type) {
                        final isSelected = type == _selectedType;
                        return ChoiceChip(
                          visualDensity: VisualDensity.compact,
                          label: Text(type, style: const TextStyle(fontSize: 12)),
                          selected: isSelected,
                          onSelected: _isEditMode
                              ? null
                              : (val) {
                                  if (val) _applySubgroupConstraints(type);
                                },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // Unique Checkbox
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text(AppStrings.isUniqueLabel, style: TextStyle(fontSize: 13)),
                      value: template.isAlwaysUnique || _isUnique,
                      onChanged: template.isAlwaysUnique
                          ? null
                          : (val) {
                              setState(() {
                                _isUnique = val ?? false;
                              });
                            },
                    ),
                    const SizedBox(height: 10),

                    // Configuración de Caducidad (Solo visible para Especies de tipo Objeto)
                    if (_selectedType == AppStrings.typeObject) ...[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: const Text(AppStrings.isPerishableProductTitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        subtitle: const Text(AppStrings.defaultNonPerishableSubtitle, style: TextStyle(fontSize: 11)),
                        value: !_isNonPerishable,
                        onChanged: (isPerishable) {
                          setState(() {
                            _isNonPerishable = !isPerishable;
                          });
                        },
                      ),
                      if (!_isNonPerishable) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _defaultShelfLifeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: AppStrings.shelfLifeDaysLabel,
                                  hintText: AppStrings.shelfLifeDaysHint,
                                  prefixIcon: Icon(Icons.timer_outlined, size: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _warningDaysController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: AppStrings.warningDaysLabel,
                                  hintText: AppStrings.warningDaysHint,
                                  prefixIcon: Icon(Icons.warning_amber_rounded, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 10),
                    ],

                    // Multiplicidad de Unidades y Magnitudes (+ / - Controls)
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(AppStrings.presetNamePropertyLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              subtitle: const Text(AppStrings.presetNamePropertyDescription, style: TextStyle(fontSize: 11, color: Colors.grey)),
                              value: _hasNameProperty,
                              onChanged: _toggleNameProperty,
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    AppStrings.unitsAndMagnitudesTitle,
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addMagnitudeRow,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text(AppStrings.addUnitAction, style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            if (_magnitudes.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(AppStrings.noAdditionalUnitsAdded, style: TextStyle(color: Colors.grey, fontSize: 12)),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _magnitudes.length,
                                itemBuilder: (ctx, idx) {
                                  final mag = _magnitudes[idx];
                                  return ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      AppStrings.propertyWithUnitOrType(
                                        mag.propertyName,
                                        mag.unitSymbol != null && mag.unitSymbol!.trim().isNotEmpty
                                            ? mag.unitSymbol!
                                            : mag.dataType,
                                      ),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                                      tooltip: AppStrings.removeUnitAction,
                                      onPressed: () => _removeMagnitudeRow(idx),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Draft Subspecies / Brand Variants (Create Mode)
                    if (!_isEditMode) ...[
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      AppStrings.subspeciesOrBrandsWithCount(_draftSubspecies.length),
                                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _addOrEditDraftSubspeciesModal(),
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text(AppStrings.addBrandAction, style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                              if (_draftSubspecies.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6.0),
                                  child: Text(AppStrings.noSubspeciesOrBrandsAdded, style: TextStyle(color: Colors.grey, fontSize: 12)),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _draftSubspecies.length,
                                  itemBuilder: (ctx, idx) {
                                    final sub = _draftSubspecies[idx];
                                    return SubspeciesTile(
                                      subspecies: sub,
                                      speciesName: _nameController.text.trim(),
                                      onTap: () => _addOrEditDraftSubspeciesModal(initial: sub, editIndex: idx),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 18),
                                        onPressed: () async {
                                          final confirm = await AppConfirmationDialog.showDeleteConfirmation(
                                            context: context,
                                            title: AppStrings.confirmDeleteSubspeciesTitle,
                                            message: AppStrings.confirmDeleteSubspeciesNamed(sub.subspeciesName),
                                          );
                                          if (confirm && mounted) {
                                            setState(() => _draftSubspecies.removeAt(idx));
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Point 3: "Adjuntar archivo" action button ONLY in Edit Mode!
                    if (_isEditMode && widget.initialSpecies != null) ...[
                      OutlinedButton.icon(
                        onPressed: () => _pickAndAddDocument(widget.initialSpecies!.id),
                        icon: const Icon(Icons.attach_file, size: 16),
                        label: const Text(AppStrings.attachFile),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 44),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Subspecies & Brand Variants section
                      SubspeciesSectionWidget(speciesId: widget.initialSpecies!.id, isEditing: true),
                      const SizedBox(height: 14),
                    ],



                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveSpecies,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(_isEditMode ? AppStrings.save : AppStrings.saveSpeciesAction, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

    if (widget.isEmbedded) {
      return PopScope(
        canPop: _forceClose,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final canClose = await _requestClose();
          if (canClose && mounted) {
            Navigator.of(context).pop();
          }
        },
        child: formContent,
      );
    }

    return PopScope(
      canPop: _forceClose,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canClose = await _requestClose();
        if (canClose && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: bottomPadding,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * 0.92,
          ),
          child: formContent,
        ),
      ),
    );
  }
}
