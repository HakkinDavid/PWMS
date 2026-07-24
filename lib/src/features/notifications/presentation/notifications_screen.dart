import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../domain/app_notification.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones & Recordatorios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(notificationListProvider.notifier).evaluateAndLoad();
            },
            tooltip: 'Actualizar',
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
                    'No tienes notificaciones pendientes',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Todos tus elementos están al día y requerimientos cubiertos.',
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
              padding: const EdgeInsets.all(16),
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
          child: Text('Error al cargar notificaciones: $err'),
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
      case 'expired':
        return Colors.red.shade700;
      case 'expiring_soon':
        return Colors.orange.shade800;
      case 'unsatisfied_need':
        return Colors.deepPurple.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  IconData _getBadgeIcon() {
    switch (notification.type) {
      case 'expired':
        return Icons.error_outline;
      case 'expiring_soon':
        return Icons.warning_amber_rounded;
      case 'unsatisfied_need':
        return Icons.inventory_2_outlined;
      default:
        return Icons.notifications;
    }
  }

  void _onTap(BuildContext context) {
    if (notification.targetType == 'species') {
      context.push('/catalog/${notification.targetId}');
    } else if (notification.targetType == 'entity') {
      context.push('/entities/${notification.targetId}');
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
                  'Posponer Recordatorio',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Elige por cuánto tiempo deseas ocultar este aviso:',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.timer_outlined, color: Colors.blue),
                  title: const Text('Posponer 1 día'),
                  onTap: () {
                    ref.read(notificationListProvider.notifier).snoozeNotification(notification.id, const Duration(days: 1));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.date_range_outlined, color: Colors.indigo),
                  title: const Text('Posponer 3 días'),
                  onTap: () {
                    ref.read(notificationListProvider.notifier).snoozeNotification(notification.id, const Duration(days: 3));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event_outlined, color: Colors.purple),
                  title: const Text('Posponer 1 semana (7 días)'),
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
    final badgeColor = _getBadgeColor();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: badgeColor.withOpacity(0.3), width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _onTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getBadgeIcon(), color: badgeColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                notification.message,
                style: const TextStyle(fontSize: 14, height: 1.3),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.snooze, size: 18),
                    label: const Text('Posponer'),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: Colors.blue.shade800,
                    ),
                    onPressed: () => _showSnoozeOptions(context, ref),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    tooltip: 'Descartar',
                    onPressed: () {
                      ref.read(notificationListProvider.notifier).dismissNotification(notification.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
