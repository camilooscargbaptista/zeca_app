// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'autonomous_vehicles_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AutonomousVehiclesEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(CreateAutonomousVehicleRequest request) create,
    required TResult Function(String id, UpdateAutonomousVehicleRequest request)
        update,
    required TResult Function(String id) delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(CreateAutonomousVehicleRequest request)? create,
    TResult? Function(String id, UpdateAutonomousVehicleRequest request)?
        update,
    TResult? Function(String id)? delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(CreateAutonomousVehicleRequest request)? create,
    TResult Function(String id, UpdateAutonomousVehicleRequest request)? update,
    TResult Function(String id)? delete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Create value) create,
    required TResult Function(_Update value) update,
    required TResult Function(_Delete value) delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Create value)? create,
    TResult? Function(_Update value)? update,
    TResult? Function(_Delete value)? delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Create value)? create,
    TResult Function(_Update value)? update,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutonomousVehiclesEventCopyWith<$Res> {
  factory $AutonomousVehiclesEventCopyWith(AutonomousVehiclesEvent value,
          $Res Function(AutonomousVehiclesEvent) then) =
      _$AutonomousVehiclesEventCopyWithImpl<$Res, AutonomousVehiclesEvent>;
}

/// @nodoc
class _$AutonomousVehiclesEventCopyWithImpl<$Res,
        $Val extends AutonomousVehiclesEvent>
    implements $AutonomousVehiclesEventCopyWith<$Res> {
  _$AutonomousVehiclesEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadImplCopyWith<$Res> {
  factory _$$LoadImplCopyWith(
          _$LoadImpl value, $Res Function(_$LoadImpl) then) =
      __$$LoadImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$LoadImpl>
    implements _$$LoadImplCopyWith<$Res> {
  __$$LoadImplCopyWithImpl(_$LoadImpl _value, $Res Function(_$LoadImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadImpl implements _Load {
  const _$LoadImpl();

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.load()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(CreateAutonomousVehicleRequest request) create,
    required TResult Function(String id, UpdateAutonomousVehicleRequest request)
        update,
    required TResult Function(String id) delete,
  }) {
    return load();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(CreateAutonomousVehicleRequest request)? create,
    TResult? Function(String id, UpdateAutonomousVehicleRequest request)?
        update,
    TResult? Function(String id)? delete,
  }) {
    return load?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(CreateAutonomousVehicleRequest request)? create,
    TResult Function(String id, UpdateAutonomousVehicleRequest request)? update,
    TResult Function(String id)? delete,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Create value) create,
    required TResult Function(_Update value) update,
    required TResult Function(_Delete value) delete,
  }) {
    return load(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Create value)? create,
    TResult? Function(_Update value)? update,
    TResult? Function(_Delete value)? delete,
  }) {
    return load?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Create value)? create,
    TResult Function(_Update value)? update,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load(this);
    }
    return orElse();
  }
}

abstract class _Load implements AutonomousVehiclesEvent {
  const factory _Load() = _$LoadImpl;
}

/// @nodoc
abstract class _$$CreateImplCopyWith<$Res> {
  factory _$$CreateImplCopyWith(
          _$CreateImpl value, $Res Function(_$CreateImpl) then) =
      __$$CreateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CreateAutonomousVehicleRequest request});

  $CreateAutonomousVehicleRequestCopyWith<$Res> get request;
}

/// @nodoc
class __$$CreateImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$CreateImpl>
    implements _$$CreateImplCopyWith<$Res> {
  __$$CreateImplCopyWithImpl(
      _$CreateImpl _value, $Res Function(_$CreateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? request = null,
  }) {
    return _then(_$CreateImpl(
      null == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as CreateAutonomousVehicleRequest,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $CreateAutonomousVehicleRequestCopyWith<$Res> get request {
    return $CreateAutonomousVehicleRequestCopyWith<$Res>(_value.request,
        (value) {
      return _then(_value.copyWith(request: value));
    });
  }
}

/// @nodoc

class _$CreateImpl implements _Create {
  const _$CreateImpl(this.request);

  @override
  final CreateAutonomousVehicleRequest request;

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.create(request: $request)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateImpl &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateImplCopyWith<_$CreateImpl> get copyWith =>
      __$$CreateImplCopyWithImpl<_$CreateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(CreateAutonomousVehicleRequest request) create,
    required TResult Function(String id, UpdateAutonomousVehicleRequest request)
        update,
    required TResult Function(String id) delete,
  }) {
    return create(request);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(CreateAutonomousVehicleRequest request)? create,
    TResult? Function(String id, UpdateAutonomousVehicleRequest request)?
        update,
    TResult? Function(String id)? delete,
  }) {
    return create?.call(request);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(CreateAutonomousVehicleRequest request)? create,
    TResult Function(String id, UpdateAutonomousVehicleRequest request)? update,
    TResult Function(String id)? delete,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(request);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Create value) create,
    required TResult Function(_Update value) update,
    required TResult Function(_Delete value) delete,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Create value)? create,
    TResult? Function(_Update value)? update,
    TResult? Function(_Delete value)? delete,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Create value)? create,
    TResult Function(_Update value)? update,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }
}

abstract class _Create implements AutonomousVehiclesEvent {
  const factory _Create(final CreateAutonomousVehicleRequest request) =
      _$CreateImpl;

  CreateAutonomousVehicleRequest get request;
  @JsonKey(ignore: true)
  _$$CreateImplCopyWith<_$CreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateImplCopyWith<$Res> {
  factory _$$UpdateImplCopyWith(
          _$UpdateImpl value, $Res Function(_$UpdateImpl) then) =
      __$$UpdateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id, UpdateAutonomousVehicleRequest request});

  $UpdateAutonomousVehicleRequestCopyWith<$Res> get request;
}

/// @nodoc
class __$$UpdateImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$UpdateImpl>
    implements _$$UpdateImplCopyWith<$Res> {
  __$$UpdateImplCopyWithImpl(
      _$UpdateImpl _value, $Res Function(_$UpdateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? request = null,
  }) {
    return _then(_$UpdateImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      null == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as UpdateAutonomousVehicleRequest,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UpdateAutonomousVehicleRequestCopyWith<$Res> get request {
    return $UpdateAutonomousVehicleRequestCopyWith<$Res>(_value.request,
        (value) {
      return _then(_value.copyWith(request: value));
    });
  }
}

/// @nodoc

class _$UpdateImpl implements _Update {
  const _$UpdateImpl(this.id, this.request);

  @override
  final String id;
  @override
  final UpdateAutonomousVehicleRequest request;

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.update(id: $id, request: $request)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, request);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateImplCopyWith<_$UpdateImpl> get copyWith =>
      __$$UpdateImplCopyWithImpl<_$UpdateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(CreateAutonomousVehicleRequest request) create,
    required TResult Function(String id, UpdateAutonomousVehicleRequest request)
        update,
    required TResult Function(String id) delete,
  }) {
    return update(id, request);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(CreateAutonomousVehicleRequest request)? create,
    TResult? Function(String id, UpdateAutonomousVehicleRequest request)?
        update,
    TResult? Function(String id)? delete,
  }) {
    return update?.call(id, request);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(CreateAutonomousVehicleRequest request)? create,
    TResult Function(String id, UpdateAutonomousVehicleRequest request)? update,
    TResult Function(String id)? delete,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(id, request);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Create value) create,
    required TResult Function(_Update value) update,
    required TResult Function(_Delete value) delete,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Create value)? create,
    TResult? Function(_Update value)? update,
    TResult? Function(_Delete value)? delete,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Create value)? create,
    TResult Function(_Update value)? update,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class _Update implements AutonomousVehiclesEvent {
  const factory _Update(
          final String id, final UpdateAutonomousVehicleRequest request) =
      _$UpdateImpl;

  String get id;
  UpdateAutonomousVehicleRequest get request;
  @JsonKey(ignore: true)
  _$$UpdateImplCopyWith<_$UpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteImplCopyWith<$Res> {
  factory _$$DeleteImplCopyWith(
          _$DeleteImpl value, $Res Function(_$DeleteImpl) then) =
      __$$DeleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$DeleteImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$DeleteImpl>
    implements _$$DeleteImplCopyWith<$Res> {
  __$$DeleteImplCopyWithImpl(
      _$DeleteImpl _value, $Res Function(_$DeleteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$DeleteImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteImpl implements _Delete {
  const _$DeleteImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.delete(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteImplCopyWith<_$DeleteImpl> get copyWith =>
      __$$DeleteImplCopyWithImpl<_$DeleteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(CreateAutonomousVehicleRequest request) create,
    required TResult Function(String id, UpdateAutonomousVehicleRequest request)
        update,
    required TResult Function(String id) delete,
  }) {
    return delete(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(CreateAutonomousVehicleRequest request)? create,
    TResult? Function(String id, UpdateAutonomousVehicleRequest request)?
        update,
    TResult? Function(String id)? delete,
  }) {
    return delete?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(CreateAutonomousVehicleRequest request)? create,
    TResult Function(String id, UpdateAutonomousVehicleRequest request)? update,
    TResult Function(String id)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Create value) create,
    required TResult Function(_Update value) update,
    required TResult Function(_Delete value) delete,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Create value)? create,
    TResult? Function(_Update value)? update,
    TResult? Function(_Delete value)? delete,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Create value)? create,
    TResult Function(_Update value)? update,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class _Delete implements AutonomousVehiclesEvent {
  const factory _Delete(final String id) = _$DeleteImpl;

  String get id;
  @JsonKey(ignore: true)
  _$$DeleteImplCopyWith<_$DeleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AutonomousVehiclesState {
  List<AutonomousVehicleModel> get vehicles =>
      throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get successMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AutonomousVehiclesStateCopyWith<AutonomousVehiclesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutonomousVehiclesStateCopyWith<$Res> {
  factory $AutonomousVehiclesStateCopyWith(AutonomousVehiclesState value,
          $Res Function(AutonomousVehiclesState) then) =
      _$AutonomousVehiclesStateCopyWithImpl<$Res, AutonomousVehiclesState>;
  @useResult
  $Res call(
      {List<AutonomousVehicleModel> vehicles,
      int count,
      int limit,
      bool isLoading,
      bool isSaving,
      String? errorMessage,
      String? successMessage});
}

/// @nodoc
class _$AutonomousVehiclesStateCopyWithImpl<$Res,
        $Val extends AutonomousVehiclesState>
    implements $AutonomousVehiclesStateCopyWith<$Res> {
  _$AutonomousVehiclesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicles = null,
    Object? count = null,
    Object? limit = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_value.copyWith(
      vehicles: null == vehicles
          ? _value.vehicles
          : vehicles // ignore: cast_nullable_to_non_nullable
              as List<AutonomousVehicleModel>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AutonomousVehiclesStateImplCopyWith<$Res>
    implements $AutonomousVehiclesStateCopyWith<$Res> {
  factory _$$AutonomousVehiclesStateImplCopyWith(
          _$AutonomousVehiclesStateImpl value,
          $Res Function(_$AutonomousVehiclesStateImpl) then) =
      __$$AutonomousVehiclesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AutonomousVehicleModel> vehicles,
      int count,
      int limit,
      bool isLoading,
      bool isSaving,
      String? errorMessage,
      String? successMessage});
}

/// @nodoc
class __$$AutonomousVehiclesStateImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesStateCopyWithImpl<$Res,
        _$AutonomousVehiclesStateImpl>
    implements _$$AutonomousVehiclesStateImplCopyWith<$Res> {
  __$$AutonomousVehiclesStateImplCopyWithImpl(
      _$AutonomousVehiclesStateImpl _value,
      $Res Function(_$AutonomousVehiclesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicles = null,
    Object? count = null,
    Object? limit = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$AutonomousVehiclesStateImpl(
      vehicles: null == vehicles
          ? _value._vehicles
          : vehicles // ignore: cast_nullable_to_non_nullable
              as List<AutonomousVehicleModel>,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AutonomousVehiclesStateImpl implements _AutonomousVehiclesState {
  const _$AutonomousVehiclesStateImpl(
      {final List<AutonomousVehicleModel> vehicles = const [],
      this.count = 0,
      this.limit = 3,
      this.isLoading = false,
      this.isSaving = false,
      this.errorMessage,
      this.successMessage})
      : _vehicles = vehicles;

  final List<AutonomousVehicleModel> _vehicles;
  @override
  @JsonKey()
  List<AutonomousVehicleModel> get vehicles {
    if (_vehicles is EqualUnmodifiableListView) return _vehicles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vehicles);
  }

  @override
  @JsonKey()
  final int count;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? errorMessage;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'AutonomousVehiclesState(vehicles: $vehicles, count: $count, limit: $limit, isLoading: $isLoading, isSaving: $isSaving, errorMessage: $errorMessage, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutonomousVehiclesStateImpl &&
            const DeepCollectionEquality().equals(other._vehicles, _vehicles) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_vehicles),
      count,
      limit,
      isLoading,
      isSaving,
      errorMessage,
      successMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AutonomousVehiclesStateImplCopyWith<_$AutonomousVehiclesStateImpl>
      get copyWith => __$$AutonomousVehiclesStateImplCopyWithImpl<
          _$AutonomousVehiclesStateImpl>(this, _$identity);
}

abstract class _AutonomousVehiclesState implements AutonomousVehiclesState {
  const factory _AutonomousVehiclesState(
      {final List<AutonomousVehicleModel> vehicles,
      final int count,
      final int limit,
      final bool isLoading,
      final bool isSaving,
      final String? errorMessage,
      final String? successMessage}) = _$AutonomousVehiclesStateImpl;

  @override
  List<AutonomousVehicleModel> get vehicles;
  @override
  int get count;
  @override
  int get limit;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  String? get errorMessage;
  @override
  String? get successMessage;
  @override
  @JsonKey(ignore: true)
  _$$AutonomousVehiclesStateImplCopyWith<_$AutonomousVehiclesStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
