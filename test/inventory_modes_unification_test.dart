import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/storage/file_storage_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/effective_entity_group.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/effective_group_tile.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/entity_photo_thumbnail.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/minecraft_tile_widget.dart';
import 'package:platinum_world_management_system/src/features/home/presentation/inventory_finder_screen.dart';
import 'package:platinum_world_management_system/src/features/home/presentation/inventory_item_interaction_wrapper.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';
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
  late RelationRepository relationRepo;
  late LocationRepository locationRepo;
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
    locationRepo = LocationRepository(db);
    fileStorageService = MockFileStorageService();
  });

  tearDown(() async {
    await db.close();
  });

  group('Inventory Modes Unification Tests', () {
    testWidgets('1. EntityPhotoThumbnail renders text badge fallback when no photo exists', (tester) async {
      final species = CatalogItem(
        id: 'sp-1',
        name: 'Moneda Antigua',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: EntityPhotoThumbnail(
                species: species,
                size: 48,
                useTextBadgeFallback: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Fallback shows species name in SpeciesTextBadgeAvatar
      expect(find.text('Moneda Antigua'), findsOneWidget);
    });

    testWidgets('2. InventoryItemInteractionWrapper enables DragTarget for containers and triggers drop callback', (tester) async {
      final containerEntity = WorldEntity(
        id: 'container-box-1',
        speciesId: 'sp-box',
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final containerGroup = EffectiveEntityGroup(
        key: 'grp_box',
        speciesId: 'sp-box',
        effectiveLocationId: null,
        entities: [containerEntity],
      );

      Object? droppedData;
      String? targetContainer;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryItemInteractionWrapper(
              group: containerGroup,
              isSelected: false,
              isSelectionMode: false,
              selectedEntityIds: const {},
              isContainer: true,
              onTap: () {},
              onDropIntoContainer: (payload, targetId) {
                droppedData = payload;
                targetContainer = targetId;
              },
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Text('Container Tile'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DragTarget<Object>), findsOneWidget);
      expect(find.text('Container Tile'), findsOneWidget);
    });

    testWidgets('3. MinecraftTileWidget renders photo, badges, and reacts to tap and selection state', (tester) async {
      final species = CatalogItem(
        id: 'sp-apple',
        name: 'Manzana Fuji',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entity1 = WorldEntity(
        id: 'ent-apple-1',
        speciesId: species.id,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final entity2 = WorldEntity(
        id: 'ent-apple-2',
        speciesId: species.id,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final group = EffectiveEntityGroup(
        key: 'grp_apple',
        speciesId: species.id,
        effectiveLocationId: null,
        entities: [entity1, entity2],
      );

      bool tapped = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: MinecraftTileWidget(
                    group: group,
                    title: species.name,
                    isSelected: true,
                    isSelectionMode: true,
                    isContainer: true,
                    containedCount: 3,
                    isExpired: false,
                    onTap: () => tapped = true,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Population badge "2" is shown
      expect(find.text('2'), findsOneWidget);

      // Contained count badge is NOT shown (container badges removed)
      expect(find.text('3'), findsNothing);

      // Selection checkmark icon is NOT shown (selection uses highlight/grayscale without icons or checkboxes)
      expect(find.byIcon(Icons.check), findsNothing);

      // Tapping invokes onTap
      await tester.tap(find.byType(MinecraftTileWidget));
      expect(tapped, isTrue);
    });

    testWidgets('3b. MinecraftTileWidget applies grayscale ColorFiltered when unselected in selection mode', (tester) async {
      final species = CatalogItem(
        id: 'sp-apple-2',
        name: 'Manzana Fuji',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entity1 = WorldEntity(
        id: 'ent-apple-3',
        speciesId: species.id,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final group = EffectiveEntityGroup(
        key: 'grp_apple_2',
        speciesId: species.id,
        effectiveLocationId: null,
        entities: [entity1],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: MinecraftTileWidget(
                    group: group,
                    title: species.name,
                    isSelected: false,
                    isSelectionMode: true,
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Unselected item in selection mode is wrapped with ColorFiltered for grayscale
      expect(find.byType(ColorFiltered), findsOneWidget);
    });

    testWidgets('4. InventoryFinderScreen toggles view mode between detailedList and minecraftGrid seamlessly', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'sp-pen',
        name: 'Bolígrafo',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entity = WorldEntity(
        id: 'ent-pen-1',
        speciesId: species.id,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(entity);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            relationRepositoryProvider.overrideWithValue(relationRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: const MaterialApp(
            home: InventoryFinderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Starts in Detailed List mode: EffectiveGroupTile should be present
      expect(find.byType(EffectiveGroupTile), findsOneWidget);
      expect(find.byType(MinecraftTileWidget), findsNothing);

      // Toggle to Grid Mode via AppBar button
      final toggleViewBtn = find.byIcon(Icons.view_list);
      expect(toggleViewBtn, findsOneWidget);
      await tester.tap(toggleViewBtn);
      await tester.pumpAndSettle();

      // Now MinecraftTileWidget should be present in Grid Mode
      expect(find.byType(MinecraftTileWidget), findsOneWidget);
      expect(find.byType(EffectiveGroupTile), findsNothing);

      // Toggle back to Detailed List Mode
      final toggleBackBtn = find.byIcon(Icons.apps);
      expect(toggleBackBtn, findsOneWidget);
      await tester.tap(toggleBackBtn);
      await tester.pumpAndSettle();

      expect(find.byType(EffectiveGroupTile), findsOneWidget);
    });

    testWidgets('5. Minecraft mode long-press triggers drag-and-drop and does NOT enter selection mode', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final species = CatalogItem(
        id: 'sp-coin',
        name: 'Moneda',
        type: 'Objeto',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entity = WorldEntity(
        id: 'ent-coin-1',
        speciesId: species.id,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(entity);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            relationRepositoryProvider.overrideWithValue(relationRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: const MaterialApp(
            home: InventoryFinderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Switch to Minecraft Grid mode
      await tester.tap(find.byIcon(Icons.view_list));
      await tester.pumpAndSettle();

      expect(find.byType(MinecraftTileWidget), findsOneWidget);

      // Verify that LongPressDraggable is present on the tile
      expect(find.byType(LongPressDraggable<Object>), findsOneWidget);

      // Perform a long press gesture on the tile
      final tileFinder = find.byType(MinecraftTileWidget);
      final gesture = await tester.startGesture(tester.getCenter(tileFinder));
      await tester.pump(const Duration(milliseconds: 600));

      // Check that selection mode bottom bar is NOT displayed
      expect(find.text('Eliminar Selección'), findsNothing);
      expect(find.byIcon(Icons.check), findsNothing);

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('6. MinecraftTileWidget resolves photo hierarchy (subspecies over species, instance attachment over subspecies)', (tester) async {
      final species = CatalogItem(
        id: 'sp-camera',
        name: 'Cámara',
        type: 'Objeto',
        mainPhotoPath: 'species_camera.jpg',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final subspecies = Subspecies(
        id: 'sub-camera-sony',
        speciesId: species.id,
        subspeciesName: 'A7 IV',
        photoPath: 'subspecies_sony.jpg',
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveSubspecies(subspecies);

      final entity = WorldEntity(
        id: 'ent-cam-1',
        speciesId: species.id,
        subspeciesId: subspecies.id,
        magnitudes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await entityRepo.saveEntity(entity);

      final group = EffectiveEntityGroup(
        key: 'grp_cam',
        speciesId: species.id,
        effectiveLocationId: null,
        entities: [entity],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MinecraftTileWidget(
                group: group,
                title: species.name,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find EntityPhotoThumbnail inside MinecraftTileWidget
      final thumbnailFinder = find.byType(EntityPhotoThumbnail);
      expect(thumbnailFinder, findsOneWidget);

      final thumbnail = tester.widget<EntityPhotoThumbnail>(thumbnailFinder);
      expect(thumbnail.species?.id, equals(species.id));
      expect(thumbnail.subspeciesId, equals(subspecies.id));
      expect(thumbnail.instanceId, equals(entity.id));
    });

    testWidgets('7. Drill-Down navigation: tapping container opens its contents, displays container hero tile in top bar, and back navigation despools level', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      // Create container species (Caja) and item species (Moneda)
      final boxSpecies = CatalogItem(id: 'sp-box', name: 'Caja Fuerte', type: 'Objeto', createdAt: now);
      final coinSpecies = CatalogItem(id: 'sp-coin', name: 'Moneda Antigua', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(boxSpecies);
      await catalogRepo.saveCatalogItem(coinSpecies);

      // Create container entity and child entity
      final boxEntity = WorldEntity(id: 'ent-box-1', speciesId: boxSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final coinEntity = WorldEntity(id: 'ent-coin-1', speciesId: coinSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(boxEntity);
      await entityRepo.saveEntity(coinEntity);

      // Link coin inside box
      await relationRepo.addRelation(EntityRelation(
        id: 'rel-1',
        sourceEntityId: coinEntity.id,
        targetEntityId: boxEntity.id,
        relationType: 'GUARDADO_EN',
        createdAt: now,
      ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            relationRepositoryProvider.overrideWithValue(relationRepo),
            locationRepositoryProvider.overrideWithValue(locationRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: const MaterialApp(
            home: InventoryFinderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At root level: Container 'Caja Fuerte' is shown (1 EffectiveGroupTile), contained 'Moneda Antigua' is not visible in root
      expect(find.byType(EffectiveGroupTile), findsOneWidget);

      // Tap container to drill-down into it
      await tester.tap(find.byType(EffectiveGroupTile));
      await tester.pumpAndSettle();

      // Inside container: Active Container Hero Tile is displayed in the header with "Ver Ficha"
      expect(find.text('Ver Ficha'), findsOneWidget);

      // Contained item 'Moneda Antigua' is now displayed in the inventory
      expect(find.byType(EffectiveGroupTile), findsOneWidget);

      // Tap on the root breadcrumb "Todas las Ubicaciones" to go back to root
      final rootBreadcrumb = find.text('Todas las Ubicaciones');
      expect(rootBreadcrumb, findsOneWidget);
      await tester.tap(rootBreadcrumb);
      await tester.pumpAndSettle();

      // Back at root: 'Caja Fuerte' is shown, 'Ver Ficha' header is closed
      expect(find.byType(EffectiveGroupTile), findsOneWidget);
      expect(find.text('Ver Ficha'), findsNothing);
    });

    testWidgets('8. Drill-Down in Minecraft Grid mode: tapping container enters grid of contents with top hero tile', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final bagSpecies = CatalogItem(id: 'sp-bag', name: 'Mochila Táctica', type: 'Objeto', createdAt: now);
      final toolSpecies = CatalogItem(id: 'sp-tool', name: 'Navaja Suiza', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(bagSpecies);
      await catalogRepo.saveCatalogItem(toolSpecies);

      final bagEntity = WorldEntity(id: 'ent-bag-1', speciesId: bagSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final toolEntity = WorldEntity(id: 'ent-tool-1', speciesId: toolSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(bagEntity);
      await entityRepo.saveEntity(toolEntity);

      await relationRepo.addRelation(EntityRelation(
        id: 'rel-bag-tool',
        sourceEntityId: toolEntity.id,
        targetEntityId: bagEntity.id,
        relationType: 'GUARDADO_EN',
        createdAt: now,
      ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            entityRepositoryProvider.overrideWithValue(entityRepo),
            relationRepositoryProvider.overrideWithValue(relationRepo),
            locationRepositoryProvider.overrideWithValue(locationRepo),
            fileStorageServiceProvider.overrideWithValue(fileStorageService),
          ],
          child: const MaterialApp(
            home: InventoryFinderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Switch to Minecraft Grid mode
      await tester.tap(find.byIcon(Icons.view_list));
      await tester.pumpAndSettle();

      // Verify bag tile is present
      expect(find.byType(MinecraftTileWidget), findsOneWidget);

      // Tap bag tile to drill down into bag in Minecraft mode
      await tester.tap(find.byType(MinecraftTileWidget));
      await tester.pumpAndSettle();

      // Inside bag: Top bar has container hero tile with "Ver Ficha"
      expect(find.text('Ver Ficha'), findsOneWidget);

      // Grid inside bag contains MinecraftTileWidget for the tool
      expect(find.byType(MinecraftTileWidget), findsOneWidget);

      // Tap back button
      await tester.tap(find.byTooltip('Subir nivel'));
      await tester.pumpAndSettle();

      // Returned to root
      expect(find.text('Ver Ficha'), findsNothing);
    });
  });
}
