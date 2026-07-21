import 'package:flutter/material.dart';
import 'features/entity_management/application/get_contained_entities_use_case.dart';
import 'features/entity_management/application/get_location_path_use_case.dart';
import 'features/entity_management/application/move_entity_use_case.dart';
import 'features/entity_management/application/register_entity_use_case.dart';
import 'features/entity_management/application/search_entities_with_location_use_case.dart';
import 'features/entity_management/infrastructure/repositories/sqflite_entity_repository.dart';
import 'features/entity_management/infrastructure/repositories/sqflite_event_repository.dart';
import 'features/entity_management/presentation/controllers/world_explorer_controller.dart';
import 'features/home/presentation/screens/main_shell_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inyección manual de dependencias desacopladas
  final entityRepository = SqfliteEntityRepository();
  final eventRepository = SqfliteEventRepository();

  final getLocationPathUseCase = GetLocationPathUseCase(entityRepository);
  final searchEntitiesUseCase = SearchEntitiesWithLocationUseCase(
    entityRepository: entityRepository,
    getLocationPathUseCase: getLocationPathUseCase,
  );
  final getContainedEntitiesUseCase = GetContainedEntitiesUseCase(entityRepository);
  final moveEntityUseCase = MoveEntityUseCase(
    entityRepository: entityRepository,
    eventRepository: eventRepository,
    getLocationPathUseCase: getLocationPathUseCase,
  );
  final registerEntityUseCase = RegisterEntityUseCase(
    entityRepository,
    eventRepository,
  );

  final controller = WorldExplorerController(
    searchEntitiesUseCase: searchEntitiesUseCase,
    getContainedEntitiesUseCase: getContainedEntitiesUseCase,
    getLocationPathUseCase: getLocationPathUseCase,
    moveEntityUseCase: moveEntityUseCase,
    registerEntityUseCase: registerEntityUseCase,
  );

  runApp(PWMSApp(controller: controller));
}

class PWMSApp extends StatelessWidget {
  final WorldExplorerController controller;

  const PWMSApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platinum World Management System',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E), // Esmeralda Platino
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF14B8A6),
          brightness: Brightness.dark,
        ),
      ),
      home: MainShellScreen(controller: controller),
    );
  }
}
