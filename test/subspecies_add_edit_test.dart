import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/storage/file_storage_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/add_edit_subspecies_modal.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/species_form_modal.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/subspecies_section_widget.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

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
  late MockFileStorageService fileStorageService;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );
    db = AppDatabase(NativeDatabase.memory());
    catalogRepo = CatalogRepository(db);
    fileStorageService = MockFileStorageService();
  });

  tearDown(() async {
    await db.close();
  });

  group('AddEditSubspecies & Draft Subspecies Flow Tests', () {
    testWidgets('1. AddEditSubspeciesModal returns updated text and photo when editing subspecies', (tester) async {
      final species = CatalogItem(
        id: 'species-tv',
        name: 'Televisor',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );

      final initialSub = Subspecies(
        id: 'sub-1',
        speciesId: species.id,
        subspeciesName: 'Modelo Antiguo',
        brand: 'Sony',
        barcode: '111111',
        photoPath: 'old_photo.jpg',
        notes: 'Nota vieja',
        createdAt: DateTime.now(),
      );

      Subspecies? savedResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    savedResult = await AddEditSubspeciesModal.show(
                      context,
                      species: species,
                      initialSubspecies: initialSub,
                    );
                  },
                  child: const Text('Open Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open Modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.editSubspecies), findsOneWidget);
      expect(find.text('Modelo Antiguo'), findsOneWidget);
      expect(find.text('Sony'), findsOneWidget);

      // Modify text fields
      final nameField = find.widgetWithText(TextField, 'Modelo Antiguo');
      await tester.enterText(nameField, 'Bravia XR 4K');

      final brandField = find.widgetWithText(TextField, 'Sony');
      await tester.enterText(brandField, 'Sony Electronics');

      final barcodeField = find.widgetWithText(TextField, '111111');
      await tester.enterText(barcodeField, '999888777');

      final notesField = find.widgetWithText(TextField, 'Nota vieja');
      await tester.enterText(notesField, 'Panel OLED 120Hz');

      // Click Guardar
      await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(savedResult, isNotNull);
      expect(savedResult!.id, equals('sub-1'));
      expect(savedResult!.speciesId, equals('species-tv'));
      expect(savedResult!.subspeciesName, equals('Bravia XR 4K'));
      expect(savedResult!.brand, equals('Sony Electronics'));
      expect(savedResult!.barcode, equals('999888777'));
      expect(savedResult!.notes, equals('Panel OLED 120Hz'));
      expect(savedResult!.photoPath, equals('old_photo.jpg'));
    });

    testWidgets('2. AddEditSubspeciesModal validates empty name and shows restriction', (tester) async {
      final species = CatalogItem(
        id: 'species-tv',
        name: 'Televisor',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );

      Subspecies? savedResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    savedResult = await AddEditSubspeciesModal.show(
                      context,
                      species: species,
                    );
                  },
                  child: const Text('Open Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open Modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Enter only whitespace
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, '   ');

      // Click Guardar
      await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar'));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Modal should still be open and savedResult remains null
      expect(find.byType(AddEditSubspeciesModal), findsOneWidget);
      expect(savedResult, isNull);
    });

    test('3. Species creation with draft subspecies preserves foreign key integrity without default generic', () async {
      final species = CatalogItem(
        id: 'sp-new-audio',
        name: 'Audífonos Bluetooth',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );

      // First persist species
      await catalogRepo.saveCatalogItem(species);

      // Verify no generic subspecies was automatically created
      final initialSubs = await catalogRepo.getSubspeciesForSpecies(species.id);
      expect(initialSubs.isEmpty, isTrue);

      // Save custom draft subspecies
      final draftSub1 = Subspecies(
        id: 'sub-audio-1',
        speciesId: species.id,
        subspeciesName: 'WH-1000XM5',
        brand: 'Sony',
        barcode: '750123456789',
        photoPath: 'sony_xm5.jpg',
        createdAt: DateTime.now(),
      );

      final draftSub2 = Subspecies(
        id: 'sub-audio-2',
        speciesId: species.id,
        subspeciesName: 'AirPods Max',
        brand: 'Apple',
        barcode: '750987654321',
        photoPath: 'airpods_max.jpg',
        createdAt: DateTime.now(),
      );

      await catalogRepo.saveSubspecies(draftSub1);
      await catalogRepo.saveSubspecies(draftSub2);

      final finalSubs = await catalogRepo.getSubspeciesForSpecies(species.id);
      expect(finalSubs.length, equals(2));
      expect(finalSubs.any((s) => s.subspeciesName == 'WH-1000XM5' && s.brand == 'Sony'), isTrue);
      expect(finalSubs.any((s) => s.subspeciesName == 'AirPods Max' && s.brand == 'Apple'), isTrue);
      expect(finalSubs.any((s) => s.subspeciesName == 'Genérica'), isFalse);
    });

    testWidgets('4. SubspeciesSectionWidget renders list and updates reactively', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'sp-watch',
        name: 'Reloj',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );

      await catalogRepo.saveCatalogItem(species);

      final sub1 = Subspecies(
        id: 'sub-watch-1',
        speciesId: species.id,
        subspeciesName: 'G-Shock GA-2100',
        brand: 'Casio',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub1);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(EntityRepository(db)),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SubspeciesSectionWidget(
                  speciesId: species.id,
                  isEditing: true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('G-Shock GA-2100'), findsOneWidget);
      expect(find.text(AppStrings.addSubspeciesTab), findsOneWidget);
    });

    testWidgets('5. SpeciesFormModal prompts warning dialog when saving without subspecies, aborts if cancelled', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(EntityRepository(db)),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SpeciesFormModal(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter species name
      final nameField = find.widgetWithText(TextField, AppStrings.nameLabel);
      await tester.enterText(nameField, 'Cafetera');

      // Click Guardar button
      final saveBtn = find.widgetWithText(ElevatedButton, AppStrings.saveSpeciesAction);
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Warning dialog should appear
      expect(find.text(AppStrings.noSubspeciesWarningTitle), findsOneWidget);
      expect(find.text(AppStrings.noSubspeciesWarningMessage), findsOneWidget);

      // Tap Cancelar on the dialog
      await tester.tap(find.widgetWithText(TextButton, AppStrings.cancel));
      await tester.pumpAndSettle();

      // Verify no species or subspecies were saved
      final allSpecies = await catalogRepo.getAllCatalogItems();
      expect(allSpecies.isEmpty, isTrue);
      final allSubs = await catalogRepo.getAllSubspecies();
      expect(allSubs.isEmpty, isTrue);

      // Form is still open
      expect(find.byType(SpeciesFormModal), findsOneWidget);
    });

    testWidgets('6. SpeciesFormModal prompts warning dialog and creates Genérica in payload when confirmed', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(EntityRepository(db)),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SpeciesFormModal(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter species name
      final nameField = find.widgetWithText(TextField, AppStrings.nameLabel);
      await tester.enterText(nameField, 'Cafetera Expresso');

      // Click Guardar button
      final saveBtn = find.widgetWithText(ElevatedButton, AppStrings.saveSpeciesAction);
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Warning dialog appears
      expect(find.text(AppStrings.noSubspeciesWarningTitle), findsOneWidget);
      expect(find.text(AppStrings.noSubspeciesWarningMessage), findsOneWidget);

      // Tap Confirmar on the dialog
      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
      await tester.pumpAndSettle();

      // Verify species and Genérica subspecies were saved
      final allSpecies = await catalogRepo.getAllCatalogItems();
      expect(allSpecies.length, equals(1));
      expect(allSpecies.first.name, equals('Cafetera Expresso'));

      final allSubs = await catalogRepo.getSubspeciesForSpecies(allSpecies.first.id);
      expect(allSubs.length, equals(1));
      expect(allSubs.first.subspeciesName, equals('Genérica'));
    });

    testWidgets('7. SpeciesFormModal saves directly with draft subspecies without showing warning dialog', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(EntityRepository(db)),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SpeciesFormModal(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter species name
      final nameField = find.widgetWithText(TextField, AppStrings.nameLabel);
      await tester.enterText(nameField, 'Monitor Gamer');

      // Scroll to and tap Añadir subespecie
      final addSubFinder = find.text(AppStrings.addBrandAction);
      await tester.scrollUntilVisible(addSubFinder, 100, scrollable: find.byType(Scrollable).first);
      await tester.tap(addSubFinder);
      await tester.pumpAndSettle();

      // Enter subspecies details in modal
      final subNameField = find.widgetWithText(TextField, AppStrings.subspeciesNameLabel);
      await tester.enterText(subNameField, 'Odyssey G9');

      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.save));
      await tester.pumpAndSettle();

      // Click Guardar button on species form
      final saveBtnFinder = find.widgetWithText(ElevatedButton, AppStrings.saveSpeciesAction);
      await tester.scrollUntilVisible(saveBtnFinder, 100, scrollable: find.byType(Scrollable).first);
      await tester.tap(saveBtnFinder);
      await tester.pumpAndSettle();

      // Dialog should NOT have appeared
      expect(find.text(AppStrings.noSubspeciesWarningTitle), findsNothing);

      // Verify species and only custom subspecies were saved
      final allSpecies = await catalogRepo.getAllCatalogItems();
      expect(allSpecies.length, equals(1));
      expect(allSpecies.first.name, equals('Monitor Gamer'));

      final allSubs = await catalogRepo.getSubspeciesForSpecies(allSpecies.first.id);
      expect(allSubs.length, equals(1));
      expect(allSubs.first.subspeciesName, equals('Odyssey G9'));
      expect(allSubs.any((s) => s.subspeciesName == 'Genérica'), isFalse);
    });
  });
}

