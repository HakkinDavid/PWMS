import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/catalog_item.dart';
import '../domain/subspecies.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/domain/entity_template.dart';
import '../../entities/domain/world_entity.dart';
import '../../locations/domain/location_path_helper.dart';
import 'species_text_badge_avatar.dart';
import 'standard_media_picker_sheet.dart';

class SplitSubspeciesModal extends ConsumerStatefulWidget {
  final CatalogItem? species;
  final Subspecies sourceSubspecies;

  const SplitSubspeciesModal({
    super.key,
    this.species,
    required this.sourceSubspecies,
  });

  static Future<Subspecies?> show(
    BuildContext context, {
    CatalogItem? species,
    required Subspecies sourceSubspecies,
  }) async {
    return showDialog<Subspecies?>(
      context: context,
      builder: (_) => SplitSubspeciesModal(
        species: species,
        sourceSubspecies: sourceSubspecies,
      ),
    );
  }

  @override
  ConsumerState<SplitSubspeciesModal> createState() => _SplitSubspeciesModalState();
}

class _SplitSubspeciesModalState extends ConsumerState<SplitSubspeciesModal> {
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _barcodeController;
  late TextEditingController _notesController;

  String? _photoPath;
  XFile? _newPickedImage;
  Future<String>? _resolvedPhotoPathFuture;
  bool _showAdvancedFields = false;
  bool _isSaving = false;
  bool _photoDeleted = false;
  bool _forceClose = false;

  final Set<String> _selectedInstanceIds = {};

  @override
  void initState() {
    super.initState();
    final source = widget.sourceSubspecies;
    _nameController = TextEditingController(text: AppStrings.splitSubspeciesDefaultName(source.subspeciesName));
    _brandController = TextEditingController(text: source.brand ?? AppTechnicalStrings.empty);
    _barcodeController = TextEditingController(text: source.barcode ?? AppTechnicalStrings.empty);
    _notesController = TextEditingController(text: source.notes ?? AppTechnicalStrings.empty);
    _showAdvancedFields = (_brandController.text.trim().isNotEmpty || _barcodeController.text.trim().isNotEmpty);
    _photoPath = source.photoPath;
    if (_photoPath != null && _photoPath!.isNotEmpty) {
      _resolvedPhotoPathFuture = ref.read(fileStorageServiceProvider).getAbsolutePath(_photoPath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges() {
    final source = widget.sourceSubspecies;
    if (_nameController.text.trim() != AppStrings.splitSubspeciesDefaultName(source.subspeciesName)) return true;
    if (_brandController.text.trim() != (source.brand ?? AppTechnicalStrings.empty).trim()) return true;
    if (_barcodeController.text.trim() != (source.barcode ?? AppTechnicalStrings.empty).trim()) return true;
    if (_notesController.text.trim() != (source.notes ?? AppTechnicalStrings.empty).trim()) return true;
    if (_newPickedImage != null || _photoDeleted) return true;
    if (_selectedInstanceIds.isNotEmpty) return true;
    return false;
  }

  Future<bool> _requestClose() async {
    if (_hasUnsavedChanges()) {
      final discard = await AppConfirmationDialog.showDiscardChangesDialog(context);
      if (!discard) return false;
    }
    _forceClose = true;
    return true;
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppToast.showRestriction(context, AppStrings.subspeciesNameLabel);
      return;
    }

    setState(() => _isSaving = true);

    try {
      String? finalPhotoPath = _photoPath;

      if (_newPickedImage != null) {
        final storage = ref.read(fileStorageServiceProvider);
        finalPhotoPath = await storage.saveFile(_newPickedImage!.path);
      } else if (_photoDeleted) {
        finalPhotoPath = null;
      }

      final targetSpeciesId = widget.species?.id ?? widget.sourceSubspecies.speciesId;

      if (targetSpeciesId.isNotEmpty) {
        final catalogRepo = ref.read(catalogRepositoryProvider);
        final currentSpecies = widget.species ?? await catalogRepo.getCatalogItemById(targetSpeciesId);
        if (currentSpecies != null && !EntityTemplateRegistry.hasBarcodeAndBrand(currentSpecies.type)) {
          final hasBrandOrBarcode = _brandController.text.trim().isNotEmpty || _barcodeController.text.trim().isNotEmpty;
          if (hasBrandOrBarcode) {
            final subChoice = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text(AppStrings.subgroupDeviationTitle),
                content: Text(AppStrings.subgroupDeviationPrompt(currentSpecies.type, AppStrings.brandLabel)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text(AppStrings.correctDataAction),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(AppStrings.confirmExceptionAction),
                  ),
                ],
              ),
            );
            if (subChoice != true) {
              setState(() => _isSaving = false);
              return;
            }
          }
        }
      }

      final newSubspecies = Subspecies(
        id: const Uuid().v4(),
        speciesId: targetSpeciesId,
        subspeciesName: name,
        brand: _brandController.text.trim().isNotEmpty ? _brandController.text.trim() : null,
        barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
        photoPath: finalPhotoPath,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        createdAt: DateTime.now(),
      );

      final catalogRepo = ref.read(catalogRepositoryProvider);
      final resultSubspecies = await catalogRepo.splitSubspecies(
        sourceSubspecies: widget.sourceSubspecies,
        newSubspecies: newSubspecies,
        entityIdsToMove: _selectedInstanceIds.toList(),
      );

      ref.invalidate(subspeciesListProvider);
      ref.invalidate(entityListProvider);
      ref.invalidate(catalogListProvider);
      ref.invalidate(recentEntitiesProvider);
      ref.invalidate(searchResultsProvider);

      if (mounted) {
        _forceClose = true;
        AppToast.showSuccess(
          context,
          AppStrings.subspeciesSplitSuccess(resultSubspecies.subspeciesName, _selectedInstanceIds.length),
        );
        Navigator.pop(context, resultSubspecies);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, AppStrings.splitSubspeciesError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final allEntities = entitiesState.asData?.value ?? [];
    final sourceInstances = allEntities
        .where((e) => e.speciesId == widget.sourceSubspecies.speciesId && e.subspeciesId == widget.sourceSubspecies.id)
        .toList();

    final isObjectMode = widget.species == null
        ? true
        : EntityTemplateRegistry.hasBarcodeAndBrand(widget.species!.type);

    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
    final locationNodes = ref.watch(locationNodeListProvider).asData?.value ?? [];
    final allRelations = ref.watch(relationListProvider).asData?.value ?? [];
    final subspeciesList = ref.watch(subspeciesListProvider).asData?.value ?? [];

    final dialog = AlertDialog(
      title: Text(
        AppStrings.splitSubspeciesDialogTitle,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.splitSubspeciesDescription(widget.sourceSubspecies.subspeciesName),
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withAlpha(180)),
              ),
              const SizedBox(height: 14),

              // Photo Picker Box
              GestureDetector(
                onTap: () async {
                  final name = _nameController.text.trim();
                  final brand = _brandController.text.trim();
                  final query = [if (name.isNotEmpty) name, if (brand.isNotEmpty) brand].join(AppTechnicalStrings.space);
                  final finalQuery = query.isNotEmpty
                      ? query
                      : (widget.species?.name ?? widget.sourceSubspecies.subspeciesName);

                  final result = await StandardMediaPickerSheet.show(
                    context,
                    title: AppStrings.subspeciesPhotoTitle,
                    webSearchQuery: finalQuery,
                    allowDocuments: false,
                  );
                  if (result != null && mounted) {
                    if (result.file != null) {
                      setState(() {
                        _newPickedImage = XFile(result.file!.path);
                        _photoPath = null;
                        _photoDeleted = false;
                      });
                    } else if (result.relativeStoredPath != null) {
                      setState(() {
                        _photoPath = result.relativeStoredPath;
                        _resolvedPhotoPathFuture = ref.read(fileStorageServiceProvider).getAbsolutePath(result.relativeStoredPath!);
                        _newPickedImage = null;
                        _photoDeleted = false;
                      });
                    }
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _newPickedImage != null
                            ? Image.file(
                                File(_newPickedImage!.path),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                              )
                            : (_photoPath != null && _photoPath!.isNotEmpty)
                                ? FutureBuilder<String>(
                                    future: _resolvedPhotoPathFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                          return Image.file(
                                            File(snapshot.data!),
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 28),
                                          );
                                        }
                                        return const Icon(Icons.broken_image_outlined, size: 28);
                                      }
                                      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                    },
                                  )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_outlined, size: 22),
                                      SizedBox(height: 4),
                                      Text(AppStrings.subspeciesPhotoLabel, style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                      ),
                    ),
                    if (_newPickedImage != null || (_photoPath != null && _photoPath!.isNotEmpty))
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Material(
                          color: Colors.redAccent.withAlpha(220),
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () async {
                              final confirm = await AppConfirmationDialog.show(
                                context: context,
                                title: AppStrings.confirmRemovePhotoTitle,
                                message: AppStrings.confirmRemovePhotoMessage,
                                confirmLabel: AppStrings.delete,
                                isDestructive: true,
                                icon: Icons.delete_outline,
                              );
                              if (confirm && mounted) {
                                setState(() {
                                  _newPickedImage = null;
                                  _photoPath = null;
                                  _resolvedPhotoPathFuture = null;
                                  _photoDeleted = true;
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(Icons.delete_outline, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Subspecies Variant Name TextField
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.subspeciesNameLabel,
                  prefixIcon: Icon(Icons.style),
                  isDense: true,
                ),
              ),

              if (isObjectMode) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.brandOptionalLabel,
                    prefixIcon: Icon(Icons.branding_watermark),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.barcodeOptionalLabel,
                    prefixIcon: Icon(Icons.qr_code),
                    isDense: true,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showAdvancedFields = !_showAdvancedFields),
                    icon: Icon(_showAdvancedFields ? Icons.expand_less : Icons.expand_more, size: 18),
                    label: Text(
                      _showAdvancedFields ? AppStrings.hideNonStandardFields : AppStrings.showNonStandardFields,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                if (_showAdvancedFields) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: theme.colorScheme.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            AppStrings.nonStandardFieldsHint,
                            style: TextStyle(fontSize: 11, color: theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _brandController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.brandOptionalLabel,
                      prefixIcon: Icon(Icons.branding_watermark),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _barcodeController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.barcodeOptionalLabel,
                      prefixIcon: Icon(Icons.qr_code),
                      isDense: true,
                    ),
                  ),
                ],
              ],

              const SizedBox(height: 10),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: AppStrings.variantNotesOptionalLabel,
                  prefixIcon: Icon(Icons.notes),
                  isDense: true,
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // Instance Selection Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.instancesToTransferTitle(_selectedInstanceIds.length, sourceInstances.length),
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (sourceInstances.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        alignment: WrapAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedInstanceIds.addAll(sourceInstances.map((e) => e.id));
                              });
                            },
                            child: const Text(AppStrings.selectAllAction, style: TextStyle(fontSize: 11)),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedInstanceIds.clear();
                              });
                            },
                            child: const Text(AppStrings.deselectAllAction, style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),

              if (sourceInstances.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.dividerColor.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppStrings.noInstancesToTransferNotice,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sourceInstances.length,
                  itemBuilder: (context, index) {
                    final entity = sourceInstances[index];
                    final isChecked = _selectedInstanceIds.contains(entity.id);
                    final customName = EntityDisplayHelper.getInstanceCustomName(entity);
                    final breadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
                      entityId: entity.id,
                      effectiveLocationId: entity.locationId,
                      allEntities: allEntities,
                      allRelations: allRelations,
                      allNodes: locationNodes,
                      catalogItems: catalogItems,
                      subspeciesList: subspeciesList,
                    );

                    final subtitleParts = <String>[];
                    if (breadcrumb.fullPath.isNotEmpty) subtitleParts.add(breadcrumb.fullPath);
                    if (entity.magnitudes.isNotEmpty) {
                      subtitleParts.add(entity.magnitudes.map((m) => m.displayValue).join(AppTechnicalStrings.commaSpace));
                    }
                    if (entity.notes != null && entity.notes!.trim().isNotEmpty) {
                      subtitleParts.add(entity.notes!.trim());
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 6),
                      elevation: isChecked ? 1.0 : 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isChecked ? theme.colorScheme.primary : theme.dividerColor.withAlpha(40),
                          width: isChecked ? 1.5 : 1.0,
                        ),
                      ),
                      child: CheckboxListTile(
                        dense: true,
                        value: isChecked,
                        activeColor: theme.colorScheme.primary,
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: SpeciesTextBadgeAvatar(
                              speciesName: widget.species?.name ?? widget.sourceSubspecies.subspeciesName,
                              size: 32,
                            ),
                          ),
                        ),
                        title: Text(
                          customName ?? widget.species?.name ?? widget.sourceSubspecies.subspeciesName,
                          style: TextStyle(
                            fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                        subtitle: subtitleParts.isNotEmpty
                            ? Text(
                                subtitleParts.join(AppTechnicalStrings.bulletSeparator),
                                style: TextStyle(fontSize: 11, color: theme.colorScheme.secondary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedInstanceIds.add(entity.id);
                            } else {
                              _selectedInstanceIds.remove(entity.id);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () async {
                  final canClose = await _requestClose();
                  if (canClose && context.mounted) {
                    Navigator.pop(context);
                  }
                },
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          child: _isSaving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text(AppStrings.splitSubspeciesAction),
        ),
      ],
    );

    return PopScope(
      canPop: _forceClose,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canClose = await _requestClose();
        if (canClose && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: dialog,
    );
  }
}
