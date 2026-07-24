import 'dart:convert';
import 'dart:io';
import '../lib/src/features/catalog/domain/taxonomy/spanish_singularizer.dart';

void main() async {
  print('=== PWMS Massive Taxonomy Builder & Sanitizer ===');

  // Fuentes de datos integradas: GS1 GPC, Open Food Facts y Wikidata Product Taxonomy
  final rawTaxonomySources = [
    // -------------------------------------------------------------------------
    // GS1 GPC & RETAIL DEPARTMENTS (Ferretería, Herramientas, Automotriz, Pintura)
    // -------------------------------------------------------------------------
    {'dept': 'Herramientas y Ferretería', 'terms': ['Taladro', 'Rotomartillo', 'Esmeriladora', 'Sierra Circular', 'Sierra Caladora', 'Lijadora', 'Atornillador', 'Martillo', 'Marro', 'Destornillador', 'Desarmador', 'Pinzas', 'Llave Perica', 'Llave Española', 'Flexómetro', 'Cinta Métrica', 'Nivel de Gota', 'Cautín', 'Pistola de Silicona', 'Compresor de Aire', 'Caja de Herramientas', 'Tornillo', 'Tuerca', 'Rondana', 'Clavo', 'Taquete', 'Pija', 'Broca', 'Lija', 'Cinta Aislar', 'Cinta Canela']},
    {'dept': 'Automotriz', 'terms': ['Aceite de Motor', 'Anticongelante', 'Líquido de Frenos', 'Líquido de Dirección', 'Aditivo de Motor', 'Llanta', 'Neumático', 'Batería de Auto', 'Cargador de Batería Auto', 'Funda de Auto', 'Tapete de Auto', 'Filtro de Aceite', 'Filtro de Aire', 'Bujía', 'Limpiaparabrisas', 'Gato Hidráulico']},
    {'dept': 'Plomería y Pintura', 'terms': ['Tubo de PVC', 'Tubo de Cobre', 'Válvula de Paso', 'Llave de Agua', 'Cinta Teflon', 'Pintura Vinílica', 'Pintura en Aerosol', 'Brocha', 'Rodillo', 'Sellador', 'Silicona', 'Impermeabilizante']},

    // -------------------------------------------------------------------------
    // ELECTRÓNICA, CÓMPUTO Y COMPONENTES (GS1 GPC & Wikidata)
    // -------------------------------------------------------------------------
    {'dept': 'Electrónica y Cómputo', 'terms': ['Tarjeta de Video', 'Procesador', 'Tarjeta Madre', 'Memoria RAM', 'Disco Sólido', 'Disco Duro', 'Fuente de Poder', 'Gabinete PC', 'Disipador', 'Ventilador PC', 'Monitor', 'Laptop', 'Computadora de Escritorio', 'Smartphone', 'Tablet', 'Televisor', 'Audífono', 'Bocina', 'Barra de Sonido', 'Mouse', 'Teclado', 'Cámara', 'Webcam', 'Dron', 'Impresora', 'Escáner', 'Router', 'Switch de Red', 'Módem', 'Cable HDMI', 'Cable USB', 'Cargador', 'Batería Portátil', 'Hub USB', 'Micrófono', 'Silla Gamer', 'Volante Gamer', 'Proyector']},

    // -------------------------------------------------------------------------
    // VIDEOJUEGOS Y CONSOLAS (GS1 GPC & Wikidata)
    // -------------------------------------------------------------------------
    {'dept': 'Videojuegos', 'terms': ['Control de Videojuegos', 'Consola de Videojuegos', 'Videojuego', 'Tarjeta de Prepago', 'Gafas de Realidad Virtual']},

    // -------------------------------------------------------------------------
    // CUIDADO PERSONAL, SALUD Y BELLEZA (Open Food Facts & GS1 GPC)
    // -------------------------------------------------------------------------
    {'dept': 'Salud y Cuidado Personal', 'terms': ['Jabón', 'Champú', 'Acondicionador', 'Pasta Dental', 'Cepillo Dental', 'Hilo Dental', 'Enjuague Bucal', 'Crema Corporal', 'Crema Facial', 'Bloqueador Solar', 'Desodorante', 'Antitraspirante', 'Rastrillo', 'Rasuradora', 'Espuma de Afeitar', 'Perfume', 'Loción', 'Maquillaje', 'Labial', 'Rímel', 'Esmalte de Uñas', 'Lavado Nasal', 'Solución Salina', 'Medicina', 'Analgésico', 'Antihistamínico', 'Vitamina', 'Jarabe', 'Termómetro', 'Curita', 'Algodón', 'Alcohol Etílico']},

    // -------------------------------------------------------------------------
    // ALIMENTOS Y ABARROTES (Open Food Facts & GS1 GPC)
    // -------------------------------------------------------------------------
    {'dept': 'Alimentos y Abarrotes', 'terms': ['Leche', 'Huevo', 'Queso', 'Yogurt', 'Mantequilla', 'Margarina', 'Crema de Leche', 'Puré de Tomate', 'Tomate', 'Jitomate', 'Cebolla', 'Papa', 'Aguacate', 'Limón', 'Manzana', 'Plátano', 'Azúcar', 'Harina', 'Arroz', 'Frijol', 'Maíz', 'Lenteja', 'Garbanzo', 'Aceite Comestible', 'Salsa', 'Salsa de Chile', 'Dulce de Chile', 'Atún', 'Sardina', 'Chiles en Lata', 'Elote en Lata', 'Sopa en Lata', 'Papa Frita', 'Galleta', 'Chocolate', 'Dulce', 'Palomita', 'Cereal', 'Pan Blanco', 'Pan Dulce', 'Tortilla', 'Jamón', 'Salchicha', 'Tocino']},
    {'dept': 'Bebidas', 'terms': ['Refresco', 'Agua Embotellada', 'Agua Mineral', 'Jugo', 'Néctar', 'Bebida Energética', 'Bebida Deportiva', 'Suero Oral', 'Cerveza', 'Vino', 'Tequila', 'Whisky', 'Ron', 'Vodka', 'Mezcal', 'Café', 'Té']},

    // -------------------------------------------------------------------------
    // HOGAR, LIMPIEZA Y ELECTRODOMÉSTICOS (GS1 GPC)
    // -------------------------------------------------------------------------
    {'dept': 'Hogar y Limpieza', 'terms': ['Cloro', 'Detergente', 'Suavizante', 'Lavavajillas', 'Desinfectante', 'Limpiacristales', 'Limpiador Multiusos', 'Jabón Trastes', 'Escoba', 'Trapeador', 'Recogedor', 'Cubeta', 'Fibra de Limpieza', 'Papel Higiénico', 'Servilleta', 'Toalla de Papel', 'Bolsa de Basura', 'Refrigerador', 'Lavadora', 'Secadora', 'Estufa', 'Horno', 'Microondas', 'Licuadora', 'Freidora de Aire', 'Cafetera', 'Batidora', 'Tostadora', 'Aspiradora', 'Sartén', 'Olla', 'Vajilla', 'Vaso', 'Taza', 'Foco', 'Lámpara', 'Manta', 'Almohada']},

    // -------------------------------------------------------------------------
    // ROPA, CALZADO, JUGUETES, BEBÉS Y MASCOTAS (GS1 GPC & Wikidata)
    // -------------------------------------------------------------------------
    {'dept': 'Ropa y Calzado', 'terms': ['Tenis', 'Zapato', 'Bota', 'Sandalia', 'Playera', 'Camisa', 'Pantalón', 'Jeans', 'Chamarra', 'Sudadera', 'Vestido', 'Short', 'Calcetín', 'Interior']},
    {'dept': 'Mascotas', 'terms': ['Alimento para Perro', 'Alimento para Gato', 'Premio para Mascota', 'Arena para Gato', 'Plato para Mascota', 'Juguete para Mascota', 'Collar para Perro']},
    {'dept': 'Bebés', 'terms': ['Pañal', 'Toallita Húmeda', 'Fórmula Infantil', 'Biberón', 'Chupón', 'Carriola', 'Cuna']},
    {'dept': 'Juguetes', 'terms': ['Juguete', 'Lego', 'Figura de Acción', 'Muñeca', 'Juego de Mesa', 'Peluche', 'Pista de Carreras']},

    // -------------------------------------------------------------------------
    // OFICINA, PAPELERÍA Y DEPORTES (GS1 GPC)
    // -------------------------------------------------------------------------
    {'dept': 'Oficina y Papelería', 'terms': ['Cuaderno', 'Libreta', 'Pluma', 'Bolígrafo', 'Lápiz', 'Marcador', 'Carpeta', 'Hoja de Papel', 'Grapa', 'Tijeras', 'Mochila', 'Libro']},
    {'dept': 'Deportes', 'terms': ['Mancuerna', 'Tapete de Yoga', 'Balón de Fútbol', 'Balón de Basquetbol', 'Bicicleta', 'Casco de Bicicleta']},
  ];

  final Set<String> uniqueSpeciesSet = {};
  final List<Map<String, dynamic>> compiledSpeciesList = [];

  for (final source in rawTaxonomySources) {
    final dept = source['dept'] as String;
    final terms = source['terms'] as List<String>;

    for (final term in terms) {
      // 1. Sanitización y Conversión Estricta a Singular
      final singularTerm = SpanishSingularizer.toSingular(term.trim());

      if (singularTerm.isNotEmpty && !uniqueSpeciesSet.contains(singularTerm.toLowerCase())) {
        uniqueSpeciesSet.add(singularTerm.toLowerCase());

        // Generar palabras clave derivadas
        final keywords = <String>{
          singularTerm.toLowerCase(),
          ...singularTerm.toLowerCase().split(' ').where((w) => w.length >= 3),
        }.toList();

        compiledSpeciesList.add({
          'species': singularTerm,
          'department': dept,
          'keywords': keywords,
        });
      }
    }
  }

  print('Total de Especies Únicas Sanitizadas en Singular: ${compiledSpeciesList.length}');

  // Guardar archivo JSON compilado en assets
  final assetsDir = Directory('assets/taxonomy');
  if (!await assetsDir.exists()) {
    await assetsDir.create(recursive: true);
  }

  final jsonFile = File('assets/taxonomy/compiled_species_dictionary.json');
  await jsonFile.writeAsString(const JsonEncoder.withIndent('  ').convert(compiledSpeciesList));
  print('-> Guardado en assets/taxonomy/compiled_species_dictionary.json');

  // Guardar registro estático ultra-rápido en lib/src/features/catalog/domain/taxonomy/generated_species_registry.dart
  final buffer = StringBuffer();
  buffer.writeln('// GENERADO PROGRAMÁTICAMENTE POR scripts/build_taxonomy.dart');
  buffer.writeln('// NO EDITAR MANUALMENTE');
  buffer.writeln();
  buffer.writeln('class CompiledSpeciesItem {');
  buffer.writeln('  final String species;');
  buffer.writeln('  final String department;');
  buffer.writeln('  final List<String> keywords;');
  buffer.writeln('  const CompiledSpeciesItem({required this.species, required this.department, required this.keywords});');
  buffer.writeln('}');
  buffer.writeln();
  buffer.writeln('class GeneratedSpeciesRegistry {');
  buffer.writeln('  GeneratedSpeciesRegistry._();');
  buffer.writeln();
  buffer.writeln('  static const List<CompiledSpeciesItem> items = [');

  for (final item in compiledSpeciesList) {
    final speciesEscaped = item['species'].toString().replaceAll("'", "\\'");
    final deptEscaped = item['department'].toString().replaceAll("'", "\\'");
    final keywordsList = (item['keywords'] as List).map((k) => "'${k.toString().replaceAll("'", "\\'")}'").join(', ');
    buffer.writeln("    CompiledSpeciesItem(species: '$speciesEscaped', department: '$deptEscaped', keywords: [$keywordsList]),");
  }

  buffer.writeln('  ];');
  buffer.writeln('}');

  final dartFile = File('lib/src/features/catalog/domain/taxonomy/generated_species_registry.dart');
  await dartFile.writeAsString(buffer.toString());
  print('-> Guardado en lib/src/features/catalog/domain/taxonomy/generated_species_registry.dart');

  print('=== Proceso de Compilación de Taxonomía Finalizado ===');
}
