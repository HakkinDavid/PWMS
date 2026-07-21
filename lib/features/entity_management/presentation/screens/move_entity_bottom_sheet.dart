import 'package:flutter/material.dart';
import '../../../../core/domain/entities/entity.dart';
import '../../../../core/domain/entities/entity_id.dart';
import '../controllers/world_explorer_controller.dart';

/// Modal interactivo de la Acción "Mover a..." para reubicar una entidad en 2 toques.
class MoveEntityBottomSheet extends StatefulWidget {
  final Entity entityToMove;
  final WorldExplorerController controller;
  final VoidCallback onMoved;

  const MoveEntityBottomSheet({
    super.key,
    required this.entityToMove,
    required this.controller,
    required this.onMoved,
  });

  @override
  State<MoveEntityBottomSheet> createState() => _MoveEntityBottomSheetState();
}

class _MoveEntityBottomSheetState extends State<MoveEntityBottomSheet> {
  EntityId? _selectedTargetParentId;
  List<Entity> _availableContainers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedTargetParentId = widget.entityToMove.parentId;
    _loadContainers();
  }

  Future<void> _loadContainers() async {
    setState(() => _isLoading = true);
    // Cargamos todas las entidades del mundo para ofrecerlas como potenciales contenedores
    final allWithLoc = widget.controller.recentEntities;
    // Excluimos la propia entidad a mover
    _availableContainers = allWithLoc
        .map((e) => e.entity)
        .where((e) => e.id != widget.entityToMove.id)
        .toList();

    setState(() => _isLoading = false);
  }

  Future<void> _confirmMove() async {
    final success = await widget.controller.moveEntity(
      widget.entityToMove.id,
      _selectedTargetParentId,
    );

    if (mounted && success) {
      widget.onMoved();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.drive_file_move_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mover "${widget.entityToMove.name}"',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Selecciona el nuevo contenedor o ubicación',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Opción para la Raíz del Mundo
          Card(
            color: _selectedTargetParentId == null
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: _selectedTargetParentId == null
                  ? BorderSide(color: theme.colorScheme.primary, width: 2)
                  : BorderSide.none,
            ),
            child: ListTile(
              leading: const Icon(Icons.public_rounded),
              title: const Text('[Raíz del Mundo]', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Sin contenedor padre'),
              trailing: _selectedTargetParentId == null
                  ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
                  : null,
              onTap: () => setState(() => _selectedTargetParentId = null),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'O selecciona un contenedor existente:',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _availableContainers.length,
                    itemBuilder: (context, index) {
                      final container = _availableContainers[index];
                      final isSelected = _selectedTargetParentId == container.id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: isSelected
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: isSelected
                              ? BorderSide(color: theme.colorScheme.primary, width: 2)
                              : BorderSide.none,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.folder_open_rounded),
                          title: Text(container.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          trailing: isSelected
                              ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
                              : null,
                          onTap: () => setState(() => _selectedTargetParentId = container.id),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: widget.controller.isLoading ? null : _confirmMove,
            icon: const Icon(Icons.check_rounded),
            label: const Text('Confirmar Movimiento'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
