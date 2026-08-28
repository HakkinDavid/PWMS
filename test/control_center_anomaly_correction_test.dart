import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/features/control_center/presentation/control_center_screen.dart';

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
  late Directory tempDir;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = Directory.systemTemp.createTempSync('cc_anomaly_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );

    db = AppDatabase(NativeDatabase.memory());
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
      await db.into(db.instanceLocationsTable).insert(
            InstanceLocationsTableCompanion.insert(instanceId: 'e_doc', locationId: 'loc_office', createdAt: now),
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
      await db.into(db.instanceLocationsTable).insert(
            InstanceLocationsTableCompanion.insert(instanceId: 'e_doc', locationId: 'loc_office', createdAt: now),
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

      // Tap "Resolver ubicación" button on the conflict card
      final fixButton = find.text('Resolver ubicación');
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
            LocationsTableCompanion.insert(id: 'loc_drawer', name: 'Cajón', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_pass1',
              speciesId: 'sp_passport',
              subspeciesId: const Value('sub_passport'),
              locationId: const Value('loc_drawer'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_pass2',
              speciesId: 'sp_passport',
              subspeciesId: const Value('sub_passport'),
              locationId: const Value('loc_drawer'),
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

      // Tap "Resolver duplicados" button
      final fixButton = find.text('Resolver duplicados');
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

      // Tap "Limpiar atributos" button
      final fixButton = find.text('Limpiar atributos');
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

    testWidgets('Missing species magnitude card is generated and onFix saves magnitude to DB', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_sugar',
              name: 'Azúcar Morena',
              mainPhotoPath: const Value('local/sugar.jpg'),
              createdAt: now,
            ),
          );

      await db.into(db.speciesMagnitudesTable).insert(
            SpeciesMagnitudesTableCompanion.insert(
              id: 'sm_peso',
              speciesId: 'sp_sugar',
              propertyName: 'Peso Neto',
              dataType: const Value('real'),
              unitSymbol: const Value('kg'),
              createdAt: now,
            ),
          );

      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_pantry', name: 'Alacena', createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_sugar',
              speciesId: 'sp_sugar',
              locationId: const Value('loc_pantry'),
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

      expect(find.text('Magnitud Faltante: Peso Neto'), findsOneWidget);

      final fixButton = find.text('Ingresar valor');
      expect(fixButton, findsOneWidget);
      await tester.tap(fixButton);
      await tester.pumpAndSettle();

      final enterValBtn = find.text('Ingresar valor').last;
      expect(enterValBtn, findsOneWidget);
      await tester.tap(enterValBtn);
      await tester.pumpAndSettle();

      // Enter value in the dialog
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, '2.5');
      await tester.pumpAndSettle();

      final saveButton = find.text('Guardar');
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify in DB that instance magnitude was inserted
      final mags = await (db.select(db.instanceMagnitudesTable)..where((tbl) => tbl.instanceId.equals('e_sugar'))).get();
      expect(mags.length, 1);
      expect(mags.first.propertyName, 'Peso Neto');
      expect(mags.first.magnitudeValue, 2.5);
      expect(mags.first.unitSymbol, 'kg');
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('Multiple cards on the same entity do not overwrite stale snapshots', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_yogurt',
              name: 'Yogurt Griego',
              isNonPerishable: const Value(false),
              mainPhotoPath: const Value('local/yogurt.jpg'),
              createdAt: now,
            ),
          );

      await db.into(db.speciesMagnitudesTable).insert(
            SpeciesMagnitudesTableCompanion.insert(
              id: 'sm_grasa',
              speciesId: 'sp_yogurt',
              propertyName: 'Grasa',
              dataType: const Value('real'),
              unitSymbol: const Value('g'),
              createdAt: now,
            ),
          );

      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_fridge2', name: 'Refri', createdAt: now),
          );

      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_yogurt_mult',
              speciesId: 'sp_yogurt',
              locationId: const Value('loc_fridge2'),
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

      // Card 1: Perecedero sin Caducidad
      expect(find.text('Perecedero sin Caducidad'), findsOneWidget);
      final fixBtn1 = find.text('Asignar fecha');
      await tester.tap(fixBtn1);
      await tester.pumpAndSettle();

      // Pick date in date picker dialog
      final okBtn = find.text('OK');
      expect(okBtn, findsOneWidget);
      await tester.tap(okBtn);
      await tester.pumpAndSettle();

      // Card 2: Magnitud Faltante: Grasa
      expect(find.text('Magnitud Faltante: Grasa'), findsOneWidget);
      final fixBtn2 = find.text('Ingresar valor');
      expect(fixBtn2, findsOneWidget);
      await tester.tap(fixBtn2);
      await tester.pumpAndSettle();

      final enterValBtn2 = find.text('Ingresar valor').last;
      expect(enterValBtn2, findsOneWidget);
      await tester.tap(enterValBtn2);
      await tester.pumpAndSettle();

      // Enter 5.0 for Grasa
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, '5.0');
      await tester.pumpAndSettle();

      final saveBtn = find.text('Guardar');
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Check final DB state for e_yogurt_mult: BOTH expirationDate AND magnitude must exist!
      final entity = await (db.select(db.entitiesTable)..where((tbl) => tbl.id.equals('e_yogurt_mult'))).getSingle();
      expect(entity.expirationDate, isNotNull);

      final mags = await (db.select(db.instanceMagnitudesTable)..where((tbl) => tbl.instanceId.equals('e_yogurt_mult'))).get();
      expect(mags.length, 1);
      expect(mags.first.propertyName, 'Grasa');
      expect(mags.first.magnitudeValue, 5.0);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('Routine checks appear in their own Tab and TabBar switches cleanly', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_watch',
              name: 'Reloj de Pulsera',
              mainPhotoPath: const Value('local/watch.jpg'),
              createdAt: now,
            ),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_safe', name: 'Caja Fuerte', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_watch',
              speciesId: 'sp_watch',
              locationId: const Value('loc_safe'),
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

      // Integrity rules tab is active initially and may be empty
      expect(find.text('Reglas de Integridad'), findsOneWidget);
      expect(find.text('Comprobaciones Rutinarias'), findsOneWidget);

      // Tap on Comprobaciones Rutinarias tab
      await tester.tap(find.text('Comprobaciones Rutinarias'));
      await tester.pumpAndSettle();

      // Should show routine checks (either ownership or location check)
      expect(
        find.text(AppStrings.keepThisObjectQuestion),
        findsOneWidget,
      );
    });

    testWidgets('Attachment incongruity preserves .webp extension without forcing .jpg', (WidgetTester tester) async {
      final now = DateTime.now();

      await db.into(db.catalogTable).insert(
            CatalogTableCompanion.insert(
              id: 'sp_coin',
              name: 'Moneda',
              type: const Value('Objeto'),
              mainPhotoPath: const Value('local/coin.jpg'),
              createdAt: now,
            ),
          );
      await db.into(db.subspeciesTable).insert(
            SubspeciesTableCompanion.insert(
              id: 'sub_coin',
              speciesId: 'sp_coin',
              subspeciesName: '10 Pesos Mexicanos - México (2024)',
              createdAt: now,
            ),
          );
      await db.into(db.locationsTable).insert(
            LocationsTableCompanion.insert(id: 'loc_safe', name: 'Caja Fuerte', createdAt: now),
          );
      await db.into(db.entitiesTable).insert(
            EntitiesTableCompanion.insert(
              id: 'e_coin',
              speciesId: 'sp_coin',
              subspeciesId: const Value('sub_coin'),
              locationId: const Value('loc_safe'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.instanceMagnitudesTable).insert(
            InstanceMagnitudesTableCompanion.insert(
              id: 'mag_val',
              instanceId: 'e_coin',
              propertyName: 'Valor nominal',
              dataType: const Value('real'),
              magnitudeValue: const Value(10.0),
            ),
          );
      await db.into(db.instanceMagnitudesTable).insert(
            InstanceMagnitudesTableCompanion.insert(
              id: 'mag_year',
              instanceId: 'e_coin',
              propertyName: 'Acuñación',
              dataType: const Value('integer'),
              magnitudeValue: const Value(2024.0),
              unitSymbol: const Value('año'),
            ),
          );
      await db.into(db.instanceMagnitudesTable).insert(
            InstanceMagnitudesTableCompanion.insert(
              id: 'mag_curr',
              instanceId: 'e_coin',
              propertyName: 'Divisa',
              dataType: const Value('string'),
              stringValue: const Value('MXN'),
            ),
          );
      await db.into(db.instanceMagnitudesTable).insert(
            InstanceMagnitudesTableCompanion.insert(
              id: 'mag_grade',
              instanceId: 'e_coin',
              propertyName: 'Grado',
              dataType: const Value('string'),
              stringValue: const Value('Sin circular'),
            ),
          );
      await db.into(db.attachmentsTable).insert(
            AttachmentsTableCompanion.insert(
              id: 'att_webp',
              speciesId: 'sp_coin',
              instanceId: const Value('e_coin'),
              filePath: '/data/user/0/app/files/old_photo.webp',
              fileName: 'Antiguo Nombre (anverso).webp',
              fileType: 'image',
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

      expect(find.text('Nombre de Adjunto Desincronizado'), findsOneWidget);

      // Tap "Renombrar archivo"
      final renameBtn = find.text('Renombrar archivo');
      expect(renameBtn, findsOneWidget);
      await tester.ensureVisible(renameBtn);
      await tester.pumpAndSettle();
      await tester.tap(renameBtn);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      final updatedAtt = await (db.select(db.attachmentsTable)..where((tbl) => tbl.id.equals('att_webp'))).getSingle();
      expect(updatedAtt.fileName, '10 Pesos Mexicanos - México (2024) (e_coin) (anverso).webp');
      expect(updatedAtt.fileName.endsWith('.jpg'), isFalse);
      expect(updatedAtt.fileName.endsWith('.webp'), isTrue);
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
