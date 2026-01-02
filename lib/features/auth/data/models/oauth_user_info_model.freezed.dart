// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oauth_user_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OAuthUserInfoModel _$OAuthUserInfoModelFromJson(Map<String, dynamic> json) {
  return _OAuthUserInfoModel.fromJson(json);
}

/// @nodoc
mixin _$OAuthUserInfoModel {
  String get sub => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get cpf => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_cnpj')
  String? get companyCnpj => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_type')
  String? get companyType => throw _privateConstructorUsedError;
  @JsonKey(name: 'roles')
  List<String> get roles => throw _privateConstructorUsedError;
  @JsonKey(name: 'permissions')
  List<String> get permissions => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verified')
  bool get emailVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_verified')
  bool get phoneVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OAuthUserInfoModelCopyWith<OAuthUserInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OAuthUserInfoModelCopyWith<$Res> {
  factory $OAuthUserInfoModelCopyWith(
          OAuthUserInfoModel value, $Res Function(OAuthUserInfoModel) then) =
      _$OAuthUserInfoModelCopyWithImpl<$Res, OAuthUserInfoModel>;
  @useResult
  $Res call(
      {String sub,
      String name,
      String cpf,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'company_cnpj') String? companyCnpj,
      @JsonKey(name: 'company_type') String? companyType,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'permissions') List<String> permissions,
      @JsonKey(name: 'last_login') DateTime? lastLogin,
      @JsonKey(name: 'email_verified') bool emailVerified,
      @JsonKey(name: 'phone_verified') bool phoneVerified});
}

/// @nodoc
class _$OAuthUserInfoModelCopyWithImpl<$Res, $Val extends OAuthUserInfoModel>
    implements $OAuthUserInfoModelCopyWith<$Res> {
  _$OAuthUserInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sub = null,
    Object? name = null,
    Object? cpf = null,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? companyId = null,
    Object? companyName = null,
    Object? companyCnpj = freezed,
    Object? companyType = freezed,
    Object? roles = null,
    Object? permissions = null,
    Object? lastLogin = freezed,
    Object? emailVerified = null,
    Object? phoneVerified = null,
  }) {
    return _then(_value.copyWith(
      sub: null == sub
          ? _value.sub
          : sub // ignore: cast_nullable_to_non_nullable
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
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
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
      companyType: freezed == companyType
          ? _value.companyType
          : companyType // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OAuthUserInfoModelImplCopyWith<$Res>
    implements $OAuthUserInfoModelCopyWith<$Res> {
  factory _$$OAuthUserInfoModelImplCopyWith(_$OAuthUserInfoModelImpl value,
          $Res Function(_$OAuthUserInfoModelImpl) then) =
      __$$OAuthUserInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sub,
      String name,
      String cpf,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'company_cnpj') String? companyCnpj,
      @JsonKey(name: 'company_type') String? companyType,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'permissions') List<String> permissions,
      @JsonKey(name: 'last_login') DateTime? lastLogin,
      @JsonKey(name: 'email_verified') bool emailVerified,
      @JsonKey(name: 'phone_verified') bool phoneVerified});
}

/// @nodoc
class __$$OAuthUserInfoModelImplCopyWithImpl<$Res>
    extends _$OAuthUserInfoModelCopyWithImpl<$Res, _$OAuthUserInfoModelImpl>
    implements _$$OAuthUserInfoModelImplCopyWith<$Res> {
  __$$OAuthUserInfoModelImplCopyWithImpl(_$OAuthUserInfoModelImpl _value,
      $Res Function(_$OAuthUserInfoModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sub = null,
    Object? name = null,
    Object? cpf = null,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? companyId = null,
    Object? companyName = null,
    Object? companyCnpj = freezed,
    Object? companyType = freezed,
    Object? roles = null,
    Object? permissions = null,
    Object? lastLogin = freezed,
    Object? emailVerified = null,
    Object? phoneVerified = null,
  }) {
    return _then(_$OAuthUserInfoModelImpl(
      sub: null == sub
          ? _value.sub
          : sub // ignore: cast_nullable_to_non_nullable
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
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
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
      companyType: freezed == companyType
          ? _value.companyType
          : companyType // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OAuthUserInfoModelImpl implements _OAuthUserInfoModel {
  const _$OAuthUserInfoModelImpl(
      {required this.sub,
      required this.name,
      required this.cpf,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'phone_number') this.phoneNumber,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'company_name') required this.companyName,
      @JsonKey(name: 'company_cnpj') this.companyCnpj,
      @JsonKey(name: 'company_type') this.companyType,
      @JsonKey(name: 'roles') final List<String> roles = const [],
      @JsonKey(name: 'permissions') final List<String> permissions = const [],
      @JsonKey(name: 'last_login') this.lastLogin,
      @JsonKey(name: 'email_verified') this.emailVerified = false,
      @JsonKey(name: 'phone_verified') this.phoneVerified = false})
      : _roles = roles,
        _permissions = permissions;

  factory _$OAuthUserInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OAuthUserInfoModelImplFromJson(json);

  @override
  final String sub;
  @override
  final String name;
  @override
  final String cpf;
  @override
  @JsonKey(name: 'email')
  final String? email;
  @override
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
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
  @JsonKey(name: 'company_type')
  final String? companyType;
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
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  @override
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @override
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;

  @override
  String toString() {
    return 'OAuthUserInfoModel(sub: $sub, name: $name, cpf: $cpf, email: $email, phoneNumber: $phoneNumber, companyId: $companyId, companyName: $companyName, companyCnpj: $companyCnpj, companyType: $companyType, roles: $roles, permissions: $permissions, lastLogin: $lastLogin, emailVerified: $emailVerified, phoneVerified: $phoneVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OAuthUserInfoModelImpl &&
            (identical(other.sub, sub) || other.sub == sub) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cpf, cpf) || other.cpf == cpf) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyCnpj, companyCnpj) ||
                other.companyCnpj == companyCnpj) &&
            (identical(other.companyType, companyType) ||
                other.companyType == companyType) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sub,
      name,
      cpf,
      email,
      phoneNumber,
      companyId,
      companyName,
      companyCnpj,
      companyType,
      const DeepCollectionEquality().hash(_roles),
      const DeepCollectionEquality().hash(_permissions),
      lastLogin,
      emailVerified,
      phoneVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OAuthUserInfoModelImplCopyWith<_$OAuthUserInfoModelImpl> get copyWith =>
      __$$OAuthUserInfoModelImplCopyWithImpl<_$OAuthUserInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OAuthUserInfoModelImplToJson(
      this,
    );
  }
}

abstract class _OAuthUserInfoModel implements OAuthUserInfoModel {
  const factory _OAuthUserInfoModel(
          {required final String sub,
          required final String name,
          required final String cpf,
          @JsonKey(name: 'email') final String? email,
          @JsonKey(name: 'phone_number') final String? phoneNumber,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'company_name') required final String companyName,
          @JsonKey(name: 'company_cnpj') final String? companyCnpj,
          @JsonKey(name: 'company_type') final String? companyType,
          @JsonKey(name: 'roles') final List<String> roles,
          @JsonKey(name: 'permissions') final List<String> permissions,
          @JsonKey(name: 'last_login') final DateTime? lastLogin,
          @JsonKey(name: 'email_verified') final bool emailVerified,
          @JsonKey(name: 'phone_verified') final bool phoneVerified}) =
      _$OAuthUserInfoModelImpl;

  factory _OAuthUserInfoModel.fromJson(Map<String, dynamic> json) =
      _$OAuthUserInfoModelImpl.fromJson;

  @override
  String get sub;
  @override
  String get name;
  @override
  String get cpf;
  @override
  @JsonKey(name: 'email')
  String? get email;
  @override
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
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
  @JsonKey(name: 'company_type')
  String? get companyType;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles;
  @override
  @JsonKey(name: 'permissions')
  List<String> get permissions;
  @override
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin;
  @override
  @JsonKey(name: 'email_verified')
  bool get emailVerified;
  @override
  @JsonKey(name: 'phone_verified')
  bool get phoneVerified;
  @override
  @JsonKey(ignore: true)
  _$$OAuthUserInfoModelImplCopyWith<_$OAuthUserInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
