import 'package:flutter/foundation.dart';
import '../../../../core/domain/entities/entity.dart';
import '../../../../core/domain/value_objects/attribute_key.dart';
import '../../../../core/domain/value_objects/attribute_value.dart';
import '../../application/list_entities_use_case.dart';
import '../../application/register_entity_use_case.dart';

/// Controlador de estado de la interfaz de usuario para la gestión de entidades.
class EntityListController extends ChangeNotifier {
  final ListEntitiesUseCase _listEntitiesUseCase;
  final RegisterEntityUseCase _registerEntityUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  List<Entity> _entities = [];

  EntityListController({
    required ListEntitiesUseCase listEntitiesUseCase,
    required RegisterEntityUseCase registerEntityUseCase,
  })  : _listEntitiesUseCase = listEntitiesUseCase,
        _registerEntityUseCase = registerEntityUseCase;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Entity> get entities => List.unmodifiable(_entities);

  /// Carga la lista inicial de entidades desde la base de datos.
  Future<void> loadEntities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _entities = await _listEntitiesUseCase.execute();
    } catch (e) {
      _errorMessage = 'Error al cargar las entidades: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ejecuta la acción rápida de registrar una nueva entidad (Captura en <30 segundos).
  Future<bool> registerEntity(String name, {String? description}) async {
    if (name.trim().isEmpty) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final extraAttributes = <AttributeKey, AttributeValue>{};
      if (description != null && description.trim().isNotEmpty) {
        extraAttributes[AttributeKey.description] = AttributeValue.string(description.trim());
      }

      final newEntity = await _registerEntityUseCase.execute(
        name: name,
        extraAttributes: extraAttributes,
      );

      _entities = [newEntity, ..._entities];
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
