class PerishabilityInferenceResult {
  final bool isNonPerishable;
  final int? suggestedShelfLifeDays;
  final DateTime? extractedExpirationDate;
  final String? inferenceReason;

  const PerishabilityInferenceResult({
    required this.isNonPerishable,
    this.suggestedShelfLifeDays,
    this.extractedExpirationDate,
    this.inferenceReason,
  });
}

class PerishabilityInferenceEngine {
  const PerishabilityInferenceEngine._();

  /// Parse GS1 Barcode Application Identifiers (AI 17 = Expiration Date, AI 15 = Best Before Date)
  /// Format: (17)YYMMDD or 17YYMMDD, (15)YYMMDD or 15YYMMDD
  static DateTime? parseGS1ExpirationDate(String barcode) {
    final clean = barcode.replaceAll(RegExp(r'[\s\(\)\-]'), '');

    // Check for AI 17 (Expiration) or AI 15 (Best Before) pattern
    final RegExp gs1Regex = RegExp(r'(?:17|15)(\d{2})(\d{2})(\d{2})');
    final match = gs1Regex.firstMatch(clean);

    if (match != null) {
      try {
        final year = 2000 + int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final day = int.parse(match.group(3)!);

        if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
          return DateTime(year, month, day);
        }
      } catch (_) {}
    }
    return null;
  }

  /// Infer perishability and shelf life based on barcode, title, category, and generic name
  static PerishabilityInferenceResult inferPerishability({
    required String type,
    String? title,
    String? category,
    String? genericName,
    String? barcode,
  }) {
    // Rule 1: Non-Object species types (Ser vivo, Documento, Proyecto, etc.) are strictly non-perishable
    if (type != 'Objeto') {
      return const PerishabilityInferenceResult(
        isNonPerishable: true,
        inferenceReason: 'Las especies de tipo distinto a Objeto son No Perecederas por definición.',
      );
    }

    // Rule 2: Check GS1 Barcode for explicit expiration date
    DateTime? gs1Expiration;
    if (barcode != null && barcode.isNotEmpty) {
      gs1Expiration = parseGS1ExpirationDate(barcode);
    }

    final textToAnalyze = '${title ?? ""} ${category ?? ""} ${genericName ?? ""}'.toLowerCase();

    // Check non-perishable keywords explicitly
    final nonPerishableKeywords = [
      'monitor', 'teclado', 'mouse', 'ratón', 'celular', 'smartphone', 'iphone', 'samsung',
      'laptop', 'computadora', 'cable', 'cargador', 'audífonos', 'headset', 'pantalla', 'tv',
      'televisión', 'martillo', 'destornillador', 'tornillo', 'taladro', 'herramienta',
      'mueble', 'silla', 'mesa', 'escritorio', 'estante', 'camisa', 'pantalón', 'zapato',
      'tenis', 'ropa', 'vestido', 'libro', 'cuaderno', 'libreta', 'pluma', 'bolígrafo',
      'vaso', 'taza', 'plato', 'sartén', 'olla', 'mochila', 'bolsa'
    ];

    for (final kw in nonPerishableKeywords) {
      if (textToAnalyze.contains(kw)) {
        return PerishabilityInferenceResult(
          isNonPerishable: true,
          extractedExpirationDate: gs1Expiration,
          inferenceReason: 'Detectado como objeto durable/no alimenticio ($kw).',
        );
      }
    }

    // Check perishable categories & keywords
    if (_containsAny(textToAnalyze, ['leche', 'lait', 'milk', 'yogur', 'yogurt', 'queso', 'crema', 'mantequilla', 'kefir'])) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 14,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: 'Categoría Lácteos (~14 días de vida útil).',
      );
    }

    if (_containsAny(textToAnalyze, ['pan', 'bread', 'torta', 'pastel', 'galleta', 'panqueque', 'donas'])) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 7,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: 'Categoría Panadería (~7 días de vida útil).',
      );
    }

    if (_containsAny(textToAnalyze, ['manzana', 'plátano', 'banana', 'jitomate', 'tomate', 'lechuga', 'aguacate', 'fresa', 'uva', 'fruta', 'verdura'])) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 7,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: 'Categoría Frutas & Verduras (~7 días de vida útil).',
      );
    }

    if (_containsAny(textToAnalyze, ['carne', 'pollo', 'pescado', 'jamón', 'salchicha', 'pavo', 'tocino', 'meat', 'chicken'])) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 5,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: 'Categoría Carnes & Pescados (~5 días de vida útil).',
      );
    }

    if (_containsAny(textToAnalyze, ['jugo', 'zumo', 'juice', 'batido', 'cerveza', 'beer'])) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 30,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: 'Categoría Bebidas Perecederas (~30 días de vida útil).',
      );
    }

    if (_containsAny(textToAnalyze, ['medicamento', 'jarabe', 'pastillas', 'antibiótico', 'suero', 'medicina', 'pharmacy'])) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 365,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: 'Categoría Farmacia / Salud (~365 días de vida útil).',
      );
    }

    if (_containsAny(textToAnalyze, ['atún en lata', 'enlatado', 'conserva', 'mermelada', 'canned'])) {
      return PerishabilityInferenceResult(
        isNonPerishable: false,
        suggestedShelfLifeDays: 365,
        extractedExpirationDate: gs1Expiration,
        inferenceReason: 'Categoría Enlatados & Conservas (~365 días de vida útil).',
      );
    }

    // Default Rule 4: If unclassified or unknown, defaults to No Perecedero
    return PerishabilityInferenceResult(
      isNonPerishable: true,
      extractedExpirationDate: gs1Expiration,
      inferenceReason: 'No se identificó categoría perecedera; configurado como No Perecedero por defecto.',
    );
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((kw) => text.contains(kw));
  }
}
