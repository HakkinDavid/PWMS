import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ProductLookupResult {
  final String productName;
  final String? brand;
  final String? barcode;
  final String? description;
  final String type;
  final String? photoUrl;
  final String? localPhotoPath;
  final Map<String, dynamic> extraAttributes;

  const ProductLookupResult({
    required this.productName,
    this.brand,
    this.barcode,
    this.description,
    this.type = 'Objeto',
    this.photoUrl,
    this.localPhotoPath,
    this.extraAttributes = const {},
  });

  ProductLookupResult copyWith({
    String? productName,
    String? brand,
    String? barcode,
    String? description,
    String? type,
    String? photoUrl,
    String? localPhotoPath,
    Map<String, dynamic>? extraAttributes,
  }) {
    return ProductLookupResult(
      productName: productName ?? this.productName,
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
            final imgUrl = prod['image_front_url'] ?? prod['image_url'];
            final result = ProductLookupResult(
              productName: name,
              brand: brand.isNotEmpty ? brand : null,
              barcode: code.isNotEmpty ? code : null,
              photoUrl: imgUrl?.toString(),
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
          final imgUrl = prod['image_front_url'] ?? prod['image_url'] ?? prod['image_small_url'];

          if (name.isNotEmpty) {
            return ProductLookupResult(
              productName: name,
              brand: brand.isNotEmpty ? brand : null,
              barcode: barcode,
              description: categories.isNotEmpty ? categories : null,
              photoUrl: imgUrl?.toString(),
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
          final description = (item['description'] ?? '').toString().trim();
          final images = item['images'] as List?;
          final imgUrl = (images != null && images.isNotEmpty) ? images.first.toString() : null;

          if (title.isNotEmpty) {
            return ProductLookupResult(
              productName: title,
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
