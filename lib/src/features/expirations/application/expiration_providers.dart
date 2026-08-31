import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../domain/expiration_item.dart';
import '../domain/expiration_summary.dart';

final expirationSummaryProvider = Provider<ExpirationSummary>((ref) {
  final entitiesAsync = ref.watch(entityListProvider);
  final catalogAsync = ref.watch(catalogListProvider);
  final subspeciesAsync = ref.watch(subspeciesListProvider);
  final locationsAsync = ref.watch(locationNodeListProvider);

  final entities = entitiesAsync.asData?.value ?? [];
  final catalog = catalogAsync.asData?.value ?? [];
  final subspeciesList = subspeciesAsync.asData?.value ?? [];
  final locations = locationsAsync.asData?.value ?? [];

  if (entities.isEmpty) return const ExpirationSummary.empty();

  final catalogMap = {for (var c in catalog) c.id: c};
  final subspeciesMap = {for (var s in subspeciesList) s.id: s};
  final now = DateTime.now();

  return ExpirationSummary.fromEntities(
    entities: entities,
    catalogMap: catalogMap,
    subspeciesMap: subspeciesMap,
    locations: locations,
    now: now,
  );
});

final expirationSearchQueryProvider = StateProvider<String>((ref) => AppTechnicalStrings.empty);
final expirationUrgencyFilterProvider = StateProvider<ExpirationUrgency?>((ref) => null);
final expirationLocationFilterProvider = StateProvider<String?>((ref) => null);
final expirationCalendarSelectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final filteredExpirationsProvider = Provider<List<ExpirationItem>>((ref) {
  final summary = ref.watch(expirationSummaryProvider);
  final query = ref.watch(expirationSearchQueryProvider).trim().toLowerCase();
  final urgencyFilter = ref.watch(expirationUrgencyFilterProvider);
  final locationFilter = ref.watch(expirationLocationFilterProvider);

  var items = summary.allItems;

  if (urgencyFilter != null) {
    items = items.where((i) => i.urgency == urgencyFilter).toList();
  }

  if (locationFilter != null && locationFilter.isNotEmpty) {
    items = items.where((i) => i.entity.locationId == locationFilter).toList();
  }

  if (query.isNotEmpty) {
    items = items.where((i) {
      if (i.displayName.toLowerCase().contains(query)) return true;
      if (i.species?.name.toLowerCase().contains(query) ?? false) return true;
      if (i.subspecies?.brand?.toLowerCase().contains(query) ?? false) return true;
      if (i.entity.notes?.toLowerCase().contains(query) ?? false) return true;
      if (i.locationName?.toLowerCase().contains(query) ?? false) return true;
      return false;
    }).toList();
  }

  return items;
});
