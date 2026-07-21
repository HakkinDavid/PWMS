import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/create_entity_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'creation':
        return Icons.add_circle_outline;
      case 'edition':
        return Icons.edit_note;
      case 'movement':
        return Icons.near_me_outlined;
      case 'attachment':
        return Icons.attach_file;
      case 'relation':
        return Icons.link;
      default:
        return Icons.history;
    }
  }

  Color _getEventColor(String type, BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case 'creation':
        return Colors.greenAccent;
      case 'edition':
        return theme.colorScheme.primary;
      case 'movement':
        return Colors.amberAccent;
      case 'attachment':
        return theme.colorScheme.secondary;
      case 'relation':
        return Colors.purpleAccent;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentEntitiesAsync = ref.watch(recentEntitiesProvider);
    final recentActivityAsync = ref.watch(recentActivityProvider);

    final collections = [
      {'name': 'Herramientas', 'icon': Icons.build, 'query': 'Herramienta'},
      {'name': 'Lugares', 'icon': Icons.place, 'route': '/places'},
      {'name': 'Documentos', 'icon': Icons.description, 'query': 'Documento'},
      {'name': 'Proyectos', 'icon': Icons.work, 'query': 'Proyecto'},
      {'name': 'Ideas', 'icon': Icons.lightbulb, 'query': 'Idea'},
      {'name': 'Recuerdos', 'icon': Icons.star, 'query': 'Recuerdo'},
      {'name': 'Vehículos', 'icon': Icons.directions_car, 'query': 'Vehículo'},
      {'name': 'Animales', 'icon': Icons.pets, 'query': 'Animal'},
    ];

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(entityListProvider.notifier).loadEntities();
            ref.invalidate(recentEntitiesProvider);
            ref.invalidate(recentActivityProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Brand & Subtitle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PWMS',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Tu Mundo Digital',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withAlpha(150)),
                        ),
                      ],
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.place_outlined),
                      onPressed: () => context.push('/places'),
                      tooltip: 'Ver Lugares',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Real-time Search Bar Widget
                GestureDetector(
                  onTap: () => context.push('/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Buscar en tu mundo...',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Instantáneo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // World Collections Section
                Text(
                  'Colecciones de tu Mundo',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: collections.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = collections[index];
                      return InkWell(
                        onTap: () {
                          if (item.containsKey('route')) {
                            context.push(item['route'] as String);
                          } else {
                            ref.read(searchQueryProvider.notifier).state = item['query'] as String;
                            context.push('/search');
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 110,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item['icon'] as IconData, size: 28, color: theme.colorScheme.primary),
                              const SizedBox(height: 8),
                              Text(
                                item['name'] as String,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Recent Entities Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Elementos Recientes',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                        context.push('/search');
                      },
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                recentEntitiesAsync.when(
                  data: (entities) {
                    if (entities.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.stars_outlined, size: 48, color: theme.colorScheme.primary.withAlpha(120)),
                            const SizedBox(height: 12),
                            Text(
                              'Tu mundo está vacío',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Presiona el botón "+" para registrar tu primera herramienta, objeto, o lugar.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    return SizedBox(
                      height: 170,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: entities.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final entity = entities[index];
                          return InkWell(
                            onTap: () => context.push('/entity/${entity.id}'),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: theme.dividerColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: FutureBuilder<String>(
                                        future: entity.mainPhotoPath != null
                                            ? ref.read(fileStorageServiceProvider).getAbsolutePath(entity.mainPhotoPath!)
                                            : Future.value(''),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                            return Image.file(
                                              File(snapshot.data!),
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          }
                                          return Container(
                                            color: theme.colorScheme.primary.withAlpha(30),
                                            child: Center(
                                              child: Icon(Icons.category, color: theme.colorScheme.primary),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    entity.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    entity.type,
                                    style: TextStyle(color: theme.colorScheme.secondary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error al cargar recientes: $e'),
                ),
                const SizedBox(height: 28),

                // Recent Activity Stream Section (Automatic Audit Log)
                Text(
                  'Actividad Reciente en tu Mundo',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                recentActivityAsync.when(
                  data: (events) {
                    if (events.isEmpty) {
                      return Text('Sin eventos registrados aún.', style: theme.textTheme.bodyMedium);
                    }

                    return Column(
                      children: events.map((event) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _getEventColor(event.eventType, context).withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getEventIcon(event.eventType),
                                  color: _getEventColor(event.eventType, context),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.description,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      DateFormat('dd/MM HH:mm').format(event.timestamp),
                                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error al cargar historial: $e'),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateEntitySheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Registrar en tu Mundo'),
      ),
    );
  }
}
