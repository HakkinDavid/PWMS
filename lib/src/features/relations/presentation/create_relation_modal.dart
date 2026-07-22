import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../../entities/domain/entity_template.dart';
import '../../entities/domain/world_entity.dart';
import '../domain/entity_relation.dart';

class CreateRelationModal extends ConsumerStatefulWidget {
  final WorldEntity sourceEntity;

  const CreateRelationModal({
    super.key,
    required this.sourceEntity,
  });

  static Future<void> show(BuildContext context, {required WorldEntity sourceEntity}) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateRelationModal(sourceEntity: sourceEntity),
    );
  }

  @override
  ConsumerState<CreateRelationModal> createState() => _CreateRelationModalState();
}

class _CreateRelationModalState extends ConsumerState<CreateRelationModal> {
  WorldEntity? _selectedTargetEntity;
  String _selectedRelationType = EntityTemplateRegistry.directedRelationTypes.first;
  bool _isSaving = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _saveRelation() async {
    if (_selectedTargetEntity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una entidad objetivo')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final relationRepo = ref.read(relationRepositoryProvider);
      final newRelation = EntityRelation(
        id: const Uuid().v4(),
        sourceEntityId: widget.sourceEntity.id,
        targetEntityId: _selectedTargetEntity!.id,
        relationType: _selectedRelationType,
        createdAt: DateTime.now(),
      );

      await relationRepo.addRelation(newRelation);
      ref.invalidate(entityRelationsProvider(widget.sourceEntity.id));
      ref.invalidate(entityRelationsProvider(_selectedTargetEntity!.id));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Relación "$_selectedRelationType" creada con éxito'),
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
    final theme = Theme.of(context);
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);

    final allEntities = entitiesState.asData?.value ?? [];
    final catalogItems = catalogState.asData?.value ?? [];

    final sourceSpecies = catalogItems.where((c) => c.id == widget.sourceEntity.speciesId).firstOrNull;
    final availableTargets = allEntities.where((e) {
      if (e.id == widget.sourceEntity.id) return false;
      if (_searchQuery.isEmpty) return true;
      final targetSpecies = catalogItems.where((c) => c.id == e.speciesId).firstOrNull;
      final name = targetSpecies?.name.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: Column(
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
            const SizedBox(height: 12),
            Text(
              'Relacionar "${sourceSpecies?.name ?? "Instancia"}"',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Relation Type Wheel Picker
            InkWell(
              onTap: () async {
                final picked = await AppWheelPicker.show<String>(
                  context,
                  items: EntityTemplateRegistry.directedRelationTypes,
                  initialValue: _selectedRelationType,
                  labelBuilder: (type) => type,
                  title: 'Seleccionar Tipo de Relación Dirigida',
                );
                if (picked != null) {
                  setState(() => _selectedRelationType = picked);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Relación Dirigida (Origen ➔ Destino)',
                  prefixIcon: Icon(Icons.alt_route),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedRelationType, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Icon(Icons.unfold_more),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Search Target Entity
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar Entidad Destino',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),

            // List of Target Candidates
            Expanded(
              child: availableTargets.isEmpty
                  ? const Center(child: Text('No hay entidades disponibles para relacionar.'))
                  : ListView.builder(
                      itemCount: availableTargets.length,
                      itemBuilder: (ctx, idx) {
                        final target = availableTargets[idx];
                        final targetSpecies = catalogItems.where((c) => c.id == target.speciesId).firstOrNull;
                        final isSelected = _selectedTargetEntity?.id == target.id;

                        return Card(
                          color: isSelected ? theme.colorScheme.primary.withAlpha(30) : null,
                          child: ListTile(
                            dense: true,
                            leading: Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isSelected ? theme.colorScheme.primary : Colors.grey,
                            ),
                            title: Text(targetSpecies?.name ?? 'Instancia Destino', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(targetSpecies?.type ?? 'Objeto'),
                            onTap: () {
                              setState(() => _selectedTargetEntity = target);
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveRelation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Crear Relación Dirigida', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
