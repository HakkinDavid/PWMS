import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_technical_strings.dart';
import '../database/app_database.dart';
import '../database/database_backup_service.dart';
import '../storage/file_storage_service.dart';
import '../../features/entities/domain/i_entity_repository.dart';
import '../../features/entities/infrastructure/entity_repository.dart';
import '../../features/entities/domain/world_entity.dart';
import '../../features/entities/domain/attachment.dart';
import '../../features/locations/domain/location_node.dart';
import '../../features/locations/infrastructure/location_repository.dart';
import '../../features/relations/domain/i_relation_repository.dart';
import '../../features/relations/infrastructure/relation_repository.dart';
import '../../features/relations/domain/entity_relation.dart';
import '../../features/history/domain/i_history_repository.dart';
import '../../features/history/infrastructure/history_repository.dart';
import '../../features/history/domain/activity_event.dart';
import '../../features/history/application/activity_logger_service.dart';

import '../../features/catalog/domain/catalog_item.dart';
import '../../features/catalog/domain/species_requirement.dart';
import '../../features/catalog/domain/subspecies.dart';
import '../../features/catalog/infrastructure/catalog_repository.dart';
import '../../features/catalog/infrastructure/product_lookup_service.dart';

import '../../features/notifications/domain/app_notification.dart';
import '../../features/notifications/infrastructure/notification_repository.dart';
import '../../features/notifications/application/notification_service.dart';

import '../updater/infrastructure/app_update_service.dart';

// Singletons / Core Services
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final fileStorageServiceProvider = Provider<FileStorageService>((ref) {
  return FileStorageService();
});

final databaseBackupServiceProvider = Provider<DatabaseBackupService>((ref) {
  return DatabaseBackupService(ref.watch(databaseProvider));
});

final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService();
});

final currentAppVersionProvider = FutureProvider<String>((ref) async {
  final service = ref.watch(appUpdateServiceProvider);
  return service.getCurrentAppVersion();
});

// History and Audit Services
final historyRepositoryProvider = Provider<IHistoryRepository>((ref) {
  return HistoryRepository(ref.watch(databaseProvider));
});

final activityLoggerServiceProvider = Provider<ActivityLoggerService>((ref) {
  return ActivityLoggerService(ref.watch(historyRepositoryProvider));
});

// Repositories
final entityRepositoryProvider = Provider<IEntityRepository>((ref) {
  return EntityRepository(
    ref.watch(databaseProvider),
    ref.watch(fileStorageServiceProvider),
    ref.watch(activityLoggerServiceProvider),
  );
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(
    ref.watch(databaseProvider),
    ref.watch(fileStorageServiceProvider),
    ref.watch(activityLoggerServiceProvider),
  );
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository(
    ref.watch(databaseProvider),
    ref.watch(activityLoggerServiceProvider),
  );
});

final relationRepositoryProvider = Provider<IRelationRepository>((ref) {
  return RelationRepository(
    ref.watch(databaseProvider),
    ref.watch(activityLoggerServiceProvider),
  );
});

// Location Graph State
class LocationNodeListNotifier extends StateNotifier<AsyncValue<List<LocationNode>>> {
  final LocationRepository _repository;

  LocationNodeListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadNodes();
  }

  Future<void> loadNodes() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getAllNodes();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveNode(LocationNode node) async {
    await _repository.saveNode(node);
    await loadNodes();
  }

  Future<void> deleteNode(String id) async {
    await _repository.deleteNode(id);
    await loadNodes();
  }
}

final locationNodeListProvider = StateNotifierProvider<LocationNodeListNotifier, AsyncValue<List<LocationNode>>>((ref) {
  return LocationNodeListNotifier(ref.watch(locationRepositoryProvider));
});

final placeListProvider = Provider<AsyncValue<List<LocationNode>>>((ref) {
  return ref.watch(locationNodeListProvider);
});

// All Entities State
class EntityListNotifier extends StateNotifier<AsyncValue<List<WorldEntity>>> {
  final IEntityRepository _repository;

  EntityListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadEntities();
  }

  Future<void> loadEntities() async {
    if (!mounted) return;
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getAllEntities();
      if (!mounted) return;
      state = AsyncValue.data(list);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveEntity(WorldEntity entity) async {
    await _repository.saveEntity(entity);
    await loadEntities();
  }

  Future<void> deleteEntity(String id) async {
    await _repository.deleteEntity(id);
    await loadEntities();
  }
}

final entityListProvider = StateNotifierProvider<EntityListNotifier, AsyncValue<List<WorldEntity>>>((ref) {
  return EntityListNotifier(ref.watch(entityRepositoryProvider));
});

// Universe Catalog State
class CatalogListNotifier extends StateNotifier<AsyncValue<List<CatalogItem>>> {
  final CatalogRepository _repository;

  CatalogListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadCatalog();
  }

  Future<void> loadCatalog() async {
    if (!mounted) return;
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getAllCatalogItems();
      if (!mounted) return;
      state = AsyncValue.data(list);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveCatalogItem(CatalogItem item) async {
    await _repository.saveCatalogItem(item);
    await loadCatalog();
  }

  Future<void> deleteCatalogItem(String id) async {
    await _repository.deleteCatalogItem(id);
    await loadCatalog();
  }
}

final catalogListProvider = StateNotifierProvider<CatalogListNotifier, AsyncValue<List<CatalogItem>>>((ref) {
  return CatalogListNotifier(ref.watch(catalogRepositoryProvider));
});

// All Subspecies Provider
final subspeciesListProvider = FutureProvider<List<Subspecies>>((ref) async {
  ref.watch(catalogListProvider);
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getAllSubspecies();
});

// Recent Entities Provider
final recentEntitiesProvider = FutureProvider<List<WorldEntity>>((ref) async {
  ref.watch(entityListProvider);
  final repo = ref.watch(entityRepositoryProvider);
  return repo.getRecentEntities(limit: 10);
});

// Recent Activity Provider
final recentActivityProvider = FutureProvider<List<ActivityEvent>>((ref) async {
  ref.watch(entityListProvider);
  ref.watch(catalogListProvider);
  ref.watch(locationNodeListProvider);
  final repo = ref.watch(historyRepositoryProvider);
  return repo.getRecentEvents(limit: 15);
});

// Full History Reactive Stream & Filters
final historySearchQueryProvider = StateProvider<String>((ref) => AppTechnicalStrings.empty);
final historySelectedCategoryProvider = StateProvider<String>((ref) => AppTechnicalStrings.categoryAll);

final allHistoryEventsStreamProvider = StreamProvider<List<ActivityEvent>>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return repo.watchAllEvents();
});

final filteredHistoryEventsProvider = Provider<AsyncValue<List<ActivityEvent>>>((ref) {
  final allEventsAsync = ref.watch(allHistoryEventsStreamProvider);
  final category = ref.watch(historySelectedCategoryProvider);
  final query = ref.watch(historySearchQueryProvider);

  return allEventsAsync.whenData((events) {
    var filtered = events;
    if (category.isNotEmpty && category != AppTechnicalStrings.categoryAll) {
      filtered = filtered.where((e) => e.category == category).toList();
    }
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

// Search Query State
final searchQueryProvider = StateProvider<String>((ref) => AppTechnicalStrings.empty);

// Real-time Filtered Search Provider
final searchResultsProvider = FutureProvider<List<WorldEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final repo = ref.watch(entityRepositoryProvider);
  ref.watch(entityListProvider);
  return repo.searchEntities(query);
});

// Entity Detail Provider
final entityDetailProvider = FutureProvider.family<WorldEntity?, String>((ref, id) async {
  ref.watch(entityListProvider);
  final repo = ref.watch(entityRepositoryProvider);
  return repo.getEntityById(id);
});

// Species Attachments Provider
final speciesAttachmentsProvider = FutureProvider.family<List<Attachment>, String>((ref, speciesId) async {
  final repo = ref.watch(entityRepositoryProvider);
  return repo.getAttachmentsForSpecies(speciesId);
});

// Instance Attachments Provider
final instanceAttachmentsProvider = FutureProvider.family<List<Attachment>, String>((ref, instanceId) async {
  final repo = ref.watch(entityRepositoryProvider);
  return repo.getAttachmentsForInstance(instanceId);
});

// Entity Relations Provider
final entityRelationsProvider = FutureProvider.family<List<EntityRelation>, String>((ref, entityId) async {
  final repo = ref.watch(relationRepositoryProvider);
  return repo.getRelationsForEntity(entityId);
});

// Source Requirements Provider
final sourceRequirementsProvider = FutureProvider.family<List<SpeciesRequirement>, String>((ref, sourceId) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getRequirementsForSource(sourceId);
});

// All Relations State Provider
class RelationListNotifier extends StateNotifier<AsyncValue<List<EntityRelation>>> {
  final IRelationRepository _repository;

  RelationListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRelations();
  }

  Future<void> loadRelations() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getAllRelations();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addRelation(EntityRelation relation) async {
    await _repository.addRelation(relation);
    await loadRelations();
  }

  Future<void> deleteRelation(String relationId) async {
    await _repository.deleteRelation(relationId);
    await loadRelations();
  }
}

final relationListProvider = StateNotifierProvider<RelationListNotifier, AsyncValue<List<EntityRelation>>>((ref) {
  return RelationListNotifier(ref.watch(relationRepositoryProvider));
});

// Auto-fill Product Lookup Provider
final productLookupServiceProvider = Provider<ProductLookupService>((ref) {
  return ProductLookupService();
});

// Notification Feature Providers
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(databaseProvider));
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    db: ref.watch(databaseProvider),
    entityRepo: ref.watch(entityRepositoryProvider) as EntityRepository,
    catalogRepo: ref.watch(catalogRepositoryProvider),
    notificationRepo: ref.watch(notificationRepositoryProvider),
  );
});

class NotificationListNotifier extends StateNotifier<AsyncValue<List<AppNotification>>> {
  final NotificationRepository _repo;
  final NotificationService _service;

  NotificationListNotifier(this._repo, this._service) : super(const AsyncValue.loading()) {
    evaluateAndLoad();
  }

  Future<void> evaluateAndLoad() async {
    state = const AsyncValue.loading();
    try {
      await _service.evaluateAllNotifications();
      final active = await _repo.getActiveNotifications();
      state = AsyncValue.data(active);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> snoozeNotification(String id, Duration duration) async {
    await _repo.snoozeNotification(id, duration);
    await evaluateAndLoad();
  }

  Future<void> dismissNotification(String id) async {
    await _repo.dismissNotification(id);
    await evaluateAndLoad();
  }
}

final notificationListProvider = StateNotifierProvider<NotificationListNotifier, AsyncValue<List<AppNotification>>>((ref) {
  return NotificationListNotifier(
    ref.watch(notificationRepositoryProvider),
    ref.watch(notificationServiceProvider),
  );
});

/// Refresca todos los proveedores de la aplicación tras importar un respaldo
void refreshAllAppProviders(WidgetRef ref) {
  ref.read(catalogListProvider.notifier).loadCatalog();
  ref.read(entityListProvider.notifier).loadEntities();
  ref.read(locationNodeListProvider.notifier).loadNodes();
  ref.read(relationListProvider.notifier).loadRelations();
  ref.read(notificationListProvider.notifier).evaluateAndLoad();
}
