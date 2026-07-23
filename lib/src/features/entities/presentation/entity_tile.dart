import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/world_entity.dart';
import 'instance_preview_card.dart';

class EntityTile extends ConsumerWidget {
  final WorldEntity entity;

  const EntityTile({
    super.key,
    required this.entity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InstancePreviewCard(
      entity: entity,
      onTap: () => context.push('/entity/${entity.id}'),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }
}
