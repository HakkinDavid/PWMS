import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/domain/domain_rules.dart';
import '../../../core/providers/providers.dart';
import '../../locations/domain/location_path_helper.dart';
import '../domain/effective_entity_group.dart';
import '../domain/world_entity.dart';

class GroupedInstanceDetailSheet extends ConsumerStatefulWidget {
  final EffectiveEntityGroup group;

  const GroupedInstanceDetailSheet({super.key, required this.group});

  static Future<void> show(BuildContext context, EffectiveEntityGroup group) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GroupedInstanceDetailSheet(group: group),
    );
  }

  @override
  ConsumerState<GroupedInstanceDetailSheet> createState() => _GroupedInstanceDetailSheetState();
}

class _GroupedInstanceDetailSheetState extends ConsumerState<GroupedInstanceDetailSheet> {
  bool _isBusy = false;

  Future<void> _addOneInstance() async {
    setState(() => _isBusy = true);
    try {
      final first = widget.group.primaryEntity;
      await ref.read(entityRepositoryProvider).instantiateOrMerge(
        first.speciesId,
        widget.group.effectiveLocationId,
        1.0,
        notes: first.notes,
      );
      ref.read(entityListProvider.notifier).loadEntities();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir instancia: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _removeOneInstance() async {
    if (widget.group.entities.isEmpty) return;
    setState(() => _isBusy = true);
    try {
      final last = widget.group.entities.last;
      await ref.read(entityRepositoryProvider).deleteEntity(last.id);
      ref.read(entityListProvider.notifier).loadEntities();
      if (widget.group.entities.length <= 1 && mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar instancia: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _addBatchInstances() async {
    final qtyController = TextEditingController(text: '5');
    final count = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Adición Masiva (Conteo Rápido)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingresa la cantidad de instancias a instanciar en este grupo:'),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(qtyController.text.trim());
              Navigator.pop(ctx, val);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (count != null && count > 0) {
      setState(() => _isBusy = true);
      try {
        final first = widget.group.primaryEntity;
        for (int i = 0; i < count; i++) {
          await ref.read(entityRepositoryProvider).instantiateOrMerge(
            first.speciesId,
            widget.group.effectiveLocationId,
            1.0,
            notes: first.notes,
          );
        }
        ref.read(entityListProvider.notifier).loadEntities();
      } finally {
        if (mounted) setState(() => _isBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogListProvider);
    final locationsState = ref.watch(locationNodeListProvider);
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final locationNodes = locationsState.asData?.value ?? [];

    final species = catalogItems.where((c) => c.id == widget.group.speciesId).firstOrNull;
    final name = species?.name ?? AppStrings.typeObject;
    final type = species?.type ?? AppStrings.typeObject;

    final breadcrumb = LocationPathHelper.buildBreadcrumbPath(widget.group.effectiveLocationId, locationNodes);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header: Group Identity & Total Count
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: FutureBuilder<String>(
                    future: species?.mainPhotoPath != null
                        ? ref.read(fileStorageServiceProvider).getAbsolutePath(species!.mainPhotoPath!)
                        : Future.value(''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                        return Image.file(File(snapshot.data!), fit: BoxFit.cover);
                      }
                      return Container(
                        color: theme.colorScheme.primary.withAlpha(25),
                        child: Icon(Icons.category, color: theme.colorScheme.primary, size: 28),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$type • ${breadcrumb.fullPath}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Population Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '${widget.group.population}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      'Población',
                      style: TextStyle(fontSize: 10, color: theme.colorScheme.onPrimaryContainer.withAlpha(180)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Action Bar for Instant Add / Delete (Huevos & Pilas)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Quick Decrement (-)
                ElevatedButton.icon(
                  onPressed: (_isBusy || widget.group.population == 0) ? null : _removeOneInstance,
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 18),
                  label: const Text('-1', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                // Quick Increment (+)
                ElevatedButton.icon(
                  onPressed: _isBusy ? null : _addOneInstance,
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 18),
                  label: const Text('+1 Rápido', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                // Batch Add (+N)
                OutlinedButton.icon(
                  onPressed: _isBusy ? null : _addBatchInstances,
                  icon: const Icon(Icons.post_add, size: 18),
                  label: const Text('+N Masivo', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Detalle de Instancias Individuales (${widget.group.population})',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Expandable list of individual entities in the group
          Expanded(
            child: ListView.builder(
              itemCount: widget.group.entities.length,
              itemBuilder: (context, index) {
                final entity = widget.group.entities[index];
                final firstMag = entity.magnitudes.isNotEmpty ? entity.magnitudes.first : null;
                final shortId = entity.id.length > 8 ? entity.id.substring(0, 8) : entity.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: theme.colorScheme.primary.withAlpha(20),
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                    ),
                    title: Text(
                      'Instancia ID: $shortId',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: Text(
                      entity.notes != null && entity.notes!.isNotEmpty
                          ? entity.notes!
                          : (firstMag != null ? 'Magnitud: ${DomainRules.formatMagnitude(firstMag.magnitudeValue, firstMag.unitSymbol)} ${firstMag.unitSymbol}' : 'Sin notas'),
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.secondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (entity.notes != null) Text('Notas: ${entity.notes}', style: const TextStyle(fontSize: 12)),
                            if (entity.magnitudes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Magnitudes: ${entity.magnitudes.map((m) => '${m.propertyName}: ${DomainRules.formatMagnitude(m.magnitudeValue, m.unitSymbol)} ${m.unitSymbol}').join(', ')}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.open_in_new, size: 16),
                                  label: const Text('Ver Ficha Completa', style: TextStyle(fontSize: 12)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.push('/entity/${entity.id}');
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () async {
                                    await ref.read(entityRepositoryProvider).deleteEntity(entity.id);
                                    ref.read(entityListProvider.notifier).loadEntities();
                                    if (mounted && widget.group.entities.length <= 1) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
