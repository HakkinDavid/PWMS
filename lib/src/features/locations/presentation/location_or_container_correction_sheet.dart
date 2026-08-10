import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/domain/world_entity.dart';
import '../../relations/domain/entity_relation.dart';
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
        r.sourceEntityId == widget.entity.id && r.relationType == 'GUARDADO_EN'
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

  Future<void> _saveCorrection() async {
    setState(() => _isSaving = true);
    try {
      final relationRepo = ref.read(relationRepositoryProvider);
      final eRepo = ref.read(entityRepositoryProvider);

      // Clean up previous GUARDADO_EN relations for this source entity
      final existingRelations = await relationRepo.getRelationsForEntity(widget.entity.id);
      for (final rel in existingRelations) {
        if (rel.sourceEntityId == widget.entity.id && rel.relationType == 'GUARDADO_EN') {
          await relationRepo.deleteRelation(rel.id);
        }
      }

      if (_mode == LocationCorrectionMode.physicalNode) {
        // Save physical location node
        final updatedEntity = widget.entity.copyWith(locationId: _selectedLocationId);
        await eRepo.saveEntity(updatedEntity);
      } else {
        // Container mode selected
        if (_selectedContainerEntityId == null || _selectedContainerEntityId!.isEmpty) {
          if (mounted) {
            AppToast.showRestriction(context, 'Selecciona un objeto contenedor válido.');
            setState(() => _isSaving = false);
          }
          return;
        }

        // Clear physical location and save GUARDADO_EN relation
        final updatedEntity = widget.entity.copyWith(locationId: null);
        await eRepo.saveEntity(updatedEntity);

        final newRelation = EntityRelation(
          id: const Uuid().v4(),
          sourceEntityId: widget.entity.id,
          targetEntityId: _selectedContainerEntityId!,
          relationType: 'GUARDADO_EN',
          createdAt: DateTime.now(),
        );
        await relationRepo.addRelation(newRelation);
      }

      ref.invalidate(entityListProvider);
      ref.invalidate(relationListProvider);

      if (mounted) {
        AppToast.showSuccess(context, 'Ubicación corregida exitosamente.');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, 'Error al corregir ubicación: $e');
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

    final catalogItems = catalogState.asData?.value ?? [];
    final entities = entitiesState.asData?.value ?? [];
    final subspeciesList = subspeciesState.asData?.value ?? [];

    String locationDisplayName = AppStrings.rootLocationName;
    if (_selectedLocationId != null) {
      locationsState.whenData((nodes) {
        final found = nodes.where((n) => n.id == _selectedLocationId).firstOrNull;
        if (found != null) locationDisplayName = found.name;
      });
    }

    final entityName = EntityDisplayHelper.getDisplayName(
      entity: widget.entity,
      catalogItems: catalogItems,
      subspeciesList: subspeciesList,
    );

    // Candidates for container: excluding the entity itself
    final candidateContainers = entities.where((e) => e.id != widget.entity.id).toList();

    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom + 20
        : mediaQuery.padding.bottom + 20;

    return Container(
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
            const SizedBox(height: 16),
            Text(
              AppStrings.correctLocationTitlePrefix + entityName + AppStrings.correctLocationTitleSuffix,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

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
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedContainerEntityId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                    hintText: AppStrings.selectContainerObject,
                  ),
                  items: candidateContainers.map((e) {
                    final name = EntityDisplayHelper.getDisplayName(
                      entity: e,
                      catalogItems: catalogItems,
                      subspeciesList: subspeciesList,
                    );
                    return DropdownMenuItem(value: e.id, child: Text(name, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedContainerEntityId = val),
                ),
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
    );
  }
}
