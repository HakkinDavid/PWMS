import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../domain/catalog_item.dart';
import '../../entities/domain/attachment.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import 'species_detail_view.dart';
import 'species_form_modal.dart';
import 'subspecies_section_widget.dart';

class SpeciesDetailScreen extends ConsumerStatefulWidget {
  final String speciesId;

  const SpeciesDetailScreen({super.key, required this.speciesId});

  @override
  ConsumerState<SpeciesDetailScreen> createState() => _SpeciesDetailScreenState();
}

class _SpeciesDetailScreenState extends ConsumerState<SpeciesDetailScreen> {
  bool _isEditing = false;
  bool _forceClose = false;
  List<Attachment> _workingAttachments = [];
  List<Attachment>? _originalAttachments;

  bool _hasUnsavedChanges() {
    if (!_isEditing) return false;
    if (_originalAttachments != null) {
      if (_workingAttachments.length != _originalAttachments!.length) return true;
      for (final wa in _workingAttachments) {
        final oa = _originalAttachments!.where((a) => a.id == wa.id).firstOrNull;
        if (oa == null) return true;
        if (wa.fileName != oa.fileName || wa.filePath != oa.filePath || wa.fileType != oa.fileType) return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final theme = Theme.of(context);

    return catalogState.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (items) {
        final species = items.where((c) => c.id == widget.speciesId).firstOrNull;
        if (species == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(AppStrings.appName)),
            body: const Center(child: Text(AppStrings.emptyCatalog)),
          );
        }

        final allEntities = entitiesState.asData?.value ?? [];
        final instances = allEntities.where((e) => e.speciesId == species.id).toList();
        final hasExistingInstance = instances.isNotEmpty;

        final speciesAttachmentsAsync = ref.watch(speciesAttachmentsProvider(widget.speciesId));
        if (!_isEditing) {
          final atts = speciesAttachmentsAsync.asData?.value ?? [];
          _originalAttachments = List.from(atts);
          _workingAttachments = List.from(atts);
        }

        // World Instance Locations Summary Card for this Species
        final locationsSummaryHeader = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distinct Species Header Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppStrings.masterCatalogSpeciesBadge,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SubspeciesSectionWidget(
              speciesId: species.id,
              isEditing: _isEditing,
              showInstances: true,
            ),
            const SizedBox(height: 16),
          ],
        );

        final fab = (species.isUnique && hasExistingInstance)
            ? null
            : FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  InstantiateSpeciesSheet.show(context, species: species);
                },
                tooltip: AppStrings.instantiateAction,
                child: const Icon(Icons.add),
              );

        return PopScope(
          canPop: !_isEditing || _forceClose,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (_hasUnsavedChanges()) {
              final shouldDiscard = await AppConfirmationDialog.showDiscardChangesDialog(context);
              if (!shouldDiscard || !mounted) return;
            }
            _workingAttachments = List.from(_originalAttachments ?? []);
            _forceClose = true;
            if (context.mounted) {
              setState(() => _isEditing = false);
              Navigator.of(context).pop();
            }
          },
          child: SpeciesDetailView(
            species: species,
            showAttachmentAction: _isEditing,
            workingSpeciesAttachments: _isEditing ? _workingAttachments : null,
            onSpeciesAttachmentsChanged: _isEditing
                ? (updatedList) => setState(() => _workingAttachments = updatedList)
                : null,
            instanceSpecificsHeader: locationsSummaryHeader,
            floatingActionButton: fab,
            actions: !_isEditing
                ? [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: AppStrings.edit,
                      onPressed: () => setState(() => _isEditing = true),
                    ),
                  ]
                : [
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      tooltip: AppStrings.delete,
                      onPressed: () async {
                        if (hasExistingInstance) {
                          final allCatalog = ref.read(catalogListProvider).asData?.value ?? [];
                          final otherSpecies = allCatalog.where((c) => c.id != species.id).toList();

                          final choice = await showDialog<String>(
                            context: context,
                            builder: (dialogCtx) => AlertDialog(
                              title: const Text(AppStrings.deleteSpeciesWithInstancesTitle),
                              content: Text(AppStrings.deleteSpeciesWithInstancesPrompt(species.name, instances.length)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                                  child: const Text(AppStrings.cancel),
                                ),
                                if (otherSpecies.isNotEmpty)
                                  OutlinedButton(
                                    onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionReassign),
                                    child: const Text(AppStrings.reassignInstancesAction),
                                  ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                  onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCascadeDelete),
                                  child: const Text(AppStrings.cascadeDeleteInstancesAction, style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );

                          if (choice == AppTechnicalStrings.actionReassign) {
                            if (!context.mounted) return;
                            final targetSpecies = await AppWheelPicker.show<CatalogItem>(
                              context,
                              items: otherSpecies,
                              initialValue: otherSpecies.first,
                              labelBuilder: (c) => c.name,
                              title: AppStrings.selectTargetSpeciesPrompt,
                            );
                            if (targetSpecies != null) {
                              await ref.read(entityRepositoryProvider).reassignEntitiesSpecies(species.id, targetSpecies.id);
                              await ref.read(catalogListProvider.notifier).deleteCatalogItem(species.id);
                              ref.invalidate(entityListProvider);
                              if (context.mounted) {
                                AppToast.showSuccess(context, AppStrings.instancesReassignedSuccess(instances.length, targetSpecies.name));
                                context.pop();
                              }
                            }
                          } else if (choice == AppTechnicalStrings.actionCascadeDelete) {
                            try {
                              await ref.read(catalogListProvider.notifier).deleteCatalogItem(species.id, cascadeEntities: true);
                              ref.invalidate(entityListProvider);
                              if (context.mounted) {
                                AppToast.showSuccess(context, AppStrings.speciesDeletedWithCascadeSuccess(instances.length));
                                context.pop();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                AppToast.showError(context, e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty));
                              }
                            }
                          }
                        } else {
                          final confirm = await AppConfirmationDialog.showDeleteConfirmation(
                            context: context,
                            title: AppStrings.deleteConfirmationTitle,
                            message: AppStrings.confirmDeleteSpeciesNamed(species.name),
                          );

                          if (confirm == true) {
                            try {
                              await ref.read(catalogListProvider.notifier).deleteCatalogItem(species.id);
                              if (context.mounted) context.pop();
                            } catch (e) {
                              if (context.mounted) {
                                AppToast.showError(context, e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty));
                              }
                            }
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      tooltip: AppStrings.saveChangesAction,
                      onPressed: () async {
                        if (_originalAttachments != null) {
                          final entityRepo = ref.read(entityRepositoryProvider);
                          final fileStorage = ref.read(fileStorageServiceProvider);
                          final deletedAttachments = _originalAttachments!.where((orig) => !_workingAttachments.any((w) => w.id == orig.id)).toList();
                          final addedAttachments = _workingAttachments.where((w) => !_originalAttachments!.any((orig) => orig.id == w.id)).toList();
                          final existingAttachments = _workingAttachments.where((w) => _originalAttachments!.any((orig) => orig.id == w.id)).toList();

                          for (final att in deletedAttachments) {
                            await entityRepo.deleteAttachment(att.id);
                          }
                          for (final att in addedAttachments) {
                            await entityRepo.addAttachment(att);
                          }
                          for (final att in existingAttachments) {
                            final orig = _originalAttachments!.firstWhere((o) => o.id == att.id);
                            if (att.filePath != orig.filePath) {
                              final absPath = await fileStorage.getAbsolutePath(att.filePath);
                              await entityRepo.replaceAttachmentFile(
                                att.id,
                                absPath,
                                newFileName: att.fileName,
                                newFileType: att.fileType,
                              );
                            } else if (att.fileName != orig.fileName) {
                              await entityRepo.updateAttachment(att);
                            }
                          }
                          ref.invalidate(speciesAttachmentsProvider(widget.speciesId));
                          _originalAttachments = List.from(_workingAttachments);
                        }

                        if (context.mounted) {
                          setState(() => _isEditing = false);
                          AppToast.showSuccess(context, AppStrings.instanceUpdatedSuccess);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      tooltip: AppStrings.editSpeciesTitle,
                      onPressed: () {
                        SpeciesFormModal.show(context, initialSpecies: species);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: AppStrings.cancel,
                      onPressed: () async {
                        if (_hasUnsavedChanges()) {
                          final shouldDiscard = await AppConfirmationDialog.showDiscardChangesDialog(context);
                          if (!shouldDiscard || !mounted) return;
                        }
                        setState(() {
                          _workingAttachments = List.from(_originalAttachments ?? []);
                          _isEditing = false;
                        });
                      },
                    ),
                  ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.appName)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.appName)),
        body: Center(child: Text(AppStrings.errorWithDetails(err))),
      ),
    );
  }
}
