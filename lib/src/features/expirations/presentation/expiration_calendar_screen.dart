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

enum ExpirationViewMode { monthly, agenda }

class ExpirationCalendarScreen extends ConsumerStatefulWidget {
  const ExpirationCalendarScreen({super.key});

  @override
  ConsumerState<ExpirationCalendarScreen> createState() => _ExpirationCalendarScreenState();
}

class _ExpirationCalendarScreenState extends ConsumerState<ExpirationCalendarScreen> {
  ExpirationViewMode _viewMode = ExpirationViewMode.monthly;
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(expirationSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      // Registrar evento de consumo explícito
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
    final selectedUrgency = ref.watch(expirationUrgencyFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.expirationsCalendarTitle),
        actions: [
          // Toggle entre vista mensual y vista agenda
          SegmentedButton<ExpirationViewMode>(
            segments: const [
              ButtonSegment(
                value: ExpirationViewMode.monthly,
                icon: Icon(Icons.calendar_month_outlined, size: 18),
                label: Text(AppStrings.viewModeMonthly, style: TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: ExpirationViewMode.agenda,
                icon: Icon(Icons.view_agenda_outlined, size: 18),
                label: Text(AppStrings.viewModeAgenda, style: TextStyle(fontSize: 12)),
              ),
            ],
            selected: {_viewMode},
            onSelectionChanged: (set) {
              setState(() {
                _viewMode = set.first;
              });
            },
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Barra de Búsqueda y Filtros
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppStrings.searchExpirationsHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(expirationSearchQueryProvider.notifier).state = AppTechnicalStrings.empty;
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                ref.read(expirationSearchQueryProvider.notifier).state = val;
                setState(() {});
              },
            ),
          ),

          // Chips de filtro por urgencia
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                FilterChip(
                  label: const Text(AppStrings.filterAllUrgencies),
                  selected: selectedUrgency == null,
                  onSelected: (_) {
                    ref.read(expirationUrgencyFilterProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: 6),
                FilterChip(
                  avatar: const Icon(Icons.error_outline, size: 14, color: Colors.redAccent),
                  label: Text(AppStrings.labelWithCount(AppStrings.urgencyExpired, summary.expiredCount)),
                  selected: selectedUrgency == ExpirationUrgency.expired,
                  onSelected: (_) {
                    ref.read(expirationUrgencyFilterProvider.notifier).state =
                        selectedUrgency == ExpirationUrgency.expired ? null : ExpirationUrgency.expired;
                  },
                ),
                const SizedBox(width: 6),
                FilterChip(
                  avatar: const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.amberAccent),
                  label: Text(AppStrings.labelWithCount(AppStrings.urgencyWarning, summary.expiringSoonCount)),
                  selected: selectedUrgency == ExpirationUrgency.warning || selectedUrgency == ExpirationUrgency.critical,
                  onSelected: (_) {
                    ref.read(expirationUrgencyFilterProvider.notifier).state =
                        selectedUrgency == ExpirationUrgency.warning ? null : ExpirationUrgency.warning;
                  },
                ),
                const SizedBox(width: 6),
                FilterChip(
                  avatar: const Icon(Icons.check_circle_outline, size: 14, color: Colors.greenAccent),
                  label: const Text(AppStrings.urgencySafe),
                  selected: selectedUrgency == ExpirationUrgency.safe,
                  onSelected: (_) {
                    ref.read(expirationUrgencyFilterProvider.notifier).state =
                        selectedUrgency == ExpirationUrgency.safe ? null : ExpirationUrgency.safe;
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Contenido principal según el modo seleccionado
          Expanded(
            child: _viewMode == ExpirationViewMode.monthly
                ? _buildMonthlyView(context, summary, selectedDate)
                : _buildAgendaView(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyView(BuildContext context, ExpirationSummary summary, DateTime selectedDate) {
    final theme = Theme.of(context);
    final capitalizedMonth = AppStrings.formatMonthYear(_currentMonth);

    // Calcular días del mes actual
    final firstDayOfMonth = _currentMonth;
    final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Lunes, 7 = Domingo

    // Obtener ítems del día seleccionado
    final selectedDayNormalized = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final itemsForSelectedDay = summary.itemsByDate[selectedDayNormalized] ?? [];

    return Column(
      children: [
        // Selector de mes (< Mes Año >)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
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
        ),

        // Cabecera de días de la semana
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: AppStrings.weekdayShortLetters.map((d) {
              return SizedBox(
                width: 38,
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 6),

        // Cuadrícula de días
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1.1,
            ),
            itemCount: 42, // 6 semanas
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
                          fontSize: 13,
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
        ),

        const Divider(height: 16),

        // Lista de ítems del día seleccionado
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.formatFullDate(selectedDayNormalized),
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                AppStrings.itemsCount(itemsForSelectedDay.length),
                style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
              ),
            ],
          ),
        ),

        Expanded(
          child: itemsForSelectedDay.isEmpty
              ? Center(
                  child: Text(
                    AppStrings.noExpirationsForDate,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: itemsForSelectedDay.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = itemsForSelectedDay[index];
                    return _buildExpirationTile(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAgendaView(BuildContext context) {
    final filteredItems = ref.watch(filteredExpirationsProvider);

    if (filteredItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_available, size: 64, color: Colors.grey.shade500),
              const SizedBox(height: 16),
              const Text(
                AppStrings.expirationsEmpty,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.expirationsEmptySubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    // Agrupar por categorías de agenda
    final expired = filteredItems.where((i) => i.urgency == ExpirationUrgency.expired).toList();
    final criticalAndWarning = filteredItems
        .where((i) => i.urgency == ExpirationUrgency.critical || i.urgency == ExpirationUrgency.warning)
        .toList();
    final upcoming = filteredItems.where((i) => i.urgency == ExpirationUrgency.upcoming).toList();
    final safe = filteredItems.where((i) => i.urgency == ExpirationUrgency.safe).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        if (expired.isNotEmpty) ...[
          _buildAgendaSectionHeader(AppStrings.sectionExpired, Colors.redAccent, expired.length),
          ...expired.map((i) => _buildExpirationTile(i)),
          const SizedBox(height: 16),
        ],
        if (criticalAndWarning.isNotEmpty) ...[
          _buildAgendaSectionHeader(AppStrings.sectionThisWeek, Colors.amberAccent, criticalAndWarning.length),
          ...criticalAndWarning.map((i) => _buildExpirationTile(i)),
          const SizedBox(height: 16),
        ],
        if (upcoming.isNotEmpty) ...[
          _buildAgendaSectionHeader(AppStrings.sectionThisMonth, const Color(0xFF38BDF8), upcoming.length),
          ...upcoming.map((i) => _buildExpirationTile(i)),
          const SizedBox(height: 16),
        ],
        if (safe.isNotEmpty) ...[
          _buildAgendaSectionHeader(AppStrings.sectionFuture, Colors.greenAccent, safe.length),
          ...safe.map((i) => _buildExpirationTile(i)),
        ],
      ],
    );
  }

  Widget _buildAgendaSectionHeader(String title, Color color, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpirationTile(ExpirationItem item) {
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
