import '../../../core/domain/entities/entity.dart';
import '../../../core/domain/repositories/entity_repository.dart';
import 'get_location_path_use_case.dart';

/// DTO que acompaña a una entidad con su ruta legible de ubicación.
class EntityWithLocation {
  final Entity entity;
  final List<Entity> locationPath;
  final String locationDisplayPath;

  const EntityWithLocation({
    required this.entity,
    required this.locationPath,
    required this.locationDisplayPath,
  });
}

/// Caso de uso central para el JTBD: Encontrar cualquier objeto con su ubicación en <10s.
class SearchEntitiesWithLocationUseCase {
  final EntityRepository _entityRepository;
  final GetLocationPathUseCase _getLocationPathUseCase;

  SearchEntitiesWithLocationUseCase({
    required EntityRepository entityRepository,
    required GetLocationPathUseCase getLocationPathUseCase,
  })  : _entityRepository = entityRepository,
        _getLocationPathUseCase = getLocationPathUseCase;

  Future<List<EntityWithLocation>> execute(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    final allEntities = await _entityRepository.findAll();

    final filtered = allEntities.where((entity) {
      if (cleanQuery.isEmpty) return true;
      final nameMatches = entity.name.toLowerCase().contains(cleanQuery);
      final descMatches = entity.description?.toLowerCase().contains(cleanQuery) ?? false;
      return nameMatches || descMatches;
    }).toList();

    final results = <EntityWithLocation>[];

    for (final entity in filtered) {
      final fullPath = await _getLocationPathUseCase.execute(entity.id);

      // La ruta de ubicación excluye a la propia entidad al final
      final parentPath = fullPath.where((e) => e.id != entity.id).toList();

      final displayPath = parentPath.isNotEmpty
          ? parentPath.map((e) => e.name).join(' > ')
          : 'Raíz del Mundo';

      results.add(EntityWithLocation(
        entity: entity,
        locationPath: parentPath,
        locationDisplayPath: displayPath,
      ));
    }

    return results;
  }
}
