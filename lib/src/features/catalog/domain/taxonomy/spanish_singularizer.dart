class SpanishSingularizer {
  SpanishSingularizer._();

  /// Convierte sustantivos plurales en español e inglés a su forma singular estricta
  static String toSingular(String text) {
    var clean = text.trim();
    if (clean.isEmpty) return clean;

    final lower = clean.toLowerCase();

    // Mapeo directo de plurales comunes a singular
    const Map<String, String> explicitPluralToSingular = {
      'audífonos': 'Audífono',
      'audifonos': 'Audífono',
      'tomates': 'Tomate',
      'jabones': 'Jabón',
      'papas': 'Papa',
      'galletas': 'Galleta',
      'chocolates': 'Chocolate',
      'limpiadores': 'Limpiador',
      'detergentes': 'Detergente',
      'suavizantes': 'Suavizante',
      'desinfectantes': 'Desinfectante',
      'cables': 'Cable',
      'cargadores': 'Cargador',
      'adaptadores': 'Adaptador',
      'monitores': 'Monitor',
      'televisores': 'Televisor',
      'pantallas': 'Pantalla',
      'impresoras': 'Impresora',
      'bocinas': 'Bocina',
      'auriculares': 'Auricular',
      'dulces': 'Dulce',
      'botanas': 'Botana',
      'refrescos': 'Refresco',
      'jugos': 'Jugo',
      'cervezas': 'Cerveza',
      'vinos': 'Vino',
      'licores': 'Licor',
      'pastas': 'Pasta',
      'salsas': 'Salsa',
      'aceites': 'Aceite',
      'sartenes': 'Sartén',
      'ollas': 'Olla',
      'vasos': 'Vaso',
      'tazas': 'Taza',
      'herramientas': 'Herramienta',
      'taladros': 'Taladro',
      'martillos': 'Martillo',
      'pinzas': 'Pinza',
      'llaves': 'Llave',
      'tenis': 'Tenis',
      'zapatos': 'Zapato',
      'botas': 'Bota',
      'playeras': 'Playera',
      'camisas': 'Camisa',
      'pantalones': 'Pantalón',
      'sudaderas': 'Sudadera',
      'pañales': 'Pañal',
      'panales': 'Pañal',
      'toallitas': 'Toallita',
      'juguetes': 'Juguete',
      'muñecas': 'Muñeca',
      'croquetas': 'Croqueta',
      'cuadernos': 'Cuaderno',
      'plumas': 'Pluma',
      'marcadores': 'Marcador',
      'carpetas': 'Carpeta',
      'libros': 'Libro',
    };

    if (explicitPluralToSingular.containsKey(lower)) {
      return explicitPluralToSingular[lower]!;
    }

    // Reglas lingüísticas gramaticales para otros términos
    if (lower.endsWith('nes')) {
      clean = clean.substring(0, clean.length - 3) + 'ón';
    } else if (lower.endsWith('res')) {
      clean = clean.substring(0, clean.length - 2);
    } else if (lower.endsWith('ces')) {
      clean = clean.substring(0, clean.length - 3) + 'z';
    } else if (lower.endsWith('es') && !lower.endsWith('ses')) {
      clean = clean.substring(0, clean.length - 2);
    } else if (lower.endsWith('s') && !lower.endsWith('ss') && !lower.endsWith('is') && !lower.endsWith('us') && !lower.endsWith('os')) {
      clean = clean.substring(0, clean.length - 1);
    }

    if (clean.isEmpty) return text;
    return clean[0].toUpperCase() + clean.substring(1);
  }
}
