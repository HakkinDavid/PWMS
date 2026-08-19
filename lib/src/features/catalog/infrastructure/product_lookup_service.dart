import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../domain/taxonomy/product_taxonomy_service.dart';
import '../../../core/storage/file_storage_service.dart';

class ProductLookupResult {
  final String generalSpeciesName; // ej. "Monitor", "Libro", "Control de Videojuegos"
  final String subspeciesName;     // ej. "Cien Años de Soledad", "Dell P2425DE"
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
  final FileStorageService _fileStorage;

  ProductLookupService({
    http.Client? client,
    ProductTaxonomyService? taxonomyService,
    FileStorageService? fileStorage,
  })  : _client = client ?? http.Client(),
        _taxonomyService = taxonomyService ?? ProductTaxonomyService(),
        _fileStorage = fileStorage ?? FileStorageService();

  /// Consultar producto por código de barras o ISBN con arquitectura multinivel
  Future<ProductLookupResult?> lookupByBarcode(String rawBarcode) async {
    final cleanCode = rawBarcode.trim().replaceAll('-', '').replaceAll(' ', '');
    if (cleanCode.isEmpty) return null;

    // Level 0: ISBN Book Search (Google Books & Open Library)
    if (_isPotentialIsbn(cleanCode)) {
      final isbnResult = await _fetchFromIsbnApis(cleanCode);
      if (isbnResult != null) {
        return await _ensureCleanPhotoAndSave(isbnResult);
      }
    }

    // Level 1: Open Food Facts, Open Beauty Facts, Open Products Facts, Open Pet Food Facts APIs (v2)
    final openFactsDomains = [
      'world.openfoodfacts.org',
      'world.openbeautyfacts.org',
      'world.openproductsfacts.org',
      'world.openpetfoodfacts.org',
    ];
    for (final domain in openFactsDomains) {
      final offResult = await _fetchFromOpenFactsApi(domain, cleanCode);
      if (offResult != null) {
        return await _ensureCleanPhotoAndSave(offResult);
      }
    }

    // Level 2: UPC Item DB Trial API
    final upcResult = await _fetchFromUpcItemDb(cleanCode);
    if (upcResult != null) {
      return await _ensureCleanPhotoAndSave(upcResult);
    }

    // Level 3: Web Fallback por Código de Barras
    final webResult = await _fetchFromWebSearchFallback(cleanCode);
    if (webResult != null) {
      return await _ensureCleanPhotoAndSave(webResult);
    }

    return null;
  }

  bool _isPotentialIsbn(String code) {
    if (code.length == 10) return true;
    if (code.length == 13 && (code.startsWith('978') || code.startsWith('979'))) return true;
    return false;
  }

  /// Nivel 0: Búsqueda específica de ISBN usando Google Books y Open Library API
  Future<ProductLookupResult?> _fetchFromIsbnApis(String isbn) async {
    // 1. Google Books API
    try {
      final uri = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn');
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List?;
        if (items != null && items.isNotEmpty) {
          final volumeInfo = items.first['volumeInfo'] as Map<String, dynamic>?;
          if (volumeInfo != null) {
            final title = (volumeInfo['title'] ?? '').toString().trim();
            final authorsList = volumeInfo['authors'] as List?;
            final authorStr = (authorsList != null && authorsList.isNotEmpty) ? authorsList.join(', ') : null;
            final publisher = volumeInfo['publisher']?.toString();
            final description = volumeInfo['description']?.toString();
            final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;
            var photoUrl = imageLinks?['thumbnail'] ?? imageLinks?['smallThumbnail'];
            if (photoUrl != null && photoUrl.startsWith('http:')) {
              photoUrl = photoUrl.replaceFirst('http:', 'https:');
            }

            if (title.isNotEmpty) {
              return ProductLookupResult(
                generalSpeciesName: 'Libro',
                subspeciesName: title,
                brand: authorStr ?? publisher,
                barcode: isbn,
                description: description,
                type: 'Documento',
                photoUrl: photoUrl?.toString(),
              );
            }
          }
        }
      }
    } catch (_) {}

    // 2. Open Library API Fallback
    try {
      final uri = Uri.parse('https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data');
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final key = 'ISBN:$isbn';
        if (data.containsKey(key)) {
          final bookData = data[key] as Map<String, dynamic>;
          final title = (bookData['title'] ?? '').toString().trim();
          final authors = bookData['authors'] as List?;
          final authorName = (authors != null && authors.isNotEmpty) ? authors.first['name']?.toString() : null;
          final coverMap = bookData['cover'] as Map<String, dynamic>?;
          final photoUrl = coverMap?['large'] ?? coverMap?['medium'];

          if (title.isNotEmpty) {
            return ProductLookupResult(
              generalSpeciesName: 'Libro',
              subspeciesName: title,
              brand: authorName,
              barcode: isbn,
              type: 'Documento',
              photoUrl: photoUrl?.toString(),
            );
          }
        }
      }
    } catch (_) {}

    return null;
  }

  Future<ProductLookupResult?> _fetchFromOpenFactsApi(String domain, String barcode) async {
    try {
      final uri = Uri.parse('https://$domain/api/v2/product/$barcode.json');
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

  /// Buscar múltiples opciones de imágenes en Internet para un término de búsqueda (Requisito 3 y 5)
  Future<List<String>> searchWebImages(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];
    final List<String> imageUrls = [];
    final headers = {
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    };

    // 1. DuckDuckGo Image Search con token vqd
    try {
      String vqd = '';
      final initRes = await _client.get(
        Uri.parse('https://duckduckgo.com/?q=${Uri.encodeComponent(cleanQuery)}'),
        headers: headers,
      ).timeout(const Duration(seconds: 4));

      final vqdMatch = RegExp(r'vqd="([^"]+)"').firstMatch(initRes.body) ?? RegExp(r"vqd=([^&'\s]+)").firstMatch(initRes.body);
      if (vqdMatch != null) {
        vqd = vqdMatch.group(1) ?? '';
      }

      final uri = Uri.parse('https://duckduckgo.com/i.js?q=${Uri.encodeComponent(cleanQuery)}&o=json&vqd=$vqd');
      final response = await _client.get(uri, headers: headers).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List?;
        if (results != null) {
          for (final res in results) {
            final image = res['image']?.toString();
            if (image != null && image.startsWith('http') && !imageUrls.contains(image)) {
              final lower = image.toLowerCase();
              if (!lower.endsWith('.svg') && !lower.endsWith('.avif') && !lower.contains('data:image')) {
                imageUrls.add(image);
                if (imageUrls.length >= 12) break;
              }
            }
          }
        }
      }
    } catch (_) {}

    // 2. Fallback Wikimedia Commons API si se obtuvieron menos de 4 imágenes
    if (imageUrls.length < 4) {
      try {
        final wikiUri = Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages&piprop=original&generator=search&gsrsearch=${Uri.encodeComponent(cleanQuery)}&gsrlimit=8',
        );
        final res = await _client.get(wikiUri, headers: headers).timeout(const Duration(seconds: 4));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final pages = data['query']?['pages'] as Map<String, dynamic>?;
          if (pages != null) {
            for (final page in pages.values) {
              final original = page['original']?['source']?.toString();
              if (original != null && original.startsWith('http') && !imageUrls.contains(original)) {
                imageUrls.add(original);
              }
            }
          }
        }
      } catch (_) {}
    }

    return imageUrls;
  }

  Future<ProductLookupResult> _ensureCleanPhotoAndSave(ProductLookupResult result) async {
    String? photoUrl = result.photoUrl;

    if (photoUrl == null || photoUrl.isEmpty) {
      final images = await searchWebImages('${result.brand ?? ''} ${result.subspeciesName}');
      if (images.isNotEmpty) {
        photoUrl = images.first;
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

  Future<String?> downloadAndSaveImage(String imageUrl) async {
    try {
      final response = await _client.get(Uri.parse(imageUrl)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ext = p.extension(imageUrl).split('?').first;
        final validExt = (ext.isNotEmpty && ext.length <= 5) ? ext : '.jpg';
        final filename = await _fileStorage.saveBytes(response.bodyBytes, extension: validExt);
        return await _fileStorage.getAbsolutePath(filename);
      }
    } catch (_) {}
    return null;
  }
}
