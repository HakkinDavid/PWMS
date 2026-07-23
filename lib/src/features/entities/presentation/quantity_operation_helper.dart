import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/effective_entity_group.dart';
import '../domain/world_entity.dart';

class QuantityOperationHelper {
  QuantityOperationHelper._();

  /// Collects instance IDs to remove, starting with the majority demographic
  /// and cascading through subsequent demographic groups in descending order of size.
  static List<String> getCascadingRemovalIds(EffectiveEntityGroup group, int requestedCount) {
    if (group.entities.isEmpty || requestedCount <= 0) return [];

    final Map<String, List<WorldEntity>> demographicMap = {};
    for (final e in group.entities) {
      final magSig = e.magnitudes.map((m) => '${m.propertyName}:${m.magnitudeValue}${m.unitSymbol}').join('|');
      final signature = '${e.notes ?? ""}_$magSig';
      demographicMap.putIfAbsent(signature, () => []).add(e);
    }

    // Sort demographic groups by population size descending (majority demographics first)
    final sortedGroups = demographicMap.values.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    final List<String> idsToRemove = [];
    int remaining = requestedCount.clamp(1, group.population);

    for (final groupList in sortedGroups) {
      if (remaining <= 0) break;
      final takeCount = remaining.clamp(0, groupList.length);
      idsToRemove.addAll(groupList.take(takeCount).map((e) => e.id));
      remaining -= takeCount;
    }

    return idsToRemove;
  }

  /// Short tap: Add 1 instance using majority demographic
  static Future<void> addOne(WidgetRef ref, EffectiveEntityGroup group) async {
    final archetype = group.majorityEntity;
    await ref.read(entityRepositoryProvider).instantiateOrMerge(
      archetype.speciesId,
      group.effectiveLocationId,
      1.0,
      notes: archetype.notes,
    );
    ref.read(entityListProvider.notifier).loadEntities();
  }

  /// Short tap: Remove 1 instance from majority demographic
  static Future<void> removeOne(WidgetRef ref, EffectiveEntityGroup group) async {
    final idsToRemove = getCascadingRemovalIds(group, 1);
    if (idsToRemove.isNotEmpty) {
      await ref.read(entityRepositoryProvider).deleteEntitiesBatch(idsToRemove);
      ref.read(entityListProvider.notifier).loadEntities();
    }
  }

  /// Long press: Open WheelPicker modal to add or subtract [count] instances
  static Future<void> showWheelPickerModal(
    BuildContext context,
    WidgetRef ref, {
    required EffectiveEntityGroup group,
    required bool isAdd,
  }) async {
    if (!isAdd && group.population <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.noInstancesAvailableToDelete)),
      );
      return;
    }

    // Rule 2: In deletion mode, max wheel picker count is group.population
    final int maxWheelCount = isAdd ? 100 : group.population;
    int selectedQty = 1;

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(100),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isAdd ? AppStrings.addByWheelTitle : AppStrings.removeByWheelTitle,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAdd
                        ? 'Clonará la demografía mayoritaria ($selectedQty de $maxWheelCount)'
                        : 'Eliminará demografías mayoritarias en cascada ($selectedQty de máximo $maxWheelCount)',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.secondary),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 120,
                    child: CupertinoPicker(
                      itemExtent: 36,
                      scrollController: FixedExtentScrollController(initialItem: 0),
                      onSelectedItemChanged: (index) {
                        setState(() => selectedQty = index + 1);
                      },
                      children: List.generate(maxWheelCount, (idx) {
                        final val = idx + 1;
                        return Center(
                          child: Text(
                            '$val ${val == 1 ? AppStrings.unitLabel : AppStrings.unitsLabel}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: selectedQty == val ? FontWeight.bold : FontWeight.normal,
                              color: selectedQty == val ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx, true),
                      icon: Icon(isAdd ? Icons.add_circle : Icons.remove_circle, color: Colors.white),
                      label: Text(
                        isAdd ? 'Confirmar adición de $selectedQty' : 'Confirmar eliminación de $selectedQty',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAdd ? Colors.green : Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (confirm == true) {
      if (isAdd) {
        final archetype = group.majorityEntity;
        for (int i = 0; i < selectedQty; i++) {
          await ref.read(entityRepositoryProvider).instantiateOrMerge(
            archetype.speciesId,
            group.effectiveLocationId,
            1.0,
            notes: archetype.notes,
          );
        }
      } else {
        // Rule 1: Cascading deletion through majority demographic groups in order
        final idsToRemove = getCascadingRemovalIds(group, selectedQty);
        await ref.read(entityRepositoryProvider).deleteEntitiesBatch(idsToRemove);
      }
      ref.read(entityListProvider.notifier).loadEntities();
    }
  }

  /// Broad number tap: Direct numeric input to set arbitrary population target
  static Future<void> showDirectNumericInputDialog(
    BuildContext context,
    WidgetRef ref, {
    required EffectiveEntityGroup group,
  }) async {
    final controller = TextEditingController(text: '${group.population}');

    final targetVal = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final currentInput = int.tryParse(controller.text.trim()) ?? group.population;
            final delta = currentInput - group.population;

            String deltaText = AppStrings.noChangesLabel;
            Color deltaColor = Colors.grey;
            if (delta > 0) {
              deltaText = 'Se añadirán $delta instancias';
              deltaColor = Colors.green;
            } else if (delta < 0) {
              final actualRemove = delta.abs().clamp(1, group.population);
              deltaText = 'Se eliminarán $actualRemove instancias en cascada';
              deltaColor = Colors.redAccent;
            }

            return AlertDialog(
              title: const Text(AppStrings.directPopulationAdjustmentTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${AppStrings.currentPopulationLabel}: ${group.population}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: AppStrings.newTargetPopulationLabel,
                      hintText: AppStrings.targetPopulationHint,
                      prefixIcon: Icon(Icons.pin),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    deltaText,
                    style: TextStyle(fontWeight: FontWeight.bold, color: deltaColor, fontSize: 13),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text(AppStrings.cancel)),
                ElevatedButton(
                  onPressed: () {
                    final parsed = int.tryParse(controller.text.trim());
                    Navigator.pop(ctx, parsed);
                  },
                  child: const Text(AppStrings.applyCalculationAction),
                ),
              ],
            );
          },
        );
      },
    );

    if (targetVal != null && targetVal >= 0 && targetVal != group.population) {
      final delta = targetVal - group.population;

      if (delta > 0) {
        final archetype = group.majorityEntity;
        for (int i = 0; i < delta; i++) {
          await ref.read(entityRepositoryProvider).instantiateOrMerge(
            archetype.speciesId,
            group.effectiveLocationId,
            1.0,
            notes: archetype.notes,
          );
        }
      } else if (delta < 0) {
        final idsToRemove = getCascadingRemovalIds(group, delta.abs());
        await ref.read(entityRepositoryProvider).deleteEntitiesBatch(idsToRemove);
      }

      ref.read(entityListProvider.notifier).loadEntities();
    }
  }
}
