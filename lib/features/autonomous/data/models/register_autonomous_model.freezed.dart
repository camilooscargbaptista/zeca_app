// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_autonomous_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegisterAutonomousRequest _$RegisterAutonomousRequestFromJson(
    Map<String, dynamic> json) {
  return _RegisterAutonomousRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterAutonomousRequest {
  String get name => throw _privateConstructorUsedError;
  String get cpf => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  String? get birthDate => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'terms_accepted')
  bool get termsAccepted => throw _privateConstructorUsedError;
  @JsonKey(name: 'terms_version')
  String? get termsVersion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterAutonomousRequestCopyWith<RegisterAutonomousRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterAutonomousRequestCopyWith<$Res> {
  factory $RegisterAutonomousRequestCopyWith(RegisterAutonomousRequest value,
          $Res Function(RegisterAutonomousRequest) then) =
      _$RegisterAutonomousRequestCopyWithImpl<$Res, RegisterAutonomousRequest>;
  @useResult
  $Res call(
      {String name,
      String cpf,
      String phone,
      @JsonKey(name: 'birth_date') String? birthDate,
      String? email,
      String password,
      @JsonKey(name: 'terms_accepted') bool termsAccepted,
      @JsonKey(name: 'terms_version') String? termsVersion});
}

/// @nodoc
class _$RegisterAutonomousRequestCopyWithImpl<$Res,
        $Val extends RegisterAutonomousRequest>
    implements $RegisterAutonomousRequestCopyWith<$Res> {
  _$RegisterAutonomousRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? cpf = null,
    Object? phone = null,
    Object? birthDate = freezed,
    Object? email = freezed,
    Object? password = null,
    Object? termsAccepted = null,
    Object? termsVersion = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cpf: null == cpf
          ? _value.cpf
          : cpf // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      termsAccepted: null == termsAccepted
          ? _value.termsAccepted
          : termsAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      termsVersion: freezed == termsVersion
          ? _value.termsVersion
          : termsVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterAutonomousRequestImplCopyWith<$Res>
    implements $RegisterAutonomousRequestCopyWith<$Res> {
  factory _$$RegisterAutonomousRequestImplCopyWith(
          _$RegisterAutonomousRequestImpl value,
          $Res Function(_$RegisterAutonomousRequestImpl) then) =
      __$$RegisterAutonomousRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String cpf,
      String phone,
      @JsonKey(name: 'birth_date') String? birthDate,
      String? email,
      String password,
      @JsonKey(name: 'terms_accepted') bool termsAccepted,
      @JsonKey(name: 'terms_version') String? termsVersion});
}

/// @nodoc
class __$$RegisterAutonomousRequestImplCopyWithImpl<$Res>
    extends _$RegisterAutonomousRequestCopyWithImpl<$Res,
        _$RegisterAutonomousRequestImpl>
    implements _$$RegisterAutonomousRequestImplCopyWith<$Res> {
  __$$RegisterAutonomousRequestImplCopyWithImpl(
      _$RegisterAutonomousRequestImpl _value,
      $Res Function(_$RegisterAutonomousRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? cpf = null,
    Object? phone = null,
    Object? birthDate = freezed,
    Object? email = freezed,
    Object? password = null,
    Object? termsAccepted = null,
    Object? termsVersion = freezed,
  }) {
    return _then(_$RegisterAutonomousRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cpf: null == cpf
          ? _value.cpf
          : cpf // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      termsAccepted: null == termsAccepted
          ? _value.termsAccepted
          : termsAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      termsVersion: freezed == termsVersion
          ? _value.termsVersion
          : termsVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterAutonomousRequestImpl implements _RegisterAutonomousRequest {
  const _$RegisterAutonomousRequestImpl(
      {required this.name,
      required this.cpf,
      required this.phone,
      @JsonKey(name: 'birth_date') this.birthDate,
      this.email,
      required this.password,
      @JsonKey(name: 'terms_accepted') required this.termsAccepted,
      @JsonKey(name: 'terms_version') this.termsVersion});

  factory _$RegisterAutonomousRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterAutonomousRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String cpf;
  @override
  final String phone;
  @override
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @override
  final String? email;
  @override
  final String password;
  @override
  @JsonKey(name: 'terms_accepted')
  final bool termsAccepted;
  @override
  @JsonKey(name: 'terms_version')
  final String? termsVersion;

  @override
  String toString() {
    return 'RegisterAutonomousRequest(name: $name, cpf: $cpf, phone: $phone, birthDate: $birthDate, email: $email, password: $password, termsAccepted: $termsAccepted, termsVersion: $termsVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterAutonomousRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cpf, cpf) || other.cpf == cpf) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.termsAccepted, termsAccepted) ||
                other.termsAccepted == termsAccepted) &&
            (identical(other.termsVersion, termsVersion) ||
                other.termsVersion == termsVersion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, cpf, phone, birthDate,
      email, password, termsAccepted, termsVersion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterAutonomousRequestImplCopyWith<_$RegisterAutonomousRequestImpl>
      get copyWith => __$$RegisterAutonomousRequestImplCopyWithImpl<
          _$RegisterAutonomousRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterAutonomousRequestImplToJson(
      this,
    );
  }
}

abstract class _RegisterAutonomousRequest implements RegisterAutonomousRequest {
  const factory _RegisterAutonomousRequest(
          {required final String name,
          required final String cpf,
          required final String phone,
          @JsonKey(name: 'birth_date') final String? birthDate,
          final String? email,
          required final String password,
          @JsonKey(name: 'terms_accepted') required final bool termsAccepted,
          @JsonKey(name: 'terms_version') final String? termsVersion}) =
      _$RegisterAutonomousRequestImpl;

  factory _RegisterAutonomousRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterAutonomousRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get cpf;
  @override
  String get phone;
  @override
  @JsonKey(name: 'birth_date')
  String? get birthDate;
  @override
  String? get email;
  @override
  String get password;
  @override
  @JsonKey(name: 'terms_accepted')
  bool get termsAccepted;
  @override
  @JsonKey(name: 'terms_version')
  String? get termsVersion;
  @override
  @JsonKey(ignore: true)
  _$$RegisterAutonomousRequestImplCopyWith<_$RegisterAutonomousRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RegisterAutonomousResponse _$RegisterAutonomousResponseFromJson(
    Map<String, dynamic> json) {
  return _RegisterAutonomousResponse.fromJson(json);
}

/// @nodoc
mixin _$RegisterAutonomousResponse {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get cpf => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterAutonomousResponseCopyWith<RegisterAutonomousResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterAutonomousResponseCopyWith<$Res> {
  factory $RegisterAutonomousResponseCopyWith(RegisterAutonomousResponse value,
          $Res Function(RegisterAutonomousResponse) then) =
      _$RegisterAutonomousResponseCopyWithImpl<$Res,
          RegisterAutonomousResponse>;
  @useResult
  $Res call(
      {String id,
      String name,
      String cpf,
      @JsonKey(name: 'access_token') String accessToken});
}

/// @nodoc
class _$RegisterAutonomousResponseCopyWithImpl<$Res,
        $Val extends RegisterAutonomousResponse>
    implements $RegisterAutonomousResponseCopyWith<$Res> {
  _$RegisterAutonomousResponseCopyWithImpl(this._value, this._then);

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
    Object? accessToken = null,
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
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterAutonomousResponseImplCopyWith<$Res>
    implements $RegisterAutonomousResponseCopyWith<$Res> {
  factory _$$RegisterAutonomousResponseImplCopyWith(
          _$RegisterAutonomousResponseImpl value,
          $Res Function(_$RegisterAutonomousResponseImpl) then) =
      __$$RegisterAutonomousResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String cpf,
      @JsonKey(name: 'access_token') String accessToken});
}

/// @nodoc
class __$$RegisterAutonomousResponseImplCopyWithImpl<$Res>
    extends _$RegisterAutonomousResponseCopyWithImpl<$Res,
        _$RegisterAutonomousResponseImpl>
    implements _$$RegisterAutonomousResponseImplCopyWith<$Res> {
  __$$RegisterAutonomousResponseImplCopyWithImpl(
      _$RegisterAutonomousResponseImpl _value,
      $Res Function(_$RegisterAutonomousResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cpf = null,
    Object? accessToken = null,
  }) {
    return _then(_$RegisterAutonomousResponseImpl(
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
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterAutonomousResponseImpl implements _RegisterAutonomousResponse {
  const _$RegisterAutonomousResponseImpl(
      {required this.id,
      required this.name,
      required this.cpf,
      @JsonKey(name: 'access_token') required this.accessToken});

  factory _$RegisterAutonomousResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RegisterAutonomousResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String cpf;
  @override
  @JsonKey(name: 'access_token')
  final String accessToken;

  @override
  String toString() {
    return 'RegisterAutonomousResponse(id: $id, name: $name, cpf: $cpf, accessToken: $accessToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterAutonomousResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cpf, cpf) || other.cpf == cpf) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, cpf, accessToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterAutonomousResponseImplCopyWith<_$RegisterAutonomousResponseImpl>
      get copyWith => __$$RegisterAutonomousResponseImplCopyWithImpl<
          _$RegisterAutonomousResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterAutonomousResponseImplToJson(
      this,
    );
  }
}

abstract class _RegisterAutonomousResponse
    implements RegisterAutonomousResponse {
  const factory _RegisterAutonomousResponse(
          {required final String id,
          required final String name,
          required final String cpf,
          @JsonKey(name: 'access_token') required final String accessToken}) =
      _$RegisterAutonomousResponseImpl;

  factory _RegisterAutonomousResponse.fromJson(Map<String, dynamic> json) =
      _$RegisterAutonomousResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get cpf;
  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(ignore: true)
  _$$RegisterAutonomousResponseImplCopyWith<_$RegisterAutonomousResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TermsVersionModel _$TermsVersionModelFromJson(Map<String, dynamic> json) {
  return _TermsVersionModel.fromJson(json);
}

/// @nodoc
mixin _$TermsVersionModel {
  String get id => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TermsVersionModelCopyWith<TermsVersionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TermsVersionModelCopyWith<$Res> {
  factory $TermsVersionModelCopyWith(
          TermsVersionModel value, $Res Function(TermsVersionModel) then) =
      _$TermsVersionModelCopyWithImpl<$Res, TermsVersionModel>;
  @useResult
  $Res call(
      {String id,
      String version,
      String title,
      String content,
      String type,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'published_at') DateTime? publishedAt});
}

/// @nodoc
class _$TermsVersionModelCopyWithImpl<$Res, $Val extends TermsVersionModel>
    implements $TermsVersionModelCopyWith<$Res> {
  _$TermsVersionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? version = null,
    Object? title = null,
    Object? content = null,
    Object? type = null,
    Object? isActive = null,
    Object? publishedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TermsVersionModelImplCopyWith<$Res>
    implements $TermsVersionModelCopyWith<$Res> {
  factory _$$TermsVersionModelImplCopyWith(_$TermsVersionModelImpl value,
          $Res Function(_$TermsVersionModelImpl) then) =
      __$$TermsVersionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String version,
      String title,
      String content,
      String type,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'published_at') DateTime? publishedAt});
}

/// @nodoc
class __$$TermsVersionModelImplCopyWithImpl<$Res>
    extends _$TermsVersionModelCopyWithImpl<$Res, _$TermsVersionModelImpl>
    implements _$$TermsVersionModelImplCopyWith<$Res> {
  __$$TermsVersionModelImplCopyWithImpl(_$TermsVersionModelImpl _value,
      $Res Function(_$TermsVersionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? version = null,
    Object? title = null,
    Object? content = null,
    Object? type = null,
    Object? isActive = null,
    Object? publishedAt = freezed,
  }) {
    return _then(_$TermsVersionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TermsVersionModelImpl implements _TermsVersionModel {
  const _$TermsVersionModelImpl(
      {required this.id,
      required this.version,
      required this.title,
      required this.content,
      required this.type,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'published_at') this.publishedAt});

  factory _$TermsVersionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TermsVersionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String version;
  @override
  final String title;
  @override
  final String content;
  @override
  final String type;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'published_at')
  final DateTime? publishedAt;

  @override
  String toString() {
    return 'TermsVersionModel(id: $id, version: $version, title: $title, content: $content, type: $type, isActive: $isActive, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TermsVersionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, version, title, content, type, isActive, publishedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TermsVersionModelImplCopyWith<_$TermsVersionModelImpl> get copyWith =>
      __$$TermsVersionModelImplCopyWithImpl<_$TermsVersionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TermsVersionModelImplToJson(
      this,
    );
  }
}

abstract class _TermsVersionModel implements TermsVersionModel {
  const factory _TermsVersionModel(
          {required final String id,
          required final String version,
          required final String title,
          required final String content,
          required final String type,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'published_at') final DateTime? publishedAt}) =
      _$TermsVersionModelImpl;

  factory _TermsVersionModel.fromJson(Map<String, dynamic> json) =
      _$TermsVersionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get version;
  @override
  String get title;
  @override
  String get content;
  @override
  String get type;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt;
  @override
  @JsonKey(ignore: true)
  _$$TermsVersionModelImplCopyWith<_$TermsVersionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CheckCpfResponse _$CheckCpfResponseFromJson(Map<String, dynamic> json) {
  return _CheckCpfResponse.fromJson(json);
}

/// @nodoc
mixin _$CheckCpfResponse {
  bool get exists => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CheckCpfResponseCopyWith<CheckCpfResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckCpfResponseCopyWith<$Res> {
  factory $CheckCpfResponseCopyWith(
          CheckCpfResponse value, $Res Function(CheckCpfResponse) then) =
      _$CheckCpfResponseCopyWithImpl<$Res, CheckCpfResponse>;
  @useResult
  $Res call({bool exists});
}

/// @nodoc
class _$CheckCpfResponseCopyWithImpl<$Res, $Val extends CheckCpfResponse>
    implements $CheckCpfResponseCopyWith<$Res> {
  _$CheckCpfResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exists = null,
  }) {
    return _then(_value.copyWith(
      exists: null == exists
          ? _value.exists
          : exists // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckCpfResponseImplCopyWith<$Res>
    implements $CheckCpfResponseCopyWith<$Res> {
  factory _$$CheckCpfResponseImplCopyWith(_$CheckCpfResponseImpl value,
          $Res Function(_$CheckCpfResponseImpl) then) =
      __$$CheckCpfResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool exists});
}

/// @nodoc
class __$$CheckCpfResponseImplCopyWithImpl<$Res>
    extends _$CheckCpfResponseCopyWithImpl<$Res, _$CheckCpfResponseImpl>
    implements _$$CheckCpfResponseImplCopyWith<$Res> {
  __$$CheckCpfResponseImplCopyWithImpl(_$CheckCpfResponseImpl _value,
      $Res Function(_$CheckCpfResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exists = null,
  }) {
    return _then(_$CheckCpfResponseImpl(
      exists: null == exists
          ? _value.exists
          : exists // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckCpfResponseImpl implements _CheckCpfResponse {
  const _$CheckCpfResponseImpl({required this.exists});

  factory _$CheckCpfResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckCpfResponseImplFromJson(json);

  @override
  final bool exists;

  @override
  String toString() {
    return 'CheckCpfResponse(exists: $exists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckCpfResponseImpl &&
            (identical(other.exists, exists) || other.exists == exists));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, exists);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckCpfResponseImplCopyWith<_$CheckCpfResponseImpl> get copyWith =>
      __$$CheckCpfResponseImplCopyWithImpl<_$CheckCpfResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckCpfResponseImplToJson(
      this,
    );
  }
}

abstract class _CheckCpfResponse implements CheckCpfResponse {
  const factory _CheckCpfResponse({required final bool exists}) =
      _$CheckCpfResponseImpl;

  factory _CheckCpfResponse.fromJson(Map<String, dynamic> json) =
      _$CheckCpfResponseImpl.fromJson;

  @override
  bool get exists;
  @override
  @JsonKey(ignore: true)
  _$$CheckCpfResponseImplCopyWith<_$CheckCpfResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
