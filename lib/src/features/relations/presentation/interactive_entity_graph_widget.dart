import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../entities/domain/world_entity.dart';

class InteractiveEntityGraphWidget extends ConsumerWidget {
  final WorldEntity currentEntity;

  const InteractiveEntityGraphWidget({
    super.key,
    required this.currentEntity,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Central Entity Node
                        _buildNodeCard(
                          context,
                          theme: theme,
                          title: currentSpecies?.name ?? 'Instancia Actual',
                          subtitle: 'Central',
                          icon: Icons.my_location,
                          isCentral: true,
                          onTap: null,
                        ),

                        // Render Directed Edges & Target/Source Nodes
                        ...relations.map((rel) {
                          final isOutgoing = rel.sourceEntityId == currentEntity.id;
                          final otherEntityId = isOutgoing ? rel.targetEntityId : rel.sourceEntityId;
                          final otherEntity = allEntities.where((e) => e.id == otherEntityId).firstOrNull;
                          final otherSpecies = catalogItems.where((c) => c.id == otherEntity?.speciesId).firstOrNull;
                          final otherName = otherSpecies?.name ?? 'Entidad Externa';

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Directed Arrow Connection
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
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
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 14, color: Colors.grey),
                                      tooltip: 'Eliminar relación',
                                      onPressed: () async {
                                        await ref.read(relationRepositoryProvider).deleteRelation(rel.id);
                                        ref.invalidate(entityRelationsProvider(currentEntity.id));
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Target / Source Connected Node
                              _buildNodeCard(
                                context,
                                theme: theme,
                                title: otherName,
                                subtitle: isOutgoing ? 'Destino' : 'Origen',
                                icon: Icons.open_in_new,
                                isCentral: false,
                                onTap: () {
                                  context.push('/entity/$otherEntityId');
                                },
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
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

  Widget _buildNodeCard(
    BuildContext context, {
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCentral,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isCentral ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCentral ? theme.colorScheme.primary : theme.dividerColor,
            width: isCentral ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: isCentral ? Colors.white : theme.colorScheme.primary, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isCentral ? Colors.white : theme.textTheme.bodyMedium?.color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isCentral ? Colors.white.withAlpha(200) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
