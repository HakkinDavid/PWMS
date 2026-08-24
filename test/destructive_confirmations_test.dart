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
import 'package:platinum_world_management_system/src/features/catalog/domain/species_requirement.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/requirements_section_widget.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/subspecies_section_widget.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/entity_detail_screen.dart';
import 'package:platinum_world_management_system/src/features/relations/domain/entity_relation.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/presentation/interactive_entity_graph_widget.dart';

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
  late RelationRepository relationRepo;
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
    relationRepo = RelationRepository(db);
    fileStorageService = MockFileStorageService();
  });

  tearDown(() async {
    await db.close();
  });

  group('Destructive Confirmations Tests', () {
    testWidgets('1. Subspecies deletion requires confirmation and aborts when cancelled', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'sp-camera',
        name: 'Cámara Fotográfica',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final sub1 = Subspecies(
        id: 'sub-cam-1',
        speciesId: species.id,
        subspeciesName: 'Alpha 7 IV',
        brand: 'Sony',
        createdAt: DateTime.now(),
      );
      final sub2 = Subspecies(
        id: 'sub-cam-2',
        speciesId: species.id,
        subspeciesName: 'EOS R6',
        brand: 'Canon',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(sub1);
      await catalogRepo.saveSubspecies(sub2);

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

      // Open popup menu on first subspecies
      final menuBtn = find.byIcon(Icons.more_vert).first;
      await tester.tap(menuBtn);
      await tester.pumpAndSettle();

      // Tap Eliminar in popup menu
      final deleteMenuItem = find.text(AppStrings.delete);
      await tester.tap(deleteMenuItem);
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.text(AppStrings.confirmDeleteSubspeciesTitle), findsOneWidget);

      // Cancel deletion
      await tester.tap(find.widgetWithText(TextButton, AppStrings.cancel));
      await tester.pumpAndSettle();

      // Subspecies should NOT be deleted
      final subs = await catalogRepo.getSubspeciesForSpecies(species.id);
      expect(subs.length, equals(2));
    });

    testWidgets('2. Requirement deletion requires confirmation and deletes when confirmed', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'sp-flashlight',
        name: 'Linterna',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      final batterySpecies = CatalogItem(
        id: 'sp-battery',
        name: 'Batería AA',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);
      await catalogRepo.saveCatalogItem(batterySpecies);

      final req = SpeciesRequirement(
        id: 'req-1',
        sourceId: species.id,
        sourceType: 'species',
        requiredSpeciesId: batterySpecies.id,
        requiredQuantity: 2.0,
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveRequirement(req);

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
              body: RequirementsSectionWidget(
                sourceId: species.id,
                sourceType: 'species',
                isEditing: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap delete requirement button
      final deleteBtn = find.byIcon(Icons.delete_outline);
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.text(AppStrings.confirmDeleteRequirementTitle), findsOneWidget);

      // Confirm deletion
      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.delete));
      await tester.pumpAndSettle();

      // Requirement should be deleted from DB
      final reqs = await catalogRepo.getRequirementsForSource(species.id);
      expect(reqs.isEmpty, isTrue);
    });

    testWidgets('3. Relation deletion in InteractiveEntityGraphWidget requires confirmation', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final entityA = WorldEntity(
        id: 'ent-a',
        speciesId: 'sp-a',
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final entityB = WorldEntity(
        id: 'ent-b',
        speciesId: 'sp-b',
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(entityA);
      await entityRepo.saveEntity(entityB);

      final rel = EntityRelation(
        id: 'rel-ab',
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
            home: Scaffold(
              body: InteractiveEntityGraphWidget(
                currentEntity: entityA,
                isEditing: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap delete relation close icon
      final closeIcon = find.byIcon(Icons.close);
      await tester.tap(closeIcon);
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.text(AppStrings.confirmDeleteRelationTitle), findsOneWidget);

      // Cancel deletion
      await tester.tap(find.widgetWithText(TextButton, AppStrings.cancel));
      await tester.pumpAndSettle();

      // Relation still exists
      final relations = await relationRepo.getRelationsForEntity(entityA.id);
      expect(relations.length, equals(1));
    });

    testWidgets('4. Property deletion in EntityDetailScreen prompts confirmation dialog', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'sp-prop-test',
        name: 'Objeto Propiedad',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entity = WorldEntity(
        id: 'ent-prop-test',
        speciesId: species.id,
        magnitudes: [
          const InstanceMagnitude(
            id: 'mag-1',
            instanceId: 'ent-prop-test',
            propertyName: 'Longitud',
            magnitudeValue: 10.0,
            unitSymbol: 'cm',
            dataType: 'real',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(entity);

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
            home: EntityDetailScreen(entityId: entity.id),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter edit mode
      final editBtn = find.byIcon(Icons.edit_outlined);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      // Tap delete icon on property
      final deletePropBtn = find.byTooltip(AppStrings.deletePropertyFromInstanceTooltip);
      await tester.scrollUntilVisible(deletePropBtn, 200.0, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await tester.tap(deletePropBtn);
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.text(AppStrings.confirmDeletePropertyTitle), findsOneWidget);

      // Cancel deletion
      await tester.tap(find.widgetWithText(TextButton, AppStrings.cancel));
      await tester.pumpAndSettle();

      // Property still visible
      expect(find.textContaining('Longitud'), findsOneWidget);
    });
  });
}
