// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) {
  return _CompanyModel.fromJson(json);
}

/// @nodoc
mixin _$CompanyModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get cnpj => throw _privateConstructorUsedError;
  String? get fantasyName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  CompanyAddressModel? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'settings')
  CompanySettingsModel? get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanyModelCopyWith<CompanyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyModelCopyWith<$Res> {
  factory $CompanyModelCopyWith(
          CompanyModel value, $Res Function(CompanyModel) then) =
      _$CompanyModelCopyWithImpl<$Res, CompanyModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String cnpj,
      String? fantasyName,
      String? email,
      String? phone,
      CompanyAddressModel? address,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'settings') CompanySettingsModel? settings});

  $CompanyAddressModelCopyWith<$Res>? get address;
  $CompanySettingsModelCopyWith<$Res>? get settings;
}

/// @nodoc
class _$CompanyModelCopyWithImpl<$Res, $Val extends CompanyModel>
    implements $CompanyModelCopyWith<$Res> {
  _$CompanyModelCopyWithImpl(this._value, this._then);

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
    Object? fantasyName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isActive = null,
    Object? settings = freezed,
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
      fantasyName: freezed == fantasyName
          ? _value.fantasyName
          : fantasyName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as CompanyAddressModel?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as CompanySettingsModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CompanyAddressModelCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $CompanyAddressModelCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CompanySettingsModelCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $CompanySettingsModelCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompanyModelImplCopyWith<$Res>
    implements $CompanyModelCopyWith<$Res> {
  factory _$$CompanyModelImplCopyWith(
          _$CompanyModelImpl value, $Res Function(_$CompanyModelImpl) then) =
      __$$CompanyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String cnpj,
      String? fantasyName,
      String? email,
      String? phone,
      CompanyAddressModel? address,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'settings') CompanySettingsModel? settings});

  @override
  $CompanyAddressModelCopyWith<$Res>? get address;
  @override
  $CompanySettingsModelCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$CompanyModelImplCopyWithImpl<$Res>
    extends _$CompanyModelCopyWithImpl<$Res, _$CompanyModelImpl>
    implements _$$CompanyModelImplCopyWith<$Res> {
  __$$CompanyModelImplCopyWithImpl(
      _$CompanyModelImpl _value, $Res Function(_$CompanyModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cnpj = null,
    Object? fantasyName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isActive = null,
    Object? settings = freezed,
  }) {
    return _then(_$CompanyModelImpl(
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
      fantasyName: freezed == fantasyName
          ? _value.fantasyName
          : fantasyName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as CompanyAddressModel?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as CompanySettingsModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyModelImpl implements _CompanyModel {
  const _$CompanyModelImpl(
      {required this.id,
      required this.name,
      required this.cnpj,
      this.fantasyName,
      this.email,
      this.phone,
      this.address,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'settings') this.settings});

  factory _$CompanyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String cnpj;
  @override
  final String? fantasyName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final CompanyAddressModel? address;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'settings')
  final CompanySettingsModel? settings;

  @override
  String toString() {
    return 'CompanyModel(id: $id, name: $name, cnpj: $cnpj, fantasyName: $fantasyName, email: $email, phone: $phone, address: $address, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cnpj, cnpj) || other.cnpj == cnpj) &&
            (identical(other.fantasyName, fantasyName) ||
                other.fantasyName == fantasyName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, cnpj, fantasyName,
      email, phone, address, createdAt, updatedAt, isActive, settings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      __$$CompanyModelImplCopyWithImpl<_$CompanyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyModelImplToJson(
      this,
    );
  }
}

abstract class _CompanyModel implements CompanyModel {
  const factory _CompanyModel(
          {required final String id,
          required final String name,
          required final String cnpj,
          final String? fantasyName,
          final String? email,
          final String? phone,
          final CompanyAddressModel? address,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'settings') final CompanySettingsModel? settings}) =
      _$CompanyModelImpl;

  factory _CompanyModel.fromJson(Map<String, dynamic> json) =
      _$CompanyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get cnpj;
  @override
  String? get fantasyName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  CompanyAddressModel? get address;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'settings')
  CompanySettingsModel? get settings;
  @override
  @JsonKey(ignore: true)
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyAddressModel _$CompanyAddressModelFromJson(Map<String, dynamic> json) {
  return _CompanyAddressModel.fromJson(json);
}

/// @nodoc
mixin _$CompanyAddressModel {
  String get street => throw _privateConstructorUsedError;
  String get number => throw _privateConstructorUsedError;
  String? get complement => throw _privateConstructorUsedError;
  String get neighborhood => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get zipCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanyAddressModelCopyWith<CompanyAddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyAddressModelCopyWith<$Res> {
  factory $CompanyAddressModelCopyWith(
          CompanyAddressModel value, $Res Function(CompanyAddressModel) then) =
      _$CompanyAddressModelCopyWithImpl<$Res, CompanyAddressModel>;
  @useResult
  $Res call(
      {String street,
      String number,
      String? complement,
      String neighborhood,
      String city,
      String state,
      String zipCode,
      String? country});
}

/// @nodoc
class _$CompanyAddressModelCopyWithImpl<$Res, $Val extends CompanyAddressModel>
    implements $CompanyAddressModelCopyWith<$Res> {
  _$CompanyAddressModelCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyAddressModelImplCopyWith<$Res>
    implements $CompanyAddressModelCopyWith<$Res> {
  factory _$$CompanyAddressModelImplCopyWith(_$CompanyAddressModelImpl value,
          $Res Function(_$CompanyAddressModelImpl) then) =
      __$$CompanyAddressModelImplCopyWithImpl<$Res>;
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
      String? country});
}

/// @nodoc
class __$$CompanyAddressModelImplCopyWithImpl<$Res>
    extends _$CompanyAddressModelCopyWithImpl<$Res, _$CompanyAddressModelImpl>
    implements _$$CompanyAddressModelImplCopyWith<$Res> {
  __$$CompanyAddressModelImplCopyWithImpl(_$CompanyAddressModelImpl _value,
      $Res Function(_$CompanyAddressModelImpl) _then)
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
  }) {
    return _then(_$CompanyAddressModelImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyAddressModelImpl implements _CompanyAddressModel {
  const _$CompanyAddressModelImpl(
      {required this.street,
      required this.number,
      this.complement,
      required this.neighborhood,
      required this.city,
      required this.state,
      required this.zipCode,
      this.country});

  factory _$CompanyAddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyAddressModelImplFromJson(json);

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
  String toString() {
    return 'CompanyAddressModel(street: $street, number: $number, complement: $complement, neighborhood: $neighborhood, city: $city, state: $state, zipCode: $zipCode, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyAddressModelImpl &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.complement, complement) ||
                other.complement == complement) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, street, number, complement,
      neighborhood, city, state, zipCode, country);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyAddressModelImplCopyWith<_$CompanyAddressModelImpl> get copyWith =>
      __$$CompanyAddressModelImplCopyWithImpl<_$CompanyAddressModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyAddressModelImplToJson(
      this,
    );
  }
}

abstract class _CompanyAddressModel implements CompanyAddressModel {
  const factory _CompanyAddressModel(
      {required final String street,
      required final String number,
      final String? complement,
      required final String neighborhood,
      required final String city,
      required final String state,
      required final String zipCode,
      final String? country}) = _$CompanyAddressModelImpl;

  factory _CompanyAddressModel.fromJson(Map<String, dynamic> json) =
      _$CompanyAddressModelImpl.fromJson;

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
  @JsonKey(ignore: true)
  _$$CompanyAddressModelImplCopyWith<_$CompanyAddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanySettingsModel _$CompanySettingsModelFromJson(Map<String, dynamic> json) {
  return _CompanySettingsModel.fromJson(json);
}

/// @nodoc
mixin _$CompanySettingsModel {
  @JsonKey(name: 'max_vehicles')
  int get maxVehicles => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_users')
  int get maxUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_budget_limit')
  double? get fuelBudgetLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'require_approval')
  bool get requireApproval => throw _privateConstructorUsedError;
  @JsonKey(name: 'allow_external_stations')
  bool get allowExternalStations => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_settings')
  NotificationSettingsModel? get notificationSettings =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanySettingsModelCopyWith<CompanySettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanySettingsModelCopyWith<$Res> {
  factory $CompanySettingsModelCopyWith(CompanySettingsModel value,
          $Res Function(CompanySettingsModel) then) =
      _$CompanySettingsModelCopyWithImpl<$Res, CompanySettingsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'max_vehicles') int maxVehicles,
      @JsonKey(name: 'max_users') int maxUsers,
      @JsonKey(name: 'fuel_budget_limit') double? fuelBudgetLimit,
      @JsonKey(name: 'require_approval') bool requireApproval,
      @JsonKey(name: 'allow_external_stations') bool allowExternalStations,
      @JsonKey(name: 'notification_settings')
      NotificationSettingsModel? notificationSettings});

  $NotificationSettingsModelCopyWith<$Res>? get notificationSettings;
}

/// @nodoc
class _$CompanySettingsModelCopyWithImpl<$Res,
        $Val extends CompanySettingsModel>
    implements $CompanySettingsModelCopyWith<$Res> {
  _$CompanySettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxVehicles = null,
    Object? maxUsers = null,
    Object? fuelBudgetLimit = freezed,
    Object? requireApproval = null,
    Object? allowExternalStations = null,
    Object? notificationSettings = freezed,
  }) {
    return _then(_value.copyWith(
      maxVehicles: null == maxVehicles
          ? _value.maxVehicles
          : maxVehicles // ignore: cast_nullable_to_non_nullable
              as int,
      maxUsers: null == maxUsers
          ? _value.maxUsers
          : maxUsers // ignore: cast_nullable_to_non_nullable
              as int,
      fuelBudgetLimit: freezed == fuelBudgetLimit
          ? _value.fuelBudgetLimit
          : fuelBudgetLimit // ignore: cast_nullable_to_non_nullable
              as double?,
      requireApproval: null == requireApproval
          ? _value.requireApproval
          : requireApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      allowExternalStations: null == allowExternalStations
          ? _value.allowExternalStations
          : allowExternalStations // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationSettings: freezed == notificationSettings
          ? _value.notificationSettings
          : notificationSettings // ignore: cast_nullable_to_non_nullable
              as NotificationSettingsModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationSettingsModelCopyWith<$Res>? get notificationSettings {
    if (_value.notificationSettings == null) {
      return null;
    }

    return $NotificationSettingsModelCopyWith<$Res>(
        _value.notificationSettings!, (value) {
      return _then(_value.copyWith(notificationSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompanySettingsModelImplCopyWith<$Res>
    implements $CompanySettingsModelCopyWith<$Res> {
  factory _$$CompanySettingsModelImplCopyWith(_$CompanySettingsModelImpl value,
          $Res Function(_$CompanySettingsModelImpl) then) =
      __$$CompanySettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'max_vehicles') int maxVehicles,
      @JsonKey(name: 'max_users') int maxUsers,
      @JsonKey(name: 'fuel_budget_limit') double? fuelBudgetLimit,
      @JsonKey(name: 'require_approval') bool requireApproval,
      @JsonKey(name: 'allow_external_stations') bool allowExternalStations,
      @JsonKey(name: 'notification_settings')
      NotificationSettingsModel? notificationSettings});

  @override
  $NotificationSettingsModelCopyWith<$Res>? get notificationSettings;
}

/// @nodoc
class __$$CompanySettingsModelImplCopyWithImpl<$Res>
    extends _$CompanySettingsModelCopyWithImpl<$Res, _$CompanySettingsModelImpl>
    implements _$$CompanySettingsModelImplCopyWith<$Res> {
  __$$CompanySettingsModelImplCopyWithImpl(_$CompanySettingsModelImpl _value,
      $Res Function(_$CompanySettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxVehicles = null,
    Object? maxUsers = null,
    Object? fuelBudgetLimit = freezed,
    Object? requireApproval = null,
    Object? allowExternalStations = null,
    Object? notificationSettings = freezed,
  }) {
    return _then(_$CompanySettingsModelImpl(
      maxVehicles: null == maxVehicles
          ? _value.maxVehicles
          : maxVehicles // ignore: cast_nullable_to_non_nullable
              as int,
      maxUsers: null == maxUsers
          ? _value.maxUsers
          : maxUsers // ignore: cast_nullable_to_non_nullable
              as int,
      fuelBudgetLimit: freezed == fuelBudgetLimit
          ? _value.fuelBudgetLimit
          : fuelBudgetLimit // ignore: cast_nullable_to_non_nullable
              as double?,
      requireApproval: null == requireApproval
          ? _value.requireApproval
          : requireApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      allowExternalStations: null == allowExternalStations
          ? _value.allowExternalStations
          : allowExternalStations // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationSettings: freezed == notificationSettings
          ? _value.notificationSettings
          : notificationSettings // ignore: cast_nullable_to_non_nullable
              as NotificationSettingsModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanySettingsModelImpl implements _CompanySettingsModel {
  const _$CompanySettingsModelImpl(
      {@JsonKey(name: 'max_vehicles') this.maxVehicles = 100,
      @JsonKey(name: 'max_users') this.maxUsers = 50,
      @JsonKey(name: 'fuel_budget_limit') this.fuelBudgetLimit,
      @JsonKey(name: 'require_approval') this.requireApproval = false,
      @JsonKey(name: 'allow_external_stations')
      this.allowExternalStations = true,
      @JsonKey(name: 'notification_settings') this.notificationSettings});

  factory _$CompanySettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanySettingsModelImplFromJson(json);

  @override
  @JsonKey(name: 'max_vehicles')
  final int maxVehicles;
  @override
  @JsonKey(name: 'max_users')
  final int maxUsers;
  @override
  @JsonKey(name: 'fuel_budget_limit')
  final double? fuelBudgetLimit;
  @override
  @JsonKey(name: 'require_approval')
  final bool requireApproval;
  @override
  @JsonKey(name: 'allow_external_stations')
  final bool allowExternalStations;
  @override
  @JsonKey(name: 'notification_settings')
  final NotificationSettingsModel? notificationSettings;

  @override
  String toString() {
    return 'CompanySettingsModel(maxVehicles: $maxVehicles, maxUsers: $maxUsers, fuelBudgetLimit: $fuelBudgetLimit, requireApproval: $requireApproval, allowExternalStations: $allowExternalStations, notificationSettings: $notificationSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanySettingsModelImpl &&
            (identical(other.maxVehicles, maxVehicles) ||
                other.maxVehicles == maxVehicles) &&
            (identical(other.maxUsers, maxUsers) ||
                other.maxUsers == maxUsers) &&
            (identical(other.fuelBudgetLimit, fuelBudgetLimit) ||
                other.fuelBudgetLimit == fuelBudgetLimit) &&
            (identical(other.requireApproval, requireApproval) ||
                other.requireApproval == requireApproval) &&
            (identical(other.allowExternalStations, allowExternalStations) ||
                other.allowExternalStations == allowExternalStations) &&
            (identical(other.notificationSettings, notificationSettings) ||
                other.notificationSettings == notificationSettings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      maxVehicles,
      maxUsers,
      fuelBudgetLimit,
      requireApproval,
      allowExternalStations,
      notificationSettings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanySettingsModelImplCopyWith<_$CompanySettingsModelImpl>
      get copyWith =>
          __$$CompanySettingsModelImplCopyWithImpl<_$CompanySettingsModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanySettingsModelImplToJson(
      this,
    );
  }
}

abstract class _CompanySettingsModel implements CompanySettingsModel {
  const factory _CompanySettingsModel(
          {@JsonKey(name: 'max_vehicles') final int maxVehicles,
          @JsonKey(name: 'max_users') final int maxUsers,
          @JsonKey(name: 'fuel_budget_limit') final double? fuelBudgetLimit,
          @JsonKey(name: 'require_approval') final bool requireApproval,
          @JsonKey(name: 'allow_external_stations')
          final bool allowExternalStations,
          @JsonKey(name: 'notification_settings')
          final NotificationSettingsModel? notificationSettings}) =
      _$CompanySettingsModelImpl;

  factory _CompanySettingsModel.fromJson(Map<String, dynamic> json) =
      _$CompanySettingsModelImpl.fromJson;

  @override
  @JsonKey(name: 'max_vehicles')
  int get maxVehicles;
  @override
  @JsonKey(name: 'max_users')
  int get maxUsers;
  @override
  @JsonKey(name: 'fuel_budget_limit')
  double? get fuelBudgetLimit;
  @override
  @JsonKey(name: 'require_approval')
  bool get requireApproval;
  @override
  @JsonKey(name: 'allow_external_stations')
  bool get allowExternalStations;
  @override
  @JsonKey(name: 'notification_settings')
  NotificationSettingsModel? get notificationSettings;
  @override
  @JsonKey(ignore: true)
  _$$CompanySettingsModelImplCopyWith<_$CompanySettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationSettingsModel _$NotificationSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettingsModel {
  @JsonKey(name: 'email_notifications')
  bool get emailNotifications => throw _privateConstructorUsedError;
  @JsonKey(name: 'push_notifications')
  bool get pushNotifications => throw _privateConstructorUsedError;
  @JsonKey(name: 'sms_notifications')
  bool get smsNotifications => throw _privateConstructorUsedError;
  @JsonKey(name: 'refueling_alerts')
  bool get refuelingAlerts => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_alerts')
  bool get budgetAlerts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationSettingsModelCopyWith<NotificationSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsModelCopyWith<$Res> {
  factory $NotificationSettingsModelCopyWith(NotificationSettingsModel value,
          $Res Function(NotificationSettingsModel) then) =
      _$NotificationSettingsModelCopyWithImpl<$Res, NotificationSettingsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'email_notifications') bool emailNotifications,
      @JsonKey(name: 'push_notifications') bool pushNotifications,
      @JsonKey(name: 'sms_notifications') bool smsNotifications,
      @JsonKey(name: 'refueling_alerts') bool refuelingAlerts,
      @JsonKey(name: 'budget_alerts') bool budgetAlerts});
}

/// @nodoc
class _$NotificationSettingsModelCopyWithImpl<$Res,
        $Val extends NotificationSettingsModel>
    implements $NotificationSettingsModelCopyWith<$Res> {
  _$NotificationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? smsNotifications = null,
    Object? refuelingAlerts = null,
    Object? budgetAlerts = null,
  }) {
    return _then(_value.copyWith(
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotifications: null == smsNotifications
          ? _value.smsNotifications
          : smsNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      refuelingAlerts: null == refuelingAlerts
          ? _value.refuelingAlerts
          : refuelingAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      budgetAlerts: null == budgetAlerts
          ? _value.budgetAlerts
          : budgetAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsModelImplCopyWith<$Res>
    implements $NotificationSettingsModelCopyWith<$Res> {
  factory _$$NotificationSettingsModelImplCopyWith(
          _$NotificationSettingsModelImpl value,
          $Res Function(_$NotificationSettingsModelImpl) then) =
      __$$NotificationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'email_notifications') bool emailNotifications,
      @JsonKey(name: 'push_notifications') bool pushNotifications,
      @JsonKey(name: 'sms_notifications') bool smsNotifications,
      @JsonKey(name: 'refueling_alerts') bool refuelingAlerts,
      @JsonKey(name: 'budget_alerts') bool budgetAlerts});
}

/// @nodoc
class __$$NotificationSettingsModelImplCopyWithImpl<$Res>
    extends _$NotificationSettingsModelCopyWithImpl<$Res,
        _$NotificationSettingsModelImpl>
    implements _$$NotificationSettingsModelImplCopyWith<$Res> {
  __$$NotificationSettingsModelImplCopyWithImpl(
      _$NotificationSettingsModelImpl _value,
      $Res Function(_$NotificationSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? smsNotifications = null,
    Object? refuelingAlerts = null,
    Object? budgetAlerts = null,
  }) {
    return _then(_$NotificationSettingsModelImpl(
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotifications: null == smsNotifications
          ? _value.smsNotifications
          : smsNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      refuelingAlerts: null == refuelingAlerts
          ? _value.refuelingAlerts
          : refuelingAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      budgetAlerts: null == budgetAlerts
          ? _value.budgetAlerts
          : budgetAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsModelImpl implements _NotificationSettingsModel {
  const _$NotificationSettingsModelImpl(
      {@JsonKey(name: 'email_notifications') this.emailNotifications = true,
      @JsonKey(name: 'push_notifications') this.pushNotifications = true,
      @JsonKey(name: 'sms_notifications') this.smsNotifications = false,
      @JsonKey(name: 'refueling_alerts') this.refuelingAlerts = true,
      @JsonKey(name: 'budget_alerts') this.budgetAlerts = true});

  factory _$NotificationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsModelImplFromJson(json);

  @override
  @JsonKey(name: 'email_notifications')
  final bool emailNotifications;
  @override
  @JsonKey(name: 'push_notifications')
  final bool pushNotifications;
  @override
  @JsonKey(name: 'sms_notifications')
  final bool smsNotifications;
  @override
  @JsonKey(name: 'refueling_alerts')
  final bool refuelingAlerts;
  @override
  @JsonKey(name: 'budget_alerts')
  final bool budgetAlerts;

  @override
  String toString() {
    return 'NotificationSettingsModel(emailNotifications: $emailNotifications, pushNotifications: $pushNotifications, smsNotifications: $smsNotifications, refuelingAlerts: $refuelingAlerts, budgetAlerts: $budgetAlerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsModelImpl &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.pushNotifications, pushNotifications) ||
                other.pushNotifications == pushNotifications) &&
            (identical(other.smsNotifications, smsNotifications) ||
                other.smsNotifications == smsNotifications) &&
            (identical(other.refuelingAlerts, refuelingAlerts) ||
                other.refuelingAlerts == refuelingAlerts) &&
            (identical(other.budgetAlerts, budgetAlerts) ||
                other.budgetAlerts == budgetAlerts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, emailNotifications,
      pushNotifications, smsNotifications, refuelingAlerts, budgetAlerts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
      get copyWith => __$$NotificationSettingsModelImplCopyWithImpl<
          _$NotificationSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettingsModel implements NotificationSettingsModel {
  const factory _NotificationSettingsModel(
          {@JsonKey(name: 'email_notifications') final bool emailNotifications,
          @JsonKey(name: 'push_notifications') final bool pushNotifications,
          @JsonKey(name: 'sms_notifications') final bool smsNotifications,
          @JsonKey(name: 'refueling_alerts') final bool refuelingAlerts,
          @JsonKey(name: 'budget_alerts') final bool budgetAlerts}) =
      _$NotificationSettingsModelImpl;

  factory _NotificationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsModelImpl.fromJson;

  @override
  @JsonKey(name: 'email_notifications')
  bool get emailNotifications;
  @override
  @JsonKey(name: 'push_notifications')
  bool get pushNotifications;
  @override
  @JsonKey(name: 'sms_notifications')
  bool get smsNotifications;
  @override
  @JsonKey(name: 'refueling_alerts')
  bool get refuelingAlerts;
  @override
  @JsonKey(name: 'budget_alerts')
  bool get budgetAlerts;
  @override
  @JsonKey(ignore: true)
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
