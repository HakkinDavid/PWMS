import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/domain/item_view_mode.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/storage/app_settings_repository.dart';
import 'package:platinum_world_management_system/src/core/storage/file_storage_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/minecraft_tile_widget.dart';
import 'package:platinum_world_management_system/src/features/home/presentation/inventory_finder_screen.dart';
import 'package:platinum_world_management_system/src/features/home/presentation/inventory_item_interaction_wrapper.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/effective_entity_group.dart';

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
  late LocationRepository locationRepo;
  late RelationRepository relationRepo;
  late AppSettingsRepository settingsRepo;
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
    locationRepo = LocationRepository(db);
    relationRepo = RelationRepository(db);
    settingsRepo = AppSettingsRepository(db);
    fileStorageService = MockFileStorageService();
  });

  tearDown(() async {
    await db.close();
  });

  Widget createTestWidget(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        catalogRepositoryProvider.overrideWithValue(catalogRepo),
        entityRepositoryProvider.overrideWithValue(entityRepo),
        locationRepositoryProvider.overrideWithValue(locationRepo),
        relationRepositoryProvider.overrideWithValue(relationRepo),
        appSettingsRepositoryProvider.overrideWithValue(settingsRepo),
        fileStorageServiceProvider.overrideWithValue(fileStorageService),
        ...overrides,
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('1. View Mode Independent Persistence Tests', () {
    test('Persists inventory and catalog view modes separately in AppSettingsRepository', () async {
      // Default should be detailedList
      expect(await settingsRepo.getInventoryViewMode(), ItemViewMode.detailedList);
      expect(await settingsRepo.getCatalogViewMode(), ItemViewMode.detailedList);

      // Change inventory mode to minecraftGrid
      await settingsRepo.setInventoryViewMode(ItemViewMode.minecraftGrid);
      expect(await settingsRepo.getInventoryViewMode(), ItemViewMode.minecraftGrid);
      expect(await settingsRepo.getCatalogViewMode(), ItemViewMode.detailedList);

      // Change catalog mode to minecraftGrid
      await settingsRepo.setCatalogViewMode(ItemViewMode.minecraftGrid);
      expect(await settingsRepo.getCatalogViewMode(), ItemViewMode.minecraftGrid);

      // Change inventory mode back to detailedList
      await settingsRepo.setInventoryViewMode(ItemViewMode.detailedList);
      expect(await settingsRepo.getInventoryViewMode(), ItemViewMode.detailedList);
      expect(await settingsRepo.getCatalogViewMode(), ItemViewMode.minecraftGrid);
    });
  });

  group('2. Minecraft Tile Container Visual Indicator Tests', () {
    testWidgets('Renders container box icon badge in MinecraftTileWidget when isContainer is true without counter text', (tester) async {
      final species = CatalogItem(
        id: 'sp-box',
        name: 'Caja Organizadora',
        type: AppStrings.typeObject,
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entity = WorldEntity(
        id: 'ent-box-1',
        speciesId: 'sp-box',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final grp = EffectiveEntityGroup(
        key: 'grp-box',
        speciesId: 'sp-box',
        effectiveLocationId: null,
        entities: [entity],
      );

      await tester.pumpWidget(
        createTestWidget(
          Scaffold(
            body: Center(
              child: SizedBox(
                width: 90,
                height: 90,
                child: MinecraftTileWidget(
                  group: grp,
                  title: 'Caja Organizadora',
                  isContainer: true,
                  containedCount: 5,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Container icon should be present
      expect(find.byIcon(Icons.inventory_2_rounded), findsOneWidget);
      // Ensure NO numeric counter text for container contents is rendered (per user request)
      expect(find.text('5'), findsNothing);
    });

    testWidgets('Does not render container badge when isContainer is false', (tester) async {
      final species = CatalogItem(
        id: 'sp-coin',
        name: 'Moneda',
        type: AppStrings.typeObject,
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      final entity = WorldEntity(
        id: 'ent-coin-1',
        speciesId: 'sp-coin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final grp = EffectiveEntityGroup(
        key: 'grp-coin',
        speciesId: 'sp-coin',
        effectiveLocationId: null,
        entities: [entity],
      );

      await tester.pumpWidget(
        createTestWidget(
          Scaffold(
            body: Center(
              child: SizedBox(
                width: 90,
                height: 90,
                child: MinecraftTileWidget(
                  group: grp,
                  title: 'Moneda',
                  isContainer: false,
                  containedCount: 0,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.inventory_2_rounded), findsNothing);
    });
  });

  group('3. Inventory Item Universal DragTarget Tests', () {
    testWidgets('InventoryItemInteractionWrapper enables DragTarget for non-container items', (tester) async {
      final entity = WorldEntity(
        id: 'ent-1',
        speciesId: 'sp-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final grp = EffectiveEntityGroup(
        key: 'grp-1',
        speciesId: 'sp-1',
        effectiveLocationId: null,
        entities: [entity],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryItemInteractionWrapper(
              group: grp,
              isSelected: false,
              isSelectionMode: false,
              selectedEntityIds: const {},
              isContainer: false,
              onTap: () {},
              onDropIntoContainer: (payload, targetId, isCont) {},
              child: const Text('Regular Item'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DragTarget<Object>), findsOneWidget);
    });
  });

  group('4. Inventory Navigation and Back Button Tests', () {
    testWidgets('PopScope in InventoryFinderScreen manages back navigation hierarchy', (tester) async {
      final loc = LocationNode(
        id: 'loc-1',
        name: 'Estante A',
        createdAt: DateTime.now(),
      );
      await locationRepo.saveNode(loc);

      await tester.pumpWidget(
        createTestWidget(
          const InventoryFinderScreen(initialLocationId: 'loc-1'),
        ),
      );
      await tester.pumpAndSettle();

      // Back button in AppBar should be present since we are in a sublocation
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should return to root Mundo (no back button in AppBar)
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });
  });

  group('5. Inventory Autoscroll over Tiles Tests', () {
    testWidgets('Autoscroll occurs when dragging pointer over tiles near the bottom and top edge zones', (tester) async {
      // Create 30 items to ensure a long scrollable inventory
      for (int i = 0; i < 30; i++) {
        final species = CatalogItem(
          id: 'sp-$i',
          name: 'Item $i',
          type: AppStrings.typeObject,
          createdAt: DateTime.now(),
        );
        await catalogRepo.saveCatalogItem(species);

        final entity = WorldEntity(
          id: 'ent-$i',
          speciesId: 'sp-$i',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await entityRepo.saveEntity(entity);
      }

      await tester.pumpWidget(
        createTestWidget(
          const InventoryFinderScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);

      final scrollable = tester.widget<ScrollView>(listViewFinder);
      final scrollController = scrollable.controller!;
      expect(scrollController.offset, 0.0);

      // Start drag on the first tile
      final firstTileFinder = find.text('Item 0').first;
      final gesture = await tester.startGesture(tester.getCenter(firstTileFinder));
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));

      final canvasRect = tester.getRect(listViewFinder);

      // Move drag pointer directly over tiles located in the bottom edge zone (60px threshold)
      final bottomEdgePoint = Offset(canvasRect.center.dx, canvasRect.bottom - 20.0);
      await gesture.moveTo(bottomEdgePoint);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 200));

      // Scroll offset should increase due to autoscroll over tiles
      expect(scrollController.offset, greaterThan(0.0));
      final scrolledOffset = scrollController.offset;

      // Move drag pointer directly over tiles in the top edge zone
      final topEdgePoint = Offset(canvasRect.center.dx, canvasRect.top + 20.0);
      await gesture.moveTo(topEdgePoint);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 200));

      // Scroll offset should have decreased back towards top
      expect(scrollController.offset, lessThan(scrolledOffset));

      // Lift pointer to finish drag
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 50));
      final stoppedOffset = scrollController.offset;

      // Verify scrolling stopped
      await tester.pump(const Duration(milliseconds: 200));
      expect(scrollController.offset, equals(stoppedOffset));
    });

    testWidgets('Autoscroll occurs when dragging pointer over tiles in Minecraft Grid mode', (tester) async {
      await settingsRepo.setInventoryViewMode(ItemViewMode.minecraftGrid);

      // Create 40 items for grid mode scrolling
      for (int i = 0; i < 40; i++) {
        final species = CatalogItem(
          id: 'sp-grid-$i',
          name: 'GridItem $i',
          type: AppStrings.typeObject,
          createdAt: DateTime.now(),
        );
        await catalogRepo.saveCatalogItem(species);

        final entity = WorldEntity(
          id: 'ent-grid-$i',
          speciesId: 'sp-grid-$i',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await entityRepo.saveEntity(entity);
      }

      await tester.pumpWidget(
        createTestWidget(
          const InventoryFinderScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final gridViewFinder = find.byType(GridView);
      expect(gridViewFinder, findsOneWidget);

      final scrollable = tester.widget<ScrollView>(gridViewFinder);
      final scrollController = scrollable.controller!;
      expect(scrollController.offset, 0.0);

      // Start drag on the first grid tile
      final firstTileFinder = find.byType(MinecraftTileWidget).first;
      final gesture = await tester.startGesture(tester.getCenter(firstTileFinder));
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));

      final canvasRect = tester.getRect(gridViewFinder);

      // Move drag pointer directly over tiles in the bottom edge zone
      final bottomEdgePoint = Offset(canvasRect.center.dx, canvasRect.bottom - 20.0);
      await gesture.moveTo(bottomEdgePoint);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 200));

      // Scroll offset should increase due to autoscroll over tiles
      expect(scrollController.offset, greaterThan(0.0));
      final scrolledOffset = scrollController.offset;

      // Move drag pointer directly over tiles in the top edge zone
      final topEdgePoint = Offset(canvasRect.center.dx, canvasRect.top + 20.0);
      await gesture.moveTo(topEdgePoint);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 200));

      // Scroll offset should have decreased back towards top
      expect(scrollController.offset, lessThan(scrolledOffset));

      // Lift pointer to finish drag
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 50));
      final stoppedOffset = scrollController.offset;

      await tester.pump(const Duration(milliseconds: 200));
      expect(scrollController.offset, equals(stoppedOffset));
    });
  });
}

