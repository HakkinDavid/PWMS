import 'dart:convert';
import 'package:http/http.dart' as http;

class NumistaApiService {
  Future<Map<String, dynamic>?> searchNumistaCatalog({
    required String query,
    String? apiKey,
  }) async {
    if (query.trim().isEmpty) return null;

    try {
      final headers = <String, String>{
        'Accept': 'application/json',
      };
      if (apiKey != null && apiKey.isNotEmpty) {
        headers['Numista-API-Key'] = apiKey;
      }

      final url = Uri.parse('https://api.numista.com/api/v3/types?q=${Uri.encodeComponent(query)}&count=1');
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data['types'] is List && (data['types'] as List).isNotEmpty) {
          final firstType = (data['types'] as List).first as Map<String, dynamic>;
          final title = firstType['title']?.toString() ?? query;
          final issuerName = firstType['issuer']?['name']?.toString();
          final minYear = firstType['min_year']?.toString();
          final maxYear = firstType['max_year']?.toString();
          final yearStr = (minYear != null && minYear == maxYear) ? minYear : (minYear != null ? '$minYear-$maxYear' : null);

          double? weight;
          if (firstType['weight'] != null) {
            weight = (firstType['weight'] is num) ? (firstType['weight'] as num).toDouble() : double.tryParse(firstType['weight'].toString());
          }

          double? diameter;
          if (firstType['diameter'] != null) {
            diameter = (firstType['diameter'] is num) ? (firstType['diameter'] as num).toDouble() : double.tryParse(firstType['diameter'].toString());
          }

          return {
            'title': title,
            'issuer': issuerName,
            'year': yearStr,
            'weight': weight,
            'diameter': diameter,
            'composition': firstType['composition']?['text']?.toString(),
          };
        }
      }
    } catch (_) {}
    return null;
  }
}
