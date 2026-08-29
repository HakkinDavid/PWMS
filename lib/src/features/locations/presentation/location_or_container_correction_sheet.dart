import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../../relations/domain/entity_relation.dart';
import '../domain/location_path_helper.dart';
import 'container_entity_picker.dart';
import 'location_tree_picker.dart';

enum LocationCorrectionMode { physicalNode, containerEntity }

class LocationOrContainerCorrectionSheet extends ConsumerStatefulWidget {
  final WorldEntity entity;

  const LocationOrContainerCorrectionSheet({
    super.key,
    required this.entity,
  });

  /// Shows the correction sheet and returns `true` if a location/container correction was saved,
  /// or `false` if cancelled.
  static Future<bool> show(BuildContext context, {required WorldEntity entity}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationOrContainerCorrectionSheet(entity: entity),
    );
    return result ?? false;
  }

  @override
  ConsumerState<LocationOrContainerCorrectionSheet> createState() => _LocationOrContainerCorrectionSheetState();
}

class _LocationOrContainerCorrectionSheetState extends ConsumerState<LocationOrContainerCorrectionSheet> {
  LocationCorrectionMode _mode = LocationCorrectionMode.physicalNode;
  String? _selectedLocationId;
  String? _selectedContainerEntityId;
  bool _isSaving = false;
  bool _forceClose = false;

  bool _hasUnsavedChanges() {
    if (_mode == LocationCorrectionMode.physicalNode && _selectedLocationId != widget.entity.locationId) return true;
    if (_mode == LocationCorrectionMode.containerEntity && _selectedContainerEntityId != null) return true;
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

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.entity.locationId;
    _initCurrentRelation();
  }

  Future<void> _initCurrentRelation() async {
    try {
      final relationRepo = ref.read(relationRepositoryProvider);
      final relations = await relationRepo.getRelationsForEntity(widget.entity.id);
      final existingContainerRel = relations.where((r) =>
        r.sourceEntityId == widget.entity.id && r.relationType == AppTechnicalStrings.relGuardadoEn
      ).firstOrNull;

      if (existingContainerRel != null) {
        setState(() {
          _mode = LocationCorrectionMode.containerEntity;
          _selectedContainerEntityId = existingContainerRel.targetEntityId;
        });
      }
    } catch (_) {}
  }

  Future<void> _pickLocationFromTree() async {
    final result = await LocationTreePicker.show(context, initialSelectedId: _selectedLocationId);
    if (result != null) {
      setState(() {
        _selectedLocationId = result.locationId;
      });
    }
  }

  Future<void> _pickContainerFromPicker() async {
    final result = await ContainerEntityPicker.show(
      context,
      initialSelectedId: _selectedContainerEntityId,
      excludeEntityId: widget.entity.id,
    );
    if (result != null) {
      setState(() {
        _selectedContainerEntityId = result.id;
      });
    }
  }

  Future<void> _saveCorrection() async {
    setState(() => _isSaving = true);
    try {
      final relationRepo = ref.read(relationRepositoryProvider);
      final eRepo = ref.read(entityRepositoryProvider);

      // Clean up previous GUARDADO_EN relations for this source entity
      final existingRelations = await relationRepo.getRelationsForEntity(widget.entity.id);
      for (final rel in existingRelations) {
        if (rel.sourceEntityId == widget.entity.id && rel.relationType == AppTechnicalStrings.relGuardadoEn) {
          await relationRepo.deleteRelation(rel.id);
        }
      }

      final freshEntity = await eRepo.getEntityById(widget.entity.id) ?? widget.entity;

      if (_mode == LocationCorrectionMode.physicalNode) {
        // Save physical location node
        final updatedEntity = freshEntity.copyWith(locationId: _selectedLocationId);
        await eRepo.saveEntity(updatedEntity);
      } else {
        // Container mode selected
        if (_selectedContainerEntityId == null || _selectedContainerEntityId!.isEmpty) {
          if (mounted) {
            AppToast.showRestriction(context, AppStrings.selectValidContainerPrompt);
            setState(() => _isSaving = false);
          }
          return;
        }

        // Clear physical location and save GUARDADO_EN relation
        final updatedEntity = freshEntity.copyWith(locationId: null);
        await eRepo.saveEntity(updatedEntity);

        final newRelation = EntityRelation(
          id: const Uuid().v4(),
          sourceEntityId: widget.entity.id,
          targetEntityId: _selectedContainerEntityId!,
          relationType: AppTechnicalStrings.relGuardadoEn,
          createdAt: DateTime.now(),
        );
        await relationRepo.addRelation(newRelation);
      }

      ref.invalidate(entityListProvider);
      ref.invalidate(relationListProvider);
      ref.invalidate(entityDetailProvider(widget.entity.id));
      ref.invalidate(entityRelationsProvider(widget.entity.id));
      if (_selectedContainerEntityId != null) {
        ref.invalidate(entityRelationsProvider(_selectedContainerEntityId!));
      }

      if (mounted) {
        _forceClose = true;
        AppToast.showSuccess(context, AppStrings.locationCorrectedSuccess);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, AppStrings.locationCorrectionError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationsState = ref.watch(locationNodeListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final subspeciesState = ref.watch(subspeciesListProvider);

    final locations = locationsState.asData?.value ?? [];
    final catalogItems = catalogState.asData?.value ?? [];
    final entities = entitiesState.asData?.value ?? [];
    final subspeciesList = subspeciesState.asData?.value ?? [];

    final entityName = EntityDisplayHelper.getDisplayName(
      entity: widget.entity,
      catalogItems: catalogItems,
      subspeciesList: subspeciesList,
    );

    // Current location display text
    final locationDisplayName = LocationPathHelper.buildBreadcrumbPath(
      _selectedLocationId,
      locations,
    ).fullPath;

    // Candidates for container: excluding the entity itself
    final candidateContainers = entities.where((e) => e.id != widget.entity.id).toList();

    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom + 20
        : mediaQuery.padding.bottom + 20;

    return PopScope(
      canPop: _forceClose,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canClose = await _requestClose();
        if (canClose && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: bottomPadding,
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
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.correctLocationTitle(entityName),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: AppStrings.close,
                    onPressed: () async {
                      final canClose = await _requestClose();
                      if (canClose && mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mode selection: Physical Node vs Container Entity
              SegmentedButton<LocationCorrectionMode>(
                segments: const [
                  ButtonSegment(
                    value: LocationCorrectionMode.physicalNode,
                    label: Text(AppStrings.physicalLocation),
                    icon: Icon(Icons.account_tree_outlined),
                  ),
                  ButtonSegment(
                    value: LocationCorrectionMode.containerEntity,
                    label: Text(AppStrings.savedInContainer),
                    icon: Icon(Icons.inventory_2_outlined),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (set) {
                  setState(() => _mode = set.first);
                },
              ),
              const SizedBox(height: 16),

            if (_mode == LocationCorrectionMode.physicalNode) ...[
              Text(AppStrings.locationLabel, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickLocationFromTree,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_tree_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          locationDisplayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Text(AppStrings.selectContainerPrompt, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              if (candidateContainers.isEmpty)
                const Text(AppStrings.noContainerObjectsAvailable)
              else if (_selectedContainerEntityId != null &&
                  candidateContainers.any((e) => e.id == _selectedContainerEntityId)) ...[
                Builder(
                  builder: (context) {
                    final selectedContainer = candidateContainers.firstWhere(
                      (e) => e.id == _selectedContainerEntityId,
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InstancePreviewCard(
                          entity: selectedContainer,
                          onTap: _pickContainerFromPicker,
                          trailing: IconButton(
                            icon: const Icon(Icons.swap_horiz),
                            tooltip: AppStrings.changeContainerAction,
                            onPressed: _pickContainerFromPicker,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _pickContainerFromPicker,
                            icon: const Icon(Icons.search, size: 16),
                            label: const Text(AppStrings.changeContainerAction),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ] else ...[
                InkWell(
                  onTap: _pickContainerFromPicker,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.inventory_2_outlined),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppStrings.selectContainerObject,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveCorrection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.check),
                label: Text(_isSaving ? AppStrings.savingAction : AppStrings.applyCorrectionAction, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
