import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';

class WebImagePickerDialog extends ConsumerStatefulWidget {
  final String searchQuery;
  final CatalogItem? targetSpecies;
  final Subspecies? targetSubspecies;

  const WebImagePickerDialog({
    super.key,
    required this.searchQuery,
    this.targetSpecies,
    this.targetSubspecies,
  }) : assert(targetSpecies != null || targetSubspecies != null, 'Debe proveer especie o subespecie');

  static Future<void> show(
    BuildContext context, {
    required String searchQuery,
    CatalogItem? targetSpecies,
    Subspecies? targetSubspecies,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => WebImagePickerDialog(
        searchQuery: searchQuery,
        targetSpecies: targetSpecies,
        targetSubspecies: targetSubspecies,
      ),
    );
  }

  @override
  ConsumerState<WebImagePickerDialog> createState() => _WebImagePickerDialogState();
}

class _WebImagePickerDialogState extends ConsumerState<WebImagePickerDialog> {
  late TextEditingController _searchCtrl;
  bool _isLoading = false;
  List<String> _imageUrls = [];
  String? _selectedUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.searchQuery);
    _performSearch();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final query = _searchCtrl.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _imageUrls = [];
      _selectedUrl = null;
    });

    try {
      final lookupService = ref.read(productLookupServiceProvider);
      final urls = await lookupService.searchWebImages(query);
      setState(() {
        _imageUrls = urls;
      });
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error buscando imágenes: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _assignSelectedImage() async {
    if (_selectedUrl == null) return;
    setState(() => _isSaving = true);

    try {
      final lookupService = ref.read(productLookupServiceProvider);
      final fileStorage = ref.read(fileStorageServiceProvider);
      final localPath = await lookupService.downloadAndSaveImage(_selectedUrl!);

      if (localPath != null && mounted) {
        final relPath = await fileStorage.saveFile(localPath);

        if (widget.targetSubspecies != null) {
          final updatedSub = widget.targetSubspecies!.copyWith(photoPath: relPath);
          await ref.read(catalogRepositoryProvider).saveSubspecies(updatedSub);
        } else if (widget.targetSpecies != null) {
          final updatedSpecies = widget.targetSpecies!.copyWith(mainPhotoPath: relPath);
          await ref.read(catalogRepositoryProvider).saveCatalogItem(updatedSpecies);
        }

        ref.read(catalogListProvider.notifier).loadCatalog();
        if (mounted) {
          Navigator.pop(context);
          AppToast.showSuccess(context, 'Imagen de Internet asignada correctamente.');
        }
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'Error al descargar/asignar la imagen: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Buscar Imagen en Internet',
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Nombre del producto / especie...',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _performSearch,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _imageUrls.isEmpty
                      ? const Center(child: Text('No se encontraron imágenes en Internet.'))
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _imageUrls.length,
                          itemBuilder: (ctx, idx) {
                            final url = _imageUrls[idx];
                            final isSelected = _selectedUrl == url;

                            return InkWell(
                              onTap: () => setState(() => _selectedUrl = url),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? theme.colorScheme.primary : Colors.grey.withAlpha(80),
                                    width: isSelected ? 3 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.broken_image, size: 24, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _selectedUrl != null && !_isSaving ? _assignSelectedImage : null,
          child: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Asignar Foto'),
        ),
      ],
    );
  }
}
