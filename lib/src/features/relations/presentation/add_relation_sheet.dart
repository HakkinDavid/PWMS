import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/app_wheel_picker.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/domain/entity_template.dart';
import '../../entities/domain/world_entity.dart';
import '../domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

class AddRelationSheet extends ConsumerStatefulWidget {
  final WorldEntity sourceEntity;

  const AddRelationSheet({super.key, required this.sourceEntity});

  static Future<void> show(BuildContext context, WorldEntity sourceEntity) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddRelationSheet(sourceEntity: sourceEntity),
    );
  }

  @override
  ConsumerState<AddRelationSheet> createState() => _AddRelationSheetState();
}

class _AddRelationSheetState extends ConsumerState<AddRelationSheet> {
  String? _targetEntityId;
  String _relationType = AppTechnicalStrings.relPerteneceA;
  bool _isSaving = false;

  final List<String> _directedRelationTypes = EntityTemplateRegistry.directedRelationTypes;

  Future<void> _saveRelation() async {
    if (_targetEntityId == null) {
      AppToast.showRestriction(context, AppStrings.selectElementToRelate);
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
      ref.invalidate(relationListProvider);
      ref.read(entityListProvider.notifier).loadEntities();

      if (mounted) {
        Navigator.pop(context);
        AppToast.showSuccess(context, AppStrings.directedRelationCreatedSuccess);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, AppStrings.saveRelationError(e));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entitiesState = ref.watch(entityListProvider);
    final catalogState = ref.watch(catalogListProvider);
    final subspeciesState = ref.watch(subspeciesListProvider);
    final theme = Theme.of(context);

    final catalogItems = catalogState.asData?.value ?? [];
    final subspeciesList = subspeciesState.asData?.value ?? [];

    final sourceName = EntityDisplayHelper.getDisplayName(
      entity: widget.sourceEntity,
      catalogItems: catalogItems,
      subspeciesList: subspeciesList,
    );

    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom + 20
        : mediaQuery.padding.bottom + 20;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: bottomPadding,
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
            AppStrings.directedRelationInWorldTitle,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                const TextSpan(text: AppStrings.sourceObjectLabel),
                TextSpan(
                  text: AppStrings.quoted(sourceName),
                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Relation Type Selector
          Text(AppStrings.semanticRelationType, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          AppWheelPickerField<String>(
            value: _relationType,
            items: _directedRelationTypes,
            labelBuilder: (t) => t,
            title: AppStrings.semanticRelationType,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.compare_arrows)),
            onChanged: (val) {
              if (val != null) setState(() => _relationType = val);
            },
          ),
          const SizedBox(height: 16),

          // Target Entity Selector
          Text(AppStrings.targetOfRelation, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          entitiesState.when(
            data: (entities) {
              List<WorldEntity> candidates = entities.where((e) => e.id != widget.sourceEntity.id).toList();
              if (candidates.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(AppStrings.noOtherRelationCandidates),
                );
              }

              return AppWheelPickerField<String>(
                value: _targetEntityId,
                items: candidates.map((e) => e.id).toList(),
                labelBuilder: (id) {
                  final e = candidates.where((e) => e.id == id).firstOrNull;
                  if (e == null) return id;
                  return EntityDisplayHelper.getDisplayName(
                    entity: e,
                    catalogItems: catalogItems,
                    subspeciesList: subspeciesList,
                  );
                },
                title: AppStrings.targetOfRelation,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                  hintText: AppStrings.selectTargetElement,
                ),
                onChanged: (val) => setState(() => _targetEntityId = val),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => Text(AppStrings.formatError(err)),
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
                  : const Text(AppStrings.establishDirectedRelation, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
