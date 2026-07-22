import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/world_entity.dart';

class InteractiveEntityGraphWidget extends ConsumerWidget {
  final WorldEntity currentEntity;
  final bool isEditing;

  const InteractiveEntityGraphWidget({
    super.key,
    required this.currentEntity,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final relationsAsync = ref.watch(entityRelationsProvider(currentEntity.id));
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);

    final catalogItems = catalogState.asData?.value ?? [];
    final allEntities = entitiesState.asData?.value ?? [];
    final currentSpecies = catalogItems.where((c) => c.id == currentEntity.speciesId).firstOrNull;

    return relationsAsync.when(
      data: (relations) {
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.hub_outlined, color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Grafo Interactivo de Relaciones',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text('${relations.length} vínculos', style: const TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (relations.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.alt_route, color: Colors.grey, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          'Sin relaciones dirigidas registradas',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  // Vertical Column Layout for Relations
                  Column(
                    children: [
                      // Central Entity Node Header Card
                      _buildCentralNodeTile(
                        theme: theme,
                        title: currentSpecies?.name ?? 'Instancia Actual',
                      ),
                      const SizedBox(height: 10),

                      // List of Directed Edge Connections in Column Layout
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: relations.length,
                        separatorBuilder: (ctx, idx) => const SizedBox(height: 8),
                        itemBuilder: (ctx, idx) {
                          final rel = relations[idx];
                          final isOutgoing = rel.sourceEntityId == currentEntity.id;
                          final otherEntityId = isOutgoing ? rel.targetEntityId : rel.sourceEntityId;
                          final otherEntity = allEntities.where((e) => e.id == otherEntityId).firstOrNull;
                          final otherSpecies = catalogItems.where((c) => c.id == otherEntity?.speciesId).firstOrNull;
                          final otherName = otherSpecies?.name ?? 'Entidad Externa';

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Row(
                              children: [
                                // Directional Relation Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withAlpha(25),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: theme.colorScheme.primary.withAlpha(90)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isOutgoing ? Icons.arrow_forward : Icons.arrow_back,
                                        size: 14,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        rel.relationType,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Connected Entity Node Info & Navigation
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      context.push('/entity/$otherEntityId');
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.open_in_new, size: 16, color: theme.colorScheme.primary),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                otherName,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                isOutgoing ? 'Entidad Destino' : 'Entidad Origen',
                                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Deletion Action ONLY in Edit Mode!
                                if (isEditing) ...[
                                  const SizedBox(width: 6),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                                    tooltip: 'Eliminar relación',
                                    onPressed: () async {
                                      await ref.read(relationRepositoryProvider).deleteRelation(rel.id);
                                      ref.invalidate(entityRelationsProvider(currentEntity.id));
                                    },
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text('Error al cargar relaciones: $err'),
    );
  }

  Widget _buildCentralNodeTile({
    required ThemeData theme,
    required String title,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            'Instancia Central: ',
            style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 12),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
