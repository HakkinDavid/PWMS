import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity_id.dart';
import 'package:platinum_world_management_system/core/domain/value_objects/attribute_key.dart';
import 'package:platinum_world_management_system/core/domain/value_objects/attribute_value.dart';

void main() {
  group('Entity Kind Semantic Tests', () {
    test('Retorna "object" por defecto si el atributo kind no está especificado', () {
      final entity = Entity(id: EntityId.generate());
      expect(entity.kind, 'object');
    });

    test('Retorna el tipo semántico asignado (space, container, document, resource)', () {
      final spaceEntity = Entity(
        id: EntityId.generate(),
        attributes: {
          AttributeKey.kind: AttributeValue.string('space'),
        },
      );

      final containerEntity = Entity(
        id: EntityId.generate(),
        attributes: {
          AttributeKey.kind: AttributeValue.string('container'),
        },
      );

      expect(spaceEntity.kind, 'space');
      expect(containerEntity.kind, 'container');
    });
  });
}
