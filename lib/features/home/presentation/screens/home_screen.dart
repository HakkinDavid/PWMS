import 'package:flutter/material.dart';
import '../../../../core/domain/entities/entity_id.dart';
import '../../../../core/presentation/helpers/entity_kind_helper.dart';
import '../../../entity_management/presentation/controllers/world_explorer_controller.dart';
import '../../../entity_management/presentation/screens/entity_detail_screen.dart';
import '../../../entity_management/presentation/screens/unified_register_modal.dart';

/// Pantalla Principal de Tarea 1: 🔍 Buscar y Consultar en "Mi Mundo".
class HomeScreen extends StatefulWidget {
  final WorldExplorerController controller;
  final Function(EntityId?)? onNavigateToExplorer;

  const HomeScreen({
    super.key,
    required this.controller,
    this.onNavigateToExplorer,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.controller.initHome();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openRegisterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => UnifiedRegisterModal(
        controller: widget.controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final isSearching = controller.searchQuery.trim().isNotEmpty;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Header Prominente con Búsqueda Destacada
              SliverAppBar(
                expandedHeight: 170.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 68),
                  title: const Text(
                    'Mi Mundo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.surface,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: controller.onSearchQueryChanged,
                      decoration: InputDecoration(
                        hintText: 'Buscar objeto, documento, herramienta o lugar...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: isSearching
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  controller.onSearchQueryChanged('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),

              // Búsqueda Activa: Resultados Instantáneos
              if (isSearching) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      'Resultados de búsqueda (${controller.searchResults.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (controller.searchResults.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 48, color: theme.colorScheme.outline),
                          const SizedBox(height: 12),
                          Text(
                            'No se encontró ningún elemento coincidente con "${controller.searchQuery}"',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = controller.searchResults[index];
                        final kindColor = EntityKindHelper.getColor(item.entity.kind, theme);
                        final containerColor =
                            EntityKindHelper.getContainerColor(item.entity.kind, theme);
                        final kindIcon = EntityKindHelper.getIcon(item.entity.kind);
                        final kindLabel = EntityKindHelper.getLabel(item.entity.kind);

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 1.5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: containerColor,
                                      child: Icon(kindIcon, color: kindColor, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.entity.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: containerColor,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  kindLabel,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: kindColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on_rounded,
                                                  size: 14, color: theme.colorScheme.primary),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  '📍 ${item.locationDisplayPath}',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.colorScheme.primary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16),
                                // Acciones Directas: Abrir e Ir al Lugar
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        if (widget.onNavigateToExplorer != null) {
                                          widget.onNavigateToExplorer!(item.entity.parentId);
                                        }
                                      },
                                      icon: const Icon(Icons.near_me_rounded, size: 16),
                                      label: const Text('Ir al Lugar'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => EntityDetailScreen(
                                              entity: item.entity,
                                              controller: controller,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                                      label: const Text('Abrir'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.colorScheme.primaryContainer,
                                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                                        elevation: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: controller.searchResults.length,
                    ),
                  ),
              ] else ...[
                // Pantalla Normal "Mi Mundo": Recientes y Resumen
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actividad Reciente',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (controller.recentEntities.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text(
                        'Aún no hay elementos registrados en tu mundo.',
                        style: TextStyle(color: theme.colorScheme.outline),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = controller.recentEntities[index];
                        final kindColor = EntityKindHelper.getColor(item.entity.kind, theme);
                        final containerColor =
                            EntityKindHelper.getContainerColor(item.entity.kind, theme);
                        final kindIcon = EntityKindHelper.getIcon(item.entity.kind);
                        final kindLabel = EntityKindHelper.getLabel(item.entity.kind);

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: containerColor,
                              child: Icon(kindIcon, color: kindColor, size: 20),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.entity.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    kindLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: kindColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '📍 ${item.locationDisplayPath}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EntityDetailScreen(
                                    entity: item.entity,
                                    controller: controller,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: controller.recentEntities.length,
                    ),
                  ),
              ],
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: _openRegisterModal,
            tooltip: 'Captura Rápida',
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }
}
