import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../entities/domain/entity_template.dart';
import '../../entities/domain/world_entity.dart';
import '../domain/entity_relation.dart';

class AddRelationSheet extends ConsumerStatefulWidget {
  final WorldEntity sourceEntity;

  const AddRelationSheet({super.key, required this.sourceEntity});

  static Future<void> show(BuildContext context, WorldEntity sourceEntity) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddRelationSheet(sourceEntity: sourceEntity),
    );
  }

  @override
  ConsumerState<AddRelationSheet> createState() => _AddRelationSheetState();
}

class _AddRelationSheetState extends ConsumerState<AddRelationSheet> {
  String? _targetEntityId;
  String _relationType = 'GUARDADO_EN';
  bool _isSaving = false;

  final List<String> _directedRelationTypes = EntityTemplateRegistry.directedRelationTypes;

  Future<void> _saveRelation() async {
    if (_targetEntityId == null) {
      AppToast.showRestriction(context, 'Selecciona el elemento a relacionar');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final relationId = const Uuid().v4();
      final relation = EntityRelation(
        id: relationId,
        sourceEntityId: widget.sourceEntity.id,
        targetEntityId: _targetEntityId!,
        relationType: _relationType,
        createdAt: DateTime.now(),
      );

      await ref.read(relationRepositoryProvider).addRelation(relation);

      ref.invalidate(entityRelationsProvider(widget.sourceEntity.id));
      ref.invalidate(entityRelationsProvider(_targetEntityId!));
      ref.read(entityListProvider.notifier).loadEntities();

      if (mounted) {
        Navigator.pop(context);
        AppToast.showSuccess(context, 'Relación dirigida creada con éxito');
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, 'Error al guardar relación: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final sourceSpecies = catalogItems.where((c) => c.id == widget.sourceEntity.speciesId).firstOrNull;
    final sourceName = sourceSpecies?.name ?? 'Objeto Origen';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            'Relación Dirigida en tu Mundo',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                const TextSpan(text: 'Origen: '),
                TextSpan(
                  text: '"$sourceName"',
                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Relation Type Selector
          Text('Tipo de vínculo semántico', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _relationType,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.compare_arrows)),
            items: _directedRelationTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _relationType = val);
            },
          ),
          const SizedBox(height: 16),

          // Target Entity Selector
          Text('Destino del vínculo:', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          entitiesState.when(
            data: (entities) {
              List<WorldEntity> candidates = entities.where((e) => e.id != widget.sourceEntity.id).toList();
              if (candidates.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('No hay otros elementos disponibles para relacionar.'),
                );
              }

              return DropdownButtonFormField<String>(
                initialValue: _targetEntityId,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                  hintText: 'Selecciona elemento destino',
                ),
                items: candidates.map((e) {
                  final sp = catalogItems.where((c) => c.id == e.speciesId).firstOrNull;
                  final name = sp?.name ?? 'Objeto Destino';
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _targetEntityId = val),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveRelation,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Establecer Vínculo Dirigido', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
