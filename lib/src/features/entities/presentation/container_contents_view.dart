import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../domain/world_entity.dart';

class ContainerContentsView extends ConsumerWidget {
  final WorldEntity parentEntity;

  const ContainerContentsView({super.key, required this.parentEntity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allEntitiesAsync = ref.watch(entityListProvider);

    return allEntitiesAsync.when(
      data: (allEntities) {
        // Find entities contained inside parent (either via parentEntityId or placeId)
        final contents = allEntities.where((e) {
          return e.id != parentEntity.id && (e.parentEntityId == parentEntity.id || e.placeId == parentEntity.id);
        }).toList();

        if (contents.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                Icon(
                  parentEntity.isPlace ? Icons.place_outlined : Icons.inventory_2_outlined,
                  size: 40,
                  color: theme.colorScheme.primary.withAlpha(120),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sin elementos guardados aquí',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Este ${parentEntity.isPlace ? 'lugar' : 'contenedor'} está actualmente vacío.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  parentEntity.isPlace ? Icons.location_city : Icons.inventory_2,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Contenido (${contents.length})',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: contents.length,
              itemBuilder: (context, index) {
                final child = contents[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.push('/entity/${child.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: theme.colorScheme.primary.withAlpha(30),
                                child: FutureBuilder<String>(
                                  future: child.mainPhotoPath != null
                                      ? ref.read(fileStorageServiceProvider).getAbsolutePath(child.mainPhotoPath!)
                                      : Future.value(''),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                      return ClipOval(
                                        child: Image.file(
                                          File(snapshot.data!),
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                    return Icon(
                                      child.isContainer ? Icons.inventory_2 : (child.isPlace ? Icons.place : Icons.category),
                                      size: 18,
                                      color: theme.colorScheme.primary,
                                    );
                                  },
                                ),
                              ),
                              const Spacer(),
                              if (child.quantity != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary.withAlpha(40),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${child.quantity} ${child.unit ?? ''}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            child.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            child.type,
                            style: TextStyle(color: theme.colorScheme.secondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text('Error al cargar contenido: $err'),
    );
  }
}
