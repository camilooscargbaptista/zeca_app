// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'autonomous_vehicles_event.dart';

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
    required TResult Function() loadVehicles,
    required TResult Function(List<Map<String, dynamic>> vehicles, int limit)
        vehiclesLoaded,
    required TResult Function(String error) loadFailed,
    required TResult Function(String vehicleId) startDelete,
    required TResult Function() deleteCompleted,
    required TResult Function(String error) deleteFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadVehicles,
    TResult? Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult? Function(String error)? loadFailed,
    TResult? Function(String vehicleId)? startDelete,
    TResult? Function()? deleteCompleted,
    TResult? Function(String error)? deleteFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadVehicles,
    TResult Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult Function(String error)? loadFailed,
    TResult Function(String vehicleId)? startDelete,
    TResult Function()? deleteCompleted,
    TResult Function(String error)? deleteFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadVehicles value) loadVehicles,
    required TResult Function(_VehiclesLoaded value) vehiclesLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_StartDelete value) startDelete,
    required TResult Function(_DeleteCompleted value) deleteCompleted,
    required TResult Function(_DeleteFailed value) deleteFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadVehicles value)? loadVehicles,
    TResult? Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_StartDelete value)? startDelete,
    TResult? Function(_DeleteCompleted value)? deleteCompleted,
    TResult? Function(_DeleteFailed value)? deleteFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadVehicles value)? loadVehicles,
    TResult Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_StartDelete value)? startDelete,
    TResult Function(_DeleteCompleted value)? deleteCompleted,
    TResult Function(_DeleteFailed value)? deleteFailed,
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
abstract class _$$LoadVehiclesImplCopyWith<$Res> {
  factory _$$LoadVehiclesImplCopyWith(
          _$LoadVehiclesImpl value, $Res Function(_$LoadVehiclesImpl) then) =
      __$$LoadVehiclesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadVehiclesImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$LoadVehiclesImpl>
    implements _$$LoadVehiclesImplCopyWith<$Res> {
  __$$LoadVehiclesImplCopyWithImpl(
      _$LoadVehiclesImpl _value, $Res Function(_$LoadVehiclesImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadVehiclesImpl implements _LoadVehicles {
  const _$LoadVehiclesImpl();

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.loadVehicles()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadVehiclesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadVehicles,
    required TResult Function(List<Map<String, dynamic>> vehicles, int limit)
        vehiclesLoaded,
    required TResult Function(String error) loadFailed,
    required TResult Function(String vehicleId) startDelete,
    required TResult Function() deleteCompleted,
    required TResult Function(String error) deleteFailed,
  }) {
    return loadVehicles();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadVehicles,
    TResult? Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult? Function(String error)? loadFailed,
    TResult? Function(String vehicleId)? startDelete,
    TResult? Function()? deleteCompleted,
    TResult? Function(String error)? deleteFailed,
  }) {
    return loadVehicles?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadVehicles,
    TResult Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult Function(String error)? loadFailed,
    TResult Function(String vehicleId)? startDelete,
    TResult Function()? deleteCompleted,
    TResult Function(String error)? deleteFailed,
    required TResult orElse(),
  }) {
    if (loadVehicles != null) {
      return loadVehicles();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadVehicles value) loadVehicles,
    required TResult Function(_VehiclesLoaded value) vehiclesLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_StartDelete value) startDelete,
    required TResult Function(_DeleteCompleted value) deleteCompleted,
    required TResult Function(_DeleteFailed value) deleteFailed,
  }) {
    return loadVehicles(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadVehicles value)? loadVehicles,
    TResult? Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_StartDelete value)? startDelete,
    TResult? Function(_DeleteCompleted value)? deleteCompleted,
    TResult? Function(_DeleteFailed value)? deleteFailed,
  }) {
    return loadVehicles?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadVehicles value)? loadVehicles,
    TResult Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_StartDelete value)? startDelete,
    TResult Function(_DeleteCompleted value)? deleteCompleted,
    TResult Function(_DeleteFailed value)? deleteFailed,
    required TResult orElse(),
  }) {
    if (loadVehicles != null) {
      return loadVehicles(this);
    }
    return orElse();
  }
}

abstract class _LoadVehicles implements AutonomousVehiclesEvent {
  const factory _LoadVehicles() = _$LoadVehiclesImpl;
}

/// @nodoc
abstract class _$$VehiclesLoadedImplCopyWith<$Res> {
  factory _$$VehiclesLoadedImplCopyWith(_$VehiclesLoadedImpl value,
          $Res Function(_$VehiclesLoadedImpl) then) =
      __$$VehiclesLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Map<String, dynamic>> vehicles, int limit});
}

/// @nodoc
class __$$VehiclesLoadedImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$VehiclesLoadedImpl>
    implements _$$VehiclesLoadedImplCopyWith<$Res> {
  __$$VehiclesLoadedImplCopyWithImpl(
      _$VehiclesLoadedImpl _value, $Res Function(_$VehiclesLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicles = null,
    Object? limit = null,
  }) {
    return _then(_$VehiclesLoadedImpl(
      null == vehicles
          ? _value._vehicles
          : vehicles // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$VehiclesLoadedImpl implements _VehiclesLoaded {
  const _$VehiclesLoadedImpl(
      final List<Map<String, dynamic>> vehicles, this.limit)
      : _vehicles = vehicles;

  final List<Map<String, dynamic>> _vehicles;
  @override
  List<Map<String, dynamic>> get vehicles {
    if (_vehicles is EqualUnmodifiableListView) return _vehicles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vehicles);
  }

  @override
  final int limit;

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.vehiclesLoaded(vehicles: $vehicles, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehiclesLoadedImpl &&
            const DeepCollectionEquality().equals(other._vehicles, _vehicles) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_vehicles), limit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VehiclesLoadedImplCopyWith<_$VehiclesLoadedImpl> get copyWith =>
      __$$VehiclesLoadedImplCopyWithImpl<_$VehiclesLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadVehicles,
    required TResult Function(List<Map<String, dynamic>> vehicles, int limit)
        vehiclesLoaded,
    required TResult Function(String error) loadFailed,
    required TResult Function(String vehicleId) startDelete,
    required TResult Function() deleteCompleted,
    required TResult Function(String error) deleteFailed,
  }) {
    return vehiclesLoaded(vehicles, limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadVehicles,
    TResult? Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult? Function(String error)? loadFailed,
    TResult? Function(String vehicleId)? startDelete,
    TResult? Function()? deleteCompleted,
    TResult? Function(String error)? deleteFailed,
  }) {
    return vehiclesLoaded?.call(vehicles, limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadVehicles,
    TResult Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult Function(String error)? loadFailed,
    TResult Function(String vehicleId)? startDelete,
    TResult Function()? deleteCompleted,
    TResult Function(String error)? deleteFailed,
    required TResult orElse(),
  }) {
    if (vehiclesLoaded != null) {
      return vehiclesLoaded(vehicles, limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadVehicles value) loadVehicles,
    required TResult Function(_VehiclesLoaded value) vehiclesLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_StartDelete value) startDelete,
    required TResult Function(_DeleteCompleted value) deleteCompleted,
    required TResult Function(_DeleteFailed value) deleteFailed,
  }) {
    return vehiclesLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadVehicles value)? loadVehicles,
    TResult? Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_StartDelete value)? startDelete,
    TResult? Function(_DeleteCompleted value)? deleteCompleted,
    TResult? Function(_DeleteFailed value)? deleteFailed,
  }) {
    return vehiclesLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadVehicles value)? loadVehicles,
    TResult Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_StartDelete value)? startDelete,
    TResult Function(_DeleteCompleted value)? deleteCompleted,
    TResult Function(_DeleteFailed value)? deleteFailed,
    required TResult orElse(),
  }) {
    if (vehiclesLoaded != null) {
      return vehiclesLoaded(this);
    }
    return orElse();
  }
}

abstract class _VehiclesLoaded implements AutonomousVehiclesEvent {
  const factory _VehiclesLoaded(
          final List<Map<String, dynamic>> vehicles, final int limit) =
      _$VehiclesLoadedImpl;

  List<Map<String, dynamic>> get vehicles;
  int get limit;
  @JsonKey(ignore: true)
  _$$VehiclesLoadedImplCopyWith<_$VehiclesLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadFailedImplCopyWith<$Res> {
  factory _$$LoadFailedImplCopyWith(
          _$LoadFailedImpl value, $Res Function(_$LoadFailedImpl) then) =
      __$$LoadFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$LoadFailedImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$LoadFailedImpl>
    implements _$$LoadFailedImplCopyWith<$Res> {
  __$$LoadFailedImplCopyWithImpl(
      _$LoadFailedImpl _value, $Res Function(_$LoadFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$LoadFailedImpl(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadFailedImpl implements _LoadFailed {
  const _$LoadFailedImpl(this.error);

  @override
  final String error;

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.loadFailed(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadFailedImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadFailedImplCopyWith<_$LoadFailedImpl> get copyWith =>
      __$$LoadFailedImplCopyWithImpl<_$LoadFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadVehicles,
    required TResult Function(List<Map<String, dynamic>> vehicles, int limit)
        vehiclesLoaded,
    required TResult Function(String error) loadFailed,
    required TResult Function(String vehicleId) startDelete,
    required TResult Function() deleteCompleted,
    required TResult Function(String error) deleteFailed,
  }) {
    return loadFailed(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadVehicles,
    TResult? Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult? Function(String error)? loadFailed,
    TResult? Function(String vehicleId)? startDelete,
    TResult? Function()? deleteCompleted,
    TResult? Function(String error)? deleteFailed,
  }) {
    return loadFailed?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadVehicles,
    TResult Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult Function(String error)? loadFailed,
    TResult Function(String vehicleId)? startDelete,
    TResult Function()? deleteCompleted,
    TResult Function(String error)? deleteFailed,
    required TResult orElse(),
  }) {
    if (loadFailed != null) {
      return loadFailed(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadVehicles value) loadVehicles,
    required TResult Function(_VehiclesLoaded value) vehiclesLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_StartDelete value) startDelete,
    required TResult Function(_DeleteCompleted value) deleteCompleted,
    required TResult Function(_DeleteFailed value) deleteFailed,
  }) {
    return loadFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadVehicles value)? loadVehicles,
    TResult? Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_StartDelete value)? startDelete,
    TResult? Function(_DeleteCompleted value)? deleteCompleted,
    TResult? Function(_DeleteFailed value)? deleteFailed,
  }) {
    return loadFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadVehicles value)? loadVehicles,
    TResult Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_StartDelete value)? startDelete,
    TResult Function(_DeleteCompleted value)? deleteCompleted,
    TResult Function(_DeleteFailed value)? deleteFailed,
    required TResult orElse(),
  }) {
    if (loadFailed != null) {
      return loadFailed(this);
    }
    return orElse();
  }
}

abstract class _LoadFailed implements AutonomousVehiclesEvent {
  const factory _LoadFailed(final String error) = _$LoadFailedImpl;

  String get error;
  @JsonKey(ignore: true)
  _$$LoadFailedImplCopyWith<_$LoadFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StartDeleteImplCopyWith<$Res> {
  factory _$$StartDeleteImplCopyWith(
          _$StartDeleteImpl value, $Res Function(_$StartDeleteImpl) then) =
      __$$StartDeleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String vehicleId});
}

/// @nodoc
class __$$StartDeleteImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$StartDeleteImpl>
    implements _$$StartDeleteImplCopyWith<$Res> {
  __$$StartDeleteImplCopyWithImpl(
      _$StartDeleteImpl _value, $Res Function(_$StartDeleteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
  }) {
    return _then(_$StartDeleteImpl(
      null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StartDeleteImpl implements _StartDelete {
  const _$StartDeleteImpl(this.vehicleId);

  @override
  final String vehicleId;

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.startDelete(vehicleId: $vehicleId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartDeleteImpl &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, vehicleId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StartDeleteImplCopyWith<_$StartDeleteImpl> get copyWith =>
      __$$StartDeleteImplCopyWithImpl<_$StartDeleteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadVehicles,
    required TResult Function(List<Map<String, dynamic>> vehicles, int limit)
        vehiclesLoaded,
    required TResult Function(String error) loadFailed,
    required TResult Function(String vehicleId) startDelete,
    required TResult Function() deleteCompleted,
    required TResult Function(String error) deleteFailed,
  }) {
    return startDelete(vehicleId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadVehicles,
    TResult? Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult? Function(String error)? loadFailed,
    TResult? Function(String vehicleId)? startDelete,
    TResult? Function()? deleteCompleted,
    TResult? Function(String error)? deleteFailed,
  }) {
    return startDelete?.call(vehicleId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadVehicles,
    TResult Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult Function(String error)? loadFailed,
    TResult Function(String vehicleId)? startDelete,
    TResult Function()? deleteCompleted,
    TResult Function(String error)? deleteFailed,
    required TResult orElse(),
  }) {
    if (startDelete != null) {
      return startDelete(vehicleId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadVehicles value) loadVehicles,
    required TResult Function(_VehiclesLoaded value) vehiclesLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_StartDelete value) startDelete,
    required TResult Function(_DeleteCompleted value) deleteCompleted,
    required TResult Function(_DeleteFailed value) deleteFailed,
  }) {
    return startDelete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadVehicles value)? loadVehicles,
    TResult? Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_StartDelete value)? startDelete,
    TResult? Function(_DeleteCompleted value)? deleteCompleted,
    TResult? Function(_DeleteFailed value)? deleteFailed,
  }) {
    return startDelete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadVehicles value)? loadVehicles,
    TResult Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_StartDelete value)? startDelete,
    TResult Function(_DeleteCompleted value)? deleteCompleted,
    TResult Function(_DeleteFailed value)? deleteFailed,
    required TResult orElse(),
  }) {
    if (startDelete != null) {
      return startDelete(this);
    }
    return orElse();
  }
}

abstract class _StartDelete implements AutonomousVehiclesEvent {
  const factory _StartDelete(final String vehicleId) = _$StartDeleteImpl;

  String get vehicleId;
  @JsonKey(ignore: true)
  _$$StartDeleteImplCopyWith<_$StartDeleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteCompletedImplCopyWith<$Res> {
  factory _$$DeleteCompletedImplCopyWith(_$DeleteCompletedImpl value,
          $Res Function(_$DeleteCompletedImpl) then) =
      __$$DeleteCompletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeleteCompletedImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$DeleteCompletedImpl>
    implements _$$DeleteCompletedImplCopyWith<$Res> {
  __$$DeleteCompletedImplCopyWithImpl(
      _$DeleteCompletedImpl _value, $Res Function(_$DeleteCompletedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DeleteCompletedImpl implements _DeleteCompleted {
  const _$DeleteCompletedImpl();

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.deleteCompleted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeleteCompletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadVehicles,
    required TResult Function(List<Map<String, dynamic>> vehicles, int limit)
        vehiclesLoaded,
    required TResult Function(String error) loadFailed,
    required TResult Function(String vehicleId) startDelete,
    required TResult Function() deleteCompleted,
    required TResult Function(String error) deleteFailed,
  }) {
    return deleteCompleted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadVehicles,
    TResult? Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult? Function(String error)? loadFailed,
    TResult? Function(String vehicleId)? startDelete,
    TResult? Function()? deleteCompleted,
    TResult? Function(String error)? deleteFailed,
  }) {
    return deleteCompleted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadVehicles,
    TResult Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult Function(String error)? loadFailed,
    TResult Function(String vehicleId)? startDelete,
    TResult Function()? deleteCompleted,
    TResult Function(String error)? deleteFailed,
    required TResult orElse(),
  }) {
    if (deleteCompleted != null) {
      return deleteCompleted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadVehicles value) loadVehicles,
    required TResult Function(_VehiclesLoaded value) vehiclesLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_StartDelete value) startDelete,
    required TResult Function(_DeleteCompleted value) deleteCompleted,
    required TResult Function(_DeleteFailed value) deleteFailed,
  }) {
    return deleteCompleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadVehicles value)? loadVehicles,
    TResult? Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_StartDelete value)? startDelete,
    TResult? Function(_DeleteCompleted value)? deleteCompleted,
    TResult? Function(_DeleteFailed value)? deleteFailed,
  }) {
    return deleteCompleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadVehicles value)? loadVehicles,
    TResult Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_StartDelete value)? startDelete,
    TResult Function(_DeleteCompleted value)? deleteCompleted,
    TResult Function(_DeleteFailed value)? deleteFailed,
    required TResult orElse(),
  }) {
    if (deleteCompleted != null) {
      return deleteCompleted(this);
    }
    return orElse();
  }
}

abstract class _DeleteCompleted implements AutonomousVehiclesEvent {
  const factory _DeleteCompleted() = _$DeleteCompletedImpl;
}

/// @nodoc
abstract class _$$DeleteFailedImplCopyWith<$Res> {
  factory _$$DeleteFailedImplCopyWith(
          _$DeleteFailedImpl value, $Res Function(_$DeleteFailedImpl) then) =
      __$$DeleteFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$DeleteFailedImplCopyWithImpl<$Res>
    extends _$AutonomousVehiclesEventCopyWithImpl<$Res, _$DeleteFailedImpl>
    implements _$$DeleteFailedImplCopyWith<$Res> {
  __$$DeleteFailedImplCopyWithImpl(
      _$DeleteFailedImpl _value, $Res Function(_$DeleteFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$DeleteFailedImpl(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteFailedImpl implements _DeleteFailed {
  const _$DeleteFailedImpl(this.error);

  @override
  final String error;

  @override
  String toString() {
    return 'AutonomousVehiclesEvent.deleteFailed(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteFailedImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteFailedImplCopyWith<_$DeleteFailedImpl> get copyWith =>
      __$$DeleteFailedImplCopyWithImpl<_$DeleteFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadVehicles,
    required TResult Function(List<Map<String, dynamic>> vehicles, int limit)
        vehiclesLoaded,
    required TResult Function(String error) loadFailed,
    required TResult Function(String vehicleId) startDelete,
    required TResult Function() deleteCompleted,
    required TResult Function(String error) deleteFailed,
  }) {
    return deleteFailed(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadVehicles,
    TResult? Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult? Function(String error)? loadFailed,
    TResult? Function(String vehicleId)? startDelete,
    TResult? Function()? deleteCompleted,
    TResult? Function(String error)? deleteFailed,
  }) {
    return deleteFailed?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadVehicles,
    TResult Function(List<Map<String, dynamic>> vehicles, int limit)?
        vehiclesLoaded,
    TResult Function(String error)? loadFailed,
    TResult Function(String vehicleId)? startDelete,
    TResult Function()? deleteCompleted,
    TResult Function(String error)? deleteFailed,
    required TResult orElse(),
  }) {
    if (deleteFailed != null) {
      return deleteFailed(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadVehicles value) loadVehicles,
    required TResult Function(_VehiclesLoaded value) vehiclesLoaded,
    required TResult Function(_LoadFailed value) loadFailed,
    required TResult Function(_StartDelete value) startDelete,
    required TResult Function(_DeleteCompleted value) deleteCompleted,
    required TResult Function(_DeleteFailed value) deleteFailed,
  }) {
    return deleteFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadVehicles value)? loadVehicles,
    TResult? Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult? Function(_LoadFailed value)? loadFailed,
    TResult? Function(_StartDelete value)? startDelete,
    TResult? Function(_DeleteCompleted value)? deleteCompleted,
    TResult? Function(_DeleteFailed value)? deleteFailed,
  }) {
    return deleteFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadVehicles value)? loadVehicles,
    TResult Function(_VehiclesLoaded value)? vehiclesLoaded,
    TResult Function(_LoadFailed value)? loadFailed,
    TResult Function(_StartDelete value)? startDelete,
    TResult Function(_DeleteCompleted value)? deleteCompleted,
    TResult Function(_DeleteFailed value)? deleteFailed,
    required TResult orElse(),
  }) {
    if (deleteFailed != null) {
      return deleteFailed(this);
    }
    return orElse();
  }
}

abstract class _DeleteFailed implements AutonomousVehiclesEvent {
  const factory _DeleteFailed(final String error) = _$DeleteFailedImpl;

  String get error;
  @JsonKey(ignore: true)
  _$$DeleteFailedImplCopyWith<_$DeleteFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
