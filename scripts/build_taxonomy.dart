import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../lib/src/features/catalog/domain/taxonomy/spanish_singularizer.dart';

void main() async {
  print('=== PWMS Sweet Spot Taxonomy Pipeline (GS1 GPC + OFF + Wikidata) ===');

  final client = http.Client();
  final Map<String, Map<String, dynamic>> compiledSpeciesMap = {};

  // 1. Ampliar catálogo de taxonomías de GS1 GPC por departamentos
  final Map<String, List<String>> departmentalTaxonomies = {
    'Herramientas': [
      'Taladro', 'Rotomartillo', 'Esmeriladora', 'Sierra Circular', 'Sierra Caladora', 'Sierra de Banco', 'Lijadora', 'Atornillador', 'Martillo', 'Marro', 'Destornillador', 'Desarmador', 'Pinzas', 'Llave Perica', 'Llave Española', 'Llave Allen', 'Llave Combinada', 'Llave de Estriadas', 'Flexómetro', 'Cinta Métrica', 'Nivel de Gota', 'Nivel Laser', 'Cautín', 'Pistola de Silicona', 'Compresor de Aire', 'Caja de Herramientas', 'Organizador de Herramientas', 'Tornillo', 'Tuerca', 'Rondana', 'Clavo', 'Taquete', 'Pija', 'Broca', 'Lija', 'Cinta Aislar', 'Cinta Canela', 'Carretilla', 'Pala', 'Pico', 'Rastrillo', 'Machete', 'Cincel', 'Arco de Segueta', 'Segueta', 'Prensa C', 'Cuchilla', 'Navaja', 'Cortador de Azulejo', 'Esmeril de Banco', 'Soldadora', 'Careta de Soldar', 'Mascarilla Respiradora', 'Guantes de Trabajo', 'Casco de Seguridad', 'Chaleco Reflejante', 'Gafas de Protección'
    ],
    'Automotriz': [
      'Aceite de Motor', 'Anticongelante', 'Líquido de Frenos', 'Líquido de Dirección', 'Aditivo de Motor', 'Aditivo de Gasolina', 'Llanta', 'Neumático', 'Batería de Auto', 'Cargador de Batería Auto', 'Funda de Auto', 'Tapete de Auto', 'Filtro de Aceite', 'Filtro de Aire', 'Filtro de Gasolina', 'Bujía', 'Limpiaparabrisas', 'Gato Hidráulico', 'Torre de Soporte Auto', 'Amortiguador', 'Pastilla de Freno', 'Disco de Freno', 'Bomba de Agua Auto', 'Bomba de Gasolina', 'Radiador', 'Faro Auto', 'Calavera Auto', 'Pluma Limpiaparabrisas', 'Cera para Auto', 'Shampoo para Auto', 'Grasa Automotriz', 'Sensor de Oxígeno', 'Alternador', 'Marcha Auto'
    ],
    'Plomería y Pintura': [
      'Tubo de PVC', 'Tubo de Cobre', 'Tubo CPVC', 'Tubo Galvanizado', 'Válvula de Paso', 'Válvula Check', 'Llave de Agua', 'Cinta Teflon', 'Pintura Vinílica', 'Pintura Esmalte', 'Pintura en Aerosol', 'Brocha', 'Rodillo', 'Sellador', 'Silicona', 'Impermeabilizante', 'Fregadero', 'Mezcladora', 'Regadera', 'Cespól', 'Empaque', 'Conector PVC', 'Codo PVC', 'Tee PVC', 'Pegamento PVC', 'Calentador de Agua', 'Boiler', 'Bomba de Agua', 'Tinaco', 'Cisterna'
    ],
    'Electrónica y Cómputo': [
      'Tarjeta de Video', 'Procesador', 'Tarjeta Madre', 'Memoria RAM', 'Disco Sólido', 'Disco Duro', 'Fuente de Poder', 'Gabinete PC', 'Disipador', 'Ventilador PC', 'Monitor', 'Laptop', 'Computadora de Escritorio', 'Smartphone', 'Tablet', 'Televisor', 'Audífono', 'Bocina', 'Barra de Sonido', 'Mouse', 'Teclado', 'Cámara', 'Webcam', 'Dron', 'Impresora', 'Escáner', 'Router', 'Switch de Red', 'Módem', 'Cable HDMI', 'Cable USB', 'Cable Ethernet', 'Cargador', 'Batería Portátil', 'Hub USB', 'Micrófono', 'Silla Gamer', 'Volante Gamer', 'Proyector', 'Servidor', 'Antena Wifi', 'Disco Externo', 'Lápiz Óptico', 'Procesador de Audio', 'Mezcladora de Audio', 'Amplificador', 'Lector de Código de Barras', 'No-Break', 'Regulador de Voltaje'
    ],
    'Videojuegos': [
      'Control de Videojuegos', 'Consola de Videojuegos', 'Videojuego', 'Tarjeta de Prepago', 'Gafas de Realidad Virtual', 'Base de Carga', 'Funda de Consola', 'Timón Gamer', 'Palanca de Cambio Gamer', 'Grip de Controller'
    ],
    'Salud y Cuidado Personal': [
      'Jabón', 'Champú', 'Acondicionador', 'Pasta Dental', 'Cepillo Dental', 'Hilo Dental', 'Enjuague Bucal', 'Crema Corporal', 'Crema Facial', 'Bloqueador Solar', 'Desodorante', 'Antitraspirante', 'Rastrillo', 'Rasuradora', 'Espuma de Afeitar', 'Perfume', 'Loción', 'Maquillaje', 'Labial', 'Rímel', 'Esmalte de Uñas', 'Lavado Nasal', 'Solución Salina', 'Medicina', 'Analgésico', 'Antihistamínico', 'Vitamina', 'Jarabe', 'Termómetro', 'Curita', 'Algodón', 'Alcohol Etílico', 'Oxímetro', 'Baumanómetro', 'Glucómetro', 'Jeringa', 'Gasa', 'Venda', 'Suero Oral', 'Pastilla', 'Cápsula', 'Pomada', 'Gel Antibacterial', 'Cortaúñas', 'Cera Depilatoria', 'Secadora de Cabello', 'Plancha de Cabello'
    ],
    'Alimentos y Abarrotes': [
      'Leche', 'Huevo', 'Queso', 'Yogurt', 'Mantequilla', 'Margarina', 'Crema de Leche', 'Puré de Tomate', 'Tomate', 'Jitomate', 'Cebolla', 'Papa', 'Aguacate', 'Limón', 'Manzana', 'Plátano', 'Naranja', 'Uva', 'Fresa', 'Melón', 'Sandía', 'Papaya', 'Piña', 'Mango', 'Azúcar', 'Harina', 'Arroz', 'Frijol', 'Maíz', 'Lenteja', 'Garbanzo', 'Aceite Comestible', 'Salsa', 'Salsa de Chile', 'Dulce de Chile', 'Atún', 'Sardina', 'Chiles en Lata', 'Elote en Lata', 'Sopa en Lata', 'Papa Frita', 'Galleta', 'Chocolate', 'Dulce', 'Palomita', 'Cereal', 'Pan Blanco', 'Pan Dulce', 'Tortilla', 'Jamón', 'Salchicha', 'Tocino', 'Chorizo', 'Carne de Res', 'Carne de Cerdo', 'Pollo', 'Pescado', 'Camarón', 'Cereal de Trigo', 'Avena', 'Miel', 'Mayonesa', 'Mostaza', 'Cátsup', 'Vinagre', 'Mermelada', 'Crema de Cacahuate', 'Sopa de Pasta', 'Puré de Papa', 'Aceitunas', 'Pepinillos'
    ],
    'Bebidas': [
      'Refresco', 'Agua Embotellada', 'Agua Mineral', 'Jugo', 'Néctar', 'Bebida Energética', 'Bebida Deportiva', 'Cerveza', 'Vino', 'Tequila', 'Whisky', 'Ron', 'Vodka', 'Mezcal', 'Brandy', 'Ginebra', 'Café', 'Té', 'Malteada', 'Sidra', 'Licor de Café'
    ],
    'Hogar y Limpieza': [
      'Cloro', 'Detergente', 'Suavizante', 'Lavavajillas', 'Desinfectante', 'Limpiacristales', 'Limpiador Multiusos', 'Jabón Trastes', 'Escoba', 'Trapeador', 'Recogedor', 'Cubeta', 'Fibra de Limpieza', 'Papel Higiénico', 'Servilleta', 'Toalla de Papel', 'Bolsa de Basura', 'Refrigerador', 'Lavadora', 'Secadora', 'Estufa', 'Horno', 'Microondas', 'Licuadora', 'Freidora de Aire', 'Cafetera', 'Batidora', 'Tostadora', 'Aspiradora', 'Sartén', 'Olla', 'Vajilla', 'Vaso', 'Taza', 'Plato', 'Cuchillo de Cocina', 'Tenedor', 'Cuchara', 'Foco', 'Lámpara', 'Manta', 'Almohada', 'Colchón', 'Sábana', 'Cama', 'Ventilador', 'Aire Acondicionado', 'Plancha de Ropa', 'Burro de Planchar'
    ],
    'Ropa y Calzado': [
      'Tenis', 'Zapato', 'Bota', 'Sandalia', 'Playera', 'Camisa', 'Pantalón', 'Jeans', 'Chamarra', 'Sudadera', 'Vestido', 'Short', 'Calcetín', 'Interior', 'Cinturón', 'Gorra', 'Sombrero', 'Bufanda', 'Guantes', 'Traje de Baño'
    ],
    'Mascotas': [
      'Alimento para Perro', 'Alimento para Gato', 'Premio para Mascota', 'Arena para Gato', 'Plato para Mascota', 'Juguete para Mascota', 'Collar para Perro', 'Pechera', 'Correa', 'Cama para Perro', 'Rascador para Gato', 'Shampoo para Perro'
    ],
    'Bebés': [
      'Pañal', 'Toallita Húmeda', 'Fórmula Infantil', 'Biberón', 'Chupón', 'Carriola', 'Cuna', 'Silla de Bebé', 'Esterilizador de Biberones', 'Mordedera'
    ],
    'Juguetes': [
      'Juguete', 'Lego', 'Figura de Acción', 'Muñeca', 'Juego de Mesa', 'Peluche', 'Pista de Carreras', 'Montable', 'Triciclo', 'Patín', 'Rompecabezas', 'Pistola de Juguete'
    ],
    'Oficina y Papelería': [
      'Cuaderno', 'Libreta', 'Pluma', 'Bolígrafo', 'Lápiz', 'Marcador', 'Carpeta', 'Hoja de Papel', 'Grapa', 'Tijeras', 'Mochila', 'Libro', 'Calculadora', 'Engrapadora', 'Cinta Adhesiva', 'Regla', 'Sacapuntas', 'Goma de Borrar', 'Folder'
    ],
    'Deportes': [
      'Mancuerna', 'Tapete de Yoga', 'Balón de Fútbol', 'Balón de Basquetbol', 'Balón de Voleibol', 'Bicicleta', 'Casco de Bicicleta', 'Cuerda para Saltar', 'Raqueta', 'Guantes de Box', 'Banda de Resistencia'
    ]
  };

  for (final entry in departmentalTaxonomies.entries) {
    final dept = entry.key;
    for (final term in entry.value) {
      final singular = SpanishSingularizer.toSingular(term.trim());
      if (singular.isNotEmpty) {
        final key = singular.toLowerCase();
        compiledSpeciesMap[key] = {
          'species': singular,
          'department': dept,
          'keywords': [key, ...key.split(' ').where((w) => w.length >= 3)],
        };
      }
    }
  }

  // 2. Integrar taxonomía masiva adicional desde la API pública de Open Food Facts
  print('-> Descargando taxonomías públicas desde Open Food Facts...');
  try {
    final response = await client.get(
      Uri.parse('https://world.openfoodfacts.org/categories.json'),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tags = data['tags'] as List?;
      if (tags != null) {
        int added = 0;
        for (final tag in tags) {
          final rawName = (tag['name'] ?? '').toString().trim();
          final products = tag['products'] as int? ?? 0;

          if (rawName.isNotEmpty && products >= 2 && !rawName.contains(':')) {
            final singular = SpanishSingularizer.toSingular(rawName);
            final key = singular.toLowerCase();

            if (key.length >= 3 && !compiledSpeciesMap.containsKey(key)) {
              compiledSpeciesMap[key] = {
                'species': singular,
                'department': 'Alimentos y Abarrotes',
                'keywords': [key, ...key.split(' ').where((w) => w.length >= 3)],
              };
              added++;
            }
          }
        }
        print('-> Adicionadas $added especies atómicas adicionales desde la API.');
      }
    }
  } catch (e) {
    print('-> Nota: Fallback local activo. Excepción de API: $e');
  }

  final compiledSpeciesList = compiledSpeciesMap.values.toList();
  print('=== TOTAL FINAL DE ESPECIES ÚNICAS ATÓMICAS EN SINGULAR: ${compiledSpeciesList.length} ===');

  // Guardar archivo JSON compilado masivo
  final jsonFile = File('assets/taxonomy/compiled_species_dictionary.json');
  await jsonFile.writeAsString(const JsonEncoder.withIndent('  ').convert(compiledSpeciesList));

  // Guardar código estático compilado en lib/src/features/catalog/domain/taxonomy/generated_species_registry.dart
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

  print('-> Sweet Spot compilado exitosamente (${compiledSpeciesList.length} especies atómicas en singular).');
}
