import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';

class WebImagePickerDialog extends ConsumerStatefulWidget {
  final String searchQuery;
  final CatalogItem? targetSpecies;
  final Subspecies? targetSubspecies;
  final List<CatalogItem>? bulkSpecies;
  final List<Subspecies>? bulkSubspecies;

  const WebImagePickerDialog({
    super.key,
    required this.searchQuery,
    this.targetSpecies,
    this.targetSubspecies,
    this.bulkSpecies,
    this.bulkSubspecies,
  });

  static Future<String?> show(
    BuildContext context, {
    required String searchQuery,
    CatalogItem? targetSpecies,
    Subspecies? targetSubspecies,
    List<CatalogItem>? bulkSpecies,
    List<Subspecies>? bulkSubspecies,
  }) async {
    return await showDialog<String>(
      context: context,
      builder: (_) => WebImagePickerDialog(
        searchQuery: searchQuery,
        targetSpecies: targetSpecies,
        targetSubspecies: targetSubspecies,
        bulkSpecies: bulkSpecies,
        bulkSubspecies: bulkSubspecies,
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
      if (mounted) AppToast.showError(context, AppStrings.searchWebImagesError(e.toString()));
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
        final catalogRepo = ref.read(catalogRepositoryProvider);

        final hasDirectDbMutation = widget.targetSubspecies != null ||
            widget.targetSpecies != null ||
            widget.bulkSpecies != null ||
            widget.bulkSubspecies != null;

        // Single subspecies
        if (widget.targetSubspecies != null) {
          final updatedSub = widget.targetSubspecies!.copyWith(photoPath: relPath);
          await catalogRepo.saveSubspecies(updatedSub);
        }

        // Single species
        if (widget.targetSpecies != null) {
          final updatedSpecies = widget.targetSpecies!.copyWith(mainPhotoPath: relPath);
          await catalogRepo.saveCatalogItem(updatedSpecies);
        }

        // Bulk species (Point 4)
        if (widget.bulkSpecies != null) {
          for (final sp in widget.bulkSpecies!) {
            final updatedSp = sp.copyWith(mainPhotoPath: relPath);
            await catalogRepo.saveCatalogItem(updatedSp);
          }
        }

        // Bulk subspecies (Point 4)
        if (widget.bulkSubspecies != null) {
          for (final sub in widget.bulkSubspecies!) {
            final updatedSub = sub.copyWith(photoPath: relPath);
            await catalogRepo.saveSubspecies(updatedSub);
          }
        }

        if (hasDirectDbMutation) {
          ref.read(catalogListProvider.notifier).loadCatalog();
          ref.invalidate(subspeciesListProvider);
        }

        if (mounted) {
          Navigator.pop(context, relPath);
          if (hasDirectDbMutation) {
            AppToast.showSuccess(context, AppStrings.webImageAssignedSuccess);
          }
        }
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, AppStrings.downloadOrAssignImageError(e.toString()));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        AppStrings.searchWebImageTitle,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 500,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: AppStrings.productOrSpeciesSearchHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              tooltip: AppStrings.cancel,
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
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
                      ? const Center(child: Text(AppStrings.noWebImagesFound))
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
                                      child: Icon(Icons.broken_image_outlined, size: 24, color: Colors.grey),
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
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _selectedUrl != null && !_isSaving ? _assignSelectedImage : null,
          child: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text(AppStrings.assignPhotoAction),
        ),
      ],
    );
  }
}
