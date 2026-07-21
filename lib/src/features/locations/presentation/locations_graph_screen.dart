import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/create_entity_sheet.dart';
import '../domain/location_node.dart';

class LocationsGraphScreen extends ConsumerWidget {
  const LocationsGraphScreen({super.key});

  void _showCreateNodeModal(BuildContext context, WidgetRef ref, {String? parentId}) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
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
                'Nuevo Nodo en el Grafo de Ubicación',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Crea un lugar físico o contenedor (ej. Garaje, Armario, Caja Roja, Maletín).',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la ubicación / contenedor',
                  hintText: 'Ej. Taller, Armario Principal, Caja #1...',
                  prefixIcon: Icon(Icons.account_tree_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción u observaciones (Opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;

                    final node = LocationNode(
                      id: const Uuid().v4(),
                      name: name,
                      parentLocationId: parentId,
                      description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
                      createdAt: DateTime.now(),
                    );

                    await ref.read(locationNodeListProvider.notifier).saveNode(node);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Crear Nodo de Ubicación', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesState = ref.watch(locationNodeListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafo de Ubicaciones (Lugares y Contenedores)'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateNodeModal(context, ref),
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Nueva Ubicación'),
      ),
      body: nodesState.when(
        data: (nodes) {
          if (nodes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_tree_outlined, size: 64, color: theme.colorScheme.primary.withAlpha(120)),
                    const SizedBox(height: 16),
                    Text(
                      'No hay ubicaciones registradas en el Grafo',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crea nodos de ubicación (lugares o contenedores) para organizar tus objetos en tu mundo.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: nodes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final node = nodes[index];

              int count = 0;
              entitiesState.whenData((entities) {
                count = entities.where((e) => e.locationId == node.id).length;
              });

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.secondary.withAlpha(30),
                    child: Icon(Icons.location_on, color: theme.colorScheme.secondary),
                  ),
                  title: Text(node.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('$count objetos guardados aquí • ${node.description ?? "Sin descripción"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        tooltip: 'Crear objeto en esta ubicación',
                        onPressed: () {
                          CreateEntitySheet.show(context, initialLocationId: node.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Filter entities at this node
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) {
                        return Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    node.name,
                                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      CreateEntitySheet.show(context, initialLocationId: node.id);
                                    },
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text('Crear Objeto Aquí'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              entitiesState.when(
                                data: (entities) {
                                  final nodeEntities = entities.where((e) => e.locationId == node.id).toList();
                                  if (nodeEntities.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 24.0),
                                      child: Center(child: Text('Ubicación actualmente vacía.')),
                                    );
                                  }
                                  return SizedBox(
                                    height: 300,
                                    child: ListView.builder(
                                      itemCount: nodeEntities.length,
                                      itemBuilder: (context, i) {
                                        final ent = nodeEntities[i];
                                        final catalogItems = catalogState.asData?.value ?? [];
                                        final species = catalogItems.where((c) => c.id == ent.speciesId).firstOrNull;
                                        final name = species?.name ?? 'Objeto';

                                        return ListTile(
                                          leading: const Icon(Icons.inventory_2),
                                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          subtitle: Text('Cantidad: ${ent.quantity ?? 1} ${ent.unit ?? ""}'),
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            context.push('/entity/${ent.id}');
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                                loading: () => const CircularProgressIndicator(),
                                error: (err, _) => Text('Error: $err'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
