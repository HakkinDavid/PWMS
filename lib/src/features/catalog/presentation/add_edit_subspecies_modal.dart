import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';
import 'web_image_picker_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    final initial = widget.initialSubspecies;
    _selectedSpeciesId = widget.species?.id ?? initial?.speciesId;
    _nameController = TextEditingController(text: initial?.subspeciesName ?? '');
    _brandController = TextEditingController(text: initial?.brand ?? '');
    _barcodeController = TextEditingController(text: initial?.barcode ?? '');
    _notesController = TextEditingController(text: initial?.notes ?? '');
    _photoPath = initial?.photoPath;
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

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      String? finalPhotoPath = _photoPath;

      if (_newPickedImage != null) {
        final storage = ref.read(fileStorageServiceProvider);
        finalPhotoPath = await storage.saveFile(_newPickedImage!.path);
      }

      final targetSpeciesId = widget.species?.id ?? widget.initialSubspecies?.speciesId ?? _selectedSpeciesId ?? '';

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
        Navigator.pop(context, resultSubspecies);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, 'Error al guardar subespecie: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // Web Image Search strictly for Subspecies data (Point 4)
  Future<void> _searchSubspeciesWebImage() async {
    final name = _nameController.text.trim();
    final brand = _brandController.text.trim();

    // Query exclusively uses Subspecies name and brand (Point 4)
    final query = [if (name.isNotEmpty) name, if (brand.isNotEmpty) brand].join(' ');
    final finalQuery = query.isNotEmpty ? query : (widget.species?.name ?? widget.defaultSpeciesName ?? '');

    final relPath = await WebImagePickerDialog.show(
      context,
      searchQuery: finalQuery,
      targetSubspecies: widget.initialSubspecies,
    );
    if (relPath != null && relPath.isNotEmpty && mounted) {
      setState(() {
        _photoPath = relPath;
        _newPickedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialSubspecies != null;
    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
    
    _selectedSpeciesId ??= catalogItems.firstOrNull?.id;

    final isObjectMode = widget.species == null
        ? widget.isObject
        : widget.species!.type == AppStrings.typeObject;

    return AlertDialog(
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
              DropdownButtonFormField<String>(
                initialValue: catalogItems.any((c) => c.id == _selectedSpeciesId) ? _selectedSpeciesId : catalogItems.first.id,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.public),
                  isDense: true,
                ),
                items: catalogItems.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.name} (${c.type})', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSpeciesId = val);
                },
              ),
              const SizedBox(height: 12),
            ],

            // Photo Picker Box
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                if (img != null && mounted) {
                  setState(() => _newPickedImage = img);
                }
              },
              child: Container(
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
                      ? Image.file(File(_newPickedImage!.path), fit: BoxFit.cover)
                      : (_photoPath != null && _photoPath!.isNotEmpty)
                          ? FutureBuilder<String>(
                              future: ref.read(fileStorageServiceProvider).getAbsolutePath(_photoPath!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                  return Image.file(
                                    File(snapshot.data!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                                  );
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
            ),
            const SizedBox(height: 6),

            // Web Image Search Button strictly for Subspecies (Point 4)
            Center(
              child: TextButton.icon(
                onPressed: _searchSubspeciesWebImage,
                icon: const Icon(Icons.image_search, size: 16),
                label: const Text(AppStrings.searchPhotoOnWebAction),
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
          onPressed: _isSaving ? null : () => Navigator.pop(context),
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
  }
}
