import '../../../features/catalog/domain/catalog_item.dart';
import '../../../features/catalog/domain/subspecies.dart';
import '../../../features/entities/domain/world_entity.dart';
import '../../../features/locations/domain/location_node.dart';
import '../../../features/locations/domain/location_path_helper.dart';
import 'expiration_item.dart';

class ExpirationSummary {
  final List<ExpirationItem> allItems;
  final List<ExpirationItem> expiredItems;
  final List<ExpirationItem> criticalItems;
  final List<ExpirationItem> warningItems;
  final List<ExpirationItem> thisMonthItems;
  final List<ExpirationItem> futureItems;
  final Map<DateTime, List<ExpirationItem>> itemsByDate;

  const ExpirationSummary({
    required this.allItems,
    required this.expiredItems,
    required this.criticalItems,
    required this.warningItems,
    required this.thisMonthItems,
    required this.futureItems,
    required this.itemsByDate,
  });

  const ExpirationSummary.empty()
      : allItems = const [],
        expiredItems = const [],
        criticalItems = const [],
        warningItems = const [],
        thisMonthItems = const [],
        futureItems = const [],
        itemsByDate = const {};

  int get totalCount => allItems.length;
  int get expiredCount => expiredItems.length;
  int get criticalCount => criticalItems.length;
  int get warningCount => warningItems.length;
  int get expiringSoonCount => criticalItems.length + warningItems.length;
  bool get hasUrgentAlerts => expiredCount > 0 || expiringSoonCount > 0;

  List<ExpirationItem> get topUrgentItems {
    final list = <ExpirationItem>[];
    list.addAll(expiredItems);
    list.addAll(criticalItems);
    list.addAll(warningItems);
    list.addAll(thisMonthItems);
    list.addAll(futureItems);
    return list;
  }

  factory ExpirationSummary.fromEntities({
    required List<WorldEntity> entities,
    required Map<String, CatalogItem> catalogMap,
    required Map<String, Subspecies> subspeciesMap,
    required List<LocationNode> locations,
    required DateTime now,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final locationMap = {for (var loc in locations) loc.id: loc};

    final all = <ExpirationItem>[];
    final expired = <ExpirationItem>[];
    final critical = <ExpirationItem>[];
    final warning = <ExpirationItem>[];
    final thisMonth = <ExpirationItem>[];
    final future = <ExpirationItem>[];
    final byDate = <DateTime, List<ExpirationItem>>{};

    for (final entity in entities) {
      if (entity.expirationDate == null) continue;

      final species = catalogMap[entity.speciesId];
      final canExpire = species?.canExpire ?? false;
      if (!canExpire) continue;

      final subspecies = entity.subspeciesId != null ? subspeciesMap[entity.subspeciesId!] : null;
      final expDate = entity.expirationDate!;
      final expDay = DateTime(expDate.year, expDate.month, expDate.day);
      final diffDays = expDay.difference(today).inDays;
      final warningDays = species?.warningDaysBeforeExpiration ?? 7;

      final urgency = ExpirationItem.calculateUrgency(
        expirationDate: expDate,
        now: now,
        warningDays: warningDays,
      );

      final ratio = ExpirationItem.calculateShelfLifeRatio(
        createdAt: entity.createdAt,
        expirationDate: expDate,
        now: now,
      );

      String? locName;
      String? locBreadcrumb;
      if (entity.locationId != null) {
        final node = locationMap[entity.locationId];
        locName = node?.name;
        locBreadcrumb = LocationPathHelper.buildBreadcrumbPath(entity.locationId, locations).fullPath;
      }

      final item = ExpirationItem(
        entity: entity,
        species: species,
        subspecies: subspecies,
        locationName: locName,
        locationBreadcrumb: locBreadcrumb,
        expirationDate: expDate,
        daysUntilExpiration: diffDays,
        urgency: urgency,
        shelfLifeElapsedRatio: ratio,
        totalShelfLifeDays: expDate.difference(entity.createdAt).inDays,
        daysElapsedSinceCreation: now.difference(entity.createdAt).inDays,
      );

      all.add(item);
      byDate.putIfAbsent(expDay, () => []).add(item);

      switch (urgency) {
        case ExpirationUrgency.expired:
          expired.add(item);
          break;
        case ExpirationUrgency.critical:
          critical.add(item);
          break;
        case ExpirationUrgency.warning:
          warning.add(item);
          break;
        case ExpirationUrgency.upcoming:
          thisMonth.add(item);
          break;
        case ExpirationUrgency.safe:
          future.add(item);
          break;
      }
    }

    // Sort each group by expiration date ascending
    int compareExp(ExpirationItem a, ExpirationItem b) => a.expirationDate.compareTo(b.expirationDate);

    all.sort(compareExp);
    expired.sort((a, b) => b.expirationDate.compareTo(a.expirationDate)); // most recently expired first
    critical.sort(compareExp);
    warning.sort(compareExp);
    thisMonth.sort(compareExp);
    future.sort(compareExp);

    return ExpirationSummary(
      allItems: all,
      expiredItems: expired,
      criticalItems: critical,
      warningItems: warning,
      thisMonthItems: thisMonth,
      futureItems: future,
      itemsByDate: byDate,
    );
  }
}
