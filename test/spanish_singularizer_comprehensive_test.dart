import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/taxonomy/spanish_singularizer.dart';

void main() {
  group('SpanishSingularizer Comprehensive Linguistic Tests', () {
    test('Regular plural nouns ending in -os are singularized to -o', () {
      expect(SpanishSingularizer.toSingular('Carros'), 'Carro');
      expect(SpanishSingularizer.toSingular('perros'), 'Perro');
      expect(SpanishSingularizer.toSingular('Platos'), 'Plato');
      expect(SpanishSingularizer.toSingular('zapatos'), 'Zapato');
      expect(SpanishSingularizer.toSingular('Libros'), 'Libro');
      expect(SpanishSingularizer.toSingular('vasos'), 'Vaso');
      expect(SpanishSingularizer.toSingular('Teclados'), 'Teclado');
    });

    test('Regular plural nouns ending in -as are singularized to -a', () {
      expect(SpanishSingularizer.toSingular('Mesas'), 'Mesa');
      expect(SpanishSingularizer.toSingular('sillas'), 'Silla');
      expect(SpanishSingularizer.toSingular('Botanas'), 'Botana');
      expect(SpanishSingularizer.toSingular('camisas'), 'Camisa');
      expect(SpanishSingularizer.toSingular('manzanas'), 'Manzana');
    });

    test('Plural nouns ending in -es preceded by vowel or consonant', () {
      expect(SpanishSingularizer.toSingular('Tomates'), 'Tomate');
      expect(SpanishSingularizer.toSingular('Billetes'), 'Billete');
      expect(SpanishSingularizer.toSingular('Dientes'), 'Diente');
      expect(SpanishSingularizer.toSingular('Puentes'), 'Puente');
      expect(SpanishSingularizer.toSingular('Paredes'), 'Pared');
      expect(SpanishSingularizer.toSingular('Motores'), 'Motor');
      expect(SpanishSingularizer.toSingular('Flores'), 'Flor');
    });

    test('Plural nouns ending in -iones and -ces', () {
      expect(SpanishSingularizer.toSingular('Camiones'), 'Camión');
      expect(SpanishSingularizer.toSingular('estaciones'), 'Estación');
      expect(SpanishSingularizer.toSingular('canciones'), 'Canción');
      expect(SpanishSingularizer.toSingular('Luces'), 'Luz');
      expect(SpanishSingularizer.toSingular('lapices'), 'Lápiz');
      expect(SpanishSingularizer.toSingular('Peces'), 'Pez');
      expect(SpanishSingularizer.toSingular('Nueces'), 'Nuez');
    });

    test('Invariable nouns ending in -s remain unchanged', () {
      expect(SpanishSingularizer.toSingular('Tenis'), 'Tenis');
      expect(SpanishSingularizer.toSingular('paraguas'), 'Paraguas');
      expect(SpanishSingularizer.toSingular('abrelatas'), 'Abrelatas');
      expect(SpanishSingularizer.toSingular('crisis'), 'Crisis');
      expect(SpanishSingularizer.toSingular('virus'), 'Virus');
      expect(SpanishSingularizer.toSingular('análisis'), 'Análisis');
    });

    test('Explicit dictionary mappings take precedence', () {
      expect(SpanishSingularizer.toSingular('audífonos'), 'Audífono');
      expect(SpanishSingularizer.toSingular('pantalones'), 'Pantalón');
      expect(SpanishSingularizer.toSingular('jabones'), 'Jabón');
    });
  });
}
