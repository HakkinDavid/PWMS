import 'package:flutter/material.dart';
import '../../entities/domain/effective_entity_group.dart';
import '../../entities/domain/world_entity.dart';

/// Universal interaction wrapper for inventory items in both Detailed List and Minecraft Grid modes.
/// Standardizes drag-and-drop source, container drop targets, multi-selection gestures, and visual feedback.
class InventoryItemInteractionWrapper extends StatelessWidget {
  final Widget child;
  final EffectiveEntityGroup group;
  final bool isSelected;
  final bool isSelectionMode;
  final Set<String> selectedEntityIds;
  final bool isContainer;
  final VoidCallback onTap;
  final Function(Object payload, String targetContainerEntityId) onDropIntoContainer;

  const InventoryItemInteractionWrapper({
    super.key,
    required this.child,
    required this.group,
    required this.isSelected,
    required this.isSelectionMode,
    required this.selectedEntityIds,
    required this.isContainer,
    required this.onTap,
    required this.onDropIntoContainer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryId = group.primaryEntity.id;

    Widget content = child;

    // 1. If this item is a container (target of GUARDADO_EN), wrap it with DragTarget
    if (isContainer) {
      content = DragTarget<Object>(
        onWillAcceptWithDetails: (details) {
          final data = details.data;
          if (data == group || data == primaryId) return false;
          if (data is EffectiveEntityGroup && data.primaryEntity.id == primaryId) return false;
          if (data is WorldEntity && data.id == primaryId) return false;
          if (data is List<String> && data.contains(primaryId)) return false;
          return true;
        },
        onAcceptWithDetails: (details) {
          onDropIntoContainer(details.data, primaryId);
        },
        builder: (context, candidateData, rejectedData) {
          final isHovered = candidateData.isNotEmpty;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isHovered ? theme.colorScheme.primaryContainer.withAlpha(140) : Colors.transparent,
              border: isHovered ? Border.all(color: theme.colorScheme.primary, width: 2.0) : null,
            ),
            child: child,
          );
        },
      );
    }

    // 2. Wrap with LongPressDraggable for dragging items or batches
    if (!isSelectionMode) {
      // Normal Mode: Drag the group
      return LongPressDraggable<Object>(
        data: group,
        feedback: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.primaryContainer,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2, size: 20, color: theme.colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Arrastrando ${group.population} unidad(es)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.35, child: content),
        child: content,
      );
    }

    // Selection Mode: Drag selected items batch if this item is selected
    if (isSelected && selectedEntityIds.isNotEmpty) {
      return LongPressDraggable<Object>(
        data: selectedEntityIds.toList(),
        feedback: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.primaryContainer,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.checklist, size: 20, color: theme.colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Arrastrando ${selectedEntityIds.length} elementos seleccionados',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.35, child: content),
        child: content,
      );
    }

    return content;
  }
}
