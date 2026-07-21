import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/species_magnitude.dart';
import '../../catalog/presentation/species_tile.dart';
import '../domain/entity_template.dart';
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
  String _defaultUnit = 'kg';
  bool _isUnique = false;
  bool _hasMonetaryValue = true;
  String _currency = 'MXN';
  XFile? _selectedImage;
  bool _isSaving = false;

  // Multiplicity of Magnitudes
  final List<SpeciesMagnitude> _additionalMagnitudes = [];

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
    _isCreatingNewSpecies = widget.startInCreateSpecies;
    _updateDefaultUnit();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _updateDefaultUnit() {
    final allowed = DomainRules.getAllowedUnitsForSpecies(isUnique: _isUnique);
    if (!allowed.contains(_defaultUnit)) {
      _defaultUnit = allowed.first;
    }
  }

  void _applySubgroupConstraints(String type) {
    final template = EntityTemplateRegistry.getTemplate(type);
    setState(() {
      _selectedType = type;
      if (template.isAlwaysUnique) {
        _isUnique = true;
      }
      if (!template.hasMonetaryValue) {
        _hasMonetaryValue = false;
      } else {
        _hasMonetaryValue = true;
      }
      _updateDefaultUnit();
    });
  }

  void _populateFromBaseTemplate(CatalogItem base) {
    setState(() {
      _selectedType = base.type;
      _brandController.text = base.brand ?? '';
      _descController.text = base.description ?? '';
      _isUnique = base.isUnique;
      _hasMonetaryValue = base.hasMonetaryValue;
      _currency = base.defaultMonetaryCurrency;
      _updateDefaultUnit();
      if (base.defaultUnit != null && DomainRules.isUnitAllowedForSpecies(unitSymbol: base.defaultUnit!, isUnique: _isUnique)) {
        _defaultUnit = base.defaultUnit!;
      }
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

  Future<void> _saveNewSpeciesAndInstantiate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.nameLabel)),
      );
      return;
    }

    // Single Source of Truth Rule Check (Rule #8)
    final template = EntityTemplateRegistry.getTemplate(_selectedType);
    final effectiveUnique = template.isAlwaysUnique || _isUnique;
    if (template.hasQuantity && !DomainRules.isUnitAllowedForSpecies(unitSymbol: _defaultUnit, isUnique: effectiveUnique)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Una Especie Única no puede asociarse con la unidad "pieza".')),
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
        brand: template.hasBarcodeAndBrand && _brandController.text.trim().isNotEmpty ? _brandController.text.trim() : null,
        description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : null,
        barcode: template.hasBarcodeAndBrand && _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
        defaultUnit: template.hasQuantity ? _defaultUnit : null,
        magnitudes: _additionalMagnitudes,
        isUnique: effectiveUnique,
        hasMonetaryValue: template.hasMonetaryValue && _hasMonetaryValue,
        defaultMonetaryCurrency: _currency,
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
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
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
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.78,
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

            // Header Mode Switcher Tabs
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    visualDensity: VisualDensity.compact,
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
                    visualDensity: VisualDensity.compact,
                    label: const Center(child: Text('Crear nueva especie')),
                    selected: _isCreatingNewSpecies,
                    onSelected: (val) {
                      if (val) setState(() => _isCreatingNewSpecies = true);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Body: Option 1 (Browse Catalog) vs Option 2 (Create New Species)
            Expanded(
              child: _isCreatingNewSpecies
                  ? _buildCreateSpeciesForm(context, theme, catalogState)
                  : _buildBrowseCatalogView(context, catalogState),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildCreateSpeciesForm(BuildContext context, ThemeData theme, AsyncValue<List<CatalogItem>> catalogState) {
    final existingItems = catalogState.asData?.value ?? [];
    final template = EntityTemplateRegistry.getTemplate(_selectedType);
    final allowedUnits = DomainRules.getAllowedUnitsForSpecies(isUnique: template.isAlwaysUnique || _isUnique);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pre-populate from base template
          if (existingItems.isNotEmpty) ...[
            DropdownButtonFormField<CatalogItem?>(
              decoration: const InputDecoration(
                labelText: 'Usar especie como plantilla base',
                prefixIcon: Icon(Icons.copy),
              ),
              items: [
                const DropdownMenuItem<CatalogItem?>(value: null, child: Text('Sin plantilla (nueva vacía)')),
                ...existingItems.map((item) => DropdownMenuItem<CatalogItem?>(value: item, child: Text('${item.name} (${item.type})'))),
              ],
              onChanged: (base) {
                if (base != null) _populateFromBaseTemplate(base);
              },
            ),
            const SizedBox(height: 10),
          ],

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
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
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

          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: AppStrings.nameLabel,
              prefixIcon: Icon(Icons.auto_awesome),
            ),
          ),
          const SizedBox(height: 10),

          // Subgroup Type Chips
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
                onSelected: (val) {
                  if (val) _applySubgroupConstraints(type);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Rule #6 & #8: Unique Checkbox (No "pieza" for unique species!)
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
                      _updateDefaultUnit();
                    });
                  },
          ),

          if (template.hasMonetaryValue) ...[
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('Permitir valor monetario', style: TextStyle(fontSize: 13)),
              value: _hasMonetaryValue,
              onChanged: (val) => setState(() => _hasMonetaryValue = val ?? true),
            ),
            if (_hasMonetaryValue) ...[
              DropdownButtonFormField<String>(
                initialValue: _currency,
                decoration: const InputDecoration(labelText: AppStrings.currencyLabel),
                items: const [
                  DropdownMenuItem(value: 'MXN', child: Text('MXN')),
                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _currency = val);
                },
              ),
              const SizedBox(height: 10),
            ],
          ],

          // SI Unit Dropdown Selector (Filtered by DomainRules)
          if (template.hasQuantity) ...[
            DropdownButtonFormField<String>(
              initialValue: allowedUnits.contains(_defaultUnit) ? _defaultUnit : allowedUnits.first,
              decoration: const InputDecoration(
                labelText: AppStrings.unitLabel,
                prefixIcon: Icon(Icons.straighten),
              ),
              items: allowedUnits
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _defaultUnit = val);
              },
            ),
            const SizedBox(height: 10),
          ],

          if (template.hasBarcodeAndBrand) ...[
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: AppStrings.brandLabel,
                prefixIcon: Icon(Icons.branding_watermark),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                labelText: AppStrings.barcodeLabel,
                prefixIcon: Icon(Icons.qr_code),
              ),
            ),
            const SizedBox(height: 10),
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
              onPressed: _isSaving ? null : _saveNewSpeciesAndInstantiate,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Guardar e instanciar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
