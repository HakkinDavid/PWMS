import 'dart:async';
import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../entities/domain/effective_entity_group.dart';
import '../../entities/domain/world_entity.dart';

/// Universal interaction wrapper for inventory items in both Detailed List and Minecraft Grid modes.
/// Standardizes drag-and-drop source, container drop targets, multi-selection gestures, and spring-loaded hover opening.
class InventoryItemInteractionWrapper extends StatefulWidget {
  final Widget child;
  final EffectiveEntityGroup group;
  final bool isSelected;
  final bool isSelectionMode;
  final Set<String> selectedEntityIds;
  final bool isContainer;
  final bool isStack;
  final bool isHighlighted;
  final VoidCallback onTap;
  final Function(Object payload, String targetEntityId, bool isContainer) onDropIntoContainer;
  final Function(String targetKey)? onHoverSpringLoaded;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;

  const InventoryItemInteractionWrapper({
    super.key,
    required this.child,
    required this.group,
    required this.isSelected,
    required this.isSelectionMode,
    required this.selectedEntityIds,
    required this.isContainer,
    this.isStack = false,
    this.isHighlighted = false,
    required this.onTap,
    required this.onDropIntoContainer,
    this.onHoverSpringLoaded,
    this.onDragStarted,
    this.onDragEnd,
  });

  @override
  State<InventoryItemInteractionWrapper> createState() => _InventoryItemInteractionWrapperState();
}

class _InventoryItemInteractionWrapperState extends State<InventoryItemInteractionWrapper> {
  Timer? _hoverTimer;

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  void _cancelHoverTimer() {
    _hoverTimer?.cancel();
    _hoverTimer = null;
  }

  void _startHoverTimer(String targetKey) {
    if (_hoverTimer != null) return;
    _hoverTimer = Timer(const Duration(milliseconds: 600), () {
      _hoverTimer = null;
      if (mounted) {
        widget.onHoverSpringLoaded?.call(targetKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryId = widget.group.primaryEntity.id;

    // 1. Wrap all items with DragTarget so any item can receive dropped items
    // (prompting confirmation in parent if not yet a container)
    Widget content = DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        final data = details.data;
        if (data == widget.group || data == primaryId) return false;
        if (data is EffectiveEntityGroup && data.primaryEntity.id == primaryId) return false;
        if (data is WorldEntity && data.id == primaryId) return false;
        if (data is List<String> && data.contains(primaryId)) return false;
        return true;
      },
      onMove: (details) {
        if (widget.onHoverSpringLoaded != null && (widget.isContainer || widget.isStack)) {
          _startHoverTimer(widget.isContainer ? primaryId : widget.group.key);
        }
      },
      onLeave: (data) {
        _cancelHoverTimer();
      },
      onAcceptWithDetails: (details) {
        _cancelHoverTimer();
        widget.onDropIntoContainer(details.data, primaryId, widget.isContainer);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isHovered
                ? theme.colorScheme.primaryContainer.withAlpha(140)
                : (widget.isHighlighted ? theme.colorScheme.primary.withAlpha(35) : Colors.transparent),
            border: isHovered
                ? Border.all(color: theme.colorScheme.primary, width: 2.0)
                : (widget.isHighlighted
                    ? Border.all(color: theme.colorScheme.primary, width: 2.5)
                    : null),
            boxShadow: widget.isHighlighted
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(120),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        );
      },
    );

    // 2. Wrap with LongPressDraggable for dragging items or batches
    if (!widget.isSelectionMode) {
      // Normal Mode: Drag the group/stack or single entity
      final isMulti = widget.group.population > 1;
      final dragData = isMulti ? widget.group.entities.map((e) => e.id).toList() : widget.group.primaryEntity.id;

      return LongPressDraggable<Object>(
        data: dragData,
        onDragStarted: widget.onDragStarted,
        onDragEnd: (_) => widget.onDragEnd?.call(),
        onDragCompleted: () => widget.onDragEnd?.call(),
        onDraggableCanceled: (_, __) => widget.onDragEnd?.call(),
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
                  isMulti
                      ? AppStrings.draggingUnits(widget.group.population)
                      : AppStrings.draggingElement,
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
    if (widget.isSelected && widget.selectedEntityIds.isNotEmpty) {
      return LongPressDraggable<Object>(
        data: widget.selectedEntityIds.toList(),
        onDragStarted: widget.onDragStarted,
        onDragEnd: (_) => widget.onDragEnd?.call(),
        onDragCompleted: () => widget.onDragEnd?.call(),
        onDraggableCanceled: (_, __) => widget.onDragEnd?.call(),
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
                  AppStrings.draggingSelectedElements(widget.selectedEntityIds.length),
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
