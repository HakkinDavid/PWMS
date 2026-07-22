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

  // Acquisition Cost Prompt ("Por pieza" vs "Monto total")
  Future<void> _promptAcquisitionCost({
    required String speciesId,
    required String entityId,
    required double magnitudeDelta,
    required String currency,
  }) async {
    final amountCtrl = TextEditingController(text: '0.0');
    final notesCtrl = TextEditingController();
    String selectedCurrency = currency;
    bool isPerUnit = true;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (c, setStateDialog) => AlertDialog(
          title: const Text('Costo de Adquisición'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: const Center(child: Text('Por pieza')),
                      selected: isPerUnit,
                      onSelected: (val) {
                        if (val) setStateDialog(() => isPerUnit = true);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: const Center(child: Text('Monto total')),
                      selected: !isPerUnit,
                      onSelected: (val) {
                        if (val) setStateDialog(() => isPerUnit = false);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: isPerUnit ? 'Precio por unidad' : 'Costo total registrado',
                  prefixIcon: const Icon(Icons.attach_money),
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
                  if (v != null) setStateDialog(() => selectedCurrency = v);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Omitir')),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(AppStrings.save, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      final enteredAmount = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
      final totalAmount = isPerUnit ? (enteredAmount * magnitudeDelta.abs()) : enteredAmount;

      await ref.read(financialRepositoryProvider).recordTransaction(
        speciesId: speciesId,
        entityId: entityId,
        transactionType: 'acquisition',
        magnitudeDelta: magnitudeDelta,
        amount: totalAmount,
        currency: selectedCurrency,
        isSale: false,
        notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
      );
    }
  }

  // Deletion Sale Prompt (ONLY if isSale == true)
  Future<void> _promptSaleTransaction({
    required String speciesId,
    required String entityId,
    required double magnitudeDelta,
    required String currency,
  }) async {
    final amountCtrl = TextEditingController(text: '0.0');
    String selectedCurrency = currency;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrar Venta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto Total de Venta',
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
        transactionType: 'sale',
        magnitudeDelta: magnitudeDelta,
        amount: amount,
        currency: selectedCurrency,
        isSale: true,
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

          final unitSymbol = entity.unit ?? species.defaultUnit;
          final isIntegerUnit = DomainRules.isIntegerUnit(unitSymbol);

          // Instance Header Controls
          final instanceHeader = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distinct Instance Header Badge
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

              // Magnitud Control (Points 5 & 6: Decimal vs Integer mode in editing)
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
                      child: isIntegerUnit
                          // Integer Magnitudes (Point 6: Integer field + -/+ buttons + Wheel Picker on tap)
                          ? Row(
                              children: [
                                if (_isEditingInPlace)
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: () async {
                                      final currentQty = double.tryParse(_qtyController.text.trim()) ?? 1.0;
                                      final newQty = currentQty - 1.0;
                                      if (newQty > 0) {
                                        setState(() => _qtyController.text = '${newQty.toInt()}');
                                      }
                                    },
                                  ),
                                GestureDetector(
                                  onTap: isIntegerUnit && _isEditingInPlace
                                      ? () async {
                                          final currentVal = (double.tryParse(_qtyController.text.trim()) ?? 1.0).toInt();
                                          final picked = await IntegerWheelPicker.show(context, initialValue: currentVal);
                                          if (picked != null) {
                                            setState(() => _qtyController.text = '$picked');
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
                                Text(
                                  unitSymbol ?? "",
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                if (_isEditingInPlace)
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: () {
                                      final currentQty = double.tryParse(_qtyController.text.trim()) ?? 0.0;
                                      final newQty = currentQty + 1.0;
                                      setState(() => _qtyController.text = '${newQty.toInt()}');
                                    },
                                  ),
                              ],
                            )
                          // Decimal Magnitudes (Point 5: Editable ONLY as decimal number textfield)
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
                                  Text(
                                    unitSymbol ?? "",
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

          // Instance Footer (Point 4: Hide Notes if empty and not in edit mode!)
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
                            final originalQty = entity.quantity ?? 1.0;
                            final newQty = double.tryParse(_qtyController.text.trim()) ?? originalQty;
                            final hasLocationChanged = _selectedLocationId != entity.locationId;
                            final hasQtyChanged = newQty != originalQty;
                            final hasNotesChanged = _notesController.text.trim() != (entity.notes ?? '');

                            // Point 7: Only save and trigger finance/refresh if actual changes occurred!
                            if (hasLocationChanged || hasQtyChanged || hasNotesChanged) {
                              final updated = entity.copyWith(
                                locationId: _selectedLocationId,
                                quantity: newQty,
                                notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
                                updatedAt: DateTime.now(),
                              );

                              await ref.read(entityListProvider.notifier).saveEntity(updated);

                              // Point 7: Financial prompt ONLY if magnitude actually increased!
                              if (hasQtyChanged && newQty > originalQty && species.hasMonetaryValue) {
                                final delta = newQty - originalQty;
                                await _promptAcquisitionCost(
                                  speciesId: species.id,
                                  entityId: entity.id,
                                  magnitudeDelta: delta,
                                  currency: species.defaultMonetaryCurrency,
                                );
                              }
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
            showAttachmentAction: false, // Point 1: Hide attach file button on Instance screen!
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
                    // Rule: ONLY prompt for financial data if isSale == true!
                    if (species.hasMonetaryValue && isSale) {
                      await _promptSaleTransaction(
                        speciesId: species.id,
                        entityId: entity.id,
                        magnitudeDelta: -(entity.quantity ?? 1.0),
                        currency: species.defaultMonetaryCurrency,
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
