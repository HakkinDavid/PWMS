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
import 'package:platinum_world_management_system/src/core/widgets/app_confirmation_dialog.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/add_edit_subspecies_modal.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/species_form_modal.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/entity_detail_screen.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';

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
    entityRepo = EntityRepository(db);
    fileStorageService = MockFileStorageService();
  });

  tearDown(() async {
    await db.close();
  });

  group('Unsaved Changes & PopScope Protection Tests', () {
    testWidgets('1. AppConfirmationDialog.showDiscardChangesDialog displays discard warning and returns choice', (tester) async {
      bool? userChoice;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  userChoice = await AppConfirmationDialog.showDiscardChangesDialog(context);
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.unsavedChangesTitle), findsOneWidget);
      expect(find.text(AppStrings.unsavedChangesMessage), findsOneWidget);
      expect(find.text(AppStrings.keepEditingAction), findsOneWidget);
      expect(find.text(AppStrings.discardChangesAction), findsOneWidget);

      // Tap keep editing -> false
      await tester.tap(find.text(AppStrings.keepEditingAction));
      await tester.pumpAndSettle();
      expect(userChoice, isFalse);

      // Open again and tap discard -> true
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.discardChangesAction));
      await tester.pumpAndSettle();
      expect(userChoice, isTrue);
    });

    testWidgets('2. SpeciesFormModal header close button prompts discard when dirty', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(entityRepo),
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

      // Enter name so form is dirty
      final nameField = find.widgetWithText(TextField, AppStrings.nameLabel);
      await tester.enterText(nameField, 'Especie Incompleta');

      // Tap close button in header
      final closeBtn = find.byIcon(Icons.close);
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();

      // Warning dialog should appear
      expect(find.text(AppStrings.unsavedChangesTitle), findsOneWidget);
      expect(find.text(AppStrings.unsavedChangesMessage), findsOneWidget);

      // Choose keep editing
      await tester.tap(find.text(AppStrings.keepEditingAction));
      await tester.pumpAndSettle();

      // Form remains visible
      expect(find.byType(SpeciesFormModal), findsOneWidget);
    });

    testWidgets('3. AddEditSubspeciesModal cancel button prompts discard when dirty', (tester) async {
      final species = CatalogItem(
        id: 'sp-1',
        name: 'Objeto de Prueba',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );

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
                  onPressed: () => AddEditSubspeciesModal.show(context, species: species),
                  child: const Text('Open Subspecies Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Subspecies Modal'));
      await tester.pumpAndSettle();

      // Type in name field
      final nameField = find.widgetWithText(TextField, AppStrings.subspeciesNameLabel);
      await tester.enterText(nameField, 'Variante Modificada');

      // Tap Cancel
      await tester.tap(find.widgetWithText(TextButton, AppStrings.cancel));
      await tester.pumpAndSettle();

      // Discard dialog should appear
      expect(find.text(AppStrings.unsavedChangesTitle), findsOneWidget);

      // Choose keep editing
      await tester.tap(find.text(AppStrings.keepEditingAction));
      await tester.pumpAndSettle();

      expect(find.byType(AddEditSubspeciesModal), findsOneWidget);
    });

    testWidgets('4. EntityDetailScreen discard changes reverts local state cleanly', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'sp-chair',
        name: 'Silla Ergonómica',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entity = WorldEntity(
        id: 'ent-chair-1',
        speciesId: species.id,
        notes: 'Nota Original',
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(entity);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: EntityDetailScreen(entityId: entity.id),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Edit icon in AppBar
      final editBtn = find.byIcon(Icons.edit_outlined);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      // Modify notes
      final notesField = find.widgetWithText(TextField, 'Nota Original');
      await tester.enterText(notesField, 'Nota Modificada sin Guardar');
      await tester.pumpAndSettle();

      // Scroll until Discard changes button is visible
      final discardBtn = find.text(AppStrings.discardChangesAction);
      await tester.scrollUntilVisible(discardBtn, 200.0, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();

      // Tap Discard changes button in footer
      await tester.tap(discardBtn);
      await tester.pumpAndSettle();

      // Discard confirmation dialog should appear
      expect(find.text(AppStrings.unsavedChangesTitle), findsOneWidget);

      // Confirm discard
      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.discardChangesAction));
      await tester.pumpAndSettle();

      // Entity notes should revert to original in DB
      final refreshed = await entityRepo.getEntityById(entity.id);
      expect(refreshed?.notes, equals('Nota Original'));
    });

    testWidgets('5. System back button (handlePopRoute) on dirty SpeciesFormModal shows discard dialog', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => SpeciesFormModal.show(context),
                  child: const Text('Open Species Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Species Modal'));
      await tester.pumpAndSettle();

      // Enter name so form is dirty
      final nameField = find.widgetWithText(TextField, AppStrings.nameLabel);
      await tester.enterText(nameField, 'Nombre Dirty');
      await tester.pumpAndSettle();

      // Simulate system back button
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      // Discard confirmation dialog should appear
      expect(find.text(AppStrings.unsavedChangesTitle), findsOneWidget);

      // Choose keep editing
      await tester.tap(find.text(AppStrings.keepEditingAction));
      await tester.pumpAndSettle();

      // Modal is still present
      expect(find.byType(SpeciesFormModal), findsOneWidget);

      // Now simulate back button again and confirm discard
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.discardChangesAction));
      await tester.pumpAndSettle();

      // Modal is closed
      expect(find.byType(SpeciesFormModal), findsNothing);
    });

    testWidgets('6. System back button (handlePopRoute) on clean SpeciesFormModal pops immediately without prompt', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => SpeciesFormModal.show(context),
                  child: const Text('Open Clean Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Clean Modal'));
      await tester.pumpAndSettle();
      expect(find.byType(SpeciesFormModal), findsOneWidget);

      // Simulate system back button without modifying anything
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      // No discard dialog should appear and modal should close immediately
      expect(find.text(AppStrings.unsavedChangesTitle), findsNothing);
      expect(find.byType(SpeciesFormModal), findsNothing);
    });

    testWidgets('7. Deleting a relation in EntityDetailScreen edit mode and discarding reverts DB state', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final relationRepo = RelationRepository(db);

      final species = CatalogItem(
        id: 'sp-rel-test',
        name: 'Objeto Con Relacion',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entityA = WorldEntity(
        id: 'ent-a',
        speciesId: species.id,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final entityB = WorldEntity(
        id: 'ent-b',
        speciesId: species.id,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(entityA);
      await entityRepo.saveEntity(entityB);

      final rel = EntityRelation(
        id: 'rel-ab-staged',
        sourceEntityId: entityA.id,
        targetEntityId: entityB.id,
        relationType: 'CONECTADO_A',
        createdAt: DateTime.now(),
      );
      await relationRepo.addRelation(rel);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            relationRepositoryProvider.overrideWithValue(relationRepo),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: EntityDetailScreen(entityId: entityA.id),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter edit mode
      final editBtn = find.byIcon(Icons.edit_outlined);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      // Tap close icon on the relation in graph
      final closeIcon = find.byTooltip(AppStrings.deleteRelationTooltip);
      await tester.scrollUntilVisible(closeIcon, 200.0, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await tester.tap(closeIcon);
      await tester.pumpAndSettle();

      // Confirm deletion in delete confirmation dialog
      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.delete));
      await tester.pumpAndSettle();

      // The relation was deleted from UI stage, but DB should NOT be touched yet!
      var dbRels = await relationRepo.getRelationsForEntity(entityA.id);
      expect(dbRels.length, equals(1)); // Still in DB!

      // Tap Discard (X) in top AppBar
      final cancelBtn = find.byTooltip(AppStrings.cancel);
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      // Discard confirmation dialog appears
      expect(find.text(AppStrings.unsavedChangesTitle), findsOneWidget);

      // Confirm discard changes
      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.discardChangesAction));
      await tester.pumpAndSettle();

      // Exited edit mode, relation still in DB
      dbRels = await relationRepo.getRelationsForEntity(entityA.id);
      expect(dbRels.length, equals(1));
    });
  });
}
