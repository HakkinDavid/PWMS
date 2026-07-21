import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// Tables

class EntitiesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get alias => text().nullable()();
  TextColumn get type => text()(); // Real-world perceived concept
  TextColumn get mainPhotoPath => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get placeId => text().nullable().references(PlacesTable, #id)();
  TextColumn get tags => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class PlacesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get parentPlaceId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class RelationsTable extends Table {
  TextColumn get id => text()();
  @ReferenceName('sourceRelations')
  TextColumn get sourceEntityId => text().references(EntitiesTable, #id)();
  @ReferenceName('targetRelations')
  TextColumn get targetEntityId => text().references(EntitiesTable, #id)();
  TextColumn get relationType => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AttachmentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get entityId => text().references(EntitiesTable, #id)();
  TextColumn get filePath => text()();
  TextColumn get fileName => text()();
  TextColumn get fileType => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class HistoryEventsTable extends Table {
  TextColumn get id => text()();
  TextColumn get entityId => text().nullable()();
  TextColumn get eventType => text()(); // creation, edition, movement, attachment, relation
  TextColumn get description => text()();
  TextColumn get metadata => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  EntitiesTable,
  PlacesTable,
  RelationsTable,
  AttachmentsTable,
  HistoryEventsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'pwms_database');
  }
}
