import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/control_center/presentation/control_center_screen.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';
import 'package:platinum_world_management_system/src/features/relations/infrastructure/relation_repository.dart';

class FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  final String tempPath;
  final String docsPath;

  FakePathProviderPlatform({required this.tempPath, required this.docsPath});

  @override
  Future<String?> getTemporaryPath() async => tempPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => docsPath;
}

void main() {
  late AppDatabase db;
  late CatalogRepository catalogRepo;
  late EntityRepository entityRepo;
  late LocationRepository locationRepo;
  late RelationRepository relationRepo;
  late Directory tempDir;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = Directory.systemTemp.createTempSync('cc_anomaly_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );

    db = AppDatabase(NativeDatabase.memory());
    catalogRepo = CatalogRepository(db);
    entityRepo = EntityRepository(db);
    locationRepo = LocationRepository(db);
    relationRepo = RelationRepository(db);
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Control Center Anomaly Detection & Correction Tests', () {
    testWidgets('Location conflict card is generated and renders properly', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box', name: 'Caja Fuerte', mainPhotoPath: const Value('local/box.jpg'), createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_doc', name: 'Documento Secreto', mainPhotoPath: const Value('local/doc.jpg'), createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_office', name: 'Oficina', createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box', speciesId: 'sp_box', locationId: const Value('loc_office'), createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_doc', speciesId: 'sp_doc', locationId: const Value('loc_office'), createdAt: now, updatedAt: now),
          );
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_conflict',
              sourceEntityId: 'e_doc',
              targetEntityId: 'e_box',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: ControlCenterScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show the card for location conflict
      expect(find.text('Conflicto de Ubicación en Contenedor'), findsOneWidget);
    });

    testWidgets('Unique species violation card is generated and renders properly per subspecies', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_passport',
              name: 'Pasaporte',
              isUnique: const Value(true),
              mainPhotoPath: const Value('local/passport.jpg'),
              createdAt: now,
            ),
          );
      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_passport',
              speciesId: 'sp_passport',
              subspeciesName: 'Pasaporte Mexicano - David',
              createdAt: now,
            ),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_home', name: 'Casa', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_pass1',
              speciesId: 'sp_passport',
              subspeciesId: const Value('sub_passport'),
              locationId: const Value('loc_home'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_pass2',
              speciesId: 'sp_passport',
              subspeciesId: const Value('sub_passport'),
              locationId: const Value('loc_home'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: ControlCenterScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show uniqueness violation card evaluated per subspecies
      expect(find.text('Subespecie Única Duplicada'), findsOneWidget);
    });

    testWidgets('Perishable missing expiration card is generated and renders properly', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_cheese',
              name: 'Queso Gouda',
              isNonPerishable: const Value(false),
              mainPhotoPath: const Value('local/cheese.jpg'),
              createdAt: now,
            ),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_fridge', name: 'Refrigerador', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_cheese',
              speciesId: 'sp_cheese',
              locationId: const Value('loc_fridge'),
              expirationDate: const Value(null),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: ControlCenterScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show perishable missing expiration card
      expect(find.text('Perecedero sin Caducidad'), findsOneWidget);
    });

    testWidgets('Subgroup rule violation card is generated and renders properly', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_pet',
              name: 'Gato',
              type: const Value('Ser Vivo'),
              mainPhotoPath: const Value('local/cat.jpg'),
              createdAt: now,
            ),
          );
      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_pet',
              speciesId: 'sp_pet',
              subspeciesName: 'Gato Siames',
              brand: const Value('MarcaInvalida'),
              createdAt: now,
            ),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_garden', name: 'Jardín', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_cat',
              speciesId: 'sp_pet',
              subspeciesId: const Value('sub_pet'),
              locationId: const Value('loc_garden'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: ControlCenterScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show subgroup rule violation card
      expect(find.text('Infracción de Regla de Subgrupo'), findsOneWidget);
    });

    testWidgets('Location conflict onFix keep_container clears direct locationId', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_box', name: 'Caja Fuerte', mainPhotoPath: const Value('local/box.jpg'), createdAt: now),
          );
      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(id: 'sp_doc', name: 'Documento Secreto', mainPhotoPath: const Value('local/doc.jpg'), createdAt: now),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_office', name: 'Oficina', createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_box', speciesId: 'sp_box', locationId: const Value('loc_office'), createdAt: now, updatedAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(id: 'e_doc', speciesId: 'sp_doc', locationId: const Value('loc_office'), createdAt: now, updatedAt: now),
          );
      await db.into(db.relationsTable).insert(
            RelationsTableCompanion.insert(
              id: 'rel_conflict',
              sourceEntityId: 'e_doc',
              targetEntityId: 'e_box',
              relationType: 'GUARDADO_EN',
              createdAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: ControlCenterScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap "CORREGIR" button on the conflict card
      final fixButton = find.text('CORREGIR');
      expect(fixButton, findsOneWidget);
      await tester.ensureVisible(fixButton);
      await tester.pumpAndSettle();
      await tester.tap(fixButton);
      await tester.pumpAndSettle();

      // Tap "Solo en Contenedor"
      final keepContainerBtn = find.text('Solo en Contenedor');
      expect(keepContainerBtn, findsOneWidget);
      await tester.tap(keepContainerBtn);
      await tester.pumpAndSettle();

      // Verify in DB that e_doc locationId is now null
      final updatedEntity = await (db.select(db.entitiesTable)..where((tbl) => tbl.id.equals('e_doc'))).getSingle();
      expect(updatedEntity.locationId, isNull);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('Unique species violation onFix make_not_unique updates species isUnique to false', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_passport',
              name: 'Pasaporte',
              isUnique: const Value(true),
              mainPhotoPath: const Value('local/passport.jpg'),
              createdAt: now,
            ),
          );
      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_passport',
              speciesId: 'sp_passport',
              subspeciesName: 'Pasaporte Mexicano - David',
              createdAt: now,
            ),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_home', name: 'Casa', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_pass1',
              speciesId: 'sp_passport',
              subspeciesId: const Value('sub_passport'),
              locationId: const Value('loc_home'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_pass2',
              speciesId: 'sp_passport',
              subspeciesId: const Value('sub_passport'),
              locationId: const Value('loc_home'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: ControlCenterScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap "CORREGIR" button
      final fixButton = find.text('CORREGIR');
      expect(fixButton, findsOneWidget);
      await tester.ensureVisible(fixButton);
      await tester.pumpAndSettle();
      await tester.tap(fixButton);
      await tester.pumpAndSettle();

      // Tap "Convertir a No Única"
      final makeNotUniqueBtn = find.text('Convertir a No Única');
      expect(makeNotUniqueBtn, findsOneWidget);
      await tester.tap(makeNotUniqueBtn);
      await tester.pumpAndSettle();

      // Verify in DB that sp_passport isUnique is false
      final updatedSp = await (db.select(db.catalogTable)..where((tbl) => tbl.id.equals('sp_passport'))).getSingle();
      expect(updatedSp.isUnique, isFalse);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('Subgroup rule violation onFix strips brand and barcode from subspecies', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_pet',
              name: 'Gato',
              type: const Value('Ser Vivo'),
              mainPhotoPath: const Value('local/cat.jpg'),
              createdAt: now,
            ),
          );
      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_pet',
              speciesId: 'sp_pet',
              subspeciesName: 'Gato Siames',
              brand: const Value('MarcaInvalida'),
              createdAt: now,
            ),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_garden', name: 'Jardín', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_cat',
              speciesId: 'sp_pet',
              subspeciesId: const Value('sub_pet'),
              locationId: const Value('loc_garden'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: ControlCenterScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap "CORREGIR" button
      final fixButton = find.text('CORREGIR');
      expect(fixButton, findsOneWidget);
      await tester.ensureVisible(fixButton);
      await tester.pumpAndSettle();
      await tester.tap(fixButton);
      await tester.pumpAndSettle();

      // Verify in DB that sub_pet has null brand
      final updatedSub = await (db.select(db.subspeciesTable)..where((tbl) => tbl.id.equals('sub_pet'))).getSingle();
      expect(updatedSub.brand, isNull);
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
