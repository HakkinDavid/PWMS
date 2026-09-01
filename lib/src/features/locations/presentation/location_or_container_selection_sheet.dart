import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../../relations/domain/entity_relation.dart';
import '../domain/location_path_helper.dart';
import 'container_entity_picker.dart';
import 'location_tree_picker.dart';

enum LocationSelectionMode { physicalNode, containerEntity }

class LocationOrContainerSelection {
  final LocationSelectionMode mode;
  final String? locationId;
  final String? containerEntityId;

  const LocationOrContainerSelection.physicalNode([this.locationId])
      : mode = LocationSelectionMode.physicalNode,
        containerEntityId = null;

  const LocationOrContainerSelection.containerEntity(this.containerEntityId)
      : mode = LocationSelectionMode.containerEntity,
        locationId = null;

  bool get isPhysicalNode => mode == LocationSelectionMode.physicalNode;
  bool get isContainerEntity => mode == LocationSelectionMode.containerEntity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationOrContainerSelection &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          locationId == other.locationId &&
          containerEntityId == other.containerEntityId;

  @override
  int get hashCode => Object.hash(mode, locationId, containerEntityId);
}

class LocationOrContainerSelectionSheet extends ConsumerStatefulWidget {
  final String? title;
  final LocationOrContainerSelection initialSelection;
  final Set<String> excludedContainerIds;

  const LocationOrContainerSelectionSheet({
    super.key,
    this.title,
    this.initialSelection = const LocationOrContainerSelection.physicalNode(null),
    this.excludedContainerIds = const {},
  });

  /// Shows the selection sheet and returns the selected [LocationOrContainerSelection],
  /// or `null` if cancelled or dismissed without confirmation.
  static Future<LocationOrContainerSelection?> show(
    BuildContext context, {
    String? title,
    LocationOrContainerSelection? initialSelection,
    Set<String> excludedContainerIds = const {},
  }) {
    return showModalBottomSheet<LocationOrContainerSelection>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationOrContainerSelectionSheet(
        title: title,
        initialSelection: initialSelection ?? const LocationOrContainerSelection.physicalNode(null),
        excludedContainerIds: excludedContainerIds,
      ),
    );
  }

  /// Utility helper to apply a [LocationOrContainerSelection] to entities in the database,
  /// safely deleting previous inheriting relations and updating direct location or [GUARDADO_EN].
  static Future<void> applyRelocation({
    required WidgetRef ref,
    required List<String> entityIds,
    required LocationOrContainerSelection selection,
  }) async {
    if (entityIds.isEmpty) return;

    final relationRepo = ref.read(relationRepositoryProvider);
    final eRepo = ref.read(entityRepositoryProvider);

    for (final entityId in entityIds) {
      // 1. Remove previous inheriting relations (GUARDADO_EN, PARTE_DE)
      final existingRelations = await relationRepo.getRelationsForEntity(entityId);
      for (final rel in existingRelations) {
        if (rel.sourceEntityId == entityId &&
            (rel.relationType == AppTechnicalStrings.relGuardadoEn ||
             rel.relationType == AppTechnicalStrings.relParteDe)) {
          await relationRepo.deleteRelation(rel.id);
        }
      }

      final freshEntity = await eRepo.getEntityById(entityId);
      if (freshEntity == null) continue;

      if (selection.isPhysicalNode) {
        // Direct physical node
        await eRepo.saveEntity(freshEntity.copyWith(locationId: selection.locationId));
      } else if (selection.containerEntityId != null) {
        // Contained in containerEntityId
        await eRepo.saveEntity(freshEntity.copyWith(locationId: null));
        final newRelation = EntityRelation(
          id: const Uuid().v4(),
          sourceEntityId: entityId,
          targetEntityId: selection.containerEntityId!,
          relationType: AppTechnicalStrings.relGuardadoEn,
          createdAt: DateTime.now(),
        );
        await relationRepo.addRelation(newRelation);
      }
    }

    ref.invalidate(entityListProvider);
    ref.invalidate(relationListProvider);
    for (final id in entityIds) {
      ref.invalidate(entityDetailProvider(id));
      ref.invalidate(entityRelationsProvider(id));
    }
    if (selection.containerEntityId != null) {
      ref.invalidate(entityRelationsProvider(selection.containerEntityId!));
    }
  }

  @override
  ConsumerState<LocationOrContainerSelectionSheet> createState() => _LocationOrContainerSelectionSheetState();
}

class _LocationOrContainerSelectionSheetState extends ConsumerState<LocationOrContainerSelectionSheet> {
  late LocationSelectionMode _mode;
  String? _selectedLocationId;
  String? _selectedContainerEntityId;
  bool _forceClose = false;

  late final LocationSelectionMode _initialMode;
  late final String? _initialLocationId;
  late final String? _initialContainerEntityId;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialSelection.mode;
    _selectedLocationId = widget.initialSelection.locationId;
    _selectedContainerEntityId = widget.initialSelection.containerEntityId;

    _initialMode = _mode;
    _initialLocationId = _selectedLocationId;
    _initialContainerEntityId = _selectedContainerEntityId;
  }

  bool _hasUnsavedChanges() {
    if (_mode != _initialMode) return true;
    if (_mode == LocationSelectionMode.physicalNode && _selectedLocationId != _initialLocationId) return true;
    if (_mode == LocationSelectionMode.containerEntity && _selectedContainerEntityId != _initialContainerEntityId) return true;
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
      excludeEntityIds: widget.excludedContainerIds,
    );
    if (result != null) {
      setState(() {
        _selectedContainerEntityId = result.id;
      });
    }
  }

  void _confirmSelection() {
    if (_mode == LocationSelectionMode.containerEntity) {
      if (_selectedContainerEntityId == null || _selectedContainerEntityId!.isEmpty) {
        AppToast.showRestriction(context, AppStrings.selectValidContainerPrompt);
        return;
      }
    }

    final selection = _mode == LocationSelectionMode.physicalNode
        ? LocationOrContainerSelection.physicalNode(_selectedLocationId)
        : LocationOrContainerSelection.containerEntity(_selectedContainerEntityId);

    _forceClose = true;
    Navigator.pop(context, selection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationsState = ref.watch(locationNodeListProvider);
    final entitiesState = ref.watch(entityListProvider);

    final locations = locationsState.asData?.value ?? [];
    final entities = entitiesState.asData?.value ?? [];

    final titleText = widget.title ?? AppStrings.selectLocationOrContainerPrompt;

    // Current location display text
    final locationDisplayName = LocationPathHelper.buildBreadcrumbPath(
      _selectedLocationId,
      locations,
    ).fullPath;

    // Candidates for container: excluding specified IDs
    final candidateContainers = entities.where((e) => !widget.excludedContainerIds.contains(e.id)).toList();

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
                      titleText,
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
              SegmentedButton<LocationSelectionMode>(
                segments: const [
                  ButtonSegment(
                    value: LocationSelectionMode.physicalNode,
                    label: Text(AppStrings.physicalLocation),
                    icon: Icon(Icons.account_tree_outlined),
                  ),
                  ButtonSegment(
                    value: LocationSelectionMode.containerEntity,
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

              if (_mode == LocationSelectionMode.physicalNode) ...[
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

              // Confirm Selection Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text(AppStrings.confirm, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
