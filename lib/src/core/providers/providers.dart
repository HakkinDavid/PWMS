import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../storage/file_storage_service.dart';
import '../../features/entities/domain/i_entity_repository.dart';
import '../../features/entities/infrastructure/entity_repository.dart';
import '../../features/entities/domain/world_entity.dart';
import '../../features/entities/domain/attachment.dart';
import '../../features/places/domain/i_place_repository.dart';
import '../../features/places/infrastructure/place_repository.dart';
import '../../features/relations/domain/i_relation_repository.dart';
import '../../features/relations/infrastructure/relation_repository.dart';
import '../../features/relations/domain/entity_relation.dart';
import '../../features/history/domain/i_history_repository.dart';
import '../../features/history/infrastructure/history_repository.dart';
import '../../features/history/domain/activity_event.dart';
import '../../features/history/application/activity_logger_service.dart';

// Singletons / Core Services
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final fileStorageServiceProvider = Provider<FileStorageService>((ref) {
  return FileStorageService();
});

// Repositories
final entityRepositoryProvider = Provider<IEntityRepository>((ref) {
  return EntityRepository(ref.watch(databaseProvider));
});

final placeRepositoryProvider = Provider<IPlaceRepository>((ref) {
  return PlaceRepository(ref.watch(databaseProvider));
});

final relationRepositoryProvider = Provider<IRelationRepository>((ref) {
  return RelationRepository(ref.watch(databaseProvider));
});

final historyRepositoryProvider = Provider<IHistoryRepository>((ref) {
  return HistoryRepository(ref.watch(databaseProvider));
});

final activityLoggerServiceProvider = Provider<ActivityLoggerService>((ref) {
  return ActivityLoggerService(ref.watch(historyRepositoryProvider));
});

// State Notifiers & Async Providers

// All Entities State
class EntityListNotifier extends StateNotifier<AsyncValue<List<WorldEntity>>> {
  final IEntityRepository _repository;

  EntityListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadEntities();
  }

  Future<void> loadEntities() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getAllEntities();
      state = AsyncValue.data(list);
    } catch (e, st) {
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

// Unified Places Provider derived directly from EntityListProvider (Single Source of Truth)
final placeListProvider = Provider<AsyncValue<List<WorldEntity>>>((ref) {
  final entitiesState = ref.watch(entityListProvider);
  return entitiesState.whenData((entities) {
    return entities.where((e) => e.isPlace || e.type.toLowerCase() == 'lugar').toList();
  });
});

// Recent Entities Provider
final recentEntitiesProvider = FutureProvider<List<WorldEntity>>((ref) async {
  ref.watch(entityListProvider); // Auto refresh when entity list changes
  final repo = ref.watch(entityRepositoryProvider);
  return repo.getRecentEntities(limit: 10);
});

// Recent Activity Provider
final recentActivityProvider = FutureProvider<List<ActivityEvent>>((ref) async {
  ref.watch(entityListProvider); // Auto refresh when entities change
  final repo = ref.watch(historyRepositoryProvider);
  return repo.getRecentEvents(limit: 15);
});

// Search Query State
final searchQueryProvider = StateProvider<String>((ref) => '');

// Real-time Filtered Search Provider
final searchResultsProvider = FutureProvider<List<WorldEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final repo = ref.watch(entityRepositoryProvider);
  ref.watch(entityListProvider); // Auto refresh on edits
  return repo.searchEntities(query);
});

// Entity Detail Provider
final entityDetailProvider = FutureProvider.family<WorldEntity?, String>((ref, id) async {
  ref.watch(entityListProvider);
  final repo = ref.watch(entityRepositoryProvider);
  return repo.getEntityById(id);
});

// Entity Attachments Provider
final entityAttachmentsProvider = FutureProvider.family<List<Attachment>, String>((ref, entityId) async {
  final repo = ref.watch(entityRepositoryProvider);
  return repo.getAttachments(entityId);
});

// Entity Relations Provider
final entityRelationsProvider = FutureProvider.family<List<EntityRelation>, String>((ref, entityId) async {
  final repo = ref.watch(relationRepositoryProvider);
  return repo.getRelationsForEntity(entityId);
});
