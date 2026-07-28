import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/effective_entity_group.dart';
import 'instance_preview_card.dart';
import 'quantity_operation_helper.dart';

class GroupedInstanceDetailScreen extends ConsumerStatefulWidget {
  final String speciesId;
  final String? effectiveLocationId;

  const GroupedInstanceDetailScreen({
    super.key,
    required this.speciesId,
    this.effectiveLocationId,
  });

  @override
  ConsumerState<GroupedInstanceDetailScreen> createState() => _GroupedInstanceDetailScreenState();
}

class _GroupedInstanceDetailScreenState extends ConsumerState<GroupedInstanceDetailScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allEntities = ref.watch(entityListProvider).asData?.value ?? [];
    final catalog = ref.watch(catalogListProvider).asData?.value ?? [];
    final species = catalog.where((c) => c.id == widget.speciesId).firstOrNull;
    final speciesName = species?.name ?? AppStrings.typeObject;

    // Build matching EffectiveEntityGroup
    final matchingEntities = allEntities.where((e) {
      final locMatch = widget.effectiveLocationId == null ? (e.locationId == null) : (e.locationId == widget.effectiveLocationId);
      return e.speciesId == widget.speciesId && locMatch;
    }).toList();

    if (matchingEntities.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(speciesName)),
        body: const Center(child: Text('No hay instancias disponibles en este grupo.')),
      );
    }

    final group = EffectiveEntityGroup(
      key: '${widget.speciesId}_${widget.effectiveLocationId ?? "root"}',
      speciesId: widget.speciesId,
      effectiveLocationId: widget.effectiveLocationId,
      entities: matchingEntities,
    );

    final isHomogeneous = group.isHomogeneous;

    return Scaffold(
      appBar: AppBar(
        title: Text(speciesName),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined),
            tooltip: _isEditing ? 'Guardar Cambios' : 'Editar Grupo',
            onPressed: () {
              setState(() => _isEditing = !_isEditing);
            },
          ),
          if (_isEditing && isHomogeneous && !(species?.isUnique ?? false))
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              tooltip: 'Añadir Instancia Duplicada',
              onPressed: () => QuantityOperationHelper.addOne(context, ref, group),
            ),
        ],
      ),
      floatingActionButton: (_isEditing && isHomogeneous && !(species?.isUnique ?? false))
          ? FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => QuantityOperationHelper.addOne(context, ref, group),
              icon: const Icon(Icons.add),
              label: const Text('Añadir Duplicado'),
            )
          : null,
      body: Column(
        children: [
          // Banner Informativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
            child: Row(
              children: [
                Icon(
                  isHomogeneous ? Icons.verified_outlined : Icons.tune_outlined,
                  color: isHomogeneous ? Colors.green : Colors.amber.shade800,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Población Total: ${group.population} unidades',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isHomogeneous
                            ? 'Grupo Homogéneo (Propiedades idénticas)'
                            : 'Grupo Heterogéneo (Distintas subespecies/propiedades)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Lista de Instancias Individuales
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: group.entities.length,
              itemBuilder: (ctx, idx) {
                final entity = group.entities[idx];
                return Dismissible(
                  key: Key(entity.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                    ref.read(entityListProvider.notifier).loadEntities();
                  },
                  child: InstancePreviewCard(
                    entity: entity,
                    onTap: () => context.push('/entity/${entity.id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
