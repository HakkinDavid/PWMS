import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../locations/domain/location_node.dart';
import 'entity_tile.dart';

class ContainerContentsView extends ConsumerWidget {
  final LocationNode location;

  const ContainerContentsView({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitiesState = ref.watch(entityListProvider);
    final theme = Theme.of(context);

    return entitiesState.when(
      data: (allEntities) {
        final children = allEntities.where((e) => e.locationId == location.id).toList();

        if (children.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 48, color: theme.disabledColor),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.locationHasNoObjectsOrSublocations,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: children.length,
          itemBuilder: (context, index) {
            final child = children[index];
            return EntityTile(entity: child);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text(AppStrings.errorWithDetails(err))),
    );
  }
}
