import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';

void main() {
  late AppDatabase db;
  late CatalogRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = CatalogRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('removeSpeciesMainPhoto updates database mainPhotoPath to null', () async {
    final species = CatalogItem(
      id: const Uuid().v4(),
      name: 'Especie Con Foto',
      mainPhotoPath: 'sample_photo.jpg',
      createdAt: DateTime.now(),
    );

    await repository.saveCatalogItem(species);

    final saved = await repository.getCatalogItemById(species.id);
    expect(saved?.mainPhotoPath, equals('sample_photo.jpg'));

    await repository.removeSpeciesMainPhoto(species.id);

    final updated = await repository.getCatalogItemById(species.id);
    expect(updated?.mainPhotoPath, isNull);
  });

  test('removeSubspeciesPhoto updates database photoPath to null', () async {
    final species = CatalogItem(
      id: const Uuid().v4(),
      name: 'Especie Subespecie',
      createdAt: DateTime.now(),
    );
    await repository.saveCatalogItem(species);

    final sub = Subspecies(
      id: const Uuid().v4(),
      speciesId: species.id,
      subspeciesName: 'Subespecie Con Foto',
      photoPath: 'sub_photo.png',
      createdAt: DateTime.now(),
    );
    await repository.saveSubspecies(sub);

    final savedSub = await repository.getSubspeciesById(sub.id);
    expect(savedSub?.photoPath, equals('sub_photo.png'));

    await repository.removeSubspeciesPhoto(sub.id);

    final updatedSub = await repository.getSubspeciesById(sub.id);
    expect(updatedSub?.photoPath, isNull);
  });
}
