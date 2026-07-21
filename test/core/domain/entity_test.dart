import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity.dart';
import 'package:platinum_world_management_system/core/domain/entities/entity_id.dart';
import 'package:platinum_world_management_system/core/domain/value_objects/attribute_key.dart';
import 'package:platinum_world_management_system/core/domain/value_objects/attribute_value.dart';

void main() {
  group('Entity & ValueObjects Domain Tests', () {
    test('EntityId genera UUIDs válidos e inmutables', () {
      final id1 = EntityId.generate();
      final id2 = EntityId.generate();

      expect(id1.value.isNotEmpty, true);
      expect(id2.value.isNotEmpty, true);
      expect(id1, isNot(equals(id2)));
    });

    test('AttributeKey compara sin distinguir mayúsculas/minúsculas', () {
      const key1 = AttributeKey('Name');
      const key2 = AttributeKey('name');

      expect(key1, equals(key2));
      expect(key1.hashCode, equals(key2.hashCode));
    });

    test('AttributeValue convierte tipos numéricos y texto correctamente', () {
      final strVal = AttributeValue.string('Hola mundo');
      final numVal = AttributeValue.number(42);

      expect(strVal.asString, 'Hola mundo');
      expect(numVal.asNumber, 42);
    });

    test('Entity se construye inmutable y name retorna fallback o atributo', () {
      final id = EntityId.generate();
      final entity = Entity(
        id: id,
        attributes: {
          AttributeKey.name: AttributeValue.string('Taladro Bosch'),
        },
      );

      expect(entity.id, id);
      expect(entity.name, 'Taladro Bosch');

      final updatedEntity = entity.withAttribute(
        const AttributeKey('color'),
        AttributeValue.string('Verde'),
      );

      expect(entity.attributes.containsKey(const AttributeKey('color')), false);
      expect(updatedEntity.attributes[const AttributeKey('color')]?.asString, 'Verde');
    });
  });
}
