class BrandDictionary {
  BrandDictionary._();

  static const List<String> allBrands = [
    // Electrónica, Cómputo y Fotografía
    'Samsung', 'Dell', 'Gigabyte', 'Logitech', 'Sony', 'Apple', 'Asus', 'HP', 'Lenovo',
    'LG', 'Nvidia', 'AMD', 'Microsoft', 'Intel', 'Acer', 'MSI', 'Corsair', 'Razer',
    'HyperX', 'Kingston', 'Western Digital', 'Seagate', 'SanDisk', 'Crucial', 'EVGA',
    'Zotac', 'ASRock', 'TP-Link', 'Netgear', 'Linksys', 'Canon', 'Nikon', 'Fujifilm',
    'GoPro', 'DJI', 'Bose', 'Sennheiser', 'Audio-Technica', 'JBL', 'Sonos', 'Anker',
    'Belkin', 'Baseus', 'UGreen', 'Xiaomi', 'Motorola', 'Huawei', 'OnePlus', 'Google',
    'Realme', 'Oppo', 'Vivo', 'TCL', 'Hisense', 'Vizio', 'BenQ', 'ViewSonic', 'AOC',

    // Gaming y Consolas
    'PlayStation', 'Xbox', 'Nintendo', 'Steam Deck', 'SteelSeries', 'Turtle Beach',
    'Astro', 'Scuf', '8BitDo', 'HORI', 'Redragon', 'Cougar', 'Thermaltake',

    // Cuidado Personal, Salud, Belleza y Farmacia
    'NeilMed', 'Dove', 'Colgate', 'Nivea', 'Palmolive', 'Pantene', 'Head & Shoulders',
    'L\'Oréal', 'Garnier', 'Neutrogena', 'Cetaphil', 'CeraVe', 'Rexona', 'Axe',
    'Old Spice', 'Gillette', 'Oral-B', 'Sensodyne', 'Listerine', 'Vicks', 'Bayer',
    'Tylenol', 'Advil', 'Genomma Lab', 'Caprice', 'Savilé', 'Sedal', 'Eucerin',
    'Avène', 'La Roche-Posay', 'Maybelline', 'MAC', 'Revlon', 'Natura', 'Avon',

    // Alimentos, Bebidas y Abarrotes
    'Coca-Cola', 'Pepsi', 'Nestlé', 'Nescafé', 'Bimbo', 'Sabritas', 'Barcel', 'Gamesa',
    'Marinela', 'Knorr', 'Herdez', 'La Costeña', 'Del Monte', 'McCormick', 'Alpura',
    'Lala', 'Nutri', 'Danone', 'Activia', 'Yakult', 'Sigma', 'Fud', 'Sabori', 'San Rafael',
    'Zwan', 'Bafar', 'Great Value', 'Member\'s Mark', 'Kirkland', 'Kellogg\'s', 'Quaker',
    'M&M\'s', 'Snickers', 'Milky Way', 'Hershey\'s', 'Ferrero', 'Kinder', 'Corona',
    'Victoria', 'Modelo', 'Heineken', 'Tecate', 'Dos Equis', 'Jack Daniel\'s', 'Red Bull',
    'Monster', 'Electrolit', 'Gatorade', 'Bonafont', 'Epura', 'Ciel',

    // Hogar, Limpieza y Electrodomésticos
    'Ninja', 'Oster', 'Black+Decker', 'Hamilton Beach', 'T-fal', 'Cuisinart', 'KitchenAid',
    'NutriBullet', 'Mabe', 'Whirlpool', 'Maytag', 'Frigidaire', 'Electrolux', 'Dyson',
    'iRobot', 'Clorox', 'Fabuloso', 'Pinol', 'Ariel', 'Ace', 'Downy', 'Suavitel', 'Salvo',
    'Dawn', 'Lysol', 'Scotch-Brite', 'Sani-Stik', 'Regio', 'Pétalo', 'Kleenex', 'Charmin',

    // Herramientas, Ferretería y Automotriz
    'DeWalt', 'Milwaukee', 'Makita', 'Bosch', 'Craftsman', 'Stanley', 'Truper', 'Pretul',
    'Ryobi', 'Black & Decker', 'Dremel', 'Stihl', 'Husqvarna', 'Castrol', 'Mobil',
    'Pennzoil', 'Valvoline', 'Motul', 'Bardahl', 'Prestone', 'STP', 'Turtle Wax',
    'Meguiar\'s', 'Michelin', 'Bridgestone', 'Goodyear', 'Continental', 'Pirelli',

    // Ropa, Calzado y Deportes
    'Nike', 'Adidas', 'Puma', 'Under Armour', 'Reebok', 'Asics', 'New Balance', 'Skechers',
    'Vans', 'Converse', 'Levi\'s', 'Tommy Hilfiger', 'Calvin Klein', 'Zara', 'H&M',
    'Gap', 'Columbia', 'The North Face', 'Patagonia', 'Oakley', 'Ray-Ban',

    // Bebés, Juguetes y Mascotas
    'Pampers', 'Huggies', 'Fisher-Price', 'Lego', 'Hasbro', 'Mattel', 'Nerf', 'Barbie',
    'Hot Wheels', 'Pedigree', 'Whiskas', 'Purina', 'Royal Canin', 'Pro Plan', 'Cat Chow',
  ];

  /// Mapeo secundario de familias de productos icónicas (usado SOLO si no hay marca explícita en allBrands)
  static const Map<String, String> productFamilyToBrand = {
    'dualsense': 'PlayStation',
    'dualshock': 'PlayStation',
    'airpods': 'Apple',
    'macbook': 'Apple',
    'ipad': 'Apple',
    'iphone': 'Apple',
    'galaxy': 'Samsung',
    'thinkpad': 'Lenovo',
    'ideapad': 'Lenovo',
    'alienware': 'Dell',
  };

  /// Normalizar texto eliminando acentos
  static String _normalize(String s) {
    return s
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U');
  }

  /// Inferir marca: Prioriza marcas explícitas en allBrands; si no encuentra, busca familias icónicas secundarias
  static String? inferBrand(String text) {
    if (text.trim().isEmpty) return null;
    final normalizedText = _normalize(text);

    // 1. Buscar primero marcas explícitas ordenadas por longitud descendente
    final sortedBrands = List<String>.from(allBrands)..sort((a, b) => b.length.compareTo(a.length));

    for (final brand in sortedBrands) {
      final normBrand = _normalize(brand);
      final pattern = RegExp(r'\b' + RegExp.escape(normBrand) + r'\b', caseSensitive: false);
      if (pattern.hasMatch(normalizedText)) {
        return brand;
      }
    }

    // 2. Si no hay marca explícita, buscar familias icónicas secundarias
    for (final entry in productFamilyToBrand.entries) {
      final pattern = RegExp(r'\b' + entry.key + r'\b', caseSensitive: false);
      if (pattern.hasMatch(normalizedText)) {
        return entry.value;
      }
    }

    return null;
  }
}
