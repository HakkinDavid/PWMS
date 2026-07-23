import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/subspecies.dart';

class SubspeciesSectionWidget extends ConsumerStatefulWidget {
  final String speciesId;

  const SubspeciesSectionWidget({
    super.key,
    required this.speciesId,
  });

  @override
  ConsumerState<SubspeciesSectionWidget> createState() => _SubspeciesSectionWidgetState();
}

class _SubspeciesSectionWidgetState extends ConsumerState<SubspeciesSectionWidget> {
  List<Subspecies> _subspeciesList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubspecies();
  }

  Future<void> _loadSubspecies() async {
    setState(() => _isLoading = true);
    try {
      final list = await ref.read(catalogRepositoryProvider).getSubspeciesForSpecies(widget.speciesId);
      if (mounted) setState(() => _subspeciesList = list);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addOrEditSubspeciesModal({Subspecies? initial}) async {
    final nameController = TextEditingController(text: initial?.subspeciesName ?? '');
    final brandController = TextEditingController(text: initial?.brand ?? '');
    final barcodeController = TextEditingController(text: initial?.barcode ?? '');
    final notesController = TextEditingController(text: initial?.notes ?? '');
    String? photoPath = initial?.photoPath;
    XFile? newPickedImage;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (c, setStateModal) => AlertDialog(
          title: Text(initial != null ? 'Editar Subespecie' : 'Nueva Subespecie (Variante)'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                    if (img != null) {
                      setStateModal(() => newPickedImage = img);
                    }
                  },
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: newPickedImage != null
                        ? Image.file(File(newPickedImage!.path), fit: BoxFit.cover)
                        : (photoPath != null && photoPath.isNotEmpty)
                            ? FutureBuilder<String>(
                                future: ref.read(fileStorageServiceProvider).getAbsolutePath(photoPath),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.file(File(snapshot.data!), fit: BoxFit.cover);
                                  }
                                  return const Icon(Icons.add_a_photo, size: 24);
                                },
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, size: 20),
                                  SizedBox(height: 2),
                                  Text('Foto de la Subespecie', style: TextStyle(fontSize: 11)),
                                ],
                              ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre / Variante', hintText: 'Ej. Alkaline Heavy Duty'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: brandController,
                  decoration: const InputDecoration(labelText: 'Marca', hintText: 'Ej. Duracell'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: barcodeController,
                  decoration: const InputDecoration(labelText: 'Código de Barras', hintText: 'Ej. 750123456789'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notas', hintText: 'Ej. Edición especial'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    if (confirm == true && nameController.text.trim().isNotEmpty) {
      if (newPickedImage != null) {
        final storage = ref.read(fileStorageServiceProvider);
        photoPath = await storage.saveFile(newPickedImage!.path);
      }

      final sub = Subspecies(
        id: initial?.id ?? const Uuid().v4(),
        speciesId: widget.speciesId,
        subspeciesName: nameController.text.trim(),
        brand: brandController.text.trim().isNotEmpty ? brandController.text.trim() : null,
        barcode: barcodeController.text.trim().isNotEmpty ? barcodeController.text.trim() : null,
        photoPath: photoPath,
        notes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
        createdAt: initial?.createdAt ?? DateTime.now(),
      );

      await ref.read(catalogRepositoryProvider).saveSubspecies(sub);
      _loadSubspecies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subespecies (${_subspeciesList.length})',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _addOrEditSubspeciesModal(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar Marca'),
            ),
          ],
        ),
        const SizedBox(height: 4),

        if (_isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
        else if (_subspeciesList.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.style_outlined, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Text('No hay subespecies.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _subspeciesList.length,
            itemBuilder: (context, index) {
              final sub = _subspeciesList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 6),
                elevation: 0.5,
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.secondary.withAlpha(25),
                    child: sub.photoPath != null && sub.photoPath!.isNotEmpty
                        ? FutureBuilder<String>(
                            future: ref.read(fileStorageServiceProvider).getAbsolutePath(sub.photoPath!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && File(snapshot.data!).existsSync()) {
                                return ClipOval(child: Image.file(File(snapshot.data!), width: 32, height: 32, fit: BoxFit.cover));
                              }
                              return Icon(Icons.branding_watermark, color: theme.colorScheme.secondary, size: 16);
                            },
                          )
                        : Icon(Icons.branding_watermark, color: theme.colorScheme.secondary, size: 16),
                  ),
                  title: Text(
                    '${sub.subspeciesName} ${sub.brand != null ? "(${sub.brand})" : ""}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  subtitle: Text(
                    sub.barcode != null ? 'Barcode: ${sub.barcode}' : 'Sin código de barras',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => _addOrEditSubspeciesModal(initial: sub),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                        onPressed: () async {
                          await ref.read(catalogRepositoryProvider).deleteSubspecies(sub.id);
                          _loadSubspecies();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
