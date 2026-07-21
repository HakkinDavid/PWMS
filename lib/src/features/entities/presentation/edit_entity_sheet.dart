import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/providers.dart';
import '../domain/entity_template.dart';
import '../domain/world_entity.dart';
import 'custom_attribute_editor_dialog.dart';

class EditEntitySheet extends ConsumerStatefulWidget {
  final WorldEntity entity;

  const EditEntitySheet({super.key, required this.entity});

  static Future<void> show(BuildContext context, WorldEntity entity) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditEntitySheet(entity: entity),
    );
  }

  @override
  ConsumerState<EditEntitySheet> createState() => _EditEntitySheetState();
}

class _EditEntitySheetState extends ConsumerState<EditEntitySheet> {
  late TextEditingController _nameController;
  late TextEditingController _aliasController;
  late TextEditingController _notesController;
  late TextEditingController _tagsController;
  late TextEditingController _qtyController;
  late TextEditingController _unitController;
  late TextEditingController _barcodeController;

  late String _selectedType;
  String? _selectedPlaceId;
  String? _selectedParentId;
  String? _newPhotoPath;
  bool _removePhoto = false;
  late Map<String, dynamic> _customAttrs;
  late bool _isArchived;
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
    _nameController = TextEditingController(text: widget.entity.name);
    _aliasController = TextEditingController(text: widget.entity.alias ?? '');
    _notesController = TextEditingController(text: widget.entity.notes ?? '');
    _tagsController = TextEditingController(text: widget.entity.tags.join(', '));
    _qtyController = TextEditingController(text: widget.entity.quantity?.toString() ?? '');
    _unitController = TextEditingController(text: widget.entity.unit ?? '');
    _barcodeController = TextEditingController(text: widget.entity.barcode ?? '');

    _selectedType = widget.entity.type;
    _selectedPlaceId = widget.entity.placeId;
    _selectedParentId = widget.entity.parentEntityId;
    _customAttrs = Map<String, dynamic>.from(widget.entity.customAttributes);
    _isArchived = widget.entity.isArchived;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _pickNewPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      final storage = ref.read(fileStorageServiceProvider);
      final savedRelativePath = await storage.saveFile(image.path);
      setState(() {
        _newPhotoPath = savedRelativePath;
        _removePhoto = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final tagsList = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final template = EntityTemplateRegistry.getTemplate(_selectedType);
      final double? parsedQty = template.hasQuantity ? double.tryParse(_qtyController.text.trim()) : null;
      final String? parsedUnit = template.hasQuantity && _unitController.text.trim().isNotEmpty ? _unitController.text.trim() : null;
      final String? parsedBarcode = _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null;

      String? finalPhotoPath = widget.entity.mainPhotoPath;
      if (_removePhoto) {
        finalPhotoPath = null;
      } else if (_newPhotoPath != null) {
        finalPhotoPath = _newPhotoPath;
      }

      final updatedEntity = widget.entity.copyWith(
        name: name,
        alias: _aliasController.text.trim().isNotEmpty ? _aliasController.text.trim() : null,
        type: _selectedType,
        mainPhotoPath: finalPhotoPath,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        placeId: _selectedPlaceId,
        parentEntityId: template.canBeInContainer ? _selectedParentId : null,
        quantity: parsedQty,
        unit: parsedUnit,
        barcode: parsedBarcode,
        customAttributes: _customAttrs,
        isArchived: _isArchived,
        isContainer: template.isContainer,
        isPlace: template.isPlace,
        tags: tagsList,
        updatedAt: DateTime.now(),
      );

      await ref.read(entityListProvider.notifier).saveEntity(updatedEntity);
      await ref.read(activityLoggerServiceProvider).logEntityEdited(widget.entity.id, name);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${updatedEntity.name}" actualizado con éxito'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
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
                  'Editar "${widget.entity.name}"',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Photo preview
            Row(
              children: [
                FutureBuilder<String>(
                  future: (_newPhotoPath != null)
                      ? ref.read(fileStorageServiceProvider).getAbsolutePath(_newPhotoPath!)
                      : (widget.entity.mainPhotoPath != null && !_removePhoto)
                          ? ref.read(fileStorageServiceProvider).getAbsolutePath(widget.entity.mainPhotoPath!)
                          : Future.value(''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(snapshot.data!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: const Icon(Icons.no_photography, color: Colors.grey),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _pickNewPhoto,
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: const Text('Cambiar Fotografía'),
                    ),
                    if (widget.entity.mainPhotoPath != null || _newPhotoPath != null)
                      TextButton.icon(
                        onPressed: () => setState(() => _removePhoto = true),
                        icon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
                        label: const Text('Quitar Fotografía', style: TextStyle(color: Colors.redAccent)),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name & Alias
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _aliasController,
              decoration: const InputDecoration(
                labelText: 'Alias / Nombre secundario',
                prefixIcon: Icon(Icons.label_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                labelText: 'Código de barras / Identificador',
                prefixIcon: Icon(Icons.qr_code_scanner),
              ),
            ),
            const SizedBox(height: 16),

            // Type Selector
            Text('Tipo de Elemento', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.category)),
              items: _entityTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedType = val);
              },
            ),
            const SizedBox(height: 16),

            // Container Selection (Rule #2 & #3)
            if (template.canBeInContainer) ...[
              Text('Contenedor (Caja / Estante / Maletín)', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              entitiesState.when(
                data: (entities) {
                  final containers = entities.where((e) => e.isContainer && e.id != widget.entity.id).toList();
                  return DropdownButtonFormField<String?>(
                    initialValue: _selectedParentId,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                      hintText: 'Sin contenedor asignado',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(value: null, child: Text('Sin contenedor')),
                      ...containers.map((c) => DropdownMenuItem<String?>(value: c.id, child: Text(c.name))),
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

            // Location (Rule #1 - "Mundo", Rule #3 - Inherited if container set)
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
                    const DropdownMenuItem<String?>(value: null, child: Text('Mundo')),
                    ...places.map((p) => DropdownMenuItem<String?>(value: p.id, child: Text(p.name))),
                  ],
                  onChanged: isInheritedFromContainer ? null : (val) => setState(() => _selectedPlaceId = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 16),

            // Quantities & Units (Rule #4 - Only for physical objects)
            if (template.hasQuantity) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        hintText: 'Ej. 10, 2.5',
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

            // Custom Attributes trigger button & chip list
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
                  label: const Text('Administrar Atributos'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Archive Toggle
            SwitchListTile(
              title: const Text('Archivar elemento (Ocultar de la vista principal)'),
              value: _isArchived,
              onChanged: (val) => setState(() => _isArchived = val),
            ),
            const SizedBox(height: 16),

            // Notes
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notas',
                hintText: 'Escribe detalles, especificaciones, referencias...',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 16),

            // Tags
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Etiquetas (separadas por coma)',
                prefixIcon: Icon(Icons.style),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar Cambios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
