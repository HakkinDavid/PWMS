import 'dart:convert';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/database/database_backup_service.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';

class FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  final String tempPath;
  final String docsPath;

  FakePathProviderPlatform({required this.tempPath, required this.docsPath});

  @override
  Future<String?> getTemporaryPath() async => tempPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => docsPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DatabaseBackupService backupService;
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('numismatic_recovery_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );

    db = AppDatabase(NativeDatabase.memory());
    backupService = DatabaseBackupService(db);
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Numismatic Backup Recovery and Retroactive Repair Tests', () {
    test('Correctly recovers Material, Divisa, Acuñación and cleans Grado from legacy backup without stringValue/dataType', () async {
      // Simulate exact structure of pwms_backup_2026-08-10T01-49-21-034660 where
      // dataType was omitted and stringValue was missing, leaving magnitudeValue = 0.0
      final legacyBackupMap = {
        'version': 3,
        'exportedAt': '2026-08-10T01:49:16.458466',
        'tables': {
          'locations': [
            {
              'id': 'loc-1',
              'name': 'Colección Numismática',
              'parentLocationId': null,
              'description': 'Álbum',
              'icon': 'album',
              'createdAt': '2026-08-09T22:00:00.000',
            }
          ],
          'catalog': [
            {
              'id': 'species-moneda',
              'name': 'Moneda',
              'type': 'Objeto',
              'description': 'Especie para piezas numismáticas (Moneda)',
              'mainPhotoPath': 'coin_main.jpg',
              'customAttributes': '{}',
              'isUnique': false,
              'isNonPerishable': true,
              'defaultShelfLifeDays': null,
              'warningDaysBeforeExpiration': null,
              'createdAt': '2026-08-09T22:40:00.000',
            },
            {
              'id': 'species-billete',
              'name': 'Billete',
              'type': 'Objeto',
              'description': 'Especie para piezas numismáticas (Billete)',
              'mainPhotoPath': 'bill_main.jpg',
              'customAttributes': '{}',
              'isUnique': false,
              'isNonPerishable': true,
              'defaultShelfLifeDays': null,
              'warningDaysBeforeExpiration': null,
              'createdAt': '2026-08-09T22:43:00.000',
            }
          ],
          'subspecies': [
            {
              'id': 'sub-coin-1',
              'speciesId': 'species-moneda',
              'subspeciesName': '10 Pesos Mexicanos - México (2023)',
              'brand': null,
              'barcode': null,
              'photoPath': 'sub_coin.jpg',
              'notes': 'Moneda: Pesos Mexicanos | Año: 2023 | Material: Bimetálica',
              'createdAt': '2026-08-09T22:40:00.000',
            },
            {
              'id': 'sub-bill-1',
              'speciesId': 'species-billete',
              'subspeciesName': '100 Pesos Mexicanos - México (2020)',
              'brand': null,
              'barcode': null,
              'photoPath': 'sub_bill.jpg',
              'notes': 'Moneda: Pesos Mexicanos | Año: 2020 | Material: Papel',
              'createdAt': '2026-08-09T22:43:00.000',
            }
          ],
          'speciesMagnitudes': [
            {'id': 'sm-1', 'speciesId': 'species-moneda', 'propertyName': 'Valor nominal', 'unitSymbol': null, 'createdAt': '2026-08-09T22:40:00.000'},
            {'id': 'sm-2', 'speciesId': 'species-moneda', 'propertyName': 'Acuñación', 'unitSymbol': 'año', 'createdAt': '2026-08-09T22:40:00.000'},
            {'id': 'sm-3', 'speciesId': 'species-moneda', 'propertyName': 'Divisa', 'unitSymbol': null, 'createdAt': '2026-08-09T22:40:00.000'},
            {'id': 'sm-4', 'speciesId': 'species-moneda', 'propertyName': 'Material', 'unitSymbol': null, 'createdAt': '2026-08-09T22:40:00.000'},
            {'id': 'sm-5', 'speciesId': 'species-moneda', 'propertyName': 'Grado', 'unitSymbol': null, 'createdAt': '2026-08-09T22:40:00.000'},
            {'id': 'sm-6', 'speciesId': 'species-billete', 'propertyName': 'Valor nominal', 'unitSymbol': null, 'createdAt': '2026-08-09T22:43:00.000'},
            {'id': 'sm-7', 'speciesId': 'species-billete', 'propertyName': 'Acuñación', 'unitSymbol': 'año', 'createdAt': '2026-08-09T22:43:00.000'},
            {'id': 'sm-8', 'speciesId': 'species-billete', 'propertyName': 'Divisa', 'unitSymbol': null, 'createdAt': '2026-08-09T22:43:00.000'},
            {'id': 'sm-9', 'speciesId': 'species-billete', 'propertyName': 'Material', 'unitSymbol': null, 'createdAt': '2026-08-09T22:43:00.000'},
            {'id': 'sm-10', 'speciesId': 'species-billete', 'propertyName': 'Grado', 'unitSymbol': null, 'createdAt': '2026-08-09T22:43:00.000'},
          ],
          'entities': [
            {
              'id': 'ent-coin-1',
              'speciesId': 'species-moneda',
              'subspeciesId': 'sub-coin-1',
              'locationId': 'loc-1',
              'expirationDate': null,
              'notes': null,
              'createdAt': '2026-08-09T22:40:00.000',
              'updatedAt': '2026-08-09T22:40:00.000',
            },
            {
              'id': 'ent-bill-1',
              'speciesId': 'species-billete',
              'subspeciesId': 'sub-bill-1',
              'locationId': 'loc-1',
              'expirationDate': null,
              'notes': 'Edición especial: Aniversario',
              'createdAt': '2026-08-09T22:43:00.000',
              'updatedAt': '2026-08-09T22:43:00.000',
            }
          ],
          'instanceMagnitudes': [
            {'id': 'im-1', 'instanceId': 'ent-coin-1', 'propertyName': 'Valor nominal', 'magnitudeValue': 10.0, 'unitSymbol': null},
            {'id': 'im-2', 'instanceId': 'ent-coin-1', 'propertyName': 'Acuñación', 'magnitudeValue': 2023.0, 'unitSymbol': 'año'},
            {'id': 'im-3', 'instanceId': 'ent-coin-1', 'propertyName': 'Divisa', 'magnitudeValue': 0.0, 'unitSymbol': null},
            {'id': 'im-4', 'instanceId': 'ent-coin-1', 'propertyName': 'Material', 'magnitudeValue': 0.0, 'unitSymbol': null},
            {'id': 'im-5', 'instanceId': 'ent-coin-1', 'propertyName': 'Grado', 'magnitudeValue': 0.0, 'unitSymbol': null},
            {'id': 'im-6', 'instanceId': 'ent-bill-1', 'propertyName': 'Valor nominal', 'magnitudeValue': 100.0, 'unitSymbol': null},
            {'id': 'im-7', 'instanceId': 'ent-bill-1', 'propertyName': 'Acuñación', 'magnitudeValue': 2020.0, 'unitSymbol': 'año'},
            {'id': 'im-8', 'instanceId': 'ent-bill-1', 'propertyName': 'Divisa', 'magnitudeValue': 0.0, 'unitSymbol': null},
            {'id': 'im-9', 'instanceId': 'ent-bill-1', 'propertyName': 'Material', 'magnitudeValue': 0.0, 'unitSymbol': null},
            {'id': 'im-10', 'instanceId': 'ent-bill-1', 'propertyName': 'Grado', 'magnitudeValue': 0.0, 'unitSymbol': null},
          ],
          'instanceLocations': [],
          'relations': [],
          'attachments': [],
          'historyEvents': [],
          'customTemplates': [],
          'speciesRequirements': [],
          'notifications': [],
        }
      };

      await backupService.importDatabaseFromJsonString(jsonEncode(legacyBackupMap));

      // 1. Check Species Magnitudes dataType repaired
      final speciesMags = await db.select(db.speciesMagnitudesTable).get();
      final smDivisa = speciesMags.firstWhere((s) => s.propertyName == 'Divisa');
      expect(smDivisa.dataType, equals('string'));

      final smMaterial = speciesMags.firstWhere((s) => s.propertyName == 'Material');
      expect(smMaterial.dataType, equals('string'));

      final smGrado = speciesMags.firstWhere((s) => s.propertyName == 'Grado');
      expect(smGrado.dataType, equals('string'));

      final smAcunacion = speciesMags.firstWhere((s) => s.propertyName == 'Acuñación');
      expect(smAcunacion.dataType, equals('integer'));

      // 2. Check Instance Magnitudes repaired for Coin (Moneda)
      final coinMags = await (db.select(db.instanceMagnitudesTable)..where((t) => t.instanceId.equals('ent-coin-1'))).get();

      final coinMaterial = coinMags.firstWhere((m) => m.propertyName == 'Material');
      expect(coinMaterial.dataType, equals('string'));
      expect(coinMaterial.stringValue, equals('Bimetálica'));

      final coinDivisa = coinMags.firstWhere((m) => m.propertyName == 'Divisa');
      expect(coinDivisa.dataType, equals('string'));
      expect(coinDivisa.stringValue, equals('MXN'));

      final coinGrado = coinMags.firstWhere((m) => m.propertyName == 'Grado');
      expect(coinGrado.dataType, equals('string'));
      expect(coinGrado.stringValue, isNull);

      final coinAcunacion = coinMags.firstWhere((m) => m.propertyName == 'Acuñación');
      expect(coinAcunacion.dataType, equals('integer'));
      expect(coinAcunacion.magnitudeValue, equals(2023.0));

      // Test InstanceMagnitude displayValue behavior:
      // Material must NOT format as '0'
      final instMagMaterial = InstanceMagnitude(
        id: coinMaterial.id,
        instanceId: coinMaterial.instanceId,
        propertyName: coinMaterial.propertyName,
        dataType: coinMaterial.dataType,
        magnitudeValue: coinMaterial.magnitudeValue,
        stringValue: coinMaterial.stringValue,
        unitSymbol: coinMaterial.unitSymbol,
      );
      expect(instMagMaterial.displayValue, equals('Bimetálica'));

      // Grado must NOT format as '0', should return ''
      final instMagGrado = InstanceMagnitude(
        id: coinGrado.id,
        instanceId: coinGrado.instanceId,
        propertyName: coinGrado.propertyName,
        dataType: coinGrado.dataType,
        magnitudeValue: coinGrado.magnitudeValue,
        stringValue: coinGrado.stringValue,
        unitSymbol: coinGrado.unitSymbol,
      );
      expect(instMagGrado.displayValue, equals(''));

      // 3. Check Instance Magnitudes repaired for Banknote (Billete)
      final billMags = await (db.select(db.instanceMagnitudesTable)..where((t) => t.instanceId.equals('ent-bill-1'))).get();

      final billMaterial = billMags.firstWhere((m) => m.propertyName == 'Material');
      expect(billMaterial.dataType, equals('string'));
      expect(billMaterial.stringValue, equals('Papel'));

      final billDivisa = billMags.firstWhere((m) => m.propertyName == 'Divisa');
      expect(billDivisa.dataType, equals('string'));
      expect(billDivisa.stringValue, equals('MXN'));

      final billAcunacion = billMags.firstWhere((m) => m.propertyName == 'Acuñación');
      expect(billAcunacion.dataType, equals('integer'));
      expect(billAcunacion.magnitudeValue, equals(2020.0));
    });

    test('Imports actual pwms_backup_2026-08-10T01-49-21-034660.zip and restores all 34 numismatic pieces with zero errors', () async {
      final backupZipFile = File('pwms_backup_2026-08-10T01-49-21-034660.zip');
      if (!backupZipFile.existsSync()) {
        return; // Skip if backup file is not in working dir
      }

      await backupService.importDatabaseFromFile(backupZipFile);

      // Verify all 81 catalog items restored
      final catalog = await db.select(db.catalogTable).get();
      expect(catalog.length, equals(81));

      // Verify Moneda and Billete exist
      final monedaSpecies = catalog.firstWhere((c) => c.name == 'Moneda');
      final billeteSpecies = catalog.firstWhere((c) => c.name == 'Billete');
      expect(monedaSpecies, isNotNull);
      expect(billeteSpecies, isNotNull);

      // Verify all 18 subspecies for Moneda/Billete
      final subspecies = await db.select(db.subspeciesTable).get();
      final numisSubspecies = subspecies.where((s) => s.speciesId == monedaSpecies.id || s.speciesId == billeteSpecies.id).toList();
      expect(numisSubspecies.length, equals(18));

      // Verify all 34 entities for Moneda/Billete
      final entities = await db.select(db.entitiesTable).get();
      final numisEntities = entities.where((e) => e.speciesId == monedaSpecies.id || e.speciesId == billeteSpecies.id).toList();
      expect(numisEntities.length, equals(34));

      // Verify all 170 instance magnitudes for numismatics
      final allInstMags = await db.select(db.instanceMagnitudesTable).get();
      final numisEntityIds = numisEntities.map((e) => e.id).toSet();
      final numisMags = allInstMags.where((m) => numisEntityIds.contains(m.instanceId)).toList();
      expect(numisMags.length, equals(170));

      // Verify each numismatic instance has Material and Divisa correctly restored with non-zero strings
      for (final entity in numisEntities) {
        final magsForEnt = numisMags.where((m) => m.instanceId == entity.id).toList();
        
        final matMag = magsForEnt.firstWhere((m) => m.propertyName == 'Material');
        expect(matMag.dataType, equals('string'));
        expect(matMag.stringValue, isNotNull);
        expect(matMag.stringValue!.isNotEmpty, isTrue);
        expect(matMag.stringValue != '0', isTrue);

        final divMag = magsForEnt.firstWhere((m) => m.propertyName == 'Divisa');
        expect(divMag.dataType, equals('string'));
        expect(divMag.stringValue, isNotNull);
        expect(divMag.stringValue!.isNotEmpty, isTrue);
        expect(divMag.stringValue != '0', isTrue);

        final gradeMag = magsForEnt.firstWhere((m) => m.propertyName == 'Grado');
        expect(gradeMag.dataType, equals('string'));

        final yearMag = magsForEnt.firstWhere((m) => m.propertyName == 'Acuñación');
        expect(yearMag.dataType, equals('integer'));
        expect(yearMag.unitSymbol, equals('año'));
      }
    });
  });
}
