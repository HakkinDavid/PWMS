import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/attachment.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

void main() {
  late AppDatabase db;
  late EntityRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = EntityRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Add and retrieve attachments by species and instance', () async {
    const speciesId = 'species-1';
    const instanceId = 'instance-1';

    // 1. Add species-level attachment (instanceId == null)
    final speciesAttachment = Attachment(
      id: const Uuid().v4(),
      speciesId: speciesId,
      filePath: 'test_spec.pdf',
      fileName: 'FichaTecnica.pdf',
      fileType: 'pdf',
      createdAt: DateTime.now(),
    );
    await repository.addAttachment(speciesAttachment);

    // 2. Add instance-level attachment
    final instanceAttachment = Attachment(
      id: const Uuid().v4(),
      speciesId: speciesId,
      instanceId: instanceId,
      filePath: 'test_inst.jpg',
      fileName: 'Anverso.jpg',
      fileType: 'image',
      createdAt: DateTime.now(),
    );
    await repository.addAttachment(instanceAttachment);

    // 3. Verify getAttachmentsForSpecies returns only species attachments
    final speciesAttachments = await repository.getAttachmentsForSpecies(speciesId);
    expect(speciesAttachments.length, equals(1));
    expect(speciesAttachments.first.fileName, equals('FichaTecnica.pdf'));

    // 4. Verify getAttachmentsForInstance returns instance attachment
    final instanceAttachments = await repository.getAttachmentsForInstance(instanceId);
    expect(instanceAttachments.length, equals(1));
    expect(instanceAttachments.first.fileName, equals('Anverso.jpg'));
  });
}
