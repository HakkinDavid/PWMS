import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/units_registry.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/attachment.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/financial/infrastructure/financial_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_path_helper.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;
  late LocationRepository locationRepo;
  late FinancialRepository financialRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    catalogRepo = CatalogRepository(db);
    locationRepo = LocationRepository(db);
    financialRepo = FinancialRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PWMS MVP Architecture & Financial Ledger Tests', () {
    test('1. Catalog Species Creation & Immediate Instantiation', () async {
      final nodeA = LocationNode(id: 'node-A', name: 'Garaje', createdAt: DateTime.now());
      await locationRepo.saveNode(nodeA);

      final species = await catalogRepo.getOrCreateSpecies('Multímetro Fluke 87V', type: 'Objeto');
      final instance = await entityRepo.instantiateOrMerge(species.id, 'node-A', 1);

      expect(instance.speciesId, equals(species.id));
      expect(instance.locationId, equals('node-A'));

      final allNodes = await locationRepo.getAllNodes();
      final breadcrumb = LocationPathHelper.buildBreadcrumbPath('node-A', allNodes);
      expect(breadcrumb.targetName, equals('Garaje'));
    });

    test('2. Attachment Deduplication Rule', () async {
      final species = await catalogRepo.getOrCreateSpecies('Manual Técnico', type: 'Documento');
      final att1 = Attachment(
        id: 'att-1',
        speciesId: species.id,
        filePath: 'docs/manual.pdf',
        fileName: 'manual.pdf',
        fileType: 'pdf',
        createdAt: DateTime.now(),
      );
      await entityRepo.addAttachment(att1);

      final attDup = Attachment(
        id: 'att-2',
        speciesId: species.id,
        filePath: 'docs/manual.pdf',
        fileName: 'manual.pdf',
        fileType: 'pdf',
        createdAt: DateTime.now(),
      );

      expect(() async => await entityRepo.addAttachment(attDup), throwsA(isA<Exception>()));
    });

    test('3. Financial Ledger Transaction Recording', () async {
      final species = await catalogRepo.getOrCreateSpecies('Impresora 3D', type: 'Objeto');
      await financialRepo.recordTransaction(
        speciesId: species.id,
        transactionType: 'instantiation',
        magnitudeDelta: 1,
        amount: 8500.0,
        currency: 'MXN',
        notes: 'Compra inicial',
      );

      final txs = await financialRepo.getTransactionsForSpecies(species.id);
      expect(txs.length, equals(1));
      expect(txs.first.amount, equals(8500.0));
      expect(txs.first.currency, equals('MXN'));
    });

    test('4. SI Units Decimal Rule Verification', () {
      expect(UnitsRegistry.allowsDecimals('pieza'), isFalse);
      expect(UnitsRegistry.allowsDecimals('unidad'), isFalse);
      expect(UnitsRegistry.allowsDecimals('kg'), isTrue);
      expect(UnitsRegistry.allowsDecimals('m'), isTrue);
    });
  });
}
