import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// Tables

class LocationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentLocationId => text().nullable().references(LocationsTable, #id)(); // Graph containment
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CatalogTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('Objeto / Herramienta'))();
  TextColumn get brand => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get mainPhotoPath => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get customAttributes => text().withDefault(const Constant('{}'))(); // JSON key-value map
  TextColumn get defaultUnit => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class EntitiesTable extends Table {
  TextColumn get id => text()();
  TextColumn get speciesId => text().references(CatalogTable, #id)(); // Universe Catalog Species link
  TextColumn get locationId => text().nullable().references(LocationsTable, #id)(); // Location Graph Node
  RealColumn get quantity => real().nullable()(); // Countable / Measurable
  TextColumn get unit => text().nullable()(); // Unit of measurement
  TextColumn get notes => text().nullable()(); // Instance custom note / serial number
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

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
  TextColumn get eventType => text()(); // creation, edition, movement, attachment, relation, deletion, photo, consumption
  TextColumn get description => text()();
  TextColumn get metadata => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CustomTemplatesTable extends Table {
  TextColumn get id => text()();
  TextColumn get typeName => text()();
  TextColumn get iconName => text()();
  TextColumn get commonUnits => text().withDefault(const Constant('[]'))(); // JSON array
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  LocationsTable,
  CatalogTable,
  EntitiesTable,
  RelationsTable,
  AttachmentsTable,
  HistoryEventsTable,
  CustomTemplatesTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'pwms_database');
  }
}
