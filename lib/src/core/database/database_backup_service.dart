import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'app_database.dart';

class DatabaseBackupService {
  final AppDatabase _db;

  DatabaseBackupService(this._db);

  /// Genera un JSON serializado con todos los registros de las 13 tablas de la base de datos
  Future<Map<String, dynamic>> exportDatabaseToJsonMap() async {
    final locations = await _db.select(_db.locationsTable).get();
    final catalog = await _db.select(_db.catalogTable).get();
    final subspecies = await _db.select(_db.subspeciesTable).get();
    final speciesMagnitudes = await _db.select(_db.speciesMagnitudesTable).get();
    final entities = await _db.select(_db.entitiesTable).get();
    final instanceMagnitudes = await _db.select(_db.instanceMagnitudesTable).get();
    final instanceLocations = await _db.select(_db.instanceLocationsTable).get();
    final relations = await _db.select(_db.relationsTable).get();
    final attachments = await _db.select(_db.attachmentsTable).get();
    final historyEvents = await _db.select(_db.historyEventsTable).get();
    final customTemplates = await _db.select(_db.customTemplatesTable).get();
    final speciesRequirements = await _db.select(_db.speciesRequirementsTable).get();
    final notifications = await _db.select(_db.notificationsTable).get();

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'tables': {
        'locations': locations.map((r) => {
          'id': r.id,
          'name': r.name,
          'parentLocationId': r.parentLocationId,
          'description': r.description,
          'icon': r.icon,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'catalog': catalog.map((r) => {
          'id': r.id,
          'name': r.name,
          'type': r.type,
          'description': r.description,
          'mainPhotoPath': r.mainPhotoPath,
          'customAttributes': r.customAttributes,
          'isUnique': r.isUnique,
          'isNonPerishable': r.isNonPerishable,
          'defaultShelfLifeDays': r.defaultShelfLifeDays,
          'warningDaysBeforeExpiration': r.warningDaysBeforeExpiration,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'subspecies': subspecies.map((r) => {
          'id': r.id,
          'speciesId': r.speciesId,
          'subspeciesName': r.subspeciesName,
          'brand': r.brand,
          'barcode': r.barcode,
          'photoPath': r.photoPath,
          'notes': r.notes,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'speciesMagnitudes': speciesMagnitudes.map((r) => {
          'id': r.id,
          'speciesId': r.speciesId,
          'propertyName': r.propertyName,
          'unitSymbol': r.unitSymbol,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'entities': entities.map((r) => {
          'id': r.id,
          'speciesId': r.speciesId,
          'subspeciesId': r.subspeciesId,
          'locationId': r.locationId,
          'expirationDate': r.expirationDate?.toIso8601String(),
          'notes': r.notes,
          'createdAt': r.createdAt.toIso8601String(),
          'updatedAt': r.updatedAt.toIso8601String(),
        }).toList(),
        'instanceMagnitudes': instanceMagnitudes.map((r) => {
          'id': r.id,
          'instanceId': r.instanceId,
          'propertyName': r.propertyName,
          'magnitudeValue': r.magnitudeValue,
          'unitSymbol': r.unitSymbol,
        }).toList(),
        'instanceLocations': instanceLocations.map((r) => {
          'instanceId': r.instanceId,
          'locationId': r.locationId,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'relations': relations.map((r) => {
          'id': r.id,
          'sourceEntityId': r.sourceEntityId,
          'targetEntityId': r.targetEntityId,
          'relationType': r.relationType,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'attachments': attachments.map((r) => {
          'id': r.id,
          'speciesId': r.speciesId,
          'filePath': r.filePath,
          'fileName': r.fileName,
          'fileType': r.fileType,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'historyEvents': historyEvents.map((r) => {
          'id': r.id,
          'entityId': r.entityId,
          'eventType': r.eventType,
          'description': r.description,
          'metadata': r.metadata,
          'timestamp': r.timestamp.toIso8601String(),
        }).toList(),
        'customTemplates': customTemplates.map((r) => {
          'id': r.id,
          'typeName': r.typeName,
          'iconName': r.iconName,
          'commonUnits': r.commonUnits,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'speciesRequirements': speciesRequirements.map((r) => {
          'id': r.id,
          'sourceId': r.sourceId,
          'sourceType': r.sourceType,
          'requiredSpeciesId': r.requiredSpeciesId,
          'requiredQuantity': r.requiredQuantity,
          'notes': r.notes,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'notifications': notifications.map((r) => {
          'id': r.id,
          'type': r.type,
          'title': r.title,
          'message': r.message,
          'targetId': r.targetId,
          'targetType': r.targetType,
          'status': r.status,
          'snoozedUntil': r.snoozedUntil?.toIso8601String(),
          'createdAt': r.createdAt.toIso8601String(),
          'updatedAt': r.updatedAt.toIso8601String(),
        }).toList(),
      },
    };
  }

  /// Exporta el respaldo a un archivo JSON local
  Future<File> exportBackupToFile() async {
    final data = await exportDatabaseToJsonMap();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
    
    final appDir = await getApplicationDocumentsDirectory();
    final backupsDir = Directory('${appDir.path}/backups');
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
    final file = File('${backupsDir.path}/pwms_backup_$timestamp.json');
    await file.writeAsString(jsonStr);
    return file;
  }

  /// Importa la base de datos a partir de una cadena JSON
  Future<void> importDatabaseFromJsonString(String jsonString) async {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    if (!data.containsKey('tables')) {
      throw const FormatException('El archivo de respaldo no tiene una estructura válida.');
    }

    final tables = data['tables'] as Map<String, dynamic>;

    await _db.transaction(() async {
      // Limpiar datos existentes en orden inverso de clave foránea
      await _db.delete(_db.notificationsTable).go();
      await _db.delete(_db.speciesRequirementsTable).go();
      await _db.delete(_db.customTemplatesTable).go();
      await _db.delete(_db.historyEventsTable).go();
      await _db.delete(_db.attachmentsTable).go();
      await _db.delete(_db.relationsTable).go();
      await _db.delete(_db.instanceLocationsTable).go();
      await _db.delete(_db.instanceMagnitudesTable).go();
      await _db.delete(_db.entitiesTable).go();
      await _db.delete(_db.speciesMagnitudesTable).go();
      await _db.delete(_db.subspeciesTable).go();
      await _db.delete(_db.catalogTable).go();
      await _db.delete(_db.locationsTable).go();

      // Restaurar Ubicaciones
      final locs = (tables['locations'] as List? ?? []);
      for (final r in locs) {
        await _db.into(_db.locationsTable).insert(LocationsTableCompanion.insert(
          id: r['id'],
          name: r['name'],
          parentLocationId: Value(r['parentLocationId']),
          description: Value(r['description']),
          icon: Value(r['icon']),
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Catálogo
      final cat = (tables['catalog'] as List? ?? []);
      for (final r in cat) {
        await _db.into(_db.catalogTable).insert(CatalogTableCompanion.insert(
          id: r['id'],
          name: r['name'],
          type: Value(r['type'] ?? 'Objeto'),
          description: Value(r['description']),
          mainPhotoPath: Value(r['mainPhotoPath']),
          customAttributes: Value(r['customAttributes'] ?? '{}'),
          isUnique: Value(r['isUnique'] ?? false),
          isNonPerishable: Value(r['isNonPerishable'] ?? true),
          defaultShelfLifeDays: Value(r['defaultShelfLifeDays']),
          warningDaysBeforeExpiration: Value(r['warningDaysBeforeExpiration']),
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Subespecies
      final sub = (tables['subspecies'] as List? ?? []);
      for (final r in sub) {
        await _db.into(_db.subspeciesTable).insert(SubspeciesTableCompanion.insert(
          id: r['id'],
          speciesId: r['speciesId'],
          subspeciesName: r['subspeciesName'],
          brand: Value(r['brand']),
          barcode: Value(r['barcode']),
          photoPath: Value(r['photoPath']),
          notes: Value(r['notes']),
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Magnitudes de Especie
      final sm = (tables['speciesMagnitudes'] as List? ?? []);
      for (final r in sm) {
        await _db.into(_db.speciesMagnitudesTable).insert(SpeciesMagnitudesTableCompanion.insert(
          id: r['id'],
          speciesId: r['speciesId'],
          propertyName: r['propertyName'],
          unitSymbol: r['unitSymbol'],
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Instancias / Entidades
      final ent = (tables['entities'] as List? ?? []);
      for (final r in ent) {
        await _db.into(_db.entitiesTable).insert(EntitiesTableCompanion.insert(
          id: r['id'],
          speciesId: r['speciesId'],
          subspeciesId: Value(r['subspeciesId']),
          locationId: Value(r['locationId']),
          expirationDate: Value(r['expirationDate'] != null ? DateTime.parse(r['expirationDate']) : null),
          notes: Value(r['notes']),
          createdAt: DateTime.parse(r['createdAt']),
          updatedAt: DateTime.parse(r['updatedAt']),
        ));
      }

      // Restaurar Magnitudes de Instancia
      final im = (tables['instanceMagnitudes'] as List? ?? []);
      for (final r in im) {
        await _db.into(_db.instanceMagnitudesTable).insert(InstanceMagnitudesTableCompanion.insert(
          id: r['id'],
          instanceId: r['instanceId'],
          propertyName: r['propertyName'],
          magnitudeValue: (r['magnitudeValue'] as num).toDouble(),
          unitSymbol: r['unitSymbol'],
        ));
      }

      // Restaurar Ubicaciones de Instancia
      final il = (tables['instanceLocations'] as List? ?? []);
      for (final r in il) {
        await _db.into(_db.instanceLocationsTable).insert(InstanceLocationsTableCompanion.insert(
          instanceId: r['instanceId'],
          locationId: r['locationId'],
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Relaciones
      final rel = (tables['relations'] as List? ?? []);
      for (final r in rel) {
        await _db.into(_db.relationsTable).insert(RelationsTableCompanion.insert(
          id: r['id'],
          sourceEntityId: r['sourceEntityId'],
          targetEntityId: r['targetEntityId'],
          relationType: r['relationType'],
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Adjuntos
      final att = (tables['attachments'] as List? ?? []);
      for (final r in att) {
        await _db.into(_db.attachmentsTable).insert(AttachmentsTableCompanion.insert(
          id: r['id'],
          speciesId: r['speciesId'],
          filePath: r['filePath'],
          fileName: r['fileName'],
          fileType: r['fileType'],
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Eventos de Historial
      final he = (tables['historyEvents'] as List? ?? []);
      for (final r in he) {
        await _db.into(_db.historyEventsTable).insert(HistoryEventsTableCompanion.insert(
          id: r['id'],
          entityId: Value(r['entityId']),
          eventType: r['eventType'],
          description: r['description'],
          metadata: Value(r['metadata']),
          timestamp: DateTime.parse(r['timestamp']),
        ));
      }

      // Restaurar Plantillas Personalizadas
      final ct = (tables['customTemplates'] as List? ?? []);
      for (final r in ct) {
        await _db.into(_db.customTemplatesTable).insert(CustomTemplatesTableCompanion.insert(
          id: r['id'],
          typeName: r['typeName'],
          iconName: r['iconName'],
          commonUnits: Value(r['commonUnits'] ?? '[]'),
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Requerimientos
      final sr = (tables['speciesRequirements'] as List? ?? []);
      for (final r in sr) {
        await _db.into(_db.speciesRequirementsTable).insert(SpeciesRequirementsTableCompanion.insert(
          id: r['id'],
          sourceId: r['sourceId'],
          sourceType: Value(r['sourceType'] ?? 'species'),
          requiredSpeciesId: r['requiredSpeciesId'],
          requiredQuantity: Value((r['requiredQuantity'] as num? ?? 1.0).toDouble()),
          notes: Value(r['notes']),
          createdAt: DateTime.parse(r['createdAt']),
        ));
      }

      // Restaurar Notificaciones
      final notif = (tables['notifications'] as List? ?? []);
      for (final r in notif) {
        await _db.into(_db.notificationsTable).insert(NotificationsTableCompanion.insert(
          id: r['id'],
          type: r['type'],
          title: r['title'],
          message: r['message'],
          targetId: r['targetId'],
          targetType: r['targetType'],
          status: Value(r['status'] ?? 'active'),
          snoozedUntil: Value(r['snoozedUntil'] != null ? DateTime.parse(r['snoozedUntil']) : null),
          createdAt: DateTime.parse(r['createdAt']),
          updatedAt: DateTime.parse(r['updatedAt']),
        ));
      }
    });
  }
}
