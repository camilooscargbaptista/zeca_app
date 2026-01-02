// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'autonomous_registration_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AutonomousRegistrationEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTerms,
    required TResult Function(String cpf) checkCpf,
    required TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)
        register,
    required TResult Function() reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTerms,
    TResult? Function(String cpf)? checkCpf,
    TResult? Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult? Function()? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTerms,
    TResult Function(String cpf)? checkCpf,
    TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult Function()? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadTerms value) loadTerms,
    required TResult Function(_CheckCpf value) checkCpf,
    required TResult Function(_Register value) register,
    required TResult Function(_Reset value) reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadTerms value)? loadTerms,
    TResult? Function(_CheckCpf value)? checkCpf,
    TResult? Function(_Register value)? register,
    TResult? Function(_Reset value)? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadTerms value)? loadTerms,
    TResult Function(_CheckCpf value)? checkCpf,
    TResult Function(_Register value)? register,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutonomousRegistrationEventCopyWith<$Res> {
  factory $AutonomousRegistrationEventCopyWith(
          AutonomousRegistrationEvent value,
          $Res Function(AutonomousRegistrationEvent) then) =
      _$AutonomousRegistrationEventCopyWithImpl<$Res,
          AutonomousRegistrationEvent>;
}

/// @nodoc
class _$AutonomousRegistrationEventCopyWithImpl<$Res,
        $Val extends AutonomousRegistrationEvent>
    implements $AutonomousRegistrationEventCopyWith<$Res> {
  _$AutonomousRegistrationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadTermsImplCopyWith<$Res> {
  factory _$$LoadTermsImplCopyWith(
          _$LoadTermsImpl value, $Res Function(_$LoadTermsImpl) then) =
      __$$LoadTermsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadTermsImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationEventCopyWithImpl<$Res, _$LoadTermsImpl>
    implements _$$LoadTermsImplCopyWith<$Res> {
  __$$LoadTermsImplCopyWithImpl(
      _$LoadTermsImpl _value, $Res Function(_$LoadTermsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadTermsImpl implements _LoadTerms {
  const _$LoadTermsImpl();

  @override
  String toString() {
    return 'AutonomousRegistrationEvent.loadTerms()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadTermsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTerms,
    required TResult Function(String cpf) checkCpf,
    required TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)
        register,
    required TResult Function() reset,
  }) {
    return loadTerms();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTerms,
    TResult? Function(String cpf)? checkCpf,
    TResult? Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult? Function()? reset,
  }) {
    return loadTerms?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTerms,
    TResult Function(String cpf)? checkCpf,
    TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (loadTerms != null) {
      return loadTerms();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadTerms value) loadTerms,
    required TResult Function(_CheckCpf value) checkCpf,
    required TResult Function(_Register value) register,
    required TResult Function(_Reset value) reset,
  }) {
    return loadTerms(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadTerms value)? loadTerms,
    TResult? Function(_CheckCpf value)? checkCpf,
    TResult? Function(_Register value)? register,
    TResult? Function(_Reset value)? reset,
  }) {
    return loadTerms?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadTerms value)? loadTerms,
    TResult Function(_CheckCpf value)? checkCpf,
    TResult Function(_Register value)? register,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (loadTerms != null) {
      return loadTerms(this);
    }
    return orElse();
  }
}

abstract class _LoadTerms implements AutonomousRegistrationEvent {
  const factory _LoadTerms() = _$LoadTermsImpl;
}

/// @nodoc
abstract class _$$CheckCpfImplCopyWith<$Res> {
  factory _$$CheckCpfImplCopyWith(
          _$CheckCpfImpl value, $Res Function(_$CheckCpfImpl) then) =
      __$$CheckCpfImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String cpf});
}

/// @nodoc
class __$$CheckCpfImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationEventCopyWithImpl<$Res, _$CheckCpfImpl>
    implements _$$CheckCpfImplCopyWith<$Res> {
  __$$CheckCpfImplCopyWithImpl(
      _$CheckCpfImpl _value, $Res Function(_$CheckCpfImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cpf = null,
  }) {
    return _then(_$CheckCpfImpl(
      null == cpf
          ? _value.cpf
          : cpf // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CheckCpfImpl implements _CheckCpf {
  const _$CheckCpfImpl(this.cpf);

  @override
  final String cpf;

  @override
  String toString() {
    return 'AutonomousRegistrationEvent.checkCpf(cpf: $cpf)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckCpfImpl &&
            (identical(other.cpf, cpf) || other.cpf == cpf));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cpf);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckCpfImplCopyWith<_$CheckCpfImpl> get copyWith =>
      __$$CheckCpfImplCopyWithImpl<_$CheckCpfImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTerms,
    required TResult Function(String cpf) checkCpf,
    required TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)
        register,
    required TResult Function() reset,
  }) {
    return checkCpf(cpf);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTerms,
    TResult? Function(String cpf)? checkCpf,
    TResult? Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult? Function()? reset,
  }) {
    return checkCpf?.call(cpf);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTerms,
    TResult Function(String cpf)? checkCpf,
    TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (checkCpf != null) {
      return checkCpf(cpf);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadTerms value) loadTerms,
    required TResult Function(_CheckCpf value) checkCpf,
    required TResult Function(_Register value) register,
    required TResult Function(_Reset value) reset,
  }) {
    return checkCpf(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadTerms value)? loadTerms,
    TResult? Function(_CheckCpf value)? checkCpf,
    TResult? Function(_Register value)? register,
    TResult? Function(_Reset value)? reset,
  }) {
    return checkCpf?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadTerms value)? loadTerms,
    TResult Function(_CheckCpf value)? checkCpf,
    TResult Function(_Register value)? register,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (checkCpf != null) {
      return checkCpf(this);
    }
    return orElse();
  }
}

abstract class _CheckCpf implements AutonomousRegistrationEvent {
  const factory _CheckCpf(final String cpf) = _$CheckCpfImpl;

  String get cpf;
  @JsonKey(ignore: true)
  _$$CheckCpfImplCopyWith<_$CheckCpfImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RegisterImplCopyWith<$Res> {
  factory _$$RegisterImplCopyWith(
          _$RegisterImpl value, $Res Function(_$RegisterImpl) then) =
      __$$RegisterImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String name,
      String cpf,
      String phone,
      String? birthDate,
      String? email,
      String password,
      bool termsAccepted,
      String? termsVersion});
}

/// @nodoc
class __$$RegisterImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationEventCopyWithImpl<$Res, _$RegisterImpl>
    implements _$$RegisterImplCopyWith<$Res> {
  __$$RegisterImplCopyWithImpl(
      _$RegisterImpl _value, $Res Function(_$RegisterImpl) _then)
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
    return _then(_$RegisterImpl(
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

class _$RegisterImpl implements _Register {
  const _$RegisterImpl(
      {required this.name,
      required this.cpf,
      required this.phone,
      this.birthDate,
      this.email,
      required this.password,
      required this.termsAccepted,
      this.termsVersion});

  @override
  final String name;
  @override
  final String cpf;
  @override
  final String phone;
  @override
  final String? birthDate;
  @override
  final String? email;
  @override
  final String password;
  @override
  final bool termsAccepted;
  @override
  final String? termsVersion;

  @override
  String toString() {
    return 'AutonomousRegistrationEvent.register(name: $name, cpf: $cpf, phone: $phone, birthDate: $birthDate, email: $email, password: $password, termsAccepted: $termsAccepted, termsVersion: $termsVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterImpl &&
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

  @override
  int get hashCode => Object.hash(runtimeType, name, cpf, phone, birthDate,
      email, password, termsAccepted, termsVersion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterImplCopyWith<_$RegisterImpl> get copyWith =>
      __$$RegisterImplCopyWithImpl<_$RegisterImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTerms,
    required TResult Function(String cpf) checkCpf,
    required TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)
        register,
    required TResult Function() reset,
  }) {
    return register(name, cpf, phone, birthDate, email, password, termsAccepted,
        termsVersion);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTerms,
    TResult? Function(String cpf)? checkCpf,
    TResult? Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult? Function()? reset,
  }) {
    return register?.call(name, cpf, phone, birthDate, email, password,
        termsAccepted, termsVersion);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTerms,
    TResult Function(String cpf)? checkCpf,
    TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (register != null) {
      return register(name, cpf, phone, birthDate, email, password,
          termsAccepted, termsVersion);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadTerms value) loadTerms,
    required TResult Function(_CheckCpf value) checkCpf,
    required TResult Function(_Register value) register,
    required TResult Function(_Reset value) reset,
  }) {
    return register(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadTerms value)? loadTerms,
    TResult? Function(_CheckCpf value)? checkCpf,
    TResult? Function(_Register value)? register,
    TResult? Function(_Reset value)? reset,
  }) {
    return register?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadTerms value)? loadTerms,
    TResult Function(_CheckCpf value)? checkCpf,
    TResult Function(_Register value)? register,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (register != null) {
      return register(this);
    }
    return orElse();
  }
}

abstract class _Register implements AutonomousRegistrationEvent {
  const factory _Register(
      {required final String name,
      required final String cpf,
      required final String phone,
      final String? birthDate,
      final String? email,
      required final String password,
      required final bool termsAccepted,
      final String? termsVersion}) = _$RegisterImpl;

  String get name;
  String get cpf;
  String get phone;
  String? get birthDate;
  String? get email;
  String get password;
  bool get termsAccepted;
  String? get termsVersion;
  @JsonKey(ignore: true)
  _$$RegisterImplCopyWith<_$RegisterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetImplCopyWith<$Res> {
  factory _$$ResetImplCopyWith(
          _$ResetImpl value, $Res Function(_$ResetImpl) then) =
      __$$ResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationEventCopyWithImpl<$Res, _$ResetImpl>
    implements _$$ResetImplCopyWith<$Res> {
  __$$ResetImplCopyWithImpl(
      _$ResetImpl _value, $Res Function(_$ResetImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ResetImpl implements _Reset {
  const _$ResetImpl();

  @override
  String toString() {
    return 'AutonomousRegistrationEvent.reset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTerms,
    required TResult Function(String cpf) checkCpf,
    required TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)
        register,
    required TResult Function() reset,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTerms,
    TResult? Function(String cpf)? checkCpf,
    TResult? Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult? Function()? reset,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTerms,
    TResult Function(String cpf)? checkCpf,
    TResult Function(
            String name,
            String cpf,
            String phone,
            String? birthDate,
            String? email,
            String password,
            bool termsAccepted,
            String? termsVersion)?
        register,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadTerms value) loadTerms,
    required TResult Function(_CheckCpf value) checkCpf,
    required TResult Function(_Register value) register,
    required TResult Function(_Reset value) reset,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadTerms value)? loadTerms,
    TResult? Function(_CheckCpf value)? checkCpf,
    TResult? Function(_Register value)? register,
    TResult? Function(_Reset value)? reset,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadTerms value)? loadTerms,
    TResult Function(_CheckCpf value)? checkCpf,
    TResult Function(_Register value)? register,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class _Reset implements AutonomousRegistrationEvent {
  const factory _Reset() = _$ResetImpl;
}

/// @nodoc
mixin _$AutonomousRegistrationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TermsVersionModel? terms) termsLoaded,
    required TResult Function(bool exists) cpfChecked,
    required TResult Function(RegisterAutonomousResponse response) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TermsVersionModel? terms)? termsLoaded,
    TResult? Function(bool exists)? cpfChecked,
    TResult? Function(RegisterAutonomousResponse response)? success,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TermsVersionModel? terms)? termsLoaded,
    TResult Function(bool exists)? cpfChecked,
    TResult Function(RegisterAutonomousResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_TermsLoaded value) termsLoaded,
    required TResult Function(_CpfChecked value) cpfChecked,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_TermsLoaded value)? termsLoaded,
    TResult? Function(_CpfChecked value)? cpfChecked,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_TermsLoaded value)? termsLoaded,
    TResult Function(_CpfChecked value)? cpfChecked,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutonomousRegistrationStateCopyWith<$Res> {
  factory $AutonomousRegistrationStateCopyWith(
          AutonomousRegistrationState value,
          $Res Function(AutonomousRegistrationState) then) =
      _$AutonomousRegistrationStateCopyWithImpl<$Res,
          AutonomousRegistrationState>;
}

/// @nodoc
class _$AutonomousRegistrationStateCopyWithImpl<$Res,
        $Val extends AutonomousRegistrationState>
    implements $AutonomousRegistrationStateCopyWith<$Res> {
  _$AutonomousRegistrationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AutonomousRegistrationState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TermsVersionModel? terms) termsLoaded,
    required TResult Function(bool exists) cpfChecked,
    required TResult Function(RegisterAutonomousResponse response) success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TermsVersionModel? terms)? termsLoaded,
    TResult? Function(bool exists)? cpfChecked,
    TResult? Function(RegisterAutonomousResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TermsVersionModel? terms)? termsLoaded,
    TResult Function(bool exists)? cpfChecked,
    TResult Function(RegisterAutonomousResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_TermsLoaded value) termsLoaded,
    required TResult Function(_CpfChecked value) cpfChecked,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_TermsLoaded value)? termsLoaded,
    TResult? Function(_CpfChecked value)? cpfChecked,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_TermsLoaded value)? termsLoaded,
    TResult Function(_CpfChecked value)? cpfChecked,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AutonomousRegistrationState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'AutonomousRegistrationState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TermsVersionModel? terms) termsLoaded,
    required TResult Function(bool exists) cpfChecked,
    required TResult Function(RegisterAutonomousResponse response) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TermsVersionModel? terms)? termsLoaded,
    TResult? Function(bool exists)? cpfChecked,
    TResult? Function(RegisterAutonomousResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TermsVersionModel? terms)? termsLoaded,
    TResult Function(bool exists)? cpfChecked,
    TResult Function(RegisterAutonomousResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_TermsLoaded value) termsLoaded,
    required TResult Function(_CpfChecked value) cpfChecked,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_TermsLoaded value)? termsLoaded,
    TResult? Function(_CpfChecked value)? cpfChecked,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_TermsLoaded value)? termsLoaded,
    TResult Function(_CpfChecked value)? cpfChecked,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements AutonomousRegistrationState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$TermsLoadedImplCopyWith<$Res> {
  factory _$$TermsLoadedImplCopyWith(
          _$TermsLoadedImpl value, $Res Function(_$TermsLoadedImpl) then) =
      __$$TermsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TermsVersionModel? terms});

  $TermsVersionModelCopyWith<$Res>? get terms;
}

/// @nodoc
class __$$TermsLoadedImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationStateCopyWithImpl<$Res, _$TermsLoadedImpl>
    implements _$$TermsLoadedImplCopyWith<$Res> {
  __$$TermsLoadedImplCopyWithImpl(
      _$TermsLoadedImpl _value, $Res Function(_$TermsLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? terms = freezed,
  }) {
    return _then(_$TermsLoadedImpl(
      freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as TermsVersionModel?,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TermsVersionModelCopyWith<$Res>? get terms {
    if (_value.terms == null) {
      return null;
    }

    return $TermsVersionModelCopyWith<$Res>(_value.terms!, (value) {
      return _then(_value.copyWith(terms: value));
    });
  }
}

/// @nodoc

class _$TermsLoadedImpl implements _TermsLoaded {
  const _$TermsLoadedImpl(this.terms);

  @override
  final TermsVersionModel? terms;

  @override
  String toString() {
    return 'AutonomousRegistrationState.termsLoaded(terms: $terms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TermsLoadedImpl &&
            (identical(other.terms, terms) || other.terms == terms));
  }

  @override
  int get hashCode => Object.hash(runtimeType, terms);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TermsLoadedImplCopyWith<_$TermsLoadedImpl> get copyWith =>
      __$$TermsLoadedImplCopyWithImpl<_$TermsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TermsVersionModel? terms) termsLoaded,
    required TResult Function(bool exists) cpfChecked,
    required TResult Function(RegisterAutonomousResponse response) success,
    required TResult Function(String message) error,
  }) {
    return termsLoaded(terms);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TermsVersionModel? terms)? termsLoaded,
    TResult? Function(bool exists)? cpfChecked,
    TResult? Function(RegisterAutonomousResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return termsLoaded?.call(terms);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TermsVersionModel? terms)? termsLoaded,
    TResult Function(bool exists)? cpfChecked,
    TResult Function(RegisterAutonomousResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (termsLoaded != null) {
      return termsLoaded(terms);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_TermsLoaded value) termsLoaded,
    required TResult Function(_CpfChecked value) cpfChecked,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return termsLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_TermsLoaded value)? termsLoaded,
    TResult? Function(_CpfChecked value)? cpfChecked,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return termsLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_TermsLoaded value)? termsLoaded,
    TResult Function(_CpfChecked value)? cpfChecked,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (termsLoaded != null) {
      return termsLoaded(this);
    }
    return orElse();
  }
}

abstract class _TermsLoaded implements AutonomousRegistrationState {
  const factory _TermsLoaded(final TermsVersionModel? terms) =
      _$TermsLoadedImpl;

  TermsVersionModel? get terms;
  @JsonKey(ignore: true)
  _$$TermsLoadedImplCopyWith<_$TermsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CpfCheckedImplCopyWith<$Res> {
  factory _$$CpfCheckedImplCopyWith(
          _$CpfCheckedImpl value, $Res Function(_$CpfCheckedImpl) then) =
      __$$CpfCheckedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool exists});
}

/// @nodoc
class __$$CpfCheckedImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationStateCopyWithImpl<$Res, _$CpfCheckedImpl>
    implements _$$CpfCheckedImplCopyWith<$Res> {
  __$$CpfCheckedImplCopyWithImpl(
      _$CpfCheckedImpl _value, $Res Function(_$CpfCheckedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exists = null,
  }) {
    return _then(_$CpfCheckedImpl(
      exists: null == exists
          ? _value.exists
          : exists // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CpfCheckedImpl implements _CpfChecked {
  const _$CpfCheckedImpl({required this.exists});

  @override
  final bool exists;

  @override
  String toString() {
    return 'AutonomousRegistrationState.cpfChecked(exists: $exists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CpfCheckedImpl &&
            (identical(other.exists, exists) || other.exists == exists));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exists);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CpfCheckedImplCopyWith<_$CpfCheckedImpl> get copyWith =>
      __$$CpfCheckedImplCopyWithImpl<_$CpfCheckedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TermsVersionModel? terms) termsLoaded,
    required TResult Function(bool exists) cpfChecked,
    required TResult Function(RegisterAutonomousResponse response) success,
    required TResult Function(String message) error,
  }) {
    return cpfChecked(exists);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TermsVersionModel? terms)? termsLoaded,
    TResult? Function(bool exists)? cpfChecked,
    TResult? Function(RegisterAutonomousResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return cpfChecked?.call(exists);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TermsVersionModel? terms)? termsLoaded,
    TResult Function(bool exists)? cpfChecked,
    TResult Function(RegisterAutonomousResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (cpfChecked != null) {
      return cpfChecked(exists);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_TermsLoaded value) termsLoaded,
    required TResult Function(_CpfChecked value) cpfChecked,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return cpfChecked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_TermsLoaded value)? termsLoaded,
    TResult? Function(_CpfChecked value)? cpfChecked,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return cpfChecked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_TermsLoaded value)? termsLoaded,
    TResult Function(_CpfChecked value)? cpfChecked,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (cpfChecked != null) {
      return cpfChecked(this);
    }
    return orElse();
  }
}

abstract class _CpfChecked implements AutonomousRegistrationState {
  const factory _CpfChecked({required final bool exists}) = _$CpfCheckedImpl;

  bool get exists;
  @JsonKey(ignore: true)
  _$$CpfCheckedImplCopyWith<_$CpfCheckedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RegisterAutonomousResponse response});

  $RegisterAutonomousResponseCopyWith<$Res> get response;
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
  }) {
    return _then(_$SuccessImpl(
      null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as RegisterAutonomousResponse,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $RegisterAutonomousResponseCopyWith<$Res> get response {
    return $RegisterAutonomousResponseCopyWith<$Res>(_value.response, (value) {
      return _then(_value.copyWith(response: value));
    });
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl(this.response);

  @override
  final RegisterAutonomousResponse response;

  @override
  String toString() {
    return 'AutonomousRegistrationState.success(response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, response);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TermsVersionModel? terms) termsLoaded,
    required TResult Function(bool exists) cpfChecked,
    required TResult Function(RegisterAutonomousResponse response) success,
    required TResult Function(String message) error,
  }) {
    return success(response);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TermsVersionModel? terms)? termsLoaded,
    TResult? Function(bool exists)? cpfChecked,
    TResult? Function(RegisterAutonomousResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(response);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TermsVersionModel? terms)? termsLoaded,
    TResult Function(bool exists)? cpfChecked,
    TResult Function(RegisterAutonomousResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(response);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_TermsLoaded value) termsLoaded,
    required TResult Function(_CpfChecked value) cpfChecked,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_TermsLoaded value)? termsLoaded,
    TResult? Function(_CpfChecked value)? cpfChecked,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_TermsLoaded value)? termsLoaded,
    TResult Function(_CpfChecked value)? cpfChecked,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success implements AutonomousRegistrationState {
  const factory _Success(final RegisterAutonomousResponse response) =
      _$SuccessImpl;

  RegisterAutonomousResponse get response;
  @JsonKey(ignore: true)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$AutonomousRegistrationStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AutonomousRegistrationState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TermsVersionModel? terms) termsLoaded,
    required TResult Function(bool exists) cpfChecked,
    required TResult Function(RegisterAutonomousResponse response) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TermsVersionModel? terms)? termsLoaded,
    TResult? Function(bool exists)? cpfChecked,
    TResult? Function(RegisterAutonomousResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TermsVersionModel? terms)? termsLoaded,
    TResult Function(bool exists)? cpfChecked,
    TResult Function(RegisterAutonomousResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_TermsLoaded value) termsLoaded,
    required TResult Function(_CpfChecked value) cpfChecked,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_TermsLoaded value)? termsLoaded,
    TResult? Function(_CpfChecked value)? cpfChecked,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_TermsLoaded value)? termsLoaded,
    TResult Function(_CpfChecked value)? cpfChecked,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements AutonomousRegistrationState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
