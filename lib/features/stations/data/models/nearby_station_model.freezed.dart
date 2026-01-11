// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_station_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NearbyStationModel _$NearbyStationModelFromJson(Map<String, dynamic> json) {
  return _NearbyStationModel.fromJson(json);
}

/// @nodoc
mixin _$NearbyStationModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get cnpj => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double get distanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_partner')
  bool get isPartner => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  NearbyStationAddressModel get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_prices')
  List<FuelPriceItemModel> get fuelPrices => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepts_autonomous')
  bool get acceptsAutonomous => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepts_fleet_without_partnership')
  bool get acceptsFleetWithoutPartnership => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NearbyStationModelCopyWith<NearbyStationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyStationModelCopyWith<$Res> {
  factory $NearbyStationModelCopyWith(
          NearbyStationModel value, $Res Function(NearbyStationModel) then) =
      _$NearbyStationModelCopyWithImpl<$Res, NearbyStationModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String cnpj,
      @JsonKey(name: 'distance_km') double distanceKm,
      @JsonKey(name: 'is_partner') bool isPartner,
      double latitude,
      double longitude,
      NearbyStationAddressModel address,
      @JsonKey(name: 'fuel_prices') List<FuelPriceItemModel> fuelPrices,
      @JsonKey(name: 'accepts_autonomous') bool acceptsAutonomous,
      @JsonKey(name: 'accepts_fleet_without_partnership')
      bool acceptsFleetWithoutPartnership});

  $NearbyStationAddressModelCopyWith<$Res> get address;
}

/// @nodoc
class _$NearbyStationModelCopyWithImpl<$Res, $Val extends NearbyStationModel>
    implements $NearbyStationModelCopyWith<$Res> {
  _$NearbyStationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cnpj = null,
    Object? distanceKm = null,
    Object? isPartner = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? fuelPrices = null,
    Object? acceptsAutonomous = null,
    Object? acceptsFleetWithoutPartnership = null,
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
      cnpj: null == cnpj
          ? _value.cnpj
          : cnpj // ignore: cast_nullable_to_non_nullable
              as String,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      isPartner: null == isPartner
          ? _value.isPartner
          : isPartner // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as NearbyStationAddressModel,
      fuelPrices: null == fuelPrices
          ? _value.fuelPrices
          : fuelPrices // ignore: cast_nullable_to_non_nullable
              as List<FuelPriceItemModel>,
      acceptsAutonomous: null == acceptsAutonomous
          ? _value.acceptsAutonomous
          : acceptsAutonomous // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsFleetWithoutPartnership: null == acceptsFleetWithoutPartnership
          ? _value.acceptsFleetWithoutPartnership
          : acceptsFleetWithoutPartnership // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NearbyStationAddressModelCopyWith<$Res> get address {
    return $NearbyStationAddressModelCopyWith<$Res>(_value.address, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NearbyStationModelImplCopyWith<$Res>
    implements $NearbyStationModelCopyWith<$Res> {
  factory _$$NearbyStationModelImplCopyWith(_$NearbyStationModelImpl value,
          $Res Function(_$NearbyStationModelImpl) then) =
      __$$NearbyStationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String cnpj,
      @JsonKey(name: 'distance_km') double distanceKm,
      @JsonKey(name: 'is_partner') bool isPartner,
      double latitude,
      double longitude,
      NearbyStationAddressModel address,
      @JsonKey(name: 'fuel_prices') List<FuelPriceItemModel> fuelPrices,
      @JsonKey(name: 'accepts_autonomous') bool acceptsAutonomous,
      @JsonKey(name: 'accepts_fleet_without_partnership')
      bool acceptsFleetWithoutPartnership});

  @override
  $NearbyStationAddressModelCopyWith<$Res> get address;
}

/// @nodoc
class __$$NearbyStationModelImplCopyWithImpl<$Res>
    extends _$NearbyStationModelCopyWithImpl<$Res, _$NearbyStationModelImpl>
    implements _$$NearbyStationModelImplCopyWith<$Res> {
  __$$NearbyStationModelImplCopyWithImpl(_$NearbyStationModelImpl _value,
      $Res Function(_$NearbyStationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cnpj = null,
    Object? distanceKm = null,
    Object? isPartner = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? fuelPrices = null,
    Object? acceptsAutonomous = null,
    Object? acceptsFleetWithoutPartnership = null,
  }) {
    return _then(_$NearbyStationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cnpj: null == cnpj
          ? _value.cnpj
          : cnpj // ignore: cast_nullable_to_non_nullable
              as String,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      isPartner: null == isPartner
          ? _value.isPartner
          : isPartner // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as NearbyStationAddressModel,
      fuelPrices: null == fuelPrices
          ? _value._fuelPrices
          : fuelPrices // ignore: cast_nullable_to_non_nullable
              as List<FuelPriceItemModel>,
      acceptsAutonomous: null == acceptsAutonomous
          ? _value.acceptsAutonomous
          : acceptsAutonomous // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsFleetWithoutPartnership: null == acceptsFleetWithoutPartnership
          ? _value.acceptsFleetWithoutPartnership
          : acceptsFleetWithoutPartnership // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyStationModelImpl extends _NearbyStationModel {
  const _$NearbyStationModelImpl(
      {required this.id,
      required this.name,
      required this.cnpj,
      @JsonKey(name: 'distance_km') required this.distanceKm,
      @JsonKey(name: 'is_partner') this.isPartner = false,
      required this.latitude,
      required this.longitude,
      required this.address,
      @JsonKey(name: 'fuel_prices')
      final List<FuelPriceItemModel> fuelPrices = const [],
      @JsonKey(name: 'accepts_autonomous') this.acceptsAutonomous = false,
      @JsonKey(name: 'accepts_fleet_without_partnership')
      this.acceptsFleetWithoutPartnership = false})
      : _fuelPrices = fuelPrices,
        super._();

  factory _$NearbyStationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbyStationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String cnpj;
  @override
  @JsonKey(name: 'distance_km')
  final double distanceKm;
  @override
  @JsonKey(name: 'is_partner')
  final bool isPartner;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final NearbyStationAddressModel address;
  final List<FuelPriceItemModel> _fuelPrices;
  @override
  @JsonKey(name: 'fuel_prices')
  List<FuelPriceItemModel> get fuelPrices {
    if (_fuelPrices is EqualUnmodifiableListView) return _fuelPrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fuelPrices);
  }

  @override
  @JsonKey(name: 'accepts_autonomous')
  final bool acceptsAutonomous;
  @override
  @JsonKey(name: 'accepts_fleet_without_partnership')
  final bool acceptsFleetWithoutPartnership;

  @override
  String toString() {
    return 'NearbyStationModel(id: $id, name: $name, cnpj: $cnpj, distanceKm: $distanceKm, isPartner: $isPartner, latitude: $latitude, longitude: $longitude, address: $address, fuelPrices: $fuelPrices, acceptsAutonomous: $acceptsAutonomous, acceptsFleetWithoutPartnership: $acceptsFleetWithoutPartnership)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyStationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cnpj, cnpj) || other.cnpj == cnpj) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.isPartner, isPartner) ||
                other.isPartner == isPartner) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality()
                .equals(other._fuelPrices, _fuelPrices) &&
            (identical(other.acceptsAutonomous, acceptsAutonomous) ||
                other.acceptsAutonomous == acceptsAutonomous) &&
            (identical(other.acceptsFleetWithoutPartnership,
                    acceptsFleetWithoutPartnership) ||
                other.acceptsFleetWithoutPartnership ==
                    acceptsFleetWithoutPartnership));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      cnpj,
      distanceKm,
      isPartner,
      latitude,
      longitude,
      address,
      const DeepCollectionEquality().hash(_fuelPrices),
      acceptsAutonomous,
      acceptsFleetWithoutPartnership);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyStationModelImplCopyWith<_$NearbyStationModelImpl> get copyWith =>
      __$$NearbyStationModelImplCopyWithImpl<_$NearbyStationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyStationModelImplToJson(
      this,
    );
  }
}

abstract class _NearbyStationModel extends NearbyStationModel {
  const factory _NearbyStationModel(
      {required final String id,
      required final String name,
      required final String cnpj,
      @JsonKey(name: 'distance_km') required final double distanceKm,
      @JsonKey(name: 'is_partner') final bool isPartner,
      required final double latitude,
      required final double longitude,
      required final NearbyStationAddressModel address,
      @JsonKey(name: 'fuel_prices') final List<FuelPriceItemModel> fuelPrices,
      @JsonKey(name: 'accepts_autonomous') final bool acceptsAutonomous,
      @JsonKey(name: 'accepts_fleet_without_partnership')
      final bool acceptsFleetWithoutPartnership}) = _$NearbyStationModelImpl;
  const _NearbyStationModel._() : super._();

  factory _NearbyStationModel.fromJson(Map<String, dynamic> json) =
      _$NearbyStationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get cnpj;
  @override
  @JsonKey(name: 'distance_km')
  double get distanceKm;
  @override
  @JsonKey(name: 'is_partner')
  bool get isPartner;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  NearbyStationAddressModel get address;
  @override
  @JsonKey(name: 'fuel_prices')
  List<FuelPriceItemModel> get fuelPrices;
  @override
  @JsonKey(name: 'accepts_autonomous')
  bool get acceptsAutonomous;
  @override
  @JsonKey(name: 'accepts_fleet_without_partnership')
  bool get acceptsFleetWithoutPartnership;
  @override
  @JsonKey(ignore: true)
  _$$NearbyStationModelImplCopyWith<_$NearbyStationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NearbyStationAddressModel _$NearbyStationAddressModelFromJson(
    Map<String, dynamic> json) {
  return _NearbyStationAddressModel.fromJson(json);
}

/// @nodoc
mixin _$NearbyStationAddressModel {
  String get street => throw _privateConstructorUsedError;
  String? get number => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NearbyStationAddressModelCopyWith<NearbyStationAddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyStationAddressModelCopyWith<$Res> {
  factory $NearbyStationAddressModelCopyWith(NearbyStationAddressModel value,
          $Res Function(NearbyStationAddressModel) then) =
      _$NearbyStationAddressModelCopyWithImpl<$Res, NearbyStationAddressModel>;
  @useResult
  $Res call({String street, String? number, String city, String state});
}

/// @nodoc
class _$NearbyStationAddressModelCopyWithImpl<$Res,
        $Val extends NearbyStationAddressModel>
    implements $NearbyStationAddressModelCopyWith<$Res> {
  _$NearbyStationAddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = null,
    Object? number = freezed,
    Object? city = null,
    Object? state = null,
  }) {
    return _then(_value.copyWith(
      street: null == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NearbyStationAddressModelImplCopyWith<$Res>
    implements $NearbyStationAddressModelCopyWith<$Res> {
  factory _$$NearbyStationAddressModelImplCopyWith(
          _$NearbyStationAddressModelImpl value,
          $Res Function(_$NearbyStationAddressModelImpl) then) =
      __$$NearbyStationAddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String street, String? number, String city, String state});
}

/// @nodoc
class __$$NearbyStationAddressModelImplCopyWithImpl<$Res>
    extends _$NearbyStationAddressModelCopyWithImpl<$Res,
        _$NearbyStationAddressModelImpl>
    implements _$$NearbyStationAddressModelImplCopyWith<$Res> {
  __$$NearbyStationAddressModelImplCopyWithImpl(
      _$NearbyStationAddressModelImpl _value,
      $Res Function(_$NearbyStationAddressModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = null,
    Object? number = freezed,
    Object? city = null,
    Object? state = null,
  }) {
    return _then(_$NearbyStationAddressModelImpl(
      street: null == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyStationAddressModelImpl implements _NearbyStationAddressModel {
  const _$NearbyStationAddressModelImpl(
      {required this.street,
      this.number,
      required this.city,
      required this.state});

  factory _$NearbyStationAddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbyStationAddressModelImplFromJson(json);

  @override
  final String street;
  @override
  final String? number;
  @override
  final String city;
  @override
  final String state;

  @override
  String toString() {
    return 'NearbyStationAddressModel(street: $street, number: $number, city: $city, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyStationAddressModelImpl &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, street, number, city, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyStationAddressModelImplCopyWith<_$NearbyStationAddressModelImpl>
      get copyWith => __$$NearbyStationAddressModelImplCopyWithImpl<
          _$NearbyStationAddressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyStationAddressModelImplToJson(
      this,
    );
  }
}

abstract class _NearbyStationAddressModel implements NearbyStationAddressModel {
  const factory _NearbyStationAddressModel(
      {required final String street,
      final String? number,
      required final String city,
      required final String state}) = _$NearbyStationAddressModelImpl;

  factory _NearbyStationAddressModel.fromJson(Map<String, dynamic> json) =
      _$NearbyStationAddressModelImpl.fromJson;

  @override
  String get street;
  @override
  String? get number;
  @override
  String get city;
  @override
  String get state;
  @override
  @JsonKey(ignore: true)
  _$$NearbyStationAddressModelImplCopyWith<_$NearbyStationAddressModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FuelPriceItemModel _$FuelPriceItemModelFromJson(Map<String, dynamic> json) {
  return _FuelPriceItemModel.fromJson(json);
}

/// @nodoc
mixin _$FuelPriceItemModel {
  @JsonKey(name: 'fuel_type_id')
  String? get fuelTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_type')
  String get fuelType => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_type_code')
  String? get fuelTypeCode => throw _privateConstructorUsedError;
  String get price => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FuelPriceItemModelCopyWith<FuelPriceItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelPriceItemModelCopyWith<$Res> {
  factory $FuelPriceItemModelCopyWith(
          FuelPriceItemModel value, $Res Function(FuelPriceItemModel) then) =
      _$FuelPriceItemModelCopyWithImpl<$Res, FuelPriceItemModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'fuel_type_id') String? fuelTypeId,
      @JsonKey(name: 'fuel_type') String fuelType,
      @JsonKey(name: 'fuel_type_code') String? fuelTypeCode,
      String price});
}

/// @nodoc
class _$FuelPriceItemModelCopyWithImpl<$Res, $Val extends FuelPriceItemModel>
    implements $FuelPriceItemModelCopyWith<$Res> {
  _$FuelPriceItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fuelTypeId = freezed,
    Object? fuelType = null,
    Object? fuelTypeCode = freezed,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      fuelTypeId: freezed == fuelTypeId
          ? _value.fuelTypeId
          : fuelTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      fuelTypeCode: freezed == fuelTypeCode
          ? _value.fuelTypeCode
          : fuelTypeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FuelPriceItemModelImplCopyWith<$Res>
    implements $FuelPriceItemModelCopyWith<$Res> {
  factory _$$FuelPriceItemModelImplCopyWith(_$FuelPriceItemModelImpl value,
          $Res Function(_$FuelPriceItemModelImpl) then) =
      __$$FuelPriceItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'fuel_type_id') String? fuelTypeId,
      @JsonKey(name: 'fuel_type') String fuelType,
      @JsonKey(name: 'fuel_type_code') String? fuelTypeCode,
      String price});
}

/// @nodoc
class __$$FuelPriceItemModelImplCopyWithImpl<$Res>
    extends _$FuelPriceItemModelCopyWithImpl<$Res, _$FuelPriceItemModelImpl>
    implements _$$FuelPriceItemModelImplCopyWith<$Res> {
  __$$FuelPriceItemModelImplCopyWithImpl(_$FuelPriceItemModelImpl _value,
      $Res Function(_$FuelPriceItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fuelTypeId = freezed,
    Object? fuelType = null,
    Object? fuelTypeCode = freezed,
    Object? price = null,
  }) {
    return _then(_$FuelPriceItemModelImpl(
      fuelTypeId: freezed == fuelTypeId
          ? _value.fuelTypeId
          : fuelTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      fuelTypeCode: freezed == fuelTypeCode
          ? _value.fuelTypeCode
          : fuelTypeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FuelPriceItemModelImpl implements _FuelPriceItemModel {
  const _$FuelPriceItemModelImpl(
      {@JsonKey(name: 'fuel_type_id') this.fuelTypeId,
      @JsonKey(name: 'fuel_type') required this.fuelType,
      @JsonKey(name: 'fuel_type_code') this.fuelTypeCode,
      required this.price});

  factory _$FuelPriceItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelPriceItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'fuel_type_id')
  final String? fuelTypeId;
  @override
  @JsonKey(name: 'fuel_type')
  final String fuelType;
  @override
  @JsonKey(name: 'fuel_type_code')
  final String? fuelTypeCode;
  @override
  final String price;

  @override
  String toString() {
    return 'FuelPriceItemModel(fuelTypeId: $fuelTypeId, fuelType: $fuelType, fuelTypeCode: $fuelTypeCode, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelPriceItemModelImpl &&
            (identical(other.fuelTypeId, fuelTypeId) ||
                other.fuelTypeId == fuelTypeId) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.fuelTypeCode, fuelTypeCode) ||
                other.fuelTypeCode == fuelTypeCode) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fuelTypeId, fuelType, fuelTypeCode, price);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelPriceItemModelImplCopyWith<_$FuelPriceItemModelImpl> get copyWith =>
      __$$FuelPriceItemModelImplCopyWithImpl<_$FuelPriceItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelPriceItemModelImplToJson(
      this,
    );
  }
}

abstract class _FuelPriceItemModel implements FuelPriceItemModel {
  const factory _FuelPriceItemModel(
      {@JsonKey(name: 'fuel_type_id') final String? fuelTypeId,
      @JsonKey(name: 'fuel_type') required final String fuelType,
      @JsonKey(name: 'fuel_type_code') final String? fuelTypeCode,
      required final String price}) = _$FuelPriceItemModelImpl;

  factory _FuelPriceItemModel.fromJson(Map<String, dynamic> json) =
      _$FuelPriceItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'fuel_type_id')
  String? get fuelTypeId;
  @override
  @JsonKey(name: 'fuel_type')
  String get fuelType;
  @override
  @JsonKey(name: 'fuel_type_code')
  String? get fuelTypeCode;
  @override
  String get price;
  @override
  @JsonKey(ignore: true)
  _$$FuelPriceItemModelImplCopyWith<_$FuelPriceItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NearbyStationsResponseModel _$NearbyStationsResponseModelFromJson(
    Map<String, dynamic> json) {
  return _NearbyStationsResponseModel.fromJson(json);
}

/// @nodoc
mixin _$NearbyStationsResponseModel {
  bool get success => throw _privateConstructorUsedError;
  List<NearbyStationModel> get data => throw _privateConstructorUsedError;
  NearbyStationsMetaModel get meta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NearbyStationsResponseModelCopyWith<NearbyStationsResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyStationsResponseModelCopyWith<$Res> {
  factory $NearbyStationsResponseModelCopyWith(
          NearbyStationsResponseModel value,
          $Res Function(NearbyStationsResponseModel) then) =
      _$NearbyStationsResponseModelCopyWithImpl<$Res,
          NearbyStationsResponseModel>;
  @useResult
  $Res call(
      {bool success,
      List<NearbyStationModel> data,
      NearbyStationsMetaModel meta});

  $NearbyStationsMetaModelCopyWith<$Res> get meta;
}

/// @nodoc
class _$NearbyStationsResponseModelCopyWithImpl<$Res,
        $Val extends NearbyStationsResponseModel>
    implements $NearbyStationsResponseModelCopyWith<$Res> {
  _$NearbyStationsResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? meta = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<NearbyStationModel>,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as NearbyStationsMetaModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NearbyStationsMetaModelCopyWith<$Res> get meta {
    return $NearbyStationsMetaModelCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NearbyStationsResponseModelImplCopyWith<$Res>
    implements $NearbyStationsResponseModelCopyWith<$Res> {
  factory _$$NearbyStationsResponseModelImplCopyWith(
          _$NearbyStationsResponseModelImpl value,
          $Res Function(_$NearbyStationsResponseModelImpl) then) =
      __$$NearbyStationsResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      List<NearbyStationModel> data,
      NearbyStationsMetaModel meta});

  @override
  $NearbyStationsMetaModelCopyWith<$Res> get meta;
}

/// @nodoc
class __$$NearbyStationsResponseModelImplCopyWithImpl<$Res>
    extends _$NearbyStationsResponseModelCopyWithImpl<$Res,
        _$NearbyStationsResponseModelImpl>
    implements _$$NearbyStationsResponseModelImplCopyWith<$Res> {
  __$$NearbyStationsResponseModelImplCopyWithImpl(
      _$NearbyStationsResponseModelImpl _value,
      $Res Function(_$NearbyStationsResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? meta = null,
  }) {
    return _then(_$NearbyStationsResponseModelImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<NearbyStationModel>,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as NearbyStationsMetaModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyStationsResponseModelImpl
    implements _NearbyStationsResponseModel {
  const _$NearbyStationsResponseModelImpl(
      {required this.success,
      required final List<NearbyStationModel> data,
      required this.meta})
      : _data = data;

  factory _$NearbyStationsResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NearbyStationsResponseModelImplFromJson(json);

  @override
  final bool success;
  final List<NearbyStationModel> _data;
  @override
  List<NearbyStationModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final NearbyStationsMetaModel meta;

  @override
  String toString() {
    return 'NearbyStationsResponseModel(success: $success, data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyStationsResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, success, const DeepCollectionEquality().hash(_data), meta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyStationsResponseModelImplCopyWith<_$NearbyStationsResponseModelImpl>
      get copyWith => __$$NearbyStationsResponseModelImplCopyWithImpl<
          _$NearbyStationsResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyStationsResponseModelImplToJson(
      this,
    );
  }
}

abstract class _NearbyStationsResponseModel
    implements NearbyStationsResponseModel {
  const factory _NearbyStationsResponseModel(
          {required final bool success,
          required final List<NearbyStationModel> data,
          required final NearbyStationsMetaModel meta}) =
      _$NearbyStationsResponseModelImpl;

  factory _NearbyStationsResponseModel.fromJson(Map<String, dynamic> json) =
      _$NearbyStationsResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  List<NearbyStationModel> get data;
  @override
  NearbyStationsMetaModel get meta;
  @override
  @JsonKey(ignore: true)
  _$$NearbyStationsResponseModelImplCopyWith<_$NearbyStationsResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NearbyStationsMetaModel _$NearbyStationsMetaModelFromJson(
    Map<String, dynamic> json) {
  return _NearbyStationsMetaModel.fromJson(json);
}

/// @nodoc
mixin _$NearbyStationsMetaModel {
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'radius_km')
  int get radiusKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_location')
  UserLocationModel get userLocation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NearbyStationsMetaModelCopyWith<NearbyStationsMetaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyStationsMetaModelCopyWith<$Res> {
  factory $NearbyStationsMetaModelCopyWith(NearbyStationsMetaModel value,
          $Res Function(NearbyStationsMetaModel) then) =
      _$NearbyStationsMetaModelCopyWithImpl<$Res, NearbyStationsMetaModel>;
  @useResult
  $Res call(
      {int total,
      @JsonKey(name: 'radius_km') int radiusKm,
      @JsonKey(name: 'user_location') UserLocationModel userLocation});

  $UserLocationModelCopyWith<$Res> get userLocation;
}

/// @nodoc
class _$NearbyStationsMetaModelCopyWithImpl<$Res,
        $Val extends NearbyStationsMetaModel>
    implements $NearbyStationsMetaModelCopyWith<$Res> {
  _$NearbyStationsMetaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? radiusKm = null,
    Object? userLocation = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      radiusKm: null == radiusKm
          ? _value.radiusKm
          : radiusKm // ignore: cast_nullable_to_non_nullable
              as int,
      userLocation: null == userLocation
          ? _value.userLocation
          : userLocation // ignore: cast_nullable_to_non_nullable
              as UserLocationModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserLocationModelCopyWith<$Res> get userLocation {
    return $UserLocationModelCopyWith<$Res>(_value.userLocation, (value) {
      return _then(_value.copyWith(userLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NearbyStationsMetaModelImplCopyWith<$Res>
    implements $NearbyStationsMetaModelCopyWith<$Res> {
  factory _$$NearbyStationsMetaModelImplCopyWith(
          _$NearbyStationsMetaModelImpl value,
          $Res Function(_$NearbyStationsMetaModelImpl) then) =
      __$$NearbyStationsMetaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int total,
      @JsonKey(name: 'radius_km') int radiusKm,
      @JsonKey(name: 'user_location') UserLocationModel userLocation});

  @override
  $UserLocationModelCopyWith<$Res> get userLocation;
}

/// @nodoc
class __$$NearbyStationsMetaModelImplCopyWithImpl<$Res>
    extends _$NearbyStationsMetaModelCopyWithImpl<$Res,
        _$NearbyStationsMetaModelImpl>
    implements _$$NearbyStationsMetaModelImplCopyWith<$Res> {
  __$$NearbyStationsMetaModelImplCopyWithImpl(
      _$NearbyStationsMetaModelImpl _value,
      $Res Function(_$NearbyStationsMetaModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? radiusKm = null,
    Object? userLocation = null,
  }) {
    return _then(_$NearbyStationsMetaModelImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      radiusKm: null == radiusKm
          ? _value.radiusKm
          : radiusKm // ignore: cast_nullable_to_non_nullable
              as int,
      userLocation: null == userLocation
          ? _value.userLocation
          : userLocation // ignore: cast_nullable_to_non_nullable
              as UserLocationModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyStationsMetaModelImpl implements _NearbyStationsMetaModel {
  const _$NearbyStationsMetaModelImpl(
      {required this.total,
      @JsonKey(name: 'radius_km') required this.radiusKm,
      @JsonKey(name: 'user_location') required this.userLocation});

  factory _$NearbyStationsMetaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbyStationsMetaModelImplFromJson(json);

  @override
  final int total;
  @override
  @JsonKey(name: 'radius_km')
  final int radiusKm;
  @override
  @JsonKey(name: 'user_location')
  final UserLocationModel userLocation;

  @override
  String toString() {
    return 'NearbyStationsMetaModel(total: $total, radiusKm: $radiusKm, userLocation: $userLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyStationsMetaModelImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.radiusKm, radiusKm) ||
                other.radiusKm == radiusKm) &&
            (identical(other.userLocation, userLocation) ||
                other.userLocation == userLocation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, total, radiusKm, userLocation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyStationsMetaModelImplCopyWith<_$NearbyStationsMetaModelImpl>
      get copyWith => __$$NearbyStationsMetaModelImplCopyWithImpl<
          _$NearbyStationsMetaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyStationsMetaModelImplToJson(
      this,
    );
  }
}

abstract class _NearbyStationsMetaModel implements NearbyStationsMetaModel {
  const factory _NearbyStationsMetaModel(
          {required final int total,
          @JsonKey(name: 'radius_km') required final int radiusKm,
          @JsonKey(name: 'user_location')
          required final UserLocationModel userLocation}) =
      _$NearbyStationsMetaModelImpl;

  factory _NearbyStationsMetaModel.fromJson(Map<String, dynamic> json) =
      _$NearbyStationsMetaModelImpl.fromJson;

  @override
  int get total;
  @override
  @JsonKey(name: 'radius_km')
  int get radiusKm;
  @override
  @JsonKey(name: 'user_location')
  UserLocationModel get userLocation;
  @override
  @JsonKey(ignore: true)
  _$$NearbyStationsMetaModelImplCopyWith<_$NearbyStationsMetaModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserLocationModel _$UserLocationModelFromJson(Map<String, dynamic> json) {
  return _UserLocationModel.fromJson(json);
}

/// @nodoc
mixin _$UserLocationModel {
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserLocationModelCopyWith<UserLocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLocationModelCopyWith<$Res> {
  factory $UserLocationModelCopyWith(
          UserLocationModel value, $Res Function(UserLocationModel) then) =
      _$UserLocationModelCopyWithImpl<$Res, UserLocationModel>;
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class _$UserLocationModelCopyWithImpl<$Res, $Val extends UserLocationModel>
    implements $UserLocationModelCopyWith<$Res> {
  _$UserLocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_value.copyWith(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserLocationModelImplCopyWith<$Res>
    implements $UserLocationModelCopyWith<$Res> {
  factory _$$UserLocationModelImplCopyWith(_$UserLocationModelImpl value,
          $Res Function(_$UserLocationModelImpl) then) =
      __$$UserLocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class __$$UserLocationModelImplCopyWithImpl<$Res>
    extends _$UserLocationModelCopyWithImpl<$Res, _$UserLocationModelImpl>
    implements _$$UserLocationModelImplCopyWith<$Res> {
  __$$UserLocationModelImplCopyWithImpl(_$UserLocationModelImpl _value,
      $Res Function(_$UserLocationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_$UserLocationModelImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserLocationModelImpl implements _UserLocationModel {
  const _$UserLocationModelImpl({required this.lat, required this.lng});

  factory _$UserLocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserLocationModelImplFromJson(json);

  @override
  final double lat;
  @override
  final double lng;

  @override
  String toString() {
    return 'UserLocationModel(lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserLocationModelImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserLocationModelImplCopyWith<_$UserLocationModelImpl> get copyWith =>
      __$$UserLocationModelImplCopyWithImpl<_$UserLocationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserLocationModelImplToJson(
      this,
    );
  }
}

abstract class _UserLocationModel implements UserLocationModel {
  const factory _UserLocationModel(
      {required final double lat,
      required final double lng}) = _$UserLocationModelImpl;

  factory _UserLocationModel.fromJson(Map<String, dynamic> json) =
      _$UserLocationModelImpl.fromJson;

  @override
  double get lat;
  @override
  double get lng;
  @override
  @JsonKey(ignore: true)
  _$$UserLocationModelImplCopyWith<_$UserLocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
