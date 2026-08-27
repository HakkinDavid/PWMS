import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';
import '../domain/taxonomy/product_taxonomy_service.dart';
import '../../../core/storage/file_storage_service.dart';

class ProductLookupResult {
  final String generalSpeciesName;
  final String subspeciesName;
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
    this.type = AppStrings.typeObject,
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
    final cleanCode = rawBarcode.trim().replaceAll(AppTechnicalStrings.dash, AppTechnicalStrings.empty).replaceAll(AppTechnicalStrings.space, AppTechnicalStrings.empty);
    if (cleanCode.isEmpty) return null;

    // Level 0: ISBN Book Search (Google Books & Open Library)
    if (_isPotentialIsbn(cleanCode)) {
      final isbnResult = await _fetchFromIsbnApis(cleanCode);
      if (isbnResult != null) {
        return await _ensureCleanPhotoAndSave(isbnResult);
      }
    }

    // Level 1: Open Food Facts, Open Beauty Facts, Open Products Facts, Open Pet Food Facts APIs (v2)
    const openFactsDomains = AppTechnicalProductLookup.openFactsDomains;
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
    if (code.length == 13 && (code.startsWith(AppTechnicalStrings.isbnPrefix978) || code.startsWith(AppTechnicalStrings.isbnPrefix979))) return true;
    return false;
  }

  /// Nivel 0: Búsqueda específica de ISBN usando Google Books y Open Library API
  Future<ProductLookupResult?> _fetchFromIsbnApis(String isbn) async {
    // 1. Google Books API
    try {
      final uri = Uri.parse(AppTechnicalStrings.endpointGoogleBooksIsbn + isbn);
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data[AppTechnicalStrings.keyItems] as List?;
        if (items != null && items.isNotEmpty) {
          final volumeInfo = items.first[AppTechnicalStrings.keyVolumeInfo] as Map<String, dynamic>?;
          if (volumeInfo != null) {
            final title = (volumeInfo[AppTechnicalStrings.keyTitle] ?? AppTechnicalStrings.empty).toString().trim();
            final authorsList = volumeInfo[AppTechnicalStrings.keyAuthors] as List?;
            final authorStr = (authorsList != null && authorsList.isNotEmpty) ? authorsList.join(AppTechnicalStrings.commaSpace) : null;
            final publisher = volumeInfo[AppTechnicalStrings.keyPublisher]?.toString();
            final description = volumeInfo[AppTechnicalStrings.colDescription]?.toString();
            final imageLinks = volumeInfo[AppTechnicalStrings.keyImageLinks] as Map<String, dynamic>?;
            var photoUrl = imageLinks?[AppTechnicalStrings.keyThumbnail] ?? imageLinks?[AppTechnicalStrings.keySmallThumbnail];
            if (photoUrl != null && photoUrl.startsWith(AppTechnicalStrings.httpProtocol)) {
              photoUrl = photoUrl.replaceFirst(AppTechnicalStrings.httpProtocol, AppTechnicalStrings.httpsProtocol);
            }

            if (title.isNotEmpty) {
              return ProductLookupResult(
                generalSpeciesName: AppStrings.speciesBook,
                subspeciesName: title,
                brand: authorStr ?? publisher,
                barcode: isbn,
                description: description,
                type: AppStrings.typeDocument,
                photoUrl: photoUrl?.toString(),
              );
            }
          }
        }
      }
    } catch (_) {}

    // 2. Open Library API Fallback
    try {
      final uri = Uri.parse(AppTechnicalStrings.endpointOpenLibraryIsbnPrefix + isbn + AppTechnicalStrings.endpointOpenLibraryIsbnSuffix);
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final key = AppTechnicalStrings.prefixIsbnKey + isbn;
        if (data.containsKey(key)) {
          final bookData = data[key] as Map<String, dynamic>;
          final title = (bookData[AppTechnicalStrings.keyTitle] ?? AppTechnicalStrings.empty).toString().trim();
          final authors = bookData[AppTechnicalStrings.keyAuthors] as List?;
          final authorName = (authors != null && authors.isNotEmpty) ? authors.first[AppTechnicalStrings.colName]?.toString() : null;
          final coverMap = bookData[AppTechnicalStrings.keyCover] as Map<String, dynamic>?;
          final photoUrl = coverMap?[AppTechnicalStrings.keyLarge] ?? coverMap?[AppTechnicalStrings.keyMedium];

          if (title.isNotEmpty) {
            return ProductLookupResult(
              generalSpeciesName: AppStrings.speciesBook,
              subspeciesName: title,
              brand: authorName,
              barcode: isbn,
              type: AppStrings.typeDocument,
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
      final uri = Uri.parse(AppTechnicalStrings.endpointOpenFactsPrefix + domain + AppTechnicalStrings.endpointOpenFactsProductPath + barcode + AppTechnicalStrings.endpointOpenFactsProductExt);
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data[AppTechnicalStrings.keyStatus] == 1 && data[AppTechnicalStrings.keyProduct] != null) {
          final prod = data[AppTechnicalStrings.keyProduct] as Map<String, dynamic>;
          final name = (prod[AppTechnicalStrings.keyProductName] ?? prod[AppTechnicalStrings.keyProductNameEs] ?? prod[AppTechnicalStrings.keyAbbreviatedProductName] ?? AppTechnicalStrings.empty).toString().trim();
          final brand = (prod[AppTechnicalStrings.keyBrands] ?? AppTechnicalStrings.empty).toString().trim();
          final categories = (prod[AppTechnicalStrings.keyCategories] ?? AppTechnicalStrings.empty).toString().trim();
          final genericName = (prod[AppTechnicalStrings.keyGenericName] ?? AppTechnicalStrings.empty).toString().trim();
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
      final uri = Uri.parse(AppTechnicalStrings.endpointUpcItemDbLookup + barcode);
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data[AppTechnicalStrings.keyItems] as List?;
        if (items != null && items.isNotEmpty) {
          final item = items.first as Map<String, dynamic>;
          final title = (item[AppTechnicalStrings.keyTitle] ?? AppTechnicalStrings.empty).toString().trim();
          final brand = (item[AppTechnicalStrings.colBrand] ?? AppTechnicalStrings.empty).toString().trim();
          final category = (item[AppTechnicalStrings.keyCategory] ?? AppTechnicalStrings.empty).toString().trim();
          final description = (item[AppTechnicalStrings.colDescription] ?? AppTechnicalStrings.empty).toString().trim();
          final images = item[AppTechnicalStrings.keyImages] as List?;
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
      final uri = Uri.parse(AppTechnicalStrings.endpointDuckDuckGoHtml + Uri.encodeComponent(barcodeOrQuery));
      final response = await _client.get(
        uri,
        headers: {
          AppTechnicalStrings.headerUserAgent: AppTechnicalStrings.userAgentDesktop,
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final html = response.body;
        final titleRegex = RegExp(AppTechnicalStrings.regexDuckDuckGoResultLink, dotAll: true, caseSensitive: false);
        final matches = titleRegex.allMatches(html);

        for (final match in matches) {
          var rawTitle = match.group(1) ?? AppTechnicalStrings.empty;
          rawTitle = rawTitle.replaceAll(RegExp(AppTechnicalStrings.regexHtmlTags), AppTechnicalStrings.empty).trim();
          rawTitle = rawTitle
              .replaceAll(AppTechnicalStrings.htmlEntityQuot, AppTechnicalStrings.doubleQuote)
              .replaceAll(AppTechnicalStrings.htmlEntityAmp, AppTechnicalStrings.amp)
              .replaceAll(AppTechnicalStrings.htmlEntityApos, AppTechnicalStrings.singleQuote);

          if (rawTitle.isNotEmpty && rawTitle.length > 5 && !rawTitle.toLowerCase().contains(AppTechnicalStrings.siteDuckDuckGo)) {
            final taxonomy = _taxonomyService.resolve(title: rawTitle);

            return ProductLookupResult(
              generalSpeciesName: taxonomy.generalSpeciesName,
              subspeciesName: rawTitle,
              brand: taxonomy.inferredBrand,
              barcode: RegExp(AppTechnicalStrings.digitsOnly).hasMatch(barcodeOrQuery) ? barcodeOrQuery : null,
            );
          }
        }
      }
    } catch (_) {}
    return null;
  }

  String? _extractFrontPhotoUrl(Map<String, dynamic> prod) {
    if (prod[AppTechnicalStrings.keyImageFrontUrl] != null && prod[AppTechnicalStrings.keyImageFrontUrl].toString().isNotEmpty) {
      return prod[AppTechnicalStrings.keyImageFrontUrl].toString();
    }
    if (prod[AppTechnicalStrings.keyImageFrontLargeUrl] != null && prod[AppTechnicalStrings.keyImageFrontLargeUrl].toString().isNotEmpty) {
      return prod[AppTechnicalStrings.keyImageFrontLargeUrl].toString();
    }
    if (prod[AppTechnicalStrings.keyImageUrl] != null && prod[AppTechnicalStrings.keyImageUrl].toString().isNotEmpty) {
      final url = prod[AppTechnicalStrings.keyImageUrl].toString();
      if (!url.contains(AppTechnicalStrings.keyNutrition) && !url.contains(AppTechnicalStrings.keyIngredients)) {
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
      AppTechnicalStrings.headerUserAgent: AppTechnicalStrings.userAgentDesktop,
    };

    // 1. DuckDuckGo Image Search con token vqd
    try {
      String vqd = AppTechnicalStrings.empty;
      final initRes = await _client.get(
        Uri.parse(AppTechnicalStrings.endpointDuckDuckGoSearch + Uri.encodeComponent(cleanQuery)),
        headers: headers,
      ).timeout(const Duration(seconds: 4));

      final vqdMatch = RegExp(AppTechnicalStrings.regexVqdDoubleQuotes).firstMatch(initRes.body) ?? RegExp(AppTechnicalStrings.regexVqdSingleQuotes).firstMatch(initRes.body);
      if (vqdMatch != null) {
        vqd = vqdMatch.group(1) ?? AppTechnicalStrings.empty;
      }

      final uri = Uri.parse(AppTechnicalStrings.endpointDuckDuckGoImageSearch + Uri.encodeComponent(cleanQuery) + AppTechnicalStrings.endpointDuckDuckGoImageParams + vqd);
      final response = await _client.get(uri, headers: headers).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data[AppTechnicalStrings.keyResults] as List?;
        if (results != null) {
          for (final res in results) {
            final image = res[AppTechnicalStrings.keyImage]?.toString();
            if (image != null && image.startsWith(AppTechnicalStrings.httpPrefix) && !imageUrls.contains(image)) {
              final lower = image.toLowerCase();
              if (!lower.endsWith(AppTechnicalStrings.extSvg) && !lower.endsWith(AppTechnicalStrings.extAvif) && !lower.contains(AppTechnicalStrings.dataImagePrefix)) {
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
          AppTechnicalStrings.endpointWikiCommonsSearch + Uri.encodeComponent(cleanQuery) + AppTechnicalStrings.endpointWikiCommonsLimit,
        );
        final res = await _client.get(wikiUri, headers: headers).timeout(const Duration(seconds: 4));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final pages = data[AppTechnicalStrings.keyQuery]?[AppTechnicalStrings.keyPages] as Map<String, dynamic>?;
          if (pages != null) {
            for (final page in pages.values) {
              final original = page[AppTechnicalStrings.keyOriginal]?[AppTechnicalStrings.keySource]?.toString();
              if (original != null && original.startsWith(AppTechnicalStrings.httpPrefix) && !imageUrls.contains(original)) {
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
      final brandPrefix = (result.brand != null && result.brand!.isNotEmpty) ? result.brand! + AppTechnicalStrings.space : AppTechnicalStrings.empty;
      final images = await searchWebImages(brandPrefix + result.subspeciesName);
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
        final ext = p.extension(imageUrl).split(AppTechnicalStrings.questionMark).first;
        final validExt = (ext.isNotEmpty && ext.length <= 5) ? ext : AppTechnicalStrings.extJpg;
        final filename = await _fileStorage.saveBytes(response.bodyBytes, extension: validExt);
        return await _fileStorage.getAbsolutePath(filename);
      }
    } catch (_) {}
    return null;
  }
}
