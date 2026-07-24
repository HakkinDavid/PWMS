class CategoryDefinition {
  final String generalSpeciesName;
  final String department;
  final List<String> keywords;
  final List<String>? regexPatterns;

  const CategoryDefinition({
    required this.generalSpeciesName,
    required this.department,
    required this.keywords,
    this.regexPatterns,
  });
}

class ProductTaxonomyDictionary {
  ProductTaxonomyDictionary._();

  static const List<CategoryDefinition> definitions = [
    // -------------------------------------------------------------------------
    // 1. ELECTRÓNICA, CÓMPUTO Y COMPONENTES
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Tarjeta de Video',
      department: 'Electrónica y Cómputo',
      keywords: ['rtx', 'gtx', 'radeon', 'gpu', 'graphics card', 'tarjeta de video', 'tarjeta grafica', 'tarjeta gráfica', 'gddr6', 'gddr6x'],
      regexPatterns: [r'\b(rtx|gtx)\s*\d{3,4}\b', r'\brx\s*\d{3,4}\b'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Procesador',
      department: 'Electrónica y Cómputo',
      keywords: ['ryzen', 'core i3', 'core i5', 'core i7', 'core i9', 'cpu', 'procesador', 'intel core', 'threadripper'],
      regexPatterns: [r'\bi[3579]-\d{4,5}[a-z]*\b', r'\bryzen\s*[3579]\b'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Tarjeta Madre',
      department: 'Electrónica y Cómputo',
      keywords: ['motherboard', 'tarjeta madre', 'placa base', 'am4', 'am5', 'lga1700', 'b550', 'b650', 'z790', 'x670'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Memoria RAM',
      department: 'Electrónica y Cómputo',
      keywords: ['ddr4', 'ddr5', 'memoria ram', 'ram kit', 'sodimm', 'dimm'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Almacenamiento',
      department: 'Electrónica y Cómputo',
      keywords: ['ssd', 'nvme', 'disco duro', 'hard drive', 'm.2', 'disco solido', 'disco sólido', 'memoria sd', 'micro sd', 'usb drive', 'pendrive'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Fuente de Poder',
      department: 'Electrónica y Cómputo',
      keywords: ['fuente de poder', 'power supply', 'psu', '80 plus', 'modular psu'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Gabinete PC',
      department: 'Electrónica y Cómputo',
      keywords: ['pc case', 'gabinete pc', 'chasis pc', 'mid tower', 'full tower'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Enfriamiento PC',
      department: 'Electrónica y Cómputo',
      keywords: ['liquid cooler', 'disipador', 'fan pc', 'ventilador pc', 'aio cooler', 'water cooling'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Monitor',
      department: 'Electrónica y Cómputo',
      keywords: ['monitor', 'pantalla', 'display', 'p2425de', 'g65b', 'odyssey', 'curved monitor', 'gaming monitor', 'hz monitor'],
      regexPatterns: [r'\b\d{2}"\s*monitor\b', r'\b\d{2}-inch\b'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Laptop',
      department: 'Electrónica y Cómputo',
      keywords: ['laptop', 'notebook', 'macbook', 'portatil', 'portátil', 'chromebook', 'ultrabook', 'thinkpad', 'zenbook', 'ideapad', 'pavilion'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Computadora de Escritorio',
      department: 'Electrónica y Cómputo',
      keywords: ['desktop', 'computadora de escritorio', 'all in one', 'imac', 'pc armadas', 'workstation'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Smartphone',
      department: 'Electrónica y Cómputo',
      keywords: ['galaxy a', 'galaxy s', 'iphone', 'pixel', 'smartphone', 'celular', 'telefono', 'teléfono', 'xiaomi redmi', 'motorola edge'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Tablet',
      department: 'Electrónica y Cómputo',
      keywords: ['ipad', 'galaxy tab', 'tablet', 'tableta', 'kindle', 'surface pro'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Televisor',
      department: 'Electrónica y Cómputo',
      keywords: ['smart tv', 'televisor', 'television', 'televisión', 'oled tv', 'qled tv', '4k tv', 'roku tv'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Audífonos',
      department: 'Electrónica y Cómputo',
      keywords: ['headphone', 'headset', 'audifono', 'audífono', 'earbuds', 'airpods', 'auriculares', 'in-ear', 'over-ear'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Bocina',
      department: 'Electrónica y Cómputo',
      keywords: ['bocina', 'speaker', 'soundbar', 'barra de sonido', 'bocina bluetooth', 'altavoz'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Mouse',
      department: 'Electrónica y Cómputo',
      keywords: ['g203', 'g502', 'mouse', 'raton', 'ratón', 'mouse gamer', 'mouse inalambrico'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Teclado',
      department: 'Electrónica y Cómputo',
      keywords: ['keyboard', 'teclado', 'keychron', 'teclado mecanico', 'teclado mecánico', 'teclado gamer'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cámara',
      department: 'Electrónica y Cómputo',
      keywords: ['cámara', 'camara', 'camera', 'dslr', 'mirrorless', 'webcam', 'camara web', 'gopro', 'action cam'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Dron',
      department: 'Electrónica y Cómputo',
      keywords: ['dron', 'drone', 'quadcopter', 'dji mavic', 'dji mini'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Impresora',
      department: 'Electrónica y Cómputo',
      keywords: ['impresora', 'printer', 'laserjet', 'ecotank', 'multifuncional', 'impresora 3d', '3d printer'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Redes y Conectividad',
      department: 'Electrónica y Cómputo',
      keywords: ['router', 'switch red', 'modem', 'módem', 'repetidor wifi', 'mesh wifi', 'access point'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cables y Adaptadores',
      department: 'Electrónica y Cómputo',
      keywords: ['cable hdmi', 'cable usb', 'adaptador usb-c', 'hub usb', 'cargador', 'power bank', 'bateria portable'],
    ),

    // -------------------------------------------------------------------------
    // 2. VIDEOJUEGOS Y CONSOLAS
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Control de Videojuegos',
      department: 'Videojuegos',
      keywords: ['dualsense', 'dualshock', 'gamepad', 'controller', 'joy-con', 'controlador', 'control ps5', 'control xbox', 'volante gamer', 'joystick'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Consola de Videojuegos',
      department: 'Videojuegos',
      keywords: ['playstation', 'xbox', 'nintendo switch', 'ps5', 'ps4', 'xbox series', 'steam deck'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Videojuego',
      department: 'Videojuegos',
      keywords: ['juego ps5', 'juego xbox', 'juego nintendo', 'videojuego', 'game disc', 'cartucho nintendo'],
    ),

    // -------------------------------------------------------------------------
    // 3. CUIDADO PERSONAL, SALUD Y BELLEZA
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Cuidado Personal / Salud',
      department: 'Salud y Cuidado Personal',
      keywords: ['sinusrinse', 'neilmed', 'saline', 'nasal', 'rinse', 'farmacia', 'salud', 'medicina', 'antihistaminico', 'solucion salina'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Jabón',
      department: 'Salud y Cuidado Personal',
      keywords: ['jabon', 'jabón', 'body wash', 'jabon liquido', 'jabon barra', 'jabon de tocador', 'jabon corporal'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Champú',
      department: 'Salud y Cuidado Personal',
      keywords: ['shampoo', 'champu', 'champú', 'acondicionador', 'tratamiento capilar'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cuidado Oral',
      department: 'Salud y Cuidado Personal',
      keywords: ['pasta dental', 'crema dental', 'cepillo de dientes', 'cepillo dental', 'hilo dental', 'enjuague bucal'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Crema Corporal y Facial',
      department: 'Salud y Cuidado Personal',
      keywords: ['crema corporal', 'crema facial', 'humectante', 'hidratante', 'bloqueador solar', 'protector solar', 'suero facial'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Desodorante',
      department: 'Salud y Cuidado Personal',
      keywords: ['desodorante', 'antitraspirante', 'antiperspirant', 'roll-on', 'desodorante aerosol'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Afeitado y Depilación',
      department: 'Salud y Cuidado Personal',
      keywords: ['rastrillo', 'rasuradora', 'crema de afeitar', 'espuma de afeitar', 'cera depilatoria', 'aftershave'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Perfume y Fragancia',
      department: 'Salud y Cuidado Personal',
      keywords: ['perfume', 'locion', 'loción', 'fragancia', 'eau de parfum', 'eau de toilette', 'body spray'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Maquillaje',
      department: 'Salud y Cuidado Personal',
      keywords: ['maquillaje', 'labial', 'rimel', 'rímel', 'base de maquillaje', 'corrector', 'sombra de ojos', 'esmalte de uñas'],
    ),

    // -------------------------------------------------------------------------
    // 4. ALIMENTOS Y ABARROTES
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Bebida',
      department: 'Alimentos y Abarrotes',
      keywords: ['coca cola', 'refresco', 'bebida', 'soda', 'agua de sabor', 'juice', 'jugo', 'te helado', 'té helado'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Agua Embotellada',
      department: 'Alimentos y Abarrotes',
      keywords: ['agua purificada', 'agua mineral', 'agua natural', 'garrafon de agua', 'agua embotellada'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Bebida Energética / Deportiva',
      department: 'Alimentos y Abarrotes',
      keywords: ['red bull', 'monster energy', 'gatorade', 'electrolit', 'powerade', 'suero oral'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Bebida Alcohólica',
      department: 'Alimentos y Abarrotes',
      keywords: ['cerveza', 'vino', 'tequila', 'whisky', 'ron', 'vodka', 'ginebra', 'licor', 'mezcal'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Café y Té',
      department: 'Alimentos y Abarrotes',
      keywords: ['nescafe', 'nescafé', 'cafe', 'café', 'cafe molido', 'cafe soluble', 'capsulas de cafe', 'té verde', 'té negro'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Despensa y Granos',
      department: 'Alimentos y Abarrotes',
      keywords: ['aceite comestible', 'aceite vegetal', 'arroz', 'frijol', 'pasta para sopa', 'harina', 'azucar', 'azúcar', 'sal de mesa'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Enlatados y Conservas',
      department: 'Alimentos y Abarrotes',
      keywords: ['atun', 'atún', 'sardinas', 'chiles en lata', 'elote en lata', 'verduras en lata', 'sopa en lata', 'pure de tomate'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Botanas y Galletas',
      department: 'Alimentos y Abarrotes',
      keywords: ['papas fritas', 'botana', 'chips', 'galletas', 'chocolates', 'dulces', 'cacahuates', 'palomitas'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Lácteos y Huevos',
      department: 'Alimentos y Abarrotes',
      keywords: ['leche', 'queso', 'yogurt', 'mantequilla', 'margarina', 'crema de leche', 'huevo', 'huevos'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Panadería y Cereales',
      department: 'Alimentos y Abarrotes',
      keywords: ['pan blanco', 'pan dulce', 'pan de caja', 'cereal', 'hojuelas de maiz', 'avena'],
    ),

    // -------------------------------------------------------------------------
    // 5. HOGAR, LIMPIEZA Y ELECTRODOMÉSTICOS
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Refrigerador',
      department: 'Hogar y Electrodomésticos',
      keywords: ['refrigerador', 'nevera', 'frigorifico', 'congelador', 'minibar'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Lavadora y Secadora',
      department: 'Hogar y Electrodomésticos',
      keywords: ['lavadora', 'secadora', 'centro de lavado', 'lavasecadora'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Estufa y Horno',
      department: 'Hogar y Electrodomésticos',
      keywords: ['estufa', 'horno', 'parrilla de gas', 'parrilla de induccion', 'horno de microondas', 'microondas'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Electrodoméstico de Cocina',
      department: 'Hogar y Electrodomésticos',
      keywords: ['licuadora', 'freidora de aire', 'air fryer', 'cafetera', 'batidora', 'tostadora', 'procesador de alimentos', 'exprimidor'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Aspiradora y Limpieza Eléctrica',
      department: 'Hogar y Electrodomésticos',
      keywords: ['aspiradora', 'aspiradora robot', 'robot vacuum', 'mopa electrica'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Producto de Limpieza Hogar',
      department: 'Hogar y Electrodomésticos',
      keywords: ['detergente', 'suavizante', 'cloro', 'desinfectante', 'limpiador multiusos', 'lavatrastes', 'jabon liquido loza', 'limpiacristales'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Menaje de Cocina',
      department: 'Hogar y Electrodomésticos',
      keywords: ['sarten', 'sartén', 'olla', 'cacerola', 'vajilla', 'cubiertos', 'vasos', 'tazas'],
    ),

    // -------------------------------------------------------------------------
    // 6. FERRETERÍA, HERRAMIENTAS Y AUTOMOTRIZ
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Herramienta Eléctrica',
      department: 'Ferretería y Herramientas',
      keywords: ['taladro', 'rotomartillo', 'esmeriladora', 'sierra circular', 'sierra caladora', 'lijadora', 'atornillador electrico'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Herramienta Manual',
      department: 'Ferretería y Herramientas',
      keywords: ['martillo', 'destornillador', 'desarmador', 'pinzas', 'llave perica', 'llave espanola', 'flexometro', 'cinta metrica', 'juego de llaves'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Aceite y Fluido Automotriz',
      department: 'Automotriz',
      keywords: ['aceite de motor', 'aceite sintético', 'anticongelante', 'liquido de frenos', 'aditivo motor'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Accesorio Automotriz',
      department: 'Automotriz',
      keywords: ['llanta', 'neumatico', 'bateria de auto', 'cargador de bateria auto', 'funda para auto', 'tapetes para auto'],
    ),

    // -------------------------------------------------------------------------
    // 7. ROPA, CALZADO Y ACCESORIOS
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Calzado / Tenis',
      department: 'Ropa y Calzado',
      keywords: ['tenis', 'zapatillas', 'zapatos', 'botas', 'sandalias', 'sneakers'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Ropa',
      department: 'Ropa y Calzado',
      keywords: ['playera', 'camisa', 'pantalon', 'pantalón', 'jeans', 'chamarra', 'sudadera', 'vestido', 'short'],
    ),

    // -------------------------------------------------------------------------
    // 8. JUGUETES, BEBÉS Y MASCOTAS
    // -------------------------------------------------------------------------
    CategoryDefinition(
      generalSpeciesName: 'Alimento para Mascota',
      department: 'Mascotas',
      keywords: ['croquetas', 'alimento para perro', 'alimento para gato', 'comida perro', 'comida gato', 'premios mascota', 'arena para gato'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Cuidado del Bebé',
      department: 'Bebés',
      keywords: ['pañales', 'panales', 'toallitas humedas', 'formula infantil', 'biberon', 'biberón', 'carriola'],
    ),
    CategoryDefinition(
      generalSpeciesName: 'Juguete',
      department: 'Juguetes',
      keywords: ['juguete', 'lego', 'figura de accion', 'muñeca', 'juego de mesa', 'pista de carreras', 'peluche'],
    ),
  ];
}
