import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/brand_dictionary.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/product_taxonomy_service.dart';

void main() {
  group('Walmart-Level Decoupled Product Taxonomy Tests', () {
    const service = ProductTaxonomyService();

    test('1. Electrónica y Cómputo Categorization', () {
      final resGpu = service.resolve(title: 'GIGABYTE NVIDIA RTX 4060 GAMING OC 8GB GDDR6');
      expect(resGpu.generalSpeciesName, 'Tarjeta de Video');
      expect(resGpu.inferredBrand, 'Gigabyte');

      final resCpu = service.resolve(title: 'Procesador AMD Ryzen 7 7800X3D');
      expect(resCpu.generalSpeciesName, 'Procesador');
      expect(resCpu.inferredBrand, 'AMD');

      final resRam = service.resolve(title: 'Corsair Vengeance 32GB DDR5 RAM Kit');
      expect(resRam.generalSpeciesName, 'Memoria RAM');
      expect(resRam.inferredBrand, 'Corsair');

      final resMonitor = service.resolve(title: 'Dell Pro Plus P2425DE 24" USB-C Hub Monitor');
      expect(resMonitor.generalSpeciesName, 'Monitor');
      expect(resMonitor.inferredBrand, 'Dell');
    });

    test('2. Videojuegos y Consolas Categorization', () {
      final resControl = service.resolve(title: 'DualSense Midnight Black Wireless Controller');
      expect(resControl.generalSpeciesName, 'Control de Videojuegos');
      expect(resControl.inferredBrand, 'PlayStation');

      final resConsola = service.resolve(title: 'Nintendo Switch OLED Model Mario Edition');
      expect(resConsola.generalSpeciesName, 'Consola de Videojuegos');
      expect(resConsola.inferredBrand, 'Nintendo');
    });

    test('3. Cuidado Personal, Salud y Belleza Categorization (Jabones, Salud, Pastas)', () {
      final resJabon = service.resolve(title: 'Dove Jabón de Tocador Barra Humectante 135g');
      expect(resJabon.generalSpeciesName, 'Jabón');
      expect(resJabon.inferredBrand, 'Dove');

      final resChampu = service.resolve(title: 'Pantene Champú Restauración 700ml');
      expect(resChampu.generalSpeciesName, 'Champú');
      expect(resChampu.inferredBrand, 'Pantene');

      final resSalud = service.resolve(title: 'NeilMed SinusRinse Kit de Lavado Nasal Salino');
      expect(resSalud.generalSpeciesName, 'Cuidado Personal / Salud');
      expect(resSalud.inferredBrand, 'NeilMed');

      final resPasta = service.resolve(title: 'Colgate Total 12 Crema Dental 150ml');
      expect(resPasta.generalSpeciesName, 'Cuidado Oral');
      expect(resPasta.inferredBrand, 'Colgate');
    });

    test('4. Alimentos y Abarrotes Categorization', () {
      final resBebida = service.resolve(title: 'Coca-Cola Original Refresco 600ml');
      expect(resBebida.generalSpeciesName, 'Bebida');
      expect(resBebida.inferredBrand, 'Coca-Cola');

      final resCafe = service.resolve(title: 'Nescafé Clásico Café Soluble 200g');
      expect(resCafe.generalSpeciesName, 'Café y Té');
      expect(resCafe.inferredBrand, 'Nescafé');
    });

    test('5. Hogar, Electrodomésticos y Herramientas Categorization', () {
      final resFreidora = service.resolve(title: 'Ninja Air Fryer Freidora de Aire XL');
      expect(resFreidora.generalSpeciesName, 'Electrodoméstico de Cocina');
      expect(resFreidora.inferredBrand, 'Ninja');

      final resTaladro = service.resolve(title: 'DeWalt Taladro Inalámbrico 20V Max');
      expect(resTaladro.generalSpeciesName, 'Herramienta Eléctrica');
      expect(resTaladro.inferredBrand, 'DeWalt');

      final resAceite = service.resolve(title: 'Castrol GTX Aceite de Motor Sintético 5W-30');
      expect(resAceite.generalSpeciesName, 'Aceite y Fluido Automotriz');
      expect(resAceite.inferredBrand, 'Castrol');
    });

    test('6. BrandDictionary Direct Inferences', () {
      expect(BrandDictionary.inferBrand('Mousse Corporal Nivea 200ml'), 'Nivea');
      expect(BrandDictionary.inferBrand('Galletas Marias Gamesa 170g'), 'Gamesa');
      expect(BrandDictionary.inferBrand('Detergente Ariel Doble Poder 4kg'), 'Ariel');
      expect(BrandDictionary.inferBrand('Tenis Nike Air Force 1 Blancos'), 'Nike');
    });
  });
}
