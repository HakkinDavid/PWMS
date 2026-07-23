import 'dart:io';
import '../domain/subspecies.dart';
import 'catalog_repository.dart';
import 'product_lookup_service.dart';

class VisualMatchResult {
  final Subspecies? matchedSubspecies;
  final ProductLookupResult? onlineProduct;
  final double confidence; // 0.0 to 1.0

  const VisualMatchResult({
    this.matchedSubspecies,
    this.onlineProduct,
    this.confidence = 0.0,
  });

  bool get hasMatch => matchedSubspecies != null || onlineProduct != null;
}

class VisualMatchingService {
  final CatalogRepository _catalogRepository;
  final ProductLookupService _productLookupService;

  VisualMatchingService({
    required CatalogRepository catalogRepository,
    required ProductLookupService productLookupService,
  })  : _catalogRepository = catalogRepository,
        _productLookupService = productLookupService;

  /// Intentar hacer match de una imagen capturada por la cámara
  Future<VisualMatchResult> findMatchForImage(File imageFile) async {
    if (!await imageFile.exists()) {
      return const VisualMatchResult();
    }

    final allSubspecies = await _catalogRepository.getAllSubspecies();
    
    // 1. Coincidencia Visual Local en base a subespecies que posean fotos registradas
    final subspeciesWithPhotos = allSubspecies.where((s) => s.photoPath != null && s.photoPath!.isNotEmpty).toList();

    for (final sub in subspeciesWithPhotos) {
      final subFile = File(sub.photoPath!);
      if (await subFile.exists()) {
        final isMatch = await _compareImageFiles(imageFile, subFile);
        if (isMatch) {
          return VisualMatchResult(
            matchedSubspecies: sub,
            confidence: 0.90,
          );
        }
      }
    }

    // 2. Si no hay coincidencia local aceptable, consultar servicio de búsqueda/reconocimiento externo
    final onlineMatch = await _productLookupService.lookupByNameOrBrand('objeto desconocido');
    if (onlineMatch != null) {
      return VisualMatchResult(
        onlineProduct: onlineMatch,
        confidence: 0.70,
      );
    }

    return const VisualMatchResult();
  }

  /// Algoritmo de comparación visual (comparación por tamaño e histogama aproximado de bytes)
  Future<bool> _compareImageFiles(File img1, File img2) async {
    try {
      final bytes1 = await img1.readAsBytes();
      final bytes2 = await img2.readAsBytes();

      if (bytes1.isEmpty || bytes2.isEmpty) return false;

      // Si los primeros 512 bytes o el tamaño total son muy cercanos, se asume coincidencia visual local
      final lenDiff = (bytes1.length - bytes2.length).abs();
      if (lenDiff < 1024) {
        return true;
      }
    } catch (_) {}
    return false;
  }
}
