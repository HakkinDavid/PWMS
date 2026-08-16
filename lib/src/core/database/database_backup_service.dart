import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'app_database.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_data_helper.dart';

class DatabaseBackupService {
  final AppDatabase _db;

  DatabaseBackupService(this._db);

  /// Sanitiza rutas de archivos para evitar almacenar rutas absolutas locales del SO (ej. Android)
  /// Si es una URL externa (http/https), la preserva intacta.
  static String _sanitizeMediaPath(String? rawPath) {
    if (rawPath == null || rawPath.trim().isEmpty) return '';
    final trimmed = rawPath.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
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
      'version': _db.schemaVersion,
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
          'mainPhotoPath': r.mainPhotoPath != null ? _sanitizeMediaPath(r.mainPhotoPath) : null,
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
          'photoPath': r.photoPath != null ? _sanitizeMediaPath(r.photoPath) : null,
          'notes': r.notes,
          'createdAt': r.createdAt.toIso8601String(),
        }).toList(),
        'speciesMagnitudes': speciesMagnitudes.map((r) => {
          'id': r.id,
          'speciesId': r.speciesId,
          'propertyName': r.propertyName,
          'dataType': r.dataType,
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
          'dataType': r.dataType,
          'magnitudeValue': r.magnitudeValue,
          'stringValue': r.stringValue,
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
          'instanceId': r.instanceId,
          'filePath': _sanitizeMediaPath(r.filePath),
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
        'appSettings': appSettings.map((r) => {
          'key': r.key,
          'value': r.value,
        }).toList(),
      },
    };
  }

  /// Resuelve la ruta física local de un archivo de media referenciado en BD.
  Future<File?> _resolvePhysicalFile(String pathStr) async {
    if (pathStr.trim().isEmpty) return null;
    final trimmed = pathStr.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) return null;

    final fDirect = File(trimmed);
    if (await fDirect.exists()) return fDirect;

    final docsDir = await getApplicationDocumentsDirectory();
    final filename = p.basename(trimmed);

    final fMedia = File(p.join(docsDir.path, 'pwms_media', filename));
    if (await fMedia.exists()) return fMedia;

    final fProd = File(p.join(docsDir.path, 'product_images', filename));
    if (await fProd.exists()) return fProd;

    final fRoot = File(p.join(docsDir.path, filename));
    if (await fRoot.exists()) return fRoot;

    return null;
  }

  /// Exporta un paquete completo ZIP (Base de datos JSON + Fotos y archivos adjuntos) y abre la ventana de compartir nativa.
  /// Limpia automáticamente el archivo ZIP temporal al finalizar.
  Future<void> exportAndShareBackup() async {
    final data = await exportDatabaseToJsonMap();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);

    final archive = Archive();

    // 1. Agregar el archivo de la base de datos
    final jsonBytes = utf8.encode(jsonStr);
    archive.addFile(ArchiveFile('database.json', jsonBytes.length, jsonBytes));

    // 2. Recolectar todas las rutas de archivos multimedia referenciadas en las tablas
    final Set<String> referencedPaths = {};
    final tables = data['tables'] as Map<String, dynamic>? ?? {};

    final catalogList = tables['catalog'] as List<dynamic>? ?? [];
    for (final item in catalogList) {
      if (item['mainPhotoPath'] != null && item['mainPhotoPath'].toString().isNotEmpty) {
        referencedPaths.add(item['mainPhotoPath'].toString());
      }
    }

    final subspeciesList = tables['subspecies'] as List<dynamic>? ?? [];
    for (final item in subspeciesList) {
      if (item['photoPath'] != null && item['photoPath'].toString().isNotEmpty) {
        referencedPaths.add(item['photoPath'].toString());
      }
    }

    final attachmentsList = tables['attachments'] as List<dynamic>? ?? [];
    for (final item in attachmentsList) {
      if (item['filePath'] != null && item['filePath'].toString().isNotEmpty) {
        referencedPaths.add(item['filePath'].toString());
      }
    }

    // 3. Incluir cada archivo físico en el archivo ZIP dentro de files/
    for (final refPath in referencedPaths) {
      final file = await _resolvePhysicalFile(refPath);
      if (file != null && await file.exists()) {
        final bytes = await file.readAsBytes();
        final filename = p.basename(file.path);
        archive.addFile(ArchiveFile('files/$filename', bytes.length, bytes));
      }
    }

    final zipEncoder = ZipEncoder();
    final zipBytes = zipEncoder.encode(archive);

    if (zipBytes == null) {
      throw Exception('Error al generar la compresión del paquete de respaldo.');
    }

    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
    final tempZipFile = File(p.join(tempDir.path, 'pwms_backup_$timestamp.zip'));

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

    final isZip = file.path.toLowerCase().endsWith('.zip') ||
        (bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4B);

    if (isZip) {
      final archive = ZipDecoder().decodeBytes(bytes);
      String? jsonContent;

      final docsDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory(p.join(docsDir.path, 'pwms_media'));
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }
      final prodDir = Directory(p.join(docsDir.path, 'product_images'));
      if (!await prodDir.exists()) {
        await prodDir.create(recursive: true);
      }

      for (final archiveFile in archive) {
        if (!archiveFile.isFile) continue;

        final name = archiveFile.name;
        final baseName = p.basename(name);

        // Ignorar carpetas/archivos de metadatos del sistema de macOS (__MACOSX, ._*, .DS_Store)
        if (name.contains('__MACOSX') || baseName.startsWith('._') || baseName.startsWith('.')) {
          continue;
        }

        if (baseName == 'database.json' || (jsonContent == null && baseName.endsWith('.json'))) {
          jsonContent = utf8.decode(archiveFile.content as List<int>);
        } else if (name.startsWith('files/') || name.contains('/files/')) {
          if (baseName.isNotEmpty) {
            final content = archiveFile.content as List<int>;
            await File(p.join(mediaDir.path, baseName)).writeAsBytes(content);
            await File(p.join(prodDir.path, baseName)).writeAsBytes(content);
          }
        }
      }

      if (jsonContent == null) {
        throw Exception('El paquete ZIP no contiene un archivo database.json válido.');
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
    final rawVersion = data['version'] ?? data['schemaVersion'] ?? data['versionCheck'] ?? 1;
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

    currentData['version'] = targetVersion;
    return currentData;
  }

  Map<String, dynamic> _migrateJsonStep(Map<String, dynamic> data, {required int fromVersion, required int toVersion}) {
    final tables = Map<String, dynamic>.from(data['tables'] as Map<String, dynamic>? ?? {});

    if (fromVersion == 1 && toVersion >= 2) {
      // Migración 1 -> 2:
      // Asegurar tabla de appSettings y columnas predeterminadas agregadas en v2
      tables.putIfAbsent('appSettings', () => <Map<String, dynamic>>[]);

      final catalog = (tables['catalog'] as List? ?? []);
      final List<Map<String, dynamic>> updatedCatalog = [];
      for (var item in catalog) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent('type', () => 'Objeto');
          m.putIfAbsent('customAttributes', () => '{}');
          m.putIfAbsent('isUnique', () => false);
          m.putIfAbsent('isNonPerishable', () => true);
          updatedCatalog.add(m);
        }
      }
      tables['catalog'] = updatedCatalog;

      final speciesMagnitudes = (tables['speciesMagnitudes'] as List? ?? []);
      final List<Map<String, dynamic>> updatedSM = [];
      for (var item in speciesMagnitudes) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent('dataType', () => 'real');
          updatedSM.add(m);
        }
      }
      tables['speciesMagnitudes'] = updatedSM;

      final instanceMagnitudes = (tables['instanceMagnitudes'] as List? ?? []);
      final List<Map<String, dynamic>> updatedIM = [];
      for (var item in instanceMagnitudes) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent('dataType', () => 'real');
          m.putIfAbsent('magnitudeValue', () => 0.0);
          updatedIM.add(m);
        }
      }
      tables['instanceMagnitudes'] = updatedIM;

      final speciesRequirements = (tables['speciesRequirements'] as List? ?? []);
      final List<Map<String, dynamic>> updatedSR = [];
      for (var item in speciesRequirements) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent('sourceType', () => 'species');
          m.putIfAbsent('requiredQuantity', () => 1.0);
          updatedSR.add(m);
        }
      }
      tables['speciesRequirements'] = updatedSR;

      final notifications = (tables['notifications'] as List? ?? []);
      final List<Map<String, dynamic>> updatedNotif = [];
      for (var item in notifications) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent('status', () => 'active');
          updatedNotif.add(m);
        }
      }
      tables['notifications'] = updatedNotif;
    }

    if (fromVersion == 2 && toVersion >= 3) {
      // Migración 2 -> 3:
      // Agregar campo instanceId en la tabla de attachments
      final attachments = (tables['attachments'] as List? ?? []);
      final List<Map<String, dynamic>> updatedAtt = [];
      for (var item in attachments) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          m.putIfAbsent('instanceId', () => null);
          updatedAtt.add(m);
        }
      }
      tables['attachments'] = updatedAtt;
    }

    data['tables'] = tables;
    return data;
  }

  /// Realiza la autorreparación retroactiva de datos numismáticos y sanitización de rutas
  /// para respaldos creados en versiones previas donde dataType/stringValue no fueron exportados.
  Map<String, dynamic> _repairAndStandardizeImportedData(Map<String, dynamic> data) {
    final tables = Map<String, dynamic>.from(data['tables'] as Map<String, dynamic>? ?? {});

    // Asegurar tabla appSettings
    tables.putIfAbsent('appSettings', () => <Map<String, dynamic>>[]);

    // 1. Construir mapas de búsqueda rápida
    final catalogList = (tables['catalog'] as List? ?? []);
    final speciesMap = <String, Map<String, dynamic>>{};
    final List<Map<String, dynamic>> sanitizedCatalog = [];
    for (final c in catalogList) {
      if (c is Map) {
        final m = Map<String, dynamic>.from(c);
        if (m['mainPhotoPath'] != null) {
          m['mainPhotoPath'] = _sanitizeMediaPath(m['mainPhotoPath'].toString());
        }
        speciesMap[m['id'].toString()] = m;
        sanitizedCatalog.add(m);
      }
    }
    tables['catalog'] = sanitizedCatalog;

    final subspeciesList = (tables['subspecies'] as List? ?? []);
    final subspeciesMap = <String, Map<String, dynamic>>{};
    final List<Map<String, dynamic>> sanitizedSubspecies = [];
    for (final s in subspeciesList) {
      if (s is Map) {
        final m = Map<String, dynamic>.from(s);
        if (m['photoPath'] != null) {
          m['photoPath'] = _sanitizeMediaPath(m['photoPath'].toString());
        }
        subspeciesMap[m['id'].toString()] = m;
        sanitizedSubspecies.add(m);
      }
    }
    tables['subspecies'] = sanitizedSubspecies;

    final attachmentsList = (tables['attachments'] as List? ?? []);
    final List<Map<String, dynamic>> sanitizedAttachments = [];
    for (final a in attachmentsList) {
      if (a is Map) {
        final m = Map<String, dynamic>.from(a);
        if (m['filePath'] != null) {
          m['filePath'] = _sanitizeMediaPath(m['filePath'].toString());
        }
        sanitizedAttachments.add(m);
      }
    }
    tables['attachments'] = sanitizedAttachments;

    final entitiesList = (tables['entities'] as List? ?? []);
    final entityMap = <String, Map<String, dynamic>>{};
    for (final e in entitiesList) {
      if (e is Map) {
        final m = Map<String, dynamic>.from(e);
        entityMap[m['id'].toString()] = m;
      }
    }

    // 2. Reparar y estandarizar speciesMagnitudes
    final speciesMagnitudes = (tables['speciesMagnitudes'] as List? ?? []);
    final List<Map<String, dynamic>> updatedSM = [];
    for (final item in speciesMagnitudes) {
      if (item is Map) {
        final m = Map<String, dynamic>.from(item);
        final propName = (m['propertyName'] ?? '').toString().trim();
        var dt = m['dataType']?.toString();

        if (dt == null || dt.isEmpty || dt == 'real') {
          if (propName == 'Divisa' || propName == 'Material' || propName == 'Grado') {
            dt = 'string';
          } else if (propName == 'Acuñación' || propName == 'Año') {
            dt = 'integer';
          } else {
            dt ??= 'real';
          }
        }
        m['dataType'] = dt;
        updatedSM.add(m);
      }
    }
    tables['speciesMagnitudes'] = updatedSM;

    // 3. Reparar y estandarizar instanceMagnitudes
    final instanceMagnitudes = (tables['instanceMagnitudes'] as List? ?? []);
    final List<Map<String, dynamic>> updatedIM = [];
    for (final item in instanceMagnitudes) {
      if (item is Map) {
        final m = Map<String, dynamic>.from(item);
        final propName = (m['propertyName'] ?? '').toString().trim();
        final instId = m['instanceId']?.toString();
        var dt = m['dataType']?.toString();
        var strVal = m['stringValue']?.toString();
        var numVal = (m['magnitudeValue'] as num?)?.toDouble() ?? 0.0;
        var unit = m['unitSymbol']?.toString();

        final entity = instId != null ? entityMap[instId] : null;
        final speciesId = entity?['speciesId']?.toString();
        final species = speciesId != null ? speciesMap[speciesId] : null;
        final subspeciesId = entity?['subspeciesId']?.toString();
        final subspecies = subspeciesId != null ? subspeciesMap[subspeciesId] : null;

        if (propName == 'Divisa') {
          dt = 'string';
          unit = null;
          if (strVal == null || strVal.trim().isEmpty) {
            if (subspecies != null) {
              final subNotes = subspecies['notes']?.toString() ?? '';
              final subName = subspecies['subspeciesName']?.toString() ?? '';

              final notesMatch = RegExp(r'Moneda:\s*([^|]+)').firstMatch(subNotes);
              if (notesMatch != null) {
                strVal = notesMatch.group(1)?.trim();
              } else if (subName.isNotEmpty && subName != 'Genérica') {
                final parsed = NumismaticDataHelper.parseSubspeciesName(subName);
                strVal = parsed.currencyName;
              }
            }
          }
        } else if (propName == 'Material') {
          dt = 'string';
          unit = null;
          if (strVal == null || strVal.trim().isEmpty) {
            if (subspecies != null) {
              final subNotes = subspecies['notes']?.toString() ?? '';
              final matMatch = RegExp(r'Material:\s*([^|]+)').firstMatch(subNotes);
              final metalMatch = RegExp(r'Metal:\s*([^|]+)').firstMatch(subNotes);
              if (matMatch != null) {
                strVal = matMatch.group(1)?.trim();
              } else if (metalMatch != null) {
                strVal = metalMatch.group(1)?.trim();
              } else if (species?['name'] == 'Billete') {
                strVal = 'Papel';
              }
            } else if (species?['name'] == 'Billete') {
              strVal = 'Papel';
            }
          }
        } else if (propName == 'Grado') {
          dt = 'string';
          unit = null;
          if (strVal == null && entity?['notes'] != null) {
            final entNotes = entity!['notes'].toString();
            final gradeMatch = RegExp(r'Grado:\s*([^|\n]+)').firstMatch(entNotes);
            if (gradeMatch != null) {
              final g = gradeMatch.group(1)?.trim();
              if (g != null && g != 'No especificado' && g.isNotEmpty) {
                strVal = g;
              }
            }
          }
        } else if (propName == 'Acuñación' || propName == 'Año') {
          dt = 'integer';
          unit ??= 'año';
        } else if (propName == 'Valor nominal') {
          dt = 'real';
        } else {
          dt ??= 'real';
        }

        m['dataType'] = dt;
        m['stringValue'] = strVal;
        m['magnitudeValue'] = numVal;
        m['unitSymbol'] = unit;
        updatedIM.add(m);
      }
    }
    tables['instanceMagnitudes'] = updatedIM;

    data['tables'] = tables;
    return data;
  }

  /// Importa la base de datos a partir de una cadena JSON
  Future<void> importDatabaseFromJsonString(String jsonString) async {
    final Map<String, dynamic> rawData = jsonDecode(jsonString);
    if (!rawData.containsKey('tables')) {
      throw const FormatException('El archivo de respaldo no tiene una estructura válida.');
    }

    final migratedData = migrateImportedData(rawData, targetVersion: _db.schemaVersion);
    final tables = migratedData['tables'] as Map<String, dynamic>;

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
          dataType: Value(r['dataType'] ?? 'real'),
          unitSymbol: Value(r['unitSymbol']),
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
          dataType: Value(r['dataType'] ?? 'real'),
          magnitudeValue: Value((r['magnitudeValue'] as num?)?.toDouble() ?? 0.0),
          stringValue: Value(r['stringValue']),
          unitSymbol: Value(r['unitSymbol']),
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
          instanceId: Value(r['instanceId']),
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

      // Restaurar Configuraciones de la App
      final appSettings = (tables['appSettings'] as List? ?? []);
      for (final r in appSettings) {
        if (r is Map && r['key'] != null && r['value'] != null) {
          await _db.into(_db.appSettingsTable).insert(AppSettingsTableCompanion.insert(
            key: r['key'].toString(),
            value: r['value'].toString(),
          ));
        }
      }
    });
  }
}
