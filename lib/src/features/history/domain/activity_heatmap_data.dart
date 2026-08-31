import '../domain/activity_event.dart';

class ActivityHeatmapData {
  final Map<DateTime, int> dailyCounts;
  final Map<DateTime, List<ActivityEvent>> dailyEvents;
  final int currentStreak;
  final int maxStreak;
  final int totalEventsInPeriod;
  final int maxDailyCount;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, int> categoryCounts;

  const ActivityHeatmapData({
    required this.dailyCounts,
    required this.dailyEvents,
    required this.currentStreak,
    required this.maxStreak,
    required this.totalEventsInPeriod,
    required this.maxDailyCount,
    required this.startDate,
    required this.endDate,
    required this.categoryCounts,
  });

  ActivityHeatmapData.empty()
      : dailyCounts = const {},
        dailyEvents = const {},
        currentStreak = 0,
        maxStreak = 0,
        totalEventsInPeriod = 0,
        maxDailyCount = 0,
        startDate = DateTime.now(),
        endDate = DateTime.now(),
        categoryCounts = const {};

  /// Retorna un nivel de 0 a 4 para determinar el color de la celda en el mapa de calor
  int getLevel(int count) {
    if (count <= 0) return 0;
    if (count <= 2) return 1;
    if (count <= 5) return 2;
    if (count <= 9) return 3;
    return 4;
  }

  factory ActivityHeatmapData.fromEvents(
    List<ActivityEvent> allEvents, {
    int daysRange = 112, // 16 weeks by default
    DateTime? referenceNow,
  }) {
    final now = referenceNow ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(Duration(days: daysRange - 1));

    final Map<DateTime, int> dailyCounts = {};
    final Map<DateTime, List<ActivityEvent>> dailyEvents = {};
    final Map<DateTime, int> allHistoricalCounts = {};
    final Map<String, int> categoryCounts = {};

    int maxCount = 0;
    int totalInPeriod = 0;

    for (final event in allEvents) {
      final day = DateTime(event.timestamp.year, event.timestamp.month, event.timestamp.day);
      allHistoricalCounts[day] = (allHistoricalCounts[day] ?? 0) + 1;

      // Check if within period
      if (!day.isBefore(startDate) && !day.isAfter(today)) {
        dailyCounts[day] = (dailyCounts[day] ?? 0) + 1;
        dailyEvents.putIfAbsent(day, () => []).add(event);
        totalInPeriod++;

        if (dailyCounts[day]! > maxCount) {
          maxCount = dailyCounts[day]!;
        }

        final cat = event.category;
        categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
      }
    }

    // Calcular racha activa (current streak)
    int currentStreak = 0;
    var checkDay = today;

    // Si hoy no hay actividad pero ayer sí, la racha sigue viva
    if ((allHistoricalCounts[checkDay] ?? 0) == 0) {
      checkDay = checkDay.subtract(const Duration(days: 1));
    }

    while ((allHistoricalCounts[checkDay] ?? 0) > 0) {
      currentStreak++;
      checkDay = checkDay.subtract(const Duration(days: 1));
    }

    // Calcular racha máxima histórica (max streak)
    int maxStreak = 0;
    if (allHistoricalCounts.isNotEmpty) {
      final sortedDays = allHistoricalCounts.keys.toList()..sort();
      int tempStreak = 0;
      DateTime? prevDay;

      for (final d in sortedDays) {
        if (prevDay == null || d.difference(prevDay).inDays == 1) {
          tempStreak++;
        } else if (d.difference(prevDay).inDays > 1) {
          tempStreak = 1;
        }
        if (tempStreak > maxStreak) {
          maxStreak = tempStreak;
        }
        prevDay = d;
      }
    }

    if (currentStreak > maxStreak) {
      maxStreak = currentStreak;
    }

    return ActivityHeatmapData(
      dailyCounts: dailyCounts,
      dailyEvents: dailyEvents,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      totalEventsInPeriod: totalInPeriod,
      maxDailyCount: maxCount,
      startDate: startDate,
      endDate: today,
      categoryCounts: categoryCounts,
    );
  }
}
