import 'package:drift/drift.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import '../../../core/database/app_database.dart';
import '../../entities/domain/world_entity.dart';
import '../../history/application/activity_logger_service.dart';
import '../../history/infrastructure/history_repository.dart';
import '../domain/location_node.dart';

class LocationRepository {
  final AppDatabase _db;
  final ActivityLoggerService _activityLogger;

  LocationRepository(this._db, [ActivityLoggerService? activityLogger])
      : _activityLogger = activityLogger ?? ActivityLoggerService(HistoryRepository(_db));

  LocationNode _mapToDomain(LocationsTableData row) {
    return LocationNode(
      id: row.id,
      name: row.name,
      parentLocationId: row.parentLocationId,
      description: row.description,
      icon: row.icon,
      createdAt: row.createdAt,
    );
  }

  Future<List<LocationNode>> getAllNodes() async {
    final query = _db.select(_db.locationsTable)..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  Future<LocationNode?> getNodeById(String id) async {
    final query = _db.select(_db.locationsTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToDomain(row) : null;
  }

  Future<List<LocationNode>> getSubNodes(String? parentId) async {
    final query = _db.select(_db.locationsTable);
    if (parentId == null) {
      query.where((t) => t.parentLocationId.isNull());
    } else {
      query.where((t) => t.parentLocationId.equals(parentId));
    }
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  Future<void> saveNode(LocationNode node) async {
    final existing = await getNodeById(node.id);
    final companion = LocationsTableCompanion(
      id: Value(node.id),
      name: Value(node.name),
      parentLocationId: Value(node.parentLocationId),
      description: Value(node.description),
      icon: Value(node.icon),
      createdAt: Value(node.createdAt),
    );
    await _db.into(_db.locationsTable).insertOnConflictUpdate(companion);

    if (existing == null) {
      await _activityLogger.logLocationCreated(node.id, node.name);
    } else if (existing.name != node.name) {
      await _activityLogger.logLocationEdited(node.id, node.name);
    }
  }

  // Cycle Prevention Rules
  Set<String> getDescendantIds(String nodeId, List<LocationNode> allNodes) {
    final Set<String> descendants = {};
    void findChildren(String pId) {
      final children = allNodes.where((n) => n.parentLocationId == pId);
      for (final child in children) {
        descendants.add(child.id);
        findChildren(child.id);
      }
    }
    findChildren(nodeId);
    return descendants;
  }

  bool canMoveNode(String nodeId, String? targetParentId, List<LocationNode> allNodes) {
    if (targetParentId == null) return true;
    if (nodeId == targetParentId) return false;
    final descendants = getDescendantIds(nodeId, allNodes);
    return !descendants.contains(targetParentId);
  }

  Future<void> moveNode(String nodeId, String? newParentLocationId) async {
    final allNodes = await getAllNodes();
    if (!canMoveNode(nodeId, newParentLocationId, allNodes)) {
      throw Exception(AppStrings.circularLocationError);
    }

    final node = await getNodeById(nodeId);
    if (node == null) return;

    final updated = node.copyWith(parentLocationId: newParentLocationId);
    await saveNode(updated);

    String? parentName;
    if (newParentLocationId != null) {
      final pNode = await getNodeById(newParentLocationId);
      parentName = pNode?.name;
    }
    await _activityLogger.logLocationMoved(nodeId, node.name, parentName);
  }

  Future<void> deleteNode(String id) async {
    final node = await getNodeById(id);
    await (_db.delete(_db.locationsTable)..where((t) => t.id.equals(id))).go();
    if (node != null) {
      await _activityLogger.logLocationDeleted(id, node.name);
    }
  }

  // Global Recursive Count Engine
  static int getRecursiveItemCount(String nodeId, List<LocationNode> allNodes, List<WorldEntity> allEntities) {
    int selfCount = allEntities.where((e) => e.locationId == nodeId).length;
    final children = allNodes.where((n) => n.parentLocationId == nodeId);
    for (final child in children) {
      selfCount += getRecursiveItemCount(child.id, allNodes, allEntities);
    }
    return selfCount;
  }
}
