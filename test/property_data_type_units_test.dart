import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/units_registry.dart';
import 'package:platinum_world_management_system/src/core/domain/property_data_type.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';

void main() {
  group('UnitsRegistry and PropertyDataType Tests', () {
    test('UnitsRegistry only contains valid SI and currency units', () {
      expect(UnitsRegistry.isKnownUnit('kg'), isTrue);
      expect(UnitsRegistry.isKnownUnit('MXN'), isTrue);
      expect(UnitsRegistry.isKnownUnit('EUR'), isTrue);

      // Verify string types / property values are NOT registered as units
      expect(UnitsRegistry.isKnownUnit('string'), isFalse);
      expect(UnitsRegistry.isKnownUnit('número real'), isFalse);
      expect(UnitsRegistry.isKnownUnit('Plata .925'), isFalse);
      expect(UnitsRegistry.isKnownUnit('MS-65'), isFalse);
    });

    test('PropertyDataType resolves correct enum from code', () {
      expect(PropertyDataType.fromCode('real'), PropertyDataType.real);
      expect(PropertyDataType.fromCode('double'), PropertyDataType.real);
      expect(PropertyDataType.fromCode('integer'), PropertyDataType.integer);
      expect(PropertyDataType.fromCode('entero'), PropertyDataType.integer);
      expect(PropertyDataType.fromCode('string'), PropertyDataType.string);
      expect(PropertyDataType.fromCode('texto'), PropertyDataType.string);
      expect(PropertyDataType.fromCode('boolean'), PropertyDataType.boolean);
      expect(PropertyDataType.fromCode('booleano'), PropertyDataType.boolean);
    });

    test('InstanceMagnitude formats string, boolean, integer, and real properties correctly', () {
      final realMag = InstanceMagnitude(
        id: '1',
        instanceId: 'inst1',
        propertyName: 'Valor nominal',
        dataType: 'real',
        magnitudeValue: 5.0,
        unitSymbol: null,
      );
      expect(realMag.displayValue, equals('5'));

      final currencyMag = InstanceMagnitude(
        id: '1b',
        instanceId: 'inst1',
        propertyName: 'Divisa',
        dataType: 'string',
        magnitudeValue: 0.0,
        stringValue: 'MXN',
        unitSymbol: null,
      );
      expect(currencyMag.displayValue, equals('MXN'));

      final intMag = InstanceMagnitude(
        id: '2',
        instanceId: 'inst1',
        propertyName: 'Acuñación',
        dataType: 'integer',
        magnitudeValue: 2022.0,
        unitSymbol: 'año',
      );
      expect(intMag.displayValue, equals('2022 año'));

      final strMaterialMag = InstanceMagnitude(
        id: '3',
        instanceId: 'inst1',
        propertyName: 'Material',
        dataType: 'string',
        magnitudeValue: 0.0,
        stringValue: 'Plata .925',
        unitSymbol: null,
      );
      expect(strMaterialMag.displayValue, equals('Plata .925'));

      final strGradeMag = InstanceMagnitude(
        id: '4',
        instanceId: 'inst1',
        propertyName: 'Grado',
        dataType: 'string',
        magnitudeValue: 0.0,
        stringValue: 'MS-65',
        unitSymbol: null,
      );
      expect(strGradeMag.displayValue, equals('MS-65'));

      final boolMag = InstanceMagnitude(
        id: '5',
        instanceId: 'inst1',
        propertyName: 'Edición Especial',
        dataType: 'boolean',
        magnitudeValue: 0.0,
        stringValue: 'true',
        unitSymbol: null,
      );
      expect(boolMag.displayValue, equals('Sí'));
    });
  });
}
