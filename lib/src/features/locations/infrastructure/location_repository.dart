import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/location_node.dart';

class LocationRepository {
  final AppDatabase _db;

  LocationRepository(this._db);

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
    final companion = LocationsTableCompanion(
      id: Value(node.id),
      name: Value(node.name),
      parentLocationId: Value(node.parentLocationId),
      description: Value(node.description),
      icon: Value(node.icon),
      createdAt: Value(node.createdAt),
    );
    await _db.into(_db.locationsTable).insertOnConflictUpdate(companion);
  }

  Future<void> deleteNode(String id) async {
    await (_db.delete(_db.locationsTable)..where((t) => t.id.equals(id))).go();
  }
}
