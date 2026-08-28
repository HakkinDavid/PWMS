import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/storage/file_storage_service.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/species_detail_view.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/attachment.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/entity_detail_screen.dart';
import 'package:platinum_world_management_system/src/features/entities/presentation/photo_viewer_dialog.dart';

class FakePathProviderPlatform extends PathProviderPlatform with MockPlatformInterfaceMixin {
  final String tempPath;
  final String docsPath;

  FakePathProviderPlatform({required this.tempPath, required this.docsPath});

  @override
  Future<String?> getTemporaryPath() async => tempPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => docsPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late Directory tempDir;
  late FileStorageService fileStorageService;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('open_share_test_media_');
    PathProviderPlatform.instance = FakePathProviderPlatform(
      tempPath: p.join(tempDir.path, 'temp'),
      docsPath: p.join(tempDir.path, 'docs'),
    );

    fileStorageService = FileStorageService();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db, fileStorageService);
    catalogRepo = CatalogRepository(db, fileStorageService);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('1. Constant and error message helpers validity', () {
    expect(AppStrings.openExternallyAction, equals('Abrir externamente'));
    expect(AppStrings.openExternallyTooltip, equals('Abrir con aplicación externa'));
    expect(AppStrings.shareAction, equals('Compartir'));
    expect(AppStrings.shareAttachmentTooltip, equals('Compartir archivo'));
    expect(AppStrings.errorOpeningFile('test_err'), equals('Error al abrir archivo: test_err'));
    expect(AppStrings.errorSharingFile('test_err'), equals('Error al compartir archivo: test_err'));
    expect(AppTechnicalStrings.actionOpenExternally, equals('open_externally'));
    expect(AppTechnicalStrings.actionShare, equals('share'));
  });

  testWidgets('2. PhotoViewerDialog UI layout and action controls', (tester) async {
    final entity = WorldEntity(
      id: 'ent-1',
      speciesId: 'sp-1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhotoViewerDialog(
            entity: entity,
            imagePath: '/non_existent_file.png',
            onChangePhoto: () {},
            onDeletePhoto: () {},
          ),
        ),
      ),
    );

    await tester.pump();

    // Since file does not exist, photoNotAvailable is rendered and action buttons are present
    expect(find.text(AppStrings.photoNotAvailable), findsOneWidget);
    expect(find.text(AppStrings.changePhotoAction), findsOneWidget);
    expect(find.text(AppStrings.delete), findsOneWidget);
  });

  testWidgets('3. Attachment popup menu in read-only mode shows Open Externally and Share without redundant button', (tester) async {
    final species = CatalogItem(
      id: 'sp_1',
      name: 'Moneda 10 Pesos',
      type: 'Objeto',
      createdAt: DateTime.now(),
    );

    final att = Attachment(
      id: 'att_read_1',
      speciesId: 'sp_1',
      instanceId: null,
      filePath: 'dummy/path.pdf',
      fileName: 'documento_guia.pdf',
      fileType: 'pdf',
      createdAt: DateTime(2026, 1, 1),
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
            body: SpeciesDetailView(
              species: species,
              showAttachmentAction: false,
              workingSpeciesAttachments: [att],
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('documento_guia.pdf'), findsOneWidget);

    // Redundant inline share button is removed
    expect(find.byIcon(Icons.share_outlined), findsNothing);

    // Open the popup menu
    final moreVert = find.byIcon(Icons.more_vert);
    expect(moreVert, findsOneWidget);
    await tester.tap(moreVert);
    await tester.pumpAndSettle();

    // Verify Open Externally and Share options are present
    expect(find.text(AppStrings.openExternallyAction), findsOneWidget);
    expect(find.text(AppStrings.shareAction), findsOneWidget);

    // Editing options should NOT be present in read-only mode
    expect(find.text(AppStrings.replaceFileAction), findsNothing);
    expect(find.text(AppStrings.renameAction), findsNothing);
  });

  testWidgets('4. Attachment popup menu in edit mode shows Open Externally, Share, and Edit actions', (tester) async {
    final species = CatalogItem(
      id: 'sp_2',
      name: 'Documento Secreto',
      type: 'Documento',
      createdAt: DateTime.now(),
    );

    final att = Attachment(
      id: 'att_edit_1',
      speciesId: 'sp_2',
      instanceId: null,
      filePath: 'dummy/path.pdf',
      fileName: 'certificado.pdf',
      fileType: 'pdf',
      createdAt: DateTime(2026, 1, 1),
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
            body: SpeciesDetailView(
              species: species,
              showAttachmentAction: true,
              workingSpeciesAttachments: [att],
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('certificado.pdf'), findsOneWidget);

    // Open the popup menu
    final moreVert = find.byIcon(Icons.more_vert);
    expect(moreVert, findsOneWidget);
    await tester.tap(moreVert);
    await tester.pumpAndSettle();

    // Verify ONLY edit actions are present in edit mode (no open or share buttons)
    expect(find.text(AppStrings.openExternallyAction), findsNothing);
    expect(find.text(AppStrings.shareAction), findsNothing);
    expect(find.text(AppStrings.replaceFileAction), findsOneWidget);
    expect(find.text(AppStrings.renameAction), findsOneWidget);
    expect(find.text(AppStrings.delete), findsOneWidget);
  });

  testWidgets('5. EntityDetailScreen displays attachments when switching from read-only to editing mode', (tester) async {
    final species = await catalogRepo.getOrCreateSpecies('Laptop Pro', type: 'Electrónica');
    final entity = WorldEntity(
      id: 'ent_instance_100',
      speciesId: species.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await entityRepo.saveEntity(entity);

    final att = Attachment(
      id: 'att_inst_1',
      speciesId: species.id,
      instanceId: entity.id,
      filePath: 'dummy/invoice.pdf',
      fileName: 'factura_compra.pdf',
      fileType: 'pdf',
      createdAt: DateTime(2026, 1, 1),
    );
    await entityRepo.addAttachment(att);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          catalogRepositoryProvider.overrideWithValue(catalogRepo),
          entityRepositoryProvider.overrideWithValue(entityRepo),
          fileStorageServiceProvider.overrideWithValue(fileStorageService),
        ],
        child: MaterialApp(
          home: EntityDetailScreen(entityId: entity.id),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify attachment is visible in read-only mode
    expect(find.text('factura_compra.pdf'), findsOneWidget);

    // Enter edit mode
    final editButton = find.byIcon(Icons.edit_outlined);
    expect(editButton, findsOneWidget);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    // Verify attachment remains visible in editing mode!
    expect(find.text('factura_compra.pdf'), findsOneWidget);

    // Open options in edit mode (scroll into view if needed)
    final moreVert = find.byIcon(Icons.more_vert);
    expect(moreVert, findsOneWidget);
    await tester.ensureVisible(moreVert);
    await tester.pumpAndSettle();
    await tester.tap(moreVert);
    await tester.pumpAndSettle();

    // Verify edit actions are present in edit mode (no open or share)
    expect(find.text(AppStrings.openExternallyAction), findsNothing);
    expect(find.text(AppStrings.shareAction), findsNothing);
    expect(find.text(AppStrings.replaceFileAction), findsOneWidget);
    expect(find.text(AppStrings.renameAction), findsOneWidget);
    expect(find.text(AppStrings.delete), findsOneWidget);
  });
}
