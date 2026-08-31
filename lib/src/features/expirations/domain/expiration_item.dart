import 'package:flutter/material.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../features/catalog/domain/catalog_item.dart';
import '../../../features/catalog/domain/subspecies.dart';
import '../../../features/entities/domain/world_entity.dart';

enum ExpirationUrgency {
  expired,
  critical, // <= 3 days
  warning,  // <= 7 days
  upcoming, // <= 30 days
  safe;     // > 30 days

  Color get color {
    switch (this) {
      case ExpirationUrgency.expired:
        return const Color(0xFFEF4444); // Red
      case ExpirationUrgency.critical:
        return const Color(0xFFF97316); // Bright Orange
      case ExpirationUrgency.warning:
        return const Color(0xFFF59E0B); // Amber
      case ExpirationUrgency.upcoming:
        return const Color(0xFF38BDF8); // Sky Blue
      case ExpirationUrgency.safe:
        return const Color(0xFF10B981); // Emerald
    }
  }

  IconData get icon {
    switch (this) {
      case ExpirationUrgency.expired:
        return Icons.error_outline;
      case ExpirationUrgency.critical:
        return Icons.warning_amber_rounded;
      case ExpirationUrgency.warning:
        return Icons.access_time_filled;
      case ExpirationUrgency.upcoming:
        return Icons.calendar_today_outlined;
      case ExpirationUrgency.safe:
        return Icons.check_circle_outline;
    }
  }

  String get label {
    switch (this) {
      case ExpirationUrgency.expired:
        return AppStrings.urgencyExpired;
      case ExpirationUrgency.critical:
        return AppStrings.urgencyCritical;
      case ExpirationUrgency.warning:
        return AppStrings.urgencyWarning;
      case ExpirationUrgency.upcoming:
        return AppStrings.urgencyUpcoming;
      case ExpirationUrgency.safe:
        return AppStrings.urgencySafe;
    }
  }
}

class ExpirationItem {
  final WorldEntity entity;
  final CatalogItem? species;
  final Subspecies? subspecies;
  final String? locationName;
  final String? locationBreadcrumb;
  final DateTime expirationDate;
  final int daysUntilExpiration;
  final ExpirationUrgency urgency;
  final double? shelfLifeElapsedRatio; // 0.0 to 1.0 (or >1.0 if expired)
  final int? totalShelfLifeDays;
  final int? daysElapsedSinceCreation;

  const ExpirationItem({
    required this.entity,
    this.species,
    this.subspecies,
    this.locationName,
    this.locationBreadcrumb,
    required this.expirationDate,
    required this.daysUntilExpiration,
    required this.urgency,
    this.shelfLifeElapsedRatio,
    this.totalShelfLifeDays,
    this.daysElapsedSinceCreation,
  });

  String get displayName {
    if (subspecies != null && subspecies!.subspeciesName.toLowerCase() != AppStrings.genericSubspeciesNameLower) {
      return AppStrings.subspeciesNameWithBrand(subspecies!.subspeciesName, subspecies!.brand);
    }
    return species?.name ?? AppStrings.typeObject;
  }

  String get relativeTimeText {
    if (daysUntilExpiration < -1) {
      return AppStrings.daysAgoExpired(daysUntilExpiration.abs());
    } else if (daysUntilExpiration == -1) {
      return AppStrings.expiredYesterday;
    } else if (daysUntilExpiration == 0) {
      return AppStrings.expiredToday;
    } else if (daysUntilExpiration == 1) {
      return AppStrings.expiresTomorrow;
    } else if (daysUntilExpiration < 30) {
      return AppStrings.daysLeftExpiring(daysUntilExpiration);
    } else {
      final months = (daysUntilExpiration / 30).round();
      return AppStrings.monthsLeftExpiring(months);
    }
  }

  int get warningDays => species?.warningDaysBeforeExpiration ?? 7;

  DateTime get warningStartDate {
    final exp = DateTime(expirationDate.year, expirationDate.month, expirationDate.day);
    return exp.subtract(Duration(days: warningDays));
  }

  bool isActiveOnDay(DateTime day, DateTime today) {
    final target = DateTime(day.year, day.month, day.day);
    final exp = DateTime(expirationDate.year, expirationDate.month, expirationDate.day);
    final current = DateTime(today.year, today.month, today.day);

    if (exp.isBefore(current)) {
      // Overdue range: [exp, current]
      return (target.isAtSameMomentAs(exp) || target.isAfter(exp)) &&
          (target.isAtSameMomentAs(current) || target.isBefore(current));
    } else if (urgency == ExpirationUrgency.critical || urgency == ExpirationUrgency.warning) {
      // Warning / Soon range: [max(current, warningStartDate), exp] or [warningStartDate, exp]
      final warnStart = warningStartDate;
      final effectiveStart = warnStart.isBefore(current) ? current : warnStart;
      return (target.isAtSameMomentAs(effectiveStart) || target.isAfter(effectiveStart)) &&
          (target.isAtSameMomentAs(exp) || target.isBefore(exp));
    } else {
      // Future / safe: exact day
      return target.isAtSameMomentAs(exp);
    }
  }

  static ExpirationUrgency calculateUrgency({
    required DateTime expirationDate,
    required DateTime now,
    int warningDays = 7,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(expirationDate.year, expirationDate.month, expirationDate.day);
    final diffDays = target.difference(today).inDays;

    if (diffDays < 0) {
      return ExpirationUrgency.expired;
    } else if (diffDays <= 3) {
      return ExpirationUrgency.critical;
    } else if (diffDays <= warningDays) {
      return ExpirationUrgency.warning;
    } else if (diffDays <= 30) {
      return ExpirationUrgency.upcoming;
    } else {
      return ExpirationUrgency.safe;
    }
  }

  static double? calculateShelfLifeRatio({
    required DateTime createdAt,
    required DateTime expirationDate,
    required DateTime now,
  }) {
    final totalDuration = expirationDate.difference(createdAt).inMilliseconds;
    if (totalDuration <= 0) return null;
    final elapsed = now.difference(createdAt).inMilliseconds;
    return (elapsed / totalDuration).clamp(0.0, 2.0);
  }
}
