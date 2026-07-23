import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/species_requirement.dart';

class RequirementsSectionWidget extends ConsumerStatefulWidget {
  final String sourceId;
  final String sourceType; // 'species' or 'entity'
  final String title;

  const RequirementsSectionWidget({
    super.key,
    required this.sourceId,
    this.sourceType = 'species',
    this.title = 'Insumos / Requisitos (NECESITA)',
  });

  @override
  ConsumerState<RequirementsSectionWidget> createState() => _RequirementsSectionWidgetState();
}

class _RequirementsSectionWidgetState extends ConsumerState<RequirementsSectionWidget> {
  List<SpeciesRequirement> _requirements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequirements();
  }

  Future<void> _loadRequirements() async {
    setState(() => _isLoading = true);
    try {
      final reqs = await ref.read(catalogRepositoryProvider).getRequirementsForSource(widget.sourceId);
      if (mounted) setState(() => _requirements = reqs);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addRequirementDialog() async {
    final catalogState = ref.read(catalogListProvider);
    final catalogItems = catalogState.asData?.value ?? [];

    if (catalogItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay especies en el catálogo para requerir.')),
      );
      return;
    }

    String? selectedSpeciesId = catalogItems.first.id;
    final qtyController = TextEditingController(text: '1');
    final notesController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Agregar Requisito NECESITA'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Selecciona la especie requerida e indica la cantidad necesaria:'),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedSpeciesId,
                  decoration: const InputDecoration(labelText: 'Especie Requerida'),
                  items: catalogItems.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                  onChanged: (val) => setState(() => selectedSpeciesId = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cantidad Requerida', hintText: 'Ej. 6'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notas (Opcional)', hintText: 'Ej. Baterías para encendido'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );

    if (confirm == true && selectedSpeciesId != null) {
      final qty = double.tryParse(qtyController.text.trim()) ?? 1.0;
      final newReq = SpeciesRequirement(
        id: const Uuid().v4(),
        sourceId: widget.sourceId,
        sourceType: widget.sourceType,
        requiredSpeciesId: selectedSpeciesId!,
        requiredQuantity: qty,
        notes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
        createdAt: DateTime.now(),
      );

      await ref.read(catalogRepositoryProvider).saveRequirement(newReq);
      _loadRequirements();
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogListProvider);
    final catalogItems = catalogState.asData?.value ?? [];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _addRequirementDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar'),
            ),
          ],
        ),
        const SizedBox(height: 4),

        if (_isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
        else if (_requirements.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Text('No hay insumos o requisitos definidos.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _requirements.length,
            itemBuilder: (context, index) {
              final req = _requirements[index];
              final reqSpecies = catalogItems.where((c) => c.id == req.requiredSpeciesId).firstOrNull;
              final speciesName = reqSpecies?.name ?? 'Especie';
              final formattedQty = req.requiredQuantity % 1 == 0 ? '${req.requiredQuantity.toInt()}' : '${req.requiredQuantity}';

              return Card(
                margin: const EdgeInsets.only(bottom: 6),
                elevation: 0.5,
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary.withAlpha(25),
                    child: Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.primary, size: 16),
                  ),
                  title: Text(
                    'NECESITA $formattedQty x $speciesName',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  subtitle: req.notes != null ? Text(req.notes!, style: const TextStyle(fontSize: 11)) : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    onPressed: () async {
                      await ref.read(catalogRepositoryProvider).deleteRequirement(req.id);
                      _loadRequirements();
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
