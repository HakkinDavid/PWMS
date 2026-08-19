import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../catalog/presentation/species_detail_view.dart';
import '../../locations/domain/location_path_helper.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../../relations/presentation/create_relation_modal.dart';
import '../../relations/presentation/interactive_entity_graph_widget.dart';
import '../../catalog/presentation/requirements_section_widget.dart';
import 'package:uuid/uuid.dart';
import '../../catalog/domain/species_magnitude.dart';
import '../domain/instance_magnitude.dart';


class EntityDetailScreen extends ConsumerStatefulWidget {
  final String entityId;

  const EntityDetailScreen({super.key, required this.entityId});

  @override
  ConsumerState<EntityDetailScreen> createState() => _EntityDetailScreenState();
}

class _EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
  bool _isEditingInPlace = false;
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedLocationId;
  DateTime? _selectedExpirationDate;
  List<InstanceMagnitude> _workingMagnitudes = [];

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _editMagnitudeDialog(InstanceMagnitude mag) async {
    final valCtrl = TextEditingController(
      text: mag.type.isNumeric
          ? mag.magnitudeValue.toString()
          : (mag.stringValue ?? ''),
    );

    final result = await showDialog<InstanceMagnitude>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${AppStrings.editPropertyTitlePrefix}${mag.propertyName}"'),
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
                    ? 'Valor (${mag.unitSymbol})'
                    : 'Valor (${mag.dataType})',
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
                final dVal = double.tryParse(raw) ?? mag.magnitudeValue;
                Navigator.pop(ctx, mag.copyWith(magnitudeValue: dVal));
              } else {
                Navigator.pop(ctx, mag.copyWith(stringValue: raw));
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
    final existingNames = _workingMagnitudes.map((m) => '${m.propertyName}_${m.unitSymbol ?? ""}').toSet();
    final availableSpeciesMags = species.magnitudes.where((sm) =>
      !existingNames.contains('${sm.propertyName}_${sm.unitSymbol ?? ""}')
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
              ? ' (${sm.unitSymbol})'
              : ' (${sm.dataType})';
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  const Icon(Icons.add_circle_outline, size: 18, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Text('${sm.propertyName}$unitText', style: const TextStyle(fontWeight: FontWeight.bold)),
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
          magnitudeValue: 0.0,
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmationTitle),
        content: Text('${AppStrings.deleteConfirmationMessage} "${species.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
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
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: entityAsync.when(
        data: (entity) {
          if (entity == null) {
            return const Center(child: Text(AppStrings.appName));
          }

          final primaryMag = entity.magnitudes.isNotEmpty ? entity.magnitudes.first : null;
          final primaryVal = primaryMag?.magnitudeValue ?? 1.0;
          final primaryUnit = primaryMag?.unitSymbol ?? '';
          final hasMagnitudes = entity.magnitudes.isNotEmpty;

          if (!_isEditingInPlace) {
            _qtyController.text = hasMagnitudes ? DomainRules.formatMagnitude(primaryVal, primaryUnit) : '';
            _notesController.text = entity.notes ?? '';
            _selectedLocationId = entity.locationId;
            _selectedExpirationDate = entity.expirationDate;
            _workingMagnitudes = List.from(entity.magnitudes);
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

          final breadcrumb = LocationPathHelper.buildEffectiveBreadcrumb(
            entityId: entity.id,
            effectiveLocationId: _selectedLocationId,
            allEntities: allEntities,
            allRelations: allRelations,
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
                  Container(
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
                        Text(
                          AppStrings.instanceWorldHeader,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isEditingInPlace)
                    OutlinedButton.icon(
                      onPressed: () => CreateRelationModal.show(context, sourceEntity: entity),
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
                                  '${AppStrings.generalSpeciesPrefix}${species.name} (${species.type})',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                if (sub.barcode != null)
                                  Text('${AppStrings.barcodeLabel}: ${sub.barcode}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
                  if (!_isEditingInPlace && _selectedLocationId != null) {
                    context.go('/locations?focusNodeId=$_selectedLocationId');
                  } else if (_isEditingInPlace) {
                    final pickerResult = await LocationTreePicker.show(
                      context,
                      initialSelectedId: _selectedLocationId,
                    );
                    if (pickerResult != null) {
                      setState(() => _selectedLocationId = pickerResult.locationId);
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
                                  final dateStr = '${_selectedExpirationDate!.day}/${_selectedExpirationDate!.month}/${_selectedExpirationDate!.year}';
                                  if (diffDays < 0) {
                                    return Text('$dateStr (${AppStrings.expiredDaysAgoPrefix}${-diffDays}${AppStrings.expiredDaysAgoSuffix})', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 11));
                                  } else if (diffDays <= 7) {
                                    return Text('$dateStr (${AppStrings.expiresInDaysAlertPrefix}$diffDays${AppStrings.expiresInDaysAlertSuffix})', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11));
                                  } else {
                                    return Text('$dateStr (${AppStrings.expiresInDaysPrefix}$diffDays${AppStrings.expiresInDaysSuffix})', style: const TextStyle(color: Colors.green, fontSize: 11));
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
              const SizedBox(height: 14),

              // Interactive Directed Entity Relations Graph (Passes isEditing mode!)
              InteractiveEntityGraphWidget(
                currentEntity: entity,
                isEditing: _isEditingInPlace,
              ),
              const SizedBox(height: 14),

              // Entity Requirements Section (NECESITA)
              RequirementsSectionWidget(
                sourceId: entity.id,
                sourceType: 'entity',
                isEditing: _isEditingInPlace,
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
                          Text(
                            AppStrings.instancePropertiesAndMagnitudesTitle,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
                                          ? '${mag.propertyName} (${mag.unitSymbol})'
                                          : '${mag.propertyName} (${mag.dataType})',
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
                                          onPressed: () {
                                            setState(() => _workingMagnitudes.removeAt(idx));
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

          // Instance Footer (Notes & Save Action)
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
                    if (_isEditingInPlace) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final updated = entity.copyWith(
                              locationId: _selectedLocationId,
                              expirationDate: _selectedExpirationDate,
                              magnitudes: _workingMagnitudes,
                              notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
                              updatedAt: DateTime.now(),
                            );

                            await ref.read(entityListProvider.notifier).saveEntity(updated);
                            ref.invalidate(entityDetailProvider(widget.entityId));
                            setState(() => _isEditingInPlace = false);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text(AppStrings.saveChangesAction),
                        ),
                      ),
                    ],
                  ],
                )
              : null;

          if (entity.subspeciesId != null && entity.subspeciesId!.isNotEmpty) {
            return FutureBuilder<Subspecies?>(
              future: ref.read(catalogRepositoryProvider).getSubspeciesById(entity.subspeciesId!),
              builder: (context, subSnapshot) {
                return SpeciesDetailView(
                  species: species,
                  subspecies: subSnapshot.data,
                  instanceId: entity.id,
                  showAttachmentAction: false,
                  instanceSpecificsHeader: instanceHeader,
                  instanceSpecificsFooter: instanceFooter,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.public),
                      tooltip: AppStrings.viewCatalogSpecies,
                      onPressed: () => context.push('/catalog/${species.id}'),
                    ),
                    IconButton(
                      icon: Icon(_isEditingInPlace ? Icons.close : Icons.edit_outlined),
                      tooltip: _isEditingInPlace ? AppStrings.cancel : AppStrings.edit,
                      onPressed: () {
                        setState(() => _isEditingInPlace = !_isEditingInPlace);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      tooltip: AppStrings.delete,
                      onPressed: () => _handleDeletion(species: species, entityId: entity.id),
                    ),
                  ],
                );
              },
            );
          }

          return SpeciesDetailView(
            species: species,
            instanceId: entity.id,
            showAttachmentAction: false,
            instanceSpecificsHeader: instanceHeader,
            instanceSpecificsFooter: instanceFooter,
            actions: [
              IconButton(
                icon: const Icon(Icons.public),
                tooltip: AppStrings.viewCatalogSpecies,
                onPressed: () => context.push('/catalog/${species.id}'),
              ),
              IconButton(
                icon: Icon(_isEditingInPlace ? Icons.close : Icons.edit_outlined),
                tooltip: _isEditingInPlace ? AppStrings.cancel : AppStrings.edit,
                onPressed: () {
                  setState(() => _isEditingInPlace = !_isEditingInPlace);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: AppStrings.delete,
                onPressed: () => _handleDeletion(species: species, entityId: entity.id),
              ),
            ],
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, _) => Scaffold(body: Center(child: Text('${AppStrings.errorPrefix}$err'))),
      ),
    );
  }
}
