import 'place.dart';

abstract class IPlaceRepository {
  Future<List<Place>> getAllPlaces();
  Future<Place?> getPlaceById(String id);
  Future<void> savePlace(Place place);
  Future<void> deletePlace(String id);
}
