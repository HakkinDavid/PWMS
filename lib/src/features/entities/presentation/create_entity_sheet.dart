import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../domain/entity_template.dart';
import '../domain/world_entity.dart';

class CreateEntitySheet extends ConsumerStatefulWidget {
  final String? initialLocationId;

  const CreateEntitySheet({
    super.key,
    this.initialLocationId,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialLocationId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateEntitySheet(initialLocationId: initialLocationId),
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

  String _selectedType = 'Objeto / Herramienta';
  String? _selectedLocationId;
  String? _speciesId;
  XFile? _selectedImage;
  bool _showMore = false;
  bool _isSaving = false;

  final List<String> _entityTypes = [
    'Objeto / Herramienta',
    'Documento',
    'Proyecto / Idea',
    'Recuerdo',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
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

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty && _selectedImage == null && _barcodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa al menos un nombre o fotografía')),
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

      // Rule #2 & #3: Auto-create Species in Catalog if not selecting existing
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
          name.isNotEmpty ? name : 'Elemento ($_selectedType)',
          type: _selectedType,
          description: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          mainPhotoPath: relativePhotoPath,
          barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
        );
      }

      final entityId = const Uuid().v4();
      final template = EntityTemplateRegistry.getTemplate(_selectedType);

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
            content: Text('"${species.name}" registrado en tu mundo'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsState = ref.watch(locationNodeListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);
    final template = EntityTemplateRegistry.getTemplate(_selectedType);

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
                  'Registrar Objeto en tu Mundo',
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
                    label: const Text('Elegir Especie del Catálogo Maestro'),
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
                              subtitle: Text('${item.brand ?? "Sin marca"} • ${item.type}'),
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

            // Photo Capture Picker
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Tomar fotografía'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Elegir de galería'),
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
                            'Fotografía del objeto (Opcional)',
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
                labelText: 'Nombre del objeto / especie',
                hintText: 'Ej. Multímetro Fluke 87V, Taladro Bosch 18V...',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),

            // Type Chips
            Text('Tipo de objeto', style: theme.textTheme.labelLarge),
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

            // Location Graph Selector Node
            Text('Ubicación en el Grafo (Lugar o Contenedor)', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            locationsState.when(
              data: (nodes) {
                return DropdownButtonFormField<String?>(
                  initialValue: _selectedLocationId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_tree_outlined),
                    hintText: 'Mundo',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Mundo (Raíz)'),
                    ),
                    ...nodes.map((n) => DropdownMenuItem<String?>(
                          value: n.id,
                          child: Text(n.name),
                        )),
                  ],
                  onChanged: (val) => setState(() => _selectedLocationId = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error al cargar nodo de ubicación: $err'),
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
                        labelText: 'Cantidad de ejemplares',
                        hintText: 'Ej. 1, 10',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unidad',
                        hintText: 'Ej. piezas, kg',
                        prefixIcon: Icon(Icons.straighten),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Toggle "Mostrar campos adicionales"
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _showMore = !_showMore),
                icon: Icon(_showMore ? Icons.expand_less : Icons.expand_more),
                label: Text(_showMore ? 'Mostrar menos' : 'Mostrar campos adicionales'),
              ),
            ),

            if (_showMore) ...[
              const SizedBox(height: 12),
              // Barcode Field
              TextField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Código de barras / Identificador',
                  hintText: 'Ej. 750123456789',
                  prefixIcon: Icon(Icons.qr_code_scanner),
                ),
              ),
              const SizedBox(height: 12),

              // Notes / Serial
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notas / Número de serie de esta instancia',
                  hintText: 'Detalles particulares de este ejemplar...',
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
                    : const Text('Registrar Instancia en tu Mundo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
