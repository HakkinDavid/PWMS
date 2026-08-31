import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/activity_event.dart';
import '../domain/activity_heatmap_data.dart';

final activityHeatmap16WeeksProvider = Provider<ActivityHeatmapData>((ref) {
  final allEventsAsync = ref.watch(allHistoryEventsStreamProvider);
  final events = allEventsAsync.asData?.value ?? [];
  if (events.isEmpty) return ActivityHeatmapData.empty();
  return ActivityHeatmapData.fromEvents(events, daysRange: 112); // 16 weeks
});

final activityHeatmapFullYearProvider = Provider<ActivityHeatmapData>((ref) {
  final allEventsAsync = ref.watch(allHistoryEventsStreamProvider);
  final events = allEventsAsync.asData?.value ?? [];
  if (events.isEmpty) return ActivityHeatmapData.empty();
  return ActivityHeatmapData.fromEvents(events, daysRange: 365);
});

final historySelectedDateFilterProvider = StateProvider<DateTime?>((ref) => null);

/// Filtered events incorporating Category, Search Query, AND Specific Date Filter from the Heatmap
final comprehensiveHistoryEventsProvider = Provider<AsyncValue<List<ActivityEvent>>>((ref) {
  final allEventsAsync = ref.watch(allHistoryEventsStreamProvider);
  final category = ref.watch(historySelectedCategoryProvider);
  final query = ref.watch(historySearchQueryProvider);
  final selectedDate = ref.watch(historySelectedDateFilterProvider);

  return allEventsAsync.whenData((events) {
    var filtered = events;

    // Filter by selected date if set
    if (selectedDate != null) {
      filtered = filtered.where((e) {
        return e.timestamp.year == selectedDate.year &&
            e.timestamp.month == selectedDate.month &&
            e.timestamp.day == selectedDate.day;
      }).toList();
    }

    // Filter by category
    if (category.isNotEmpty && category != AppTechnicalStrings.categoryAll) {
      filtered = filtered.where((e) => e.category == category).toList();
    }

    // Filter by search text
    if (query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      filtered = filtered.where((e) {
        if (e.description.toLowerCase().contains(clean)) return true;
        if (e.entityId?.toLowerCase().contains(clean) ?? false) return true;
        if (e.resolvedTargetId?.toLowerCase().contains(clean) ?? false) return true;
        if (e.metadata != null && e.metadata.toString().toLowerCase().contains(clean)) return true;
        return false;
      }).toList();
    }

    return filtered;
  });
});
