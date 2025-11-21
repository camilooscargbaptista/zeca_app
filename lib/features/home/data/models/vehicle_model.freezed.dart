// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) {
  return _VehicleModel.fromJson(json);
}

/// @nodoc
mixin _$VehicleModel {
  String get id => throw _privateConstructorUsedError;
  String get plate => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_types')
  List<String> get fuelTypes => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_km')
  int get lastKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_refueling')
  DateTime? get lastRefueling => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  VehicleSpecsModel? get specs => throw _privateConstructorUsedError;
  VehicleInsuranceModel? get insurance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VehicleModelCopyWith<VehicleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleModelCopyWith<$Res> {
  factory $VehicleModelCopyWith(
          VehicleModel value, $Res Function(VehicleModel) then) =
      _$VehicleModelCopyWithImpl<$Res, VehicleModel>;
  @useResult
  $Res call(
      {String id,
      String plate,
      String model,
      String brand,
      int year,
      String color,
      @JsonKey(name: 'fuel_types') List<String> fuelTypes,
      @JsonKey(name: 'last_km') int lastKm,
      @JsonKey(name: 'last_refueling') DateTime? lastRefueling,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      VehicleSpecsModel? specs,
      VehicleInsuranceModel? insurance});

  $VehicleSpecsModelCopyWith<$Res>? get specs;
  $VehicleInsuranceModelCopyWith<$Res>? get insurance;
}

/// @nodoc
class _$VehicleModelCopyWithImpl<$Res, $Val extends VehicleModel>
    implements $VehicleModelCopyWith<$Res> {
  _$VehicleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plate = null,
    Object? model = null,
    Object? brand = null,
    Object? year = null,
    Object? color = null,
    Object? fuelTypes = null,
    Object? lastKm = null,
    Object? lastRefueling = freezed,
    Object? companyId = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? specs = freezed,
    Object? insurance = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      plate: null == plate
          ? _value.plate
          : plate // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      fuelTypes: null == fuelTypes
          ? _value.fuelTypes
          : fuelTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastKm: null == lastKm
          ? _value.lastKm
          : lastKm // ignore: cast_nullable_to_non_nullable
              as int,
      lastRefueling: freezed == lastRefueling
          ? _value.lastRefueling
          : lastRefueling // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specs: freezed == specs
          ? _value.specs
          : specs // ignore: cast_nullable_to_non_nullable
              as VehicleSpecsModel?,
      insurance: freezed == insurance
          ? _value.insurance
          : insurance // ignore: cast_nullable_to_non_nullable
              as VehicleInsuranceModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VehicleSpecsModelCopyWith<$Res>? get specs {
    if (_value.specs == null) {
      return null;
    }

    return $VehicleSpecsModelCopyWith<$Res>(_value.specs!, (value) {
      return _then(_value.copyWith(specs: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $VehicleInsuranceModelCopyWith<$Res>? get insurance {
    if (_value.insurance == null) {
      return null;
    }

    return $VehicleInsuranceModelCopyWith<$Res>(_value.insurance!, (value) {
      return _then(_value.copyWith(insurance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VehicleModelImplCopyWith<$Res>
    implements $VehicleModelCopyWith<$Res> {
  factory _$$VehicleModelImplCopyWith(
          _$VehicleModelImpl value, $Res Function(_$VehicleModelImpl) then) =
      __$$VehicleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String plate,
      String model,
      String brand,
      int year,
      String color,
      @JsonKey(name: 'fuel_types') List<String> fuelTypes,
      @JsonKey(name: 'last_km') int lastKm,
      @JsonKey(name: 'last_refueling') DateTime? lastRefueling,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      VehicleSpecsModel? specs,
      VehicleInsuranceModel? insurance});

  @override
  $VehicleSpecsModelCopyWith<$Res>? get specs;
  @override
  $VehicleInsuranceModelCopyWith<$Res>? get insurance;
}

/// @nodoc
class __$$VehicleModelImplCopyWithImpl<$Res>
    extends _$VehicleModelCopyWithImpl<$Res, _$VehicleModelImpl>
    implements _$$VehicleModelImplCopyWith<$Res> {
  __$$VehicleModelImplCopyWithImpl(
      _$VehicleModelImpl _value, $Res Function(_$VehicleModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plate = null,
    Object? model = null,
    Object? brand = null,
    Object? year = null,
    Object? color = null,
    Object? fuelTypes = null,
    Object? lastKm = null,
    Object? lastRefueling = freezed,
    Object? companyId = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? specs = freezed,
    Object? insurance = freezed,
  }) {
    return _then(_$VehicleModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      plate: null == plate
          ? _value.plate
          : plate // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      fuelTypes: null == fuelTypes
          ? _value._fuelTypes
          : fuelTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastKm: null == lastKm
          ? _value.lastKm
          : lastKm // ignore: cast_nullable_to_non_nullable
              as int,
      lastRefueling: freezed == lastRefueling
          ? _value.lastRefueling
          : lastRefueling // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specs: freezed == specs
          ? _value.specs
          : specs // ignore: cast_nullable_to_non_nullable
              as VehicleSpecsModel?,
      insurance: freezed == insurance
          ? _value.insurance
          : insurance // ignore: cast_nullable_to_non_nullable
              as VehicleInsuranceModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleModelImpl extends _VehicleModel {
  const _$VehicleModelImpl(
      {required this.id,
      required this.plate,
      required this.model,
      required this.brand,
      required this.year,
      required this.color,
      @JsonKey(name: 'fuel_types') final List<String> fuelTypes = const [],
      @JsonKey(name: 'last_km') required this.lastKm,
      @JsonKey(name: 'last_refueling') this.lastRefueling,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.specs,
      this.insurance})
      : _fuelTypes = fuelTypes,
        super._();

  factory _$VehicleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String plate;
  @override
  final String model;
  @override
  final String brand;
  @override
  final int year;
  @override
  final String color;
  final List<String> _fuelTypes;
  @override
  @JsonKey(name: 'fuel_types')
  List<String> get fuelTypes {
    if (_fuelTypes is EqualUnmodifiableListView) return _fuelTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fuelTypes);
  }

  @override
  @JsonKey(name: 'last_km')
  final int lastKm;
  @override
  @JsonKey(name: 'last_refueling')
  final DateTime? lastRefueling;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  final VehicleSpecsModel? specs;
  @override
  final VehicleInsuranceModel? insurance;

  @override
  String toString() {
    return 'VehicleModel(id: $id, plate: $plate, model: $model, brand: $brand, year: $year, color: $color, fuelTypes: $fuelTypes, lastKm: $lastKm, lastRefueling: $lastRefueling, companyId: $companyId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, specs: $specs, insurance: $insurance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality()
                .equals(other._fuelTypes, _fuelTypes) &&
            (identical(other.lastKm, lastKm) || other.lastKm == lastKm) &&
            (identical(other.lastRefueling, lastRefueling) ||
                other.lastRefueling == lastRefueling) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.specs, specs) || other.specs == specs) &&
            (identical(other.insurance, insurance) ||
                other.insurance == insurance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      plate,
      model,
      brand,
      year,
      color,
      const DeepCollectionEquality().hash(_fuelTypes),
      lastKm,
      lastRefueling,
      companyId,
      isActive,
      createdAt,
      updatedAt,
      specs,
      insurance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleModelImplCopyWith<_$VehicleModelImpl> get copyWith =>
      __$$VehicleModelImplCopyWithImpl<_$VehicleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleModelImplToJson(
      this,
    );
  }
}

abstract class _VehicleModel extends VehicleModel {
  const factory _VehicleModel(
      {required final String id,
      required final String plate,
      required final String model,
      required final String brand,
      required final int year,
      required final String color,
      @JsonKey(name: 'fuel_types') final List<String> fuelTypes,
      @JsonKey(name: 'last_km') required final int lastKm,
      @JsonKey(name: 'last_refueling') final DateTime? lastRefueling,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final VehicleSpecsModel? specs,
      final VehicleInsuranceModel? insurance}) = _$VehicleModelImpl;
  const _VehicleModel._() : super._();

  factory _VehicleModel.fromJson(Map<String, dynamic> json) =
      _$VehicleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get plate;
  @override
  String get model;
  @override
  String get brand;
  @override
  int get year;
  @override
  String get color;
  @override
  @JsonKey(name: 'fuel_types')
  List<String> get fuelTypes;
  @override
  @JsonKey(name: 'last_km')
  int get lastKm;
  @override
  @JsonKey(name: 'last_refueling')
  DateTime? get lastRefueling;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  VehicleSpecsModel? get specs;
  @override
  VehicleInsuranceModel? get insurance;
  @override
  @JsonKey(ignore: true)
  _$$VehicleModelImplCopyWith<_$VehicleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VehicleSpecsModel _$VehicleSpecsModelFromJson(Map<String, dynamic> json) {
  return _VehicleSpecsModel.fromJson(json);
}

/// @nodoc
mixin _$VehicleSpecsModel {
  @JsonKey(name: 'engine_size')
  String? get engineSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_capacity')
  double? get fuelCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'consumption_city')
  double? get consumptionCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'consumption_highway')
  double? get consumptionHighway => throw _privateConstructorUsedError;
  @JsonKey(name: 'transmission')
  String? get transmission => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_system')
  String? get fuelSystem => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VehicleSpecsModelCopyWith<VehicleSpecsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleSpecsModelCopyWith<$Res> {
  factory $VehicleSpecsModelCopyWith(
          VehicleSpecsModel value, $Res Function(VehicleSpecsModel) then) =
      _$VehicleSpecsModelCopyWithImpl<$Res, VehicleSpecsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'engine_size') String? engineSize,
      @JsonKey(name: 'fuel_capacity') double? fuelCapacity,
      @JsonKey(name: 'consumption_city') double? consumptionCity,
      @JsonKey(name: 'consumption_highway') double? consumptionHighway,
      @JsonKey(name: 'transmission') String? transmission,
      @JsonKey(name: 'fuel_system') String? fuelSystem});
}

/// @nodoc
class _$VehicleSpecsModelCopyWithImpl<$Res, $Val extends VehicleSpecsModel>
    implements $VehicleSpecsModelCopyWith<$Res> {
  _$VehicleSpecsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? engineSize = freezed,
    Object? fuelCapacity = freezed,
    Object? consumptionCity = freezed,
    Object? consumptionHighway = freezed,
    Object? transmission = freezed,
    Object? fuelSystem = freezed,
  }) {
    return _then(_value.copyWith(
      engineSize: freezed == engineSize
          ? _value.engineSize
          : engineSize // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelCapacity: freezed == fuelCapacity
          ? _value.fuelCapacity
          : fuelCapacity // ignore: cast_nullable_to_non_nullable
              as double?,
      consumptionCity: freezed == consumptionCity
          ? _value.consumptionCity
          : consumptionCity // ignore: cast_nullable_to_non_nullable
              as double?,
      consumptionHighway: freezed == consumptionHighway
          ? _value.consumptionHighway
          : consumptionHighway // ignore: cast_nullable_to_non_nullable
              as double?,
      transmission: freezed == transmission
          ? _value.transmission
          : transmission // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelSystem: freezed == fuelSystem
          ? _value.fuelSystem
          : fuelSystem // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VehicleSpecsModelImplCopyWith<$Res>
    implements $VehicleSpecsModelCopyWith<$Res> {
  factory _$$VehicleSpecsModelImplCopyWith(_$VehicleSpecsModelImpl value,
          $Res Function(_$VehicleSpecsModelImpl) then) =
      __$$VehicleSpecsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'engine_size') String? engineSize,
      @JsonKey(name: 'fuel_capacity') double? fuelCapacity,
      @JsonKey(name: 'consumption_city') double? consumptionCity,
      @JsonKey(name: 'consumption_highway') double? consumptionHighway,
      @JsonKey(name: 'transmission') String? transmission,
      @JsonKey(name: 'fuel_system') String? fuelSystem});
}

/// @nodoc
class __$$VehicleSpecsModelImplCopyWithImpl<$Res>
    extends _$VehicleSpecsModelCopyWithImpl<$Res, _$VehicleSpecsModelImpl>
    implements _$$VehicleSpecsModelImplCopyWith<$Res> {
  __$$VehicleSpecsModelImplCopyWithImpl(_$VehicleSpecsModelImpl _value,
      $Res Function(_$VehicleSpecsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? engineSize = freezed,
    Object? fuelCapacity = freezed,
    Object? consumptionCity = freezed,
    Object? consumptionHighway = freezed,
    Object? transmission = freezed,
    Object? fuelSystem = freezed,
  }) {
    return _then(_$VehicleSpecsModelImpl(
      engineSize: freezed == engineSize
          ? _value.engineSize
          : engineSize // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelCapacity: freezed == fuelCapacity
          ? _value.fuelCapacity
          : fuelCapacity // ignore: cast_nullable_to_non_nullable
              as double?,
      consumptionCity: freezed == consumptionCity
          ? _value.consumptionCity
          : consumptionCity // ignore: cast_nullable_to_non_nullable
              as double?,
      consumptionHighway: freezed == consumptionHighway
          ? _value.consumptionHighway
          : consumptionHighway // ignore: cast_nullable_to_non_nullable
              as double?,
      transmission: freezed == transmission
          ? _value.transmission
          : transmission // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelSystem: freezed == fuelSystem
          ? _value.fuelSystem
          : fuelSystem // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleSpecsModelImpl extends _VehicleSpecsModel {
  const _$VehicleSpecsModelImpl(
      {@JsonKey(name: 'engine_size') this.engineSize,
      @JsonKey(name: 'fuel_capacity') this.fuelCapacity,
      @JsonKey(name: 'consumption_city') this.consumptionCity,
      @JsonKey(name: 'consumption_highway') this.consumptionHighway,
      @JsonKey(name: 'transmission') this.transmission,
      @JsonKey(name: 'fuel_system') this.fuelSystem})
      : super._();

  factory _$VehicleSpecsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleSpecsModelImplFromJson(json);

  @override
  @JsonKey(name: 'engine_size')
  final String? engineSize;
  @override
  @JsonKey(name: 'fuel_capacity')
  final double? fuelCapacity;
  @override
  @JsonKey(name: 'consumption_city')
  final double? consumptionCity;
  @override
  @JsonKey(name: 'consumption_highway')
  final double? consumptionHighway;
  @override
  @JsonKey(name: 'transmission')
  final String? transmission;
  @override
  @JsonKey(name: 'fuel_system')
  final String? fuelSystem;

  @override
  String toString() {
    return 'VehicleSpecsModel(engineSize: $engineSize, fuelCapacity: $fuelCapacity, consumptionCity: $consumptionCity, consumptionHighway: $consumptionHighway, transmission: $transmission, fuelSystem: $fuelSystem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleSpecsModelImpl &&
            (identical(other.engineSize, engineSize) ||
                other.engineSize == engineSize) &&
            (identical(other.fuelCapacity, fuelCapacity) ||
                other.fuelCapacity == fuelCapacity) &&
            (identical(other.consumptionCity, consumptionCity) ||
                other.consumptionCity == consumptionCity) &&
            (identical(other.consumptionHighway, consumptionHighway) ||
                other.consumptionHighway == consumptionHighway) &&
            (identical(other.transmission, transmission) ||
                other.transmission == transmission) &&
            (identical(other.fuelSystem, fuelSystem) ||
                other.fuelSystem == fuelSystem));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, engineSize, fuelCapacity,
      consumptionCity, consumptionHighway, transmission, fuelSystem);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleSpecsModelImplCopyWith<_$VehicleSpecsModelImpl> get copyWith =>
      __$$VehicleSpecsModelImplCopyWithImpl<_$VehicleSpecsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleSpecsModelImplToJson(
      this,
    );
  }
}

abstract class _VehicleSpecsModel extends VehicleSpecsModel {
  const factory _VehicleSpecsModel(
      {@JsonKey(name: 'engine_size') final String? engineSize,
      @JsonKey(name: 'fuel_capacity') final double? fuelCapacity,
      @JsonKey(name: 'consumption_city') final double? consumptionCity,
      @JsonKey(name: 'consumption_highway') final double? consumptionHighway,
      @JsonKey(name: 'transmission') final String? transmission,
      @JsonKey(name: 'fuel_system')
      final String? fuelSystem}) = _$VehicleSpecsModelImpl;
  const _VehicleSpecsModel._() : super._();

  factory _VehicleSpecsModel.fromJson(Map<String, dynamic> json) =
      _$VehicleSpecsModelImpl.fromJson;

  @override
  @JsonKey(name: 'engine_size')
  String? get engineSize;
  @override
  @JsonKey(name: 'fuel_capacity')
  double? get fuelCapacity;
  @override
  @JsonKey(name: 'consumption_city')
  double? get consumptionCity;
  @override
  @JsonKey(name: 'consumption_highway')
  double? get consumptionHighway;
  @override
  @JsonKey(name: 'transmission')
  String? get transmission;
  @override
  @JsonKey(name: 'fuel_system')
  String? get fuelSystem;
  @override
  @JsonKey(ignore: true)
  _$$VehicleSpecsModelImplCopyWith<_$VehicleSpecsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VehicleInsuranceModel _$VehicleInsuranceModelFromJson(
    Map<String, dynamic> json) {
  return _VehicleInsuranceModel.fromJson(json);
}

/// @nodoc
mixin _$VehicleInsuranceModel {
  @JsonKey(name: 'insurance_company')
  String? get insuranceCompany => throw _privateConstructorUsedError;
  @JsonKey(name: 'policy_number')
  String? get policyNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'coverage_type')
  String? get coverageType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VehicleInsuranceModelCopyWith<VehicleInsuranceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleInsuranceModelCopyWith<$Res> {
  factory $VehicleInsuranceModelCopyWith(VehicleInsuranceModel value,
          $Res Function(VehicleInsuranceModel) then) =
      _$VehicleInsuranceModelCopyWithImpl<$Res, VehicleInsuranceModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'insurance_company') String? insuranceCompany,
      @JsonKey(name: 'policy_number') String? policyNumber,
      @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'coverage_type') String? coverageType});
}

/// @nodoc
class _$VehicleInsuranceModelCopyWithImpl<$Res,
        $Val extends VehicleInsuranceModel>
    implements $VehicleInsuranceModelCopyWith<$Res> {
  _$VehicleInsuranceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insuranceCompany = freezed,
    Object? policyNumber = freezed,
    Object? expiresAt = freezed,
    Object? coverageType = freezed,
  }) {
    return _then(_value.copyWith(
      insuranceCompany: freezed == insuranceCompany
          ? _value.insuranceCompany
          : insuranceCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      policyNumber: freezed == policyNumber
          ? _value.policyNumber
          : policyNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      coverageType: freezed == coverageType
          ? _value.coverageType
          : coverageType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VehicleInsuranceModelImplCopyWith<$Res>
    implements $VehicleInsuranceModelCopyWith<$Res> {
  factory _$$VehicleInsuranceModelImplCopyWith(
          _$VehicleInsuranceModelImpl value,
          $Res Function(_$VehicleInsuranceModelImpl) then) =
      __$$VehicleInsuranceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'insurance_company') String? insuranceCompany,
      @JsonKey(name: 'policy_number') String? policyNumber,
      @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'coverage_type') String? coverageType});
}

/// @nodoc
class __$$VehicleInsuranceModelImplCopyWithImpl<$Res>
    extends _$VehicleInsuranceModelCopyWithImpl<$Res,
        _$VehicleInsuranceModelImpl>
    implements _$$VehicleInsuranceModelImplCopyWith<$Res> {
  __$$VehicleInsuranceModelImplCopyWithImpl(_$VehicleInsuranceModelImpl _value,
      $Res Function(_$VehicleInsuranceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insuranceCompany = freezed,
    Object? policyNumber = freezed,
    Object? expiresAt = freezed,
    Object? coverageType = freezed,
  }) {
    return _then(_$VehicleInsuranceModelImpl(
      insuranceCompany: freezed == insuranceCompany
          ? _value.insuranceCompany
          : insuranceCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      policyNumber: freezed == policyNumber
          ? _value.policyNumber
          : policyNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      coverageType: freezed == coverageType
          ? _value.coverageType
          : coverageType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleInsuranceModelImpl extends _VehicleInsuranceModel {
  const _$VehicleInsuranceModelImpl(
      {@JsonKey(name: 'insurance_company') this.insuranceCompany,
      @JsonKey(name: 'policy_number') this.policyNumber,
      @JsonKey(name: 'expires_at') this.expiresAt,
      @JsonKey(name: 'coverage_type') this.coverageType})
      : super._();

  factory _$VehicleInsuranceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleInsuranceModelImplFromJson(json);

  @override
  @JsonKey(name: 'insurance_company')
  final String? insuranceCompany;
  @override
  @JsonKey(name: 'policy_number')
  final String? policyNumber;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @override
  @JsonKey(name: 'coverage_type')
  final String? coverageType;

  @override
  String toString() {
    return 'VehicleInsuranceModel(insuranceCompany: $insuranceCompany, policyNumber: $policyNumber, expiresAt: $expiresAt, coverageType: $coverageType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleInsuranceModelImpl &&
            (identical(other.insuranceCompany, insuranceCompany) ||
                other.insuranceCompany == insuranceCompany) &&
            (identical(other.policyNumber, policyNumber) ||
                other.policyNumber == policyNumber) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.coverageType, coverageType) ||
                other.coverageType == coverageType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, insuranceCompany, policyNumber, expiresAt, coverageType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleInsuranceModelImplCopyWith<_$VehicleInsuranceModelImpl>
      get copyWith => __$$VehicleInsuranceModelImplCopyWithImpl<
          _$VehicleInsuranceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleInsuranceModelImplToJson(
      this,
    );
  }
}

abstract class _VehicleInsuranceModel extends VehicleInsuranceModel {
  const factory _VehicleInsuranceModel(
          {@JsonKey(name: 'insurance_company') final String? insuranceCompany,
          @JsonKey(name: 'policy_number') final String? policyNumber,
          @JsonKey(name: 'expires_at') final DateTime? expiresAt,
          @JsonKey(name: 'coverage_type') final String? coverageType}) =
      _$VehicleInsuranceModelImpl;
  const _VehicleInsuranceModel._() : super._();

  factory _VehicleInsuranceModel.fromJson(Map<String, dynamic> json) =
      _$VehicleInsuranceModelImpl.fromJson;

  @override
  @JsonKey(name: 'insurance_company')
  String? get insuranceCompany;
  @override
  @JsonKey(name: 'policy_number')
  String? get policyNumber;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  @JsonKey(name: 'coverage_type')
  String? get coverageType;
  @override
  @JsonKey(ignore: true)
  _$$VehicleInsuranceModelImplCopyWith<_$VehicleInsuranceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
