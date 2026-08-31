import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../domain/world_entity.dart';

class ShelfLifeGaugeWidget extends StatelessWidget {
  final WorldEntity entity;

  const ShelfLifeGaugeWidget({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    if (entity.expirationDate == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final now = DateTime.now();
    final created = entity.createdAt;
    final expires = entity.expirationDate!;

    final totalMs = expires.difference(created).inMilliseconds;
    if (totalMs <= 0) return const SizedBox.shrink();

    final elapsedMs = now.difference(created).inMilliseconds;
    final ratio = (elapsedMs / totalMs).clamp(0.0, 1.0);
    final percent = (ratio * 100).toInt();

    final today = DateTime(now.year, now.month, now.day);
    final expDay = DateTime(expires.year, expires.month, expires.day);
    final daysRemaining = expDay.difference(today).inDays;
    final isExpired = daysRemaining < 0;

    final color = isExpired
        ? Colors.redAccent
        : (ratio > 0.8
            ? Colors.orangeAccent
            : (ratio > 0.5 ? Colors.amberAccent : Colors.greenAccent));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isExpired ? Colors.redAccent.withAlpha(80) : theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.timelapse_outlined, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.shelfLifeTitle,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isExpired
                      ? AppStrings.urgencyExpired
                      : (daysRemaining == 0
                          ? AppStrings.expiredToday
                          : AppStrings.shelfLifeRemaining(daysRemaining)),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Barra de progreso con gradiente
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: theme.scaffoldBackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),

          // Fechas inicial y final
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.shelfLifeStartPrefix(AppStrings.formatDateDMY(created)),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              ),
              Text(
                AppStrings.shelfLifeConsumedRatio(percent),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              Text(
                AppStrings.shelfLifeEndPrefix(AppStrings.formatDateDMY(expires)),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
