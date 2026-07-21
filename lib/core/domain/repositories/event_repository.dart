import '../entities/entity_id.dart';
import '../events/domain_event.dart';

/// Contrato abstracto del repositorio de eventos de auditoría.
abstract class EventRepository {
  /// Registra un evento de dominio.
  Future<void> record(DomainEvent event);

  /// Obtiene los eventos asociados a una entidad específica.
  Future<List<DomainEvent>> findByEntityId(EntityId entityId);

  /// Obtiene todos los eventos ordenados por fecha.
  Future<List<DomainEvent>> findAll();
}
