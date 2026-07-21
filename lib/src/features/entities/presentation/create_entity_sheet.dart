import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/world_entity.dart';

class CreateEntitySheet extends ConsumerStatefulWidget {
  const CreateEntitySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateEntitySheet(),
    );
  }

  @override
  ConsumerState<CreateEntitySheet> createState() => _CreateEntitySheetState();
}

class _CreateEntitySheetState extends ConsumerState<CreateEntitySheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();

  String _selectedType = 'Herramienta';
  String? _selectedPlaceId;
  XFile? _selectedImage;
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa al menos un nombre o selecciona una fotografía')),
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
      final finalName = name.isNotEmpty ? name : 'Sin Nombre ($_selectedType)';

      final tagsList = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final newEntity = WorldEntity(
        id: entityId,
        name: finalName,
        type: _selectedType,
        mainPhotoPath: relativePhotoPath,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        placeId: _selectedPlaceId,
        tags: tagsList,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(entityListProvider.notifier).saveEntity(newEntity);

      // Auto log event
      await ref.read(activityLoggerServiceProvider).logEntityCreated(entityId, finalName, _selectedType);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$finalName" registrado exitosamente en tu mundo'),
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
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
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
            // Handle bar
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
            const SizedBox(height: 16),

            // Photo Capture Picker Area
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
                height: 140,
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
            const SizedBox(height: 20),

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

            // Type Selector Chips
            Text('Tipo de elemento', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _entityTypes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final type = _entityTypes[index];
                  final isSelected = type == _selectedType;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedType = type);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Location Selector Dropdown
            Text('Ubicación (Lugar)', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            placesState.when(
              data: (places) {
                return DropdownButtonFormField<String?>(
                  initialValue: _selectedPlaceId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.place_outlined),
                    hintText: 'Sin ubicación asignada',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Sin ubicación'),
                    ),
                    ...places.map((p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(p.name),
                        )),
                  ],
                  onChanged: (val) => setState(() => _selectedPlaceId = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error al cargar lugares: $err'),
            ),
            const SizedBox(height: 16),

            // Optional Tags
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Etiquetas (separadas por coma)',
                hintText: 'Ej. trabajo, urgente, garaje',
                prefixIcon: Icon(Icons.label_outlined),
              ),
            ),
            const SizedBox(height: 24),

            // Action Button
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
                    : const Text(
                        'Guardar en tu Mundo',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
