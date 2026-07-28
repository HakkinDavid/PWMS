import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/subspecies.dart';
import 'taxonomy_operations_dialog.dart';
import 'add_edit_subspecies_modal.dart';
import 'web_image_picker_dialog.dart';

class SubspeciesSectionWidget extends ConsumerStatefulWidget {
  final String speciesId;
  final bool isEditing;

  const SubspeciesSectionWidget({
    super.key,
    required this.speciesId,
    this.isEditing = false,
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
    final species = await ref.read(catalogRepositoryProvider).getCatalogItemById(widget.speciesId);
    if (!mounted) return;

    final resultSubspecies = await AddEditSubspeciesModal.show(
      context,
      species: species,
      initialSubspecies: initial,
    );

    if (resultSubspecies != null) {
      await ref.read(catalogRepositoryProvider).saveSubspecies(resultSubspecies);
      _loadSubspecies();
      ref.invalidate(catalogListProvider);
      ref.invalidate(entityListProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final allEntities = entitiesState.asData?.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppStrings.subspeciesCountTitle} (${_subspeciesList.length})',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (widget.isEditing)
              TextButton.icon(
                onPressed: () => _addOrEditSubspeciesModal(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text(AppStrings.addBrand),
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
                Text(AppStrings.noSubspeciesDefined, style: TextStyle(color: Colors.grey, fontSize: 12)),
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
              final hasInstances = allEntities.any((e) => e.subspeciesId == sub.id);
              final canDelete = _subspeciesList.length > 1 && !hasInstances;

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
                  subtitle: (sub.barcode != null || sub.notes != null)
                      ? Text(
                          sub.barcode != null
                              ? '${AppStrings.barcodeLabel}: ${sub.barcode}'
                              : sub.notes!,
                          style: const TextStyle(fontSize: 11),
                        )
                      : null,
                  trailing: widget.isEditing
                      ? PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 18),
                          onSelected: (val) async {
                            if (val == 'edit') {
                              _addOrEditSubspeciesModal(initial: sub);
                            } else if (val == 'web_image') {
                              await WebImagePickerDialog.show(
                                context,
                                searchQuery: '${sub.subspeciesName} ${sub.brand ?? ""}',
                                targetSubspecies: sub,
                              );
                              _loadSubspecies();
                            } else if (val == 'separate') {
                              await TaxonomyOperationsDialog.showSeparateSubspeciesDialog(context, ref, sub);
                              _loadSubspecies();
                            } else if (val == 'move') {
                              await TaxonomyOperationsDialog.showMoveSubspeciesDialog(context, ref, sub);
                              _loadSubspecies();
                            } else if (val == 'delete' && canDelete) {
                              try {
                                await ref.read(catalogRepositoryProvider).deleteSubspecies(sub.id);
                                _loadSubspecies();
                              } catch (e) {
                                if (context.mounted) AppToast.showError(context, e.toString().replaceAll('Exception: ', ''));
                              }
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text('Editar')])),
                            const PopupMenuItem(value: 'web_image', child: Row(children: [Icon(Icons.image_search, size: 16), SizedBox(width: 8), Text('Buscar foto en Web')])),
                            const PopupMenuItem(value: 'separate', child: Row(children: [Icon(Icons.call_split, size: 16), SizedBox(width: 8), Text('Separar en nueva Especie')])),
                            const PopupMenuItem(value: 'move', child: Row(children: [Icon(Icons.drive_file_move_outlined, size: 16), SizedBox(width: 8), Text('Mover a otra Especie')])),
                            if (canDelete)
                              const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 16, color: Colors.redAccent), SizedBox(width: 8), Text('Eliminar', style: TextStyle(color: Colors.redAccent))])),
                          ],
                        )
                      : null,
                ),
              );
            },
          ),
      ],
    );
  }
}
