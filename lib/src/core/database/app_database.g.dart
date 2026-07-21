// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocationsTableTable extends LocationsTable
    with TableInfo<$LocationsTableTable, LocationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentLocationIdMeta =
      const VerificationMeta('parentLocationId');
  @override
  late final GeneratedColumn<String> parentLocationId = GeneratedColumn<String>(
      'parent_location_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES locations_table (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, parentLocationId, description, icon, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations_table';
  @override
  VerificationContext validateIntegrity(Insertable<LocationsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_location_id')) {
      context.handle(
          _parentLocationIdMeta,
          parentLocationId.isAcceptableOrUnknown(
              data['parent_location_id']!, _parentLocationIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentLocationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}parent_location_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LocationsTableTable createAlias(String alias) {
    return $LocationsTableTable(attachedDatabase, alias);
  }
}

class LocationsTableData extends DataClass
    implements Insertable<LocationsTableData> {
  final String id;
  final String name;
  final String? parentLocationId;
  final String? description;
  final String? icon;
  final DateTime createdAt;
  const LocationsTableData(
      {required this.id,
      required this.name,
      this.parentLocationId,
      this.description,
      this.icon,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentLocationId != null) {
      map['parent_location_id'] = Variable<String>(parentLocationId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocationsTableCompanion toCompanion(bool nullToAbsent) {
    return LocationsTableCompanion(
      id: Value(id),
      name: Value(name),
      parentLocationId: parentLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentLocationId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      createdAt: Value(createdAt),
    );
  }

  factory LocationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentLocationId: serializer.fromJson<String?>(json['parentLocationId']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentLocationId': serializer.toJson<String?>(parentLocationId),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocationsTableData copyWith(
          {String? id,
          String? name,
          Value<String?> parentLocationId = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          DateTime? createdAt}) =>
      LocationsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        parentLocationId: parentLocationId.present
            ? parentLocationId.value
            : this.parentLocationId,
        description: description.present ? description.value : this.description,
        icon: icon.present ? icon.value : this.icon,
        createdAt: createdAt ?? this.createdAt,
      );
  LocationsTableData copyWithCompanion(LocationsTableCompanion data) {
    return LocationsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentLocationId: data.parentLocationId.present
          ? data.parentLocationId.value
          : this.parentLocationId,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentLocationId: $parentLocationId, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, parentLocationId, description, icon, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentLocationId == this.parentLocationId &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.createdAt == this.createdAt);
}

class LocationsTableCompanion extends UpdateCompanion<LocationsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentLocationId;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocationsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentLocationId = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsTableCompanion.insert({
    required String id,
    required String name,
    this.parentLocationId = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<LocationsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentLocationId,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentLocationId != null) 'parent_location_id': parentLocationId,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? parentLocationId,
      Value<String?>? description,
      Value<String?>? icon,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return LocationsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentLocationId: parentLocationId ?? this.parentLocationId,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentLocationId.present) {
      map['parent_location_id'] = Variable<String>(parentLocationId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentLocationId: $parentLocationId, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogTableTable extends CatalogTable
    with TableInfo<$CatalogTableTable, CatalogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Objeto'));
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mainPhotoPathMeta =
      const VerificationMeta('mainPhotoPath');
  @override
  late final GeneratedColumn<String> mainPhotoPath = GeneratedColumn<String>(
      'main_photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customAttributesMeta =
      const VerificationMeta('customAttributes');
  @override
  late final GeneratedColumn<String> customAttributes = GeneratedColumn<String>(
      'custom_attributes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _defaultUnitMeta =
      const VerificationMeta('defaultUnit');
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
      'default_unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        brand,
        description,
        mainPhotoPath,
        barcode,
        customAttributes,
        defaultUnit,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_table';
  @override
  VerificationContext validateIntegrity(Insertable<CatalogTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('main_photo_path')) {
      context.handle(
          _mainPhotoPathMeta,
          mainPhotoPath.isAcceptableOrUnknown(
              data['main_photo_path']!, _mainPhotoPathMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('custom_attributes')) {
      context.handle(
          _customAttributesMeta,
          customAttributes.isAcceptableOrUnknown(
              data['custom_attributes']!, _customAttributesMeta));
    }
    if (data.containsKey('default_unit')) {
      context.handle(
          _defaultUnitMeta,
          defaultUnit.isAcceptableOrUnknown(
              data['default_unit']!, _defaultUnitMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      mainPhotoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}main_photo_path']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      customAttributes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_attributes'])!,
      defaultUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_unit']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CatalogTableTable createAlias(String alias) {
    return $CatalogTableTable(attachedDatabase, alias);
  }
}

class CatalogTableData extends DataClass
    implements Insertable<CatalogTableData> {
  final String id;
  final String name;
  final String type;
  final String? brand;
  final String? description;
  final String? mainPhotoPath;
  final String? barcode;
  final String customAttributes;
  final String? defaultUnit;
  final DateTime createdAt;
  const CatalogTableData(
      {required this.id,
      required this.name,
      required this.type,
      this.brand,
      this.description,
      this.mainPhotoPath,
      this.barcode,
      required this.customAttributes,
      this.defaultUnit,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || mainPhotoPath != null) {
      map['main_photo_path'] = Variable<String>(mainPhotoPath);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['custom_attributes'] = Variable<String>(customAttributes);
    if (!nullToAbsent || defaultUnit != null) {
      map['default_unit'] = Variable<String>(defaultUnit);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CatalogTableCompanion toCompanion(bool nullToAbsent) {
    return CatalogTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      mainPhotoPath: mainPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(mainPhotoPath),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      customAttributes: Value(customAttributes),
      defaultUnit: defaultUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultUnit),
      createdAt: Value(createdAt),
    );
  }

  factory CatalogTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      brand: serializer.fromJson<String?>(json['brand']),
      description: serializer.fromJson<String?>(json['description']),
      mainPhotoPath: serializer.fromJson<String?>(json['mainPhotoPath']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      customAttributes: serializer.fromJson<String>(json['customAttributes']),
      defaultUnit: serializer.fromJson<String?>(json['defaultUnit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'brand': serializer.toJson<String?>(brand),
      'description': serializer.toJson<String?>(description),
      'mainPhotoPath': serializer.toJson<String?>(mainPhotoPath),
      'barcode': serializer.toJson<String?>(barcode),
      'customAttributes': serializer.toJson<String>(customAttributes),
      'defaultUnit': serializer.toJson<String?>(defaultUnit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CatalogTableData copyWith(
          {String? id,
          String? name,
          String? type,
          Value<String?> brand = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> mainPhotoPath = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          String? customAttributes,
          Value<String?> defaultUnit = const Value.absent(),
          DateTime? createdAt}) =>
      CatalogTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        brand: brand.present ? brand.value : this.brand,
        description: description.present ? description.value : this.description,
        mainPhotoPath:
            mainPhotoPath.present ? mainPhotoPath.value : this.mainPhotoPath,
        barcode: barcode.present ? barcode.value : this.barcode,
        customAttributes: customAttributes ?? this.customAttributes,
        defaultUnit: defaultUnit.present ? defaultUnit.value : this.defaultUnit,
        createdAt: createdAt ?? this.createdAt,
      );
  CatalogTableData copyWithCompanion(CatalogTableCompanion data) {
    return CatalogTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      brand: data.brand.present ? data.brand.value : this.brand,
      description:
          data.description.present ? data.description.value : this.description,
      mainPhotoPath: data.mainPhotoPath.present
          ? data.mainPhotoPath.value
          : this.mainPhotoPath,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      customAttributes: data.customAttributes.present
          ? data.customAttributes.value
          : this.customAttributes,
      defaultUnit:
          data.defaultUnit.present ? data.defaultUnit.value : this.defaultUnit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('brand: $brand, ')
          ..write('description: $description, ')
          ..write('mainPhotoPath: $mainPhotoPath, ')
          ..write('barcode: $barcode, ')
          ..write('customAttributes: $customAttributes, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, brand, description,
      mainPhotoPath, barcode, customAttributes, defaultUnit, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.brand == this.brand &&
          other.description == this.description &&
          other.mainPhotoPath == this.mainPhotoPath &&
          other.barcode == this.barcode &&
          other.customAttributes == this.customAttributes &&
          other.defaultUnit == this.defaultUnit &&
          other.createdAt == this.createdAt);
}

class CatalogTableCompanion extends UpdateCompanion<CatalogTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> brand;
  final Value<String?> description;
  final Value<String?> mainPhotoPath;
  final Value<String?> barcode;
  final Value<String> customAttributes;
  final Value<String?> defaultUnit;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CatalogTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.brand = const Value.absent(),
    this.description = const Value.absent(),
    this.mainPhotoPath = const Value.absent(),
    this.barcode = const Value.absent(),
    this.customAttributes = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogTableCompanion.insert({
    required String id,
    required String name,
    this.type = const Value.absent(),
    this.brand = const Value.absent(),
    this.description = const Value.absent(),
    this.mainPhotoPath = const Value.absent(),
    this.barcode = const Value.absent(),
    this.customAttributes = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<CatalogTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? brand,
    Expression<String>? description,
    Expression<String>? mainPhotoPath,
    Expression<String>? barcode,
    Expression<String>? customAttributes,
    Expression<String>? defaultUnit,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (brand != null) 'brand': brand,
      if (description != null) 'description': description,
      if (mainPhotoPath != null) 'main_photo_path': mainPhotoPath,
      if (barcode != null) 'barcode': barcode,
      if (customAttributes != null) 'custom_attributes': customAttributes,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String?>? brand,
      Value<String?>? description,
      Value<String?>? mainPhotoPath,
      Value<String?>? barcode,
      Value<String>? customAttributes,
      Value<String?>? defaultUnit,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CatalogTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      mainPhotoPath: mainPhotoPath ?? this.mainPhotoPath,
      barcode: barcode ?? this.barcode,
      customAttributes: customAttributes ?? this.customAttributes,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (mainPhotoPath.present) {
      map['main_photo_path'] = Variable<String>(mainPhotoPath.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (customAttributes.present) {
      map['custom_attributes'] = Variable<String>(customAttributes.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('brand: $brand, ')
          ..write('description: $description, ')
          ..write('mainPhotoPath: $mainPhotoPath, ')
          ..write('barcode: $barcode, ')
          ..write('customAttributes: $customAttributes, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntitiesTableTable extends EntitiesTable
    with TableInfo<$EntitiesTableTable, EntitiesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitiesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speciesIdMeta =
      const VerificationMeta('speciesId');
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
      'species_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES catalog_table (id)'));
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES locations_table (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        speciesId,
        locationId,
        quantity,
        unit,
        notes,
        isArchived,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entities_table';
  @override
  VerificationContext validateIntegrity(Insertable<EntitiesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(_speciesIdMeta,
          speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta));
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntitiesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntitiesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      speciesId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}species_id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EntitiesTableTable createAlias(String alias) {
    return $EntitiesTableTable(attachedDatabase, alias);
  }
}

class EntitiesTableData extends DataClass
    implements Insertable<EntitiesTableData> {
  final String id;
  final String speciesId;
  final String? locationId;
  final double? quantity;
  final String? unit;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EntitiesTableData(
      {required this.id,
      required this.speciesId,
      this.locationId,
      this.quantity,
      this.unit,
      this.notes,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['species_id'] = Variable<String>(speciesId);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EntitiesTableCompanion toCompanion(bool nullToAbsent) {
    return EntitiesTableCompanion(
      id: Value(id),
      speciesId: Value(speciesId),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EntitiesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntitiesTableData(
      id: serializer.fromJson<String>(json['id']),
      speciesId: serializer.fromJson<String>(json['speciesId']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      notes: serializer.fromJson<String?>(json['notes']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'speciesId': serializer.toJson<String>(speciesId),
      'locationId': serializer.toJson<String?>(locationId),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'notes': serializer.toJson<String?>(notes),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EntitiesTableData copyWith(
          {String? id,
          String? speciesId,
          Value<String?> locationId = const Value.absent(),
          Value<double?> quantity = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      EntitiesTableData(
        id: id ?? this.id,
        speciesId: speciesId ?? this.speciesId,
        locationId: locationId.present ? locationId.value : this.locationId,
        quantity: quantity.present ? quantity.value : this.quantity,
        unit: unit.present ? unit.value : this.unit,
        notes: notes.present ? notes.value : this.notes,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  EntitiesTableData copyWithCompanion(EntitiesTableCompanion data) {
    return EntitiesTableData(
      id: data.id.present ? data.id.value : this.id,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      notes: data.notes.present ? data.notes.value : this.notes,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesTableData(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('locationId: $locationId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, speciesId, locationId, quantity, unit,
      notes, isArchived, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntitiesTableData &&
          other.id == this.id &&
          other.speciesId == this.speciesId &&
          other.locationId == this.locationId &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.notes == this.notes &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EntitiesTableCompanion extends UpdateCompanion<EntitiesTableData> {
  final Value<String> id;
  final Value<String> speciesId;
  final Value<String?> locationId;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<String?> notes;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EntitiesTableCompanion({
    this.id = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitiesTableCompanion.insert({
    required String id,
    required String speciesId,
    this.locationId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        speciesId = Value(speciesId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<EntitiesTableData> custom({
    Expression<String>? id,
    Expression<String>? speciesId,
    Expression<String>? locationId,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? notes,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (speciesId != null) 'species_id': speciesId,
      if (locationId != null) 'location_id': locationId,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (notes != null) 'notes': notes,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitiesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? speciesId,
      Value<String?>? locationId,
      Value<double?>? quantity,
      Value<String?>? unit,
      Value<String?>? notes,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return EntitiesTableCompanion(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      locationId: locationId ?? this.locationId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesTableCompanion(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('locationId: $locationId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelationsTableTable extends RelationsTable
    with TableInfo<$RelationsTableTable, RelationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceEntityIdMeta =
      const VerificationMeta('sourceEntityId');
  @override
  late final GeneratedColumn<String> sourceEntityId = GeneratedColumn<String>(
      'source_entity_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES entities_table (id)'));
  static const VerificationMeta _targetEntityIdMeta =
      const VerificationMeta('targetEntityId');
  @override
  late final GeneratedColumn<String> targetEntityId = GeneratedColumn<String>(
      'target_entity_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES entities_table (id)'));
  static const VerificationMeta _relationTypeMeta =
      const VerificationMeta('relationType');
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
      'relation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sourceEntityId, targetEntityId, relationType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relations_table';
  @override
  VerificationContext validateIntegrity(Insertable<RelationsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_entity_id')) {
      context.handle(
          _sourceEntityIdMeta,
          sourceEntityId.isAcceptableOrUnknown(
              data['source_entity_id']!, _sourceEntityIdMeta));
    } else if (isInserting) {
      context.missing(_sourceEntityIdMeta);
    }
    if (data.containsKey('target_entity_id')) {
      context.handle(
          _targetEntityIdMeta,
          targetEntityId.isAcceptableOrUnknown(
              data['target_entity_id']!, _targetEntityIdMeta));
    } else if (isInserting) {
      context.missing(_targetEntityIdMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
          _relationTypeMeta,
          relationType.isAcceptableOrUnknown(
              data['relation_type']!, _relationTypeMeta));
    } else if (isInserting) {
      context.missing(_relationTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelationsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_entity_id'])!,
      targetEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_entity_id'])!,
      relationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RelationsTableTable createAlias(String alias) {
    return $RelationsTableTable(attachedDatabase, alias);
  }
}

class RelationsTableData extends DataClass
    implements Insertable<RelationsTableData> {
  final String id;
  final String sourceEntityId;
  final String targetEntityId;
  final String relationType;
  final DateTime createdAt;
  const RelationsTableData(
      {required this.id,
      required this.sourceEntityId,
      required this.targetEntityId,
      required this.relationType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_entity_id'] = Variable<String>(sourceEntityId);
    map['target_entity_id'] = Variable<String>(targetEntityId);
    map['relation_type'] = Variable<String>(relationType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RelationsTableCompanion toCompanion(bool nullToAbsent) {
    return RelationsTableCompanion(
      id: Value(id),
      sourceEntityId: Value(sourceEntityId),
      targetEntityId: Value(targetEntityId),
      relationType: Value(relationType),
      createdAt: Value(createdAt),
    );
  }

  factory RelationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelationsTableData(
      id: serializer.fromJson<String>(json['id']),
      sourceEntityId: serializer.fromJson<String>(json['sourceEntityId']),
      targetEntityId: serializer.fromJson<String>(json['targetEntityId']),
      relationType: serializer.fromJson<String>(json['relationType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceEntityId': serializer.toJson<String>(sourceEntityId),
      'targetEntityId': serializer.toJson<String>(targetEntityId),
      'relationType': serializer.toJson<String>(relationType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RelationsTableData copyWith(
          {String? id,
          String? sourceEntityId,
          String? targetEntityId,
          String? relationType,
          DateTime? createdAt}) =>
      RelationsTableData(
        id: id ?? this.id,
        sourceEntityId: sourceEntityId ?? this.sourceEntityId,
        targetEntityId: targetEntityId ?? this.targetEntityId,
        relationType: relationType ?? this.relationType,
        createdAt: createdAt ?? this.createdAt,
      );
  RelationsTableData copyWithCompanion(RelationsTableCompanion data) {
    return RelationsTableData(
      id: data.id.present ? data.id.value : this.id,
      sourceEntityId: data.sourceEntityId.present
          ? data.sourceEntityId.value
          : this.sourceEntityId,
      targetEntityId: data.targetEntityId.present
          ? data.targetEntityId.value
          : this.targetEntityId,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelationsTableData(')
          ..write('id: $id, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('targetEntityId: $targetEntityId, ')
          ..write('relationType: $relationType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourceEntityId, targetEntityId, relationType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelationsTableData &&
          other.id == this.id &&
          other.sourceEntityId == this.sourceEntityId &&
          other.targetEntityId == this.targetEntityId &&
          other.relationType == this.relationType &&
          other.createdAt == this.createdAt);
}

class RelationsTableCompanion extends UpdateCompanion<RelationsTableData> {
  final Value<String> id;
  final Value<String> sourceEntityId;
  final Value<String> targetEntityId;
  final Value<String> relationType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RelationsTableCompanion({
    this.id = const Value.absent(),
    this.sourceEntityId = const Value.absent(),
    this.targetEntityId = const Value.absent(),
    this.relationType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelationsTableCompanion.insert({
    required String id,
    required String sourceEntityId,
    required String targetEntityId,
    required String relationType,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceEntityId = Value(sourceEntityId),
        targetEntityId = Value(targetEntityId),
        relationType = Value(relationType),
        createdAt = Value(createdAt);
  static Insertable<RelationsTableData> custom({
    Expression<String>? id,
    Expression<String>? sourceEntityId,
    Expression<String>? targetEntityId,
    Expression<String>? relationType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceEntityId != null) 'source_entity_id': sourceEntityId,
      if (targetEntityId != null) 'target_entity_id': targetEntityId,
      if (relationType != null) 'relation_type': relationType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelationsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceEntityId,
      Value<String>? targetEntityId,
      Value<String>? relationType,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RelationsTableCompanion(
      id: id ?? this.id,
      sourceEntityId: sourceEntityId ?? this.sourceEntityId,
      targetEntityId: targetEntityId ?? this.targetEntityId,
      relationType: relationType ?? this.relationType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceEntityId.present) {
      map['source_entity_id'] = Variable<String>(sourceEntityId.value);
    }
    if (targetEntityId.present) {
      map['target_entity_id'] = Variable<String>(targetEntityId.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationsTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('targetEntityId: $targetEntityId, ')
          ..write('relationType: $relationType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTableTable extends AttachmentsTable
    with TableInfo<$AttachmentsTableTable, AttachmentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speciesIdMeta =
      const VerificationMeta('speciesId');
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
      'species_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES catalog_table (id)'));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileTypeMeta =
      const VerificationMeta('fileType');
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
      'file_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, speciesId, filePath, fileName, fileType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AttachmentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(_speciesIdMeta,
          speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta));
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(_fileTypeMeta,
          fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta));
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttachmentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttachmentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      speciesId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}species_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      fileType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AttachmentsTableTable createAlias(String alias) {
    return $AttachmentsTableTable(attachedDatabase, alias);
  }
}

class AttachmentsTableData extends DataClass
    implements Insertable<AttachmentsTableData> {
  final String id;
  final String speciesId;
  final String filePath;
  final String fileName;
  final String fileType;
  final DateTime createdAt;
  const AttachmentsTableData(
      {required this.id,
      required this.speciesId,
      required this.filePath,
      required this.fileName,
      required this.fileType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['species_id'] = Variable<String>(speciesId);
    map['file_path'] = Variable<String>(filePath);
    map['file_name'] = Variable<String>(fileName);
    map['file_type'] = Variable<String>(fileType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttachmentsTableCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsTableCompanion(
      id: Value(id),
      speciesId: Value(speciesId),
      filePath: Value(filePath),
      fileName: Value(fileName),
      fileType: Value(fileType),
      createdAt: Value(createdAt),
    );
  }

  factory AttachmentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttachmentsTableData(
      id: serializer.fromJson<String>(json['id']),
      speciesId: serializer.fromJson<String>(json['speciesId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileType: serializer.fromJson<String>(json['fileType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'speciesId': serializer.toJson<String>(speciesId),
      'filePath': serializer.toJson<String>(filePath),
      'fileName': serializer.toJson<String>(fileName),
      'fileType': serializer.toJson<String>(fileType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AttachmentsTableData copyWith(
          {String? id,
          String? speciesId,
          String? filePath,
          String? fileName,
          String? fileType,
          DateTime? createdAt}) =>
      AttachmentsTableData(
        id: id ?? this.id,
        speciesId: speciesId ?? this.speciesId,
        filePath: filePath ?? this.filePath,
        fileName: fileName ?? this.fileName,
        fileType: fileType ?? this.fileType,
        createdAt: createdAt ?? this.createdAt,
      );
  AttachmentsTableData copyWithCompanion(AttachmentsTableCompanion data) {
    return AttachmentsTableData(
      id: data.id.present ? data.id.value : this.id,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsTableData(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('fileType: $fileType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, speciesId, filePath, fileName, fileType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttachmentsTableData &&
          other.id == this.id &&
          other.speciesId == this.speciesId &&
          other.filePath == this.filePath &&
          other.fileName == this.fileName &&
          other.fileType == this.fileType &&
          other.createdAt == this.createdAt);
}

class AttachmentsTableCompanion extends UpdateCompanion<AttachmentsTableData> {
  final Value<String> id;
  final Value<String> speciesId;
  final Value<String> filePath;
  final Value<String> fileName;
  final Value<String> fileType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AttachmentsTableCompanion({
    this.id = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsTableCompanion.insert({
    required String id,
    required String speciesId,
    required String filePath,
    required String fileName,
    required String fileType,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        speciesId = Value(speciesId),
        filePath = Value(filePath),
        fileName = Value(fileName),
        fileType = Value(fileType),
        createdAt = Value(createdAt);
  static Insertable<AttachmentsTableData> custom({
    Expression<String>? id,
    Expression<String>? speciesId,
    Expression<String>? filePath,
    Expression<String>? fileName,
    Expression<String>? fileType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (speciesId != null) 'species_id': speciesId,
      if (filePath != null) 'file_path': filePath,
      if (fileName != null) 'file_name': fileName,
      if (fileType != null) 'file_type': fileType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? speciesId,
      Value<String>? filePath,
      Value<String>? fileName,
      Value<String>? fileType,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AttachmentsTableCompanion(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('fileType: $fileType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoryEventsTableTable extends HistoryEventsTable
    with TableInfo<$HistoryEventsTableTable, HistoryEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, entityId, eventType, description, metadata, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_events_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<HistoryEventsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryEventsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryEventsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $HistoryEventsTableTable createAlias(String alias) {
    return $HistoryEventsTableTable(attachedDatabase, alias);
  }
}

class HistoryEventsTableData extends DataClass
    implements Insertable<HistoryEventsTableData> {
  final String id;
  final String? entityId;
  final String eventType;
  final String description;
  final String? metadata;
  final DateTime timestamp;
  const HistoryEventsTableData(
      {required this.id,
      this.entityId,
      required this.eventType,
      required this.description,
      this.metadata,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['event_type'] = Variable<String>(eventType);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  HistoryEventsTableCompanion toCompanion(bool nullToAbsent) {
    return HistoryEventsTableCompanion(
      id: Value(id),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      eventType: Value(eventType),
      description: Value(description),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      timestamp: Value(timestamp),
    );
  }

  factory HistoryEventsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryEventsTableData(
      id: serializer.fromJson<String>(json['id']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      description: serializer.fromJson<String>(json['description']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityId': serializer.toJson<String?>(entityId),
      'eventType': serializer.toJson<String>(eventType),
      'description': serializer.toJson<String>(description),
      'metadata': serializer.toJson<String?>(metadata),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  HistoryEventsTableData copyWith(
          {String? id,
          Value<String?> entityId = const Value.absent(),
          String? eventType,
          String? description,
          Value<String?> metadata = const Value.absent(),
          DateTime? timestamp}) =>
      HistoryEventsTableData(
        id: id ?? this.id,
        entityId: entityId.present ? entityId.value : this.entityId,
        eventType: eventType ?? this.eventType,
        description: description ?? this.description,
        metadata: metadata.present ? metadata.value : this.metadata,
        timestamp: timestamp ?? this.timestamp,
      );
  HistoryEventsTableData copyWithCompanion(HistoryEventsTableCompanion data) {
    return HistoryEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      description:
          data.description.present ? data.description.value : this.description,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryEventsTableData(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('eventType: $eventType, ')
          ..write('description: $description, ')
          ..write('metadata: $metadata, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityId, eventType, description, metadata, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryEventsTableData &&
          other.id == this.id &&
          other.entityId == this.entityId &&
          other.eventType == this.eventType &&
          other.description == this.description &&
          other.metadata == this.metadata &&
          other.timestamp == this.timestamp);
}

class HistoryEventsTableCompanion
    extends UpdateCompanion<HistoryEventsTableData> {
  final Value<String> id;
  final Value<String?> entityId;
  final Value<String> eventType;
  final Value<String> description;
  final Value<String?> metadata;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const HistoryEventsTableCompanion({
    this.id = const Value.absent(),
    this.entityId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.description = const Value.absent(),
    this.metadata = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoryEventsTableCompanion.insert({
    required String id,
    this.entityId = const Value.absent(),
    required String eventType,
    required String description,
    this.metadata = const Value.absent(),
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        eventType = Value(eventType),
        description = Value(description),
        timestamp = Value(timestamp);
  static Insertable<HistoryEventsTableData> custom({
    Expression<String>? id,
    Expression<String>? entityId,
    Expression<String>? eventType,
    Expression<String>? description,
    Expression<String>? metadata,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityId != null) 'entity_id': entityId,
      if (eventType != null) 'event_type': eventType,
      if (description != null) 'description': description,
      if (metadata != null) 'metadata': metadata,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryEventsTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? entityId,
      Value<String>? eventType,
      Value<String>? description,
      Value<String?>? metadata,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return HistoryEventsTableCompanion(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      eventType: eventType ?? this.eventType,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('eventType: $eventType, ')
          ..write('description: $description, ')
          ..write('metadata: $metadata, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomTemplatesTableTable extends CustomTemplatesTable
    with TableInfo<$CustomTemplatesTableTable, CustomTemplatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomTemplatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeNameMeta =
      const VerificationMeta('typeName');
  @override
  late final GeneratedColumn<String> typeName = GeneratedColumn<String>(
      'type_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commonUnitsMeta =
      const VerificationMeta('commonUnits');
  @override
  late final GeneratedColumn<String> commonUnits = GeneratedColumn<String>(
      'common_units', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, typeName, iconName, commonUnits, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_templates_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CustomTemplatesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type_name')) {
      context.handle(_typeNameMeta,
          typeName.isAcceptableOrUnknown(data['type_name']!, _typeNameMeta));
    } else if (isInserting) {
      context.missing(_typeNameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('common_units')) {
      context.handle(
          _commonUnitsMeta,
          commonUnits.isAcceptableOrUnknown(
              data['common_units']!, _commonUnitsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomTemplatesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomTemplatesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      typeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      commonUnits: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}common_units'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomTemplatesTableTable createAlias(String alias) {
    return $CustomTemplatesTableTable(attachedDatabase, alias);
  }
}

class CustomTemplatesTableData extends DataClass
    implements Insertable<CustomTemplatesTableData> {
  final String id;
  final String typeName;
  final String iconName;
  final String commonUnits;
  final DateTime createdAt;
  const CustomTemplatesTableData(
      {required this.id,
      required this.typeName,
      required this.iconName,
      required this.commonUnits,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type_name'] = Variable<String>(typeName);
    map['icon_name'] = Variable<String>(iconName);
    map['common_units'] = Variable<String>(commonUnits);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomTemplatesTableCompanion toCompanion(bool nullToAbsent) {
    return CustomTemplatesTableCompanion(
      id: Value(id),
      typeName: Value(typeName),
      iconName: Value(iconName),
      commonUnits: Value(commonUnits),
      createdAt: Value(createdAt),
    );
  }

  factory CustomTemplatesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomTemplatesTableData(
      id: serializer.fromJson<String>(json['id']),
      typeName: serializer.fromJson<String>(json['typeName']),
      iconName: serializer.fromJson<String>(json['iconName']),
      commonUnits: serializer.fromJson<String>(json['commonUnits']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'typeName': serializer.toJson<String>(typeName),
      'iconName': serializer.toJson<String>(iconName),
      'commonUnits': serializer.toJson<String>(commonUnits),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomTemplatesTableData copyWith(
          {String? id,
          String? typeName,
          String? iconName,
          String? commonUnits,
          DateTime? createdAt}) =>
      CustomTemplatesTableData(
        id: id ?? this.id,
        typeName: typeName ?? this.typeName,
        iconName: iconName ?? this.iconName,
        commonUnits: commonUnits ?? this.commonUnits,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomTemplatesTableData copyWithCompanion(
      CustomTemplatesTableCompanion data) {
    return CustomTemplatesTableData(
      id: data.id.present ? data.id.value : this.id,
      typeName: data.typeName.present ? data.typeName.value : this.typeName,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      commonUnits:
          data.commonUnits.present ? data.commonUnits.value : this.commonUnits,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomTemplatesTableData(')
          ..write('id: $id, ')
          ..write('typeName: $typeName, ')
          ..write('iconName: $iconName, ')
          ..write('commonUnits: $commonUnits, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, typeName, iconName, commonUnits, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomTemplatesTableData &&
          other.id == this.id &&
          other.typeName == this.typeName &&
          other.iconName == this.iconName &&
          other.commonUnits == this.commonUnits &&
          other.createdAt == this.createdAt);
}

class CustomTemplatesTableCompanion
    extends UpdateCompanion<CustomTemplatesTableData> {
  final Value<String> id;
  final Value<String> typeName;
  final Value<String> iconName;
  final Value<String> commonUnits;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomTemplatesTableCompanion({
    this.id = const Value.absent(),
    this.typeName = const Value.absent(),
    this.iconName = const Value.absent(),
    this.commonUnits = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomTemplatesTableCompanion.insert({
    required String id,
    required String typeName,
    required String iconName,
    this.commonUnits = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        typeName = Value(typeName),
        iconName = Value(iconName),
        createdAt = Value(createdAt);
  static Insertable<CustomTemplatesTableData> custom({
    Expression<String>? id,
    Expression<String>? typeName,
    Expression<String>? iconName,
    Expression<String>? commonUnits,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (typeName != null) 'type_name': typeName,
      if (iconName != null) 'icon_name': iconName,
      if (commonUnits != null) 'common_units': commonUnits,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomTemplatesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? typeName,
      Value<String>? iconName,
      Value<String>? commonUnits,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CustomTemplatesTableCompanion(
      id: id ?? this.id,
      typeName: typeName ?? this.typeName,
      iconName: iconName ?? this.iconName,
      commonUnits: commonUnits ?? this.commonUnits,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (typeName.present) {
      map['type_name'] = Variable<String>(typeName.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (commonUnits.present) {
      map['common_units'] = Variable<String>(commonUnits.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomTemplatesTableCompanion(')
          ..write('id: $id, ')
          ..write('typeName: $typeName, ')
          ..write('iconName: $iconName, ')
          ..write('commonUnits: $commonUnits, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocationsTableTable locationsTable = $LocationsTableTable(this);
  late final $CatalogTableTable catalogTable = $CatalogTableTable(this);
  late final $EntitiesTableTable entitiesTable = $EntitiesTableTable(this);
  late final $RelationsTableTable relationsTable = $RelationsTableTable(this);
  late final $AttachmentsTableTable attachmentsTable =
      $AttachmentsTableTable(this);
  late final $HistoryEventsTableTable historyEventsTable =
      $HistoryEventsTableTable(this);
  late final $CustomTemplatesTableTable customTemplatesTable =
      $CustomTemplatesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        locationsTable,
        catalogTable,
        entitiesTable,
        relationsTable,
        attachmentsTable,
        historyEventsTable,
        customTemplatesTable
      ];
}

typedef $$LocationsTableTableCreateCompanionBuilder = LocationsTableCompanion
    Function({
  required String id,
  required String name,
  Value<String?> parentLocationId,
  Value<String?> description,
  Value<String?> icon,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$LocationsTableTableUpdateCompanionBuilder = LocationsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parentLocationId,
  Value<String?> description,
  Value<String?> icon,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$LocationsTableTableReferences extends BaseReferences<
    _$AppDatabase, $LocationsTableTable, LocationsTableData> {
  $$LocationsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LocationsTableTable _parentLocationIdTable(_$AppDatabase db) =>
      db.locationsTable.createAlias($_aliasNameGenerator(
          db.locationsTable.parentLocationId, db.locationsTable.id));

  $$LocationsTableTableProcessedTableManager? get parentLocationId {
    final $_column = $_itemColumn<String>('parent_location_id');
    if ($_column == null) return null;
    final manager = $$LocationsTableTableTableManager($_db, $_db.locationsTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentLocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EntitiesTableTable, List<EntitiesTableData>>
      _entitiesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.entitiesTable,
              aliasName: $_aliasNameGenerator(
                  db.locationsTable.id, db.entitiesTable.locationId));

  $$EntitiesTableTableProcessedTableManager get entitiesTableRefs {
    final manager = $$EntitiesTableTableTableManager($_db, $_db.entitiesTable)
        .filter((f) => f.locationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entitiesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LocationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTableTable> {
  $$LocationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$LocationsTableTableFilterComposer get parentLocationId {
    final $$LocationsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentLocationId,
        referencedTable: $db.locationsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocationsTableTableFilterComposer(
              $db: $db,
              $table: $db.locationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> entitiesTableRefs(
      Expression<bool> Function($$EntitiesTableTableFilterComposer f) f) {
    final $$EntitiesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.locationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableFilterComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LocationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTableTable> {
  $$LocationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$LocationsTableTableOrderingComposer get parentLocationId {
    final $$LocationsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentLocationId,
        referencedTable: $db.locationsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocationsTableTableOrderingComposer(
              $db: $db,
              $table: $db.locationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LocationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTableTable> {
  $$LocationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LocationsTableTableAnnotationComposer get parentLocationId {
    final $$LocationsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentLocationId,
        referencedTable: $db.locationsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocationsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.locationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> entitiesTableRefs<T extends Object>(
      Expression<T> Function($$EntitiesTableTableAnnotationComposer a) f) {
    final $$EntitiesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.locationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LocationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocationsTableTable,
    LocationsTableData,
    $$LocationsTableTableFilterComposer,
    $$LocationsTableTableOrderingComposer,
    $$LocationsTableTableAnnotationComposer,
    $$LocationsTableTableCreateCompanionBuilder,
    $$LocationsTableTableUpdateCompanionBuilder,
    (LocationsTableData, $$LocationsTableTableReferences),
    LocationsTableData,
    PrefetchHooks Function({bool parentLocationId, bool entitiesTableRefs})> {
  $$LocationsTableTableTableManager(
      _$AppDatabase db, $LocationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentLocationId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocationsTableCompanion(
            id: id,
            name: name,
            parentLocationId: parentLocationId,
            description: description,
            icon: icon,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> parentLocationId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocationsTableCompanion.insert(
            id: id,
            name: name,
            parentLocationId: parentLocationId,
            description: description,
            icon: icon,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LocationsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {parentLocationId = false, entitiesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (entitiesTableRefs) db.entitiesTable
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentLocationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentLocationId,
                    referencedTable: $$LocationsTableTableReferences
                        ._parentLocationIdTable(db),
                    referencedColumn: $$LocationsTableTableReferences
                        ._parentLocationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entitiesTableRefs)
                    await $_getPrefetchedData<LocationsTableData,
                            $LocationsTableTable, EntitiesTableData>(
                        currentTable: table,
                        referencedTable: $$LocationsTableTableReferences
                            ._entitiesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LocationsTableTableReferences(db, table, p0)
                                .entitiesTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.locationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LocationsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocationsTableTable,
    LocationsTableData,
    $$LocationsTableTableFilterComposer,
    $$LocationsTableTableOrderingComposer,
    $$LocationsTableTableAnnotationComposer,
    $$LocationsTableTableCreateCompanionBuilder,
    $$LocationsTableTableUpdateCompanionBuilder,
    (LocationsTableData, $$LocationsTableTableReferences),
    LocationsTableData,
    PrefetchHooks Function({bool parentLocationId, bool entitiesTableRefs})>;
typedef $$CatalogTableTableCreateCompanionBuilder = CatalogTableCompanion
    Function({
  required String id,
  required String name,
  Value<String> type,
  Value<String?> brand,
  Value<String?> description,
  Value<String?> mainPhotoPath,
  Value<String?> barcode,
  Value<String> customAttributes,
  Value<String?> defaultUnit,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CatalogTableTableUpdateCompanionBuilder = CatalogTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String?> brand,
  Value<String?> description,
  Value<String?> mainPhotoPath,
  Value<String?> barcode,
  Value<String> customAttributes,
  Value<String?> defaultUnit,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CatalogTableTableReferences extends BaseReferences<_$AppDatabase,
    $CatalogTableTable, CatalogTableData> {
  $$CatalogTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntitiesTableTable, List<EntitiesTableData>>
      _entitiesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.entitiesTable,
              aliasName: $_aliasNameGenerator(
                  db.catalogTable.id, db.entitiesTable.speciesId));

  $$EntitiesTableTableProcessedTableManager get entitiesTableRefs {
    final manager = $$EntitiesTableTableTableManager($_db, $_db.entitiesTable)
        .filter((f) => f.speciesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entitiesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttachmentsTableTable, List<AttachmentsTableData>>
      _attachmentsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.attachmentsTable,
              aliasName: $_aliasNameGenerator(
                  db.catalogTable.id, db.attachmentsTable.speciesId));

  $$AttachmentsTableTableProcessedTableManager get attachmentsTableRefs {
    final manager = $$AttachmentsTableTableTableManager(
            $_db, $_db.attachmentsTable)
        .filter((f) => f.speciesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_attachmentsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CatalogTableTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogTableTable> {
  $$CatalogTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mainPhotoPath => $composableBuilder(
      column: $table.mainPhotoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customAttributes => $composableBuilder(
      column: $table.customAttributes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> entitiesTableRefs(
      Expression<bool> Function($$EntitiesTableTableFilterComposer f) f) {
    final $$EntitiesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.speciesId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableFilterComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attachmentsTableRefs(
      Expression<bool> Function($$AttachmentsTableTableFilterComposer f) f) {
    final $$AttachmentsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachmentsTable,
        getReferencedColumn: (t) => t.speciesId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableTableFilterComposer(
              $db: $db,
              $table: $db.attachmentsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CatalogTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogTableTable> {
  $$CatalogTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mainPhotoPath => $composableBuilder(
      column: $table.mainPhotoPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customAttributes => $composableBuilder(
      column: $table.customAttributes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CatalogTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogTableTable> {
  $$CatalogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get mainPhotoPath => $composableBuilder(
      column: $table.mainPhotoPath, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get customAttributes => $composableBuilder(
      column: $table.customAttributes, builder: (column) => column);

  GeneratedColumn<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> entitiesTableRefs<T extends Object>(
      Expression<T> Function($$EntitiesTableTableAnnotationComposer a) f) {
    final $$EntitiesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.speciesId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> attachmentsTableRefs<T extends Object>(
      Expression<T> Function($$AttachmentsTableTableAnnotationComposer a) f) {
    final $$AttachmentsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachmentsTable,
        getReferencedColumn: (t) => t.speciesId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.attachmentsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CatalogTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CatalogTableTable,
    CatalogTableData,
    $$CatalogTableTableFilterComposer,
    $$CatalogTableTableOrderingComposer,
    $$CatalogTableTableAnnotationComposer,
    $$CatalogTableTableCreateCompanionBuilder,
    $$CatalogTableTableUpdateCompanionBuilder,
    (CatalogTableData, $$CatalogTableTableReferences),
    CatalogTableData,
    PrefetchHooks Function(
        {bool entitiesTableRefs, bool attachmentsTableRefs})> {
  $$CatalogTableTableTableManager(_$AppDatabase db, $CatalogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> mainPhotoPath = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String> customAttributes = const Value.absent(),
            Value<String?> defaultUnit = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CatalogTableCompanion(
            id: id,
            name: name,
            type: type,
            brand: brand,
            description: description,
            mainPhotoPath: mainPhotoPath,
            barcode: barcode,
            customAttributes: customAttributes,
            defaultUnit: defaultUnit,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> type = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> mainPhotoPath = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String> customAttributes = const Value.absent(),
            Value<String?> defaultUnit = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CatalogTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            brand: brand,
            description: description,
            mainPhotoPath: mainPhotoPath,
            barcode: barcode,
            customAttributes: customAttributes,
            defaultUnit: defaultUnit,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CatalogTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {entitiesTableRefs = false, attachmentsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (entitiesTableRefs) db.entitiesTable,
                if (attachmentsTableRefs) db.attachmentsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entitiesTableRefs)
                    await $_getPrefetchedData<CatalogTableData,
                            $CatalogTableTable, EntitiesTableData>(
                        currentTable: table,
                        referencedTable: $$CatalogTableTableReferences
                            ._entitiesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CatalogTableTableReferences(db, table, p0)
                                .entitiesTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.speciesId == item.id),
                        typedResults: items),
                  if (attachmentsTableRefs)
                    await $_getPrefetchedData<CatalogTableData,
                            $CatalogTableTable, AttachmentsTableData>(
                        currentTable: table,
                        referencedTable: $$CatalogTableTableReferences
                            ._attachmentsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CatalogTableTableReferences(db, table, p0)
                                .attachmentsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.speciesId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CatalogTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CatalogTableTable,
    CatalogTableData,
    $$CatalogTableTableFilterComposer,
    $$CatalogTableTableOrderingComposer,
    $$CatalogTableTableAnnotationComposer,
    $$CatalogTableTableCreateCompanionBuilder,
    $$CatalogTableTableUpdateCompanionBuilder,
    (CatalogTableData, $$CatalogTableTableReferences),
    CatalogTableData,
    PrefetchHooks Function(
        {bool entitiesTableRefs, bool attachmentsTableRefs})>;
typedef $$EntitiesTableTableCreateCompanionBuilder = EntitiesTableCompanion
    Function({
  required String id,
  required String speciesId,
  Value<String?> locationId,
  Value<double?> quantity,
  Value<String?> unit,
  Value<String?> notes,
  Value<bool> isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$EntitiesTableTableUpdateCompanionBuilder = EntitiesTableCompanion
    Function({
  Value<String> id,
  Value<String> speciesId,
  Value<String?> locationId,
  Value<double?> quantity,
  Value<String?> unit,
  Value<String?> notes,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$EntitiesTableTableReferences extends BaseReferences<_$AppDatabase,
    $EntitiesTableTable, EntitiesTableData> {
  $$EntitiesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CatalogTableTable _speciesIdTable(_$AppDatabase db) =>
      db.catalogTable.createAlias(
          $_aliasNameGenerator(db.entitiesTable.speciesId, db.catalogTable.id));

  $$CatalogTableTableProcessedTableManager get speciesId {
    final $_column = $_itemColumn<String>('species_id')!;

    final manager = $$CatalogTableTableTableManager($_db, $_db.catalogTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_speciesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $LocationsTableTable _locationIdTable(_$AppDatabase db) =>
      db.locationsTable.createAlias($_aliasNameGenerator(
          db.entitiesTable.locationId, db.locationsTable.id));

  $$LocationsTableTableProcessedTableManager? get locationId {
    final $_column = $_itemColumn<String>('location_id');
    if ($_column == null) return null;
    final manager = $$LocationsTableTableTableManager($_db, $_db.locationsTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RelationsTableTable, List<RelationsTableData>>
      _sourceRelationsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.relationsTable,
              aliasName: $_aliasNameGenerator(
                  db.entitiesTable.id, db.relationsTable.sourceEntityId));

  $$RelationsTableTableProcessedTableManager get sourceRelations {
    final manager = $$RelationsTableTableTableManager($_db, $_db.relationsTable)
        .filter(
            (f) => f.sourceEntityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceRelationsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RelationsTableTable, List<RelationsTableData>>
      _targetRelationsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.relationsTable,
              aliasName: $_aliasNameGenerator(
                  db.entitiesTable.id, db.relationsTable.targetEntityId));

  $$RelationsTableTableProcessedTableManager get targetRelations {
    final manager = $$RelationsTableTableTableManager($_db, $_db.relationsTable)
        .filter(
            (f) => f.targetEntityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetRelationsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EntitiesTableTableFilterComposer
    extends Composer<_$AppDatabase, $EntitiesTableTable> {
  $$EntitiesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CatalogTableTableFilterComposer get speciesId {
    final $$CatalogTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.speciesId,
        referencedTable: $db.catalogTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CatalogTableTableFilterComposer(
              $db: $db,
              $table: $db.catalogTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LocationsTableTableFilterComposer get locationId {
    final $$LocationsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.locationId,
        referencedTable: $db.locationsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocationsTableTableFilterComposer(
              $db: $db,
              $table: $db.locationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> sourceRelations(
      Expression<bool> Function($$RelationsTableTableFilterComposer f) f) {
    final $$RelationsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationsTable,
        getReferencedColumn: (t) => t.sourceEntityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationsTableTableFilterComposer(
              $db: $db,
              $table: $db.relationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> targetRelations(
      Expression<bool> Function($$RelationsTableTableFilterComposer f) f) {
    final $$RelationsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationsTable,
        getReferencedColumn: (t) => t.targetEntityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationsTableTableFilterComposer(
              $db: $db,
              $table: $db.relationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EntitiesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitiesTableTable> {
  $$EntitiesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CatalogTableTableOrderingComposer get speciesId {
    final $$CatalogTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.speciesId,
        referencedTable: $db.catalogTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CatalogTableTableOrderingComposer(
              $db: $db,
              $table: $db.catalogTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LocationsTableTableOrderingComposer get locationId {
    final $$LocationsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.locationId,
        referencedTable: $db.locationsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocationsTableTableOrderingComposer(
              $db: $db,
              $table: $db.locationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntitiesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitiesTableTable> {
  $$EntitiesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CatalogTableTableAnnotationComposer get speciesId {
    final $$CatalogTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.speciesId,
        referencedTable: $db.catalogTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CatalogTableTableAnnotationComposer(
              $db: $db,
              $table: $db.catalogTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LocationsTableTableAnnotationComposer get locationId {
    final $$LocationsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.locationId,
        referencedTable: $db.locationsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LocationsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.locationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> sourceRelations<T extends Object>(
      Expression<T> Function($$RelationsTableTableAnnotationComposer a) f) {
    final $$RelationsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationsTable,
        getReferencedColumn: (t) => t.sourceEntityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.relationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> targetRelations<T extends Object>(
      Expression<T> Function($$RelationsTableTableAnnotationComposer a) f) {
    final $$RelationsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationsTable,
        getReferencedColumn: (t) => t.targetEntityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.relationsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EntitiesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntitiesTableTable,
    EntitiesTableData,
    $$EntitiesTableTableFilterComposer,
    $$EntitiesTableTableOrderingComposer,
    $$EntitiesTableTableAnnotationComposer,
    $$EntitiesTableTableCreateCompanionBuilder,
    $$EntitiesTableTableUpdateCompanionBuilder,
    (EntitiesTableData, $$EntitiesTableTableReferences),
    EntitiesTableData,
    PrefetchHooks Function(
        {bool speciesId,
        bool locationId,
        bool sourceRelations,
        bool targetRelations})> {
  $$EntitiesTableTableTableManager(_$AppDatabase db, $EntitiesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitiesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitiesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitiesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> speciesId = const Value.absent(),
            Value<String?> locationId = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntitiesTableCompanion(
            id: id,
            speciesId: speciesId,
            locationId: locationId,
            quantity: quantity,
            unit: unit,
            notes: notes,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String speciesId,
            Value<String?> locationId = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EntitiesTableCompanion.insert(
            id: id,
            speciesId: speciesId,
            locationId: locationId,
            quantity: quantity,
            unit: unit,
            notes: notes,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EntitiesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {speciesId = false,
              locationId = false,
              sourceRelations = false,
              targetRelations = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sourceRelations) db.relationsTable,
                if (targetRelations) db.relationsTable
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (speciesId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.speciesId,
                    referencedTable:
                        $$EntitiesTableTableReferences._speciesIdTable(db),
                    referencedColumn:
                        $$EntitiesTableTableReferences._speciesIdTable(db).id,
                  ) as T;
                }
                if (locationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.locationId,
                    referencedTable:
                        $$EntitiesTableTableReferences._locationIdTable(db),
                    referencedColumn:
                        $$EntitiesTableTableReferences._locationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sourceRelations)
                    await $_getPrefetchedData<EntitiesTableData,
                            $EntitiesTableTable, RelationsTableData>(
                        currentTable: table,
                        referencedTable: $$EntitiesTableTableReferences
                            ._sourceRelationsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntitiesTableTableReferences(db, table, p0)
                                .sourceRelations,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sourceEntityId == item.id),
                        typedResults: items),
                  if (targetRelations)
                    await $_getPrefetchedData<EntitiesTableData,
                            $EntitiesTableTable, RelationsTableData>(
                        currentTable: table,
                        referencedTable: $$EntitiesTableTableReferences
                            ._targetRelationsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntitiesTableTableReferences(db, table, p0)
                                .targetRelations,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.targetEntityId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EntitiesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntitiesTableTable,
    EntitiesTableData,
    $$EntitiesTableTableFilterComposer,
    $$EntitiesTableTableOrderingComposer,
    $$EntitiesTableTableAnnotationComposer,
    $$EntitiesTableTableCreateCompanionBuilder,
    $$EntitiesTableTableUpdateCompanionBuilder,
    (EntitiesTableData, $$EntitiesTableTableReferences),
    EntitiesTableData,
    PrefetchHooks Function(
        {bool speciesId,
        bool locationId,
        bool sourceRelations,
        bool targetRelations})>;
typedef $$RelationsTableTableCreateCompanionBuilder = RelationsTableCompanion
    Function({
  required String id,
  required String sourceEntityId,
  required String targetEntityId,
  required String relationType,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RelationsTableTableUpdateCompanionBuilder = RelationsTableCompanion
    Function({
  Value<String> id,
  Value<String> sourceEntityId,
  Value<String> targetEntityId,
  Value<String> relationType,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$RelationsTableTableReferences extends BaseReferences<
    _$AppDatabase, $RelationsTableTable, RelationsTableData> {
  $$RelationsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTableTable _sourceEntityIdTable(_$AppDatabase db) =>
      db.entitiesTable.createAlias($_aliasNameGenerator(
          db.relationsTable.sourceEntityId, db.entitiesTable.id));

  $$EntitiesTableTableProcessedTableManager get sourceEntityId {
    final $_column = $_itemColumn<String>('source_entity_id')!;

    final manager = $$EntitiesTableTableTableManager($_db, $_db.entitiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceEntityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $EntitiesTableTable _targetEntityIdTable(_$AppDatabase db) =>
      db.entitiesTable.createAlias($_aliasNameGenerator(
          db.relationsTable.targetEntityId, db.entitiesTable.id));

  $$EntitiesTableTableProcessedTableManager get targetEntityId {
    final $_column = $_itemColumn<String>('target_entity_id')!;

    final manager = $$EntitiesTableTableTableManager($_db, $_db.entitiesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetEntityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RelationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RelationsTableTable> {
  $$RelationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$EntitiesTableTableFilterComposer get sourceEntityId {
    final $$EntitiesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceEntityId,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableFilterComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableTableFilterComposer get targetEntityId {
    final $$EntitiesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetEntityId,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableFilterComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationsTableTable> {
  $$RelationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationType => $composableBuilder(
      column: $table.relationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$EntitiesTableTableOrderingComposer get sourceEntityId {
    final $$EntitiesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceEntityId,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableOrderingComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableTableOrderingComposer get targetEntityId {
    final $$EntitiesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetEntityId,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableOrderingComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationsTableTable> {
  $$RelationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EntitiesTableTableAnnotationComposer get sourceEntityId {
    final $$EntitiesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceEntityId,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableTableAnnotationComposer get targetEntityId {
    final $$EntitiesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetEntityId,
        referencedTable: $db.entitiesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.entitiesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RelationsTableTable,
    RelationsTableData,
    $$RelationsTableTableFilterComposer,
    $$RelationsTableTableOrderingComposer,
    $$RelationsTableTableAnnotationComposer,
    $$RelationsTableTableCreateCompanionBuilder,
    $$RelationsTableTableUpdateCompanionBuilder,
    (RelationsTableData, $$RelationsTableTableReferences),
    RelationsTableData,
    PrefetchHooks Function({bool sourceEntityId, bool targetEntityId})> {
  $$RelationsTableTableTableManager(
      _$AppDatabase db, $RelationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceEntityId = const Value.absent(),
            Value<String> targetEntityId = const Value.absent(),
            Value<String> relationType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelationsTableCompanion(
            id: id,
            sourceEntityId: sourceEntityId,
            targetEntityId: targetEntityId,
            relationType: relationType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceEntityId,
            required String targetEntityId,
            required String relationType,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RelationsTableCompanion.insert(
            id: id,
            sourceEntityId: sourceEntityId,
            targetEntityId: targetEntityId,
            relationType: relationType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RelationsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sourceEntityId = false, targetEntityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sourceEntityId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceEntityId,
                    referencedTable: $$RelationsTableTableReferences
                        ._sourceEntityIdTable(db),
                    referencedColumn: $$RelationsTableTableReferences
                        ._sourceEntityIdTable(db)
                        .id,
                  ) as T;
                }
                if (targetEntityId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetEntityId,
                    referencedTable: $$RelationsTableTableReferences
                        ._targetEntityIdTable(db),
                    referencedColumn: $$RelationsTableTableReferences
                        ._targetEntityIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RelationsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RelationsTableTable,
    RelationsTableData,
    $$RelationsTableTableFilterComposer,
    $$RelationsTableTableOrderingComposer,
    $$RelationsTableTableAnnotationComposer,
    $$RelationsTableTableCreateCompanionBuilder,
    $$RelationsTableTableUpdateCompanionBuilder,
    (RelationsTableData, $$RelationsTableTableReferences),
    RelationsTableData,
    PrefetchHooks Function({bool sourceEntityId, bool targetEntityId})>;
typedef $$AttachmentsTableTableCreateCompanionBuilder
    = AttachmentsTableCompanion Function({
  required String id,
  required String speciesId,
  required String filePath,
  required String fileName,
  required String fileType,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AttachmentsTableTableUpdateCompanionBuilder
    = AttachmentsTableCompanion Function({
  Value<String> id,
  Value<String> speciesId,
  Value<String> filePath,
  Value<String> fileName,
  Value<String> fileType,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AttachmentsTableTableReferences extends BaseReferences<
    _$AppDatabase, $AttachmentsTableTable, AttachmentsTableData> {
  $$AttachmentsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CatalogTableTable _speciesIdTable(_$AppDatabase db) =>
      db.catalogTable.createAlias($_aliasNameGenerator(
          db.attachmentsTable.speciesId, db.catalogTable.id));

  $$CatalogTableTableProcessedTableManager get speciesId {
    final $_column = $_itemColumn<String>('species_id')!;

    final manager = $$CatalogTableTableTableManager($_db, $_db.catalogTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_speciesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttachmentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTableTable> {
  $$AttachmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CatalogTableTableFilterComposer get speciesId {
    final $$CatalogTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.speciesId,
        referencedTable: $db.catalogTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CatalogTableTableFilterComposer(
              $db: $db,
              $table: $db.catalogTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTableTable> {
  $$AttachmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CatalogTableTableOrderingComposer get speciesId {
    final $$CatalogTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.speciesId,
        referencedTable: $db.catalogTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CatalogTableTableOrderingComposer(
              $db: $db,
              $table: $db.catalogTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTableTable> {
  $$AttachmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CatalogTableTableAnnotationComposer get speciesId {
    final $$CatalogTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.speciesId,
        referencedTable: $db.catalogTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CatalogTableTableAnnotationComposer(
              $db: $db,
              $table: $db.catalogTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttachmentsTableTable,
    AttachmentsTableData,
    $$AttachmentsTableTableFilterComposer,
    $$AttachmentsTableTableOrderingComposer,
    $$AttachmentsTableTableAnnotationComposer,
    $$AttachmentsTableTableCreateCompanionBuilder,
    $$AttachmentsTableTableUpdateCompanionBuilder,
    (AttachmentsTableData, $$AttachmentsTableTableReferences),
    AttachmentsTableData,
    PrefetchHooks Function({bool speciesId})> {
  $$AttachmentsTableTableTableManager(
      _$AppDatabase db, $AttachmentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> speciesId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> fileType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttachmentsTableCompanion(
            id: id,
            speciesId: speciesId,
            filePath: filePath,
            fileName: fileName,
            fileType: fileType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String speciesId,
            required String filePath,
            required String fileName,
            required String fileType,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AttachmentsTableCompanion.insert(
            id: id,
            speciesId: speciesId,
            filePath: filePath,
            fileName: fileName,
            fileType: fileType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttachmentsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({speciesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (speciesId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.speciesId,
                    referencedTable:
                        $$AttachmentsTableTableReferences._speciesIdTable(db),
                    referencedColumn: $$AttachmentsTableTableReferences
                        ._speciesIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AttachmentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttachmentsTableTable,
    AttachmentsTableData,
    $$AttachmentsTableTableFilterComposer,
    $$AttachmentsTableTableOrderingComposer,
    $$AttachmentsTableTableAnnotationComposer,
    $$AttachmentsTableTableCreateCompanionBuilder,
    $$AttachmentsTableTableUpdateCompanionBuilder,
    (AttachmentsTableData, $$AttachmentsTableTableReferences),
    AttachmentsTableData,
    PrefetchHooks Function({bool speciesId})>;
typedef $$HistoryEventsTableTableCreateCompanionBuilder
    = HistoryEventsTableCompanion Function({
  required String id,
  Value<String?> entityId,
  required String eventType,
  required String description,
  Value<String?> metadata,
  required DateTime timestamp,
  Value<int> rowid,
});
typedef $$HistoryEventsTableTableUpdateCompanionBuilder
    = HistoryEventsTableCompanion Function({
  Value<String> id,
  Value<String?> entityId,
  Value<String> eventType,
  Value<String> description,
  Value<String?> metadata,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

class $$HistoryEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryEventsTableTable> {
  $$HistoryEventsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$HistoryEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryEventsTableTable> {
  $$HistoryEventsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$HistoryEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryEventsTableTable> {
  $$HistoryEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$HistoryEventsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoryEventsTableTable,
    HistoryEventsTableData,
    $$HistoryEventsTableTableFilterComposer,
    $$HistoryEventsTableTableOrderingComposer,
    $$HistoryEventsTableTableAnnotationComposer,
    $$HistoryEventsTableTableCreateCompanionBuilder,
    $$HistoryEventsTableTableUpdateCompanionBuilder,
    (
      HistoryEventsTableData,
      BaseReferences<_$AppDatabase, $HistoryEventsTableTable,
          HistoryEventsTableData>
    ),
    HistoryEventsTableData,
    PrefetchHooks Function()> {
  $$HistoryEventsTableTableTableManager(
      _$AppDatabase db, $HistoryEventsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryEventsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryEventsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoryEventsTableCompanion(
            id: id,
            entityId: entityId,
            eventType: eventType,
            description: description,
            metadata: metadata,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> entityId = const Value.absent(),
            required String eventType,
            required String description,
            Value<String?> metadata = const Value.absent(),
            required DateTime timestamp,
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoryEventsTableCompanion.insert(
            id: id,
            entityId: entityId,
            eventType: eventType,
            description: description,
            metadata: metadata,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HistoryEventsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HistoryEventsTableTable,
    HistoryEventsTableData,
    $$HistoryEventsTableTableFilterComposer,
    $$HistoryEventsTableTableOrderingComposer,
    $$HistoryEventsTableTableAnnotationComposer,
    $$HistoryEventsTableTableCreateCompanionBuilder,
    $$HistoryEventsTableTableUpdateCompanionBuilder,
    (
      HistoryEventsTableData,
      BaseReferences<_$AppDatabase, $HistoryEventsTableTable,
          HistoryEventsTableData>
    ),
    HistoryEventsTableData,
    PrefetchHooks Function()>;
typedef $$CustomTemplatesTableTableCreateCompanionBuilder
    = CustomTemplatesTableCompanion Function({
  required String id,
  required String typeName,
  required String iconName,
  Value<String> commonUnits,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CustomTemplatesTableTableUpdateCompanionBuilder
    = CustomTemplatesTableCompanion Function({
  Value<String> id,
  Value<String> typeName,
  Value<String> iconName,
  Value<String> commonUnits,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CustomTemplatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CustomTemplatesTableTable> {
  $$CustomTemplatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeName => $composableBuilder(
      column: $table.typeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commonUnits => $composableBuilder(
      column: $table.commonUnits, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CustomTemplatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomTemplatesTableTable> {
  $$CustomTemplatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeName => $composableBuilder(
      column: $table.typeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commonUnits => $composableBuilder(
      column: $table.commonUnits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomTemplatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomTemplatesTableTable> {
  $$CustomTemplatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get typeName =>
      $composableBuilder(column: $table.typeName, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get commonUnits => $composableBuilder(
      column: $table.commonUnits, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomTemplatesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomTemplatesTableTable,
    CustomTemplatesTableData,
    $$CustomTemplatesTableTableFilterComposer,
    $$CustomTemplatesTableTableOrderingComposer,
    $$CustomTemplatesTableTableAnnotationComposer,
    $$CustomTemplatesTableTableCreateCompanionBuilder,
    $$CustomTemplatesTableTableUpdateCompanionBuilder,
    (
      CustomTemplatesTableData,
      BaseReferences<_$AppDatabase, $CustomTemplatesTableTable,
          CustomTemplatesTableData>
    ),
    CustomTemplatesTableData,
    PrefetchHooks Function()> {
  $$CustomTemplatesTableTableTableManager(
      _$AppDatabase db, $CustomTemplatesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomTemplatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomTemplatesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomTemplatesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> typeName = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<String> commonUnits = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomTemplatesTableCompanion(
            id: id,
            typeName: typeName,
            iconName: iconName,
            commonUnits: commonUnits,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String typeName,
            required String iconName,
            Value<String> commonUnits = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomTemplatesTableCompanion.insert(
            id: id,
            typeName: typeName,
            iconName: iconName,
            commonUnits: commonUnits,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomTemplatesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CustomTemplatesTableTable,
        CustomTemplatesTableData,
        $$CustomTemplatesTableTableFilterComposer,
        $$CustomTemplatesTableTableOrderingComposer,
        $$CustomTemplatesTableTableAnnotationComposer,
        $$CustomTemplatesTableTableCreateCompanionBuilder,
        $$CustomTemplatesTableTableUpdateCompanionBuilder,
        (
          CustomTemplatesTableData,
          BaseReferences<_$AppDatabase, $CustomTemplatesTableTable,
              CustomTemplatesTableData>
        ),
        CustomTemplatesTableData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocationsTableTableTableManager get locationsTable =>
      $$LocationsTableTableTableManager(_db, _db.locationsTable);
  $$CatalogTableTableTableManager get catalogTable =>
      $$CatalogTableTableTableManager(_db, _db.catalogTable);
  $$EntitiesTableTableTableManager get entitiesTable =>
      $$EntitiesTableTableTableManager(_db, _db.entitiesTable);
  $$RelationsTableTableTableManager get relationsTable =>
      $$RelationsTableTableTableManager(_db, _db.relationsTable);
  $$AttachmentsTableTableTableManager get attachmentsTable =>
      $$AttachmentsTableTableTableManager(_db, _db.attachmentsTable);
  $$HistoryEventsTableTableTableManager get historyEventsTable =>
      $$HistoryEventsTableTableTableManager(_db, _db.historyEventsTable);
  $$CustomTemplatesTableTableTableManager get customTemplatesTable =>
      $$CustomTemplatesTableTableTableManager(_db, _db.customTemplatesTable);
}
