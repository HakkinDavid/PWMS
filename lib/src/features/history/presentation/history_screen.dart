import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/router/app_navigation_extension.dart';
import '../../../core/theme/app_theme.dart';
import '../application/activity_heatmap_providers.dart';
import '../domain/activity_event.dart';
import 'activity_heatmap_widget.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(historySearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getEventColor(ActivityEvent event) {
    final type = event.eventType;
    if (type == AppTechnicalStrings.eventTypeCreation ||
        type == AppTechnicalStrings.eventTypeSpeciesCreation ||
        type == AppTechnicalStrings.eventTypeSubspeciesCreation ||
        type == AppTechnicalStrings.eventTypeLocationCreation) {
      return Colors.green;
    }
    if (type == AppTechnicalStrings.eventTypeEdition ||
        type == AppTechnicalStrings.eventTypeSpeciesEdition ||
        type == AppTechnicalStrings.eventTypeLocationEdition ||
        type == AppTechnicalStrings.eventTypeSubspeciesSeparation ||
        type == AppTechnicalStrings.eventTypePhotoChanged) {
      return Colors.amber.shade800;
    }
    if (type == AppTechnicalStrings.eventTypeDeletion ||
        type == AppTechnicalStrings.eventTypeSpeciesDeletion ||
        type == AppTechnicalStrings.eventTypeSubspeciesDeletion ||
        type == AppTechnicalStrings.eventTypeLocationDeletion ||
        type == AppTechnicalStrings.eventTypeBatchDeletion ||
        type == AppTechnicalStrings.eventTypeAttachmentRemoved ||
        type == AppTechnicalStrings.eventTypePhotoRemoved ||
        type == AppTechnicalStrings.eventTypeRelationRemoved) {
      return Colors.red.shade700;
    }
    if (type == AppTechnicalStrings.eventTypeMovement ||
        type == AppTechnicalStrings.eventTypeLocationMovement ||
        type == AppTechnicalStrings.eventTypeSubspeciesMovement ||
        type == AppTechnicalStrings.eventTypeSpeciesMerge) {
      return Colors.blue.shade700;
    }
    if (type == AppTechnicalStrings.eventTypeRelation || type == AppTechnicalStrings.eventTypeAttachment) {
      return Colors.teal;
    }
    if (type == AppTechnicalStrings.eventTypeBackupExport ||
        type == AppTechnicalStrings.eventTypeBackupRestore) {
      return Colors.indigo;
    }
    if (type == AppTechnicalStrings.eventTypeAuditFix) {
      return Colors.deepOrange;
    }
    return Colors.blueGrey;
  }

  IconData _getEventIcon(ActivityEvent event) {
    final type = event.eventType;
    if (type == AppTechnicalStrings.eventTypeCreation ||
        type == AppTechnicalStrings.eventTypeSpeciesCreation ||
        type == AppTechnicalStrings.eventTypeSubspeciesCreation ||
        type == AppTechnicalStrings.eventTypeLocationCreation) {
      return Icons.add_circle_outline;
    }
    if (type == AppTechnicalStrings.eventTypeEdition ||
        type == AppTechnicalStrings.eventTypeSpeciesEdition ||
        type == AppTechnicalStrings.eventTypeLocationEdition ||
        type == AppTechnicalStrings.eventTypePhotoChanged) {
      return Icons.edit_outlined;
    }
    if (type == AppTechnicalStrings.eventTypeDeletion ||
        type == AppTechnicalStrings.eventTypeSpeciesDeletion ||
        type == AppTechnicalStrings.eventTypeSubspeciesDeletion ||
        type == AppTechnicalStrings.eventTypeLocationDeletion ||
        type == AppTechnicalStrings.eventTypeBatchDeletion ||
        type == AppTechnicalStrings.eventTypeAttachmentRemoved ||
        type == AppTechnicalStrings.eventTypePhotoRemoved ||
        type == AppTechnicalStrings.eventTypeRelationRemoved) {
      return Icons.delete_outline;
    }
    if (type == AppTechnicalStrings.eventTypeMovement ||
        type == AppTechnicalStrings.eventTypeLocationMovement ||
        type == AppTechnicalStrings.eventTypeSubspeciesMovement) {
      return Icons.move_to_inbox_outlined;
    }
    if (type == AppTechnicalStrings.eventTypeSpeciesMerge) {
      return Icons.merge_type;
    }
    if (type == AppTechnicalStrings.eventTypeSubspeciesSeparation) {
      return Icons.call_split;
    }
    if (type == AppTechnicalStrings.eventTypeRelation) {
      return Icons.link;
    }
    if (type == AppTechnicalStrings.eventTypeAttachment) {
      return Icons.attach_file;
    }
    if (type == AppTechnicalStrings.eventTypeBackupExport) {
      return Icons.cloud_upload_outlined;
    }
    if (type == AppTechnicalStrings.eventTypeBackupRestore) {
      return Icons.cloud_download_outlined;
    }
    if (type == AppTechnicalStrings.eventTypeAuditFix) {
      return Icons.build_circle_outlined;
    }
    if (type == AppTechnicalStrings.eventTypeConsumption) {
      return Icons.remove_circle_outline;
    }
    return Icons.history;
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return AppStrings.timeJustNow;
    if (diff.inHours < 1) return AppStrings.timeMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return AppStrings.timeHoursAgo(diff.inHours);
    if (diff.inDays < 7) return AppStrings.timeDaysAgo(diff.inDays);

    return AppStrings.formatDateTimeDMY(dt);
  }

  void _showEventDetailModal(ActivityEvent event) {
    final theme = Theme.of(context);
    final color = _getEventColor(event);
    final icon = _getEventIcon(event);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: color.withAlpha(40),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.eventDetailsTitle,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              event.eventType,
                              style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    event.description,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildDetailRow(AppStrings.categoryLabel, event.category),
                  _buildDetailRow(AppStrings.exactTimestampLabel, event.timestamp.toIso8601String()),
                  if (event.resolvedTargetId != null)
                    _buildDetailRow(AppStrings.targetIdLabel, event.resolvedTargetId!),
                  if (event.resolvedTargetType != null)
                    _buildDetailRow(AppStrings.targetTypeLabel, event.resolvedTargetType!),
                  const SizedBox(height: 16),
                  if (event.metadata != null && event.metadata!.isNotEmpty) ...[
                    Text(
                      AppStrings.technicalDetailsTitle,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Text(
                        const JsonEncoder.withIndent(AppTechnicalStrings.indentTwoSpaces).convert(event.metadata),
                        style: const TextStyle(fontFamily: AppTechnicalStrings.fontFamilyMonospace, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (event.isNavigable && event.resolvedTargetId != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text(AppStrings.viewTargetAction),
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (event.resolvedTargetType == AppTechnicalStrings.categoryEntity) {
                            context.pushEntityDetail(event.resolvedTargetId!);
                          } else if (event.resolvedTargetType == AppTechnicalStrings.categorySpecies) {
                            context.pushSpeciesDetail(event.resolvedTargetId!);
                          }
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.clearHistoryTitle),
        content: const Text(AppStrings.clearHistoryConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancelAction),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.clearAction, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(historyRepositoryProvider).clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(historySelectedCategoryProvider);
    final selectedDate = ref.watch(historySelectedDateFilterProvider);
    final historyEventsAsync = ref.watch(comprehensiveHistoryEventsProvider);
    final heatmapData = ref.watch(activityHeatmapFullYearProvider);

    final categories = [
      (AppTechnicalStrings.categoryAll, AppStrings.categoryFilterAll),
      (AppTechnicalStrings.categoryEntity, AppStrings.categoryFilterEntities),
      (AppTechnicalStrings.categorySpecies, AppStrings.categoryFilterSpecies),
      (AppTechnicalStrings.categoryLocation, AppStrings.categoryFilterLocations),
      (AppTechnicalStrings.categoryRelation, AppStrings.categoryFilterRelations),
      (AppTechnicalStrings.categoryBackup, AppStrings.categoryFilterBackupsAndSystem),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.historyTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: AppStrings.clearHistoryTooltip,
            onPressed: _confirmClearHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppStrings.historySearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: AppStrings.cancel,
                        onPressed: () {
                          _searchController.clear();
                          ref.read(historySearchQueryProvider.notifier).state = AppTechnicalStrings.empty;
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                ref.read(historySearchQueryProvider.notifier).state = val;
                setState(() {});
              },
            ),
          ),

          // Categories Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                ...categories.map((cat) {
                  final isSelected = selectedCategory == cat.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(cat.$2),
                      selected: isSelected,
                      onSelected: (_) {
                        ref.read(historySelectedCategoryProvider.notifier).state = cat.$1;
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Active Date Filter Chip (if selected from Heatmap)
          if (selectedDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryAccent.withAlpha(100)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 13, color: AppTheme.primaryAccent),
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.filteringByDate(
                            AppStrings.formatDateDMY(selectedDate),
                          ),
                          style: const TextStyle(
                            color: AppTheme.primaryAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            ref.read(historySelectedDateFilterProvider.notifier).state = null;
                          },
                          child: const Icon(Icons.close, size: 15, color: AppTheme.primaryAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Collapsible/Full-Year Heatmap & Chroma Bar Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ExpansionTile(
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: theme.dividerColor),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: theme.dividerColor),
              ),
              backgroundColor: theme.cardColor,
              collapsedBackgroundColor: theme.cardColor,
              leading: const Icon(Icons.bar_chart_rounded, color: AppTheme.secondaryAccent, size: 20),
              title: const Text(
                AppStrings.activityHeatmapTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              subtitle: Text(
                AppStrings.heatmapHeaderStats(heatmapData.currentStreak, heatmapData.totalEventsInPeriod),
                style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 11),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra de Espectro Cromático
                      _ChromaSpectrumBar(categoryCounts: heatmapData.categoryCounts),
                      const SizedBox(height: 12),
                      // Heatmap a año completo
                      ActivityHeatmapWidget(
                        showHeader: false,
                        isCompact: false,
                        selectedDay: selectedDate,
                        onDaySelected: (day) {
                          final current = ref.read(historySelectedDateFilterProvider);
                          if (current != null &&
                              current.year == day.year &&
                              current.month == day.month &&
                              current.day == day.day) {
                            ref.read(historySelectedDateFilterProvider.notifier).state = null;
                          } else {
                            ref.read(historySelectedDateFilterProvider.notifier).state = day;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 12),

          // Events List
          Expanded(
            child: historyEventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text(err.toString())),
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_toggle_off, size: 72, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.noHistoryEvents,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.noHistoryEventsSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 64),
                  itemBuilder: (ctx, i) {
                    final event = events[i];
                    final color = _getEventColor(event);
                    final icon = _getEventIcon(event);
                    final formattedTime = _formatTimestamp(event.timestamp);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withAlpha(35),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      title: Text(
                        event.description,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withAlpha(40),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                event.category,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formattedTime,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      trailing: event.isNavigable
                          ? Icon(Icons.chevron_right, color: Colors.grey.shade400)
                          : null,
                      onTap: () => _showEventDetailModal(event),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChromaSpectrumBar extends StatelessWidget {
  final Map<String, int> categoryCounts;

  const _ChromaSpectrumBar({required this.categoryCounts});

  @override
  Widget build(BuildContext context) {
    final total = categoryCounts.values.fold(0, (sum, c) => sum + c);
    if (total == 0) return const SizedBox.shrink();

    final colors = {
      AppTechnicalStrings.categoryEntity: Colors.green,
      AppTechnicalStrings.categorySpecies: Colors.amber.shade700,
      AppTechnicalStrings.categoryLocation: Colors.blue.shade700,
      AppTechnicalStrings.categoryRelation: Colors.teal,
      AppTechnicalStrings.categoryBackup: Colors.indigo,
      AppTechnicalStrings.categorySystem: Colors.purple,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Row(
              children: categoryCounts.entries.map((entry) {
                final ratio = entry.value / total;
                final color = colors[entry.key] ?? Colors.grey;
                return Expanded(
                  flex: (ratio * 1000).toInt().clamp(1, 1000),
                  child: Container(color: color),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
