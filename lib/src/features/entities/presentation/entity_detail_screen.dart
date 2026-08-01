import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
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
import '../domain/entity_template.dart';

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
  final Map<String, double> _editedMagnitudeValues = {};

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
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
            for (final mag in entity.magnitudes) {
              _editedMagnitudeValues[mag.id] = mag.magnitudeValue;
            }
          }

          final catalogItems = catalogState.asData?.value ?? [];
          final species = catalogItems.where((c) => c.id == entity.speciesId).firstOrNull ??
              CatalogItem(
                id: entity.speciesId,
                name: AppStrings.typeObject,
                type: AppStrings.typeObject,
                createdAt: DateTime.now(),
              );

          final template = EntityTemplateRegistry.getTemplate(species.type);
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

              // Punto 8: Magnitudes 4NF de la Instancia (Lista Interactiva Completa)
              if (template.hasQuantity && hasMagnitudes) ...[
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Magnitudes Físicas de la Instancia (4NF)',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: entity.magnitudes.length,
                          itemBuilder: (ctx, idx) {
                            final mag = entity.magnitudes[idx];
                            final currentVal = _editedMagnitudeValues[mag.id] ?? mag.magnitudeValue;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.straighten, size: 18, color: Colors.blueAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      mag.propertyName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                  if (_isEditingInPlace)
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                                          onPressed: () {
                                            final val = _editedMagnitudeValues[mag.id] ?? mag.magnitudeValue;
                                            final next = (val - 1.0) > 0 ? (val - 1.0) : 0.0;
                                            setState(() => _editedMagnitudeValues[mag.id] = next);
                                          },
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: theme.dividerColor),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            DomainRules.formatMagnitude(currentVal, mag.unitSymbol),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline, size: 20),
                                          onPressed: () {
                                            final val = _editedMagnitudeValues[mag.id] ?? mag.magnitudeValue;
                                            setState(() => _editedMagnitudeValues[mag.id] = val + 1.0);
                                          },
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      '${DomainRules.formatMagnitude(currentVal, mag.unitSymbol)} ${mag.unitSymbol}',
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
                            final updatedMags = entity.magnitudes.map((m) {
                              final newV = _editedMagnitudeValues[m.id];
                              return newV != null ? m.copyWith(magnitudeValue: newV) : m;
                            }).toList();

                            final updated = entity.copyWith(
                              locationId: _selectedLocationId,
                              expirationDate: _selectedExpirationDate,
                              magnitudes: updatedMags,
                              notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
                              updatedAt: DateTime.now(),
                            );

                            await ref.read(entityListProvider.notifier).saveEntity(updated);
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
