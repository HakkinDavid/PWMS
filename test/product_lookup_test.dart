import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/product_lookup_service.dart';

void main() {
  group('ProductLookupService Unit Tests', () {
    test('lookupByBarcode extracts General Species (e.g. Monitor) and Subspecies (e.g. Dell Pro 24)', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('openfoodfacts')) {
          return http.Response(
            jsonEncode({
              'status': 1,
              'product': {
                'product_name': 'Dell Pro 24 Monitor Full HD',
                'brands': 'Dell',
                'categories': 'Electrónica, Monitores',
                'generic_name': 'Monitor',
                'image_front_url': 'https://example.com/dell.jpg',
              }
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = ProductLookupService(client: mockClient);
      final result = await service.lookupByBarcode('7501055300075');

      expect(result, isNotNull);
      expect(result!.generalSpeciesName, 'Monitor');
      expect(result.subspeciesName, 'Dell Pro 24 Monitor Full HD');
      expect(result.brand, 'Dell');
      expect(result.barcode, '7501055300075');
    });

    test('lookupByNameOrBrand returns product search results with species abstraction', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'products': [
              {
                'product_name': 'Samsung G65B 27 Gaming Monitor',
                'brands': 'Samsung',
                'code': '8806090123456',
                'categories': 'Monitores Gaming',
              }
            ]
          }),
          200,
        );
      });

      final service = ProductLookupService(client: mockClient);
      final result = await service.lookupByNameOrBrand('Samsung');

      expect(result, isNotNull);
      expect(result!.generalSpeciesName, 'Monitor');
      expect(result.subspeciesName, 'Samsung G65B 27 Gaming Monitor');
      expect(result.brand, 'Samsung');
      expect(result.barcode, '8806090123456');
    });
  });
}
