// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) {
  return _LoginResponseModel.fromJson(json);
}

/// @nodoc
mixin _$LoginResponseModel {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  LoginUserModel get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_companies')
  List<LoginCompanyModel> get availableCompanies =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginResponseModelCopyWith<LoginResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseModelCopyWith<$Res> {
  factory $LoginResponseModelCopyWith(
          LoginResponseModel value, $Res Function(LoginResponseModel) then) =
      _$LoginResponseModelCopyWithImpl<$Res, LoginResponseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      LoginUserModel user,
      @JsonKey(name: 'available_companies')
      List<LoginCompanyModel> availableCompanies});

  $LoginUserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$LoginResponseModelCopyWithImpl<$Res, $Val extends LoginResponseModel>
    implements $LoginResponseModelCopyWith<$Res> {
  _$LoginResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = null,
    Object? availableCompanies = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as LoginUserModel,
      availableCompanies: null == availableCompanies
          ? _value.availableCompanies
          : availableCompanies // ignore: cast_nullable_to_non_nullable
              as List<LoginCompanyModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LoginUserModelCopyWith<$Res> get user {
    return $LoginUserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginResponseModelImplCopyWith<$Res>
    implements $LoginResponseModelCopyWith<$Res> {
  factory _$$LoginResponseModelImplCopyWith(_$LoginResponseModelImpl value,
          $Res Function(_$LoginResponseModelImpl) then) =
      __$$LoginResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      LoginUserModel user,
      @JsonKey(name: 'available_companies')
      List<LoginCompanyModel> availableCompanies});

  @override
  $LoginUserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$LoginResponseModelImplCopyWithImpl<$Res>
    extends _$LoginResponseModelCopyWithImpl<$Res, _$LoginResponseModelImpl>
    implements _$$LoginResponseModelImplCopyWith<$Res> {
  __$$LoginResponseModelImplCopyWithImpl(_$LoginResponseModelImpl _value,
      $Res Function(_$LoginResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = null,
    Object? availableCompanies = null,
  }) {
    return _then(_$LoginResponseModelImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as LoginUserModel,
      availableCompanies: null == availableCompanies
          ? _value._availableCompanies
          : availableCompanies // ignore: cast_nullable_to_non_nullable
              as List<LoginCompanyModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseModelImpl implements _LoginResponseModel {
  const _$LoginResponseModelImpl(
      {@JsonKey(name: 'access_token') required this.accessToken,
      @JsonKey(name: 'refresh_token') required this.refreshToken,
      required this.user,
      @JsonKey(name: 'available_companies')
      final List<LoginCompanyModel> availableCompanies = const []})
      : _availableCompanies = availableCompanies;

  factory _$LoginResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseModelImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  final LoginUserModel user;
  final List<LoginCompanyModel> _availableCompanies;
  @override
  @JsonKey(name: 'available_companies')
  List<LoginCompanyModel> get availableCompanies {
    if (_availableCompanies is EqualUnmodifiableListView)
      return _availableCompanies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCompanies);
  }

  @override
  String toString() {
    return 'LoginResponseModel(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, availableCompanies: $availableCompanies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality()
                .equals(other._availableCompanies, _availableCompanies));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken, user,
      const DeepCollectionEquality().hash(_availableCompanies));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseModelImplCopyWith<_$LoginResponseModelImpl> get copyWith =>
      __$$LoginResponseModelImplCopyWithImpl<_$LoginResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseModelImplToJson(
      this,
    );
  }
}

abstract class _LoginResponseModel implements LoginResponseModel {
  const factory _LoginResponseModel(
          {@JsonKey(name: 'access_token') required final String accessToken,
          @JsonKey(name: 'refresh_token') required final String refreshToken,
          required final LoginUserModel user,
          @JsonKey(name: 'available_companies')
          final List<LoginCompanyModel> availableCompanies}) =
      _$LoginResponseModelImpl;

  factory _LoginResponseModel.fromJson(Map<String, dynamic> json) =
      _$LoginResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  LoginUserModel get user;
  @override
  @JsonKey(name: 'available_companies')
  List<LoginCompanyModel> get availableCompanies;
  @override
  @JsonKey(ignore: true)
  _$$LoginResponseModelImplCopyWith<_$LoginResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginUserModel _$LoginUserModelFromJson(Map<String, dynamic> json) {
  return _LoginUserModel.fromJson(json);
}

/// @nodoc
mixin _$LoginUserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get cpf => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get profile => throw _privateConstructorUsedError;
  LoginCompanyModel get company => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginUserModelCopyWith<LoginUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginUserModelCopyWith<$Res> {
  factory $LoginUserModelCopyWith(
          LoginUserModel value, $Res Function(LoginUserModel) then) =
      _$LoginUserModelCopyWithImpl<$Res, LoginUserModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? username,
      String? email,
      String? cpf,
      String? phone,
      String? role,
      String? profile,
      LoginCompanyModel company});

  $LoginCompanyModelCopyWith<$Res> get company;
}

/// @nodoc
class _$LoginUserModelCopyWithImpl<$Res, $Val extends LoginUserModel>
    implements $LoginUserModelCopyWith<$Res> {
  _$LoginUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? username = freezed,
    Object? email = freezed,
    Object? cpf = freezed,
    Object? phone = freezed,
    Object? role = freezed,
    Object? profile = freezed,
    Object? company = null,
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
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      cpf: freezed == cpf
          ? _value.cpf
          : cpf // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as String?,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as LoginCompanyModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LoginCompanyModelCopyWith<$Res> get company {
    return $LoginCompanyModelCopyWith<$Res>(_value.company, (value) {
      return _then(_value.copyWith(company: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginUserModelImplCopyWith<$Res>
    implements $LoginUserModelCopyWith<$Res> {
  factory _$$LoginUserModelImplCopyWith(_$LoginUserModelImpl value,
          $Res Function(_$LoginUserModelImpl) then) =
      __$$LoginUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? username,
      String? email,
      String? cpf,
      String? phone,
      String? role,
      String? profile,
      LoginCompanyModel company});

  @override
  $LoginCompanyModelCopyWith<$Res> get company;
}

/// @nodoc
class __$$LoginUserModelImplCopyWithImpl<$Res>
    extends _$LoginUserModelCopyWithImpl<$Res, _$LoginUserModelImpl>
    implements _$$LoginUserModelImplCopyWith<$Res> {
  __$$LoginUserModelImplCopyWithImpl(
      _$LoginUserModelImpl _value, $Res Function(_$LoginUserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? username = freezed,
    Object? email = freezed,
    Object? cpf = freezed,
    Object? phone = freezed,
    Object? role = freezed,
    Object? profile = freezed,
    Object? company = null,
  }) {
    return _then(_$LoginUserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      cpf: freezed == cpf
          ? _value.cpf
          : cpf // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as String?,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as LoginCompanyModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginUserModelImpl implements _LoginUserModel {
  const _$LoginUserModelImpl(
      {required this.id,
      required this.name,
      this.username,
      this.email,
      this.cpf,
      this.phone,
      this.role,
      this.profile,
      required this.company});

  factory _$LoginUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginUserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? username;
  @override
  final String? email;
  @override
  final String? cpf;
  @override
  final String? phone;
  @override
  final String? role;
  @override
  final String? profile;
  @override
  final LoginCompanyModel company;

  @override
  String toString() {
    return 'LoginUserModel(id: $id, name: $name, username: $username, email: $email, cpf: $cpf, phone: $phone, role: $role, profile: $profile, company: $company)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.cpf, cpf) || other.cpf == cpf) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.company, company) || other.company == company));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, username, email, cpf,
      phone, role, profile, company);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginUserModelImplCopyWith<_$LoginUserModelImpl> get copyWith =>
      __$$LoginUserModelImplCopyWithImpl<_$LoginUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginUserModelImplToJson(
      this,
    );
  }
}

abstract class _LoginUserModel implements LoginUserModel {
  const factory _LoginUserModel(
      {required final String id,
      required final String name,
      final String? username,
      final String? email,
      final String? cpf,
      final String? phone,
      final String? role,
      final String? profile,
      required final LoginCompanyModel company}) = _$LoginUserModelImpl;

  factory _LoginUserModel.fromJson(Map<String, dynamic> json) =
      _$LoginUserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get username;
  @override
  String? get email;
  @override
  String? get cpf;
  @override
  String? get phone;
  @override
  String? get role;
  @override
  String? get profile;
  @override
  LoginCompanyModel get company;
  @override
  @JsonKey(ignore: true)
  _$$LoginUserModelImplCopyWith<_$LoginUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginCompanyModel _$LoginCompanyModelFromJson(Map<String, dynamic> json) {
  return _LoginCompanyModel.fromJson(json);
}

/// @nodoc
mixin _$LoginCompanyModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get cnpj => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginCompanyModelCopyWith<LoginCompanyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginCompanyModelCopyWith<$Res> {
  factory $LoginCompanyModelCopyWith(
          LoginCompanyModel value, $Res Function(LoginCompanyModel) then) =
      _$LoginCompanyModelCopyWithImpl<$Res, LoginCompanyModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? cnpj,
      String? type,
      @JsonKey(name: 'is_primary') bool isPrimary});
}

/// @nodoc
class _$LoginCompanyModelCopyWithImpl<$Res, $Val extends LoginCompanyModel>
    implements $LoginCompanyModelCopyWith<$Res> {
  _$LoginCompanyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cnpj = freezed,
    Object? type = freezed,
    Object? isPrimary = null,
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
      cnpj: freezed == cnpj
          ? _value.cnpj
          : cnpj // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginCompanyModelImplCopyWith<$Res>
    implements $LoginCompanyModelCopyWith<$Res> {
  factory _$$LoginCompanyModelImplCopyWith(_$LoginCompanyModelImpl value,
          $Res Function(_$LoginCompanyModelImpl) then) =
      __$$LoginCompanyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? cnpj,
      String? type,
      @JsonKey(name: 'is_primary') bool isPrimary});
}

/// @nodoc
class __$$LoginCompanyModelImplCopyWithImpl<$Res>
    extends _$LoginCompanyModelCopyWithImpl<$Res, _$LoginCompanyModelImpl>
    implements _$$LoginCompanyModelImplCopyWith<$Res> {
  __$$LoginCompanyModelImplCopyWithImpl(_$LoginCompanyModelImpl _value,
      $Res Function(_$LoginCompanyModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cnpj = freezed,
    Object? type = freezed,
    Object? isPrimary = null,
  }) {
    return _then(_$LoginCompanyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cnpj: freezed == cnpj
          ? _value.cnpj
          : cnpj // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginCompanyModelImpl implements _LoginCompanyModel {
  const _$LoginCompanyModelImpl(
      {required this.id,
      required this.name,
      this.cnpj,
      this.type,
      @JsonKey(name: 'is_primary') this.isPrimary = false});

  factory _$LoginCompanyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginCompanyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? cnpj;
  @override
  final String? type;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;

  @override
  String toString() {
    return 'LoginCompanyModel(id: $id, name: $name, cnpj: $cnpj, type: $type, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginCompanyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cnpj, cnpj) || other.cnpj == cnpj) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, cnpj, type, isPrimary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginCompanyModelImplCopyWith<_$LoginCompanyModelImpl> get copyWith =>
      __$$LoginCompanyModelImplCopyWithImpl<_$LoginCompanyModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginCompanyModelImplToJson(
      this,
    );
  }
}

abstract class _LoginCompanyModel implements LoginCompanyModel {
  const factory _LoginCompanyModel(
          {required final String id,
          required final String name,
          final String? cnpj,
          final String? type,
          @JsonKey(name: 'is_primary') final bool isPrimary}) =
      _$LoginCompanyModelImpl;

  factory _LoginCompanyModel.fromJson(Map<String, dynamic> json) =
      _$LoginCompanyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get cnpj;
  @override
  String? get type;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;
  @override
  @JsonKey(ignore: true)
  _$$LoginCompanyModelImplCopyWith<_$LoginCompanyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
