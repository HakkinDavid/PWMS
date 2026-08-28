import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../../entities/presentation/entity_tile.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import '../domain/subspecies.dart';
import 'add_edit_subspecies_modal.dart';
import 'species_text_badge_avatar.dart';
import 'subspecies_tile.dart';
import 'taxonomy_operations_dialog.dart';

class SubspeciesSectionWidget extends ConsumerStatefulWidget {
  final String speciesId;
  final bool isEditing;
  final bool showInstances;

  const SubspeciesSectionWidget({
    super.key,
    required this.speciesId,
    this.isEditing = false,
    this.showInstances = false,
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

  @override
  void didUpdateWidget(covariant SubspeciesSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speciesId != widget.speciesId) {
      _loadSubspecies();
    }
  }

  Future<void> _loadSubspecies() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final catalogRepo = ref.read(catalogRepositoryProvider);
      final list = await catalogRepo.getSubspeciesForSpecies(widget.speciesId);
      if (mounted) setState(() => _subspeciesList = list);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addOrEditSubspeciesModal({Subspecies? initial}) async {
    final catalogRepo = ref.read(catalogRepositoryProvider);
    final species = await catalogRepo.getCatalogItemById(widget.speciesId);
    if (!mounted) return;

    final resultSubspecies = await AddEditSubspeciesModal.show(
      context,
      species: species,
      initialSubspecies: initial,
    );

    if (resultSubspecies != null) {
      await catalogRepo.saveSubspecies(resultSubspecies);
      ref.invalidate(subspeciesListProvider);
      ref.invalidate(catalogListProvider);
      ref.invalidate(entityListProvider);

      if (mounted) {
        await _loadSubspecies();
        if (initial == null && mounted) {
          InstantiateSpeciesSheet.show(
            context,
            species: species,
            initialSubspecies: resultSubspecies,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final allEntities = entitiesState.asData?.value ?? [];
    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
    final species = catalogItems.where((c) => c.id == widget.speciesId).firstOrNull;

    final allSpeciesEntities = allEntities.where((e) => e.speciesId == widget.speciesId).toList();
    final unassignedInstances = widget.showInstances
        ? allSpeciesEntities.where((e) => e.subspeciesId == null || !_subspeciesList.any((s) => s.id == e.subspeciesId)).toList()
        : null;

    final headerTitle = widget.showInstances
        ? AppStrings.subspeciesCountWithInstances(_subspeciesList.length, allSpeciesEntities.length)
        : AppStrings.subspeciesOrBrandsWithCount(_subspeciesList.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                headerTitle,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (widget.isEditing)
              TextButton.icon(
                onPressed: () => _addOrEditSubspeciesModal(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text(AppStrings.addSubspeciesTab, style: TextStyle(fontSize: 12)),
              ),
          ],
        ),
        const SizedBox(height: 6),

        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_subspeciesList.isEmpty && (unassignedInstances == null || unassignedInstances.isEmpty))
          const Text(AppStrings.noSubspeciesOrBrandsAdded, style: TextStyle(color: Colors.grey, fontSize: 12))
        else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _subspeciesList.length,
            itemBuilder: (context, index) {
              final sub = _subspeciesList[index];
              final subInstances = allSpeciesEntities.where((e) => e.subspeciesId == sub.id).toList();
              final hasInstances = subInstances.isNotEmpty;
              final canDelete = _subspeciesList.length > 1 && !hasInstances;

              return SubspeciesTile(
                subspecies: sub,
                speciesName: species?.name,
                species: species,
                isExpandable: widget.showInstances,
                initiallyExpanded: false,
                instances: widget.showInstances ? subInstances : null,
                trailing: widget.isEditing
                      ? PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18),
                        onSelected: (val) async {
                          if (val == AppTechnicalStrings.actionEdit) {
                            _addOrEditSubspeciesModal(initial: sub);
                          } else if (val == AppTechnicalStrings.actionSeparate) {
                            await TaxonomyOperationsDialog.showSeparateSubspeciesDialog(context, ref, sub);
                            if (mounted) _loadSubspecies();
                          } else if (val == AppTechnicalStrings.actionMove) {
                            await TaxonomyOperationsDialog.showMoveSubspeciesDialog(context, ref, sub);
                            if (mounted) _loadSubspecies();
                          } else if (val == AppTechnicalStrings.actionDelete) {
                            final catalogRepo = ref.read(catalogRepositoryProvider);
                            final entityRepo = ref.read(entityRepositoryProvider);

                            if (hasInstances) {
                              final otherSubs = _subspeciesList.where((s) => s.id != sub.id).toList();

                              final choice = await showDialog<String>(
                                context: context,
                                builder: (dialogCtx) => AlertDialog(
                                  title: const Text(AppStrings.deleteSubspeciesWithInstancesTitle),
                                  content: Text(AppStrings.deleteSubspeciesWithInstancesPrompt(sub.subspeciesName, subInstances.length)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogCtx, AppTechnicalStrings.actionCancel),
                                      child: const Text(AppStrings.cancel),
                                    ),
                                    if (otherSubs.isNotEmpty)
                                      ElevatedButton(
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
                                final targetSub = await AppWheelPicker.show<Subspecies>(
                                  context,
                                  items: otherSubs,
                                  initialValue: otherSubs.first,
                                  labelBuilder: (s) => s.subspeciesName,
                                  title: AppStrings.selectTargetSubspeciesPrompt,
                                );
                                if (targetSub != null) {
                                  await entityRepo.reassignEntitiesSubspecies(sub.id, targetSub.id);
                                  await catalogRepo.deleteSubspecies(sub.id, allowOnlySubspecies: true);
                                  ref.invalidate(entityListProvider);
                                  ref.invalidate(subspeciesListProvider);
                                  if (mounted) {
                                    AppToast.showSuccess(context, AppStrings.instancesReassignedSuccess(subInstances.length, targetSub.subspeciesName));
                                    _loadSubspecies();
                                  }
                                }
                              } else if (choice == AppTechnicalStrings.actionCascadeDelete) {
                                try {
                                  await catalogRepo.deleteSubspecies(sub.id, cascadeEntities: true, allowOnlySubspecies: true);
                                  ref.invalidate(entityListProvider);
                                  ref.invalidate(subspeciesListProvider);
                                  if (mounted) {
                                    AppToast.showSuccess(context, AppStrings.speciesDeletedWithCascadeSuccess(subInstances.length));
                                    _loadSubspecies();
                                  }
                                } catch (e) {
                                  if (context.mounted) AppToast.showError(context, e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty));
                                }
                              }
                            } else if (_subspeciesList.length <= 1) {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (dialogCtx) => AlertDialog(
                                  title: const Text(AppStrings.deleteOnlySubspeciesTitle),
                                  content: Text(AppStrings.deleteOnlySubspeciesPrompt(species?.name ?? AppStrings.unknownSpecies)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogCtx, false),
                                      child: const Text(AppStrings.cancel),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                      onPressed: () => Navigator.pop(dialogCtx, true),
                                      child: const Text(AppStrings.delete, style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                try {
                                  await catalogRepo.deleteSubspecies(sub.id, allowOnlySubspecies: true);
                                  ref.invalidate(subspeciesListProvider);
                                  if (mounted) _loadSubspecies();
                                } catch (e) {
                                  if (context.mounted) AppToast.showError(context, e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty));
                                }
                              }
                            } else {
                              final confirm = await AppConfirmationDialog.showDeleteConfirmation(
                                context: context,
                                title: AppStrings.confirmDeleteSubspeciesTitle,
                                message: AppStrings.confirmDeleteSubspeciesNamed(sub.subspeciesName),
                              );
                              if (!confirm) return;

                              try {
                                await catalogRepo.deleteSubspecies(sub.id);
                                ref.invalidate(subspeciesListProvider);
                                if (mounted) _loadSubspecies();
                              } catch (e) {
                                if (context.mounted) AppToast.showError(context, e.toString().replaceAll(AppTechnicalStrings.exceptionPrefix, AppTechnicalStrings.empty));
                              }
                            }
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(value: AppTechnicalStrings.actionEdit, child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Expanded(child: Text(AppStrings.edit))])),
                          const PopupMenuItem(value: AppTechnicalStrings.actionSeparate, child: Row(children: [Icon(Icons.call_split, size: 16), SizedBox(width: 8), Expanded(child: Text(AppStrings.separateInNewSpeciesTitle))])),
                          const PopupMenuItem(value: AppTechnicalStrings.actionMove, child: Row(children: [Icon(Icons.drive_file_move_outlined, size: 16), SizedBox(width: 8), Expanded(child: Text(AppStrings.moveSubspeciesTitle))])),
                          const PopupMenuItem(value: AppTechnicalStrings.actionDelete, child: Row(children: [Icon(Icons.delete_outline, size: 16, color: Colors.redAccent), SizedBox(width: 8), Expanded(child: Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)))]))
                        ],
                      )
                    : null,
              );
            },
          ),
          if (widget.showInstances && unassignedInstances != null && unassignedInstances.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: theme.dividerColor.withAlpha(40), width: 1.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                key: const ValueKey<String>(AppTechnicalStrings.empty),
                initiallyExpanded: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide.none,
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide.none,
                ),
                tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 2),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: SpeciesTextBadgeAvatar(
                      speciesName: species?.name ?? AppStrings.otherUnassignedInstances,
                      size: 40,
                    ),
                  ),
                ),
                title: const Text(
                  AppStrings.otherUnassignedInstances,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 12,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.instancesCount(unassignedInstances.length),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: unassignedInstances.length,
                    itemBuilder: (ctx, idx) {
                      return EntityTile(entity: unassignedInstances[idx]);
                    },
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
