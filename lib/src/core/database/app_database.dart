import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// 4NF Normalized Relational Tables

class LocationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentLocationId => text().nullable().references(LocationsTable, #id)();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CatalogTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('Objeto'))();
  TextColumn get description => text().nullable()();
  TextColumn get mainPhotoPath => text().nullable()();
  TextColumn get customAttributes => text().withDefault(const Constant('{}'))();
  BoolColumn get isUnique => boolean().withDefault(const Constant(false))();
  BoolColumn get isNonPerishable => boolean().withDefault(const Constant(true))();
  IntColumn get defaultShelfLifeDays => integer().nullable()();
  IntColumn get warningDaysBeforeExpiration => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4NF Table: Subspecies & Product Variants (1:N under Species)
class SubspeciesTable extends Table {
  TextColumn get id => text()();
  TextColumn get speciesId => text().references(CatalogTable, #id)();
  TextColumn get subspeciesName => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4NF Table: Species Magnitudes & Physical Properties (1:N)
class SpeciesMagnitudesTable extends Table {
  TextColumn get id => text()();
  TextColumn get speciesId => text().references(CatalogTable, #id)();
  TextColumn get propertyName => text()(); // e.g. "Masa", "Volumen", "Material"
  TextColumn get dataType => text().withDefault(const Constant('real'))(); // 'real', 'integer', 'string', 'boolean'
  TextColumn get unitSymbol => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class EntitiesTable extends Table {
  TextColumn get id => text()();
  TextColumn get speciesId => text().references(CatalogTable, #id)();
  TextColumn get subspeciesId => text().nullable().references(SubspeciesTable, #id)();
  TextColumn get locationId => text().nullable().references(LocationsTable, #id)();
  DateTimeColumn get expirationDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4NF Table: Instance Magnitudes & Physical Properties (1:N)
class InstanceMagnitudesTable extends Table {
  TextColumn get id => text()();
  TextColumn get instanceId => text().references(EntitiesTable, #id)();
  TextColumn get propertyName => text()(); // e.g. "Masa", "Volumen", "Material"
  TextColumn get dataType => text().withDefault(const Constant('real'))(); // 'real', 'integer', 'string', 'boolean'
  RealColumn get magnitudeValue => real().withDefault(const Constant(0.0))();
  TextColumn get stringValue => text().nullable()();
  TextColumn get unitSymbol => text().nullable()();

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
  TextColumn get speciesId => text().references(CatalogTable, #id)();
  TextColumn get instanceId => text().nullable().references(EntitiesTable, #id)();
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
  TextColumn get eventType => text()();
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
  TextColumn get commonUnits => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4NF Table: Instance Direct Physical Locations (1:0..1)
class InstanceLocationsTable extends Table {
  TextColumn get instanceId => text().references(EntitiesTable, #id)();
  TextColumn get locationId => text().references(LocationsTable, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {instanceId};
}

// 4NF Table: Species & Entity Requirements (NECESITA)
class SpeciesRequirementsTable extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text()(); // speciesId or entityId
  TextColumn get sourceType => text().withDefault(const Constant('species'))(); // 'species' or 'entity'
  TextColumn get requiredSpeciesId => text().references(CatalogTable, #id)();
  RealColumn get requiredQuantity => real().withDefault(const Constant(1.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class NotificationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()(); // 'expired', 'expiring_soon', 'unsatisfied_need'
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get targetId => text()();
  TextColumn get targetType => text()(); // 'entity', 'species'
  TextColumn get status => text().withDefault(const Constant('active'))(); // 'active', 'snoozed', 'dismissed'
  DateTimeColumn get snoozedUntil => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettingsTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  LocationsTable,
  CatalogTable,
  SubspeciesTable,
  SpeciesMagnitudesTable,
  EntitiesTable,
  InstanceMagnitudesTable,
  InstanceLocationsTable,
  RelationsTable,
  AttachmentsTable,
  HistoryEventsTable,
  CustomTemplatesTable,
  SpeciesRequirementsTable,
  NotificationsTable,
  AppSettingsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(appSettingsTable);
          }
          if (from < 3) {
            await m.addColumn(attachmentsTable, attachmentsTable.instanceId);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'pwms_database');
  }

  // App Settings Helper Methods
  Future<String?> getSetting(String key) async {
    final query = select(appSettingsTable)..where((tbl) => tbl.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(appSettingsTable).insertOnConflictUpdate(
      AppSettingsTableCompanion.insert(key: key, value: value),
    );
  }
}
