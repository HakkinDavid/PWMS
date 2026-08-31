import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/router/app_navigation_extension.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../application/expiration_providers.dart';

class ExpirationRadarWidget extends ConsumerWidget {
  const ExpirationRadarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summary = ref.watch(expirationSummaryProvider);

    // No mostrar si no hay vencimientos vencidos o próximos a vencer (definido por warningDays de cada elemento)
    if (!summary.hasUrgentAlerts) {
      return const SizedBox.shrink();
    }

    final urgentItems = [
      ...summary.expiredItems,
      ...summary.criticalItems,
      ...summary.warningItems,
    ];

    if (urgentItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayItems = urgentItems.take(3).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera con Título, Badges y Ver todo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    summary.expiredCount > 0
                        ? Icons.warning_amber_rounded
                        : Icons.access_time_filled,
                    color: summary.expiredCount > 0
                        ? Colors.redAccent
                        : Colors.amberAccent,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.expirationsRadarTitle,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  if (summary.expiredCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withAlpha(40),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.redAccent.withAlpha(100), width: 0.8),
                      ),
                      child: Text(
                        AppStrings.statusExpiredCount(summary.expiredCount),
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (summary.expiringSoonCount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent.withAlpha(40),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.amberAccent.withAlpha(100), width: 0.8),
                      ),
                      child: Text(
                        AppStrings.statusExpiringSoonCount(summary.expiringSoonCount),
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              TextButton(
                onPressed: () => context.pushExpirationsCalendar(),
                child: const Text(AppStrings.expirationsViewAll),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Tiles estándar de instancias urgentes
          ...displayItems.map(
            (item) => InstancePreviewCard(
              entity: item.entity,
              onTap: () => context.pushEntityDetail(item.entity.id),
            ),
          ),
        ],
      ),
    );
  }
}
