import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/integer_wheel_picker.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_detail_view.dart';
import '../../locations/domain/location_path_helper.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../../relations/presentation/create_relation_modal.dart';
import '../../relations/presentation/interactive_entity_graph_widget.dart';
import '../domain/entity_template.dart';
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
          final breadcrumb = LocationPathHelper.buildBreadcrumbPath(_selectedLocationId, locationNodes);
          final isIntegerUnit = DomainRules.isIntegerUnit(primaryUnit);

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
                          'INSTANCIA DEL MUNDO',
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
                      label: const Text('Relacionar', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                    ),
                ],
              ),
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

              // Interactive Directed Entity Relations Graph (Passes isEditing mode!)
              InteractiveEntityGraphWidget(
                currentEntity: entity,
                isEditing: _isEditingInPlace,
              ),
              const SizedBox(height: 14),

              // Magnitud Control (Only if magnitudes exist!)
              if (template.hasQuantity && hasMagnitudes) ...[
                Row(
                  children: [
                    Text(
                      AppStrings.quantityLabel,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: _isEditingInPlace ? theme.colorScheme.primary.withAlpha(20) : theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: isIntegerUnit
                          ? Row(
                              children: [
                                if (_isEditingInPlace)
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: () async {
                                      final currentQty = double.tryParse(_qtyController.text.trim()) ?? 1.0;
                                      final newQty = currentQty - 1.0;
                                      if (newQty <= 0) {
                                        await _handleDeletion(species: species, entityId: entity.id);
                                      } else {
                                        setState(() => _qtyController.text = DomainRules.formatMagnitude(newQty, primaryUnit));
                                      }
                                    },
                                  ),
                                GestureDetector(
                                  onTap: isIntegerUnit && _isEditingInPlace
                                      ? () async {
                                          final currentVal = (double.tryParse(_qtyController.text.trim()) ?? 1.0).toInt();
                                          final picked = await IntegerWheelPicker.show(context, initialValue: currentVal, minValue: 0);
                                          if (picked != null) {
                                            if (picked == 0) {
                                              await _handleDeletion(species: species, entityId: entity.id);
                                            } else {
                                              setState(() => _qtyController.text = '$picked');
                                            }
                                          }
                                        }
                                      : null,
                                  child: Container(
                                    width: 60,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      _qtyController.text,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                ),
                                if (primaryUnit.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      primaryUnit,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                if (_isEditingInPlace)
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: () {
                                      final currentQty = double.tryParse(_qtyController.text.trim()) ?? 0.0;
                                      final newQty = currentQty + 1.0;
                                      setState(() => _qtyController.text = DomainRules.formatMagnitude(newQty, primaryUnit));
                                    },
                                  ),
                              ],
                            )
                          : Container(
                              width: 110,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _qtyController,
                                      enabled: _isEditingInPlace,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  if (primaryUnit.isNotEmpty)
                                    Text(
                                      primaryUnit,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ],
          );

          // Instance Footer (Notes)
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
                        hintText: 'Añadir notas sobre esta instancia...',
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
                            final newQty = double.tryParse(_qtyController.text.trim()) ?? primaryVal;
                            final hasLocationChanged = _selectedLocationId != entity.locationId;
                            final hasQtyChanged = newQty != primaryVal;
                            final hasNotesChanged = _notesController.text.trim() != (entity.notes ?? '');

                            if (hasLocationChanged || hasQtyChanged || hasNotesChanged) {
                              final updatedMags = List<InstanceMagnitude>.from(entity.magnitudes);
                              if (updatedMags.isNotEmpty) {
                                updatedMags[0] = updatedMags[0].copyWith(magnitudeValue: newQty);
                              }

                              final updated = entity.copyWith(
                                locationId: _selectedLocationId,
                                magnitudes: updatedMags,
                                notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
                                updatedAt: DateTime.now(),
                              );

                              await ref.read(entityListProvider.notifier).saveEntity(updated);
                            }

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

          return SpeciesDetailView(
            species: species,
            showAttachmentAction: false,
            instanceSpecificsHeader: instanceHeader,
            instanceSpecificsFooter: instanceFooter,
            actions: [
              IconButton(
                icon: const Icon(Icons.public),
                tooltip: 'Ver Especie en Catálogo',
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
        error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
      ),
    );
  }
}
