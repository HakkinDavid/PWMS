import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/router/app_navigation_extension.dart';
import '../../../core/theme/app_theme.dart';
import '../../entities/presentation/entity_photo_thumbnail.dart';
import '../application/expiration_providers.dart';
import '../domain/expiration_item.dart';

class ExpirationRadarWidget extends ConsumerWidget {
  const ExpirationRadarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summary = ref.watch(expirationSummaryProvider);

    // Si no hay ningún ítem con fecha de vencimiento, no ocupamos espacio innecesario
    if (summary.allItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final topItems = summary.topUrgentItems.take(8).toList();
    final hasAlerts = summary.hasUrgentAlerts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasAlerts
                ? (summary.expiredCount > 0
                    ? Colors.redAccent.withAlpha(120)
                    : Colors.amberAccent.withAlpha(100))
                : theme.dividerColor,
            width: hasAlerts ? 1.5 : 1.0,
          ),
          boxShadow: hasAlerts
              ? [
                  BoxShadow(
                    color: (summary.expiredCount > 0 ? Colors.red : Colors.amber).withAlpha(20),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con Título, Badges y Ver todo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (summary.expiredCount > 0
                                ? Colors.redAccent
                                : AppTheme.primaryAccent)
                            .withAlpha(35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        summary.expiredCount > 0
                            ? Icons.warning_amber_rounded
                            : Icons.event_available_outlined,
                        color: summary.expiredCount > 0
                            ? Colors.redAccent
                            : AppTheme.primaryAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.expirationsRadarTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (hasAlerts) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              if (summary.expiredCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withAlpha(40),
                                    borderRadius: BorderRadius.circular(6),
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
                              if (summary.expiringSoonCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.amberAccent.withAlpha(40),
                                    borderRadius: BorderRadius.circular(6),
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
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.pushExpirationsCalendar(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.expirationsViewAll,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Carrusel horizontal de tarjetas compactas
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: topItems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = topItems[index];
                  return _RadarItemCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarItemCard extends StatelessWidget {
  final ExpirationItem item;

  const _RadarItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgencyColor = item.urgency.color;

    return InkWell(
      onTap: () => context.pushEntityDetail(item.entity.id),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.urgency == ExpirationUrgency.expired ||
                    item.urgency == ExpirationUrgency.critical
                ? urgencyColor.withAlpha(120)
                : theme.dividerColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Miniatura + Badge de urgencia
            Row(
              children: [
                EntityPhotoThumbnail(
                  species: item.species,
                  subspecies: item.subspecies,
                  instanceId: item.entity.id,
                  size: 34,
                  borderRadius: BorderRadius.circular(8),
                  useTextBadgeFallback: true,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: urgencyColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: urgencyColor.withAlpha(80), width: 0.8),
                  ),
                  child: Text(
                    item.urgency.label,
                    style: TextStyle(
                      color: urgencyColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Título
            Text(
              item.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Cuenta regresiva
            Row(
              children: [
                Icon(item.urgency.icon, size: 11, color: urgencyColor),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    item.relativeTimeText,
                    style: TextStyle(
                      color: urgencyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Ubicación
            if (item.locationName != null) ...[
              const SizedBox(height: 2),
              Text(
                item.locationName!,
                style: TextStyle(color: theme.colorScheme.secondary, fontSize: 9),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
