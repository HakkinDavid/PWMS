import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/i_place_repository.dart';
import '../domain/place.dart';

class PlaceRepository implements IPlaceRepository {
  final AppDatabase _db;

  PlaceRepository(this._db);

  Place _mapToDomain(PlacesTableData row) {
    return Place(
      id: row.id,
      name: row.name,
      description: row.description,
      icon: row.icon,
      parentPlaceId: row.parentPlaceId,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<List<Place>> getAllPlaces() async {
    final query = _db.select(_db.placesTable)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final rows = await query.get();
    return rows.map(_mapToDomain).toList();
  }

  @override
  Future<Place?> getPlaceById(String id) async {
    final query = _db.select(_db.placesTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToDomain(row) : null;
  }

  @override
  Future<void> savePlace(Place place) async {
    final companion = PlacesTableCompanion(
      id: Value(place.id),
      name: Value(place.name),
      description: Value(place.description),
      icon: Value(place.icon),
      parentPlaceId: Value(place.parentPlaceId),
      createdAt: Value(place.createdAt),
    );
    await _db.into(_db.placesTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> deletePlace(String id) async {
    await (_db.delete(_db.placesTable)..where((t) => t.id.equals(id))).go();
  }
}
