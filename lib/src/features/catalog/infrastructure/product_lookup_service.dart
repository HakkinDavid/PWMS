import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ProductLookupResult {
  final String generalSpeciesName; // ej. "Monitor", "Bebida", "Teclado"
  final String subspeciesName;     // ej. "Dell Pro 24''", "Coca Cola 600ml"
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

  ProductLookupService({http.Client? client}) : _client = client ?? http.Client();

  /// Consultar producto por código de barras (EAN/UPC) en APIs abiertas
  Future<ProductLookupResult?> lookupByBarcode(String rawBarcode) async {
    final cleanCode = rawBarcode.trim();
    if (cleanCode.isEmpty) return null;

    // 1. Intentar Open Food Facts API (v2)
    final offResult = await _fetchFromOpenFoodFacts(cleanCode);
    if (offResult != null) {
      return await _savePhotoIfPresent(offResult);
    }

    // 2. Intentar UPC Item DB Trial API
    final upcResult = await _fetchFromUpcItemDb(cleanCode);
    if (upcResult != null) {
      return await _savePhotoIfPresent(upcResult);
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

            final speciesName = _extractGeneralSpeciesName(name, categories, genericName);

            final result = ProductLookupResult(
              generalSpeciesName: speciesName,
              subspeciesName: name,
              brand: brand.isNotEmpty ? brand : null,
              barcode: code.isNotEmpty ? code : null,
              photoUrl: imgUrl,
            );
            return await _savePhotoIfPresent(result);
          }
        }
      }
    } catch (_) {}

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
            final speciesName = _extractGeneralSpeciesName(name, categories, genericName);

            return ProductLookupResult(
              generalSpeciesName: speciesName,
              subspeciesName: name,
              brand: brand.isNotEmpty ? brand : null,
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
            final speciesName = _extractGeneralSpeciesName(title, category, null);

            return ProductLookupResult(
              generalSpeciesName: speciesName,
              subspeciesName: title,
              brand: brand.isNotEmpty ? brand : null,
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

  /// Priorizar estrictamente las fotos frontales principales del producto descartando tablas/traseras
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

  /// Abstraer la Especie General (ej. "Monitor", "Televisor", "Smartphone", "Bebida")
  String _extractGeneralSpeciesName(String title, String? categories, String? genericName) {
    final combined = '${genericName ?? ""} ${categories ?? ""} $title'.toLowerCase();

    if (combined.contains('monitor') || combined.contains('pantalla') || combined.contains('display')) return 'Monitor';
    if (combined.contains('tv') || combined.contains('televisor') || combined.contains('television')) return 'Televisor';
    if (combined.contains('laptop') || combined.contains('notebook') || combined.contains('macbook') || combined.contains('portatil') || combined.contains('portátil')) return 'Laptop';
    if (combined.contains('phone') || combined.contains('celular') || combined.contains('smartphone') || combined.contains('iphone')) return 'Smartphone';
    if (combined.contains('headphone') || combined.contains('headset') || combined.contains('audifono') || combined.contains('audífono')) return 'Audífonos';
    if (combined.contains('keyboard') || combined.contains('teclado')) return 'Teclado';
    if (combined.contains('mouse') || combined.contains('raton') || combined.contains('ratón')) return 'Mouse';
    if (combined.contains('camera') || combined.contains('camara') || combined.contains('cámara')) return 'Cámara';
    if (combined.contains('printer') || combined.contains('impresora')) return 'Impresora';
    if (combined.contains('console') || combined.contains('playstation') || combined.contains('xbox') || combined.contains('nintendo')) return 'Consola de Videojuegos';
    if (combined.contains('drink') || combined.contains('refresco') || combined.contains('bebida') || combined.contains('soda') || combined.contains('water') || combined.contains('agua')) return 'Bebida';

    if (genericName != null && genericName.trim().isNotEmpty && genericName.trim().length <= 25) {
      final cleanG = genericName.trim();
      return cleanG[0].toUpperCase() + cleanG.substring(1);
    }

    return 'Objeto';
  }

  /// Descarga la imagen remota y la guarda localmente en el almacenamiento del dispositivo
  Future<ProductLookupResult> _savePhotoIfPresent(ProductLookupResult result) async {
    if (result.photoUrl == null || result.photoUrl!.isEmpty) {
      return result;
    }

    final localPath = await downloadAndSaveImage(result.photoUrl!);
    return result.copyWith(localPhotoPath: localPath);
  }

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
