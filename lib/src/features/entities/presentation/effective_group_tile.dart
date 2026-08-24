import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../domain/effective_entity_group.dart';
import 'instance_preview_card.dart';
import 'quantity_adjustment_sheet.dart';

class EffectiveGroupTile extends ConsumerWidget {
  final EffectiveEntityGroup group;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isSelectionMode;
  final bool isContainer;

  const EffectiveGroupTile({
    super.key,
    required this.group,
    this.onTap,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.isContainer = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
    final species = catalogItems.where((c) => c.id == group.speciesId).firstOrNull;
    final isUnique = species?.isUnique ?? false;
    final isHomogeneous = group.isHomogeneous;
    final showCountBadge = group.population > 1 && !isUnique;

    Widget? countBadge;
    if (showCountBadge) {
      countBadge = GestureDetector(
        onTap: () {
          if (isHomogeneous && !isUnique) {
            QuantityAdjustmentSheet.show(context, group);
          } else {
            context.pushGroupedInstanceDetail(group.speciesId, effectiveLocationId: group.effectiveLocationId);
          }
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: (isHomogeneous && !isUnique)
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(
              color: (isHomogeneous && !isUnique)
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '${group.population}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: (isHomogeneous && !isUnique)
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    Widget? trailingWidget;
    if (countBadge != null && isContainer) {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          countBadge,
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: theme.colorScheme.primary, size: 22),
        ],
      );
    } else if (countBadge != null) {
      trailingWidget = countBadge;
    } else if (isContainer) {
      trailingWidget = Icon(Icons.chevron_right, color: theme.colorScheme.primary, size: 22);
    }

    return InstancePreviewCard(
      group: group,
      isSelected: isSelected,
      isSelectionMode: isSelectionMode,
      onTap: onTap ?? () {
        if (group.population == 1) {
          context.pushEntityDetail(group.primaryEntity.id);
        } else {
          context.pushGroupedInstanceDetail(group.speciesId, effectiveLocationId: group.effectiveLocationId);
        }
      },
      trailing: trailingWidget,
    );
  }
}
