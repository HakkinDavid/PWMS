import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/domain/subspecies.dart';
import '../../entities/domain/entity_display_helper.dart';
import '../../entities/domain/world_entity.dart';
import '../domain/entity_relation.dart';

class InteractiveEntityGraphWidget extends ConsumerWidget {
  final WorldEntity currentEntity;
  final bool isEditing;
  final List<EntityRelation>? overrideRelations;
  final void Function(EntityRelation rel)? onDeleteRelation;

  const InteractiveEntityGraphWidget({
    super.key,
    required this.currentEntity,
    this.isEditing = false,
    this.overrideRelations,
    this.onDeleteRelation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catalogState = ref.watch(catalogListProvider);
    final entitiesState = ref.watch(entityListProvider);
    final subspeciesState = ref.watch(subspeciesListProvider);

    final catalogItems = catalogState.asData?.value ?? [];
    final allEntities = entitiesState.asData?.value ?? [];
    final subspeciesList = subspeciesState.asData?.value ?? [];

    final centralTitle = EntityDisplayHelper.getDisplayName(
      entity: currentEntity,
      catalogItems: catalogItems,
      subspeciesList: subspeciesList,
    );

    if (overrideRelations != null) {
      return _buildContent(
        context: context,
        ref: ref,
        theme: theme,
        relations: overrideRelations!,
        catalogItems: catalogItems,
        allEntities: allEntities,
        subspeciesList: subspeciesList,
        centralTitle: centralTitle,
      );
    }

    final relationsAsync = ref.watch(entityRelationsProvider(currentEntity.id));

    return relationsAsync.when(
      data: (relations) => _buildContent(
        context: context,
        ref: ref,
        theme: theme,
        relations: relations,
        catalogItems: catalogItems,
        allEntities: allEntities,
        subspeciesList: subspeciesList,
        centralTitle: centralTitle,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text('${AppStrings.relationsLoadErrorPrefix}$err'),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeData theme,
    required List<EntityRelation> relations,
    required List<CatalogItem> catalogItems,
    required List<WorldEntity> allEntities,
    required List<Subspecies> subspeciesList,
    required String centralTitle,
  }) {
    final visibleRelations = relations.where((r) =>
      !(r.sourceEntityId == currentEntity.id && r.relationType == 'GUARDADO_EN')
    ).toList();

        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.hub_outlined, color: theme.colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              AppStrings.interactiveRelationsGraphTitle,
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text('${visibleRelations.length}${AppStrings.linksCountSuffix}', style: const TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (visibleRelations.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.alt_route, color: Colors.grey, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.noDirectedRelationsRegistered,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  // Vertical Column Layout for Relations
                  Column(
                    children: [
                      // Central Entity Node Header Card
                      _buildCentralNodeTile(
                        theme: theme,
                        title: centralTitle,
                      ),
                      const SizedBox(height: 10),

                      // List of Directed Edge Connections in Column Layout
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleRelations.length,
                        separatorBuilder: (ctx, idx) => const SizedBox(height: 8),
                        itemBuilder: (ctx, idx) {
                          final rel = visibleRelations[idx];
                          final isOutgoing = rel.sourceEntityId == currentEntity.id;
                          final otherEntityId = isOutgoing ? rel.targetEntityId : rel.sourceEntityId;
                          final otherEntity = allEntities.where((e) => e.id == otherEntityId).firstOrNull;
                          final otherName = otherEntity != null
                              ? EntityDisplayHelper.getDisplayName(
                                  entity: otherEntity,
                                  catalogItems: catalogItems,
                                  subspeciesList: subspeciesList,
                                )
                              : AppStrings.instantiatedObject;

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Row(
                              children: [
                                // Directional Relation Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withAlpha(25),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: theme.colorScheme.primary.withAlpha(90)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isOutgoing ? Icons.arrow_forward : Icons.arrow_back,
                                        size: 14,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        rel.relationType,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Connected Entity Node Info & Navigation
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      context.pushEntityDetail(otherEntityId);
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.open_in_new, size: 16, color: theme.colorScheme.primary),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                otherName,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                isOutgoing ? AppStrings.targetEntityLabel : AppStrings.sourceEntityLabel,
                                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Deletion Action ONLY in Edit Mode!
                                if (isEditing) ...[
                                  const SizedBox(width: 6),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                                    tooltip: AppStrings.deleteRelationTooltip,
                                    onPressed: () async {
                                      final confirm = await AppConfirmationDialog.showDeleteConfirmation(
                                        context: context,
                                        title: AppStrings.confirmDeleteRelationTitle,
                                        message: '${AppStrings.confirmDeleteRelationMessagePrefix}${rel.relationType}${AppStrings.confirmDeleteRelationMessageMiddle}$otherName${AppStrings.confirmDeleteRelationMessageSuffix}',
                                      );
                                      if (!confirm) return;

                                      if (onDeleteRelation != null) {
                                        onDeleteRelation!(rel);
                                      } else {
                                        await ref.read(relationRepositoryProvider).deleteRelation(rel.id);
                                        ref.invalidate(entityRelationsProvider(currentEntity.id));
                                        ref.invalidate(entityRelationsProvider(otherEntityId));
                                        ref.invalidate(relationListProvider);
                                        ref.invalidate(entityListProvider);
                                      }
                                    },
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
  }

  Widget _buildCentralNodeTile({
    required ThemeData theme,
    required String title,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            '${AppStrings.centralInstanceLabel}: ',
            style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 12),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
