import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity_id.dart';
import 'package:platinum_world_management_system/core/domain/value_objects/attribute_key.dart';
import 'package:platinum_world_management_system/core/domain/value_objects/attribute_value.dart';
import 'package:platinum_world_management_system/core/infrastructure/database/app_database.dart';
import 'package:platinum_world_management_system/features/entity_management/infrastructure/repositories/sqflite_entity_repository.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late Database db;
  late SqfliteEntityRepository repository;

  setUp(() async {
    db = await AppDatabase.createInMemory();
    repository = SqfliteEntityRepository(dbProvider: () async => db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SqfliteEntityRepository Integration Tests', () {
    test('Guarda y recupera una entidad en SQLite', () async {
      final id = EntityId.generate();
      final entity = Entity(
        id: id,
        attributes: {
          AttributeKey.name: AttributeValue.string('Generador Solar'),
          const AttributeKey('potencia'): AttributeValue.string('200W'),
        },
      );

      await repository.save(entity);

      final retrieved = await repository.findById(id);
      expect(retrieved, isNotNull);
      expect(retrieved!.id, id);
      expect(retrieved.name, 'Generador Solar');
      expect(retrieved.attributes[const AttributeKey('potencia')]?.asString, '200W');
    });

    test('Lista todas las entidades y elimina por ID', () async {
      final entity1 = Entity(
        id: EntityId.generate(),
        attributes: {AttributeKey.name: AttributeValue.string('Caja A')},
      );
      final entity2 = Entity(
        id: EntityId.generate(),
        attributes: {AttributeKey.name: AttributeValue.string('Caja B')},
      );

      await repository.save(entity1);
      await repository.save(entity2);

      var all = await repository.findAll();
      expect(all.length, 2);

      await repository.delete(entity1.id);

      all = await repository.findAll();
      expect(all.length, 1);
      expect(all.first.id, entity2.id);
    });
  });
}
