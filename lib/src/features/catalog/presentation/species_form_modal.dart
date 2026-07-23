import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/domain/entity_template.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../domain/catalog_item.dart';
import '../domain/species_magnitude.dart';
import '../domain/subspecies.dart';
import 'subspecies_section_widget.dart';

class SpeciesFormModal extends ConsumerStatefulWidget {
  final CatalogItem? initialSpecies; // Null for Create mode, Non-null for Edit mode
  final Function(CatalogItem savedSpecies)? onSpeciesSaved;

  const SpeciesFormModal({
    super.key,
    this.initialSpecies,
    this.onSpeciesSaved,
  });

  static Future<CatalogItem?> show(
    BuildContext context, {
    CatalogItem? initialSpecies,
    Function(CatalogItem savedSpecies)? onSpeciesSaved,
  }) {
    return showModalBottomSheet<CatalogItem?>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpeciesFormModal(
        initialSpecies: initialSpecies,
        onSpeciesSaved: onSpeciesSaved,
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

  String _selectedType = AppStrings.typeObject;
  bool _isUnique = false;
  XFile? _selectedImage;
  bool _isSaving = false;

  // Multiplicity of Units & Magnitudes
  final List<SpeciesMagnitude> _magnitudes = [];

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
      _descController.text = s.description ?? '';
      _selectedType = s.type;
      _isUnique = s.isUnique;
      _magnitudes.addAll(s.magnitudes);
    } else {
      _applySubgroupConstraints(_selectedType);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _applySubgroupConstraints(String type) {
    final template = EntityTemplateRegistry.getTemplate(type);
    setState(() {
      _selectedType = type;
      if (template.isAlwaysUnique) {
        _isUnique = true;
      }
    });
  }

  void _populateFromBaseTemplate(CatalogItem base) {
    setState(() {
      _selectedType = base.type;
      _descController.text = base.description ?? '';
      _isUnique = base.isUnique;
      _magnitudes.clear();
      _magnitudes.addAll(base.magnitudes);
      _applySubgroupConstraints(base.type);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _pickAndAddDocument(String speciesId) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final storage = ref.read(fileStorageServiceProvider);
      final savedRelativePath = await storage.saveFile(file.path!);

      final attachment = Attachment(
        id: const Uuid().v4(),
        speciesId: speciesId,
        filePath: savedRelativePath,
        fileName: file.name,
        fileType: file.extension ?? 'doc',
        createdAt: DateTime.now(),
      );

      try {
        await ref.read(entityRepositoryProvider).addAttachment(attachment);
        ref.invalidate(speciesAttachmentsProvider(speciesId));
        if (mounted) {
          AppToast.showSuccess(context, 'Archivo "${file.name}" adjuntado a la especie');
        }
      } catch (e) {
        if (mounted) {
          AppToast.showError(context, e.toString().replaceAll('Exception: ', ''));
        }
      }
    }
  }

  final List<Subspecies> _draftSubspecies = [];

  void _addMagnitudeRow() async {
    final allowedUnits = DomainRules.getAllowedUnitsForSpecies(isUnique: _isUnique);
    String chosenUnit = allowedUnits.first;
    final propCtrl = TextEditingController(text: DomainRules.suggestPropertyNameForUnit(chosenUnit));

    final result = await showDialog<SpeciesMagnitude>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (c, setStateDialog) => AlertDialog(
          title: const Text(AppStrings.addPropertyOrUnitTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: propCtrl,
                decoration: const InputDecoration(labelText: AppStrings.propertyNameHint),
              ),
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
                      propCtrl.text = DomainRules.suggestPropertyNameForUnit(picked);
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: AppStrings.unitLabel),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(chosenUnit, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Icon(Icons.swap_vert),
                    ],
                  ),
                ),
              ),
            ],
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
                      speciesId: widget.initialSpecies?.id ?? '',
                      propertyName: propName,
                      unitSymbol: chosenUnit,
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
      setState(() => _magnitudes.add(result));
    }
  }

  void _removeMagnitudeRow(int index) {
    setState(() => _magnitudes.removeAt(index));
  }

  Future<void> _addOrEditDraftSubspeciesModal({Subspecies? initial, int? editIndex}) async {
    final nameCtrl = TextEditingController(text: initial?.subspeciesName ?? '');
    final brandCtrl = TextEditingController(text: initial?.brand ?? '');
    final barcodeCtrl = TextEditingController(text: initial?.barcode ?? '');
    final notesCtrl = TextEditingController(text: initial?.notes ?? '');
    String? photoPath = initial?.photoPath;
    XFile? newPickedImage;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (c, setStateModal) => AlertDialog(
          title: Text(initial != null ? AppStrings.editSubspeciesDraftTitle : AppStrings.newSubspeciesVariantTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                    if (img != null) {
                      setStateModal(() => newPickedImage = img);
                    }
                  },
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: newPickedImage != null
                        ? Image.file(File(newPickedImage!.path), fit: BoxFit.cover)
                        : (photoPath != null && photoPath.isNotEmpty)
                            ? FutureBuilder<String>(
                                future: ref.read(fileStorageServiceProvider).getAbsolutePath(photoPath),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) return Image.file(File(snapshot.data!), fit: BoxFit.cover);
                                  return const Icon(Icons.add_a_photo, size: 24);
                                },
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, size: 20),
                                  SizedBox(height: 2),
                                  Text(AppStrings.subspeciesPhotoLabel, style: TextStyle(fontSize: 11)),
                                ],
                              ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: AppStrings.nameOrVariantLabel, hintText: AppStrings.nameOrVariantHint),
                ),
                if (_selectedType == AppStrings.typeObject) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: brandCtrl,
                    decoration: const InputDecoration(labelText: AppStrings.brandLabel, hintText: AppStrings.brandHint),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: barcodeCtrl,
                    decoration: const InputDecoration(labelText: AppStrings.barcodeLabel, hintText: AppStrings.barcodeHint),
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: AppStrings.notesLabel, hintText: AppStrings.notesSpecialEditionHint),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );

    if (confirm == true && nameCtrl.text.trim().isNotEmpty) {
      if (newPickedImage != null) {
        final storage = ref.read(fileStorageServiceProvider);
        photoPath = await storage.saveFile(newPickedImage!.path);
      }

      final sub = Subspecies(
        id: initial?.id ?? const Uuid().v4(),
        speciesId: '',
        subspeciesName: nameCtrl.text.trim(),
        brand: brandCtrl.text.trim().isNotEmpty ? brandCtrl.text.trim() : null,
        barcode: barcodeCtrl.text.trim().isNotEmpty ? barcodeCtrl.text.trim() : null,
        photoPath: photoPath,
        notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
        createdAt: initial?.createdAt ?? DateTime.now(),
      );

      setState(() {
        if (editIndex != null) {
          _draftSubspecies[editIndex] = sub;
        } else {
          _draftSubspecies.add(sub);
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

    setState(() => _isSaving = true);

    try {
      final storage = ref.read(fileStorageServiceProvider);

      String? photoPath = widget.initialSpecies?.mainPhotoPath;
      if (_selectedImage != null) {
        photoPath = await storage.saveFile(_selectedImage!.path);
      }

      final speciesId = widget.initialSpecies?.id ?? const Uuid().v4();
      final updatedMagnitudes = _magnitudes.map((m) => m.copyWith(speciesId: speciesId)).toList();

      final savedItem = CatalogItem(
        id: speciesId,
        name: _isEditMode ? widget.initialSpecies!.name : name,
        type: _isEditMode ? widget.initialSpecies!.type : _selectedType,
        description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : null,
        magnitudes: updatedMagnitudes,
        isUnique: effectiveUnique,
        mainPhotoPath: photoPath,
        createdAt: widget.initialSpecies?.createdAt ?? DateTime.now(),
      );

      final catalogRepo = ref.read(catalogRepositoryProvider);

      // Save all draft subspecies BEFORE saving catalog item so default generic subspecies is omitted!
      if (_draftSubspecies.isNotEmpty) {
        for (final draft in _draftSubspecies) {
          final sub = draft.copyWith(speciesId: speciesId);
          await catalogRepo.saveSubspecies(sub);
        }
      }

      await ref.read(catalogListProvider.notifier).saveCatalogItem(savedItem);

      if (widget.onSpeciesSaved != null) {
        widget.onSpeciesSaved!(savedItem);
      }

      if (mounted) {
        Navigator.pop(context, savedItem);

        if (!_isEditMode) {
          InstantiateSpeciesSheet.show(context, species: savedItem);
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogState = ref.watch(catalogListProvider);
    final existingItems = catalogState.asData?.value ?? [];
    final template = EntityTemplateRegistry.getTemplate(_selectedType);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              _isEditMode ? AppStrings.editSpeciesTitle : AppStrings.createSpeciesTitle,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pre-populate from base template (Create Mode Only)
                    if (!_isEditMode && existingItems.isNotEmpty) ...[
                      InkWell(
                        onTap: () async {
                          final picked = await AppWheelPicker.show<CatalogItem?>(
                            context,
                            items: [null, ...existingItems],
                            initialValue: null,
                            labelBuilder: (item) => item == null ? AppStrings.noTemplate : '${item.name} (${item.type})',
                            title: AppStrings.selectBaseSpeciesPrompt,
                          );
                          if (picked != null) _populateFromBaseTemplate(picked);
                        },
                        child: const InputDecorator(
                          decoration: InputDecoration(
                            labelText: AppStrings.useSpeciesAsBaseTemplate,
                            prefixIcon: Icon(Icons.copy),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppStrings.selectBaseTemplateHint, style: TextStyle(color: Colors.grey)),
                              Icon(Icons.unfold_more),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Photo Picker (Point 2: BoxFit.contain)
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text(AppStrings.takePhoto),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text(AppStrings.chooseGallery),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 75,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(File(_selectedImage!.path)),
                                  fit: BoxFit.contain, // Point 2: BoxFit.contain
                                )
                              : null,
                        ),
                        child: _selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, size: 22, color: theme.colorScheme.primary),
                                  const SizedBox(height: 2),
                                  Text(
                                    AppStrings.photoLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Name (Read-only in edit mode - Rule #4)
                    TextField(
                      controller: _nameController,
                      enabled: !_isEditMode,
                      decoration: InputDecoration(
                        labelText: AppStrings.nameLabel,
                        prefixIcon: const Icon(Icons.auto_awesome),
                        helperText: _isEditMode ? AppStrings.nameIsImmutable : null,
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

                    // Multiplicidad de Unidades y Magnitudes (+ / - Controls)
                    if (template.hasQuantity && !template.isAlwaysUnique) ...[
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
                                  Text(
                                    AppStrings.unitsAndMagnitudesTitle,
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
                                      title: Text('${mag.propertyName} (${mag.unitSymbol})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                    ],
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
                                  Text(
                                    '${AppStrings.subspeciesOrBrands} (${_draftSubspecies.length})',
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: theme.colorScheme.secondary.withAlpha(30),
                                        child: Icon(Icons.branding_watermark, size: 14, color: theme.colorScheme.secondary),
                                      ),
                                      title: Text('${sub.subspeciesName} ${sub.brand != null ? "(${sub.brand})" : ""}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                       subtitle: (sub.barcode != null || sub.notes != null)
                                           ? Text(
                                               sub.barcode != null ? '${AppStrings.barcodeLabel}: ${sub.barcode}' : sub.notes!,
                                               style: const TextStyle(fontSize: 11),
                                             )
                                           : null,
                                      trailing: IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 18),
                                        onPressed: () => setState(() => _draftSubspecies.removeAt(idx)),
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

                    TextField(
                      controller: _descController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: AppStrings.descriptionLabel,
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),
                    const SizedBox(height: 16),

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
        ),
      ),
    );
  }
}
