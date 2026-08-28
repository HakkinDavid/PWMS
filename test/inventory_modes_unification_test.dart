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
import 'package:platinum_world_management_system/src/features/entities/domain/effective_entity_group.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/effective_group_tile.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/entity_photo_thumbnail.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/instance_preview_card.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/minecraft_tile_widget.dart';
import 'package:platinum_world_management_system/src/features/home/presentation/inventory_breadcrumb_bar.dart';
import 'package:platinum_world_management_system/src/features/home/presentation/inventory_finder_screen.dart';
import 'package:platinum_world_management_system/src/features/home/presentation/inventory_item_interaction_wrapper.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
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
              onDropIntoContainer: (payload, targetId, isCont) {
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
      await tester.pump(const Duration(seconds: 4));
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

      // Inside container: Active Container Hero Tile (InstancePreviewCard) is displayed in the header
      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsOneWidget,
      );

      // Contained item 'Moneda Antigua' is now displayed in the inventory
      expect(find.byType(EffectiveGroupTile), findsOneWidget);

      // Tap on the root breadcrumb "Mundo" to go back to root
      final rootBreadcrumb = find.text(AppStrings.rootLocationName);
      expect(rootBreadcrumb, findsWidgets);
      await tester.tap(rootBreadcrumb.first);
      await tester.pumpAndSettle();

      // Back at root: 'Caja Fuerte' is shown, hero tile in breadcrumb bar is closed
      expect(find.byType(EffectiveGroupTile), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsNothing,
      );
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

      // Inside bag: Top bar has container hero tile (InstancePreviewCard)
      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsOneWidget,
      );

      // Grid inside bag contains MinecraftTileWidget for the tool
      expect(find.byType(MinecraftTileWidget), findsOneWidget);

      // Tap back button in AppBar
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Returned to root
      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsNothing,
      );
    });

    testWidgets('9. Dropping an item onto blank canvas or Active Container Hero Tile inside container saves it into container', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final boxSpecies = CatalogItem(id: 'sp-box-drop', name: 'Caja Fuerte', type: 'Objeto', createdAt: now);
      final gemSpecies = CatalogItem(id: 'sp-gem-drop', name: 'Diamante', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(boxSpecies);
      await catalogRepo.saveCatalogItem(gemSpecies);

      final boxEntity = WorldEntity(id: 'ent-box-drop', speciesId: boxSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final gemEntity = WorldEntity(id: 'ent-gem-drop', speciesId: gemSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(boxEntity);
      await entityRepo.saveEntity(gemEntity);

      await relationRepo.addRelation(EntityRelation(
        id: 'rel-init',
        sourceEntityId: gemEntity.id,
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

      // Tap on boxEntity to enter container
      await tester.tap(find.byType(EffectiveGroupTile));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsOneWidget,
      );

      // Verify the Active Container Hero Tile is a DragTarget
      final heroTileDragTarget = find.descendant(
        of: find.byType(InventoryBreadcrumbBar),
        matching: find.byType(DragTarget<Object>),
      );
      expect(heroTileDragTarget, findsWidgets);
    });

    testWidgets('10. Spring-loaded hover on breadcrumbs: hovering for 600ms navigates level while dragging', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final chestSpecies = CatalogItem(id: 'sp-chest', name: 'Baúl', type: 'Objeto', createdAt: now);
      final keySpecies = CatalogItem(id: 'sp-key', name: 'Llave Dorada', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(chestSpecies);
      await catalogRepo.saveCatalogItem(keySpecies);

      final chestEntity = WorldEntity(id: 'ent-chest', speciesId: chestSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final keyEntity = WorldEntity(id: 'ent-key', speciesId: keySpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(chestEntity);
      await entityRepo.saveEntity(keyEntity);

      await relationRepo.addRelation(EntityRelation(
        id: 'rel-chest-key',
        sourceEntityId: keyEntity.id,
        targetEntityId: chestEntity.id,
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

      // Enter chest
      await tester.tap(find.byType(EffectiveGroupTile));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsOneWidget,
      );

      // Start drag gesture on key item inside chest
      final itemTile = find.byType(EffectiveGroupTile);
      final gesture = await tester.startGesture(tester.getCenter(itemTile));
      await tester.pump(const Duration(milliseconds: 600));

      // Move drag over the root breadcrumb "Mundo"
      final rootBreadcrumb = find.text(AppStrings.rootLocationName).first;
      await gesture.moveTo(tester.getCenter(rootBreadcrumb));
      await tester.pump();

      // Wait 600ms for spring-loaded navigation to trigger
      await tester.pump(const Duration(milliseconds: 650));
      await tester.pumpAndSettle();

      // We should now have navigated back to root (hero card is gone) even while drag gesture is still active!
      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsNothing,
      );

      await gesture.up();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('11. Dropping item onto same container or origin location is discarded without redundant writes', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final boxSpecies = CatalogItem(id: 'sp-box-discard', name: 'Caja Fuerte', type: 'Objeto', createdAt: now);
      final ringSpecies = CatalogItem(id: 'sp-ring-discard', name: 'Anillo', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(boxSpecies);
      await catalogRepo.saveCatalogItem(ringSpecies);

      final boxEntity = WorldEntity(id: 'ent-box-disc', speciesId: boxSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final ringEntity = WorldEntity(id: 'ent-ring-disc', speciesId: ringSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(boxEntity);
      await entityRepo.saveEntity(ringEntity);

      await relationRepo.addRelation(EntityRelation(
        id: 'rel-ring-in-box',
        sourceEntityId: ringEntity.id,
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

      // Drill down into boxEntity
      await tester.tap(find.byType(EffectiveGroupTile));
      await tester.pumpAndSettle();

      final initialRelCount = (await relationRepo.getAllRelations()).length;

      // Drag ring and drop it on the canvas of the same box
      final itemTile = find.byType(EffectiveGroupTile);
      final gesture = await tester.startGesture(tester.getCenter(itemTile));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveBy(const Offset(0, 100));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // Relation count should be unchanged
      final afterRelCount = (await relationRepo.getAllRelations()).length;
      expect(afterRelCount, equals(initialRelCount));
    });

    testWidgets('12. Count badges are hidden for population == 1 or unique items, and container tiles show chevron right', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final boxSpecies = CatalogItem(id: 'sp-box-chev', name: 'Cofre', type: 'Objeto', createdAt: now);
      final gemSpecies = CatalogItem(id: 'sp-gem-chev', name: 'Zafiro', type: 'Objeto', isUnique: true, createdAt: now);
      await catalogRepo.saveCatalogItem(boxSpecies);
      await catalogRepo.saveCatalogItem(gemSpecies);

      final boxEntity = WorldEntity(id: 'ent-box-c', speciesId: boxSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final gemEntity = WorldEntity(id: 'ent-gem-c', speciesId: gemSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(boxEntity);
      await entityRepo.saveEntity(gemEntity);

      // Link gem in box to make box a container
      await relationRepo.addRelation(EntityRelation(
        id: 'rel-c-1',
        sourceEntityId: gemEntity.id,
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

      // At root: Cofre is a container tile -> should display chevron right
      final boxTileFinder = find.byType(EffectiveGroupTile).first;
      expect(boxTileFinder, findsOneWidget);
      expect(
        find.descendant(of: boxTileFinder, matching: find.byIcon(Icons.chevron_right)),
        findsOneWidget,
      );

      // Population is 1 for Cofre -> no count badge '1'
      expect(find.descendant(of: boxTileFinder, matching: find.text('1')), findsNothing);
    });

    testWidgets('13. System back button pops container navigation hierarchy before exiting screen', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final boxSpecies = CatalogItem(id: 'sp-box-pop', name: 'Maleta', type: 'Objeto', createdAt: now);
      final itemSpecies = CatalogItem(id: 'sp-item-pop', name: 'Pasaporte', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(boxSpecies);
      await catalogRepo.saveCatalogItem(itemSpecies);

      final boxEntity = WorldEntity(id: 'ent-box-p', speciesId: boxSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final itemEntity = WorldEntity(id: 'ent-item-p', speciesId: itemSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(boxEntity);
      await entityRepo.saveEntity(itemEntity);

      await relationRepo.addRelation(EntityRelation(
        id: 'rel-pop-1',
        sourceEntityId: itemEntity.id,
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

      // Enter Maleta container
      await tester.tap(find.byType(EffectiveGroupTile));
      await tester.pumpAndSettle();

      // We are inside Maleta (hero tile is present in breadcrumb bar)
      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsOneWidget,
      );

      // Simulate system back button dispatch
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      // Should have returned to root (hero tile gone)
      expect(
        find.descendant(
          of: find.byType(InventoryBreadcrumbBar),
          matching: find.byType(InstancePreviewCard),
        ),
        findsNothing,
      );
    });

    testWidgets('14. Location history: back button despools location navigation history back to Mundo root', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final locHouse = LocationNode(id: 'loc_h', name: 'Casa', createdAt: now);
      final locRoom = LocationNode(id: 'loc_r', name: 'Habitación', parentLocationId: locHouse.id, createdAt: now);
      await locationRepo.saveNode(locHouse);
      await locationRepo.saveNode(locRoom);

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
            home: InventoryFinderScreen(startWithCurtainOpen: true),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Casa in the curtain
      await tester.tap(find.descendant(
        of: find.byType(SizeTransition),
        matching: find.text('Casa'),
      ));
      await tester.pumpAndSettle();

      // Back button should now be visible in AppBar
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Re-open curtain and tap Habitación
      await tester.tap(find.text('Ubicaciones'));
      await tester.pumpAndSettle();
      // Expand Casa in tree
      final treeChevron = find.descendant(
        of: find.byType(SizeTransition),
        matching: find.byIcon(Icons.chevron_right),
      );
      await tester.tap(treeChevron.first);
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(
        of: find.byType(SizeTransition),
        matching: find.text('Habitación'),
      ));
      await tester.pumpAndSettle();

      // Back button still present
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Press Back button (despools Habitación -> Casa)
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Casa'), findsWidgets);

      // Press Back button again (despools Casa -> Mundo root)
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Now at Mundo root: Back button is gone
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('15. Isolated tree spring-load: hovering over parent location node expands ONLY that node', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final locWarehouse = LocationNode(id: 'loc_w', name: 'Almacén', createdAt: now);
      final locAisle = LocationNode(id: 'loc_a', name: 'Pasillo 1', parentLocationId: locWarehouse.id, createdAt: now);

      final locOffice = LocationNode(id: 'loc_o', name: 'Oficina', createdAt: now);
      final locDesk = LocationNode(id: 'loc_d', name: 'Escritorio', parentLocationId: locOffice.id, createdAt: now);

      final boxSpecies = CatalogItem(id: 'sp-box-tree', name: 'Paquete', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(boxSpecies);
      final boxEntity = WorldEntity(id: 'ent-box-t', speciesId: boxSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(boxEntity);

      await locationRepo.saveNode(locWarehouse);
      await locationRepo.saveNode(locAisle);
      await locationRepo.saveNode(locOffice);
      await locationRepo.saveNode(locDesk);

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
            home: InventoryFinderScreen(startWithCurtainOpen: true),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially neither sub-location is visible (collapsed in tree)
      expect(find.descendant(of: find.byType(SizeTransition), matching: find.text('Pasillo 1')), findsNothing);
      expect(find.descendant(of: find.byType(SizeTransition), matching: find.text('Escritorio')), findsNothing);

      // Start drag on Paquete
      final itemTile = find.byType(EffectiveGroupTile);
      final gesture = await tester.startGesture(tester.getCenter(itemTile));
      await tester.pump(const Duration(milliseconds: 600));

      // Move drag over 'Almacén' in the tree
      final warehouseNode = find.descendant(
        of: find.byType(SizeTransition),
        matching: find.text('Almacén'),
      );
      await gesture.moveTo(tester.getCenter(warehouseNode));
      await tester.pump();

      // Wait 650ms for spring-loaded timer
      await tester.pump(const Duration(milliseconds: 650));
      await tester.pumpAndSettle();

      // 'Pasillo 1' is now expanded in tree, but 'Escritorio' is STILL COLLAPSED
      expect(find.descendant(of: find.byType(SizeTransition), matching: find.text('Pasillo 1')), findsOneWidget);
      expect(find.descendant(of: find.byType(SizeTransition), matching: find.text('Escritorio')), findsNothing);

      await gesture.up();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('16. Canvas drop in Mundo: same origin drops are discarded, container extractions move item to root', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final rootSpecies = CatalogItem(id: 'sp-root-item', name: 'Reloj', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(rootSpecies);
      final rootEntity = WorldEntity(id: 'ent-root-item', speciesId: rootSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(rootEntity);

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

      final initialRelCount = (await relationRepo.getAllRelations()).length;

      // Drag Reloj and drop it on the canvas of Mundo
      final itemTile = find.byType(EffectiveGroupTile);
      final gesture = await tester.startGesture(tester.getCenter(itemTile));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveBy(const Offset(0, 100));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // Discarded cleanly without relations modified or errors
      final afterRelCount = (await relationRepo.getAllRelations()).length;
      expect(afterRelCount, equals(initialRelCount));
    });

    testWidgets('17. Root Mundo canvas drop preserves assigned locationId if dropped without navigating, but updates if navigated', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final locHouse = LocationNode(id: 'loc_house_flag', name: 'Casa Test', createdAt: now);
      await locationRepo.saveNode(locHouse);

      final lampSpecies = CatalogItem(id: 'sp-lamp-flag', name: 'Lámpara', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(lampSpecies);
      final lampEntity = WorldEntity(id: 'ent-lamp-flag', speciesId: lampSpecies.id, locationId: locHouse.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(lampEntity);

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

      // Case A: User in Mundo drags Lámpara (which is in Casa) and drops on Mundo canvas without navigating
      final itemTile = find.byType(EffectiveGroupTile);
      final gesture = await tester.startGesture(tester.getCenter(itemTile));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveBy(const Offset(0, 100));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // Lámpara STILL has locationId == 'loc_house_flag' (NOT stripped to null!)
      final checkEntA = await entityRepo.getEntityById('ent-lamp-flag');
      expect(checkEntA?.locationId, equals('loc_house_flag'));
    });

    testWidgets('18. Physical locations do NOT show objects from their child sub-locations', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final locHouse = LocationNode(id: 'loc_house_iso', name: 'Casa Principal', createdAt: now);
      final locRoom = LocationNode(id: 'loc_room_iso', name: 'Habitación Suite', parentLocationId: locHouse.id, createdAt: now);
      await locationRepo.saveNode(locHouse);
      await locationRepo.saveNode(locRoom);

      // Sofa in Casa
      final sofaSpecies = CatalogItem(id: 'sp-sofa', name: 'Sofá', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(sofaSpecies);
      final sofaEntity = WorldEntity(id: 'ent-sofa', speciesId: sofaSpecies.id, locationId: locHouse.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(sofaEntity);

      // Bed in Habitación
      final bedSpecies = CatalogItem(id: 'sp-bed', name: 'Cama', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(bedSpecies);
      final bedEntity = WorldEntity(id: 'ent-bed', speciesId: bedSpecies.id, locationId: locRoom.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(bedEntity);

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
            home: InventoryFinderScreen(initialLocationId: 'loc_house_iso'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // In 'Casa Principal', ONLY 'Sofá' is shown. 'Cama' (in child 'Habitación') is NOT shown!
      expect(find.byType(EffectiveGroupTile), findsOneWidget);
      expect(find.text('Cama'), findsNothing);

      // Child sub-location 'Habitación Suite' IS shown as a location tile at the end!
      expect(find.text('Habitación Suite'), findsOneWidget);
    });

    testWidgets('19. Child location tiles in parent location: tap drills down, drop moves item, immutable in selection mode', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      final locGarage = LocationNode(id: 'loc_gar', name: 'Garaje', createdAt: now);
      final locToolbox = LocationNode(id: 'loc_tool', name: 'Caja de Herramientas', parentLocationId: locGarage.id, createdAt: now);
      await locationRepo.saveNode(locGarage);
      await locationRepo.saveNode(locToolbox);

      final wrenchSpecies = CatalogItem(id: 'sp-wrench', name: 'Llave Inglesa', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(wrenchSpecies);
      final wrenchEntity = WorldEntity(id: 'ent-wrench', speciesId: wrenchSpecies.id, locationId: locGarage.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(wrenchEntity);

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
            home: InventoryFinderScreen(initialLocationId: 'loc_gar'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify 'Llave Inglesa' entity tile and 'Caja de Herramientas' sub-location tile appear
      expect(find.text('Llave Inglesa'), findsWidgets);
      expect(find.text('Caja de Herramientas'), findsOneWidget);

      // Drag 'Llave Inglesa' and drop onto 'Caja de Herramientas' tile
      final itemTile = find.byType(EffectiveGroupTile);
      final locTile = find.text('Caja de Herramientas');

      final gesture = await tester.startGesture(tester.getCenter(itemTile));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveTo(tester.getCenter(locTile));
      await tester.pump();
      await gesture.up();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Entity has moved to 'loc_tool'
      final checkWrench = await entityRepo.getEntityById('ent-wrench');
      expect(checkWrench?.locationId, equals('loc_tool'));

      // Tap on 'Caja de Herramientas' tile drills down into it
      await tester.tap(find.text('Caja de Herramientas'));
      await tester.pumpAndSettle();

      // Now inside 'Caja de Herramientas', 'Llave Inglesa' is shown directly here
      expect(find.text('Llave Inglesa'), findsWidgets);
    });

    testWidgets('20. Child location tiles aggregate object counts recursively across all descendant branches', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();

      // Hierarchy: Casa -> Habitación -> Armario
      final locHouse = LocationNode(id: 'loc_h2', name: 'Casa', createdAt: now);
      final locRoom = LocationNode(id: 'loc_r2', name: 'Habitación', parentLocationId: locHouse.id, createdAt: now);
      final locCloset = LocationNode(id: 'loc_c2', name: 'Armario', parentLocationId: locRoom.id, createdAt: now);

      await locationRepo.saveNode(locHouse);
      await locationRepo.saveNode(locRoom);
      await locationRepo.saveNode(locCloset);

      // Direct in Habitación: 1 item (Lámpara)
      final lampSpecies = CatalogItem(id: 'sp-lamp', name: 'Lámpara', type: 'Objeto', createdAt: now);
      await catalogRepo.saveCatalogItem(lampSpecies);
      final lampEntity = WorldEntity(id: 'ent-lamp', speciesId: lampSpecies.id, locationId: locRoom.id, magnitudes: const [], createdAt: now, updatedAt: now);
      await entityRepo.saveEntity(lampEntity);

      // In Armario (descendant of Habitación): 2 items (Camisa, Pantalón) + 1 Container (Caja de Zapatos) containing (Zapatos)
      final shirtSpecies = CatalogItem(id: 'sp-shirt', name: 'Camisa', type: 'Objeto', createdAt: now);
      final pantsSpecies = CatalogItem(id: 'sp-pants', name: 'Pantalón', type: 'Objeto', createdAt: now);
      final shoeboxSpecies = CatalogItem(id: 'sp-shoebox', name: 'Caja de Zapatos', type: 'Objeto', createdAt: now);
      final shoesSpecies = CatalogItem(id: 'sp-shoes', name: 'Zapatos', type: 'Objeto', createdAt: now);

      await catalogRepo.saveCatalogItem(shirtSpecies);
      await catalogRepo.saveCatalogItem(pantsSpecies);
      await catalogRepo.saveCatalogItem(shoeboxSpecies);
      await catalogRepo.saveCatalogItem(shoesSpecies);

      final shirtEntity = WorldEntity(id: 'ent-shirt', speciesId: shirtSpecies.id, locationId: locCloset.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final pantsEntity = WorldEntity(id: 'ent-pants', speciesId: pantsSpecies.id, locationId: locCloset.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final shoeboxEntity = WorldEntity(id: 'ent-shoebox', speciesId: shoeboxSpecies.id, locationId: locCloset.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final shoesEntity = WorldEntity(id: 'ent-shoes', speciesId: shoesSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);

      await entityRepo.saveEntity(shirtEntity);
      await entityRepo.saveEntity(pantsEntity);
      await entityRepo.saveEntity(shoeboxEntity);
      await entityRepo.saveEntity(shoesEntity);

      // Zapatos is GUARDADO_EN Caja de Zapatos
      final relation = EntityRelation(
        id: 'rel-shoes-in-box',
        sourceEntityId: shoesEntity.id,
        targetEntityId: shoeboxEntity.id,
        relationType: 'GUARDADO_EN',
        createdAt: now,
      );
      await relationRepo.addRelation(relation);

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
            home: InventoryFinderScreen(initialLocationId: 'loc_h2'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // In Casa, 'Habitación' tile aggregates:
      // 1 (Lámpara) + 2 (Camisa, Pantalón) + 1 (Caja de Zapatos) + 1 (Zapatos inside Caja) = 5 objetos!
      expect(find.text('Habitación'), findsOneWidget);
      expect(find.text('5 objetos'), findsOneWidget);
    });

    testWidgets('21. Visual stacking: items stack with count badge and tap individualizes in-place without badges', (tester) async {
      final coinSpecies = CatalogItem(id: 'sp_coin', name: 'Moneda 1 Euro', type: 'Objeto', createdAt: DateTime.now());
      await catalogRepo.saveCatalogItem(coinSpecies);

      final now = DateTime.now();
      final coin1 = WorldEntity(id: 'coin-1', speciesId: coinSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final coin2 = WorldEntity(id: 'coin-2', speciesId: coinSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final coin3 = WorldEntity(id: 'coin-3', speciesId: coinSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);

      await entityRepo.saveEntity(coin1);
      await entityRepo.saveEntity(coin2);
      await entityRepo.saveEntity(coin3);

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

      // Initially collapsed: 1 tile with count badge '3'
      expect(find.byType(EffectiveGroupTile), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('(1)'), findsNothing);
      expect(find.text('1'), findsNothing);

      // Tap on the stack tile
      await tester.tap(find.byType(EffectiveGroupTile));
      await tester.pumpAndSettle();

      // Now individualized in-place: 3 separate tiles appear, none having a count badge
      expect(find.byType(EffectiveGroupTile), findsNWidgets(3));
      expect(find.text('3'), findsNothing);
      expect(find.text('(1)'), findsNothing);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('22. Spring-loaded hover: hovering for 600ms during drag individualizes stack in-place', (tester) async {
      final appleSpecies = CatalogItem(id: 'sp_app', name: 'Manzana Gala', type: 'Objeto', createdAt: DateTime.now());
      final bookSpecies = CatalogItem(id: 'sp_bk', name: 'Libro Antiguo', type: 'Objeto', createdAt: DateTime.now());
      await catalogRepo.saveCatalogItem(appleSpecies);
      await catalogRepo.saveCatalogItem(bookSpecies);

      final now = DateTime.now();
      final apple1 = WorldEntity(id: 'app-1', speciesId: appleSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final apple2 = WorldEntity(id: 'app-2', speciesId: appleSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);
      final book = WorldEntity(id: 'book-1', speciesId: bookSpecies.id, magnitudes: const [], createdAt: now, updatedAt: now);

      await entityRepo.saveEntity(apple1);
      await entityRepo.saveEntity(apple2);
      await entityRepo.saveEntity(book);

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

      // We have 1 book tile and 1 stacked apple tile (count '2')
      expect(find.text('2'), findsOneWidget);
      expect(find.byType(EffectiveGroupTile), findsNWidgets(2));

      // Drag the book and hover over the apple stack
      final tiles = find.byType(EffectiveGroupTile);
      final bookTile = tiles.at(1);
      final appleTile = tiles.at(0);

      final gesture = await tester.startGesture(tester.getCenter(bookTile));
      await tester.pump(const Duration(milliseconds: 600));

      // Move over apple tile and hover for 600ms
      await gesture.moveTo(tester.getCenter(appleTile));
      await tester.pump(const Duration(milliseconds: 650));
      await tester.pumpAndSettle();

      // Spring-loaded individualization triggers: apple stack expands into 2 separate tiles!
      // Total tiles now: 1 book + 2 apples = 3 tiles
      expect(find.byType(EffectiveGroupTile), findsNWidgets(3));
      expect(find.text('2'), findsNothing);

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}

