import 'package:flutter/foundation.dart';
import '../../../../core/domain/entities/entity.dart';
import '../../../../core/domain/entities/entity_id.dart';
import '../../../../core/domain/value_objects/attribute_key.dart';
import '../../../../core/domain/value_objects/attribute_value.dart';
import '../../application/get_contained_entities_use_case.dart';
import '../../application/get_location_path_use_case.dart';
import '../../application/move_entity_use_case.dart';
import '../../application/register_entity_use_case.dart';
import '../../application/search_entities_with_location_use_case.dart';

/// Controlador visual central para la experiencia del Explorador y la Pantalla "Mi Mundo".
class WorldExplorerController extends ChangeNotifier {
  final SearchEntitiesWithLocationUseCase _searchEntitiesUseCase;
  final GetContainedEntitiesUseCase _getContainedEntitiesUseCase;
  final GetLocationPathUseCase _getLocationPathUseCase;
  final MoveEntityUseCase _moveEntityUseCase;
  final RegisterEntityUseCase _registerEntityUseCase;

  WorldExplorerController({
    required SearchEntitiesWithLocationUseCase searchEntitiesUseCase,
    required GetContainedEntitiesUseCase getContainedEntitiesUseCase,
    required GetLocationPathUseCase getLocationPathUseCase,
    required MoveEntityUseCase moveEntityUseCase,
    required RegisterEntityUseCase registerEntityUseCase,
  })  : _searchEntitiesUseCase = searchEntitiesUseCase,
        _getContainedEntitiesUseCase = getContainedEntitiesUseCase,
        _getLocationPathUseCase = getLocationPathUseCase,
        _moveEntityUseCase = moveEntityUseCase,
        _registerEntityUseCase = registerEntityUseCase;

  // Estado del Explorador
  EntityId? _currentContainerId;
  Entity? _currentContainer;
  List<Entity> _currentPath = [];
  List<Entity> _containedEntities = [];
  Map<EntityId, int> _childCounts = {};

  // Estado de Búsqueda
  String _searchQuery = '';
  List<EntityWithLocation> _searchResults = [];
  List<EntityWithLocation> _recentEntities = [];

  bool _isLoading = false;
  String? _errorMessage;

  EntityId? get currentContainerId => _currentContainerId;
  Entity? get currentContainer => _currentContainer;
  List<Entity> get currentPath => List.unmodifiable(_currentPath);
  List<Entity> get containedEntities => List.unmodifiable(_containedEntities);
  Map<EntityId, int> get childCounts => Map.unmodifiable(_childCounts);

  String get searchQuery => _searchQuery;
  List<EntityWithLocation> get searchResults => List.unmodifiable(_searchResults);
  List<EntityWithLocation> get recentEntities => List.unmodifiable(_recentEntities);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Inicializa la pantalla "Mi Mundo" cargando la búsqueda vacía y las entidades recientes.
  Future<void> initHome() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final allWithLoc = await _searchEntitiesUseCase.execute('');
      _recentEntities = allWithLoc.take(10).toList();
    } catch (e) {
      _errorMessage = 'Error al cargar la pantalla de inicio: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ejecuta la búsqueda en vivo con respuesta percibida como instantánea.
  Future<void> onSearchQueryChanged(String query) async {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      _searchResults = await _searchEntitiesUseCase.execute(query);
    } catch (e) {
      _errorMessage = 'Error en la búsqueda: $e';
    } finally {
      notifyListeners();
    }
  }

  /// Navega al explorador dentro de un contenedor específico (o a la raíz si null).
  Future<void> openContainer(EntityId? containerId) async {
    _currentContainerId = containerId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (containerId != null) {
        _currentPath = await _getLocationPathUseCase.execute(containerId);
        _currentContainer = _currentPath.isNotEmpty ? _currentPath.last : null;
      } else {
        _currentPath = [];
        _currentContainer = null;
      }

      _containedEntities = await _getContainedEntitiesUseCase.execute(containerId);

      // Calcula conteo de hijos por cada entidad visible
      final counts = <EntityId, int>{};
      for (final entity in _containedEntities) {
        final children = await _getContainedEntitiesUseCase.execute(entity.id);
        counts[entity.id] = children.length;
      }
      _childCounts = counts;
    } catch (e) {
      _errorMessage = 'Error al explorar el contenedor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ejecuta la acción de mover una entidad a un nuevo contenedor.
  Future<bool> moveEntity(EntityId entityId, EntityId? newParentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _moveEntityUseCase.execute(
        entityId: entityId,
        newParentId: newParentId,
      );
      await openContainer(_currentContainerId);
      await initHome();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registra una nueva entidad en el contenedor activo o especificado (<30 segundos).
  Future<bool> registerEntity({
    required String name,
    String? kind,
    String? description,
    EntityId? parentId,
  }) async {
    if (name.trim().isEmpty) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final targetParentId = parentId ?? _currentContainerId;
      final extraAttributes = <AttributeKey, AttributeValue>{};
      if (description != null && description.trim().isNotEmpty) {
        extraAttributes[AttributeKey.description] = AttributeValue.string(description.trim());
      }

      await _registerEntityUseCase.execute(
        name: name,
        kind: kind,
        parentId: targetParentId,
        extraAttributes: extraAttributes,
      );

      await openContainer(_currentContainerId);
      await initHome();
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrar entidad: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
