import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';
import '../../entities/domain/entity_template.dart';
import 'standard_media_picker_sheet.dart';

class AddEditSubspeciesModal extends ConsumerStatefulWidget {
  final CatalogItem? species;
  final Subspecies? initialSubspecies;
  final String? defaultSpeciesName;
  final bool isObject;
  final bool isFromAutoFill;

  const AddEditSubspeciesModal({
    super.key,
    this.species,
    this.initialSubspecies,
    this.defaultSpeciesName,
    this.isObject = true,
    this.isFromAutoFill = false,
  });

  static Future<Subspecies?> show(
    BuildContext context, {
    CatalogItem? species,
    Subspecies? initialSubspecies,
    String? defaultSpeciesName,
    bool isObject = true,
    bool isFromAutoFill = false,
  }) async {
    return showDialog<Subspecies?>(
      context: context,
      builder: (_) => AddEditSubspeciesModal(
        species: species,
        initialSubspecies: initialSubspecies,
        defaultSpeciesName: defaultSpeciesName,
        isObject: isObject,
        isFromAutoFill: isFromAutoFill,
      ),
    );
  }

  @override
  ConsumerState<AddEditSubspeciesModal> createState() => _AddEditSubspeciesModalState();
}

class _AddEditSubspeciesModalState extends ConsumerState<AddEditSubspeciesModal> {
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _barcodeController;
  late TextEditingController _notesController;

  String? _selectedSpeciesId;
  String? _photoPath;
  XFile? _newPickedImage;
  Future<String>? _resolvedPhotoPathFuture;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialSubspecies;
    _selectedSpeciesId = widget.species?.id ?? initial?.speciesId;
    _nameController = TextEditingController(text: initial?.subspeciesName ?? AppTechnicalStrings.empty);
    _brandController = TextEditingController(text: initial?.brand ?? AppTechnicalStrings.empty);
    _barcodeController = TextEditingController(text: initial?.barcode ?? AppTechnicalStrings.empty);
    _notesController = TextEditingController(text: initial?.notes ?? AppTechnicalStrings.empty);
    _photoPath = initial?.photoPath;
    if (_photoPath != null && _photoPath!.isNotEmpty) {
      _resolvedPhotoPathFuture = ref.read(fileStorageServiceProvider).getAbsolutePath(_photoPath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _isSaving = false;
  bool _photoDeleted = false;
  bool _forceClose = false;

  bool _hasUnsavedChanges() {
    final initial = widget.initialSubspecies;
    if (initial != null) {
      if (_nameController.text.trim() != initial.subspeciesName.trim()) return true;
      if (_brandController.text.trim() != (initial.brand ?? AppTechnicalStrings.empty).trim()) return true;
      if (_barcodeController.text.trim() != (initial.barcode ?? AppTechnicalStrings.empty).trim()) return true;
      if (_notesController.text.trim() != (initial.notes ?? AppTechnicalStrings.empty).trim()) return true;
      if (_newPickedImage != null || _photoDeleted) return true;
      return false;
    } else {
      if (_nameController.text.trim().isNotEmpty) return true;
      if (_brandController.text.trim().isNotEmpty) return true;
      if (_barcodeController.text.trim().isNotEmpty) return true;
      if (_notesController.text.trim().isNotEmpty) return true;
      if (_newPickedImage != null) return true;
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

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppToast.showRestriction(context, AppStrings.subspeciesNameLabel);
      return;
    }

    setState(() => _isSaving = true);

    try {
      String? finalPhotoPath = _photoPath;

      if (_newPickedImage != null) {
        final storage = ref.read(fileStorageServiceProvider);
        finalPhotoPath = await storage.saveFile(_newPickedImage!.path);
      } else if (_photoDeleted) {
        finalPhotoPath = null;
      }

      final targetSpeciesId = widget.species?.id ?? widget.initialSubspecies?.speciesId ?? _selectedSpeciesId ?? AppTechnicalStrings.empty;

      final resultSubspecies = Subspecies(
        id: widget.initialSubspecies?.id ?? const Uuid().v4(),
        speciesId: targetSpeciesId,
        subspeciesName: name,
        brand: _brandController.text.trim().isNotEmpty ? _brandController.text.trim() : null,
        barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
        photoPath: finalPhotoPath,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        createdAt: widget.initialSubspecies?.createdAt ?? DateTime.now(),
      );

      if (mounted) {
        _forceClose = true;
        Navigator.pop(context, resultSubspecies);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, AppStrings.saveSubspeciesError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialSubspecies != null;
    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
    
    if (widget.isFromAutoFill) {
      _selectedSpeciesId ??= catalogItems.firstOrNull?.id;
    }

    final isObjectMode = widget.species == null
        ? widget.isObject
        : EntityTemplateRegistry.hasBarcodeAndBrand(widget.species!.type);

    final dialog = AlertDialog(
      title: Text(
        isEditing ? AppStrings.editSubspecies : AppStrings.newSubspeciesVariantTitle,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Punto 9: Desplegable de selección de Especie (únicamente si es llenado automático)
            if (widget.isFromAutoFill && catalogItems.isNotEmpty) ...[
              const Text(AppStrings.associatedSpeciesLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              AppWheelPickerField<String>(
                value: catalogItems.any((c) => c.id == _selectedSpeciesId) ? _selectedSpeciesId : catalogItems.first.id,
                items: catalogItems.map((c) => c.id).toList(),
                labelBuilder: (id) {
                  final found = catalogItems.where((c) => c.id == id).firstOrNull;
                  return found != null ? AppStrings.nameWithType(found.name, found.type) : id;
                },
                title: AppStrings.associatedSpeciesLabel,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.public),
                  isDense: true,
                ),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSpeciesId = val);
                },
              ),
              const SizedBox(height: 12),
            ],

            // Photo Picker Box
            GestureDetector(
              onTap: () async {
                final name = _nameController.text.trim();
                final brand = _brandController.text.trim();
                final query = [if (name.isNotEmpty) name, if (brand.isNotEmpty) brand].join(AppTechnicalStrings.space);
                final finalQuery = query.isNotEmpty ? query : (widget.species?.name ?? widget.defaultSpeciesName ?? AppTechnicalStrings.empty);

                final result = await StandardMediaPickerSheet.show(
                  context,
                  title: AppStrings.subspeciesPhotoTitle,
                  webSearchQuery: finalQuery,
                  allowDocuments: false,
                );
                if (result != null && mounted) {
                  if (result.file != null) {
                    setState(() {
                      _newPickedImage = XFile(result.file!.path);
                      _photoPath = null;
                      _photoDeleted = false;
                    });
                  } else if (result.relativeStoredPath != null) {
                    setState(() {
                      _photoPath = result.relativeStoredPath;
                      _resolvedPhotoPathFuture = ref.read(fileStorageServiceProvider).getAbsolutePath(result.relativeStoredPath!);
                      _newPickedImage = null;
                      _photoDeleted = false;
                    });
                  }
                }
              },
              child: Stack(
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _newPickedImage != null
                          ? Image.file(
                              File(_newPickedImage!.path),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                            )
                          : (_photoPath != null && _photoPath!.isNotEmpty)
                              ? FutureBuilder<String>(
                                  future: _resolvedPhotoPathFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                        return Image.file(
                                          File(snapshot.data!),
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                                        );
                                      }
                                      return const Icon(Icons.broken_image_outlined, size: 28);
                                    }
                                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                  },
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_outlined, size: 22),
                                    SizedBox(height: 4),
                                    Text(AppStrings.subspeciesPhotoLabel, style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                    ),
                  ),
                  if (_newPickedImage != null || (_photoPath != null && _photoPath!.isNotEmpty))
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
                                _newPickedImage = null;
                                _photoPath = null;
                                _resolvedPhotoPathFuture = null;
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
            const SizedBox(height: 8),

            // Subspecies Variant Name TextField
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: AppStrings.subspeciesNameLabel,
                prefixIcon: Icon(Icons.style),
                isDense: true,
              ),
            ),

            if (isObjectMode) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: AppStrings.brandOptionalLabel,
                  prefixIcon: Icon(Icons.branding_watermark),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: AppStrings.barcodeOptionalLabel,
                  prefixIcon: Icon(Icons.qr_code),
                  isDense: true,
                ),
              ),
            ],

            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: AppStrings.specialNotesOptionalLabel,
                prefixIcon: Icon(Icons.notes),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () async {
                  final canClose = await _requestClose();
                  if (canClose && context.mounted) {
                    Navigator.pop(context);
                  }
                },
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          child: _isSaving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text(AppStrings.save),
        ),
      ],
    );

    return PopScope(
      canPop: _forceClose,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canClose = await _requestClose();
        if (canClose && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: dialog,
    );
  }
}
