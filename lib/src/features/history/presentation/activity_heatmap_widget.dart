import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/router/app_navigation_extension.dart';
import '../../../core/theme/app_theme.dart';
import '../application/activity_heatmap_providers.dart';
import '../domain/activity_heatmap_data.dart';

class ActivityHeatmapWidget extends ConsumerWidget {
  final bool showHeader;
  final bool isCompact;
  final ValueChanged<DateTime>? onDaySelected;
  final DateTime? selectedDay;

  const ActivityHeatmapWidget({
    super.key,
    this.showHeader = true,
    this.isCompact = true,
    this.onDaySelected,
    this.selectedDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final heatmapData = isCompact
        ? ref.watch(activityHeatmap16WeeksProvider)
        : ref.watch(activityHeatmapFullYearProvider);

    return Padding(
      padding: isCompact ? const EdgeInsets.symmetric(horizontal: 20.0) : EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera opcional
            if (showHeader) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryAccent.withAlpha(35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.grid_view_rounded,
                          color: AppTheme.secondaryAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.activityHeatmapTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                AppStrings.currentStreakWithColon,
                                style: TextStyle(
                                  color: theme.textTheme.bodySmall?.color,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                AppStrings.streakWithFlame(heatmapData.currentStreak),
                                style: const TextStyle(
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppStrings.streakWithTrophy(heatmapData.maxStreak),
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isCompact)
                    TextButton(
                      onPressed: () => context.pushHistory(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        children: [
                          Text(
                            AppStrings.viewAllAction,
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
            ],

            // Matriz interactiva de celdas
            _HeatmapMatrixGrid(
              data: heatmapData,
              onDaySelected: onDaySelected,
              selectedDay: selectedDay,
            ),
            const SizedBox(height: 10),

            // Leyenda: Menos ■ ■ ■ ■ ■ Más
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.totalEventsThisMonth(heatmapData.totalEventsInPeriod),
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: 10,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      AppStrings.heatmapLess,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 4),
                    ...List.generate(5, (level) {
                      return Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: _HeatmapMatrixGrid.getColorForLevel(level),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.heatmapMore,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatmapMatrixGrid extends StatefulWidget {
  final ActivityHeatmapData data;
  final ValueChanged<DateTime>? onDaySelected;
  final DateTime? selectedDay;

  const _HeatmapMatrixGrid({
    required this.data,
    this.onDaySelected,
    this.selectedDay,
  });

  static Color getColorForLevel(int level) {
    switch (level) {
      case 0:
        return const Color(0xFF161B22); // Empty
      case 1:
        return const Color(0xFF0E4429); // 1-2
      case 2:
        return const Color(0xFF006D32); // 3-5
      case 3:
        return const Color(0xFF26A641); // 6-9
      case 4:
        return const Color(0xFF39D353); // 10+
      default:
        return const Color(0xFF161B22);
    }
  }

  @override
  State<_HeatmapMatrixGrid> createState() => _HeatmapMatrixGridState();
}

class _HeatmapMatrixGridState extends State<_HeatmapMatrixGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Auto-scroll al final (días más recientes)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final start = widget.data.startDate;
    final end = widget.data.endDate;

    // Calcular el domingo de la primera semana
    // DateTime.weekday: 1 = Lunes, ..., 6 = Sábado, 7 = Domingo
    final startSunday = start.subtract(Duration(days: start.weekday % 7));
    final totalDays = end.difference(startSunday).inDays + 1;
    final totalWeeks = (totalDays / 7).ceil();

    final dayLabels = AppStrings.weekdayShortLettersSundayFirst;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiquetas de días de la semana (D, L, M, X, J, V, S)
        Column(
          children: List.generate(7, (index) {
            return Container(
              height: 12,
              margin: const EdgeInsets.symmetric(vertical: 1.5),
              alignment: Alignment.center,
              child: Text(
                dayLabels[index],
                style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ),
        const SizedBox(width: 6),

        // Cuadrícula deslizable horizontalmente
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(totalWeeks, (weekIndex) {
                return Column(
                  children: List.generate(7, (dayOfWeekIndex) {
                    final dayOffset = (weekIndex * 7) + dayOfWeekIndex;
                    final cellDate = startSunday.add(Duration(days: dayOffset));
                    final isFuture = cellDate.isAfter(end);

                    if (isFuture) {
                      return const SizedBox(width: 12, height: 12, child: null);
                    }

                    final count = widget.data.dailyCounts[cellDate] ?? 0;
                    final level = widget.data.getLevel(count);
                    final color = _HeatmapMatrixGrid.getColorForLevel(level);

                    final isSelected = widget.selectedDay != null &&
                        widget.selectedDay!.year == cellDate.year &&
                        widget.selectedDay!.month == cellDate.month &&
                        widget.selectedDay!.day == cellDate.day;

                    final dateStr = AppStrings.formatDateDMY(cellDate);
                    final tooltipMsg = AppStrings.heatmapActivityCount(count, dateStr);

                    return Tooltip(
                      message: tooltipMsg,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.onDaySelected != null) {
                            widget.onDaySelected!(cellDate);
                          }
                        },
                        child: Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.all(1.5),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2.5),
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 1.5)
                                : Border.all(
                                    color: Colors.white.withAlpha(level > 0 ? 30 : 10),
                                    width: 0.5,
                                  ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
