import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../lib/src/features/catalog/domain/taxonomy/spanish_singularizer.dart';

void main() async {
  print('=== PWMS Massive Taxonomy Builder & Compilador Masivo ===');

  final client = http.Client();
  final Map<String, Map<String, dynamic>> compiledSpeciesMap = {};

  // 1. Cargar fuentes locales amplias de GS1 GPC
  final rawLocalTaxonomy = [
    // Ferretería, Herramientas, Construcción y Plomería
    {'dept': 'Herramientas', 'terms': ['Taladro', 'Rotomartillo', 'Esmeriladora', 'Sierra Circular', 'Sierra Caladora', 'Sierra de Banco', 'Lijadora', 'Atornillador', 'Martillo', 'Marro', 'Destornillador', 'Desarmador', 'Pinzas', 'Llave Perica', 'Llave Española', 'Llave Allen', 'Flexómetro', 'Cinta Métrica', 'Nivel de Gota', 'Cautín', 'Pistola de Silicona', 'Compresor de Aire', 'Caja de Herramientas', 'Tornillo', 'Tuerca', 'Rondana', 'Clavo', 'Taquete', 'Pija', 'Broca', 'Lija', 'Cinta Aislar', 'Cinta Canela', 'Carretilla', 'Pala', 'Pico', 'Rastrillo', 'Machete', 'Cincel', 'Arco de Segueta', 'Segueta', 'Prensa C', 'Cuchilla']},
    {'dept': 'Automotriz', 'terms': ['Aceite de Motor', 'Anticongelante', 'Líquido de Frenos', 'Líquido de Dirección', 'Aditivo de Motor', 'Llanta', 'Neumático', 'Batería de Auto', 'Cargador de Batería Auto', 'Funda de Auto', 'Tapete de Auto', 'Filtro de Aceite', 'Filtro de Aire', 'Bujía', 'Limpiaparabrisas', 'Gato Hidráulico', 'Amortiguador', 'Pastilla de Freno', 'Disco de Freno', 'Bomba de Agua Auto', 'Radiador', 'Faro Auto', 'Calavera Auto', 'Pluma Limpiaparabrisas']},
    {'dept': 'Plomería y Pintura', 'terms': ['Tubo de PVC', 'Tubo de Cobre', 'Válvula de Paso', 'Llave de Agua', 'Cinta Teflon', 'Pintura Vinílica', 'Pintura en Aerosol', 'Brocha', 'Rodillo', 'Sellador', 'Silicona', 'Impermeabilizante', 'Fregadero', 'Mezcladora', 'Regadera', 'Cespól', 'Empaque', 'Conector PVC']},

    // Electrónica, Cómputo y Componentes
    {'dept': 'Electrónica y Cómputo', 'terms': ['Tarjeta de Video', 'Procesador', 'Tarjeta Madre', 'Memoria RAM', 'Disco Sólido', 'Disco Duro', 'Fuente de Poder', 'Gabinete PC', 'Disipador', 'Ventilador PC', 'Monitor', 'Laptop', 'Computadora de Escritorio', 'Smartphone', 'Tablet', 'Televisor', 'Audífono', 'Bocina', 'Barra de Sonido', 'Mouse', 'Teclado', 'Cámara', 'Webcam', 'Dron', 'Impresora', 'Escáner', 'Router', 'Switch de Red', 'Módem', 'Cable HDMI', 'Cable USB', 'Cargador', 'Batería Portátil', 'Hub USB', 'Micrófono', 'Silla Gamer', 'Volante Gamer', 'Proyector', 'Servidor', 'Antena Wifi', 'Disco Externo', 'Lápiz Óptico', 'Procesador de Audio', 'Mezcladora de Audio', 'Amplificador']},

    // Videojuegos y Consolas
    {'dept': 'Videojuegos', 'terms': ['Control de Videojuegos', 'Consola de Videojuegos', 'Videojuego', 'Tarjeta de Prepago', 'Gafas de Realidad Virtual', 'Base de Carga', 'Funda de Consola']},

    // Salud, Cuidado Personal y Farmacia
    {'dept': 'Salud y Cuidado Personal', 'terms': ['Jabón', 'Champú', 'Acondicionador', 'Pasta Dental', 'Cepillo Dental', 'Hilo Dental', 'Enjuague Bucal', 'Crema Corporal', 'Crema Facial', 'Bloqueador Solar', 'Desodorante', 'Antitraspirante', 'Rastrillo', 'Rasuradora', 'Espuma de Afeitar', 'Perfume', 'Loción', 'Maquillaje', 'Labial', 'Rímel', 'Esmalte de Uñas', 'Lavado Nasal', 'Solución Salina', 'Medicina', 'Analgésico', 'Antihistamínico', 'Vitamina', 'Jarabe', 'Termómetro', 'Curita', 'Algodón', 'Alcohol Etílico', 'Oxímetro', 'Baumanómetro', 'Glucómetro', 'Jeringa', 'Gasas', 'Venda', 'Suero Oral', 'Pastilla', 'Cápsula', 'Pomada', 'Gel Antibacterial']},

    // Alimentos, Bebidas y Abarrotes
    {'dept': 'Alimentos y Abarrotes', 'terms': ['Leche', 'Huevo', 'Queso', 'Yogurt', 'Mantequilla', 'Margarina', 'Crema de Leche', 'Puré de Tomate', 'Tomate', 'Jitomate', 'Cebolla', 'Papa', 'Aguacate', 'Limón', 'Manzana', 'Plátano', 'Naranja', 'Uva', 'Fresa', 'Azúcar', 'Harina', 'Arroz', 'Frijol', 'Maíz', 'Lenteja', 'Garbanzo', 'Aceite Comestible', 'Salsa', 'Salsa de Chile', 'Dulce de Chile', 'Atún', 'Sardina', 'Chiles en Lata', 'Elote en Lata', 'Sopa en Lata', 'Papa Frita', 'Galleta', 'Chocolate', 'Dulce', 'Palomita', 'Cereal', 'Pan Blanco', 'Pan Dulce', 'Tortilla', 'Jamón', 'Salchicha', 'Tocino', 'Chorizo', 'Carne de Res', 'Carne de Cerdo', 'Pollo', 'Pescado', 'Camarón', 'Cereal de Trigo', 'Avena', 'Miel']},
    {'dept': 'Bebidas', 'terms': ['Refresco', 'Agua Embotellada', 'Agua Mineral', 'Jugo', 'Néctar', 'Bebida Energética', 'Bebida Deportiva', 'Cerveza', 'Vino', 'Tequila', 'Whisky', 'Ron', 'Vodka', 'Mezcal', 'Brandy', 'Ginebra', 'Café', 'Té', 'Malteada']},

    // Hogar, Limpieza y Electrodomésticos
    {'dept': 'Hogar y Limpieza', 'terms': ['Cloro', 'Detergente', 'Suavizante', 'Lavavajillas', 'Desinfectante', 'Limpiacristales', 'Limpiador Multiusos', 'Jabón Trastes', 'Escoba', 'Trapeador', 'Recogedor', 'Cubeta', 'Fibra de Limpieza', 'Papel Higiénico', 'Servilleta', 'Toalla de Papel', 'Bolsa de Basura', 'Refrigerador', 'Lavadora', 'Secadora', 'Estufa', 'Horno', 'Microondas', 'Licuadora', 'Freidora de Aire', 'Cafetera', 'Batidora', 'Tostadora', 'Aspiradora', 'Sartén', 'Olla', 'Vajilla', 'Vaso', 'Taza', 'Plato', 'Cuchillo de Cocina', 'Tenedor', 'Cuchara', 'Foco', 'Lámpara', 'Manta', 'Almohada', 'Colchón', 'Sábana', 'Cama']},

    // Ropa, Calzado, Juguetes, Bebés y Mascotas
    {'dept': 'Ropa y Calzado', 'terms': ['Tenis', 'Zapato', 'Bota', 'Sandalia', 'Playera', 'Camisa', 'Pantalón', 'Jeans', 'Chamarra', 'Sudadera', 'Vestido', 'Short', 'Calcetín', 'Interior', 'Cinturón', 'Gorra', 'Sombrero']},
    {'dept': 'Mascotas', 'terms': ['Alimento para Perro', 'Alimento para Gato', 'Premio para Mascota', 'Arena para Gato', 'Plato para Mascota', 'Juguete para Mascota', 'Collar para Perro', 'Pechera', 'Correa']},
    {'dept': 'Bebés', 'terms': ['Pañal', 'Toallita Húmeda', 'Fórmula Infantil', 'Biberón', 'Chupón', 'Carriola', 'Cuna', 'Silla de Bebé']},
    {'dept': 'Juguetes', 'terms': ['Juguete', 'Lego', 'Figura de Acción', 'Muñeca', 'Juego de Mesa', 'Peluche', 'Pista de Carreras', 'Montable', 'Triciclo', 'Patín']},

    // Oficina, Papelería y Deportes
    {'dept': 'Oficina y Papelería', 'terms': ['Cuaderno', 'Libreta', 'Pluma', 'Bolígrafo', 'Lápiz', 'Marcador', 'Carpeta', 'Hoja de Papel', 'Grapa', 'Tijeras', 'Mochila', 'Libro', 'Calculadora', 'Engrapadora', 'Cinta Adhesiva', 'Regla']},
    {'dept': 'Deportes', 'terms': ['Mancuerna', 'Tapete de Yoga', 'Balón de Fútbol', 'Balón de Basquetbol', 'Balón de Voleibol', 'Bicicleta', 'Casco de Bicicleta', 'Cuerda para Saltar', 'Raqueta', 'Guantes de Box']},
  ];

  for (final source in rawLocalTaxonomy) {
    final dept = source['dept'] as String;
    final terms = source['terms'] as List<String>;
    for (final term in terms) {
      final singularTerm = SpanishSingularizer.toSingular(term.trim());
      if (singularTerm.isNotEmpty) {
        final key = singularTerm.toLowerCase();
        compiledSpeciesMap[key] = {
          'species': singularTerm,
          'department': dept,
          'keywords': [key, ...key.split(' ').where((w) => w.length >= 3)],
        };
      }
    }
  }

  // 2. Descargar y compilar taxonomía masiva desde Open Food Facts Categories API
  print('-> Descargando taxonomías públicas masivas desde Open Food Facts...');
  try {
    final response = await client.get(
      Uri.parse('https://world.openfoodfacts.org/categories.json'),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tags = data['tags'] as List?;
      if (tags != null) {
        int addedFromApi = 0;
        for (final tag in tags) {
          final name = (tag['name'] ?? '').toString().trim();
          final products = tag['products'] as int? ?? 0;

          if (name.isNotEmpty && products >= 5 && !name.contains(':')) {
            final singularName = SpanishSingularizer.toSingular(name);
            final key = singularName.toLowerCase();

            if (key.length >= 3 && !compiledSpeciesMap.containsKey(key)) {
              compiledSpeciesMap[key] = {
                'species': singularName,
                'department': 'Alimentos y Abarrotes',
                'keywords': [key, ...key.split(' ').where((w) => w.length >= 3)],
              };
              addedFromApi++;
            }
          }
        }
        print('-> Integradas $addedFromApi categorías adicionales desde Open Food Facts API.');
      }
    }
  } catch (e) {
    print('-> Nota: Fallback local activo. Excepción durante descarga API: $e');
  }

  final compiledSpeciesList = compiledSpeciesMap.values.toList();
  print('=== TOTAL FINAL DE ESPECIES ÚNICAS ATÓMICAS EN SINGULAR: ${compiledSpeciesList.length} ===');

  // Guardar archivo JSON compilado masivo
  final jsonFile = File('assets/taxonomy/compiled_species_dictionary.json');
  await jsonFile.writeAsString(const JsonEncoder.withIndent('  ').convert(compiledSpeciesList));

  // Guardar código estático compilado masivo
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

  print('-> Guardados $compiledSpeciesList items en assets y GeneratedSpeciesRegistry.');
}
