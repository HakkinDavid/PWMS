import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/effective_entity_group.dart';

class QuantityOperationHelper {
  QuantityOperationHelper._();

  /// Short tap: Add 1 duplicate instance (solicitando fecha de caducidad si es perecedero)
  static Future<void> addOne(BuildContext context, WidgetRef ref, EffectiveEntityGroup group) async {
    if (!group.isHomogeneous) {
      AppToast.showRestriction(context, 'No se puede modificar cantidad en grupos heterogéneos.');
      return;
    }

    final species = await ref.read(catalogRepositoryProvider).getCatalogItemById(group.speciesId);
    if (species?.isUnique == true) return;

    DateTime? expirationDate;
    if (species != null && !species.isNonPerishable) {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(days: species.defaultShelfLifeDays ?? 7)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 3650)),
        helpText: 'Fecha de Caducidad para la Nueva Instancia',
      );
      if (pickedDate == null) return; // Cancelado por el usuario
      expirationDate = pickedDate;
    }

    final primary = group.primaryEntity;
    final entityRepo = ref.read(entityRepositoryProvider);

    await entityRepo.instantiateOrMerge(
      primary.speciesId,
      group.effectiveLocationId,
      1.0,
      subspeciesId: primary.subspeciesId,
      notes: primary.notes,
      expirationDate: expirationDate,
    );

    ref.read(entityListProvider.notifier).loadEntities();
  }

  /// Short tap: Remove 1 instance
  static Future<void> removeOne(BuildContext context, WidgetRef ref, EffectiveEntityGroup group) async {
    if (!group.isHomogeneous) {
      AppToast.showRestriction(context, 'No se puede modificar cantidad en grupos heterogéneos.');
      return;
    }

    if (group.entities.isEmpty) return;

    final species = await ref.read(catalogRepositoryProvider).getCatalogItemById(group.speciesId);
    if (species?.isUnique == true) return;

    final lastEntityId = group.entities.last.id;
    await ref.read(entityRepositoryProvider).deleteEntity(lastEntityId);
    ref.read(entityListProvider.notifier).loadEntities();
  }

  /// Direct Numeric Input Dialog
  static Future<void> showDirectNumericInputDialog(
    BuildContext context,
    WidgetRef ref, {
    required EffectiveEntityGroup group,
  }) async {
    if (!group.isHomogeneous) {
      AppToast.showRestriction(context, 'No se pueden realizar ajustes rápidos en grupos heterogéneos.');
      return;
    }

    final controller = TextEditingController(text: '${group.population}');

    final newCount = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ajustar Cantidad'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nueva Cantidad Total',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text.trim());
                Navigator.pop(ctx, parsed);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (newCount == null) return;
    final diff = newCount - group.population;

    if (diff > 0) {
      final species = await ref.read(catalogRepositoryProvider).getCatalogItemById(group.speciesId);
      DateTime? expirationDate;
      if (species != null && !species.isNonPerishable && context.mounted) {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(Duration(days: species.defaultShelfLifeDays ?? 7)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 3650)),
          helpText: 'Fecha de Caducidad para las $diff Nuevas Instancias',
        );
        if (picked == null) return;
        expirationDate = picked;
      }

      final primary = group.primaryEntity;
      await ref.read(entityRepositoryProvider).instantiateOrMerge(
        primary.speciesId,
        group.effectiveLocationId,
        diff.toDouble(),
        subspeciesId: primary.subspeciesId,
        notes: primary.notes,
        expirationDate: expirationDate,
      );
      ref.read(entityListProvider.notifier).loadEntities();
    } else if (diff < 0) {
      final removeCount = diff.abs();
      final idsToRemove = group.entities.take(removeCount).map((e) => e.id).toList();
      await ref.read(entityRepositoryProvider).deleteEntitiesBatch(idsToRemove);
      ref.read(entityListProvider.notifier).loadEntities();
    }
  }
}
