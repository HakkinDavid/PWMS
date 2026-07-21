import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../domain/entity_template.dart';
import '../domain/world_entity.dart';

class CreateEntitySheet extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final CatalogItem? initialSpecies;

  const CreateEntitySheet({
    super.key,
    this.initialLocationId,
    this.initialSpecies,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialLocationId,
    CatalogItem? initialSpecies,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateEntitySheet(
        initialLocationId: initialLocationId,
        initialSpecies: initialSpecies,
      ),
    );
  }

  @override
  ConsumerState<CreateEntitySheet> createState() => _CreateEntitySheetState();
}

class _CreateEntitySheetState extends ConsumerState<CreateEntitySheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _qtyController = TextEditingController();
  final _unitController = TextEditingController();

  String _selectedType = AppStrings.typeObject;
  String? _selectedLocationId;
  String? _speciesId;
  XFile? _selectedImage;
  bool _showMore = false;
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
    _selectedLocationId = widget.initialLocationId;

    if (widget.initialSpecies != null) {
      _selectFromCatalog(widget.initialSpecies!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _barcodeController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  void _selectFromCatalog(CatalogItem item) {
    setState(() {
      _speciesId = item.id;
      _nameController.text = item.name;
      _selectedType = item.type;
      if (item.barcode != null) _barcodeController.text = item.barcode!;
      if (item.description != null) _notesController.text = item.description!;
    });
  }

  Future<void> _pickLocationFromTree() async {
    final selectedId = await LocationTreePicker.show(context, initialSelectedId: _selectedLocationId);
    setState(() {
      _selectedLocationId = selectedId;
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty && _selectedImage == null && _barcodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.nameLabel)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final catalogRepo = ref.read(catalogRepositoryProvider);
      final storage = ref.read(fileStorageServiceProvider);

      String? relativePhotoPath;
      if (_selectedImage != null) {
        relativePhotoPath = await storage.saveFile(_selectedImage!.path);
      }

      CatalogItem species;
      if (_speciesId != null) {
        final found = await catalogRepo.getCatalogItemById(_speciesId!);
        species = found ??
            await catalogRepo.getOrCreateSpecies(
              name,
              type: _selectedType,
              mainPhotoPath: relativePhotoPath,
              barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
            );
      } else {
        species = await catalogRepo.getOrCreateSpecies(
          name.isNotEmpty ? name : AppStrings.typeObject,
          type: _selectedType,
          description: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          mainPhotoPath: relativePhotoPath,
          barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
        );
      }

      // Rule #5: Single Instance Restriction for Non-countable Abstract Species
      final template = EntityTemplateRegistry.getTemplate(_selectedType);
      if (!template.hasQuantity) {
        final existingEntities = ref.read(entityListProvider).asData?.value ?? [];
        final alreadyExists = existingEntities.any((e) => e.speciesId == species.id);
        if (alreadyExists) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.singleInstanceError),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }
      }

      final entityId = const Uuid().v4();
      final double? parsedQty = template.hasQuantity ? double.tryParse(_qtyController.text.trim()) : null;
      final String? parsedUnit = template.hasQuantity && _unitController.text.trim().isNotEmpty ? _unitController.text.trim() : null;

      final newEntity = WorldEntity(
        id: entityId,
        speciesId: species.id,
        locationId: _selectedLocationId,
        quantity: parsedQty,
        unit: parsedUnit,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(entityListProvider.notifier).saveEntity(newEntity);
      ref.read(catalogListProvider.notifier).loadCatalog();
      await ref.read(activityLoggerServiceProvider).logEntityCreated(entityId, species.name, _selectedType);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${species.name}" registrado'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
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
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);
    final template = EntityTemplateRegistry.getTemplate(_selectedType);

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
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.registerObjectTitle,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Select from Master Catalog
            catalogState.when(
              data: (items) {
                if (items.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ActionChip(
                    avatar: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text(AppStrings.chooseFromCatalog),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (ctx, i) {
                            final item = items[i];
                            return ListTile(
                              leading: const Icon(Icons.category),
                              title: Text(item.name),
                              subtitle: Text('${item.brand ?? ""} • ${item.type}'),
                              onTap: () {
                                Navigator.pop(ctx);
                                _selectFromCatalog(item);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

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
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
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
                          Icon(Icons.add_a_photo_outlined, size: 32, color: theme.colorScheme.primary),
                          const SizedBox(height: 6),
                          Text(
                            AppStrings.photoLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Name Field
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: AppStrings.nameLabel,
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),

            // Type Choice Chips
            Text(AppStrings.typeLabel, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
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
            const SizedBox(height: 16),

            // Reusable Location Picker Button
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
            const SizedBox(height: 16),

            // Quantities & Units
            if (template.hasQuantity) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: AppStrings.quantityLabel,
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.unitLabel,
                        prefixIcon: Icon(Icons.straighten),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Toggle Additional Fields
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _showMore = !_showMore),
                icon: Icon(_showMore ? Icons.expand_less : Icons.expand_more),
                label: Text(_showMore ? AppStrings.showFewerFields : AppStrings.showMoreFields),
              ),
            ),

            if (_showMore) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: AppStrings.barcodeLabel,
                  prefixIcon: Icon(Icons.qr_code_scanner),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: AppStrings.notesLabel,
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Save Action Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(AppStrings.registerAction, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
