import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/database/data_migration_post_processor.dart';
import '../domain/activity_event.dart';

/// Centralized post-processor implementing IDataMigrationPostProcessor
/// Handles retroactive chronological history reconstruction (backfill)
/// and audit event generation for existing backups and database migrations.
class HistoryMigrationPostProcessor implements IDataMigrationPostProcessor {
  const HistoryMigrationPostProcessor();

  @override
  Future<void> processAfterImport(AppDatabase db) async {
    await backfillMissingHistory(db);
  }

  /// Reconstructs missing creation events for existing records using their original `createdAt` timestamps.
  static Future<void> backfillMissingHistory(AppDatabase db) async {
    final existingEvents = await db.select(db.historyEventsTable).get();

    final loggedEntityCreationIds = <String>{};
    final loggedSpeciesCreationIds = <String>{};
    final loggedSubspeciesCreationIds = <String>{};
    final loggedLocationCreationIds = <String>{};
    final loggedRelationCreationIds = <String>{};
    final loggedAttachmentCreationIds = <String>{};

    for (final evt in existingEvents) {
      if (evt.eventType == AppTechnicalStrings.eventTypeCreation && evt.entityId != null) {
        loggedEntityCreationIds.add(evt.entityId!);
      }

      if (evt.metadata != null && evt.metadata!.isNotEmpty) {
        try {
          final meta = jsonDecode(evt.metadata!) as Map<String, dynamic>;
          if (meta[AppTechnicalStrings.keySpeciesId] != null && (evt.eventType == AppTechnicalStrings.eventTypeSpeciesCreation || evt.eventType == AppTechnicalStrings.eventTypeCreation)) {
            loggedSpeciesCreationIds.add(meta[AppTechnicalStrings.keySpeciesId].toString());
          }
          if (meta[AppTechnicalStrings.keySubspeciesId] != null) {
            loggedSubspeciesCreationIds.add(meta[AppTechnicalStrings.keySubspeciesId].toString());
          }
          if (meta[AppTechnicalStrings.keyLocationId] != null && (evt.eventType == AppTechnicalStrings.eventTypeLocationCreation || evt.eventType == AppTechnicalStrings.eventTypeCreation)) {
            loggedLocationCreationIds.add(meta[AppTechnicalStrings.keyLocationId].toString());
          }
          if (meta[AppTechnicalStrings.keyRelationId] != null) {
            loggedRelationCreationIds.add(meta[AppTechnicalStrings.keyRelationId].toString());
          }
          if (meta[AppTechnicalStrings.keyAttachmentId] != null) {
            loggedAttachmentCreationIds.add(meta[AppTechnicalStrings.keyAttachmentId].toString());
          }
        } catch (_) {}
      }
    }

    final catalogRows = await db.select(db.catalogTable).get();
    final subspeciesRows = await db.select(db.subspeciesTable).get();
    final locationRows = await db.select(db.locationsTable).get();
    final entityRows = await db.select(db.entitiesTable).get();
    final relationRows = await db.select(db.relationsTable).get();
    final attachmentRows = await db.select(db.attachmentsTable).get();

    final speciesMap = {for (final s in catalogRows) s.id: s};
    final entityMap = {for (final e in entityRows) e.id: e};

    final List<ActivityEvent> backfilledEvents = [];

    // 1. Backfill Catalog/Species
    for (final species in catalogRows) {
      if (!loggedSpeciesCreationIds.contains(species.id)) {
        backfilledEvents.add(ActivityEvent(
          id: const Uuid().v4(),
          entityId: null,
          eventType: AppTechnicalStrings.eventTypeSpeciesCreation,
          description: AppStrings.activitySpeciesCreated(species.name, species.type),
          metadata: {
            AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
            AppTechnicalStrings.keySpeciesId: species.id,
            AppTechnicalStrings.colName: species.name,
            AppTechnicalStrings.colType: species.type,
          },
          timestamp: species.createdAt,
        ));
      }
    }

    // 2. Backfill Subspecies
    for (final sub in subspeciesRows) {
      if (!loggedSubspeciesCreationIds.contains(sub.id)) {
        final parentSpecies = speciesMap[sub.speciesId];
        backfilledEvents.add(ActivityEvent(
          id: const Uuid().v4(),
          entityId: null,
          eventType: AppTechnicalStrings.eventTypeSubspeciesCreation,
          description: AppStrings.activitySubspeciesCreated(sub.subspeciesName, parentSpecies?.name ?? AppStrings.typeObject),
          metadata: {
            AppTechnicalStrings.keyCategory: AppTechnicalStrings.categorySpecies,
            AppTechnicalStrings.keySubspeciesId: sub.id,
            AppTechnicalStrings.keySpeciesId: sub.speciesId,
            AppTechnicalStrings.colName: sub.subspeciesName,
            AppTechnicalStrings.colBrand: sub.brand,
          },
          timestamp: sub.createdAt,
        ));
      }
    }

    // 3. Backfill Locations
    for (final loc in locationRows) {
      if (!loggedLocationCreationIds.contains(loc.id)) {
        backfilledEvents.add(ActivityEvent(
          id: const Uuid().v4(),
          entityId: null,
          eventType: AppTechnicalStrings.eventTypeLocationCreation,
          description: AppStrings.activityLocationCreated(loc.name),
          metadata: {
            AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryLocation,
            AppTechnicalStrings.keyLocationId: loc.id,
            AppTechnicalStrings.colName: loc.name,
          },
          timestamp: loc.createdAt,
        ));
      }
    }

    // 4. Backfill Entities
    for (final ent in entityRows) {
      if (!loggedEntityCreationIds.contains(ent.id)) {
        final species = speciesMap[ent.speciesId];
        final speciesName = species?.name ?? AppStrings.typeObject;
        final speciesType = species?.type ?? AppStrings.typeObject;

        backfilledEvents.add(ActivityEvent(
          id: const Uuid().v4(),
          entityId: ent.id,
          eventType: AppTechnicalStrings.eventTypeCreation,
          description: AppStrings.activityEntityCreated(speciesName, speciesType),
          metadata: {
            AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryEntity,
            AppTechnicalStrings.keyName: speciesName,
            AppTechnicalStrings.keyType: speciesType,
            AppTechnicalStrings.colSpeciesId: ent.speciesId,
            AppTechnicalStrings.colSubspeciesId: ent.subspeciesId,
            AppTechnicalStrings.colLocationId: ent.locationId,
          },
          timestamp: ent.createdAt,
        ));
      }
    }

    // 5. Backfill Relations
    for (final rel in relationRows) {
      if (!loggedRelationCreationIds.contains(rel.id)) {
        final srcEnt = entityMap[rel.sourceEntityId];
        final tgtEnt = entityMap[rel.targetEntityId];
        final srcName = srcEnt != null ? (speciesMap[srcEnt.speciesId]?.name ?? rel.sourceEntityId) : rel.sourceEntityId;
        final tgtName = tgtEnt != null ? (speciesMap[tgtEnt.speciesId]?.name ?? rel.targetEntityId) : rel.targetEntityId;

        backfilledEvents.add(ActivityEvent(
          id: const Uuid().v4(),
          entityId: rel.sourceEntityId,
          eventType: AppTechnicalStrings.eventTypeRelation,
          description: AppStrings.activityRelationAdded(srcName, rel.relationType, tgtName),
          metadata: {
            AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryRelation,
            AppTechnicalStrings.keyRelationId: rel.id,
            AppTechnicalStrings.keySource: srcName,
            AppTechnicalStrings.keyTarget: tgtName,
            AppTechnicalStrings.keyType: rel.relationType,
          },
          timestamp: rel.createdAt,
        ));
      }
    }

    // 6. Backfill Attachments
    for (final att in attachmentRows) {
      if (!loggedAttachmentCreationIds.contains(att.id)) {
        String entityName = AppStrings.typeObject;
        if (att.instanceId != null) {
          final ent = entityMap[att.instanceId];
          if (ent != null) {
            entityName = speciesMap[ent.speciesId]?.name ?? entityName;
          }
        } else {
          entityName = speciesMap[att.speciesId]?.name ?? entityName;
        }

        backfilledEvents.add(ActivityEvent(
          id: const Uuid().v4(),
          entityId: att.instanceId,
          eventType: AppTechnicalStrings.eventTypeAttachment,
          description: AppStrings.activityAttachmentAdded(att.fileName, entityName),
          metadata: {
            AppTechnicalStrings.keyCategory: AppTechnicalStrings.categoryRelation,
            AppTechnicalStrings.keyAttachmentId: att.id,
            AppTechnicalStrings.keyName: entityName,
            AppTechnicalStrings.keyFile: att.fileName,
          },
          timestamp: att.createdAt,
        ));
      }
    }

    // Insert backfilled events in batch
    if (backfilledEvents.isNotEmpty) {
      await db.batch((batch) {
        for (final evt in backfilledEvents) {
          batch.insert(
            db.historyEventsTable,
            HistoryEventsTableCompanion(
              id: Value(evt.id),
              entityId: Value(evt.entityId),
              eventType: Value(evt.eventType),
              description: Value(evt.description),
              metadata: Value(evt.metadata != null ? jsonEncode(evt.metadata) : null),
              timestamp: Value(evt.timestamp),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    }
  }
}
