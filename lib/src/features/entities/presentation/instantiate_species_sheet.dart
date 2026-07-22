import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../../../core/widgets/integer_wheel_picker.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../locations/presentation/location_tree_picker.dart';
import '../domain/entity_template.dart';

class InstantiateSpeciesSheet extends ConsumerStatefulWidget {
  final CatalogItem species;
  final String? initialLocationId;

  const InstantiateSpeciesSheet({
    super.key,
    required this.species,
    this.initialLocationId,
  });

  static Future<void> show(
    BuildContext context, {
    required CatalogItem species,
    String? initialLocationId,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InstantiateSpeciesSheet(
        species: species,
        initialLocationId: initialLocationId,
      ),
    );
  }

  @override
  ConsumerState<InstantiateSpeciesSheet> createState() => _InstantiateSpeciesSheetState();
}

class _InstantiateSpeciesSheetState extends ConsumerState<InstantiateSpeciesSheet> {
  final _qtyController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  String? _selectedLocationId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickLocationFromTree() async {
    final result = await LocationTreePicker.show(context, initialSelectedId: _selectedLocationId);
    if (result != null) {
      setState(() {
        _selectedLocationId = result.locationId;
      });
    }
  }

  Future<void> _promptAcquisitionCost(String instanceId, double addQty) async {
    final amountCtrl = TextEditingController(text: '0.0');
    String selectedCurrency = widget.species.defaultMonetaryCurrency;
    bool isPerUnit = true;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (c, setStateDialog) => AlertDialog(
          title: const Text('Costo de Adquisición (Compra)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: const Center(child: Text('Por pieza/unidad')),
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
              InkWell(
                onTap: () async {
                  final picked = await AppWheelPicker.show<String>(
                    context,
                    items: const ['MXN', 'USD'],
                    initialValue: selectedCurrency,
                    labelBuilder: (c) => c,
                    title: 'Seleccionar Moneda',
                  );
                  if (picked != null) setStateDialog(() => selectedCurrency = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: AppStrings.currencyLabel),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedCurrency, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Icon(Icons.unfold_more),
                    ],
                  ),
                ),
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
      final totalAmount = isPerUnit ? (enteredAmount * addQty.abs()) : enteredAmount;

      await ref.read(financialRepositoryProvider).recordTransaction(
        speciesId: widget.species.id,
        entityId: instanceId,
        transactionType: 'acquisition',
        magnitudeDelta: addQty,
        amount: totalAmount,
        currency: selectedCurrency,
        isSale: false,
      );
    }
  }

  Future<void> _confirmInstantiation() async {
    final template = EntityTemplateRegistry.getTemplate(widget.species.type);

    // Single instance check for non-countable abstract templates or unique species
    if (!template.hasQuantity || widget.species.isUnique) {
      final existingEntities = ref.read(entityListProvider).asData?.value ?? [];
      final alreadyExists = existingEntities.any((e) => e.speciesId == widget.species.id);
      if (alreadyExists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.singleInstanceError),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
    }

    final double addQty = double.tryParse(_qtyController.text.trim()) ?? 1.0;
    setState(() => _isSaving = true);

    try {
      final entityRepo = ref.read(entityRepositoryProvider);
      final result = await entityRepo.instantiateOrMerge(
        widget.species.id,
        _selectedLocationId,
        addQty,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        unit: 'unidad',
      );

      ref.read(entityListProvider.notifier).loadEntities();
      await ref.read(activityLoggerServiceProvider).logEntityCreated(result.id, widget.species.name, widget.species.type);

      // Prompt acquisition cost ONLY IF isSubjectToPurchase == true
      if (widget.species.isSubjectToPurchase && mounted) {
        await _promptAcquisitionCost(result.id, addQty);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${widget.species.name}" instanciado'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);
    final template = EntityTemplateRegistry.getTemplate(widget.species.type);

    String locationDisplayName = AppStrings.rootLocationName;
    if (_selectedLocationId != null) {
      locationsState.whenData((nodes) {
        final found = nodes.where((n) => n.id == _selectedLocationId).firstOrNull;
        if (found != null) locationDisplayName = found.name;
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
              'Instanciar "${widget.species.name}"',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Location Picker
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
            const SizedBox(height: 16),

            // Quantity (Wheel Picker for Integer Units)
            if (template.hasQuantity && !widget.species.isUnique) ...[
              GestureDetector(
                onTap: () async {
                  final currentVal = (double.tryParse(_qtyController.text.trim()) ?? 1.0).toInt();
                  final picked = await IntegerWheelPicker.show(context, initialValue: currentVal, minValue: 1);
                  if (picked != null) {
                    setState(() => _qtyController.text = '$picked');
                  }
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: AppStrings.quantityLabel,
                      suffixText: 'unidad',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Optional Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: AppStrings.notesLabel,
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Instantiation Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _confirmInstantiation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(AppStrings.instantiateAction, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
