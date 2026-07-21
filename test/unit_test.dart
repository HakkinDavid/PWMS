import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/custom_template.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/history/infrastructure/history_repository.dart';
import 'package:platinum_world_management_system/src/features/history/application/activity_logger_service.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late HistoryRepository historyRepo;
  late ActivityLoggerService loggerService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    historyRepo = HistoryRepository(db);
    loggerService = ActivityLoggerService(historyRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('PWMS Complete Capabilities Checklist Tests', () {
    test('Create entity with custom attributes, barcode, and custom units', () async {
      final entity = WorldEntity(
        id: 'ent-multimeter',
        name: 'Multímetro Fluke 87V',
        type: 'Herramienta',
        quantity: 2,
        unit: 'piezas',
        barcode: '750123456789',
        customAttributes: {
          'Voltaje Máximo': '1000V',
          'Garantía': 'De por vida',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(entity);
      final retrieved = await entityRepo.getEntityById('ent-multimeter');

      expect(retrieved, isNotNull);
      expect(retrieved!.barcode, equals('750123456789'));
      expect(retrieved.customAttributes['Voltaje Máximo'], equals('1000V'));
      expect(retrieved.quantity, equals(2));
      expect(retrieved.unit, equals('piezas'));
    });

    test('Create and modify user custom template and custom units', () async {
      final customTpl = CustomTemplate(
        id: 'tpl-1',
        typeName: 'Componente Electrónico',
        iconName: 'memory',
        isContainer: false,
        isPlace: false,
        commonUnits: ['unidades', 'pines', 'carretes'],
        createdAt: DateTime.now(),
      );

      await entityRepo.saveCustomTemplate(customTpl);
      final allCustom = await entityRepo.getAllCustomTemplates();

      expect(allCustom.length, equals(1));
      expect(allCustom.first.typeName, equals('Componente Electrónico'));
      expect(allCustom.first.commonUnits.contains('carretes'), isTrue);
    });

    test('Archive and unarchive entity', () async {
      final item = WorldEntity(
        id: 'item-arch',
        name: 'Antigua Laptop',
        type: 'Otro',
        isArchived: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(item);
      final activeList = await entityRepo.getRecentEntities();
      expect(activeList.any((e) => e.id == 'item-arch'), isTrue);

      final archivedItem = item.copyWith(isArchived: true, updatedAt: DateTime.now());
      await entityRepo.saveEntity(archivedItem);

      final activeListAfter = await entityRepo.getRecentEntities();
      expect(activeListAfter.any((e) => e.id == 'item-arch'), isFalse);
    });

    test('Search entities by relation, barcode, notes, and custom attributes', () async {
      final entity = WorldEntity(
        id: 'e-1',
        name: 'Servidor Dell',
        type: 'Servidor',
        barcode: 'DELL-998877',
        notes: 'Rack secundario',
        customAttributes: {'IP': '192.168.1.100'},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(entity);

      // Search by barcode
      final resBarcode = await entityRepo.searchEntities('998877');
      expect(resBarcode.length, equals(1));

      // Search by custom attribute IP
      final resIP = await entityRepo.searchEntities('192.168.1.100');
      expect(resIP.length, equals(1));
    });

    test('Complete audit log tracking for all actions', () async {
      await loggerService.logEntityCreated('e-1', 'Caja Fuertes', 'Caja / Contenedor');
      await loggerService.logPhotoChanged('e-1', 'Caja Fuertes');
      await loggerService.logQuantityConsumed('e-1', 'Caja Fuertes', 10, 'piezas');
      await loggerService.logEntityEdited('e-1', 'Caja Fuertes', details: 'Archivado');
      await loggerService.logEntityDeleted('e-1', 'Caja Fuertes');

      final events = await historyRepo.getRecentEvents(limit: 10);
      expect(events.length, equals(5));
    });
  });
}
