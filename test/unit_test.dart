import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/attachment.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/entity_template.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';
import 'package:platinum_world_management_system/src/features/locations/domain/location_node.dart';
import 'package:platinum_world_management_system/src/features/locations/infrastructure/location_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository entityRepo;
  late CatalogRepository catalogRepo;
  late LocationRepository locationRepo;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase(NativeDatabase.memory());
    entityRepo = EntityRepository(db);
    catalogRepo = CatalogRepository(db);
    locationRepo = LocationRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PWMS Hierarchical Graph & Catalog Refinements Tests', () {
    test('1. Hierarchical Location Graph Nodes (Sub-locations)', () async {
      final rootNode = LocationNode(
        id: 'loc-garaje',
        name: 'Garaje Principal',
        createdAt: DateTime.now(),
      );

      final childNode = LocationNode(
        id: 'loc-caja',
        name: 'Caja de Herramientas',
        parentLocationId: 'loc-garaje',
        createdAt: DateTime.now(),
      );

      await locationRepo.saveNode(rootNode);
      await locationRepo.saveNode(childNode);

      final subNodes = await locationRepo.getSubNodes('loc-garaje');
      expect(subNodes.length, equals(1));
      expect(subNodes.first.name, equals('Caja de Herramientas'));
    });

    test('4. Species Attachment Ownership', () async {
      final species = await catalogRepo.getOrCreateSpecies(
        'Manual de Servicio Fluke',
        type: 'Documento',
      );

      final attachment = Attachment(
        id: 'att-1',
        speciesId: species.id, // Linked to Catalog species!
        filePath: 'docs/manual.pdf',
        fileName: 'manual.pdf',
        fileType: 'pdf',
        createdAt: DateTime.now(),
      );

      await entityRepo.addAttachment(attachment);
      final attachments = await entityRepo.getAttachmentsForSpecies(species.id);

      expect(attachments.length, equals(1));
      expect(attachments.first.fileName, equals('manual.pdf'));
      expect(attachments.first.speciesId, equals(species.id));
    });

    test('5. Non-countable Abstract Templates', () async {
      final docTpl = EntityTemplateRegistry.getTemplate('Documento');
      expect(docTpl.hasQuantity, isFalse);

      final objTpl = EntityTemplateRegistry.getTemplate('Objeto');
      expect(objTpl.hasQuantity, isTrue);
    });
  });
}
