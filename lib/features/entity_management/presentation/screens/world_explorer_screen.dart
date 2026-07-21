import 'package:flutter/material.dart';
import '../../../../core/domain/entities/entity.dart';
import '../../../../core/presentation/helpers/entity_kind_helper.dart';
import '../controllers/world_explorer_controller.dart';
import 'entity_detail_screen.dart';
import 'move_entity_bottom_sheet.dart';
import 'unified_register_modal.dart';

/// Explorador Visual de Espacios y Contenedores del Mundo Personal.
class WorldExplorerScreen extends StatefulWidget {
  final WorldExplorerController controller;

  const WorldExplorerScreen({super.key, required this.controller});

  @override
  State<WorldExplorerScreen> createState() => _WorldExplorerScreenState();
}

class _WorldExplorerScreenState extends State<WorldExplorerScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.containedEntities.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.controller.openContainer(widget.controller.currentContainerId);
        }
      });
    }
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
        initialParentId: widget.controller.currentContainerId,
      ),
    );
  }

  void _openMoveModal(Entity entity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => MoveEntityBottomSheet(
        entityToMove: entity,
        controller: widget.controller,
        onMoved: () => Navigator.of(context).pop(),
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
        final currentContainer = controller.currentContainer;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              currentContainer != null ? currentContainer.name : 'Explorador del Mundo',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => controller.openContainer(controller.currentContainerId),
              ),
            ],
          ),
          body: Column(
            children: [
              // Barra Dinámica de Miga de Pan (Breadcrumbs)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.public_rounded, size: 16),
                        label: const Text('Mundo'),
                        onPressed: () => controller.openContainer(null),
                        backgroundColor: controller.currentContainerId == null
                            ? theme.colorScheme.primaryContainer
                            : null,
                      ),
                      ...controller.currentPath.map((item) {
                        final isCurrent = item.id == controller.currentContainerId;
                        return Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.chevron_right_rounded, size: 18),
                            ),
                            ActionChip(
                              avatar: Icon(
                                EntityKindHelper.getIcon(item.kind),
                                size: 16,
                              ),
                              label: Text(item.name),
                              onPressed: () => controller.openContainer(item.id),
                              backgroundColor:
                                  isCurrent ? theme.colorScheme.primaryContainer : null,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Cuerpo con Lista de Contenidos por Tipo Semántico
              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.containedEntities.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox_outlined,
                                      size: 56, color: theme.colorScheme.outline),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Este contenedor está vacío',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Registra un elemento aquí seleccionando este lugar.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: _openRegisterModal,
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Agregar Aquí'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.containedEntities.length,
                            itemBuilder: (context, index) {
                              final entity = controller.containedEntities[index];
                              final childCount = controller.childCounts[entity.id] ?? 0;
                              final isContainer = childCount > 0;

                              final kindColor = EntityKindHelper.getColor(entity.kind, theme);
                              final containerColor =
                                  EntityKindHelper.getContainerColor(entity.kind, theme);
                              final kindIcon = EntityKindHelper.getIcon(
                                entity.kind,
                                isContainer: isContainer,
                              );
                              final kindLabel = EntityKindHelper.getLabel(entity.kind);

                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 1.5,
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: CircleAvatar(
                                    backgroundColor: containerColor,
                                    child: Icon(kindIcon, color: kindColor, size: 22),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          entity.name,
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
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: kindColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      if (isContainer) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primaryContainer
                                                .withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '$childCount elemento${childCount == 1 ? '' : 's'}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      if (entity.description != null)
                                        Expanded(
                                          child: Text(
                                            entity.description!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.drive_file_move_outlined, size: 20),
                                        tooltip: 'Mover',
                                        onPressed: () => _openMoveModal(entity),
                                      ),
                                      const Icon(Icons.chevron_right_rounded),
                                    ],
                                  ),
                                  onTap: () {
                                    if (isContainer ||
                                        entity.kind == 'space' ||
                                        entity.kind == 'container') {
                                      controller.openContainer(entity.id);
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => EntityDetailScreen(
                                            entity: entity,
                                            controller: controller,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            onPressed: _openRegisterModal,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Agregar Aquí'),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
        );
      },
    );
  }
}
