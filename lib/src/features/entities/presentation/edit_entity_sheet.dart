import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../../catalog/domain/catalog_item.dart';
import '../domain/instance_magnitude.dart';
import '../domain/world_entity.dart';

class EditEntitySheet extends ConsumerStatefulWidget {
  final WorldEntity entity;

  const EditEntitySheet({super.key, required this.entity});

  static Future<void> show(BuildContext context, WorldEntity entity) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditEntitySheet(entity: entity),
    );
  }

  @override
  ConsumerState<EditEntitySheet> createState() => _EditEntitySheetState();
}

class _EditEntitySheetState extends ConsumerState<EditEntitySheet> {
  late TextEditingController _notesController;
  late TextEditingController _qtyController;

  String? _selectedLocationId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.entity.notes ?? '');
    final firstMag = widget.entity.magnitudes.isNotEmpty ? widget.entity.magnitudes.first : null;
    _qtyController = TextEditingController(
      text: firstMag != null ? DomainRules.formatMagnitude(firstMag.magnitudeValue, firstMag.unitSymbol) : '1',
    );
    _selectedLocationId = widget.entity.locationId;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    try {
      final double? parsedQty = double.tryParse(_qtyController.text.trim());

      final entityRepo = ref.read(entityRepositoryProvider);
      final mergedOrUpdated = await entityRepo.moveOrMergeEntity(widget.entity.id, _selectedLocationId);

      if (mergedOrUpdated != null) {
        final updatedMags = List<InstanceMagnitude>.from(mergedOrUpdated.magnitudes);
        if (parsedQty != null && updatedMags.isNotEmpty) {
          updatedMags[0] = updatedMags[0].copyWith(magnitudeValue: parsedQty);
        }

        final finalEntity = mergedOrUpdated.copyWith(
          magnitudes: updatedMags,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : mergedOrUpdated.notes,
          updatedAt: DateTime.now(),
        );
        await entityRepo.saveEntity(finalEntity);
      }
      ref.read(entityListProvider.notifier).loadEntities();

      if (mounted) {
        Navigator.pop(context);
        AppToast.showSuccess(context, AppStrings.instanceUpdatedSuccess);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, '${AppStrings.updateErrorPrefix}$e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsState = ref.watch(locationNodeListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final species = catalogItems.where((c) => c.id == widget.entity.speciesId).firstOrNull ??
        CatalogItem(
          id: widget.entity.speciesId,
          name: AppStrings.instantiatedObject,
          type: AppStrings.typeObject,
          createdAt: DateTime.now(),
        );

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppStrings.editInstanceTitle} "${species.name}"',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Location Selector Node in Location Graph
            Text(AppStrings.graphLocationOrContainer, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            locationsState.when(
              data: (nodes) {
                final selectedNode = nodes.where((n) => n.id == _selectedLocationId).firstOrNull;
                return InkWell(
                  onTap: () async {
                    final picked = await AppWheelPicker.show<String?>(
                      context,
                      items: [null, ...nodes.map((n) => n.id)],
                      initialValue: _selectedLocationId,
                      labelBuilder: (id) => id == null ? AppStrings.rootLocationName : (nodes.where((n) => n.id == id).firstOrNull?.name ?? id),
                      title: AppStrings.selectLocationPrompt,
                    );
                    if (picked != _selectedLocationId) {
                      setState(() => _selectedLocationId = picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.account_tree_outlined)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedNode?.name ?? AppStrings.rootLocationName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Icon(Icons.unfold_more),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('${AppStrings.errorPrefix}$err'),
            ),
            const SizedBox(height: 16),

            // Quantity Input
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: AppStrings.quantityLabel,
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 16),

            // Notes / Serial
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: AppStrings.instanceNotesLabel,
                hintText: AppStrings.specificDetailsHint,
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(AppStrings.saveChangesAction, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
