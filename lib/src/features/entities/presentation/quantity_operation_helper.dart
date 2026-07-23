import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/effective_entity_group.dart';

class QuantityOperationHelper {
  QuantityOperationHelper._();

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
    final majorityList = group.majorityInstances;
    final targets = majorityList.isNotEmpty ? majorityList : group.entities;
    if (targets.isNotEmpty) {
      await ref.read(entityRepositoryProvider).deleteEntity(targets.last.id);
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
                    isAdd ? 'Añadir por Selección de Rueda (WheelPicker)' : 'Eliminar por Selección de Rueda (WheelPicker)',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Operación sobre demografía mayoritaria',
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
                      children: List.generate(100, (idx) {
                        final val = idx + 1;
                        return Center(
                          child: Text(
                            '$val ${val == 1 ? "unidad" : "unidades"}',
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
        final majorityList = group.majorityInstances;
        final targets = majorityList.isNotEmpty ? majorityList : group.entities;
        final toRemoveCount = selectedQty.clamp(1, targets.length);
        for (int i = 0; i < toRemoveCount; i++) {
          await ref.read(entityRepositoryProvider).deleteEntity(targets[i].id);
        }
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

            String deltaText = 'Sin cambios';
            Color deltaColor = Colors.grey;
            if (delta > 0) {
              deltaText = 'Se añadirán $delta instancias';
              deltaColor = Colors.green;
            } else if (delta < 0) {
              deltaText = 'Se eliminarán ${delta.abs()} instancias';
              deltaColor = Colors.redAccent;
            }

            return AlertDialog(
              title: const Text('Ajuste Directo de Población'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Población actual: ${group.population}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nueva Población Objetivo',
                      hintText: 'Ej. 15',
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
                  child: const Text('Aplicar Cálculo'),
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
        final removeCount = delta.abs();
        final majorityList = group.majorityInstances;
        final targets = majorityList.isNotEmpty ? majorityList : group.entities;
        final actualRemoveCount = removeCount.clamp(1, targets.length);

        for (int i = 0; i < actualRemoveCount; i++) {
          await ref.read(entityRepositoryProvider).deleteEntity(targets[i].id);
        }
      }

      ref.read(entityListProvider.notifier).loadEntities();
    }
  }
}
