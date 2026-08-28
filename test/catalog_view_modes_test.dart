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
import 'package:platinum_world_management_system/src/core/widgets/minecraft_grid_cell.dart';
import 'package:platinum_world_management_system/src/core/widgets/minecraft_grid_view.dart';
import 'package:platinum_world_management_system/src/core/widgets/view_mode_toggle_button.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/catalog_screen.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/species_minecraft_tile.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/species_quick_actions_sheet.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/species_tile.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
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

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        catalogRepositoryProvider.overrideWithValue(catalogRepo),
        entityRepositoryProvider.overrideWithValue(entityRepo),
        relationRepositoryProvider.overrideWithValue(relationRepo),
        fileStorageServiceProvider.overrideWithValue(fileStorageService),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('Catalog View Modes & Abstraction Tests', () {
    testWidgets('1. CatalogScreen renders in Detailed List mode by default with SpeciesTile', (tester) async {
      final species = CatalogItem(
        id: 'sp-1',
        name: 'Moneda Numismática',
        type: AppStrings.typeObject,
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      await tester.pumpWidget(createTestWidget(const CatalogScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(SpeciesTile), findsOneWidget);
      expect(find.byType(SpeciesMinecraftTile), findsNothing);
      expect(find.byType(MinecraftGridView), findsNothing);
      expect(find.descendant(of: find.byType(SpeciesTile), matching: find.text('Moneda Numismática')), findsWidgets);
      expect(find.byType(ViewModeToggleButton), findsOneWidget);
    });

    testWidgets('2. Tapping ViewModeToggleButton in CatalogScreen switches between list and minecraft grid', (tester) async {
      final species1 = CatalogItem(
        id: 'sp-1',
        name: 'Moneda 1',
        type: AppStrings.typeObject,
        createdAt: DateTime.now(),
      );
      final species2 = CatalogItem(
        id: 'sp-2',
        name: 'Documento 1',
        type: AppStrings.typeDocument,
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species1);
      await catalogRepo.saveCatalogItem(species2);

      await tester.pumpWidget(createTestWidget(const CatalogScreen()));
      await tester.pumpAndSettle();

      // List mode initially
      expect(find.byType(SpeciesTile), findsNWidgets(2));
      expect(find.byType(SpeciesMinecraftTile), findsNothing);

      // Tap toggle button to switch to Minecraft Grid mode
      await tester.tap(find.byType(ViewModeToggleButton));
      await tester.pumpAndSettle();

      // Grid mode active
      expect(find.byType(MinecraftGridView), findsOneWidget);
      expect(find.byType(SpeciesMinecraftTile), findsNWidgets(2));
      expect(find.byType(SpeciesTile), findsNothing);

      // Tap toggle button again to switch back to List mode
      await tester.tap(find.byType(ViewModeToggleButton));
      await tester.pumpAndSettle();

      expect(find.byType(SpeciesTile), findsNWidgets(2));
      expect(find.byType(SpeciesMinecraftTile), findsNothing);
    });

    testWidgets('3. SpeciesMinecraftTile triggers custom onTap and onLongPress callbacks', (tester) async {
      final species = CatalogItem(
        id: 'sp-1',
        name: 'Especie Test',
        type: AppStrings.typeObject,
        createdAt: DateTime.now(),
      );

      var tapped = false;
      var longPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          Scaffold(
            body: Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: SpeciesMinecraftTile(
                  species: species,
                  onTap: () => tapped = true,
                  onLongPress: () => longPressed = true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SpeciesMinecraftTile));
      expect(tapped, isTrue);

      await tester.longPress(find.byType(SpeciesMinecraftTile));
      expect(longPressed, isTrue);
    });

    testWidgets('4. SpeciesQuickActionsSheet opens and displays all catalog actions', (tester) async {
      final species = CatalogItem(
        id: 'sp-1',
        name: 'Objeto Valioso',
        type: AppStrings.typeObject,
        createdAt: DateTime.now(),
      );
      await catalogRepo.saveCatalogItem(species);

      await tester.pumpWidget(
        createTestWidget(
          Scaffold(
            body: Consumer(
              builder: (context, ref, _) => Center(
                child: ElevatedButton(
                  onPressed: () => SpeciesQuickActionsSheet.show(context, ref, species),
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.viewSpeciesDetail), findsOneWidget);
      expect(find.text(AppStrings.instantiateAction), findsOneWidget);
      expect(find.text(AppStrings.editSpeciesTitle), findsOneWidget);
      expect(find.text(AppStrings.delete), findsOneWidget);
    });

    testWidgets('5. MinecraftGridCell renders badges and selection states accurately', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: MinecraftGridCell(
                  isSelected: true,
                  isExpired: true,
                  bottomRightBadge: Container(
                    key: const ValueKey('test_badge'),
                    child: const Text('99'),
                  ),
                  child: const Icon(Icons.star),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('test_badge')), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
