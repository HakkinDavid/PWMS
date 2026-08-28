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
    String? subspeciesId,
    String? notes,
    String? unit,
    Map<String, double?>? customMagnitudeValues,
    DateTime? expirationDate,
  });
  Future<void> moveEntity(String entityId, String? newLocationId);
  Future<WorldEntity?> moveOrMergeEntity(String entityId, String? newLocationId);
  Future<void> deleteEntity(String id);
  Future<void> deleteEntitiesBatch(List<String> ids);

  // Attachments belong to Species & Instances
  Future<List<Attachment>> getAttachmentsForSpecies(String speciesId);
  Future<List<Attachment>> getAttachmentsForInstance(String instanceId);
  Future<void> addAttachment(Attachment attachment);
  Future<void> updateAttachment(Attachment attachment);
  Future<void> replaceAttachmentFile(
    String attachmentId,
    String newSourcePath, {
    String? newFileName,
    String? newFileType,
  });
  Future<void> deleteAttachment(String attachmentId);

  // Reassignment for Governance & Cascade Operations
  Future<int> reassignEntitiesSubspecies(String oldSubspeciesId, String targetSubspeciesId);
  Future<int> reassignEntitiesSpecies(String oldSpeciesId, String targetSpeciesId);

  // Custom Templates
  Future<List<CustomTemplate>> getAllCustomTemplates();
  Future<void> saveCustomTemplate(CustomTemplate template);
}
