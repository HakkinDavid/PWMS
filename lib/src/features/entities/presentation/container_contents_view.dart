import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../locations/domain/location_node.dart';
import 'create_entity_sheet.dart';

class ContainerContentsView extends ConsumerWidget {
  final LocationNode locationNode;

  const ContainerContentsView({
    super.key,
    required this.locationNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Objetos Almacenados Aquí',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () {
                CreateEntitySheet.show(
                  context,
                  initialLocationId: locationNode.id,
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Crear objeto aquí'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        entitiesState.when(
          data: (entities) {
            final childEntities = entities.where((e) => e.locationId == locationNode.id).toList();

            if (childEntities.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'Ubicación o contenedor actualmente vacío.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),
              );
            }

            final catalogItems = catalogState.asData?.value ?? [];

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: childEntities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final child = childEntities[index];
                final species = catalogItems.where((c) => c.id == child.speciesId).firstOrNull;
                final name = species?.name ?? 'Objeto';
                final type = species?.type ?? 'Objeto / Herramienta';

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$type • Cantidad: ${child.quantity ?? 1} ${child.unit ?? ""}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.push('/entity/${child.id}');
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('Error al cargar contenido: $err'),
        ),
      ],
    );
  }
}
