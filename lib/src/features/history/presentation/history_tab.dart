import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(recentActivityProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.activityTitle),
      ),
      body: activityAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: theme.colorScheme.primary.withAlpha(120)),
                    const SizedBox(height: 16),
                    Text(
                      'Sin actividad registrada',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final evt = events[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withAlpha(25),
                  child: Icon(
                    evt.eventType == 'creation'
                        ? Icons.add_circle_outline
                        : evt.eventType == 'deletion'
                            ? Icons.delete_outline
                            : Icons.history,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: Text(evt.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  evt.timestamp.toString().substring(0, 16),
                  style: theme.textTheme.bodySmall,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
