import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/units_registry.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_detail_view.dart';
import '../../locations/domain/location_path_helper.dart';
import '../../locations/presentation/location_tree_picker.dart';
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

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _promptMonetaryTransaction({
    required String speciesId,
    required String entityId,
    required String transactionType,
    required double magnitudeDelta,
    required String currency,
    bool isSale = false,
  }) async {
    final amountCtrl = TextEditingController(text: '0.0');
    final notesCtrl = TextEditingController();
    String selectedCurrency = currency;
    bool registerSale = isSale;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(registerSale ? 'Registrar Venta' : 'Registro Financiero'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto Monetario',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedCurrency,
              items: const [
                DropdownMenuItem(value: 'MXN', child: Text('MXN')),
                DropdownMenuItem(value: 'USD', child: Text('USD')),
              ],
              onChanged: (v) {
                if (v != null) selectedCurrency = v;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notas financieras',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.save, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (result == true) {
      final amount = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
      await ref.read(financialRepositoryProvider).recordTransaction(
        speciesId: speciesId,
        entityId: entityId,
        transactionType: transactionType,
        magnitudeDelta: magnitudeDelta,
        amount: amount,
        currency: selectedCurrency,
        isSale: registerSale,
        notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
      );
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

          if (!_isEditingInPlace) {
            _qtyController.text = (entity.quantity ?? 1.0).toString();
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

          // SI Unit Decimal Rule
          final allowsDecimals = UnitsRegistry.allowsDecimals(entity.unit ?? species.defaultUnit);

          // Instance Header Controls
          final instanceHeader = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distinct Instance Header Badge (Rule #14)
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
              const SizedBox(height: 14),

              // Location Card (Tapping navigates to Locations screen focusing this node - Rule #22 & #23)
              InkWell(
                onTap: () {
                  if (!_isEditingInPlace && _selectedLocationId != null) {
                    context.go('/locations?focusNodeId=$_selectedLocationId');
                  } else if (_isEditingInPlace) {
                    LocationTreePicker.show(
                      context,
                      initialSelectedId: _selectedLocationId,
                    ).then((newLocId) {
                      if (newLocId != null) setState(() => _selectedLocationId = newLocId);
                    });
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

              // Magnitud Control (Rule #12 & Rule #13: Greyed out in view mode, editable in edit mode)
              if (template.hasQuantity) ...[
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
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            onPressed: () async {
                              final currentQty = double.tryParse(_qtyController.text.trim()) ?? 1.0;
                              final step = allowsDecimals ? 0.5 : 1.0;
                              final newQty = currentQty - step;

                              if (newQty <= 0) {
                                bool isSale = false;
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => StatefulBuilder(
                                    builder: (c, setStateDialog) => AlertDialog(
                                      title: const Text(AppStrings.deleteConfirmationTitle),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('${AppStrings.zeroQuantityMessage} "${species.name}"?'),
                                          if (species.hasMonetaryValue)
                                            CheckboxListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: const Text(AppStrings.isSaleLabel),
                                              value: isSale,
                                              onChanged: (v) => setStateDialog(() => isSale = v ?? false),
                                            ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                                if (confirm == true) {
                                  if (species.hasMonetaryValue) {
                                    await _promptMonetaryTransaction(
                                      speciesId: species.id,
                                      entityId: entity.id,
                                      transactionType: 'decrement',
                                      magnitudeDelta: -currentQty,
                                      currency: species.defaultMonetaryCurrency,
                                      isSale: isSale,
                                    );
                                  }
                                  await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                                  ref.read(entityListProvider.notifier).loadEntities();
                                  if (context.mounted) context.pop();
                                }
                              } else {
                                final updated = entity.copyWith(quantity: newQty, updatedAt: DateTime.now());
                                await ref.read(entityListProvider.notifier).saveEntity(updated);
                                if (species.hasMonetaryValue) {
                                  await _promptMonetaryTransaction(
                                    speciesId: species.id,
                                    entityId: entity.id,
                                    transactionType: 'decrement',
                                    magnitudeDelta: -step,
                                    currency: species.defaultMonetaryCurrency,
                                  );
                                }
                              }
                            },
                          ),
                          SizedBox(
                            width: 60,
                            child: TextField(
                              controller: _qtyController,
                              enabled: _isEditingInPlace,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.numberWithOptions(decimal: allowsDecimals),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              decoration: const InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          Text(
                            entity.unit ?? species.defaultUnit ?? "",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add, size: 16),
                            onPressed: () async {
                              final currentQty = double.tryParse(_qtyController.text.trim()) ?? 0.0;
                              final step = allowsDecimals ? 0.5 : 1.0;
                              final newQty = currentQty + step;
                              final updated = entity.copyWith(quantity: newQty, updatedAt: DateTime.now());
                              await ref.read(entityListProvider.notifier).saveEntity(updated);

                              if (species.hasMonetaryValue) {
                                await _promptMonetaryTransaction(
                                  speciesId: species.id,
                                  entityId: entity.id,
                                  transactionType: 'increment',
                                  magnitudeDelta: step,
                                  currency: species.defaultMonetaryCurrency,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ],
          );

          // Instance Footer (Notes Field)
          final instanceFooter = Column(
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
                      final newQty = double.tryParse(_qtyController.text.trim()) ?? (entity.quantity ?? 1.0);
                      final updated = entity.copyWith(
                        locationId: _selectedLocationId,
                        quantity: newQty,
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
          );

          return SpeciesDetailView(
            species: species,
            instanceSpecificsHeader: instanceHeader,
            instanceSpecificsFooter: instanceFooter,
            actions: [
              // Rule #15: Button to Species Screen
              IconButton(
                icon: const Icon(Icons.public),
                tooltip: 'Ver Especie en Catálogo',
                onPressed: () => context.push('/catalog/${species.id}'),
              ),
              // Rule #13: Single Pencil Icon Button in AppBar for In-place editing
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
                onPressed: () async {
                  bool isSale = false;
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => StatefulBuilder(
                      builder: (c, setStateDialog) => AlertDialog(
                        title: const Text(AppStrings.deleteConfirmationTitle),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${AppStrings.deleteConfirmationMessage} "${species.name}"?'),
                            if (species.hasMonetaryValue)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(AppStrings.isSaleLabel),
                                value: isSale,
                                onChanged: (v) => setStateDialog(() => isSale = v ?? false),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text(AppStrings.delete, style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ),
                  );

                  if (confirm == true) {
                    if (species.hasMonetaryValue) {
                      await _promptMonetaryTransaction(
                        speciesId: species.id,
                        entityId: entity.id,
                        transactionType: 'delete',
                        magnitudeDelta: -(entity.quantity ?? 1.0),
                        currency: species.defaultMonetaryCurrency,
                        isSale: isSale,
                      );
                    }
                    await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                    await ref.read(activityLoggerServiceProvider).logEntityDeleted(entity.id, species.name);
                    ref.read(entityListProvider.notifier).loadEntities();

                    if (context.mounted) {
                      context.pop();
                    }
                  }
                },
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
