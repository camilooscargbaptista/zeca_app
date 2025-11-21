// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get cpf => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_cnpj')
  String? get companyCnpj => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  @JsonKey(name: 'roles')
  List<String> get roles => throw _privateConstructorUsedError;
  @JsonKey(name: 'permissions')
  List<String> get permissions => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verified')
  bool get emailVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_verified')
  bool get phoneVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile')
  UserProfileModel? get profile => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferences')
  UserPreferencesModel? get preferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String cpf,
      String? email,
      String? phone,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'company_cnpj') String? companyCnpj,
      @JsonKey(name: 'last_login') DateTime? lastLogin,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'permissions') List<String> permissions,
      @JsonKey(name: 'email_verified') bool emailVerified,
      @JsonKey(name: 'phone_verified') bool phoneVerified,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'profile') UserProfileModel? profile,
      @JsonKey(name: 'preferences') UserPreferencesModel? preferences,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  $UserProfileModelCopyWith<$Res>? get profile;
  $UserPreferencesModelCopyWith<$Res>? get preferences;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cpf = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? companyId = null,
    Object? companyName = null,
    Object? companyCnpj = freezed,
    Object? lastLogin = freezed,
    Object? roles = null,
    Object? permissions = null,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? isActive = null,
    Object? profile = freezed,
    Object? preferences = freezed,
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
      cpf: null == cpf
          ? _value.cpf
          : cpf // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      companyCnpj: freezed == companyCnpj
          ? _value.companyCnpj
          : companyCnpj // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfileModel?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UserPreferencesModel?,
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
  $UserProfileModelCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesModelCopyWith<$Res>? get preferences {
    if (_value.preferences == null) {
      return null;
    }

    return $UserPreferencesModelCopyWith<$Res>(_value.preferences!, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String cpf,
      String? email,
      String? phone,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'company_cnpj') String? companyCnpj,
      @JsonKey(name: 'last_login') DateTime? lastLogin,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'permissions') List<String> permissions,
      @JsonKey(name: 'email_verified') bool emailVerified,
      @JsonKey(name: 'phone_verified') bool phoneVerified,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'profile') UserProfileModel? profile,
      @JsonKey(name: 'preferences') UserPreferencesModel? preferences,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  @override
  $UserProfileModelCopyWith<$Res>? get profile;
  @override
  $UserPreferencesModelCopyWith<$Res>? get preferences;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cpf = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? companyId = null,
    Object? companyName = null,
    Object? companyCnpj = freezed,
    Object? lastLogin = freezed,
    Object? roles = null,
    Object? permissions = null,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? isActive = null,
    Object? profile = freezed,
    Object? preferences = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cpf: null == cpf
          ? _value.cpf
          : cpf // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      companyCnpj: freezed == companyCnpj
          ? _value.companyCnpj
          : companyCnpj // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfileModel?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UserPreferencesModel?,
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
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.name,
      required this.cpf,
      this.email,
      this.phone,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'company_name') required this.companyName,
      @JsonKey(name: 'company_cnpj') this.companyCnpj,
      @JsonKey(name: 'last_login') this.lastLogin,
      @JsonKey(name: 'roles') final List<String> roles = const [],
      @JsonKey(name: 'permissions') final List<String> permissions = const [],
      @JsonKey(name: 'email_verified') this.emailVerified = false,
      @JsonKey(name: 'phone_verified') this.phoneVerified = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'profile') this.profile,
      @JsonKey(name: 'preferences') this.preferences,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _roles = roles,
        _permissions = permissions,
        super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String cpf;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  @JsonKey(name: 'company_cnpj')
  final String? companyCnpj;
  @override
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  final List<String> _roles;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  final List<String> _permissions;
  @override
  @JsonKey(name: 'permissions')
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @override
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'profile')
  final UserProfileModel? profile;
  @override
  @JsonKey(name: 'preferences')
  final UserPreferencesModel? preferences;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, cpf: $cpf, email: $email, phone: $phone, companyId: $companyId, companyName: $companyName, companyCnpj: $companyCnpj, lastLogin: $lastLogin, roles: $roles, permissions: $permissions, emailVerified: $emailVerified, phoneVerified: $phoneVerified, isActive: $isActive, profile: $profile, preferences: $preferences, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cpf, cpf) || other.cpf == cpf) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyCnpj, companyCnpj) ||
                other.companyCnpj == companyCnpj) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences) &&
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
      cpf,
      email,
      phone,
      companyId,
      companyName,
      companyCnpj,
      lastLogin,
      const DeepCollectionEquality().hash(_roles),
      const DeepCollectionEquality().hash(_permissions),
      emailVerified,
      phoneVerified,
      isActive,
      profile,
      preferences,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
          {required final String id,
          required final String name,
          required final String cpf,
          final String? email,
          final String? phone,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'company_name') required final String companyName,
          @JsonKey(name: 'company_cnpj') final String? companyCnpj,
          @JsonKey(name: 'last_login') final DateTime? lastLogin,
          @JsonKey(name: 'roles') final List<String> roles,
          @JsonKey(name: 'permissions') final List<String> permissions,
          @JsonKey(name: 'email_verified') final bool emailVerified,
          @JsonKey(name: 'phone_verified') final bool phoneVerified,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'profile') final UserProfileModel? profile,
          @JsonKey(name: 'preferences') final UserPreferencesModel? preferences,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get cpf;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  @JsonKey(name: 'company_cnpj')
  String? get companyCnpj;
  @override
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles;
  @override
  @JsonKey(name: 'permissions')
  List<String> get permissions;
  @override
  @JsonKey(name: 'email_verified')
  bool get emailVerified;
  @override
  @JsonKey(name: 'phone_verified')
  bool get phoneVerified;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'profile')
  UserProfileModel? get profile;
  @override
  @JsonKey(name: 'preferences')
  UserPreferencesModel? get preferences;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'gender')
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'address')
  UserAddressModel? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'emergency_contact')
  EmergencyContactModel? get emergencyContact =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
          UserProfileModel value, $Res Function(UserProfileModel) then) =
      _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      @JsonKey(name: 'gender') String? gender,
      @JsonKey(name: 'address') UserAddressModel? address,
      @JsonKey(name: 'emergency_contact')
      EmergencyContactModel? emergencyContact});

  $UserAddressModelCopyWith<$Res>? get address;
  $EmergencyContactModelCopyWith<$Res>? get emergencyContact;
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? avatarUrl = freezed,
    Object? birthDate = freezed,
    Object? gender = freezed,
    Object? address = freezed,
    Object? emergencyContact = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as UserAddressModel?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as EmergencyContactModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserAddressModelCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $UserAddressModelCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EmergencyContactModelCopyWith<$Res>? get emergencyContact {
    if (_value.emergencyContact == null) {
      return null;
    }

    return $EmergencyContactModelCopyWith<$Res>(_value.emergencyContact!,
        (value) {
      return _then(_value.copyWith(emergencyContact: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(_$UserProfileModelImpl value,
          $Res Function(_$UserProfileModelImpl) then) =
      __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      @JsonKey(name: 'gender') String? gender,
      @JsonKey(name: 'address') UserAddressModel? address,
      @JsonKey(name: 'emergency_contact')
      EmergencyContactModel? emergencyContact});

  @override
  $UserAddressModelCopyWith<$Res>? get address;
  @override
  $EmergencyContactModelCopyWith<$Res>? get emergencyContact;
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(_$UserProfileModelImpl _value,
      $Res Function(_$UserProfileModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? avatarUrl = freezed,
    Object? birthDate = freezed,
    Object? gender = freezed,
    Object? address = freezed,
    Object? emergencyContact = freezed,
  }) {
    return _then(_$UserProfileModelImpl(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as UserAddressModel?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as EmergencyContactModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl(
      {@JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'birth_date') this.birthDate,
      @JsonKey(name: 'gender') this.gender,
      @JsonKey(name: 'address') this.address,
      @JsonKey(name: 'emergency_contact') this.emergencyContact});

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  @JsonKey(name: 'gender')
  final String? gender;
  @override
  @JsonKey(name: 'address')
  final UserAddressModel? address;
  @override
  @JsonKey(name: 'emergency_contact')
  final EmergencyContactModel? emergencyContact;

  @override
  String toString() {
    return 'UserProfileModel(firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, birthDate: $birthDate, gender: $gender, address: $address, emergencyContact: $emergencyContact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.emergencyContact, emergencyContact) ||
                other.emergencyContact == emergencyContact));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, avatarUrl,
      birthDate, gender, address, emergencyContact);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(
      this,
    );
  }
}

abstract class _UserProfileModel implements UserProfileModel {
  const factory _UserProfileModel(
      {@JsonKey(name: 'first_name') final String? firstName,
      @JsonKey(name: 'last_name') final String? lastName,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'birth_date') final DateTime? birthDate,
      @JsonKey(name: 'gender') final String? gender,
      @JsonKey(name: 'address') final UserAddressModel? address,
      @JsonKey(name: 'emergency_contact')
      final EmergencyContactModel? emergencyContact}) = _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  @JsonKey(name: 'gender')
  String? get gender;
  @override
  @JsonKey(name: 'address')
  UserAddressModel? get address;
  @override
  @JsonKey(name: 'emergency_contact')
  EmergencyContactModel? get emergencyContact;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserAddressModel _$UserAddressModelFromJson(Map<String, dynamic> json) {
  return _UserAddressModel.fromJson(json);
}

/// @nodoc
mixin _$UserAddressModel {
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
  $UserAddressModelCopyWith<UserAddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAddressModelCopyWith<$Res> {
  factory $UserAddressModelCopyWith(
          UserAddressModel value, $Res Function(UserAddressModel) then) =
      _$UserAddressModelCopyWithImpl<$Res, UserAddressModel>;
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
class _$UserAddressModelCopyWithImpl<$Res, $Val extends UserAddressModel>
    implements $UserAddressModelCopyWith<$Res> {
  _$UserAddressModelCopyWithImpl(this._value, this._then);

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
abstract class _$$UserAddressModelImplCopyWith<$Res>
    implements $UserAddressModelCopyWith<$Res> {
  factory _$$UserAddressModelImplCopyWith(_$UserAddressModelImpl value,
          $Res Function(_$UserAddressModelImpl) then) =
      __$$UserAddressModelImplCopyWithImpl<$Res>;
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
class __$$UserAddressModelImplCopyWithImpl<$Res>
    extends _$UserAddressModelCopyWithImpl<$Res, _$UserAddressModelImpl>
    implements _$$UserAddressModelImplCopyWith<$Res> {
  __$$UserAddressModelImplCopyWithImpl(_$UserAddressModelImpl _value,
      $Res Function(_$UserAddressModelImpl) _then)
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
    return _then(_$UserAddressModelImpl(
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
class _$UserAddressModelImpl implements _UserAddressModel {
  const _$UserAddressModelImpl(
      {required this.street,
      required this.number,
      this.complement,
      required this.neighborhood,
      required this.city,
      required this.state,
      required this.zipCode,
      this.country});

  factory _$UserAddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAddressModelImplFromJson(json);

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
    return 'UserAddressModel(street: $street, number: $number, complement: $complement, neighborhood: $neighborhood, city: $city, state: $state, zipCode: $zipCode, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAddressModelImpl &&
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
  _$$UserAddressModelImplCopyWith<_$UserAddressModelImpl> get copyWith =>
      __$$UserAddressModelImplCopyWithImpl<_$UserAddressModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAddressModelImplToJson(
      this,
    );
  }
}

abstract class _UserAddressModel implements UserAddressModel {
  const factory _UserAddressModel(
      {required final String street,
      required final String number,
      final String? complement,
      required final String neighborhood,
      required final String city,
      required final String state,
      required final String zipCode,
      final String? country}) = _$UserAddressModelImpl;

  factory _UserAddressModel.fromJson(Map<String, dynamic> json) =
      _$UserAddressModelImpl.fromJson;

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
  _$$UserAddressModelImplCopyWith<_$UserAddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmergencyContactModel _$EmergencyContactModelFromJson(
    Map<String, dynamic> json) {
  return _EmergencyContactModel.fromJson(json);
}

/// @nodoc
mixin _$EmergencyContactModel {
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get relationship => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmergencyContactModelCopyWith<EmergencyContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyContactModelCopyWith<$Res> {
  factory $EmergencyContactModelCopyWith(EmergencyContactModel value,
          $Res Function(EmergencyContactModel) then) =
      _$EmergencyContactModelCopyWithImpl<$Res, EmergencyContactModel>;
  @useResult
  $Res call({String name, String phone, String? relationship});
}

/// @nodoc
class _$EmergencyContactModelCopyWithImpl<$Res,
        $Val extends EmergencyContactModel>
    implements $EmergencyContactModelCopyWith<$Res> {
  _$EmergencyContactModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? phone = null,
    Object? relationship = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmergencyContactModelImplCopyWith<$Res>
    implements $EmergencyContactModelCopyWith<$Res> {
  factory _$$EmergencyContactModelImplCopyWith(
          _$EmergencyContactModelImpl value,
          $Res Function(_$EmergencyContactModelImpl) then) =
      __$$EmergencyContactModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String phone, String? relationship});
}

/// @nodoc
class __$$EmergencyContactModelImplCopyWithImpl<$Res>
    extends _$EmergencyContactModelCopyWithImpl<$Res,
        _$EmergencyContactModelImpl>
    implements _$$EmergencyContactModelImplCopyWith<$Res> {
  __$$EmergencyContactModelImplCopyWithImpl(_$EmergencyContactModelImpl _value,
      $Res Function(_$EmergencyContactModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? phone = null,
    Object? relationship = freezed,
  }) {
    return _then(_$EmergencyContactModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmergencyContactModelImpl implements _EmergencyContactModel {
  const _$EmergencyContactModelImpl(
      {required this.name, required this.phone, this.relationship});

  factory _$EmergencyContactModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmergencyContactModelImplFromJson(json);

  @override
  final String name;
  @override
  final String phone;
  @override
  final String? relationship;

  @override
  String toString() {
    return 'EmergencyContactModel(name: $name, phone: $phone, relationship: $relationship)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyContactModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, phone, relationship);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyContactModelImplCopyWith<_$EmergencyContactModelImpl>
      get copyWith => __$$EmergencyContactModelImplCopyWithImpl<
          _$EmergencyContactModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmergencyContactModelImplToJson(
      this,
    );
  }
}

abstract class _EmergencyContactModel implements EmergencyContactModel {
  const factory _EmergencyContactModel(
      {required final String name,
      required final String phone,
      final String? relationship}) = _$EmergencyContactModelImpl;

  factory _EmergencyContactModel.fromJson(Map<String, dynamic> json) =
      _$EmergencyContactModelImpl.fromJson;

  @override
  String get name;
  @override
  String get phone;
  @override
  String? get relationship;
  @override
  @JsonKey(ignore: true)
  _$$EmergencyContactModelImplCopyWith<_$EmergencyContactModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserPreferencesModel _$UserPreferencesModelFromJson(Map<String, dynamic> json) {
  return _UserPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$UserPreferencesModel {
  @JsonKey(name: 'theme')
  String get theme => throw _privateConstructorUsedError;
  @JsonKey(name: 'language')
  String get language => throw _privateConstructorUsedError;
  @JsonKey(name: 'notifications')
  NotificationPreferencesModel? get notifications =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'privacy')
  PrivacyPreferencesModel? get privacy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPreferencesModelCopyWith<UserPreferencesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesModelCopyWith<$Res> {
  factory $UserPreferencesModelCopyWith(UserPreferencesModel value,
          $Res Function(UserPreferencesModel) then) =
      _$UserPreferencesModelCopyWithImpl<$Res, UserPreferencesModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'theme') String theme,
      @JsonKey(name: 'language') String language,
      @JsonKey(name: 'notifications')
      NotificationPreferencesModel? notifications,
      @JsonKey(name: 'privacy') PrivacyPreferencesModel? privacy});

  $NotificationPreferencesModelCopyWith<$Res>? get notifications;
  $PrivacyPreferencesModelCopyWith<$Res>? get privacy;
}

/// @nodoc
class _$UserPreferencesModelCopyWithImpl<$Res,
        $Val extends UserPreferencesModel>
    implements $UserPreferencesModelCopyWith<$Res> {
  _$UserPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? language = null,
    Object? notifications = freezed,
    Object? privacy = freezed,
  }) {
    return _then(_value.copyWith(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      notifications: freezed == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as NotificationPreferencesModel?,
      privacy: freezed == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as PrivacyPreferencesModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationPreferencesModelCopyWith<$Res>? get notifications {
    if (_value.notifications == null) {
      return null;
    }

    return $NotificationPreferencesModelCopyWith<$Res>(_value.notifications!,
        (value) {
      return _then(_value.copyWith(notifications: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PrivacyPreferencesModelCopyWith<$Res>? get privacy {
    if (_value.privacy == null) {
      return null;
    }

    return $PrivacyPreferencesModelCopyWith<$Res>(_value.privacy!, (value) {
      return _then(_value.copyWith(privacy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserPreferencesModelImplCopyWith<$Res>
    implements $UserPreferencesModelCopyWith<$Res> {
  factory _$$UserPreferencesModelImplCopyWith(_$UserPreferencesModelImpl value,
          $Res Function(_$UserPreferencesModelImpl) then) =
      __$$UserPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'theme') String theme,
      @JsonKey(name: 'language') String language,
      @JsonKey(name: 'notifications')
      NotificationPreferencesModel? notifications,
      @JsonKey(name: 'privacy') PrivacyPreferencesModel? privacy});

  @override
  $NotificationPreferencesModelCopyWith<$Res>? get notifications;
  @override
  $PrivacyPreferencesModelCopyWith<$Res>? get privacy;
}

/// @nodoc
class __$$UserPreferencesModelImplCopyWithImpl<$Res>
    extends _$UserPreferencesModelCopyWithImpl<$Res, _$UserPreferencesModelImpl>
    implements _$$UserPreferencesModelImplCopyWith<$Res> {
  __$$UserPreferencesModelImplCopyWithImpl(_$UserPreferencesModelImpl _value,
      $Res Function(_$UserPreferencesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? language = null,
    Object? notifications = freezed,
    Object? privacy = freezed,
  }) {
    return _then(_$UserPreferencesModelImpl(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      notifications: freezed == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as NotificationPreferencesModel?,
      privacy: freezed == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as PrivacyPreferencesModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesModelImpl implements _UserPreferencesModel {
  const _$UserPreferencesModelImpl(
      {@JsonKey(name: 'theme') this.theme = 'light',
      @JsonKey(name: 'language') this.language = 'pt_BR',
      @JsonKey(name: 'notifications') this.notifications,
      @JsonKey(name: 'privacy') this.privacy});

  factory _$UserPreferencesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesModelImplFromJson(json);

  @override
  @JsonKey(name: 'theme')
  final String theme;
  @override
  @JsonKey(name: 'language')
  final String language;
  @override
  @JsonKey(name: 'notifications')
  final NotificationPreferencesModel? notifications;
  @override
  @JsonKey(name: 'privacy')
  final PrivacyPreferencesModel? privacy;

  @override
  String toString() {
    return 'UserPreferencesModel(theme: $theme, language: $language, notifications: $notifications, privacy: $privacy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesModelImpl &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.notifications, notifications) ||
                other.notifications == notifications) &&
            (identical(other.privacy, privacy) || other.privacy == privacy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, theme, language, notifications, privacy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesModelImplCopyWith<_$UserPreferencesModelImpl>
      get copyWith =>
          __$$UserPreferencesModelImplCopyWithImpl<_$UserPreferencesModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _UserPreferencesModel implements UserPreferencesModel {
  const factory _UserPreferencesModel(
          {@JsonKey(name: 'theme') final String theme,
          @JsonKey(name: 'language') final String language,
          @JsonKey(name: 'notifications')
          final NotificationPreferencesModel? notifications,
          @JsonKey(name: 'privacy') final PrivacyPreferencesModel? privacy}) =
      _$UserPreferencesModelImpl;

  factory _UserPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesModelImpl.fromJson;

  @override
  @JsonKey(name: 'theme')
  String get theme;
  @override
  @JsonKey(name: 'language')
  String get language;
  @override
  @JsonKey(name: 'notifications')
  NotificationPreferencesModel? get notifications;
  @override
  @JsonKey(name: 'privacy')
  PrivacyPreferencesModel? get privacy;
  @override
  @JsonKey(ignore: true)
  _$$UserPreferencesModelImplCopyWith<_$UserPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationPreferencesModel _$NotificationPreferencesModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferencesModel {
  @JsonKey(name: 'push_enabled')
  bool get pushEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_enabled')
  bool get emailEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'sms_enabled')
  bool get smsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'refueling_alerts')
  bool get refuelingAlerts => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_alerts')
  bool get budgetAlerts => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenance_alerts')
  bool get maintenanceAlerts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationPreferencesModelCopyWith<NotificationPreferencesModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesModelCopyWith<$Res> {
  factory $NotificationPreferencesModelCopyWith(
          NotificationPreferencesModel value,
          $Res Function(NotificationPreferencesModel) then) =
      _$NotificationPreferencesModelCopyWithImpl<$Res,
          NotificationPreferencesModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'sms_enabled') bool smsEnabled,
      @JsonKey(name: 'refueling_alerts') bool refuelingAlerts,
      @JsonKey(name: 'budget_alerts') bool budgetAlerts,
      @JsonKey(name: 'maintenance_alerts') bool maintenanceAlerts});
}

/// @nodoc
class _$NotificationPreferencesModelCopyWithImpl<$Res,
        $Val extends NotificationPreferencesModel>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  _$NotificationPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? smsEnabled = null,
    Object? refuelingAlerts = null,
    Object? budgetAlerts = null,
    Object? maintenanceAlerts = null,
  }) {
    return _then(_value.copyWith(
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      smsEnabled: null == smsEnabled
          ? _value.smsEnabled
          : smsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      refuelingAlerts: null == refuelingAlerts
          ? _value.refuelingAlerts
          : refuelingAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      budgetAlerts: null == budgetAlerts
          ? _value.budgetAlerts
          : budgetAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      maintenanceAlerts: null == maintenanceAlerts
          ? _value.maintenanceAlerts
          : maintenanceAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesModelImplCopyWith<$Res>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  factory _$$NotificationPreferencesModelImplCopyWith(
          _$NotificationPreferencesModelImpl value,
          $Res Function(_$NotificationPreferencesModelImpl) then) =
      __$$NotificationPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'sms_enabled') bool smsEnabled,
      @JsonKey(name: 'refueling_alerts') bool refuelingAlerts,
      @JsonKey(name: 'budget_alerts') bool budgetAlerts,
      @JsonKey(name: 'maintenance_alerts') bool maintenanceAlerts});
}

/// @nodoc
class __$$NotificationPreferencesModelImplCopyWithImpl<$Res>
    extends _$NotificationPreferencesModelCopyWithImpl<$Res,
        _$NotificationPreferencesModelImpl>
    implements _$$NotificationPreferencesModelImplCopyWith<$Res> {
  __$$NotificationPreferencesModelImplCopyWithImpl(
      _$NotificationPreferencesModelImpl _value,
      $Res Function(_$NotificationPreferencesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? smsEnabled = null,
    Object? refuelingAlerts = null,
    Object? budgetAlerts = null,
    Object? maintenanceAlerts = null,
  }) {
    return _then(_$NotificationPreferencesModelImpl(
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      smsEnabled: null == smsEnabled
          ? _value.smsEnabled
          : smsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      refuelingAlerts: null == refuelingAlerts
          ? _value.refuelingAlerts
          : refuelingAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      budgetAlerts: null == budgetAlerts
          ? _value.budgetAlerts
          : budgetAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      maintenanceAlerts: null == maintenanceAlerts
          ? _value.maintenanceAlerts
          : maintenanceAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesModelImpl
    implements _NotificationPreferencesModel {
  const _$NotificationPreferencesModelImpl(
      {@JsonKey(name: 'push_enabled') this.pushEnabled = true,
      @JsonKey(name: 'email_enabled') this.emailEnabled = true,
      @JsonKey(name: 'sms_enabled') this.smsEnabled = false,
      @JsonKey(name: 'refueling_alerts') this.refuelingAlerts = true,
      @JsonKey(name: 'budget_alerts') this.budgetAlerts = true,
      @JsonKey(name: 'maintenance_alerts') this.maintenanceAlerts = true});

  factory _$NotificationPreferencesModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NotificationPreferencesModelImplFromJson(json);

  @override
  @JsonKey(name: 'push_enabled')
  final bool pushEnabled;
  @override
  @JsonKey(name: 'email_enabled')
  final bool emailEnabled;
  @override
  @JsonKey(name: 'sms_enabled')
  final bool smsEnabled;
  @override
  @JsonKey(name: 'refueling_alerts')
  final bool refuelingAlerts;
  @override
  @JsonKey(name: 'budget_alerts')
  final bool budgetAlerts;
  @override
  @JsonKey(name: 'maintenance_alerts')
  final bool maintenanceAlerts;

  @override
  String toString() {
    return 'NotificationPreferencesModel(pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, smsEnabled: $smsEnabled, refuelingAlerts: $refuelingAlerts, budgetAlerts: $budgetAlerts, maintenanceAlerts: $maintenanceAlerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesModelImpl &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.smsEnabled, smsEnabled) ||
                other.smsEnabled == smsEnabled) &&
            (identical(other.refuelingAlerts, refuelingAlerts) ||
                other.refuelingAlerts == refuelingAlerts) &&
            (identical(other.budgetAlerts, budgetAlerts) ||
                other.budgetAlerts == budgetAlerts) &&
            (identical(other.maintenanceAlerts, maintenanceAlerts) ||
                other.maintenanceAlerts == maintenanceAlerts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pushEnabled, emailEnabled,
      smsEnabled, refuelingAlerts, budgetAlerts, maintenanceAlerts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesModelImplCopyWith<
          _$NotificationPreferencesModelImpl>
      get copyWith => __$$NotificationPreferencesModelImplCopyWithImpl<
          _$NotificationPreferencesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationPreferencesModel
    implements NotificationPreferencesModel {
  const factory _NotificationPreferencesModel(
          {@JsonKey(name: 'push_enabled') final bool pushEnabled,
          @JsonKey(name: 'email_enabled') final bool emailEnabled,
          @JsonKey(name: 'sms_enabled') final bool smsEnabled,
          @JsonKey(name: 'refueling_alerts') final bool refuelingAlerts,
          @JsonKey(name: 'budget_alerts') final bool budgetAlerts,
          @JsonKey(name: 'maintenance_alerts') final bool maintenanceAlerts}) =
      _$NotificationPreferencesModelImpl;

  factory _NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesModelImpl.fromJson;

  @override
  @JsonKey(name: 'push_enabled')
  bool get pushEnabled;
  @override
  @JsonKey(name: 'email_enabled')
  bool get emailEnabled;
  @override
  @JsonKey(name: 'sms_enabled')
  bool get smsEnabled;
  @override
  @JsonKey(name: 'refueling_alerts')
  bool get refuelingAlerts;
  @override
  @JsonKey(name: 'budget_alerts')
  bool get budgetAlerts;
  @override
  @JsonKey(name: 'maintenance_alerts')
  bool get maintenanceAlerts;
  @override
  @JsonKey(ignore: true)
  _$$NotificationPreferencesModelImplCopyWith<
          _$NotificationPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PrivacyPreferencesModel _$PrivacyPreferencesModelFromJson(
    Map<String, dynamic> json) {
  return _PrivacyPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$PrivacyPreferencesModel {
  @JsonKey(name: 'location_sharing')
  bool get locationSharing => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_analytics')
  bool get dataAnalytics => throw _privateConstructorUsedError;
  @JsonKey(name: 'marketing_emails')
  bool get marketingEmails => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrivacyPreferencesModelCopyWith<PrivacyPreferencesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyPreferencesModelCopyWith<$Res> {
  factory $PrivacyPreferencesModelCopyWith(PrivacyPreferencesModel value,
          $Res Function(PrivacyPreferencesModel) then) =
      _$PrivacyPreferencesModelCopyWithImpl<$Res, PrivacyPreferencesModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'location_sharing') bool locationSharing,
      @JsonKey(name: 'data_analytics') bool dataAnalytics,
      @JsonKey(name: 'marketing_emails') bool marketingEmails});
}

/// @nodoc
class _$PrivacyPreferencesModelCopyWithImpl<$Res,
        $Val extends PrivacyPreferencesModel>
    implements $PrivacyPreferencesModelCopyWith<$Res> {
  _$PrivacyPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationSharing = null,
    Object? dataAnalytics = null,
    Object? marketingEmails = null,
  }) {
    return _then(_value.copyWith(
      locationSharing: null == locationSharing
          ? _value.locationSharing
          : locationSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      dataAnalytics: null == dataAnalytics
          ? _value.dataAnalytics
          : dataAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      marketingEmails: null == marketingEmails
          ? _value.marketingEmails
          : marketingEmails // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyPreferencesModelImplCopyWith<$Res>
    implements $PrivacyPreferencesModelCopyWith<$Res> {
  factory _$$PrivacyPreferencesModelImplCopyWith(
          _$PrivacyPreferencesModelImpl value,
          $Res Function(_$PrivacyPreferencesModelImpl) then) =
      __$$PrivacyPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'location_sharing') bool locationSharing,
      @JsonKey(name: 'data_analytics') bool dataAnalytics,
      @JsonKey(name: 'marketing_emails') bool marketingEmails});
}

/// @nodoc
class __$$PrivacyPreferencesModelImplCopyWithImpl<$Res>
    extends _$PrivacyPreferencesModelCopyWithImpl<$Res,
        _$PrivacyPreferencesModelImpl>
    implements _$$PrivacyPreferencesModelImplCopyWith<$Res> {
  __$$PrivacyPreferencesModelImplCopyWithImpl(
      _$PrivacyPreferencesModelImpl _value,
      $Res Function(_$PrivacyPreferencesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationSharing = null,
    Object? dataAnalytics = null,
    Object? marketingEmails = null,
  }) {
    return _then(_$PrivacyPreferencesModelImpl(
      locationSharing: null == locationSharing
          ? _value.locationSharing
          : locationSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      dataAnalytics: null == dataAnalytics
          ? _value.dataAnalytics
          : dataAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      marketingEmails: null == marketingEmails
          ? _value.marketingEmails
          : marketingEmails // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacyPreferencesModelImpl implements _PrivacyPreferencesModel {
  const _$PrivacyPreferencesModelImpl(
      {@JsonKey(name: 'location_sharing') this.locationSharing = false,
      @JsonKey(name: 'data_analytics') this.dataAnalytics = true,
      @JsonKey(name: 'marketing_emails') this.marketingEmails = false});

  factory _$PrivacyPreferencesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyPreferencesModelImplFromJson(json);

  @override
  @JsonKey(name: 'location_sharing')
  final bool locationSharing;
  @override
  @JsonKey(name: 'data_analytics')
  final bool dataAnalytics;
  @override
  @JsonKey(name: 'marketing_emails')
  final bool marketingEmails;

  @override
  String toString() {
    return 'PrivacyPreferencesModel(locationSharing: $locationSharing, dataAnalytics: $dataAnalytics, marketingEmails: $marketingEmails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyPreferencesModelImpl &&
            (identical(other.locationSharing, locationSharing) ||
                other.locationSharing == locationSharing) &&
            (identical(other.dataAnalytics, dataAnalytics) ||
                other.dataAnalytics == dataAnalytics) &&
            (identical(other.marketingEmails, marketingEmails) ||
                other.marketingEmails == marketingEmails));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, locationSharing, dataAnalytics, marketingEmails);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyPreferencesModelImplCopyWith<_$PrivacyPreferencesModelImpl>
      get copyWith => __$$PrivacyPreferencesModelImplCopyWithImpl<
          _$PrivacyPreferencesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacyPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _PrivacyPreferencesModel implements PrivacyPreferencesModel {
  const factory _PrivacyPreferencesModel(
          {@JsonKey(name: 'location_sharing') final bool locationSharing,
          @JsonKey(name: 'data_analytics') final bool dataAnalytics,
          @JsonKey(name: 'marketing_emails') final bool marketingEmails}) =
      _$PrivacyPreferencesModelImpl;

  factory _PrivacyPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$PrivacyPreferencesModelImpl.fromJson;

  @override
  @JsonKey(name: 'location_sharing')
  bool get locationSharing;
  @override
  @JsonKey(name: 'data_analytics')
  bool get dataAnalytics;
  @override
  @JsonKey(name: 'marketing_emails')
  bool get marketingEmails;
  @override
  @JsonKey(ignore: true)
  _$$PrivacyPreferencesModelImplCopyWith<_$PrivacyPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
