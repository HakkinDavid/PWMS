import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/storage/file_storage_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/split_subspecies_modal.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/history/application/activity_logger_service.dart';
import 'package:platinum_world_management_system/src/features/history/infrastructure/history_repository.dart';

class MockFileStorageService implements FileStorageService {
  @override
  Future<String> getAbsolutePath(String relativePath) async => relativePath;

  @override
  Future<String> saveFile(String sourcePath) async => sourcePath;

  @override
  Future<String> saveBytes(List<int> bytes, {String extension = '.jpg'}) async => 'saved_file$extension';

  @override
  Future<bool> fileExists(String relativeOrAbsolutePath) async => false;

  @override
  Future<void> deleteFile(String relativeOrAbsolutePath) async {}
}

void main() {
  late AppDatabase db;
  late CatalogRepository catalogRepo;
  late EntityRepository entityRepo;
  late HistoryRepository historyRepo;
  late ActivityLoggerService activityLogger;
  late MockFileStorageService fileStorageService;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );
    db = AppDatabase(NativeDatabase.memory());
    historyRepo = HistoryRepository(db);
    activityLogger = ActivityLoggerService(historyRepo);
    catalogRepo = CatalogRepository(db, null, activityLogger);
    entityRepo = EntityRepository(db, null, activityLogger);
    fileStorageService = MockFileStorageService();
  });

  tearDown(() async {
    await db.close();
  });

  group('Split Subspecies Feature Tests', () {
    test('1. Repository logic: splitSubspecies creates copy subspecies and reassigns selected entities', () async {
      final species = CatalogItem(
        id: 'species-cereal',
        name: 'Cereal',
        type: 'Alimento',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final originalSub = Subspecies(
        id: 'sub-chocokrispis-orig',
        speciesId: species.id,
        subspeciesName: 'Choco Krispis 500g',
        brand: 'Kelloggs',
        barcode: '750100804',
        photoPath: 'photo_krispis.jpg',
        notes: 'Versión estándar',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(originalSub);

      final inst1 = WorldEntity(
        id: 'inst-1',
        speciesId: species.id,
        subspeciesId: originalSub.id,
        locationId: null,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final inst2 = WorldEntity(
        id: 'inst-2',
        speciesId: species.id,
        subspeciesId: originalSub.id,
        locationId: null,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final inst3 = WorldEntity(
        id: 'inst-3',
        speciesId: species.id,
        subspeciesId: originalSub.id,
        locationId: null,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await entityRepo.saveEntity(inst1);
      await entityRepo.saveEntity(inst2);
      await entityRepo.saveEntity(inst3);

      final newSub = Subspecies(
        id: 'sub-chocokrispis-promo',
        speciesId: species.id,
        subspeciesName: 'Choco Krispis 500g (Promoción)',
        brand: 'Kelloggs',
        barcode: '750100809',
        photoPath: 'photo_krispis_promo.jpg',
        notes: 'Incluye juguete',
        createdAt: DateTime.now(),
      );

      final result = await catalogRepo.splitSubspecies(
        sourceSubspecies: originalSub,
        newSubspecies: newSub,
        entityIdsToMove: [inst1.id, inst2.id],
      );

      expect(result.id, equals('sub-chocokrispis-promo'));
      expect(result.subspeciesName, equals('Choco Krispis 500g (Promoción)'));

      final allSubs = await catalogRepo.getSubspeciesForSpecies(species.id);
      expect(allSubs.length, equals(2));

      final updatedInst1 = await entityRepo.getEntityById(inst1.id);
      final updatedInst2 = await entityRepo.getEntityById(inst2.id);
      final updatedInst3 = await entityRepo.getEntityById(inst3.id);

      expect(updatedInst1?.subspeciesId, equals(newSub.id));
      expect(updatedInst2?.subspeciesId, equals(newSub.id));
      expect(updatedInst3?.subspeciesId, equals(originalSub.id));

      final historyEvents = await historyRepo.getAllEvents();
      final splitEvent = historyEvents.where((e) => e.eventType == AppTechnicalStrings.eventTypeSubspeciesSplit).firstOrNull;
      expect(splitEvent, isNotNull);
      expect(splitEvent!.metadata![AppTechnicalStrings.keyMovedCount], equals(2));
    });

    testWidgets('2. SplitSubspeciesModal UI: displays prefilled fields and toggles instances selection', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'species-phone',
        name: 'Smartphone',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final originalSub = Subspecies(
        id: 'sub-phone-black',
        speciesId: species.id,
        subspeciesName: 'Modelo X Negro',
        brand: 'TechCorp',
        barcode: '998877',
        notes: 'Color negro mate',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(originalSub);

      final inst1 = WorldEntity(
        id: 'phone-inst-1',
        speciesId: species.id,
        subspeciesId: originalSub.id,
        locationId: null,
        magnitudes: const [],
        notes: 'Instancia A',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final inst2 = WorldEntity(
        id: 'phone-inst-2',
        speciesId: species.id,
        subspeciesId: originalSub.id,
        locationId: null,
        magnitudes: const [],
        notes: 'Instancia B',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(inst1);
      await entityRepo.saveEntity(inst2);

      Subspecies? splitResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
            activityLoggerServiceProvider.overrideWithValue(activityLogger),
            catalogListProvider.overrideWith((ref) => CatalogListNotifier(catalogRepo)),
            entityListProvider.overrideWith((ref) => EntityListNotifier(entityRepo)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    splitResult = await SplitSubspeciesModal.show(
                      context,
                      species: species,
                      sourceSubspecies: originalSub,
                    );
                  },
                  child: const Text('Open Split Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Split Modal'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.splitSubspeciesDialogTitle), findsNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, AppStrings.splitSubspeciesAction), findsOneWidget);
      expect(find.text(AppStrings.splitSubspeciesDefaultName(originalSub.subspeciesName)), findsOneWidget);
      expect(find.text('TechCorp'), findsOneWidget);
      expect(find.text('998877'), findsOneWidget);
      expect(find.text('Color negro mate'), findsOneWidget);

      expect(find.text(AppStrings.selectAllAction), findsOneWidget);
      expect(find.text(AppStrings.deselectAllAction), findsOneWidget);

      await tester.ensureVisible(find.text(AppStrings.selectAllAction));
      await tester.tap(find.text(AppStrings.selectAllAction));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.instancesToTransferTitle(2, 2)), findsOneWidget);

      await tester.ensureVisible(find.text(AppStrings.deselectAllAction));
      await tester.tap(find.text(AppStrings.deselectAllAction));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.instancesToTransferTitle(0, 2)), findsOneWidget);

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(2));
      await tester.ensureVisible(checkboxes.first);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.instancesToTransferTitle(1, 2)), findsOneWidget);

      final nameField = find.widgetWithText(TextField, AppStrings.splitSubspeciesDefaultName(originalSub.subspeciesName));
      await tester.ensureVisible(nameField);
      await tester.enterText(nameField, 'Modelo X Blanco');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.splitSubspeciesAction));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      expect(splitResult, isNotNull);
      expect(splitResult?.subspeciesName, equals('Modelo X Blanco'));

      final allSubs = await catalogRepo.getSubspeciesForSpecies(species.id);
      expect(allSubs.length, equals(2));

      final updatedInst1 = await entityRepo.getEntityById(inst1.id);
      final updatedInst2 = await entityRepo.getEntityById(inst2.id);
      expect(updatedInst1?.subspeciesId, equals(splitResult?.id));
      expect(updatedInst2?.subspeciesId, equals(originalSub.id));
    });

    testWidgets('3. SplitSubspeciesModal UI with 0 instances shows notice and creates copy', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'species-pen',
        name: 'Bolígrafo',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final originalSub = Subspecies(
        id: 'sub-pen-blue',
        speciesId: species.id,
        subspeciesName: 'Tinta Azul',
        brand: 'Bic',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(originalSub);

      Subspecies? splitResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
            activityLoggerServiceProvider.overrideWithValue(activityLogger),
            catalogListProvider.overrideWith((ref) => CatalogListNotifier(catalogRepo)),
            entityListProvider.overrideWith((ref) => EntityListNotifier(entityRepo)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    splitResult = await SplitSubspeciesModal.show(
                      context,
                      species: species,
                      sourceSubspecies: originalSub,
                    );
                  },
                  child: const Text('Open Modal 0 Instances'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal 0 Instances'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.noInstancesToTransferNotice), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.splitSubspeciesAction));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      expect(splitResult, isNotNull);
      expect(splitResult?.subspeciesName, equals(AppStrings.splitSubspeciesDefaultName(originalSub.subspeciesName)));

      final allSubs = await catalogRepo.getSubspeciesForSpecies(species.id);
      expect(allSubs.length, equals(2));
    });
  });
}
