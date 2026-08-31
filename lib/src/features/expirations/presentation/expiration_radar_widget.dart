import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/router/app_navigation_extension.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_confirmation_dialog.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_toast.dart';
import '../../entities/presentation/instance_preview_card.dart';
import '../../history/domain/activity_event.dart';
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

  Future<void> _handleConsume(ExpirationItem item) async {
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: AppStrings.actionConsumeConfirmTitle,
      message: AppStrings.actionConsumeConfirmMessage(item.displayName),
      confirmLabel: AppStrings.actionConsume,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final now = DateTime.now();
      final event = ActivityEvent(
        id: UniqueKey().toString(),
        entityId: item.entity.id,
        eventType: AppTechnicalStrings.eventTypeConsumption,
        description: AppStrings.consumedEventDescription(item.displayName),
        metadata: {
          AppTechnicalStrings.keySpeciesId: item.entity.speciesId,
          AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
          AppTechnicalStrings.keyTargetType: AppTechnicalStrings.notifTargetTypeEntity,
          AppTechnicalStrings.keyTargetId: item.entity.id,
          AppTechnicalStrings.keyConsumedAt: now.toIso8601String(),
        },
        timestamp: now,
      );
      await ref.read(historyRepositoryProvider).logEvent(event);
      await ref.read(entityRepositoryProvider).deleteEntity(item.entity.id);
      if (mounted) {
        AppToast.show(context, message: AppStrings.instanceConsumedSuccess, type: ToastType.success);
      }
    }
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

    // No mostrar si no hay vencimientos vencidos o próximos a vencer (definido por warningDays de cada elemento)
    if (!summary.hasUrgentAlerts) {
      return const SizedBox.shrink();
    }

    final capitalizedMonth = AppStrings.formatMonthYear(_currentMonth);
    final firstDayOfMonth = _currentMonth;
    final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Lunes, 7 = Domingo

    final selectedDayNormalized = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final itemsForSelectedDay = summary.itemsByDate[selectedDayNormalized] ?? [];

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
          const SizedBox(height: 12),

          // Tarjeta contenedor del Calendario Maestro
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
                // Selector de mes (< Mes Año >)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _previousMonth,
                    ),
                    Text(
                      capitalizedMonth,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),

                // Cabecera de días de la semana (L, M, X, J, V, S, D)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: AppStrings.weekdayShortLetters.map((d) {
                    return SizedBox(
                      width: 36,
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 6),

                // Cuadrícula de días del mes
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: 42,
                  itemBuilder: (context, index) {
                    final dayOffset = index - (firstWeekday - 1);
                    if (dayOffset < 0 || dayOffset >= daysInMonth) {
                      return const SizedBox.shrink();
                    }

                    final dayNumber = dayOffset + 1;
                    final cellDate = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
                    final isSelected = cellDate.year == selectedDate.year &&
                        cellDate.month == selectedDate.month &&
                        cellDate.day == selectedDate.day;

                    final today = DateTime.now();
                    final isToday = cellDate.year == today.year &&
                        cellDate.month == today.month &&
                        cellDate.day == today.day;

                    final dayItems = summary.itemsByDate[cellDate] ?? [];
                    final hasExpired = dayItems.any((i) => i.urgency == ExpirationUrgency.expired);
                    final hasWarning = dayItems.any((i) =>
                        i.urgency == ExpirationUrgency.critical || i.urgency == ExpirationUrgency.warning);

                    return InkWell(
                      onTap: () {
                        ref.read(expirationCalendarSelectedDateProvider.notifier).state = cellDate;
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withAlpha(50)
                              : (isToday ? theme.dividerColor.withAlpha(40) : Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                              : (isToday ? Border.all(color: Colors.grey.shade600, width: 1) : null),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dayNumber.toString(),
                              style: TextStyle(
                                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? theme.colorScheme.primary : Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            if (dayItems.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: hasExpired
                                          ? Colors.redAccent
                                          : (hasWarning ? Colors.amberAccent : Colors.greenAccent),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  if (dayItems.length > 1) ...[
                                    const SizedBox(width: 2),
                                    Text(
                                      dayItems.length.toString(),
                                      style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // Encabezado del día seleccionado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.formatFullDate(selectedDayNormalized),
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppStrings.itemsCount(itemsForSelectedDay.length),
                      style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Lista de instancias del día seleccionado
                if (itemsForSelectedDay.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        AppStrings.noExpirationsForDate,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ),
                  )
                else
                  ...itemsForSelectedDay.map(
                    (item) => _buildExpirationTile(context, item),
                  ),
              ],
            ),
          ),
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
          if (value == AppTechnicalStrings.actionKeyConsume) {
            _handleConsume(item);
          } else if (value == AppTechnicalStrings.actionKeyEditDate) {
            _handleEditDate(item);
          } else if (value == AppTechnicalStrings.actionKeyLocate && item.entity.locationId != null) {
            context.goToInventory(focusNodeId: item.entity.locationId);
          }
        },
        itemBuilder: (ctx) => [
          PopupMenuItem(
            value: AppTechnicalStrings.actionKeyConsume,
            child: Row(
              children: [
                Icon(Icons.restaurant_outlined, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text(AppStrings.actionConsume),
              ],
            ),
          ),
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
