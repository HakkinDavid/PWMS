import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/providers.dart';
import '../domain/entity_template.dart';
import '../domain/world_entity.dart';

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

  late String _selectedType;
  String? _selectedPlaceId;
  String? _newPhotoPath;
  bool _removePhoto = false;
  bool _isSaving = false;

  final List<String> _entityTypes = [
    'Herramienta',
    'Caja / Contenedor',
    'Documento',
    'Vehículo',
    'Animal',
    'Proyecto',
    'Idea',
    'Recuerdo',
    'Lugar',
    'Otro',
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

    _selectedType = widget.entity.type;
    _selectedPlaceId = widget.entity.placeId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
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

      final double? parsedQty = double.tryParse(_qtyController.text.trim());
      final String? parsedUnit = _unitController.text.trim().isNotEmpty ? _unitController.text.trim() : null;

      String? finalPhotoPath = widget.entity.mainPhotoPath;
      if (_removePhoto) {
        finalPhotoPath = null;
      } else if (_newPhotoPath != null) {
        finalPhotoPath = _newPhotoPath;
      }

      final isContainer = EntityTemplateRegistry.isContainer(_selectedType);
      final isPlace = EntityTemplateRegistry.isPlace(_selectedType);

      final updatedEntity = widget.entity.copyWith(
        name: name,
        alias: _aliasController.text.trim().isNotEmpty ? _aliasController.text.trim() : null,
        type: _selectedType,
        mainPhotoPath: finalPhotoPath,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        placeId: _selectedPlaceId,
        quantity: parsedQty,
        unit: parsedUnit,
        isContainer: isContainer,
        isPlace: isPlace,
        tags: tagsList,
        updatedAt: DateTime.now(),
      );

      await ref.read(entityListProvider.notifier).saveEntity(updatedEntity);

      // Audit log
      await ref.read(activityLoggerServiceProvider).logEntityEdited(
            widget.entity.id,
            name,
            details: 'Información y metadatos actualizados',
          );

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
    final theme = Theme.of(context);

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

            // Photo update preview
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
            const SizedBox(height: 16),

            // Type Selector
            Text('Plantilla de Tipo', style: theme.textTheme.labelLarge),
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

            // Quantities & Units
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

            // Location
            Text('Ubicación (Lugar)', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            placesState.when(
              data: (places) {
                return DropdownButtonFormField<String?>(
                  initialValue: _selectedPlaceId,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.place_outlined)),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Sin ubicación')),
                    ...places.map((p) => DropdownMenuItem<String?>(value: p.id, child: Text(p.name))),
                  ],
                  onChanged: (val) => setState(() => _selectedPlaceId = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
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
