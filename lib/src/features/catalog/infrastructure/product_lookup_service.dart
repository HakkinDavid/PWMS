import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../domain/taxonomy/product_taxonomy_service.dart';

class ProductLookupResult {
  final String generalSpeciesName; // ej. "Monitor", "Tarjeta de Video", "Control de Videojuegos", "Cuidado Personal / Salud"
  final String subspeciesName;     // ej. "Dell Pro Plus P2425DE", "GIGABYTE RTX 4060 GAMING OC"
  final String? brand;
  final String? barcode;
  final String? description;
  final String type;
  final String? photoUrl;
  final String? localPhotoPath;
  final Map<String, dynamic> extraAttributes;

  const ProductLookupResult({
    required this.generalSpeciesName,
    required this.subspeciesName,
    this.brand,
    this.barcode,
    this.description,
    this.type = 'Objeto',
    this.photoUrl,
    this.localPhotoPath,
    this.extraAttributes = const {},
  });

  String get productName => subspeciesName;

  ProductLookupResult copyWith({
    String? generalSpeciesName,
    String? subspeciesName,
    String? brand,
    String? barcode,
    String? description,
    String? type,
    String? photoUrl,
    String? localPhotoPath,
    Map<String, dynamic>? extraAttributes,
  }) {
    return ProductLookupResult(
      generalSpeciesName: generalSpeciesName ?? this.generalSpeciesName,
      subspeciesName: subspeciesName ?? this.subspeciesName,
      brand: brand ?? this.brand,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      type: type ?? this.type,
      photoUrl: photoUrl ?? this.photoUrl,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      extraAttributes: extraAttributes ?? this.extraAttributes,
    );
  }
}

class ProductLookupService {
  final http.Client _client;
  final ProductTaxonomyService _taxonomyService;

  ProductLookupService({
    http.Client? client,
    ProductTaxonomyService? taxonomyService,
  })  : _client = client ?? http.Client(),
        _taxonomyService = taxonomyService ?? const ProductTaxonomyService();

  /// Consultar producto por código de barras (EAN/UPC) con arquitectura multinivel de búsqueda
  Future<ProductLookupResult?> lookupByBarcode(String rawBarcode) async {
    final cleanCode = rawBarcode.trim();
    if (cleanCode.isEmpty) return null;

    // Level 1: Open Food Facts API (v2)
    final offResult = await _fetchFromOpenFoodFacts(cleanCode);
    if (offResult != null) {
      return await _ensureCleanPhotoAndSave(offResult);
    }

    // Level 2: UPC Item DB Trial API
    final upcResult = await _fetchFromUpcItemDb(cleanCode);
    if (upcResult != null) {
      return await _ensureCleanPhotoAndSave(upcResult);
    }

    // Level 3: DuckDuckGo Web Search Fallback por Código de Barras (ej. 8806094942965)
    final webResult = await _fetchFromWebSearchFallback(cleanCode);
    if (webResult != null) {
      return await _ensureCleanPhotoAndSave(webResult);
    }

    return null;
  }

  /// Consultar producto por nombre o marca
  Future<ProductLookupResult?> lookupByNameOrBrand(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return null;

    try {
      final uri = Uri.parse('https://world.openfoodfacts.org/cgi/search.pl?search_terms=${Uri.encodeComponent(cleanQuery)}&search_simple=1&action=process&json=1&page_size=1');
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = data['products'] as List?;
        if (products != null && products.isNotEmpty) {
          final prod = products.first as Map<String, dynamic>;
          final name = (prod['product_name'] ?? prod['product_name_es'] ?? prod['generic_name'] ?? '').toString().trim();
          if (name.isNotEmpty) {
            final brand = (prod['brands'] ?? '').toString().trim();
            final code = (prod['code'] ?? '').toString().trim();
            final categories = (prod['categories'] ?? '').toString().trim();
            final genericName = (prod['generic_name'] ?? '').toString().trim();
            final imgUrl = _extractFrontPhotoUrl(prod);

            final taxonomy = _taxonomyService.resolve(
              title: name,
              categoryHint: categories,
              genericName: genericName,
              brandHint: brand,
            );

            final result = ProductLookupResult(
              generalSpeciesName: taxonomy.generalSpeciesName,
              subspeciesName: name,
              brand: taxonomy.inferredBrand ?? (brand.isNotEmpty ? brand : null),
              barcode: code.isNotEmpty ? code : null,
              photoUrl: imgUrl,
            );
            return await _ensureCleanPhotoAndSave(result);
          }
        }
      }
    } catch (_) {}

    // Fallback a web search por nombre/marca
    final webFallback = await _fetchFromWebSearchFallback(cleanQuery);
    if (webFallback != null) {
      return await _ensureCleanPhotoAndSave(webFallback);
    }

    return null;
  }

  Future<ProductLookupResult?> _fetchFromOpenFoodFacts(String barcode) async {
    try {
      final uri = Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json');
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          final prod = data['product'] as Map<String, dynamic>;
          final name = (prod['product_name'] ?? prod['product_name_es'] ?? prod['abbreviated_product_name'] ?? '').toString().trim();
          final brand = (prod['brands'] ?? '').toString().trim();
          final categories = (prod['categories'] ?? '').toString().trim();
          final genericName = (prod['generic_name'] ?? '').toString().trim();
          final imgUrl = _extractFrontPhotoUrl(prod);

          if (name.isNotEmpty) {
            final taxonomy = _taxonomyService.resolve(
              title: name,
              categoryHint: categories,
              genericName: genericName,
              brandHint: brand,
            );

            return ProductLookupResult(
              generalSpeciesName: taxonomy.generalSpeciesName,
              subspeciesName: name,
              brand: taxonomy.inferredBrand ?? (brand.isNotEmpty ? brand : null),
              barcode: barcode,
              description: categories.isNotEmpty ? categories : null,
              photoUrl: imgUrl,
            );
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<ProductLookupResult?> _fetchFromUpcItemDb(String barcode) async {
    try {
      final uri = Uri.parse('https://api.upcitemdb.com/prod/trial/lookup?upc=$barcode');
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List?;
        if (items != null && items.isNotEmpty) {
          final item = items.first as Map<String, dynamic>;
          final title = (item['title'] ?? '').toString().trim();
          final brand = (item['brand'] ?? '').toString().trim();
          final category = (item['category'] ?? '').toString().trim();
          final description = (item['description'] ?? '').toString().trim();
          final images = item['images'] as List?;
          final imgUrl = (images != null && images.isNotEmpty) ? images.first.toString() : null;

          if (title.isNotEmpty) {
            final taxonomy = _taxonomyService.resolve(
              title: title,
              categoryHint: category,
              brandHint: brand,
            );

            return ProductLookupResult(
              generalSpeciesName: taxonomy.generalSpeciesName,
              subspeciesName: title,
              brand: taxonomy.inferredBrand ?? (brand.isNotEmpty ? brand : null),
              barcode: barcode,
              description: description.isNotEmpty ? description : null,
              photoUrl: imgUrl,
            );
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// Level 3: Fallback de búsqueda web (DuckDuckGo HTML) para códigos no registrados en DBs de alimentos
  Future<ProductLookupResult?> _fetchFromWebSearchFallback(String barcodeOrQuery) async {
    try {
      final uri = Uri.parse('https://html.duckduckgo.com/html/?q=${Uri.encodeComponent(barcodeOrQuery)}');
      final response = await _client.get(
        uri,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final html = response.body;

        final titleRegex = RegExp(r'<a class="result__a"[^>]*>(.*?)<\/a>', dotAll: true, caseSensitive: false);
        final matches = titleRegex.allMatches(html);

        for (final match in matches) {
          var rawTitle = match.group(1) ?? '';
          rawTitle = rawTitle.replaceAll(RegExp(r'<[^>]*>'), '').trim();
          rawTitle = rawTitle.replaceAll('&quot;', '"').replaceAll('&amp;', '&').replaceAll('&#39;', "'");

          if (rawTitle.isNotEmpty && rawTitle.length > 5 && !rawTitle.toLowerCase().contains('duckduckgo')) {
            final taxonomy = _taxonomyService.resolve(title: rawTitle);

            return ProductLookupResult(
              generalSpeciesName: taxonomy.generalSpeciesName,
              subspeciesName: rawTitle,
              brand: taxonomy.inferredBrand,
              barcode: RegExp(r'^\d+$').hasMatch(barcodeOrQuery) ? barcodeOrQuery : null,
            );
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// Priorizar fotos frontales limpias descartando tablas nutricionales o imágenes de laptops en monitores
  String? _extractFrontPhotoUrl(Map<String, dynamic> prod) {
    if (prod['image_front_url'] != null && prod['image_front_url'].toString().isNotEmpty) {
      return prod['image_front_url'].toString();
    }
    if (prod['image_front_large_url'] != null && prod['image_front_large_url'].toString().isNotEmpty) {
      return prod['image_front_large_url'].toString();
    }
    if (prod['image_url'] != null && prod['image_url'].toString().isNotEmpty) {
      final url = prod['image_url'].toString();
      if (!url.contains('nutrition') && !url.contains('ingredients')) {
        return url;
      }
    }
    return null;
  }

  /// Búsqueda directa de imagen de producto limpia vía DuckDuckGo Images cuando la foto sea nula o imprecisa
  Future<String?> _fetchCleanProductImage(String brand, String model) async {
    try {
      final query = Uri.encodeComponent('$brand $model product photo');
      final uri = Uri.parse('https://duckduckgo.com/i.js?q=$query');
      final response = await _client.get(
        uri,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        },
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List?;
        if (results != null && results.isNotEmpty) {
          for (final res in results) {
            final image = res['image']?.toString();
            if (image != null && (image.endsWith('.jpg') || image.endsWith('.png') || image.endsWith('.jpeg') || image.contains('.jpg?') || image.contains('.png?'))) {
              return image;
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// Asegura foto limpia descargada localmente
  Future<ProductLookupResult> _ensureCleanPhotoAndSave(ProductLookupResult result) async {
    String? photoUrl = result.photoUrl;

    if (photoUrl == null || photoUrl.isEmpty) {
      final fetchedPhoto = await _fetchCleanProductImage(result.brand ?? '', result.subspeciesName);
      if (fetchedPhoto != null && fetchedPhoto.isNotEmpty) {
        photoUrl = fetchedPhoto;
      }
    }

    if (photoUrl != null && photoUrl.isNotEmpty) {
      final localPath = await downloadAndSaveImage(photoUrl);
      if (localPath != null) {
        return result.copyWith(photoUrl: photoUrl, localPhotoPath: localPath);
      }
    }

    return result;
  }

  /// Descarga la imagen remota y la guarda localmente en el almacenamiento del dispositivo
  Future<String?> downloadAndSaveImage(String imageUrl) async {
    try {
      final response = await _client.get(Uri.parse(imageUrl)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final appDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory(p.join(appDir.path, 'product_images'));
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        final ext = p.extension(imageUrl).split('?').first;
        final validExt = (ext.isNotEmpty && ext.length <= 5) ? ext : '.jpg';
        final fileName = '${const Uuid().v4()}$validExt';
        final file = File(p.join(imagesDir.path, fileName));
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (_) {}
    return null;
  }
}
