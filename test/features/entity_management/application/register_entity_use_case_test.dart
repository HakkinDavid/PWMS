import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/features/entity_management/application/list_entities_use_case.dart';
import 'package:platinum_world_management_system/features/entity_management/application/register_entity_use_case.dart';
import '../../../fakes/in_memory_entity_repository.dart';

void main() {
  late InMemoryEntityRepository repository;
  late RegisterEntityUseCase registerUseCase;
  late ListEntitiesUseCase listUseCase;

  setUp(() {
    repository = InMemoryEntityRepository();
    registerUseCase = RegisterEntityUseCase(repository);
    listUseCase = ListEntitiesUseCase(repository);
  });

  group('RegisterEntityUseCase & ListEntitiesUseCase', () {
    test('Registra exitosamente una entidad y la lista en el repositorio', () async {
      final createdEntity = await registerUseCase.execute(name: 'Mochila de Montaña');

      expect(createdEntity.name, 'Mochila de Montaña');

      final entities = await listUseCase.execute();
      expect(entities.length, 1);
      expect(entities.first.id, createdEntity.id);
    });

    test('Lanza ArgumentError si el nombre está vacío', () async {
      expect(
        () => registerUseCase.execute(name: '   '),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
