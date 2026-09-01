import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/domain/property_data_type.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/species_detail_view.dart';
import '../../locations/domain/location_path_helper.dart';
import '../../locations/domain/location_resolver.dart';
import '../../locations/presentation/location_or_container_selection_sheet.dart';
import '../../relations/presentation/create_relation_modal.dart';
import '../../relations/presentation/interactive_entity_graph_widget.dart';
import '../../catalog/presentation/requirements_section_widget.dart';
import 'package:uuid/uuid.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../catalog/domain/species_magnitude.dart';
import '../../catalog/domain/species_requirement.dart';
import '../../relations/domain/entity_relation.dart';
import '../domain/attachment.dart';
import '../domain/entity_display_helper.dart';
import '../domain/instance_magnitude.dart';
import '../domain/world_entity.dart';
import 'shelf_life_gauge_widget.dart';


class EntityDetailScreen extends ConsumerStatefulWidget {
  final String entityId;

  const EntityDetailScreen({super.key, required this.entityId});

  @override
  ConsumerState<EntityDetailScreen> createState() => _EntityDetailScreenState();
}

class _EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
  bool _isEditingInPlace = false;
  bool _forceClose = false;
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedLocationId;
  DateTime? _selectedExpirationDate;
  List<InstanceMagnitude> _workingMagnitudes = [];
  List<EntityRelation> _workingRelations = [];
  List<SpeciesRequirement> _workingRequirements = [];
  List<Attachment> _workingAttachments = [];
  List<EntityRelation>? _originalRelations;
  List<SpeciesRequirement>? _originalRequirements;
  List<Attachment>? _originalAttachments;
  WorldEntity? _lastInitializedEntity;

  void _syncWorkingStateWithEntity(
    WorldEntity entity, {
    List<EntityRelation>? relations,
    List<SpeciesRequirement>? requirements,
    List<Attachment>? attachments,
    bool force = false,
  }) {
    if (!force && _lastInitializedEntity?.id == entity.id && _lastInitializedEntity == entity) {
      if (relations != null && !_isEditingInPlace) {
        _originalRelations = List.from(relations);
        _workingRelations = List.from(relations);
      }
      if (requirements != null && !_isEditingInPlace) {
        _originalRequirements = List.from(requirements);
        _workingRequirements = List.from(requirements);
      }
      if (attachments != null && !_isEditingInPlace) {
        _originalAttachments = List.from(attachments);
        _workingAttachments = List.from(attachments);
      }
      return;
    }
    _lastInitializedEntity = entity;
    final primaryMag = entity.magnitudes.isNotEmpty ? entity.magnitudes.first : null;
    final primaryVal = primaryMag?.magnitudeValue ?? 1.0;
    final primaryUnit = primaryMag?.unitSymbol ?? AppTechnicalStrings.empty;
    final hasMagnitudes = entity.magnitudes.isNotEmpty;

    _qtyController.text = hasMagnitudes ? DomainRules.formatMagnitude(primaryVal, primaryUnit) : AppTechnicalStrings.empty;
    _notesController.text = entity.notes ?? AppTechnicalStrings.empty;
    _selectedLocationId = entity.locationId;
    _selectedExpirationDate = entity.expirationDate;
    _workingMagnitudes = List.from(entity.magnitudes);
    if (relations != null) {
      _originalRelations = List.from(relations);
      _workingRelations = List.from(relations);
    }
    if (requirements != null) {
      _originalRequirements = List.from(requirements);
      _workingRequirements = List.from(requirements);
    }
    if (attachments != null) {
      _originalAttachments = List.from(attachments);
      _workingAttachments = List.from(attachments);
    }
  }

  bool _hasUnsavedChanges(WorldEntity entity) {
    if (!_isEditingInPlace) return false;
    final originalNotes = entity.notes ?? AppTechnicalStrings.empty;
    if (_notesController.text.trim() != originalNotes.trim()) return true;
    if (_selectedLocationId != entity.locationId) return true;
    if (_selectedExpirationDate != entity.expirationDate) return true;
    if (_workingMagnitudes.length != entity.magnitudes.length) return true;
    for (int i = 0; i < _workingMagnitudes.length; i++) {
      final wm = _workingMagnitudes[i];
      final om = entity.magnitudes.where((m) => m.id == wm.id).firstOrNull;
      if (om == null) return true;
      if (wm.magnitudeValue != om.magnitudeValue || wm.stringValue != om.stringValue) return true;
    }

    if (_originalRelations != null) {
      if (_workingRelations.length != _originalRelations!.length) return true;
      final origRelKeys = _originalRelations!.map((r) => AppTechnicalStrings.relationKey(r.id, r.sourceEntityId, r.targetEntityId, r.relationType)).toSet();
      for (final wr in _workingRelations) {
        if (!origRelKeys.contains(AppTechnicalStrings.relationKey(wr.id, wr.sourceEntityId, wr.targetEntityId, wr.relationType))) return true;
      }
    }

    if (_originalRequirements != null) {
      if (_workingRequirements.length != _originalRequirements!.length) return true;
      final origReqKeys = _originalRequirements!.map((r) => AppTechnicalStrings.requirementKey(r.id, r.requiredSpeciesId, r.requiredQuantity, r.notes)).toSet();
      for (final wr in _workingRequirements) {
        if (!origReqKeys.contains(AppTechnicalStrings.requirementKey(wr.id, wr.requiredSpeciesId, wr.requiredQuantity, wr.notes))) return true;
      }
    }

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

  Future<void> _handleCancelEditing(WorldEntity entity) async {
    if (_hasUnsavedChanges(entity)) {
      final shouldDiscard = await AppConfirmationDialog.showDiscardChangesDialog(context);
      if (!shouldDiscard) return;
    }
    _syncWorkingStateWithEntity(
      entity,
      relations: _originalRelations,
      requirements: _originalRequirements,
      attachments: _originalAttachments,
      force: true,
    );
    if (mounted) {
      setState(() => _isEditingInPlace = false);
    }
  }

  Future<void> _saveEntityChanges(WorldEntity entity) async {
    final updated = entity.copyWith(
      locationId: _selectedLocationId,
      expirationDate: _selectedExpirationDate,
      magnitudes: _workingMagnitudes,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      updatedAt: DateTime.now(),
    );

    // 1. Save entity
    await ref.read(entityListProvider.notifier).saveEntity(updated);

    // 2. Sync relations delta
    if (_originalRelations != null) {
      final relationRepo = ref.read(relationRepositoryProvider);
      final deletedRelations = _originalRelations!.where((orig) => !_workingRelations.any((w) => w.id == orig.id)).toList();
      final addedRelations = _workingRelations.where((w) => !_originalRelations!.any((orig) => orig.id == w.id)).toList();

      for (final rel in deletedRelations) {
        await relationRepo.deleteRelation(rel.id);
      }
      for (final rel in addedRelations) {
        await relationRepo.addRelation(rel);
      }
    }

    // 3. Sync requirements delta
    if (_originalRequirements != null) {
      final catalogRepo = ref.read(catalogRepositoryProvider);
      final deletedRequirements = _originalRequirements!.where((orig) => !_workingRequirements.any((w) => w.id == orig.id)).toList();
      final addedRequirements = _workingRequirements.where((w) => !_originalRequirements!.any((orig) => orig.id == w.id)).toList();

      for (final req in deletedRequirements) {
        await catalogRepo.deleteRequirement(req.id);
      }
      for (final req in addedRequirements) {
        await catalogRepo.saveRequirement(req);
      }
    }

    // 4. Sync attachments delta
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

      ref.invalidate(instanceAttachmentsProvider(widget.entityId));
    }

    ref.invalidate(entityDetailProvider(widget.entityId));
    ref.invalidate(entityRelationsProvider(widget.entityId));
    ref.invalidate(sourceRequirementsProvider(widget.entityId));
    ref.invalidate(relationListProvider);
    ref.invalidate(entityListProvider);

    _syncWorkingStateWithEntity(
      updated,
      relations: _workingRelations,
      requirements: _workingRequirements,
      attachments: _workingAttachments,
      force: true,
    );

    if (mounted) {
      setState(() => _isEditingInPlace = false);
      AppToast.showSuccess(context, AppStrings.instanceUpdatedSuccess);
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _editMagnitudeDialog(InstanceMagnitude mag) async {
    final valCtrl = TextEditingController(
      text: mag.type.isNumeric
          ? (mag.magnitudeValue != null
              ? (mag.type == PropertyDataType.integer
                  ? mag.magnitudeValue!.toInt().toString()
                  : mag.magnitudeValue!.toString())
              : AppTechnicalStrings.empty)
          : (mag.stringValue ?? AppTechnicalStrings.empty),
    );

    final result = await showDialog<InstanceMagnitude>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.editPropertyTitle(mag.propertyName)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: valCtrl,
              keyboardType: mag.type.isNumeric
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              autofocus: true,
              decoration: InputDecoration(
                labelText: (mag.unitSymbol != null && mag.unitSymbol!.trim().isNotEmpty)
                    ? AppStrings.valueWithUnitLabel(mag.unitSymbol!)
                    : AppStrings.valueWithDataTypeLabel(mag.dataType),
                suffixText: mag.unitSymbol,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () {
              final raw = valCtrl.text.trim();
              if (mag.type.isNumeric) {
                final dVal = raw.isNotEmpty ? double.tryParse(raw) : null;
                Navigator.pop(ctx, mag.copyWith(magnitudeValue: dVal));
              } else {
                final sVal = raw.isNotEmpty ? raw : null;
                Navigator.pop(ctx, mag.copyWith(stringValue: sVal));
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      setState(() {
        final idx = _workingMagnitudes.indexWhere((m) => m.id == mag.id);
        if (idx != -1) {
          _workingMagnitudes[idx] = result;
        }
      });
    }
  }

  Future<void> _addInstancePropertyDialog(CatalogItem species) async {
    final existingNames = _workingMagnitudes.map((m) => AppTechnicalStrings.propertyNameWithUnitKey(m.propertyName, m.unitSymbol)).toSet();
    final availableSpeciesMags = species.magnitudes.where((sm) =>
      !existingNames.contains(AppTechnicalStrings.propertyNameWithUnitKey(sm.propertyName, sm.unitSymbol))
    ).toList();

    if (availableSpeciesMags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.instanceHasAllPropertiesMessage)),
      );
      return;
    }

    final selectedMag = await showDialog<SpeciesMagnitude>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text(AppStrings.addSpeciesPropertyTitle),
        children: availableSpeciesMags.map((sm) {
          final unitText = (sm.unitSymbol != null && sm.unitSymbol!.trim().isNotEmpty)
              ? AppStrings.unitOrTypeInParentheses(sm.unitSymbol!)
              : AppStrings.unitOrTypeInParentheses(sm.dataType);
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  const Icon(Icons.add_circle_outline, size: 18, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Text(AppStrings.propertyNameWithUnitText(sm.propertyName, unitText), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );

    if (selectedMag != null && mounted) {
      setState(() {
        _workingMagnitudes.add(InstanceMagnitude(
          id: const Uuid().v4(),
          instanceId: widget.entityId,
          propertyName: selectedMag.propertyName,
          dataType: selectedMag.dataType,
          magnitudeValue: null,
          unitSymbol: selectedMag.unitSymbol,
        ));
      });
    }
  }

  // Confirm Deletion Flow
  Future<void> _handleDeletion({
    required CatalogItem species,
    required String entityId,
  }) async {
    final confirm = await AppConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: AppStrings.deleteConfirmationTitle,
      message: AppStrings.deleteSpeciesInstanceConfirmation(species.name),
    );

    if (confirm == true) {
      await ref.read(entityRepositoryProvider).deleteEntity(entityId);
      await ref.read(activityLoggerServiceProvider).logEntityDeleted(entityId, species.name);
      ref.read(entityListProvider.notifier).loadEntities();
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final entityAsync = ref.watch(entityDetailProvider(widget.entityId));
    final relationsAsync = ref.watch(entityRelationsProvider(widget.entityId));
    final requirementsAsync = ref.watch(sourceRequirementsProvider(widget.entityId));
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return entityAsync.when(
      data: (entity) {
        if (entity == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(AppStrings.appName)),
            body: const Center(child: Text(AppStrings.appName)),
          );
        }

        final originalRelations = relationsAsync.asData?.value ?? [];
        final originalRequirements = requirementsAsync.asData?.value ?? [];
        final instanceAttachmentsAsync = ref.watch(instanceAttachmentsProvider(widget.entityId));
        final originalAttachments = instanceAttachmentsAsync.asData?.value ?? [];

        if (!_isEditingInPlace) {
          _syncWorkingStateWithEntity(
            entity,
            relations: originalRelations,
            requirements: originalRequirements,
            attachments: originalAttachments,
          );
        }

        final catalogItems = catalogState.asData?.value ?? [];
        final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull ??
            CatalogItem(
              id: entity.speciesId,
              name: AppStrings.typeObject,
              type: AppStrings.typeObject,
              createdAt: DateTime.now(),
            );

        final locationNodes = locationsState.asData?.value ?? [];
        final allEntities = ref.watch(entityListProvider).asData?.value ?? [];
        final allRelations = ref.watch(relationListProvider).asData?.value ?? [];
        final subspeciesList = ref.watch(subspeciesListProvider).asData?.value ?? [];

        final effectiveRelations = _isEditingInPlace
            ? [
                ...allRelations.where((r) => r.sourceEntityId != entity.id && r.targetEntityId != entity.id),
                ..._workingRelations,
              ]
            : allRelations;

        final breadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
          entityId: entity.id,
          effectiveLocationId: _selectedLocationId,
          allEntities: allEntities,
          allRelations: effectiveRelations,
          allNodes: locationNodes,
          catalogItems: catalogItems,
          subspeciesList: subspeciesList,
        );

        // Instance Header Controls & Interactive Directed Graph
        final instanceHeader = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distinct Instance Header Badge & Relacionar Button (ONLY in Edit Mode!)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory_2, size: 14, color: Colors.amber),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            AppStrings.instanceWorldHeader,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: theme.colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isEditingInPlace)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final newRel = await CreateRelationModal.show(
                        context,
                        sourceEntity: entity,
                        returnResultOnly: true,
                      );
                      if (newRel != null && mounted) {
                        setState(() {
                          _workingRelations.add(newRel);
                        });
                      }
                    },
                    icon: const Icon(Icons.alt_route, size: 14),
                    label: const Text(AppStrings.link, style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                  ),
              ],
            ),
              if (entity.subspeciesId != null) ...[
                const SizedBox(height: 10),
                FutureBuilder<Subspecies?>(
                  future: ref.read(catalogRepositoryProvider).getSubspeciesById(entity.subspeciesId!),
                  builder: (context, snapshot) {
                    final sub = snapshot.data;
                    if (sub == null) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer.withAlpha(80),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.colorScheme.secondary.withAlpha(60)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.public, size: 16, color: theme.colorScheme.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.speciesGeneralWithType(species.name, species.type),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                if (sub.barcode != null)
                                  Text(AppStrings.barcodeWithColon(sub.barcode!), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 14),

              // Location Card
              InkWell(
                onTap: () async {
                  if (_isEditingInPlace) {
                    final existingContainerRel = _workingRelations.where((r) =>
                      r.sourceEntityId == widget.entityId && r.relationType == AppTechnicalStrings.relGuardadoEn
                    ).firstOrNull;

                    final currentSelection = existingContainerRel != null
                        ? LocationOrContainerSelection.containerEntity(existingContainerRel.targetEntityId)
                        : LocationOrContainerSelection.physicalNode(_selectedLocationId);

                    final result = await LocationOrContainerSelectionSheet.show(
                      context,
                      initialSelection: currentSelection,
                      excludedContainerIds: {widget.entityId},
                    );
                    if (result != null && mounted) {
                      setState(() {
                        if (result.isPhysicalNode) {
                          _selectedLocationId = result.locationId;
                          _workingRelations.removeWhere((r) =>
                            r.sourceEntityId == widget.entityId &&
                            (r.relationType == AppTechnicalStrings.relGuardadoEn ||
                             r.relationType == AppTechnicalStrings.relParteDe)
                          );
                        } else if (result.isContainerEntity) {
                          _selectedLocationId = null;
                          _workingRelations.removeWhere((r) =>
                            r.sourceEntityId == widget.entityId &&
                            (r.relationType == AppTechnicalStrings.relGuardadoEn ||
                             r.relationType == AppTechnicalStrings.relParteDe)
                          );
                          if (result.containerEntityId != null) {
                            _workingRelations.add(EntityRelation(
                              id: const Uuid().v4(),
                              sourceEntityId: widget.entityId,
                              targetEntityId: result.containerEntityId!,
                              relationType: AppTechnicalStrings.relGuardadoEn,
                              createdAt: DateTime.now(),
                            ));
                          }
                        }
                      });
                    }
                  } else {
                    final containerRel = allRelations.where((r) =>
                      r.sourceEntityId == entity.id &&
                      LocationResolver.locationInheritingTypes.contains(r.relationType)
                    ).firstOrNull;

                    if (containerRel != null) {
                      context.goToInventory(containerId: containerRel.targetEntityId, targetEntityId: entity.id);
                    } else if (_selectedLocationId != null) {
                      context.goToInventory(focusNodeId: _selectedLocationId, targetEntityId: entity.id);
                    } else {
                      context.goToInventory(targetEntityId: entity.id);
                    }
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  color: _isEditingInPlace ? theme.colorScheme.primary.withAlpha(20) : theme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_tree_outlined, color: Colors.black, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.locationGraphNode,
                                style: theme.textTheme.bodySmall,
                              ),
                              if (breadcrumb.ancestorPath.isNotEmpty)
                                Text(
                                  breadcrumb.ancestorPath,
                                  style: TextStyle(color: theme.colorScheme.secondary.withAlpha(180), fontSize: 11),
                                ),
                              Text(
                                breadcrumb.targetName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _isEditingInPlace ? Icons.edit_location : Icons.chevron_right,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Punto 8: Sección de Fecha de Caducidad (expirationDate)
              Card(
                margin: EdgeInsets.zero,
                color: _selectedExpirationDate != null && _selectedExpirationDate!.isBefore(DateTime.now())
                    ? Colors.red.withAlpha(30)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.event_available, color: Colors.orangeAccent, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(AppStrings.expirationDateLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 2),
                            if (_selectedExpirationDate == null)
                              const Text(AppStrings.noExpirationDateAssigned, style: TextStyle(color: Colors.grey, fontSize: 11))
                            else
                              Builder(
                                builder: (_) {
                                  final now = DateTime.now();
                                  final diffDays = _selectedExpirationDate!.difference(now).inDays;
                                  final dateStr = AppStrings.formatDateDMY(_selectedExpirationDate);
                                  if (diffDays < 0) {
                                    return Text(AppStrings.dateFormattedWithDays(dateStr, AppStrings.expiredDaysAgo(-diffDays)), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 11));
                                  } else if (diffDays <= 7) {
                                    return Text(AppStrings.dateFormattedWithDays(dateStr, AppStrings.expiresInDaysAlert(diffDays)), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11));
                                  } else {
                                    return Text(AppStrings.dateFormattedWithDays(dateStr, AppStrings.expiresInDays(diffDays)), style: const TextStyle(color: Colors.green, fontSize: 11));
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                      if (_isEditingInPlace) ...[
                        IconButton(
                          icon: const Icon(Icons.edit_calendar, size: 20),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedExpirationDate ?? DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _selectedExpirationDate = picked);
                            }
                          },
                        ),
                        if (_selectedExpirationDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                            onPressed: () => setState(() => _selectedExpirationDate = null),
                          ),
                      ],
                    ],
                  ),
                ),
              ),

              // Curva de Vida Útil (Shelf-Life Gauge)
              ShelfLifeGaugeWidget(entity: entity),
              const SizedBox(height: 14),

              // Interactive Directed Entity Relations Graph (Passes isEditing mode and draft state!)
              InteractiveEntityGraphWidget(
                currentEntity: entity,
                isEditing: _isEditingInPlace,
                overrideRelations: _isEditingInPlace ? _workingRelations : null,
                onDeleteRelation: (rel) {
                  setState(() {
                    _workingRelations.removeWhere((r) => r.id == rel.id);
                  });
                },
              ),
              const SizedBox(height: 14),

              // Entity Requirements Section (NECESITA - Passes draft state!)
              RequirementsSectionWidget(
                sourceId: entity.id,
                sourceType: AppTechnicalStrings.sourceTypeEntity,
                isEditing: _isEditingInPlace,
                overrideRequirements: _isEditingInPlace ? _workingRequirements : null,
                onRequirementsChanged: (reqs) {
                  setState(() {
                    _workingRequirements = List.from(reqs);
                  });
                },
              ),
              const SizedBox(height: 14),

              // Requisitos 3 & 10: Magnitudes y Propiedades de la Instancia (Lista Interactiva)
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              AppStrings.instancePropertiesAndMagnitudesTitle,
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (_isEditingInPlace)
                            TextButton.icon(
                              onPressed: () => _addInstancePropertyDialog(species),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text(AppStrings.addPropertyAction, style: TextStyle(fontSize: 12)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_workingMagnitudes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(AppStrings.noPropertiesAssignedToInstance, style: TextStyle(color: Colors.grey, fontSize: 12)),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _workingMagnitudes.length,
                          itemBuilder: (ctx, idx) {
                            final mag = _workingMagnitudes[idx];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Icon(mag.type.isNumeric ? Icons.straighten : Icons.label_outlined, size: 18, color: Colors.blueAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      mag.unitSymbol != null && mag.unitSymbol!.trim().isNotEmpty
                                          ? AppStrings.propertyWithUnitOrType(mag.propertyName, mag.unitSymbol!)
                                          : AppStrings.propertyWithUnitOrType(mag.propertyName, mag.dataType),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                  if (_isEditingInPlace)
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => _editMagnitudeDialog(mag),
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: theme.colorScheme.primary),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              mag.displayValue,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: theme.colorScheme.primary),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                          tooltip: AppStrings.deletePropertyFromInstanceTooltip,
                                          onPressed: () async {
                                            final confirm = await AppConfirmationDialog.showDeleteConfirmation(
                                              context: context,
                                              title: AppStrings.confirmDeletePropertyTitle,
                                              message: AppStrings.confirmDeleteProperty(mag.propertyName),
                                            );
                                            if (confirm && mounted) {
                                              setState(() => _workingMagnitudes.removeAt(idx));
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      mag.displayValue,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueAccent),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          );

          // Instance Footer (Notes & Save Action)          // Instance Footer (Notes & Save / Discard Actions)
          final hasNotes = entity.notes != null && entity.notes!.trim().isNotEmpty;
          final Widget? instanceFooter = (_isEditingInPlace || hasNotes)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.notesLabel, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _notesController,
                      enabled: _isEditingInPlace,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: AppStrings.addInstanceNotesHint,
                        filled: !_isEditingInPlace,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                )
              : null;

          final List<Widget> detailViewActions;
          if (!_isEditingInPlace) {
            detailViewActions = [
              IconButton(
                icon: const Icon(Icons.public),
                tooltip: AppStrings.viewCatalogSpecies,
                onPressed: () => context.pushSpeciesDetail(species.id),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: AppStrings.edit,
                onPressed: () => setState(() => _isEditingInPlace = true),
              ),
            ];
          } else {
            detailViewActions = [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: AppStrings.delete,
                onPressed: () => _handleDeletion(species: species, entityId: entity.id),
              ),
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                tooltip: AppStrings.saveChangesAction,
                onPressed: () => _saveEntityChanges(entity),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: AppStrings.cancel,
                onPressed: () => _handleCancelEditing(entity),
              ),
            ];
          }

          final effectiveInstanceName = _isEditingInPlace
              ? _workingMagnitudes.where((m) {
                  final p = m.propertyName.trim().toLowerCase();
                  return p == AppTechnicalStrings.propNombreLower || p == AppTechnicalStrings.propNameLower;
                }).map((m) => m.stringValue?.trim()).firstOrNull
              : EntityDisplayHelper.getInstanceCustomName(entity);
          final customInstanceTitle = (effectiveInstanceName != null && effectiveInstanceName.isNotEmpty)
              ? effectiveInstanceName
              : null;

          Widget currentDetailView;
          if (entity.subspeciesId != null && entity.subspeciesId!.isNotEmpty) {
            currentDetailView = FutureBuilder<Subspecies?>(
              future: ref.read(catalogRepositoryProvider).getSubspeciesById(entity.subspeciesId!),
              builder: (context, subSnapshot) {
                return SpeciesDetailView(
                  species: species,
                  subspecies: subSnapshot.data,
                  customTitle: customInstanceTitle,
                  instanceId: entity.id,
                  showAttachmentAction: _isEditingInPlace,
                  workingInstanceAttachments: _isEditingInPlace ? _workingAttachments : null,
                  onInstanceAttachmentsChanged: _isEditingInPlace
                      ? (updatedList) => setState(() => _workingAttachments = updatedList)
                      : null,
                  instanceSpecificsHeader: instanceHeader,
                  instanceSpecificsFooter: instanceFooter,
                  actions: detailViewActions,
                );
              },
            );
          } else {
            currentDetailView = SpeciesDetailView(
              species: species,
              customTitle: customInstanceTitle,
              instanceId: entity.id,
              showAttachmentAction: _isEditingInPlace,
              workingInstanceAttachments: _isEditingInPlace ? _workingAttachments : null,
              onInstanceAttachmentsChanged: _isEditingInPlace
                  ? (updatedList) => setState(() => _workingAttachments = updatedList)
                  : null,
              instanceSpecificsHeader: instanceHeader,
              instanceSpecificsFooter: instanceFooter,
              actions: detailViewActions,
            );
          }

          return PopScope(
            canPop: !_isEditingInPlace || _forceClose,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              if (_hasUnsavedChanges(entity)) {
                final shouldDiscard = await AppConfirmationDialog.showDiscardChangesDialog(context);
                if (!shouldDiscard || !mounted) return;
              }
              _syncWorkingStateWithEntity(entity, force: true);
              _forceClose = true;
              if (mounted) {
                setState(() => _isEditingInPlace = false);
                Navigator.of(context).pop();
              }
            },
            child: currentDetailView,
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

