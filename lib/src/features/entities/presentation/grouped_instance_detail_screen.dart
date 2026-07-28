import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/effective_entity_group.dart';
import 'instance_preview_card.dart';

import 'quantity_adjustment_sheet.dart';

class GroupedInstanceDetailScreen extends ConsumerWidget {
  final String speciesId;
  final String? effectiveLocationId;

  const GroupedInstanceDetailScreen({
    super.key,
    required this.speciesId,
    this.effectiveLocationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allEntities = ref.watch(entityListProvider).asData?.value ?? [];
    final catalog = ref.watch(catalogListProvider).asData?.value ?? [];
    final species = catalog.where((c) => c.id == speciesId).firstOrNull;
    final speciesName = species?.name ?? AppStrings.typeObject;

    // Build matching EffectiveEntityGroup
    final matchingEntities = allEntities.where((e) {
      final locMatch = effectiveLocationId == null ? (e.locationId == null) : (e.locationId == effectiveLocationId);
      return e.speciesId == speciesId && locMatch;
    }).toList();

    if (matchingEntities.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(speciesName)),
        body: const Center(child: Text(AppStrings.noInstancesAvailableInGroup)),
      );
    }

    final group = EffectiveEntityGroup(
      key: '${speciesId}_${effectiveLocationId ?? "root"}',
      speciesId: speciesId,
      effectiveLocationId: effectiveLocationId,
      entities: matchingEntities,
    );

    final isHomogeneous = group.isHomogeneous;
    final isUnique = species?.isUnique ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(speciesName),
        actions: [
          // Insignia circular de población (Regla 7)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                if (isHomogeneous && !isUnique) {
                  QuantityAdjustmentSheet.show(context, group);
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
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Informativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
            child: Row(
              children: [
                Icon(
                  isHomogeneous ? Icons.verified_outlined : Icons.tune_outlined,
                  color: isHomogeneous ? Colors.green : Colors.amber.shade800,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppStrings.totalPopulationPrefix}${group.population} ${AppStrings.unitUnits}',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isHomogeneous
                            ? AppStrings.homogeneousGroupProperties
                            : 'Grupo heterogéneo (distintas subespecies o propiedades)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Lista de Instancias Individuales
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: group.entities.length,
              itemBuilder: (ctx, idx) {
                final entity = group.entities[idx];
                return Dismissible(
                  key: Key(entity.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    // Confirmación obligatoria antes de eliminar (Regla 8)
                    return await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text(AppStrings.deleteInstanceTitle),
                        content: const Text(AppStrings.deleteInstanceConfirmationMessage),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text(AppStrings.cancel)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                            onPressed: () => Navigator.pop(c, true),
                            child: const Text(AppStrings.delete),
                          ),
                        ],
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                    ref.read(entityListProvider.notifier).loadEntities();
                  },
                  child: InstancePreviewCard(
                    entity: entity,
                    onTap: () {
                      context.push('/entity/${entity.id}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
