import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../domain/entity_template.dart';
import '../domain/world_entity.dart';
import 'custom_attribute_editor_dialog.dart';
import 'custom_template_editor_sheet.dart';

class CreateEntitySheet extends ConsumerStatefulWidget {
  final String? initialPlaceId;
  final String? initialParentEntityId;

  const CreateEntitySheet({
    super.key,
    this.initialPlaceId,
    this.initialParentEntityId,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialPlaceId,
    String? initialParentEntityId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateEntitySheet(
        initialPlaceId: initialPlaceId,
        initialParentEntityId: initialParentEntityId,
      ),
    );
  }

  @override
  ConsumerState<CreateEntitySheet> createState() => _CreateEntitySheetState();
}

class _CreateEntitySheetState extends ConsumerState<CreateEntitySheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _qtyController = TextEditingController();
  final _unitController = TextEditingController();

  String _selectedType = 'Objeto / Herramienta';
  String? _selectedPlaceId;
  String? _selectedParentId;
  String? _speciesId;
  XFile? _selectedImage;
  Map<String, dynamic> _customAttrs = {};
  bool _showMore = false;
  bool _isSaving = false;

  final List<String> _entityTypes = [
    'Objeto / Herramienta',
    'Contenedor',
    'Lugar',
    'Documento',
    'Proyecto / Idea',
    'Recuerdo',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPlaceId = widget.initialPlaceId;
    _selectedParentId = widget.initialParentEntityId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
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
      _selectedType = item.defaultType;
      if (item.barcode != null) _barcodeController.text = item.barcode!;
      if (item.description != null) _notesController.text = item.description!;
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty && _selectedImage == null && _barcodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa al menos un nombre, código o fotografía')),
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

      final entityId = const Uuid().v4();
      final finalName = name.isNotEmpty
          ? name
          : (_barcodeController.text.isNotEmpty ? 'Código ${_barcodeController.text.trim()}' : 'Elemento ($_selectedType)');

      final tagsList = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final template = EntityTemplateRegistry.getTemplate(_selectedType);

      final double? parsedQty = template.hasQuantity ? double.tryParse(_qtyController.text.trim()) : null;
      final String? parsedUnit = template.hasQuantity && _unitController.text.trim().isNotEmpty ? _unitController.text.trim() : null;

      final newEntity = WorldEntity(
        id: entityId,
        speciesId: _speciesId,
        name: finalName,
        type: _selectedType,
        mainPhotoPath: relativePhotoPath,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        placeId: _selectedPlaceId,
        parentEntityId: template.canBeInContainer ? _selectedParentId : null,
        quantity: parsedQty,
        unit: parsedUnit,
        barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
        customAttributes: _customAttrs,
        isContainer: template.isContainer,
        isPlace: template.isPlace,
        tags: tagsList,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(entityListProvider.notifier).saveEntity(newEntity);
      await ref.read(activityLoggerServiceProvider).logEntityCreated(entityId, finalName, _selectedType);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$finalName" registrado en tu mundo'),
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
    final placesState = ref.watch(placeListProvider);
    final entitiesState = ref.watch(entityListProvider);
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
                  'Registrar en tu Mundo',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Catalog Quick Import Button (Rule #12 Universe Catalog)
            catalogState.when(
              data: (catalogItems) {
                if (catalogItems.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ActionChip(
                    avatar: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text('Elegir del Universo de Objetos (Catálogo)'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ListView.builder(
                          itemCount: catalogItems.length,
                          itemBuilder: (ctx, i) {
                            final item = catalogItems[i];
                            return ListTile(
                              leading: const Icon(Icons.category),
                              title: Text(item.name),
                              subtitle: Text(item.brand ?? item.defaultType),
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
                height: 120,
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
                          Icon(Icons.add_a_photo_outlined, size: 36, color: theme.colorScheme.primary),
                          const SizedBox(height: 8),
                          Text(
                            'Añadir fotografía (Opcional)',
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
                labelText: 'Nombre del elemento',
                hintText: 'Ej. Multímetro Fluke, Pasaporte, Linterna LED...',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),

            // Reactive Type Selector Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tipo de elemento', style: theme.textTheme.labelLarge),
                TextButton.icon(
                  onPressed: () => CustomTemplateEditorSheet.show(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Crear Tipo', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
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

            // Container Selection (Rule #2 & #3 - Container selection & Inheritance)
            if (template.canBeInContainer) ...[
              Text('Contenedor (Caja / Estante / Maletín)', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              entitiesState.when(
                data: (entities) {
                  final containers = entities.where((e) => e.isContainer).toList();
                  return DropdownButtonFormField<String?>(
                    initialValue: _selectedParentId,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                      hintText: 'Sin contenedor asignado',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(value: null, child: Text('Sin contenedor')),
                      ...containers.map((c) => DropdownMenuItem<String?>(
                            value: c.id,
                            child: Text(c.name),
                          )),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedParentId = val;
                        if (val != null) {
                          final parentContainer = entities.where((e) => e.id == val).firstOrNull;
                          if (parentContainer?.placeId != null) {
                            _selectedPlaceId = parentContainer!.placeId;
                          }
                        }
                      });
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error: $err'),
              ),
              const SizedBox(height: 16),
            ],

            // Location Selector Dropdown (Rule #1 - "Mundo" Default, Rule #3 - Disabled if container assigned)
            Text('Ubicación en tu Mundo', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            placesState.when(
              data: (places) {
                final bool isInheritedFromContainer = _selectedParentId != null;
                return DropdownButtonFormField<String?>(
                  initialValue: _selectedPlaceId,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.place_outlined),
                    hintText: isInheritedFromContainer ? 'Heredado del contenedor' : 'Mundo',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Mundo'),
                    ),
                    ...places.map((p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(p.name),
                        )),
                  ],
                  onChanged: isInheritedFromContainer ? null : (val) => setState(() => _selectedPlaceId = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error al cargar lugares: $err'),
            ),
            const SizedBox(height: 16),

            // Quantities & Units (Rule #4 - Only for physical countable/measurable objects)
            if (template.hasQuantity) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        hintText: 'Ej. 10, 1',
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
                        hintText: 'Ej. piezas, kg, metros',
                        prefixIcon: Icon(Icons.straighten),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Toggle "Mostrar más" / "Mostrar menos" (Rule #6 - Form Parity)
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

              // Custom Attributes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Atributos Personalizados (${_customAttrs.length})', style: theme.textTheme.labelLarge),
                  TextButton.icon(
                    onPressed: () async {
                      final res = await CustomAttributeEditorDialog.show(context, initialAttributes: _customAttrs);
                      if (res != null) setState(() => _customAttrs = res);
                    },
                    icon: const Icon(Icons.tune, size: 16),
                    label: const Text('Administrar'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Notes
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  hintText: 'Detalles u observaciones...',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
              const SizedBox(height: 12),

              // Tags
              TextField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Etiquetas (separadas por coma)',
                  hintText: 'Ej. trabajo, urgente',
                  prefixIcon: Icon(Icons.label_outlined),
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
                    : const Text('Guardar en tu Mundo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
