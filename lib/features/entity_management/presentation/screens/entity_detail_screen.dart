import 'package:flutter/material.dart';
import '../../../../core/domain/entities/entity.dart';
import '../../../../core/presentation/helpers/entity_kind_helper.dart';
import '../controllers/world_explorer_controller.dart';
import 'move_entity_bottom_sheet.dart';
import 'unified_register_modal.dart';
import 'world_explorer_screen.dart';

/// Vista principal "Entidad" (Evolucionada de Ficha Rápida).
class EntityDetailScreen extends StatefulWidget {
  final Entity entity;
  final WorldExplorerController controller;

  const EntityDetailScreen({
    super.key,
    required this.entity,
    required this.controller,
  });

  @override
  State<EntityDetailScreen> createState() => _EntityDetailScreenState();
}

class _EntityDetailScreenState extends State<EntityDetailScreen> {
  late Entity _currentEntity;
  List<Entity> _containedItems = [];
  List<Entity> _locationPath = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentEntity = widget.entity;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadEntityDetails();
      }
    });
  }

  Future<void> _loadEntityDetails() async {
    setState(() => _isLoading = true);
    final repo = widget.controller;

    await repo.openContainer(_currentEntity.id);
    _containedItems = repo.containedEntities;
    _locationPath = repo.currentPath;

    setState(() => _isLoading = false);
  }

  void _openMoveBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => MoveEntityBottomSheet(
        entityToMove: _currentEntity,
        controller: widget.controller,
        onMoved: () async {
          Navigator.of(context).pop();
          await _loadEntityDetails();
        },
      ),
    );
  }

  void _openAddChildModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => UnifiedRegisterModal(
        controller: widget.controller,
        initialParentId: _currentEntity.id,
      ),
    ).then((_) => _loadEntityDetails());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parentPath = _locationPath.where((e) => e.id != _currentEntity.id).toList();
    final displayLocation = parentPath.isNotEmpty
        ? parentPath.map((e) => e.name).join(' > ')
        : 'Raíz del Mundo';

    final kindColor = EntityKindHelper.getColor(_currentEntity.kind, theme);
    final containerColor = EntityKindHelper.getContainerColor(_currentEntity.kind, theme);
    final kindIcon = EntityKindHelper.getIcon(_currentEntity.kind);
    final kindLabel = EntityKindHelper.getLabel(_currentEntity.kind);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentEntity.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.drive_file_move_outlined),
            tooltip: 'Mover Entidad',
            onPressed: _openMoveBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.explore_outlined),
            tooltip: 'Explorar en Jerarquía',
            onPressed: () {
              widget.controller.openContainer(_currentEntity.id);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WorldExplorerScreen(controller: widget.controller),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Cabecera Principal de la Entidad
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                kindIcon,
                                size: 32,
                                color: kindColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _currentEntity.name,
                                          style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: containerColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          kindLabel,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: kindColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_currentEntity.description != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentEntity.description!,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 28),
                        // Badge Interactivo de Ubicación
                        InkWell(
                          onTap: () {
                            if (_currentEntity.parentId != null) {
                              widget.controller.openContainer(_currentEntity.parentId);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WorldExplorerScreen(controller: widget.controller),
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.location_on_rounded,
                                    size: 18, color: theme.colorScheme.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ubicación Física:',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                      Text(
                                        displayLocation,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_currentEntity.parentId != null)
                                  const Icon(Icons.chevron_right_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sección de Contenido Interior
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Elementos Contenidos (${_containedItems.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _openAddChildModal,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Agregar Aquí'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_containedItems.isEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(Icons.inbox_rounded,
                              size: 40, color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                          const SizedBox(height: 8),
                          Text(
                            'Esta entidad no contiene otros objetos aún.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._containedItems.map((item) {
                    final itemColor = EntityKindHelper.getColor(item.kind, theme);
                    final itemBg = EntityKindHelper.getContainerColor(item.kind, theme);
                    final itemIcon = EntityKindHelper.getIcon(item.kind);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: itemBg,
                          child: Icon(itemIcon, color: itemColor, size: 20),
                        ),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('Tipo: ${EntityKindHelper.getLabel(item.kind)}'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EntityDetailScreen(
                                entity: item,
                                controller: widget.controller,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
