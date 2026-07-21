import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/features/entity_management/application/get_contained_entities_use_case.dart';
import 'package:platinum_world_management_system/features/entity_management/application/get_location_path_use_case.dart';
import 'package:platinum_world_management_system/features/entity_management/application/move_entity_use_case.dart';
import 'package:platinum_world_management_system/features/entity_management/application/register_entity_use_case.dart';
import 'package:platinum_world_management_system/features/entity_management/application/search_entities_with_location_use_case.dart';
import 'package:platinum_world_management_system/features/entity_management/presentation/controllers/world_explorer_controller.dart';
import 'package:platinum_world_management_system/main.dart';
import 'fakes/in_memory_entity_repository.dart';
import 'fakes/in_memory_event_repository.dart';

void main() {
  testWidgets('PWMSApp renderiza la navegación persistente (MainShellScreen)',
      (WidgetTester tester) async {
    final entityRepo = InMemoryEntityRepository();
    final eventRepo = InMemoryEventRepository();

    final getLocationPath = GetLocationPathUseCase(entityRepo);
    final searchUseCase = SearchEntitiesWithLocationUseCase(
      entityRepository: entityRepo,
      getLocationPathUseCase: getLocationPath,
    );
    final getContainedUseCase = GetContainedEntitiesUseCase(entityRepo);
    final moveUseCase = MoveEntityUseCase(
      entityRepository: entityRepo,
      eventRepository: eventRepo,
      getLocationPathUseCase: getLocationPath,
    );
    final registerUseCase = RegisterEntityUseCase(entityRepo, eventRepo);

    final controller = WorldExplorerController(
      searchEntitiesUseCase: searchUseCase,
      getContainedEntitiesUseCase: getContainedUseCase,
      getLocationPathUseCase: getLocationPath,
      moveEntityUseCase: moveUseCase,
      registerEntityUseCase: registerUseCase,
    );

    await tester.pumpWidget(PWMSApp(controller: controller));
    await tester.pumpAndSettle();

    expect(find.text('Mi Mundo'), findsAtLeast(1));
    expect(find.text('Buscar'), findsOneWidget);
    expect(find.text('Explorar'), findsOneWidget);
    expect(find.text('Buscar objeto, documento, herramienta o lugar...'), findsOneWidget);
  });
}
