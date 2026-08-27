import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'app_database.dart';
import 'data_migration_post_processor.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatics/numismatic_backup_post_processor.dart';

class DatabaseBackupService {
  final AppDatabase _db;
  final List<IDataMigrationPostProcessor> _postProcessors;

  DatabaseBackupService(this._db, [List<IDataMigrationPostProcessor>? postProcessors])
      : _postProcessors = postProcessors ?? const [NumismaticBackupPostProcessor()];

  /// Sanitiza rutas de archivos para evitar almacenar rutas absolutas locales del SO (ej. Android)
  /// Si es una URL externa (http/https), la preserva intacta.
  static String _sanitizeMediaPath(String? rawPath) {
    if (rawPath == null || rawPath.trim().isEmpty) return AppTechnicalStrings.empty;
    final trimmed = rawPath.trim();
    if (trimmed.startsWith(AppTechnicalStrings.schemeHttp) || trimmed.startsWith(AppTechnicalStrings.schemeHttps)) {
      return trimmed;
    }
    return p.basename(trimmed);
  }

  /// Genera un JSON serializado con todos los registros de las 14 tablas de la base de datos
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
    final appSettings = await _db.select(_db.appSettingsTable).get();

    return {
      AppTechnicalJsonKeys.keyVersion: _db.schemaVersion,
      AppTechnicalJsonKeys.keyExportedAt: DateTime.now().toIso8601String(),
      AppTechnicalJsonKeys.keyTables: {
        AppTechnicalDb.tableLocations: locations.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalDb.colName: r.name,
          AppTechnicalJsonKeys.keyParentLocationId: r.parentLocationId,
          AppTechnicalDb.colDescription: r.description,
          AppTechnicalJsonKeys.keyIcon: r.icon,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalStrings.tableCatalog: catalog.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalDb.colName: r.name,
          AppTechnicalDb.colType: r.type,
          AppTechnicalDb.colDescription: r.description,
          AppTechnicalJsonKeys.keyMainPhotoPath: r.mainPhotoPath != null ? _sanitizeMediaPath(r.mainPhotoPath) : null,
          AppTechnicalJsonKeys.keyCustomAttributes: r.customAttributes,
          AppTechnicalJsonKeys.keyIsUnique: r.isUnique,
          AppTechnicalJsonKeys.keyIsNonPerishable: r.isNonPerishable,
          AppTechnicalJsonKeys.keyDefaultShelfLifeDays: r.defaultShelfLifeDays,
          AppTechnicalJsonKeys.keyWarningDaysBeforeExpiration: r.warningDaysBeforeExpiration,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableSubspecies: subspecies.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keySpeciesId: r.speciesId,
          AppTechnicalJsonKeys.keySubspeciesName: r.subspeciesName,
          AppTechnicalJsonKeys.keyBrand: r.brand,
          AppTechnicalJsonKeys.keyBarcode: r.barcode,
          AppTechnicalJsonKeys.keyPhotoPath: r.photoPath != null ? _sanitizeMediaPath(r.photoPath) : null,
          AppTechnicalDb.colNotes: r.notes,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableSpeciesMagnitudes: speciesMagnitudes.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keySpeciesId: r.speciesId,
          AppTechnicalJsonKeys.keyPropertyName: r.propertyName,
          AppTechnicalJsonKeys.keyDataType: r.dataType,
          AppTechnicalJsonKeys.keyUnitSymbol: r.unitSymbol,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableEntities: entities.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keySpeciesId: r.speciesId,
          AppTechnicalJsonKeys.keySubspeciesId: r.subspeciesId,
          AppTechnicalJsonKeys.keyLocationId: r.locationId,
          AppTechnicalJsonKeys.keyExpirationDate: r.expirationDate?.toIso8601String(),
          AppTechnicalDb.colNotes: r.notes,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
          AppTechnicalJsonKeys.keyUpdatedAt: r.updatedAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableInstanceMagnitudes: instanceMagnitudes.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keyInstanceId: r.instanceId,
          AppTechnicalJsonKeys.keyPropertyName: r.propertyName,
          AppTechnicalJsonKeys.keyDataType: r.dataType,
          AppTechnicalJsonKeys.keyMagnitudeValue: r.magnitudeValue,
          AppTechnicalJsonKeys.keyStringValue: r.stringValue,
          AppTechnicalJsonKeys.keyUnitSymbol: r.unitSymbol,
        }).toList(),
        AppTechnicalDb.tableInstanceLocations: instanceLocations.map((r) => {
          AppTechnicalJsonKeys.keyInstanceId: r.instanceId,
          AppTechnicalJsonKeys.keyLocationId: r.locationId,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableRelations: relations.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keySourceEntityId: r.sourceEntityId,
          AppTechnicalJsonKeys.keyTargetEntityId: r.targetEntityId,
          AppTechnicalJsonKeys.keyRelationType: r.relationType,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableAttachments: attachments.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keySpeciesId: r.speciesId,
          AppTechnicalJsonKeys.keyInstanceId: r.instanceId,
          AppTechnicalJsonKeys.keyFilePath: _sanitizeMediaPath(r.filePath),
          AppTechnicalJsonKeys.keyFileName: r.fileName,
          AppTechnicalJsonKeys.keyFileType: r.fileType,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableHistoryEvents: historyEvents.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keyEntityId: r.entityId,
          AppTechnicalJsonKeys.keyEventType: r.eventType,
          AppTechnicalDb.colDescription: r.description,
          AppTechnicalJsonKeys.keyMetadata: r.metadata,
          AppTechnicalJsonKeys.keyTimestamp: r.timestamp.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableCustomTemplates: customTemplates.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keyTypeName: r.typeName,
          AppTechnicalJsonKeys.keyIconName: r.iconName,
          AppTechnicalJsonKeys.keyCommonUnits: r.commonUnits,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableRequirements: speciesRequirements.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalJsonKeys.keySourceId: r.sourceId,
          AppTechnicalJsonKeys.keySourceType: r.sourceType,
          AppTechnicalJsonKeys.keyRequiredSpeciesId: r.requiredSpeciesId,
          AppTechnicalJsonKeys.keyRequiredQuantity: r.requiredQuantity,
          AppTechnicalDb.colNotes: r.notes,
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableNotifications: notifications.map((r) => {
          AppTechnicalDb.colId: r.id,
          AppTechnicalDb.colType: r.type,
          AppTechnicalJsonKeys.keyTitle: r.title,
          AppTechnicalJsonKeys.keyMessage: r.message,
          AppTechnicalJsonKeys.keyTargetId: r.targetId,
          AppTechnicalJsonKeys.keyTargetType: r.targetType,
          AppTechnicalJsonKeys.keyStatus: r.status,
          AppTechnicalJsonKeys.keySnoozedUntil: r.snoozedUntil?.toIso8601String(),
          AppTechnicalJsonKeys.keyCreatedAt: r.createdAt.toIso8601String(),
          AppTechnicalJsonKeys.keyUpdatedAt: r.updatedAt.toIso8601String(),
        }).toList(),
        AppTechnicalDb.tableAppSettings: appSettings.map((r) => {
          AppTechnicalJsonKeys.keyKey: r.key,
          AppTechnicalJsonKeys.keyValue: r.value,
        }).toList(),
      },
    };
  }

  /// Resuelve la ruta física local de un archivo de media referenciado en BD.
  Future<File?> _resolvePhysicalFile(String pathStr) async {
    if (pathStr.trim().isEmpty) return null;
    final trimmed = pathStr.trim();
    if (trimmed.startsWith(AppTechnicalStrings.schemeHttp) || trimmed.startsWith(AppTechnicalStrings.schemeHttps)) return null;

    final fDirect = File(trimmed);
    if (await fDirect.exists()) return fDirect;

    final docsDir = await getApplicationDocumentsDirectory();
    final filename = p.basename(trimmed);

    final fMedia = File(p.join(docsDir.path, AppTechnicalStorage.dirMedia, filename));
    if (await fMedia.exists()) return fMedia;

    final fProd = File(p.join(docsDir.path, AppTechnicalStorage.dirProductImages, filename));
    if (await fProd.exists()) return fProd;

    final fRoot = File(p.join(docsDir.path, filename));
    if (await fRoot.exists()) return fRoot;

    return null;
  }

  /// Exporta un paquete completo ZIP (Base de datos JSON + Fotos y archivos adjuntos) y abre la ventana de compartir nativa.
  /// Limpia automáticamente el archivo ZIP temporal al finalizar.
  Future<void> exportAndShareBackup() async {
    final data = await exportDatabaseToJsonMap();
    final jsonStr = const JsonEncoder.withIndent(AppTechnicalStrings.indentTwoSpaces).convert(data);

    final archive = Archive();

    // 1. Agregar el archivo de la base de datos
    final jsonBytes = utf8.encode(jsonStr);
    archive.addFile(ArchiveFile(AppTechnicalStorage.backupDatabaseFileName, jsonBytes.length, jsonBytes));

    // 2. Recolectar todas las rutas de archivos multimedia referenciadas en las tablas
    final Set<String> referencedPaths = {};
    final tables = data[AppTechnicalJsonKeys.keyTables] as Map<String, dynamic>? ?? {};

    final catalogList = tables[AppTechnicalStrings.tableCatalog] as List<dynamic>? ?? [];
    for (final item in catalogList) {
      if (item[AppTechnicalJsonKeys.keyMainPhotoPath] != null && item[AppTechnicalJsonKeys.keyMainPhotoPath].toString().isNotEmpty) {
        referencedPaths.add(item[AppTechnicalJsonKeys.keyMainPhotoPath].toString());
      }
    }

    final subspeciesList = tables[AppTechnicalDb.tableSubspecies] as List<dynamic>? ?? [];
    for (final item in subspeciesList) {
      if (item[AppTechnicalJsonKeys.keyPhotoPath] != null && item[AppTechnicalJsonKeys.keyPhotoPath].toString().isNotEmpty) {
        referencedPaths.add(item[AppTechnicalJsonKeys.keyPhotoPath].toString());
      }
    }

    final attachmentsList = tables[AppTechnicalDb.tableAttachments] as List<dynamic>? ?? [];
    for (final item in attachmentsList) {
      if (item[AppTechnicalJsonKeys.keyFilePath] != null && item[AppTechnicalJsonKeys.keyFilePath].toString().isNotEmpty) {
        referencedPaths.add(item[AppTechnicalJsonKeys.keyFilePath].toString());
      }
    }

    // 3. Incluir cada archivo físico en el archivo ZIP dentro de files/
    for (final refPath in referencedPaths) {
      final file = await _resolvePhysicalFile(refPath);
      if (file != null && await file.exists()) {
        final bytes = await file.readAsBytes();
        final filename = p.basename(file.path);
        archive.addFile(ArchiveFile(AppTechnicalStrings.backupArchiveFilePath(filename), bytes.length, bytes));
      }
    }

    final zipEncoder = ZipEncoder();
    final zipBytes = zipEncoder.encode(archive);

    if (zipBytes == null) {
      throw Exception(AppStrings.backupZipCompressionError);
    }

    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(AppTechnicalDelimiters.colon, AppTechnicalDelimiters.dash).replaceAll(AppTechnicalDelimiters.dot, AppTechnicalDelimiters.dash);
    final tempZipFile = File(p.join(tempDir.path, AppTechnicalStrings.backupZipFileName(timestamp)));

    try {
      await tempZipFile.writeAsBytes(zipBytes);
      await Share.shareXFiles(
        [XFile(tempZipFile.path)],
      );
    } finally {
      if (await tempZipFile.exists()) {
        try {
          await tempZipFile.delete();
        } catch (_) {}
      }
    }
  }

  /// Importa una copia de seguridad enviada como archivo (.zip o .json)
  Future<void> importDatabaseFromFile(File file) async {
    final bytes = await file.readAsBytes();

    final isZip = file.path.toLowerCase().endsWith(AppTechnicalStorage.extZip) ||
        (bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4B);

    if (isZip) {
      final archive = ZipDecoder().decodeBytes(bytes);
      String? jsonContent;

      final docsDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory(p.join(docsDir.path, AppTechnicalStorage.dirMedia));
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }
      final prodDir = Directory(p.join(docsDir.path, AppTechnicalStorage.dirProductImages));
      if (!await prodDir.exists()) {
        await prodDir.create(recursive: true);
      }

      for (final archiveFile in archive) {
        if (!archiveFile.isFile) continue;

        final name = archiveFile.name;
        final baseName = p.basename(name);

        // Ignorar carpetas/archivos de metadatos del sistema de macOS (__MACOSX, ._*, .DS_Store)
        if (name.contains(AppTechnicalStrings.macOsMetadataDir) || baseName.startsWith(AppTechnicalStrings.dotUnderscore) || baseName.startsWith(AppTechnicalDelimiters.dot)) {
          continue;
        }

        if (baseName == AppTechnicalStorage.backupDatabaseFileName || (jsonContent == null && baseName.endsWith(AppTechnicalStorage.extJson))) {
          jsonContent = utf8.decode(archiveFile.content as List<int>);
        } else if (name.startsWith(AppTechnicalStrings.dirFilesPrefix) || name.contains(AppTechnicalStrings.slashFilesPrefix)) {
          if (baseName.isNotEmpty) {
            final content = archiveFile.content as List<int>;
            await File(p.join(mediaDir.path, baseName)).writeAsBytes(content);
            await File(p.join(prodDir.path, baseName)).writeAsBytes(content);
          }
        }
      }

      if (jsonContent == null) {
        throw Exception(AppStrings.backupZipMissingDatabaseJsonError);
      }

      await importDatabaseFromJsonString(jsonContent);
    } else {
      final jsonStr = utf8.decode(bytes);
      await importDatabaseFromJsonString(jsonStr);
    }
  }

  /// Realiza la migración secuencial paso a paso de los datos JSON importados
  /// según la versión de origen (e.g. 1.0, 2.0 -> N) y aplica autorreparación retroactiva
  Map<String, dynamic> migrateImportedData(Map<String, dynamic> data, {required int targetVersion}) {
    final rawVersion = data[AppTechnicalJsonKeys.keyVersion] ?? data[AppTechnicalJsonKeys.keySchemaVersion] ?? data[AppTechnicalJsonKeys.keyVersionCheck] ?? 1;
    int importedVersion = 1;

    if (rawVersion is int) {
      importedVersion = rawVersion;
    } else if (rawVersion is num) {
      importedVersion = rawVersion.floor();
    } else if (rawVersion is String) {
      final parsed = double.tryParse(rawVersion);
      if (parsed != null) {
        importedVersion = parsed.floor();
      }
    }

    if (importedVersion < 1) importedVersion = 1;

    Map<String, dynamic> currentData = Map<String, dynamic>.from(data);

    for (int v = importedVersion; v < targetVersion; v++) {
      currentData = _migrateJsonStep(currentData, fromVersion: v, toVersion: v + 1);
    }

    // Aplicar autorreparación y estandarización retroactiva de magnitudes, tipos y rutas
    currentData = _repairAndStandardizeImportedData(currentData);

    currentData[AppTechnicalJsonKeys.keyVersion] = targetVersion;
    return currentData;
  }

  Map<String, dynamic> _migrateJsonStep(Map<String, dynamic> data, {required int fromVersion, required int toVersion}) {
    final tables = Map<String, dynamic>.from(data[AppTechnicalJsonKeys.keyTables] as Map<String, dynamic>? ?? {});

    if (fromVersion == 1 && toVersion >= 2) {
      // Migración 1 -> 2:
      // Asegurar tabla de appSettings y columnas predeterminadas agregadas en v2
      tables.putIfAbsent(AppTechnicalDb.tableAppSettings, () => <Map<String, dynamic>>[]);

      final catalog = (tables[AppTechnicalStrings.tableCatalog] as List? ?? []);
      final List<Map<String, dynamic>> updatedCatalog = [];
      for (var item in catalog) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent(AppTechnicalDb.colType, () => AppStrings.typeObject);
          m.putIfAbsent(AppTechnicalJsonKeys.keyCustomAttributes, () => AppTechnicalStrings.emptyJsonMap);
          m.putIfAbsent(AppTechnicalJsonKeys.keyIsUnique, () => false);
          m.putIfAbsent(AppTechnicalJsonKeys.keyIsNonPerishable, () => true);
          updatedCatalog.add(m);
        }
      }
      tables[AppTechnicalStrings.tableCatalog] = updatedCatalog;

      final speciesMagnitudes = (tables[AppTechnicalDb.tableSpeciesMagnitudes] as List? ?? []);
      final List<Map<String, dynamic>> updatedSM = [];
      for (var item in speciesMagnitudes) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent(AppTechnicalJsonKeys.keyDataType, () => AppTechnicalStrings.datatypeRealLower);
          updatedSM.add(m);
        }
      }
      tables[AppTechnicalDb.tableSpeciesMagnitudes] = updatedSM;

      final instanceMagnitudes = (tables[AppTechnicalDb.tableInstanceMagnitudes] as List? ?? []);
      final List<Map<String, dynamic>> updatedIM = [];
      for (var item in instanceMagnitudes) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent(AppTechnicalJsonKeys.keyDataType, () => AppTechnicalStrings.datatypeRealLower);
          m.putIfAbsent(AppTechnicalJsonKeys.keyMagnitudeValue, () => 0.0);
          updatedIM.add(m);
        }
      }
      tables[AppTechnicalDb.tableInstanceMagnitudes] = updatedIM;

      final speciesRequirements = (tables[AppTechnicalDb.tableRequirements] as List? ?? []);
      final List<Map<String, dynamic>> updatedSR = [];
      for (var item in speciesRequirements) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent(AppTechnicalJsonKeys.keySourceType, () => AppTechnicalStrings.sourceTypeSpecies);
          m.putIfAbsent(AppTechnicalJsonKeys.keyRequiredQuantity, () => 1.0);
          updatedSR.add(m);
        }
      }
      tables[AppTechnicalDb.tableRequirements] = updatedSR;

      final notifications = (tables[AppTechnicalDb.tableNotifications] as List? ?? []);
      final List<Map<String, dynamic>> updatedNotif = [];
      for (var item in notifications) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent(AppTechnicalJsonKeys.keyStatus, () => AppTechnicalNotifications.notifStatusActive);
          updatedNotif.add(m);
        }
      }
      tables[AppTechnicalDb.tableNotifications] = updatedNotif;
    }

    if (fromVersion == 2 && toVersion >= 3) {
      // Migración 2 -> 3:
      // Agregar campo instanceId en la tabla de attachments
      final attachments = (tables[AppTechnicalDb.tableAttachments] as List? ?? []);
      final List<Map<String, dynamic>> updatedAtt = [];
      for (var item in attachments) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent(AppTechnicalJsonKeys.keyInstanceId, () => null);
          updatedAtt.add(m);
        }
      }
      tables[AppTechnicalDb.tableAttachments] = updatedAtt;
    }

    if (fromVersion == 3 && toVersion >= 4) {
      // Migración 3 -> 4:
      // Enforce que entidades contenidas no tengan ubicación directa en el respaldo
      final relations = (tables[AppTechnicalDb.tableRelations] as List? ?? []);
      final containedIds = <String>{};
      for (final r in relations) {
        if (r is Map) {
          final relType = r[AppTechnicalJsonKeys.keyRelationType]?.toString();
          if (relType == AppTechnicalDb.relGuardadoEn || relType == AppTechnicalDb.relParteDe) {
            final srcId = r[AppTechnicalJsonKeys.keySourceEntityId]?.toString();
            if (srcId != null) containedIds.add(srcId);
          }
        }
      }

      // 1. Limpiar ubicaciones directas en instanceLocations
      final instanceLocations = (tables[AppTechnicalDb.tableInstanceLocations] as List? ?? []);
      final List<Map<String, dynamic>> updatedInstLocs = [];
      for (final il in instanceLocations) {
        if (il is Map) {
          final instId = il[AppTechnicalJsonKeys.keyInstanceId]?.toString();
          if (!containedIds.contains(instId)) {
            updatedInstLocs.add(Map<String, dynamic>.from(il));
          }
        }
      }
      tables[AppTechnicalDb.tableInstanceLocations] = updatedInstLocs;

      // 2. Limpiar locationId en entities
      final entities = (tables[AppTechnicalDb.tableEntities] as List? ?? []);
      final List<Map<String, dynamic>> updatedEntities = [];
      for (final e in entities) {
        if (e is Map) {
          final m = Map<String, dynamic>.from(e);
          final eId = m[AppTechnicalDb.colId]?.toString();
          if (containedIds.contains(eId)) {
            m[AppTechnicalJsonKeys.keyLocationId] = null;
          }
          updatedEntities.add(m);
        }
      }
      tables[AppTechnicalDb.tableEntities] = updatedEntities;
    }

    data[AppTechnicalJsonKeys.keyTables] = tables;
    return data;
  }

  /// Realiza la autorreparación retroactiva de datos numismáticos y sanitización de rutas
  /// para respaldos creados en versiones previas donde dataType/stringValue no fueron exportados.
  Map<String, dynamic> _repairAndStandardizeImportedData(Map<String, dynamic> data) {
    final tables = Map<String, dynamic>.from(data[AppTechnicalJsonKeys.keyTables] as Map<String, dynamic>? ?? {});

    // Asegurar tabla appSettings
    tables.putIfAbsent(AppTechnicalDb.tableAppSettings, () => <Map<String, dynamic>>[]);

    // 1. Construir mapas de búsqueda rápida
    final catalogList = (tables[AppTechnicalStrings.tableCatalog] as List? ?? []);
    final speciesMap = <String, Map<String, dynamic>>{};
    final List<Map<String, dynamic>> sanitizedCatalog = [];
    for (final c in catalogList) {
      if (c is Map) {
        final m = Map<String, dynamic>.from(c);
        if (m[AppTechnicalJsonKeys.keyMainPhotoPath] != null) {
          m[AppTechnicalJsonKeys.keyMainPhotoPath] = _sanitizeMediaPath(m[AppTechnicalJsonKeys.keyMainPhotoPath].toString());
        }
        speciesMap[m[AppTechnicalDb.colId].toString()] = m;
        sanitizedCatalog.add(m);
      }
    }
    tables[AppTechnicalStrings.tableCatalog] = sanitizedCatalog;

    final subspeciesList = (tables[AppTechnicalDb.tableSubspecies] as List? ?? []);
    final subspeciesMap = <String, Map<String, dynamic>>{};
    final List<Map<String, dynamic>> sanitizedSubspecies = [];
    for (final s in subspeciesList) {
      if (s is Map) {
        final m = Map<String, dynamic>.from(s);
        if (m[AppTechnicalJsonKeys.keyPhotoPath] != null) {
          m[AppTechnicalJsonKeys.keyPhotoPath] = _sanitizeMediaPath(m[AppTechnicalJsonKeys.keyPhotoPath].toString());
        }
        subspeciesMap[m[AppTechnicalDb.colId].toString()] = m;
        sanitizedSubspecies.add(m);
      }
    }
    tables[AppTechnicalDb.tableSubspecies] = sanitizedSubspecies;

    final attachmentsList = (tables[AppTechnicalDb.tableAttachments] as List? ?? []);
    final List<Map<String, dynamic>> sanitizedAttachments = [];
    for (final a in attachmentsList) {
      if (a is Map) {
        final m = Map<String, dynamic>.from(a);
        if (m[AppTechnicalJsonKeys.keyFilePath] != null) {
          m[AppTechnicalJsonKeys.keyFilePath] = _sanitizeMediaPath(m[AppTechnicalJsonKeys.keyFilePath].toString());
        }
        sanitizedAttachments.add(m);
      }
    }
    tables[AppTechnicalDb.tableAttachments] = sanitizedAttachments;

    final entitiesList = (tables[AppTechnicalDb.tableEntities] as List? ?? []);
    final entityMap = <String, Map<String, dynamic>>{};
    for (final e in entitiesList) {
      if (e is Map) {
        final m = Map<String, dynamic>.from(e);
        entityMap[m[AppTechnicalDb.colId].toString()] = m;
      }
    }

    // 2. Reparar y estandarizar speciesMagnitudes
    final speciesMagnitudes = (tables[AppTechnicalDb.tableSpeciesMagnitudes] as List? ?? []);
    final List<Map<String, dynamic>> updatedSM = [];
    for (final item in speciesMagnitudes) {
      if (item is Map) {
        final m = Map<String, dynamic>.from(item);
        final propName = (m[AppTechnicalJsonKeys.keyPropertyName] ?? AppTechnicalStrings.empty).toString().trim();
        var dt = m[AppTechnicalJsonKeys.keyDataType]?.toString();

        if (dt == null || dt.isEmpty || dt == AppTechnicalStrings.datatypeRealLower) {
          if (propName == AppStrings.currencyPropertyName || propName == AppStrings.materialPropertyName || propName == AppStrings.gradePropertyName) {
            dt = AppTechnicalStrings.datatypeStringLower;
          } else if (propName == AppStrings.mintagePropertyName || propName == AppStrings.mintageYearLabel || propName == AppStrings.yearUnitSymbol) {
            dt = AppTechnicalStrings.datatypeIntegerLower;
          } else {
            dt ??= AppTechnicalStrings.datatypeRealLower;
          }
        }
        m[AppTechnicalJsonKeys.keyDataType] = dt;
        updatedSM.add(m);
      }
    }
    tables[AppTechnicalDb.tableSpeciesMagnitudes] = updatedSM;

    // 3. Reparar y estandarizar instanceMagnitudes
    final instanceMagnitudes = (tables[AppTechnicalDb.tableInstanceMagnitudes] as List? ?? []);
    final List<Map<String, dynamic>> updatedIM = [];
    for (final item in instanceMagnitudes) {
      if (item is Map) {
        final m = Map<String, dynamic>.from(item);
        final propName = (m[AppTechnicalJsonKeys.keyPropertyName] ?? AppTechnicalStrings.empty).toString().trim();
        final instId = m[AppTechnicalJsonKeys.keyInstanceId]?.toString();
        var dt = m[AppTechnicalJsonKeys.keyDataType]?.toString();
        var strVal = m[AppTechnicalJsonKeys.keyStringValue]?.toString();
        var numVal = (m[AppTechnicalJsonKeys.keyMagnitudeValue] as num?)?.toDouble() ?? 0.0;
        var unit = m[AppTechnicalJsonKeys.keyUnitSymbol]?.toString();

        final entity = instId != null ? entityMap[instId] : null;
        final speciesId = entity?[AppTechnicalJsonKeys.keySpeciesId]?.toString();
        final species = speciesId != null ? speciesMap[speciesId] : null;
        final subspeciesId = entity?[AppTechnicalJsonKeys.keySubspeciesId]?.toString();
        final subspecies = subspeciesId != null ? subspeciesMap[subspeciesId] : null;

        if (propName == AppStrings.currencyPropertyName) {
          dt = AppTechnicalStrings.datatypeStringLower;
          unit = null;
          if (strVal == null || strVal.trim().isEmpty) {
            if (subspecies != null) {
              final subNotes = subspecies[AppTechnicalDb.colNotes]?.toString() ?? AppTechnicalStrings.empty;
              final subName = subspecies[AppTechnicalJsonKeys.keySubspeciesName]?.toString() ?? AppTechnicalStrings.empty;

              final notesMatch = RegExp(AppTechnicalStrings.regexMonedaNote).firstMatch(subNotes);
              if (notesMatch != null) {
                strVal = notesMatch.group(1)?.trim();
              } else if (subName.isNotEmpty && subName != AppStrings.genericSubspeciesName) {
                final parsed = NumismaticDataHelper.parseSubspeciesName(subName);
                strVal = parsed.currencyName;
              }
            }
          }
        } else if (propName == AppStrings.materialPropertyName) {
          dt = AppTechnicalStrings.datatypeStringLower;
          unit = null;
          if (strVal == null || strVal.trim().isEmpty) {
            if (subspecies != null) {
              final subNotes = subspecies[AppTechnicalDb.colNotes]?.toString() ?? AppTechnicalStrings.empty;
              final matMatch = RegExp(AppTechnicalStrings.regexMaterialNote).firstMatch(subNotes);
              final metalMatch = RegExp(AppTechnicalStrings.regexMetalNote).firstMatch(subNotes);
              if (matMatch != null) {
                strVal = matMatch.group(1)?.trim();
              } else if (metalMatch != null) {
                strVal = metalMatch.group(1)?.trim();
              } else if (species?[AppTechnicalDb.colName] == AppStrings.banknoteRectangleLabel) {
                strVal = AppStrings.materialPaper;
              }
            } else if (species?[AppTechnicalDb.colName] == AppStrings.banknoteRectangleLabel) {
              strVal = AppStrings.materialPaper;
            }
          }
        } else if (propName == AppStrings.gradePropertyName) {
          dt = AppTechnicalStrings.datatypeStringLower;
          unit = null;
          if (strVal == null && entity?[AppTechnicalDb.colNotes] != null) {
            final entNotes = entity![AppTechnicalDb.colNotes].toString();
            final gradeMatch = RegExp(AppTechnicalStrings.regexGradoNote).firstMatch(entNotes);
            if (gradeMatch != null) {
              final g = gradeMatch.group(1)?.trim();
              if (g != null && g != AppStrings.unspecifiedGrade && g.isNotEmpty) {
                strVal = g;
              }
            }
          }
        } else if (propName == AppStrings.mintagePropertyName || propName == AppStrings.mintageYearLabel || propName == AppStrings.yearUnitSymbol) {
          dt = AppTechnicalStrings.datatypeIntegerLower;
          unit ??= AppStrings.yearUnitSymbol;
        } else if (propName == AppStrings.nominalValuePropertyName) {
          dt = AppTechnicalStrings.datatypeRealLower;
        } else {
          dt ??= AppTechnicalStrings.datatypeRealLower;
        }

        m[AppTechnicalJsonKeys.keyDataType] = dt;
        m[AppTechnicalJsonKeys.keyStringValue] = strVal;
        m[AppTechnicalJsonKeys.keyMagnitudeValue] = numVal;
        m[AppTechnicalJsonKeys.keyUnitSymbol] = unit;
        updatedIM.add(m);
      }
    }
    tables[AppTechnicalDb.tableInstanceMagnitudes] = updatedIM;

    data[AppTechnicalJsonKeys.keyTables] = tables;
    return data;
  }

  /// Importa la base de datos a partir de una cadena JSON
  Future<void> importDatabaseFromJsonString(String jsonString) async {
    final Map<String, dynamic> rawData = jsonDecode(jsonString);
    if (!rawData.containsKey(AppTechnicalJsonKeys.keyTables)) {
      throw const FormatException(AppStrings.invalidBackupStructureError);
    }

    final migratedData = migrateImportedData(rawData, targetVersion: _db.schemaVersion);
    final tables = migratedData[AppTechnicalJsonKeys.keyTables] as Map<String, dynamic>;

    await _db.transaction(() async {
      // Limpiar datos existentes en orden inverso de clave foránea
      await _db.delete(_db.appSettingsTable).go();
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
      final locs = (tables[AppTechnicalDb.tableLocations] as List? ?? []);
      for (final r in locs) {
        await _db.into(_db.locationsTable).insert(LocationsTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          name: r[AppTechnicalDb.colName],
          parentLocationId: Value(r[AppTechnicalJsonKeys.keyParentLocationId]),
          description: Value(r[AppTechnicalDb.colDescription]),
          icon: Value(r[AppTechnicalJsonKeys.keyIcon]),
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Catálogo
      final cat = (tables[AppTechnicalStrings.tableCatalog] as List? ?? []);
      for (final r in cat) {
        await _db.into(_db.catalogTable).insert(CatalogTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          name: r[AppTechnicalDb.colName],
          type: Value(r[AppTechnicalDb.colType] ?? AppStrings.typeObject),
          description: Value(r[AppTechnicalDb.colDescription]),
          mainPhotoPath: Value(r[AppTechnicalJsonKeys.keyMainPhotoPath]),
          customAttributes: Value(r[AppTechnicalJsonKeys.keyCustomAttributes] ?? AppTechnicalStrings.emptyJsonMap),
          isUnique: Value(r[AppTechnicalJsonKeys.keyIsUnique] ?? false),
          isNonPerishable: Value(r[AppTechnicalJsonKeys.keyIsNonPerishable] ?? true),
          defaultShelfLifeDays: Value(r[AppTechnicalJsonKeys.keyDefaultShelfLifeDays]),
          warningDaysBeforeExpiration: Value(r[AppTechnicalJsonKeys.keyWarningDaysBeforeExpiration]),
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Subespecies
      final sub = (tables[AppTechnicalDb.tableSubspecies] as List? ?? []);
      for (final r in sub) {
        await _db.into(_db.subspeciesTable).insert(SubspeciesTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          speciesId: r[AppTechnicalJsonKeys.keySpeciesId],
          subspeciesName: r[AppTechnicalJsonKeys.keySubspeciesName],
          brand: Value(r[AppTechnicalJsonKeys.keyBrand]),
          barcode: Value(r[AppTechnicalJsonKeys.keyBarcode]),
          photoPath: Value(r[AppTechnicalJsonKeys.keyPhotoPath]),
          notes: Value(r[AppTechnicalDb.colNotes]),
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Magnitudes de Especie
      final sm = (tables[AppTechnicalDb.tableSpeciesMagnitudes] as List? ?? []);
      for (final r in sm) {
        await _db.into(_db.speciesMagnitudesTable).insert(SpeciesMagnitudesTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          speciesId: r[AppTechnicalJsonKeys.keySpeciesId],
          propertyName: r[AppTechnicalJsonKeys.keyPropertyName],
          dataType: Value(r[AppTechnicalJsonKeys.keyDataType] ?? AppTechnicalStrings.datatypeRealLower),
          unitSymbol: Value(r[AppTechnicalJsonKeys.keyUnitSymbol]),
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Instancias / Entidades
      final ent = (tables[AppTechnicalDb.tableEntities] as List? ?? []);
      for (final r in ent) {
        await _db.into(_db.entitiesTable).insert(EntitiesTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          speciesId: r[AppTechnicalJsonKeys.keySpeciesId],
          subspeciesId: Value(r[AppTechnicalJsonKeys.keySubspeciesId]),
          locationId: Value(r[AppTechnicalJsonKeys.keyLocationId]),
          expirationDate: Value(r[AppTechnicalJsonKeys.keyExpirationDate] != null ? DateTime.parse(r[AppTechnicalJsonKeys.keyExpirationDate]) : null),
          notes: Value(r[AppTechnicalDb.colNotes]),
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
          updatedAt: DateTime.parse(r[AppTechnicalJsonKeys.keyUpdatedAt]),
        ));
      }

      // Restaurar Magnitudes de Instancia
      final im = (tables[AppTechnicalDb.tableInstanceMagnitudes] as List? ?? []);
      for (final r in im) {
        await _db.into(_db.instanceMagnitudesTable).insert(InstanceMagnitudesTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          instanceId: r[AppTechnicalJsonKeys.keyInstanceId],
          propertyName: r[AppTechnicalJsonKeys.keyPropertyName],
          dataType: Value(r[AppTechnicalJsonKeys.keyDataType] ?? AppTechnicalStrings.datatypeRealLower),
          magnitudeValue: Value((r[AppTechnicalJsonKeys.keyMagnitudeValue] as num?)?.toDouble() ?? 0.0),
          stringValue: Value(r[AppTechnicalJsonKeys.keyStringValue]),
          unitSymbol: Value(r[AppTechnicalJsonKeys.keyUnitSymbol]),
        ));
      }

      // Restaurar Ubicaciones de Instancia
      final il = (tables[AppTechnicalDb.tableInstanceLocations] as List? ?? []);
      for (final r in il) {
        await _db.into(_db.instanceLocationsTable).insert(InstanceLocationsTableCompanion.insert(
          instanceId: r[AppTechnicalJsonKeys.keyInstanceId],
          locationId: r[AppTechnicalJsonKeys.keyLocationId],
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Relaciones
      final rel = (tables[AppTechnicalDb.tableRelations] as List? ?? []);
      for (final r in rel) {
        await _db.into(_db.relationsTable).insert(RelationsTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          sourceEntityId: r[AppTechnicalJsonKeys.keySourceEntityId],
          targetEntityId: r[AppTechnicalJsonKeys.keyTargetEntityId],
          relationType: r[AppTechnicalJsonKeys.keyRelationType],
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Adjuntos
      final att = (tables[AppTechnicalDb.tableAttachments] as List? ?? []);
      for (final r in att) {
        await _db.into(_db.attachmentsTable).insert(AttachmentsTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          speciesId: r[AppTechnicalJsonKeys.keySpeciesId],
          instanceId: Value(r[AppTechnicalJsonKeys.keyInstanceId]),
          filePath: r[AppTechnicalJsonKeys.keyFilePath],
          fileName: r[AppTechnicalJsonKeys.keyFileName],
          fileType: r[AppTechnicalJsonKeys.keyFileType],
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Eventos de Historial
      final he = (tables[AppTechnicalDb.tableHistoryEvents] as List? ?? []);
      for (final r in he) {
        await _db.into(_db.historyEventsTable).insert(HistoryEventsTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          entityId: Value(r[AppTechnicalJsonKeys.keyEntityId]),
          eventType: r[AppTechnicalJsonKeys.keyEventType],
          description: r[AppTechnicalDb.colDescription],
          metadata: Value(r[AppTechnicalJsonKeys.keyMetadata]),
          timestamp: DateTime.parse(r[AppTechnicalJsonKeys.keyTimestamp]),
        ));
      }

      // Restaurar Plantillas Personalizadas
      final ct = (tables[AppTechnicalDb.tableCustomTemplates] as List? ?? []);
      for (final r in ct) {
        await _db.into(_db.customTemplatesTable).insert(CustomTemplatesTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          typeName: r[AppTechnicalJsonKeys.keyTypeName],
          iconName: r[AppTechnicalJsonKeys.keyIconName],
          commonUnits: Value(r[AppTechnicalJsonKeys.keyCommonUnits] ?? AppTechnicalStrings.emptyJsonList),
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Requerimientos
      final sr = (tables[AppTechnicalDb.tableRequirements] as List? ?? []);
      for (final r in sr) {
        await _db.into(_db.speciesRequirementsTable).insert(SpeciesRequirementsTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          sourceId: r[AppTechnicalJsonKeys.keySourceId],
          sourceType: Value(r[AppTechnicalJsonKeys.keySourceType] ?? AppTechnicalStrings.sourceTypeSpecies),
          requiredSpeciesId: r[AppTechnicalJsonKeys.keyRequiredSpeciesId],
          requiredQuantity: Value((r[AppTechnicalJsonKeys.keyRequiredQuantity] as num? ?? 1.0).toDouble()),
          notes: Value(r[AppTechnicalDb.colNotes]),
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
        ));
      }

      // Restaurar Notificaciones
      final notif = (tables[AppTechnicalDb.tableNotifications] as List? ?? []);
      for (final r in notif) {
        await _db.into(_db.notificationsTable).insert(NotificationsTableCompanion.insert(
          id: r[AppTechnicalDb.colId],
          type: r[AppTechnicalDb.colType],
          title: r[AppTechnicalJsonKeys.keyTitle],
          message: r[AppTechnicalJsonKeys.keyMessage],
          targetId: r[AppTechnicalJsonKeys.keyTargetId],
          targetType: r[AppTechnicalJsonKeys.keyTargetType],
          status: Value(r[AppTechnicalJsonKeys.keyStatus] ?? AppTechnicalNotifications.notifStatusActive),
          snoozedUntil: Value(r[AppTechnicalJsonKeys.keySnoozedUntil] != null ? DateTime.parse(r[AppTechnicalJsonKeys.keySnoozedUntil]) : null),
          createdAt: DateTime.parse(r[AppTechnicalJsonKeys.keyCreatedAt]),
          updatedAt: DateTime.parse(r[AppTechnicalJsonKeys.keyUpdatedAt]),
        ));
      }

      // Restaurar Configuraciones de la App
      final appSettings = (tables[AppTechnicalDb.tableAppSettings] as List? ?? []);
      for (final r in appSettings) {
        if (r is Map && r[AppTechnicalJsonKeys.keyKey] != null && r[AppTechnicalJsonKeys.keyValue] != null) {
          await _db.into(_db.appSettingsTable).insert(AppSettingsTableCompanion.insert(
            key: r[AppTechnicalJsonKeys.keyKey].toString(),
            value: r[AppTechnicalJsonKeys.keyValue].toString(),
          ));
        }
      }
    });

    // Execute decoupled migration post-processors (e.g. Numismatic standardization)
    for (final processor in _postProcessors) {
      await processor.processAfterImport(_db);
    }
  }
}
