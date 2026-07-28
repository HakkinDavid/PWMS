import 'dart:io';
import 'package:flutter/material.dart';
import '../domain/effective_entity_group.dart';
import '../domain/world_entity.dart';

class MinecraftTileWidget extends StatelessWidget {
  final EffectiveEntityGroup? group;
  final WorldEntity? entity;
  final String title;
  final String? photoPath;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Function(Object payload, String targetLocationId)? onDropTarget;
  final String? targetLocationId;
  final bool isExpired;

  const MinecraftTileWidget({
    super.key,
    this.group,
    this.entity,
    required this.title,
    this.photoPath,
    this.icon = Icons.inventory_2_outlined,
    this.isSelected = false,
    required this.onTap,
    this.onLongPress,
    this.onDropTarget,
    this.targetLocationId,
    this.isExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final population = group?.population ?? 1;
    final payload = group ?? entity;

    Widget tileContent = Container(
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(50)
            : theme.colorScheme.surfaceContainerHighest.withAlpha(120),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : (isExpired ? Colors.redAccent.withAlpha(180) : theme.dividerColor.withAlpha(40)),
          width: isSelected ? 2.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Center Icon / Image
          Center(
            child: photoPath != null && photoPath!.isNotEmpty && File(photoPath!).existsSync()
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(photoPath!),
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        icon,
                        size: 40,
                        color: isExpired ? Colors.redAccent : theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    size: 40,
                    color: isExpired ? Colors.redAccent : theme.colorScheme.primary,
                  ),
          ),

          // Top Left Status Badge (if expired)
          if (isExpired)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),

          // Bottom Right Population Badge Overlay
          if (population > 1)
            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.primary.withAlpha(100)),
                ),
                child: Text(
                  '$population',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    // Wrap with DragTarget if container / target location provided
    if (targetLocationId != null && onDropTarget != null) {
      tileContent = DragTarget<Object>(
        onWillAcceptWithDetails: (details) => details.data != payload,
        onAcceptWithDetails: (details) => onDropTarget!(details.data, targetLocationId!),
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;
          return AnimatedScale(
            scale: isHovering ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: tileContent,
          );
        },
      );
    }

    // Wrap with Draggable for universal drag-and-drop
    if (payload != null) {
      return LongPressDraggable<Object>(
        data: payload,
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 72,
            height: 72,
            child: tileContent,
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: tileContent),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          onLongPress: onLongPress,
          child: tileContent,
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      onLongPress: onLongPress,
      child: tileContent,
    );
  }
}
