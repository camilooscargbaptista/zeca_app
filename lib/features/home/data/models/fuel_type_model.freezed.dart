// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fuel_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FuelTypeModel _$FuelTypeModelFromJson(Map<String, dynamic> json) {
  return _FuelTypeModel.fromJson(json);
}

/// @nodoc
mixin _$FuelTypeModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'color')
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon')
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit')
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'density')
  double? get density => throw _privateConstructorUsedError;
  @JsonKey(name: 'energy_content')
  double? get energyContent => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FuelTypeModelCopyWith<FuelTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelTypeModelCopyWith<$Res> {
  factory $FuelTypeModelCopyWith(
          FuelTypeModel value, $Res Function(FuelTypeModel) then) =
      _$FuelTypeModelCopyWithImpl<$Res, FuelTypeModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      String description,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'color') String? color,
      @JsonKey(name: 'icon') String? icon,
      @JsonKey(name: 'unit') String unit,
      @JsonKey(name: 'density') double? density,
      @JsonKey(name: 'energy_content') double? energyContent,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$FuelTypeModelCopyWithImpl<$Res, $Val extends FuelTypeModel>
    implements $FuelTypeModelCopyWith<$Res> {
  _$FuelTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = null,
    Object? isActive = null,
    Object? color = freezed,
    Object? icon = freezed,
    Object? unit = null,
    Object? density = freezed,
    Object? energyContent = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      density: freezed == density
          ? _value.density
          : density // ignore: cast_nullable_to_non_nullable
              as double?,
      energyContent: freezed == energyContent
          ? _value.energyContent
          : energyContent // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FuelTypeModelImplCopyWith<$Res>
    implements $FuelTypeModelCopyWith<$Res> {
  factory _$$FuelTypeModelImplCopyWith(
          _$FuelTypeModelImpl value, $Res Function(_$FuelTypeModelImpl) then) =
      __$$FuelTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      String description,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'color') String? color,
      @JsonKey(name: 'icon') String? icon,
      @JsonKey(name: 'unit') String unit,
      @JsonKey(name: 'density') double? density,
      @JsonKey(name: 'energy_content') double? energyContent,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$FuelTypeModelImplCopyWithImpl<$Res>
    extends _$FuelTypeModelCopyWithImpl<$Res, _$FuelTypeModelImpl>
    implements _$$FuelTypeModelImplCopyWith<$Res> {
  __$$FuelTypeModelImplCopyWithImpl(
      _$FuelTypeModelImpl _value, $Res Function(_$FuelTypeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = null,
    Object? isActive = null,
    Object? color = freezed,
    Object? icon = freezed,
    Object? unit = null,
    Object? density = freezed,
    Object? energyContent = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FuelTypeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      density: freezed == density
          ? _value.density
          : density // ignore: cast_nullable_to_non_nullable
              as double?,
      energyContent: freezed == energyContent
          ? _value.energyContent
          : energyContent // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FuelTypeModelImpl implements _FuelTypeModel {
  const _$FuelTypeModelImpl(
      {required this.id,
      required this.name,
      required this.code,
      required this.description,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'color') this.color,
      @JsonKey(name: 'icon') this.icon,
      @JsonKey(name: 'unit') this.unit = 'L',
      @JsonKey(name: 'density') this.density,
      @JsonKey(name: 'energy_content') this.energyContent,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$FuelTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelTypeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String code;
  @override
  final String description;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'color')
  final String? color;
  @override
  @JsonKey(name: 'icon')
  final String? icon;
  @override
  @JsonKey(name: 'unit')
  final String unit;
  @override
  @JsonKey(name: 'density')
  final double? density;
  @override
  @JsonKey(name: 'energy_content')
  final double? energyContent;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FuelTypeModel(id: $id, name: $name, code: $code, description: $description, isActive: $isActive, color: $color, icon: $icon, unit: $unit, density: $density, energyContent: $energyContent, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.density, density) || other.density == density) &&
            (identical(other.energyContent, energyContent) ||
                other.energyContent == energyContent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      code,
      description,
      isActive,
      color,
      icon,
      unit,
      density,
      energyContent,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelTypeModelImplCopyWith<_$FuelTypeModelImpl> get copyWith =>
      __$$FuelTypeModelImplCopyWithImpl<_$FuelTypeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelTypeModelImplToJson(
      this,
    );
  }
}

abstract class _FuelTypeModel implements FuelTypeModel {
  const factory _FuelTypeModel(
          {required final String id,
          required final String name,
          required final String code,
          required final String description,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'color') final String? color,
          @JsonKey(name: 'icon') final String? icon,
          @JsonKey(name: 'unit') final String unit,
          @JsonKey(name: 'density') final double? density,
          @JsonKey(name: 'energy_content') final double? energyContent,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$FuelTypeModelImpl;

  factory _FuelTypeModel.fromJson(Map<String, dynamic> json) =
      _$FuelTypeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get code;
  @override
  String get description;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'color')
  String? get color;
  @override
  @JsonKey(name: 'icon')
  String? get icon;
  @override
  @JsonKey(name: 'unit')
  String get unit;
  @override
  @JsonKey(name: 'density')
  double? get density;
  @override
  @JsonKey(name: 'energy_content')
  double? get energyContent;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FuelTypeModelImplCopyWith<_$FuelTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FuelPriceModel _$FuelPriceModelFromJson(Map<String, dynamic> json) {
  return _FuelPriceModel.fromJson(json);
}

/// @nodoc
mixin _$FuelPriceModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_type_id')
  String get fuelTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  String get stationId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_date')
  DateTime get priceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'source')
  String get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FuelPriceModelCopyWith<FuelPriceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelPriceModelCopyWith<$Res> {
  factory $FuelPriceModelCopyWith(
          FuelPriceModel value, $Res Function(FuelPriceModel) then) =
      _$FuelPriceModelCopyWithImpl<$Res, FuelPriceModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'fuel_type_id') String fuelTypeId,
      @JsonKey(name: 'station_id') String stationId,
      double price,
      @JsonKey(name: 'price_date') DateTime priceDate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'source') String source,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$FuelPriceModelCopyWithImpl<$Res, $Val extends FuelPriceModel>
    implements $FuelPriceModelCopyWith<$Res> {
  _$FuelPriceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fuelTypeId = null,
    Object? stationId = null,
    Object? price = null,
    Object? priceDate = null,
    Object? isActive = null,
    Object? source = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fuelTypeId: null == fuelTypeId
          ? _value.fuelTypeId
          : fuelTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      stationId: null == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      priceDate: null == priceDate
          ? _value.priceDate
          : priceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FuelPriceModelImplCopyWith<$Res>
    implements $FuelPriceModelCopyWith<$Res> {
  factory _$$FuelPriceModelImplCopyWith(_$FuelPriceModelImpl value,
          $Res Function(_$FuelPriceModelImpl) then) =
      __$$FuelPriceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'fuel_type_id') String fuelTypeId,
      @JsonKey(name: 'station_id') String stationId,
      double price,
      @JsonKey(name: 'price_date') DateTime priceDate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'source') String source,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$FuelPriceModelImplCopyWithImpl<$Res>
    extends _$FuelPriceModelCopyWithImpl<$Res, _$FuelPriceModelImpl>
    implements _$$FuelPriceModelImplCopyWith<$Res> {
  __$$FuelPriceModelImplCopyWithImpl(
      _$FuelPriceModelImpl _value, $Res Function(_$FuelPriceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fuelTypeId = null,
    Object? stationId = null,
    Object? price = null,
    Object? priceDate = null,
    Object? isActive = null,
    Object? source = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FuelPriceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fuelTypeId: null == fuelTypeId
          ? _value.fuelTypeId
          : fuelTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      stationId: null == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      priceDate: null == priceDate
          ? _value.priceDate
          : priceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FuelPriceModelImpl implements _FuelPriceModel {
  const _$FuelPriceModelImpl(
      {required this.id,
      @JsonKey(name: 'fuel_type_id') required this.fuelTypeId,
      @JsonKey(name: 'station_id') required this.stationId,
      required this.price,
      @JsonKey(name: 'price_date') required this.priceDate,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'source') this.source = 'station',
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$FuelPriceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelPriceModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'fuel_type_id')
  final String fuelTypeId;
  @override
  @JsonKey(name: 'station_id')
  final String stationId;
  @override
  final double price;
  @override
  @JsonKey(name: 'price_date')
  final DateTime priceDate;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'source')
  final String source;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FuelPriceModel(id: $id, fuelTypeId: $fuelTypeId, stationId: $stationId, price: $price, priceDate: $priceDate, isActive: $isActive, source: $source, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelPriceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fuelTypeId, fuelTypeId) ||
                other.fuelTypeId == fuelTypeId) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.priceDate, priceDate) ||
                other.priceDate == priceDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fuelTypeId, stationId, price,
      priceDate, isActive, source, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelPriceModelImplCopyWith<_$FuelPriceModelImpl> get copyWith =>
      __$$FuelPriceModelImplCopyWithImpl<_$FuelPriceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelPriceModelImplToJson(
      this,
    );
  }
}

abstract class _FuelPriceModel implements FuelPriceModel {
  const factory _FuelPriceModel(
          {required final String id,
          @JsonKey(name: 'fuel_type_id') required final String fuelTypeId,
          @JsonKey(name: 'station_id') required final String stationId,
          required final double price,
          @JsonKey(name: 'price_date') required final DateTime priceDate,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'source') final String source,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$FuelPriceModelImpl;

  factory _FuelPriceModel.fromJson(Map<String, dynamic> json) =
      _$FuelPriceModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'fuel_type_id')
  String get fuelTypeId;
  @override
  @JsonKey(name: 'station_id')
  String get stationId;
  @override
  double get price;
  @override
  @JsonKey(name: 'price_date')
  DateTime get priceDate;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'source')
  String get source;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FuelPriceModelImplCopyWith<_$FuelPriceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FuelPriceHistoryModel _$FuelPriceHistoryModelFromJson(
    Map<String, dynamic> json) {
  return _FuelPriceHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$FuelPriceHistoryModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_type_id')
  String get fuelTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  String get stationId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_date')
  DateTime get priceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'change_amount')
  double? get changeAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'change_percentage')
  double? get changePercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_increase')
  bool get isIncrease => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FuelPriceHistoryModelCopyWith<FuelPriceHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelPriceHistoryModelCopyWith<$Res> {
  factory $FuelPriceHistoryModelCopyWith(FuelPriceHistoryModel value,
          $Res Function(FuelPriceHistoryModel) then) =
      _$FuelPriceHistoryModelCopyWithImpl<$Res, FuelPriceHistoryModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'fuel_type_id') String fuelTypeId,
      @JsonKey(name: 'station_id') String stationId,
      double price,
      @JsonKey(name: 'price_date') DateTime priceDate,
      @JsonKey(name: 'change_amount') double? changeAmount,
      @JsonKey(name: 'change_percentage') double? changePercentage,
      @JsonKey(name: 'is_increase') bool isIncrease});
}

/// @nodoc
class _$FuelPriceHistoryModelCopyWithImpl<$Res,
        $Val extends FuelPriceHistoryModel>
    implements $FuelPriceHistoryModelCopyWith<$Res> {
  _$FuelPriceHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fuelTypeId = null,
    Object? stationId = null,
    Object? price = null,
    Object? priceDate = null,
    Object? changeAmount = freezed,
    Object? changePercentage = freezed,
    Object? isIncrease = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fuelTypeId: null == fuelTypeId
          ? _value.fuelTypeId
          : fuelTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      stationId: null == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      priceDate: null == priceDate
          ? _value.priceDate
          : priceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changeAmount: freezed == changeAmount
          ? _value.changeAmount
          : changeAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      changePercentage: freezed == changePercentage
          ? _value.changePercentage
          : changePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      isIncrease: null == isIncrease
          ? _value.isIncrease
          : isIncrease // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FuelPriceHistoryModelImplCopyWith<$Res>
    implements $FuelPriceHistoryModelCopyWith<$Res> {
  factory _$$FuelPriceHistoryModelImplCopyWith(
          _$FuelPriceHistoryModelImpl value,
          $Res Function(_$FuelPriceHistoryModelImpl) then) =
      __$$FuelPriceHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'fuel_type_id') String fuelTypeId,
      @JsonKey(name: 'station_id') String stationId,
      double price,
      @JsonKey(name: 'price_date') DateTime priceDate,
      @JsonKey(name: 'change_amount') double? changeAmount,
      @JsonKey(name: 'change_percentage') double? changePercentage,
      @JsonKey(name: 'is_increase') bool isIncrease});
}

/// @nodoc
class __$$FuelPriceHistoryModelImplCopyWithImpl<$Res>
    extends _$FuelPriceHistoryModelCopyWithImpl<$Res,
        _$FuelPriceHistoryModelImpl>
    implements _$$FuelPriceHistoryModelImplCopyWith<$Res> {
  __$$FuelPriceHistoryModelImplCopyWithImpl(_$FuelPriceHistoryModelImpl _value,
      $Res Function(_$FuelPriceHistoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fuelTypeId = null,
    Object? stationId = null,
    Object? price = null,
    Object? priceDate = null,
    Object? changeAmount = freezed,
    Object? changePercentage = freezed,
    Object? isIncrease = null,
  }) {
    return _then(_$FuelPriceHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fuelTypeId: null == fuelTypeId
          ? _value.fuelTypeId
          : fuelTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      stationId: null == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      priceDate: null == priceDate
          ? _value.priceDate
          : priceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changeAmount: freezed == changeAmount
          ? _value.changeAmount
          : changeAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      changePercentage: freezed == changePercentage
          ? _value.changePercentage
          : changePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      isIncrease: null == isIncrease
          ? _value.isIncrease
          : isIncrease // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FuelPriceHistoryModelImpl implements _FuelPriceHistoryModel {
  const _$FuelPriceHistoryModelImpl(
      {required this.id,
      @JsonKey(name: 'fuel_type_id') required this.fuelTypeId,
      @JsonKey(name: 'station_id') required this.stationId,
      required this.price,
      @JsonKey(name: 'price_date') required this.priceDate,
      @JsonKey(name: 'change_amount') this.changeAmount,
      @JsonKey(name: 'change_percentage') this.changePercentage,
      @JsonKey(name: 'is_increase') this.isIncrease = false});

  factory _$FuelPriceHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelPriceHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'fuel_type_id')
  final String fuelTypeId;
  @override
  @JsonKey(name: 'station_id')
  final String stationId;
  @override
  final double price;
  @override
  @JsonKey(name: 'price_date')
  final DateTime priceDate;
  @override
  @JsonKey(name: 'change_amount')
  final double? changeAmount;
  @override
  @JsonKey(name: 'change_percentage')
  final double? changePercentage;
  @override
  @JsonKey(name: 'is_increase')
  final bool isIncrease;

  @override
  String toString() {
    return 'FuelPriceHistoryModel(id: $id, fuelTypeId: $fuelTypeId, stationId: $stationId, price: $price, priceDate: $priceDate, changeAmount: $changeAmount, changePercentage: $changePercentage, isIncrease: $isIncrease)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelPriceHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fuelTypeId, fuelTypeId) ||
                other.fuelTypeId == fuelTypeId) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.priceDate, priceDate) ||
                other.priceDate == priceDate) &&
            (identical(other.changeAmount, changeAmount) ||
                other.changeAmount == changeAmount) &&
            (identical(other.changePercentage, changePercentage) ||
                other.changePercentage == changePercentage) &&
            (identical(other.isIncrease, isIncrease) ||
                other.isIncrease == isIncrease));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fuelTypeId, stationId, price,
      priceDate, changeAmount, changePercentage, isIncrease);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelPriceHistoryModelImplCopyWith<_$FuelPriceHistoryModelImpl>
      get copyWith => __$$FuelPriceHistoryModelImplCopyWithImpl<
          _$FuelPriceHistoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelPriceHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _FuelPriceHistoryModel implements FuelPriceHistoryModel {
  const factory _FuelPriceHistoryModel(
          {required final String id,
          @JsonKey(name: 'fuel_type_id') required final String fuelTypeId,
          @JsonKey(name: 'station_id') required final String stationId,
          required final double price,
          @JsonKey(name: 'price_date') required final DateTime priceDate,
          @JsonKey(name: 'change_amount') final double? changeAmount,
          @JsonKey(name: 'change_percentage') final double? changePercentage,
          @JsonKey(name: 'is_increase') final bool isIncrease}) =
      _$FuelPriceHistoryModelImpl;

  factory _FuelPriceHistoryModel.fromJson(Map<String, dynamic> json) =
      _$FuelPriceHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'fuel_type_id')
  String get fuelTypeId;
  @override
  @JsonKey(name: 'station_id')
  String get stationId;
  @override
  double get price;
  @override
  @JsonKey(name: 'price_date')
  DateTime get priceDate;
  @override
  @JsonKey(name: 'change_amount')
  double? get changeAmount;
  @override
  @JsonKey(name: 'change_percentage')
  double? get changePercentage;
  @override
  @JsonKey(name: 'is_increase')
  bool get isIncrease;
  @override
  @JsonKey(ignore: true)
  _$$FuelPriceHistoryModelImplCopyWith<_$FuelPriceHistoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
