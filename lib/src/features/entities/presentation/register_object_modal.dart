import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/units_registry.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_tile.dart';
import 'instantiate_species_sheet.dart';

class RegisterObjectModal extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final bool startInCreateSpecies;

  const RegisterObjectModal({
    super.key,
    this.initialLocationId,
    this.startInCreateSpecies = false,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialLocationId,
    bool startInCreateSpecies = false,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegisterObjectModal(
        initialLocationId: initialLocationId,
        startInCreateSpecies: startInCreateSpecies,
      ),
    );
  }

  @override
  ConsumerState<RegisterObjectModal> createState() => _RegisterObjectModalState();
}

class _RegisterObjectModalState extends ConsumerState<RegisterObjectModal> {
  bool _isCreatingNewSpecies = false;

  // Species Creation Controllers
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedType = AppStrings.typeObject;
  String _defaultUnit = UnitsRegistry.countingUnits.first;
  XFile? _selectedImage;
  bool _isSaving = false;

  final List<String> _entityTypes = [
    AppStrings.typeObject,
    AppStrings.typeDocument,
    AppStrings.typeProject,
    AppStrings.typeMemory,
  ];

  @override
  void initState() {
    super.initState();
    _isCreatingNewSpecies = widget.startInCreateSpecies;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _saveNewSpeciesAndInstantiate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.nameLabel)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final storage = ref.read(fileStorageServiceProvider);

      String? relativePhotoPath;
      if (_selectedImage != null) {
        relativePhotoPath = await storage.saveFile(_selectedImage!.path);
      }

      final newSpecies = CatalogItem(
        id: const Uuid().v4(),
        name: name,
        type: _selectedType,
        brand: _brandController.text.trim().isNotEmpty ? _brandController.text.trim() : null,
        description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : null,
        barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
        defaultUnit: _defaultUnit,
        mainPhotoPath: relativePhotoPath,
        createdAt: DateTime.now(),
      );

      await ref.read(catalogListProvider.notifier).saveCatalogItem(newSpecies);

      if (mounted) {
        Navigator.pop(context); // Close RegisterObjectModal
        InstantiateSpeciesSheet.show(
          context,
          species: newSpecies,
          initialLocationId: widget.initialLocationId,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogState = ref.watch(catalogListProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
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
            const SizedBox(height: 16),

            // Header Mode Switcher Tabs
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Elegir del catálogo')),
                    selected: !_isCreatingNewSpecies,
                    onSelected: (val) {
                      if (val) setState(() => _isCreatingNewSpecies = false);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Crear nueva especie')),
                    selected: _isCreatingNewSpecies,
                    onSelected: (val) {
                      if (val) setState(() => _isCreatingNewSpecies = true);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Body: Option 1 (Browse Catalog) vs Option 2 (Create New Species)
            Expanded(
              child: _isCreatingNewSpecies
                  ? _buildCreateSpeciesForm(context, theme)
                  : _buildBrowseCatalogView(context, catalogState),
            ),
          ],
        ),
      ),
    );
  }

  // Pathway 1: Browse existing catalog species
  Widget _buildBrowseCatalogView(BuildContext context, AsyncValue<List<CatalogItem>> catalogState) {
    return catalogState.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.public, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(AppStrings.emptyCatalog),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _isCreatingNewSpecies = true),
                    icon: const Icon(Icons.add),
                    label: const Text('Crear primera especie'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, idx) {
            final item = items[idx];
            return SpeciesTile(
              species: item,
              onInstantiate: () {
                Navigator.pop(context);
                InstantiateSpeciesSheet.show(
                  context,
                  species: item,
                  initialLocationId: widget.initialLocationId,
                );
              },
              onTap: () {
                Navigator.pop(context);
                InstantiateSpeciesSheet.show(
                  context,
                  species: item,
                  initialLocationId: widget.initialLocationId,
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  // Pathway 2: Create new species in catalog
  Widget _buildCreateSpeciesForm(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo Picker
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
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
                image: _selectedImage != null
                    ? DecorationImage(
                        image: FileImage(File(_selectedImage!.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 28, color: theme.colorScheme.primary),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.photoLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: AppStrings.nameLabel,
              prefixIcon: Icon(Icons.auto_awesome),
            ),
          ),
          const SizedBox(height: 12),

          // SI Unit Dropdown Selector
          DropdownButtonFormField<String>(
            initialValue: _defaultUnit,
            decoration: const InputDecoration(
              labelText: AppStrings.unitLabel,
              prefixIcon: Icon(Icons.straighten),
            ),
            items: UnitsRegistry.allSiUnits
                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _defaultUnit = val);
            },
          ),
          const SizedBox(height: 12),

          // Type Chips
          Text(AppStrings.typeLabel, style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _entityTypes.map((type) {
              final isSelected = type == _selectedType;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (val) {
                  if (val) setState(() => _selectedType = type);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _brandController,
            decoration: const InputDecoration(
              labelText: AppStrings.brandLabel,
              prefixIcon: Icon(Icons.branding_watermark),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _barcodeController,
            decoration: const InputDecoration(
              labelText: AppStrings.barcodeLabel,
              prefixIcon: Icon(Icons.qr_code),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: AppStrings.descriptionLabel,
              prefixIcon: Icon(Icons.notes),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveNewSpeciesAndInstantiate,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Guardar e instanciar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
