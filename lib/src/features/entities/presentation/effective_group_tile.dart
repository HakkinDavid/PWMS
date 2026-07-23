import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../domain/effective_entity_group.dart';
import 'grouped_instance_detail_sheet.dart';
import 'instance_preview_card.dart';
import 'quantity_operation_helper.dart';

class EffectiveGroupTile extends ConsumerWidget {
  final EffectiveEntityGroup group;

  const EffectiveGroupTile({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final catalogItems = ref.watch(catalogListProvider).asData?.value ?? [];
    final species = catalogItems.where((c) => c.id == group.speciesId).firstOrNull;
    final isUnique = species?.isUnique ?? false;

    return InstancePreviewCard(
      group: group,
      onTap: () {
        if (group.population == 1) {
          context.push('/entity/${group.primaryEntity.id}');
        } else {
          GroupedInstanceDetailSheet.show(context, group);
        }
      },
      trailing: isUnique
          ? Icon(Icons.chevron_right, color: theme.colorScheme.secondary)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => QuantityOperationHelper.removeOne(ref, group),
                  onLongPress: () => QuantityOperationHelper.showWheelPickerModal(context, ref, group: group, isAdd: false),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.remove, size: 18, color: Colors.redAccent),
                  ),
                ),
                InkWell(
                  onTap: () => QuantityOperationHelper.showDirectNumericInputDialog(context, ref, group: group),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.primary.withAlpha(80)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${group.population}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.edit_note, size: 14, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => QuantityOperationHelper.addOne(ref, group),
                  onLongPress: () => QuantityOperationHelper.showWheelPickerModal(context, ref, group: group, isAdd: true),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 18, color: Colors.green),
                  ),
                ),
              ],
            ),
    );
  }
}
