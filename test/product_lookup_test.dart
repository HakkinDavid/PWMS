import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/product_lookup_service.dart';

void main() {
  group('ProductLookupService Unit Tests', () {
    test('lookupByBarcode returns product data from Open Food Facts JSON response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('openfoodfacts')) {
          return http.Response(
            jsonEncode({
              'status': 1,
              'product': {
                'product_name': 'Coca Cola 600ml',
                'brands': 'Coca-Cola',
                'categories': 'Bebidas, Refrescos',
                'image_front_url': 'https://example.com/coca.jpg',
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
      expect(result!.productName, 'Coca Cola 600ml');
      expect(result.brand, 'Coca-Cola');
      expect(result.barcode, '7501055300075');
    });

    test('lookupByNameOrBrand returns product search results', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'products': [
              {
                'product_name': 'Chocolate Nestle',
                'brands': 'Nestle',
                'code': '7501000111223',
              }
            ]
          }),
          200,
        );
      });

      final service = ProductLookupService(client: mockClient);
      final result = await service.lookupByNameOrBrand('Nestle');

      expect(result, isNotNull);
      expect(result!.productName, 'Chocolate Nestle');
      expect(result.brand, 'Nestle');
      expect(result.barcode, '7501000111223');
    });
  });
}
