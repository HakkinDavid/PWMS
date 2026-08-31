import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/router/app_navigation_extension.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../application/expiration_providers.dart';
import '../domain/expiration_item.dart';
import '../domain/expiration_summary.dart';

class ExpirationRadarWidget extends ConsumerStatefulWidget {
  const ExpirationRadarWidget({super.key});

  @override
  ConsumerState<ExpirationRadarWidget> createState() => _ExpirationRadarWidgetState();
}

class _ExpirationRadarWidgetState extends ConsumerState<ExpirationRadarWidget> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  bool? _userExpanded;

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  Future<void> _handleEditDate(ExpirationItem item) async {
    final initialDate = item.expirationDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != initialDate && mounted) {
      final updated = item.entity.copyWith(
        expirationDate: picked,
        updatedAt: DateTime.now(),
      );
      await ref.read(entityRepositoryProvider).saveEntity(updated);
      if (mounted) {
        AppToast.show(context, message: AppStrings.expirationDateUpdatedSuccess, type: ToastType.success);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = ref.watch(expirationSummaryProvider);
    final selectedDate = ref.watch(expirationCalendarSelectedDateProvider);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Visibilidad condicional del cuerpo: si el usuario no ha tocado el chevron,
    // se expande si hay alertas urgentes o colapsa si no hay.
    final isExpanded = _userExpanded ?? summary.hasUrgentAlerts;

    final capitalizedMonth = AppStrings.formatMonthYear(_currentMonth);
    final firstDayOfMonth = _currentMonth;
    final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);

    // Domingo como primer día (0 = Domingo, 1 = Lunes, ..., 6 = Sábado)
    final firstWeekdaySundayFirst = firstDayOfMonth.weekday % 7;
    final totalCells = (firstWeekdaySundayFirst + daysInMonth <= 35) ? 35 : 42;

    // Ítems activos para el día seleccionado según day-spanning
    final selectedDayNormalized = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final activeItemsForSelectedDay = summary.allItems
        .where((i) => i.isActiveOnDay(selectedDayNormalized, today))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera Persistente: Título, Badges, Ver Todo y Chevron
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
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
                    Flexible(
                      child: Text(
                        AppStrings.expirationsRadarTitle,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (summary.expiredCount > 0) ...[
                      const SizedBox(width: 6),
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
                    ],
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
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => context.pushExpirationsCalendar(),
                    child: const Text(AppStrings.expirationsViewAll),
                  ),
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 24,
                    ),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      setState(() {
                        _userExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          // Cuerpo del Calendario Maestro (Condicional / Desplegable)
          if (isExpanded) ...[
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selector de mes (< Mes Año >)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 20),
                        visualDensity: VisualDensity.compact,
                        onPressed: _previousMonth,
                      ),
                      Text(
                        capitalizedMonth,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 20),
                        visualDensity: VisualDensity.compact,
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),

                  // Cabecera de días de la semana con Domingo primero (D, L, M, X, J, V, S)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: AppStrings.weekdayShortLettersSundayFirst.map((d) {
                        return SizedBox(
                          width: 34,
                          child: Text(
                            d,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Cuadrícula compacta de días del mes
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 1.35,
                    ),
                    itemCount: totalCells,
                    itemBuilder: (context, index) {
                      final dayOffset = index - firstWeekdaySundayFirst;
                      if (dayOffset < 0 || dayOffset >= daysInMonth) {
                        return const SizedBox.shrink();
                      }

                      final dayNumber = dayOffset + 1;
                      final cellDate = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
                      final isSelected = cellDate.year == selectedDate.year &&
                          cellDate.month == selectedDate.month &&
                          cellDate.day == selectedDate.day;

                      final isToday = cellDate.year == today.year &&
                          cellDate.month == today.month &&
                          cellDate.day == today.day;

                      // Evaluación de Day-Spanning sobre los ítems del inventario
                      final hasExpiredSpan = summary.allItems.any(
                        (i) => i.urgency == ExpirationUrgency.expired && i.isActiveOnDay(cellDate, today),
                      );
                      final hasWarningSpan = summary.allItems.any(
                        (i) =>
                            (i.urgency == ExpirationUrgency.critical || i.urgency == ExpirationUrgency.warning) &&
                            i.isActiveOnDay(cellDate, today),
                      );

                      // El punto únicamente va al inicio del "evento"
                      final isExpiredEventStart = summary.allItems.any(
                        (i) =>
                            i.urgency == ExpirationUrgency.expired &&
                            i.expirationDate.year == cellDate.year &&
                            i.expirationDate.month == cellDate.month &&
                            i.expirationDate.day == cellDate.day,
                      );
                      final isWarningEventStart = summary.allItems.any(
                        (i) =>
                            (i.urgency == ExpirationUrgency.critical || i.urgency == ExpirationUrgency.warning) &&
                            i.warningStartDate.year == cellDate.year &&
                            i.warningStartDate.month == cellDate.month &&
                            i.warningStartDate.day == cellDate.day,
                      );
                      final isSafeExpirationStart = summary.allItems.any(
                        (i) =>
                            (i.urgency == ExpirationUrgency.upcoming || i.urgency == ExpirationUrgency.safe) &&
                            i.expirationDate.year == cellDate.year &&
                            i.expirationDate.month == cellDate.month &&
                            i.expirationDate.day == cellDate.day,
                      );

                      Color? spanColor;
                      if (hasExpiredSpan) {
                        spanColor = Colors.redAccent.withAlpha(45);
                      } else if (hasWarningSpan) {
                        spanColor = Colors.amberAccent.withAlpha(55);
                      }

                      final isEventStart = isExpiredEventStart || isWarningEventStart || isSafeExpirationStart;

                      return InkWell(
                        onTap: () {
                          ref.read(expirationCalendarSelectedDateProvider.notifier).state = cellDate;
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary.withAlpha(40)
                                : spanColor ?? (isToday ? theme.dividerColor.withAlpha(30) : Colors.transparent),
                            borderRadius: BorderRadius.circular(6),
                            border: isSelected
                                ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                                : (isToday ? Border.all(color: Colors.grey.shade500, width: 1.0) : null),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayNumber.toString(),
                                style: TextStyle(
                                  fontWeight: isSelected || isToday || isEventStart
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected ? theme.colorScheme.primary : Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                              if (isExpiredEventStart) ...[
                                const SizedBox(height: 1),
                                Container(
                                  width: 4.5,
                                  height: 4.5,
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ] else if (isWarningEventStart) ...[
                                const SizedBox(height: 1),
                                Container(
                                  width: 4.5,
                                  height: 4.5,
                                  decoration: const BoxDecoration(
                                    color: Colors.amberAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ] else if (isSafeExpirationStart) ...[
                                const SizedBox(height: 1),
                                Container(
                                  width: 4.5,
                                  height: 4.5,
                                  decoration: const BoxDecoration(
                                    color: Colors.greenAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Detalle del Día Seleccionado: Elemento visualmente independiente y condicional (3 y 5)
            if (activeItemsForSelectedDay.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.formatFullDate(selectedDayNormalized),
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppStrings.itemsCount(activeItemsForSelectedDay.length),
                          style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Divider(height: 1),
                    const SizedBox(height: 6),
                    ...activeItemsForSelectedDay.map(
                      (item) => _buildExpirationTile(context, item),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildExpirationTile(BuildContext context, ExpirationItem item) {
    final theme = Theme.of(context);
    return InstancePreviewCard(
      entity: item.entity,
      onTap: () => context.pushEntityDetail(item.entity.id),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20),
        tooltip: AppStrings.moreOptionsTooltip,
        onSelected: (value) {
          if (value == AppTechnicalStrings.actionKeyEditDate) {
            _handleEditDate(item);
          } else if (value == AppTechnicalStrings.actionKeyLocate && item.entity.locationId != null) {
            context.goToInventory(focusNodeId: item.entity.locationId);
          }
        },
        itemBuilder: (ctx) => [
          const PopupMenuItem(
            value: AppTechnicalStrings.actionKeyEditDate,
            child: Row(
              children: [
                Icon(Icons.edit_calendar_outlined, size: 18),
                SizedBox(width: 8),
                Text(AppStrings.actionExtendExpiration),
              ],
            ),
          ),
          if (item.entity.locationId != null)
            const PopupMenuItem(
              value: AppTechnicalStrings.actionKeyLocate,
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18),
                  SizedBox(width: 8),
                  Text(AppStrings.actionLocateInInventory),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
