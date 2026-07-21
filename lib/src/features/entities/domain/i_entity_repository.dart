import 'attachment.dart';
import 'custom_template.dart';
import 'world_entity.dart';

abstract class IEntityRepository {
  Future<List<WorldEntity>> getAllEntities();
  Future<WorldEntity?> getEntityById(String id);
  Future<List<WorldEntity>> getRecentEntities({int limit = 10});
  Future<List<WorldEntity>> getEntitiesByLocation(String? locationId);
  Future<List<WorldEntity>> searchEntities(String query);
  Future<void> saveEntity(WorldEntity entity);
  Future<WorldEntity> instantiateOrMerge(
    String speciesId,
    String? locationId,
    double addQuantity, {
    String? notes,
    String? unit,
  });
  Future<void> moveEntity(String entityId, String? newLocationId);
  Future<void> deleteEntity(String id);

  // Attachments belong to Species
  Future<List<Attachment>> getAttachmentsForSpecies(String speciesId);
  Future<void> addAttachment(Attachment attachment);
  Future<void> deleteAttachment(String attachmentId);

  // Custom Templates
  Future<List<CustomTemplate>> getAllCustomTemplates();
  Future<void> saveCustomTemplate(CustomTemplate template);
}
