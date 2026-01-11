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
  String get neighborhood => throw _privateConstructorUsedError;
  String get zipCode => throw _privateConstructorUsedError;

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
  $Res call(
      {String street,
      String? number,
      String city,
      String state,
      String neighborhood,
      String zipCode});
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
    Object? neighborhood = null,
    Object? zipCode = null,
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
      neighborhood: null == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
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
  $Res call(
      {String street,
      String? number,
      String city,
      String state,
      String neighborhood,
      String zipCode});
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
    Object? neighborhood = null,
    Object? zipCode = null,
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
      neighborhood: null == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
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
      required this.state,
      this.neighborhood = '',
      this.zipCode = ''});

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
  @JsonKey()
  final String neighborhood;
  @override
  @JsonKey()
  final String zipCode;

  @override
  String toString() {
    return 'NearbyStationAddressModel(street: $street, number: $number, city: $city, state: $state, neighborhood: $neighborhood, zipCode: $zipCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyStationAddressModelImpl &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, street, number, city, state, neighborhood, zipCode);

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
      required final String state,
      final String neighborhood,
      final String zipCode}) = _$NearbyStationAddressModelImpl;

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
  String get neighborhood;
  @override
  String get zipCode;
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
  @JsonKey(name: 'fuel_type')
  String get fuelType => throw _privateConstructorUsedError;
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
  $Res call({@JsonKey(name: 'fuel_type') String fuelType, String price});
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
    Object? fuelType = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call({@JsonKey(name: 'fuel_type') String fuelType, String price});
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
    Object? fuelType = null,
    Object? price = null,
  }) {
    return _then(_$FuelPriceItemModelImpl(
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
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
      {@JsonKey(name: 'fuel_type') required this.fuelType,
      required this.price});

  factory _$FuelPriceItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelPriceItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'fuel_type')
  final String fuelType;
  @override
  final String price;

  @override
  String toString() {
    return 'FuelPriceItemModel(fuelType: $fuelType, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelPriceItemModelImpl &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fuelType, price);

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
      {@JsonKey(name: 'fuel_type') required final String fuelType,
      required final String price}) = _$FuelPriceItemModelImpl;

  factory _FuelPriceItemModel.fromJson(Map<String, dynamic> json) =
      _$FuelPriceItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'fuel_type')
  String get fuelType;
  @override
  String get price;
  @override
  @JsonKey(ignore: true)
  _$$FuelPriceItemModelImplCopyWith<_$FuelPriceItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
