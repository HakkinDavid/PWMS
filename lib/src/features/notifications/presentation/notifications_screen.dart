import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/app_navigation_extension.dart';
import '../../catalog/domain/catalog_item.dart';
import '../../catalog/presentation/species_tile.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../domain/app_notification.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notificationsAndRemindersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(notificationListProvider.notifier).evaluateAndLoad();
            },
            tooltip: AppStrings.refreshAction,
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noPendingNotifications,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.allElementsUpToDate,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(notificationListProvider.notifier).evaluateAndLoad();
            },
            child: ListView.separated(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.paddingOf(context).bottom + 24,
              ),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return _NotificationTile(notification: notif);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Text(AppStrings.loadNotificationsError(err)),
        ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationTile({required this.notification});

  Color _getBadgeColor() {
    switch (notification.type) {
      case AppTechnicalNotifications.notifTypeExpired:
        return Colors.red.shade700;
      case AppTechnicalNotifications.notifTypeExpiringSoon:
        return Colors.orange.shade800;
      case AppTechnicalNotifications.notifTypeUnsatisfiedNeed:
        return Colors.deepPurple.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  IconData _getBadgeIcon() {
    switch (notification.type) {
      case AppTechnicalNotifications.notifTypeExpired:
        return Icons.error_outline;
      case AppTechnicalNotifications.notifTypeExpiringSoon:
        return Icons.warning_amber_rounded;
      case AppTechnicalNotifications.notifTypeUnsatisfiedNeed:
        return Icons.inventory_2_outlined;
      default:
        return Icons.notifications;
    }
  }

  void _showSnoozeOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AppStrings.snoozeReminderTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.snoozeReminderPrompt,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.timer_outlined, color: Colors.blue),
                  title: const Text(AppStrings.snoozeOneDay),
                  onTap: () {
                    ref.read(notificationListProvider.notifier).snoozeNotification(notification.id, const Duration(days: 1));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.date_range_outlined, color: Colors.indigo),
                  title: const Text(AppStrings.snoozeThreeDays),
                  onTap: () {
                    ref.read(notificationListProvider.notifier).snoozeNotification(notification.id, const Duration(days: 3));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event_outlined, color: Colors.purple),
                  title: const Text(AppStrings.snoozeOneWeek),
                  onTap: () {
                    ref.read(notificationListProvider.notifier).snoozeNotification(notification.id, const Duration(days: 7));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final badgeColor = _getBadgeColor();
    final allEntities = ref.watch(entityListProvider).asData?.value ?? [];
    final allCatalog = ref.watch(catalogListProvider).asData?.value ?? [];

    final isEntityTarget = notification.targetType == AppTechnicalNotifications.notifTargetTypeEntity;
    final isSpeciesTarget = notification.targetType == AppTechnicalNotifications.notifTargetTypeSpecies;

    final targetEntity = isEntityTarget
        ? allEntities.where((e) => e.id == notification.targetId).firstOrNull
        : null;
    final targetSpecies = isSpeciesTarget
        ? allCatalog.where((s) => s.id == notification.targetId).firstOrNull
        : null;

    Widget? standardizedTile;
    if (isEntityTarget) {
      if (targetEntity != null) {
        standardizedTile = InstancePreviewCard(
          entity: targetEntity,
          onTap: () => context.pushEntityDetail(targetEntity.id),
        );
      } else {
        standardizedTile = FutureBuilder<WorldEntity?>(
          future: ref.read(entityRepositoryProvider).getEntityById(notification.targetId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final ent = snapshot.data;
            if (ent != null) {
              return InstancePreviewCard(
                entity: ent,
                onTap: () => context.pushEntityDetail(ent.id),
              );
            }
            return const SizedBox.shrink();
          },
        );
      }
    } else if (isSpeciesTarget) {
      if (targetSpecies != null) {
        standardizedTile = SpeciesTile(
          species: targetSpecies,
          onTap: () => context.pushSpeciesDetail(targetSpecies.id),
        );
      } else {
        standardizedTile = FutureBuilder<CatalogItem?>(
          future: ref.read(catalogRepositoryProvider).getCatalogItemById(notification.targetId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final sp = snapshot.data;
            if (sp != null) {
              return SpeciesTile(
                species: sp,
                onTap: () => context.pushSpeciesDetail(sp.id),
              );
            }
            return const SizedBox.shrink();
          },
        );
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: badgeColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header: Badge Icon + Event Title + Event Message
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getBadgeIcon(), color: badgeColor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                      if (notification.message.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Standardized Tile for Instance or Species
            if (standardizedTile != null)
              standardizedTile,

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.snooze, size: 16),
                  label: const Text(AppStrings.snoozeAction, style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Colors.blue.shade800,
                  ),
                  onPressed: () => _showSnoozeOptions(context, ref),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  tooltip: AppStrings.dismissAction,
                  onPressed: () {
                    ref.read(notificationListProvider.notifier).dismissNotification(notification.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
