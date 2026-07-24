import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/product_lookup_service.dart';

void main() {
  group('ProductLookupService V5 Pure Generic Taxonomy Tests', () {
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

    test('Taxonomy mapping correctly classifies generic hardware, controllers, mice, and nasal care', () async {
      final mockClient = MockClient((request) async {
        final url = request.url.toString();
        if (url.contains('html.duckduckgo.com')) {
          final query = request.url.queryParameters['q'] ?? '';
          return http.Response(
            '''
            <html>
              <body>
                <a class="result__a" href="https://example.com">$query</a>
              </body>
            </html>
            ''',
            200,
          );
        }
        return http.Response(jsonEncode({'products': []}), 200);
      });

      final service = ProductLookupService(client: mockClient);

      // RTX 4060 -> Tarjeta de Video
      final rtxResult = await service.lookupByNameOrBrand('GIGABYTE NVIDIA RTX 4060 GAMING OC 8GB GDDR6');
      expect(rtxResult, isNotNull);
      expect(rtxResult!.generalSpeciesName, 'Tarjeta de Video');

      // Controller -> Control de Videojuegos
      final dualSenseResult = await service.lookupByNameOrBrand('DualSense Wireless Controller Midnight Black');
      expect(dualSenseResult, isNotNull);
      expect(dualSenseResult!.generalSpeciesName, 'Control de Videojuegos');

      // Mouse -> Mouse
      final mouseResult = await service.lookupByNameOrBrand('Logitech Mouse G203');
      expect(mouseResult, isNotNull);
      expect(mouseResult!.generalSpeciesName, 'Mouse');

      // Solución Salina -> Lavado Nasal
      final sinusResult = await service.lookupByNameOrBrand('NeilMed Solución Salina Nasal Kit');
      expect(sinusResult, isNotNull);
      expect(sinusResult!.generalSpeciesName, 'Lavado Nasal');

      // Monitor -> Monitor
      final dellResult = await service.lookupByNameOrBrand('Dell Monitor P2425DE 24 inch');
      expect(dellResult, isNotNull);
      expect(dellResult!.generalSpeciesName, 'Monitor');
    });
  });
}
