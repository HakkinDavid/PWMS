import 'attachment.dart';
import 'world_entity.dart';

abstract class IEntityRepository {
  Future<List<WorldEntity>> getAllEntities();
  Future<WorldEntity?> getEntityById(String id);
  Future<List<WorldEntity>> getRecentEntities({int limit = 10});
  Future<List<WorldEntity>> getEntitiesByPlace(String placeId);
  Future<List<WorldEntity>> getEntitiesByParent(String? parentId);
  Future<List<WorldEntity>> searchEntities(String query);
  Future<void> saveEntity(WorldEntity entity);
  Future<void> moveEntity(String entityId, {String? newPlaceId, String? newParentId});
  Future<void> deleteEntity(String id);

  // Attachments
  Future<List<Attachment>> getAttachments(String entityId);
  Future<void> addAttachment(Attachment attachment);
  Future<void> deleteAttachment(String attachmentId);
}
