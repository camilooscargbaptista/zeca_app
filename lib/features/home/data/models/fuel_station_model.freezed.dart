// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fuel_station_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FuelStationModel _$FuelStationModelFromJson(Map<String, dynamic> json) {
  return _FuelStationModel.fromJson(json);
}

/// @nodoc
mixin _$FuelStationModel {
  String get id => throw _privateConstructorUsedError;
  String get cnpj => throw _privateConstructorUsedError;
  @JsonKey(name: 'corporate_name')
  String get corporateName => throw _privateConstructorUsedError;
  @JsonKey(name: 'fantasy_name')
  String get fantasyName => throw _privateConstructorUsedError;
  FuelStationAddressModel get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_partner')
  bool get isPartner => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'prices')
  Map<String, double> get prices => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_price_update')
  DateTime? get lastPriceUpdate => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_info')
  FuelStationContactModel? get contactInfo =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'services')
  List<String> get services => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_methods')
  List<String> get paymentMethods => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating')
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double? get distanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FuelStationModelCopyWith<FuelStationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelStationModelCopyWith<$Res> {
  factory $FuelStationModelCopyWith(
          FuelStationModel value, $Res Function(FuelStationModel) then) =
      _$FuelStationModelCopyWithImpl<$Res, FuelStationModel>;
  @useResult
  $Res call(
      {String id,
      String cnpj,
      @JsonKey(name: 'corporate_name') String corporateName,
      @JsonKey(name: 'fantasy_name') String fantasyName,
      FuelStationAddressModel address,
      @JsonKey(name: 'is_partner') bool isPartner,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'prices') Map<String, double> prices,
      @JsonKey(name: 'last_price_update') DateTime? lastPriceUpdate,
      @JsonKey(name: 'contact_info') FuelStationContactModel? contactInfo,
      @JsonKey(name: 'services') List<String> services,
      @JsonKey(name: 'payment_methods') List<String> paymentMethods,
      @JsonKey(name: 'rating') double rating,
      @JsonKey(name: 'distance_km') double? distanceKm,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  $FuelStationAddressModelCopyWith<$Res> get address;
  $FuelStationContactModelCopyWith<$Res>? get contactInfo;
}

/// @nodoc
class _$FuelStationModelCopyWithImpl<$Res, $Val extends FuelStationModel>
    implements $FuelStationModelCopyWith<$Res> {
  _$FuelStationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cnpj = null,
    Object? corporateName = null,
    Object? fantasyName = null,
    Object? address = null,
    Object? isPartner = null,
    Object? isActive = null,
    Object? prices = null,
    Object? lastPriceUpdate = freezed,
    Object? contactInfo = freezed,
    Object? services = null,
    Object? paymentMethods = null,
    Object? rating = null,
    Object? distanceKm = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cnpj: null == cnpj
          ? _value.cnpj
          : cnpj // ignore: cast_nullable_to_non_nullable
              as String,
      corporateName: null == corporateName
          ? _value.corporateName
          : corporateName // ignore: cast_nullable_to_non_nullable
              as String,
      fantasyName: null == fantasyName
          ? _value.fantasyName
          : fantasyName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as FuelStationAddressModel,
      isPartner: null == isPartner
          ? _value.isPartner
          : isPartner // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      prices: null == prices
          ? _value.prices
          : prices // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      lastPriceUpdate: freezed == lastPriceUpdate
          ? _value.lastPriceUpdate
          : lastPriceUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactInfo: freezed == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as FuelStationContactModel?,
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<String>,
      paymentMethods: null == paymentMethods
          ? _value.paymentMethods
          : paymentMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
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

  @override
  @pragma('vm:prefer-inline')
  $FuelStationAddressModelCopyWith<$Res> get address {
    return $FuelStationAddressModelCopyWith<$Res>(_value.address, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FuelStationContactModelCopyWith<$Res>? get contactInfo {
    if (_value.contactInfo == null) {
      return null;
    }

    return $FuelStationContactModelCopyWith<$Res>(_value.contactInfo!, (value) {
      return _then(_value.copyWith(contactInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FuelStationModelImplCopyWith<$Res>
    implements $FuelStationModelCopyWith<$Res> {
  factory _$$FuelStationModelImplCopyWith(_$FuelStationModelImpl value,
          $Res Function(_$FuelStationModelImpl) then) =
      __$$FuelStationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String cnpj,
      @JsonKey(name: 'corporate_name') String corporateName,
      @JsonKey(name: 'fantasy_name') String fantasyName,
      FuelStationAddressModel address,
      @JsonKey(name: 'is_partner') bool isPartner,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'prices') Map<String, double> prices,
      @JsonKey(name: 'last_price_update') DateTime? lastPriceUpdate,
      @JsonKey(name: 'contact_info') FuelStationContactModel? contactInfo,
      @JsonKey(name: 'services') List<String> services,
      @JsonKey(name: 'payment_methods') List<String> paymentMethods,
      @JsonKey(name: 'rating') double rating,
      @JsonKey(name: 'distance_km') double? distanceKm,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  @override
  $FuelStationAddressModelCopyWith<$Res> get address;
  @override
  $FuelStationContactModelCopyWith<$Res>? get contactInfo;
}

/// @nodoc
class __$$FuelStationModelImplCopyWithImpl<$Res>
    extends _$FuelStationModelCopyWithImpl<$Res, _$FuelStationModelImpl>
    implements _$$FuelStationModelImplCopyWith<$Res> {
  __$$FuelStationModelImplCopyWithImpl(_$FuelStationModelImpl _value,
      $Res Function(_$FuelStationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cnpj = null,
    Object? corporateName = null,
    Object? fantasyName = null,
    Object? address = null,
    Object? isPartner = null,
    Object? isActive = null,
    Object? prices = null,
    Object? lastPriceUpdate = freezed,
    Object? contactInfo = freezed,
    Object? services = null,
    Object? paymentMethods = null,
    Object? rating = null,
    Object? distanceKm = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FuelStationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cnpj: null == cnpj
          ? _value.cnpj
          : cnpj // ignore: cast_nullable_to_non_nullable
              as String,
      corporateName: null == corporateName
          ? _value.corporateName
          : corporateName // ignore: cast_nullable_to_non_nullable
              as String,
      fantasyName: null == fantasyName
          ? _value.fantasyName
          : fantasyName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as FuelStationAddressModel,
      isPartner: null == isPartner
          ? _value.isPartner
          : isPartner // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      prices: null == prices
          ? _value._prices
          : prices // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      lastPriceUpdate: freezed == lastPriceUpdate
          ? _value.lastPriceUpdate
          : lastPriceUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactInfo: freezed == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as FuelStationContactModel?,
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<String>,
      paymentMethods: null == paymentMethods
          ? _value._paymentMethods
          : paymentMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
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
class _$FuelStationModelImpl extends _FuelStationModel {
  const _$FuelStationModelImpl(
      {required this.id,
      required this.cnpj,
      @JsonKey(name: 'corporate_name') required this.corporateName,
      @JsonKey(name: 'fantasy_name') required this.fantasyName,
      required this.address,
      @JsonKey(name: 'is_partner') this.isPartner = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'prices') final Map<String, double> prices = const {},
      @JsonKey(name: 'last_price_update') this.lastPriceUpdate,
      @JsonKey(name: 'contact_info') this.contactInfo,
      @JsonKey(name: 'services') final List<String> services = const [],
      @JsonKey(name: 'payment_methods')
      final List<String> paymentMethods = const [],
      @JsonKey(name: 'rating') this.rating = 0.0,
      @JsonKey(name: 'distance_km') this.distanceKm,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _prices = prices,
        _services = services,
        _paymentMethods = paymentMethods,
        super._();

  factory _$FuelStationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelStationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String cnpj;
  @override
  @JsonKey(name: 'corporate_name')
  final String corporateName;
  @override
  @JsonKey(name: 'fantasy_name')
  final String fantasyName;
  @override
  final FuelStationAddressModel address;
  @override
  @JsonKey(name: 'is_partner')
  final bool isPartner;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final Map<String, double> _prices;
  @override
  @JsonKey(name: 'prices')
  Map<String, double> get prices {
    if (_prices is EqualUnmodifiableMapView) return _prices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_prices);
  }

  @override
  @JsonKey(name: 'last_price_update')
  final DateTime? lastPriceUpdate;
  @override
  @JsonKey(name: 'contact_info')
  final FuelStationContactModel? contactInfo;
  final List<String> _services;
  @override
  @JsonKey(name: 'services')
  List<String> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  final List<String> _paymentMethods;
  @override
  @JsonKey(name: 'payment_methods')
  List<String> get paymentMethods {
    if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentMethods);
  }

  @override
  @JsonKey(name: 'rating')
  final double rating;
  @override
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FuelStationModel(id: $id, cnpj: $cnpj, corporateName: $corporateName, fantasyName: $fantasyName, address: $address, isPartner: $isPartner, isActive: $isActive, prices: $prices, lastPriceUpdate: $lastPriceUpdate, contactInfo: $contactInfo, services: $services, paymentMethods: $paymentMethods, rating: $rating, distanceKm: $distanceKm, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelStationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cnpj, cnpj) || other.cnpj == cnpj) &&
            (identical(other.corporateName, corporateName) ||
                other.corporateName == corporateName) &&
            (identical(other.fantasyName, fantasyName) ||
                other.fantasyName == fantasyName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isPartner, isPartner) ||
                other.isPartner == isPartner) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._prices, _prices) &&
            (identical(other.lastPriceUpdate, lastPriceUpdate) ||
                other.lastPriceUpdate == lastPriceUpdate) &&
            (identical(other.contactInfo, contactInfo) ||
                other.contactInfo == contactInfo) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            const DeepCollectionEquality()
                .equals(other._paymentMethods, _paymentMethods) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
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
      cnpj,
      corporateName,
      fantasyName,
      address,
      isPartner,
      isActive,
      const DeepCollectionEquality().hash(_prices),
      lastPriceUpdate,
      contactInfo,
      const DeepCollectionEquality().hash(_services),
      const DeepCollectionEquality().hash(_paymentMethods),
      rating,
      distanceKm,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelStationModelImplCopyWith<_$FuelStationModelImpl> get copyWith =>
      __$$FuelStationModelImplCopyWithImpl<_$FuelStationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelStationModelImplToJson(
      this,
    );
  }
}

abstract class _FuelStationModel extends FuelStationModel {
  const factory _FuelStationModel(
      {required final String id,
      required final String cnpj,
      @JsonKey(name: 'corporate_name') required final String corporateName,
      @JsonKey(name: 'fantasy_name') required final String fantasyName,
      required final FuelStationAddressModel address,
      @JsonKey(name: 'is_partner') final bool isPartner,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'prices') final Map<String, double> prices,
      @JsonKey(name: 'last_price_update') final DateTime? lastPriceUpdate,
      @JsonKey(name: 'contact_info') final FuelStationContactModel? contactInfo,
      @JsonKey(name: 'services') final List<String> services,
      @JsonKey(name: 'payment_methods') final List<String> paymentMethods,
      @JsonKey(name: 'rating') final double rating,
      @JsonKey(name: 'distance_km') final double? distanceKm,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$FuelStationModelImpl;
  const _FuelStationModel._() : super._();

  factory _FuelStationModel.fromJson(Map<String, dynamic> json) =
      _$FuelStationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get cnpj;
  @override
  @JsonKey(name: 'corporate_name')
  String get corporateName;
  @override
  @JsonKey(name: 'fantasy_name')
  String get fantasyName;
  @override
  FuelStationAddressModel get address;
  @override
  @JsonKey(name: 'is_partner')
  bool get isPartner;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'prices')
  Map<String, double> get prices;
  @override
  @JsonKey(name: 'last_price_update')
  DateTime? get lastPriceUpdate;
  @override
  @JsonKey(name: 'contact_info')
  FuelStationContactModel? get contactInfo;
  @override
  @JsonKey(name: 'services')
  List<String> get services;
  @override
  @JsonKey(name: 'payment_methods')
  List<String> get paymentMethods;
  @override
  @JsonKey(name: 'rating')
  double get rating;
  @override
  @JsonKey(name: 'distance_km')
  double? get distanceKm;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FuelStationModelImplCopyWith<_$FuelStationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FuelStationAddressModel _$FuelStationAddressModelFromJson(
    Map<String, dynamic> json) {
  return _FuelStationAddressModel.fromJson(json);
}

/// @nodoc
mixin _$FuelStationAddressModel {
  String get street => throw _privateConstructorUsedError;
  String get number => throw _privateConstructorUsedError;
  String? get complement => throw _privateConstructorUsedError;
  String get neighborhood => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get zipCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'latitude')
  double? get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'longitude')
  double? get longitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FuelStationAddressModelCopyWith<FuelStationAddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelStationAddressModelCopyWith<$Res> {
  factory $FuelStationAddressModelCopyWith(FuelStationAddressModel value,
          $Res Function(FuelStationAddressModel) then) =
      _$FuelStationAddressModelCopyWithImpl<$Res, FuelStationAddressModel>;
  @useResult
  $Res call(
      {String street,
      String number,
      String? complement,
      String neighborhood,
      String city,
      String state,
      String zipCode,
      String? country,
      @JsonKey(name: 'latitude') double? latitude,
      @JsonKey(name: 'longitude') double? longitude});
}

/// @nodoc
class _$FuelStationAddressModelCopyWithImpl<$Res,
        $Val extends FuelStationAddressModel>
    implements $FuelStationAddressModelCopyWith<$Res> {
  _$FuelStationAddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = null,
    Object? number = null,
    Object? complement = freezed,
    Object? neighborhood = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_value.copyWith(
      street: null == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      complement: freezed == complement
          ? _value.complement
          : complement // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: null == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FuelStationAddressModelImplCopyWith<$Res>
    implements $FuelStationAddressModelCopyWith<$Res> {
  factory _$$FuelStationAddressModelImplCopyWith(
          _$FuelStationAddressModelImpl value,
          $Res Function(_$FuelStationAddressModelImpl) then) =
      __$$FuelStationAddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String street,
      String number,
      String? complement,
      String neighborhood,
      String city,
      String state,
      String zipCode,
      String? country,
      @JsonKey(name: 'latitude') double? latitude,
      @JsonKey(name: 'longitude') double? longitude});
}

/// @nodoc
class __$$FuelStationAddressModelImplCopyWithImpl<$Res>
    extends _$FuelStationAddressModelCopyWithImpl<$Res,
        _$FuelStationAddressModelImpl>
    implements _$$FuelStationAddressModelImplCopyWith<$Res> {
  __$$FuelStationAddressModelImplCopyWithImpl(
      _$FuelStationAddressModelImpl _value,
      $Res Function(_$FuelStationAddressModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = null,
    Object? number = null,
    Object? complement = freezed,
    Object? neighborhood = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_$FuelStationAddressModelImpl(
      street: null == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      complement: freezed == complement
          ? _value.complement
          : complement // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: null == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FuelStationAddressModelImpl extends _FuelStationAddressModel {
  const _$FuelStationAddressModelImpl(
      {required this.street,
      required this.number,
      this.complement,
      required this.neighborhood,
      required this.city,
      required this.state,
      required this.zipCode,
      this.country,
      @JsonKey(name: 'latitude') this.latitude,
      @JsonKey(name: 'longitude') this.longitude})
      : super._();

  factory _$FuelStationAddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelStationAddressModelImplFromJson(json);

  @override
  final String street;
  @override
  final String number;
  @override
  final String? complement;
  @override
  final String neighborhood;
  @override
  final String city;
  @override
  final String state;
  @override
  final String zipCode;
  @override
  final String? country;
  @override
  @JsonKey(name: 'latitude')
  final double? latitude;
  @override
  @JsonKey(name: 'longitude')
  final double? longitude;

  @override
  String toString() {
    return 'FuelStationAddressModel(street: $street, number: $number, complement: $complement, neighborhood: $neighborhood, city: $city, state: $state, zipCode: $zipCode, country: $country, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelStationAddressModelImpl &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.complement, complement) ||
                other.complement == complement) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, street, number, complement,
      neighborhood, city, state, zipCode, country, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelStationAddressModelImplCopyWith<_$FuelStationAddressModelImpl>
      get copyWith => __$$FuelStationAddressModelImplCopyWithImpl<
          _$FuelStationAddressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelStationAddressModelImplToJson(
      this,
    );
  }
}

abstract class _FuelStationAddressModel extends FuelStationAddressModel {
  const factory _FuelStationAddressModel(
          {required final String street,
          required final String number,
          final String? complement,
          required final String neighborhood,
          required final String city,
          required final String state,
          required final String zipCode,
          final String? country,
          @JsonKey(name: 'latitude') final double? latitude,
          @JsonKey(name: 'longitude') final double? longitude}) =
      _$FuelStationAddressModelImpl;
  const _FuelStationAddressModel._() : super._();

  factory _FuelStationAddressModel.fromJson(Map<String, dynamic> json) =
      _$FuelStationAddressModelImpl.fromJson;

  @override
  String get street;
  @override
  String get number;
  @override
  String? get complement;
  @override
  String get neighborhood;
  @override
  String get city;
  @override
  String get state;
  @override
  String get zipCode;
  @override
  String? get country;
  @override
  @JsonKey(name: 'latitude')
  double? get latitude;
  @override
  @JsonKey(name: 'longitude')
  double? get longitude;
  @override
  @JsonKey(ignore: true)
  _$$FuelStationAddressModelImplCopyWith<_$FuelStationAddressModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FuelStationContactModel _$FuelStationContactModelFromJson(
    Map<String, dynamic> json) {
  return _FuelStationContactModel.fromJson(json);
}

/// @nodoc
mixin _$FuelStationContactModel {
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_name')
  String? get managerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_phone')
  String? get managerPhone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FuelStationContactModelCopyWith<FuelStationContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelStationContactModelCopyWith<$Res> {
  factory $FuelStationContactModelCopyWith(FuelStationContactModel value,
          $Res Function(FuelStationContactModel) then) =
      _$FuelStationContactModelCopyWithImpl<$Res, FuelStationContactModel>;
  @useResult
  $Res call(
      {String? phone,
      String? email,
      String? website,
      @JsonKey(name: 'manager_name') String? managerName,
      @JsonKey(name: 'manager_phone') String? managerPhone});
}

/// @nodoc
class _$FuelStationContactModelCopyWithImpl<$Res,
        $Val extends FuelStationContactModel>
    implements $FuelStationContactModelCopyWith<$Res> {
  _$FuelStationContactModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? managerName = freezed,
    Object? managerPhone = freezed,
  }) {
    return _then(_value.copyWith(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      managerPhone: freezed == managerPhone
          ? _value.managerPhone
          : managerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FuelStationContactModelImplCopyWith<$Res>
    implements $FuelStationContactModelCopyWith<$Res> {
  factory _$$FuelStationContactModelImplCopyWith(
          _$FuelStationContactModelImpl value,
          $Res Function(_$FuelStationContactModelImpl) then) =
      __$$FuelStationContactModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? phone,
      String? email,
      String? website,
      @JsonKey(name: 'manager_name') String? managerName,
      @JsonKey(name: 'manager_phone') String? managerPhone});
}

/// @nodoc
class __$$FuelStationContactModelImplCopyWithImpl<$Res>
    extends _$FuelStationContactModelCopyWithImpl<$Res,
        _$FuelStationContactModelImpl>
    implements _$$FuelStationContactModelImplCopyWith<$Res> {
  __$$FuelStationContactModelImplCopyWithImpl(
      _$FuelStationContactModelImpl _value,
      $Res Function(_$FuelStationContactModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? managerName = freezed,
    Object? managerPhone = freezed,
  }) {
    return _then(_$FuelStationContactModelImpl(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      managerPhone: freezed == managerPhone
          ? _value.managerPhone
          : managerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FuelStationContactModelImpl extends _FuelStationContactModel {
  const _$FuelStationContactModelImpl(
      {this.phone,
      this.email,
      this.website,
      @JsonKey(name: 'manager_name') this.managerName,
      @JsonKey(name: 'manager_phone') this.managerPhone})
      : super._();

  factory _$FuelStationContactModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelStationContactModelImplFromJson(json);

  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? website;
  @override
  @JsonKey(name: 'manager_name')
  final String? managerName;
  @override
  @JsonKey(name: 'manager_phone')
  final String? managerPhone;

  @override
  String toString() {
    return 'FuelStationContactModel(phone: $phone, email: $email, website: $website, managerName: $managerName, managerPhone: $managerPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelStationContactModelImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName) &&
            (identical(other.managerPhone, managerPhone) ||
                other.managerPhone == managerPhone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, phone, email, website, managerName, managerPhone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelStationContactModelImplCopyWith<_$FuelStationContactModelImpl>
      get copyWith => __$$FuelStationContactModelImplCopyWithImpl<
          _$FuelStationContactModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelStationContactModelImplToJson(
      this,
    );
  }
}

abstract class _FuelStationContactModel extends FuelStationContactModel {
  const factory _FuelStationContactModel(
          {final String? phone,
          final String? email,
          final String? website,
          @JsonKey(name: 'manager_name') final String? managerName,
          @JsonKey(name: 'manager_phone') final String? managerPhone}) =
      _$FuelStationContactModelImpl;
  const _FuelStationContactModel._() : super._();

  factory _FuelStationContactModel.fromJson(Map<String, dynamic> json) =
      _$FuelStationContactModelImpl.fromJson;

  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get website;
  @override
  @JsonKey(name: 'manager_name')
  String? get managerName;
  @override
  @JsonKey(name: 'manager_phone')
  String? get managerPhone;
  @override
  @JsonKey(ignore: true)
  _$$FuelStationContactModelImplCopyWith<_$FuelStationContactModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
