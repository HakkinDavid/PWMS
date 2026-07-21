import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../catalog/domain/catalog_item.dart';
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
  late TextEditingController _unitController;

  String? _selectedLocationId;
  late bool _isArchived;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.entity.notes ?? '');
    _qtyController = TextEditingController(text: widget.entity.quantity?.toString() ?? '');
    _unitController = TextEditingController(text: widget.entity.unit ?? '');
    _selectedLocationId = widget.entity.locationId;
    _isArchived = widget.entity.isArchived;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    try {
      final double? parsedQty = double.tryParse(_qtyController.text.trim());
      final String? parsedUnit = _unitController.text.trim().isNotEmpty ? _unitController.text.trim() : null;

      final entityRepo = ref.read(entityRepositoryProvider);
      final mergedOrUpdated = await entityRepo.moveOrMergeEntity(widget.entity.id, _selectedLocationId);

      if (mergedOrUpdated != null) {
        final finalEntity = mergedOrUpdated.copyWith(
          quantity: parsedQty ?? mergedOrUpdated.quantity,
          unit: parsedUnit ?? mergedOrUpdated.unit,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : mergedOrUpdated.notes,
          isArchived: _isArchived,
          updatedAt: DateTime.now(),
        );
        await entityRepo.saveEntity(finalEntity);
      }
      ref.read(entityListProvider.notifier).loadEntities();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Instancia actualizada con éxito'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
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
          name: 'Objeto Instanciado',
          type: 'Objeto / Herramienta',
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
                  'Editar Instancia "${species.name}"',
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
            Text('Ubicación en el Grafo (Lugar o Contenedor)', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            locationsState.when(
              data: (nodes) {
                return DropdownButtonFormField<String?>(
                  initialValue: _selectedLocationId,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.account_tree_outlined)),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Mundo (Raíz)')),
                    ...nodes.map((n) => DropdownMenuItem<String?>(value: n.id, child: Text(n.name))),
                  ],
                  onChanged: (val) => setState(() => _selectedLocationId = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 16),

            // Quantity Input
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 16),

            // Archive Toggle
            SwitchListTile(
              title: const Text('Archivar elemento (Ocultar de la vista principal)'),
              value: _isArchived,
              onChanged: (val) => setState(() => _isArchived = val),
            ),
            const SizedBox(height: 16),

            // Notes / Serial
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notas / Número de Serie de esta Instancia',
                hintText: 'Detalles específicos...',
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
                    : const Text('Guardar Cambios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
