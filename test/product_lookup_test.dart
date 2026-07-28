import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/product_lookup_service.dart';

void main() {
  group('ProductLookupService Barcode & ISBN Tests', () {
    test('lookupByBarcode handles barcode 8806094942965 via web search fallback', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('html.duckduckgo.com')) {
          return http.Response(
            '''
            <html>
              <body>
                <a class="result__a" href="https://example.com">Samsung Odyssey G6 G65B 27 Gaming Monitor</a>
              </body>
            </html>
            ''',
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = ProductLookupService(client: mockClient);
      final result = await service.lookupByBarcode('8806094942965');

      expect(result, isNotNull);
      expect(result!.generalSpeciesName, 'Monitor');
      expect(result.subspeciesName, 'Samsung Odyssey G6 G65B 27 Gaming Monitor');
      expect(result.brand, 'Samsung');
    });

    test('lookupByBarcode identifies ISBN book codes', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('googleapis.com')) {
          return http.Response(
            '''
            {
              "items": [
                {
                  "volumeInfo": {
                    "title": "Cien Años de Soledad",
                    "authors": ["Gabriel García Márquez"],
                    "publisher": "Editorial Sudamericana"
                  }
                }
              ]
            }
            ''',
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = ProductLookupService(client: mockClient);
      final result = await service.lookupByBarcode('9780307474728');

      expect(result, isNotNull);
      expect(result!.generalSpeciesName, 'Libro');
      expect(result.subspeciesName, 'Cien Años de Soledad');
      expect(result.brand, 'Gabriel García Márquez');
    });
  });
}
