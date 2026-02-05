// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TripHomeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(
            String vehicleId, String? origin, String? destination)
        startTrip,
    required TResult Function(String tripId) finishTrip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String vehicleId, String? origin, String? destination)?
        startTrip,
    TResult? Function(String tripId)? finishTrip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String vehicleId, String? origin, String? destination)?
        startTrip,
    TResult Function(String tripId)? finishTrip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(StartTripRequested value) startTrip,
    required TResult Function(FinishTripRequested value) finishTrip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(StartTripRequested value)? startTrip,
    TResult? Function(FinishTripRequested value)? finishTrip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(StartTripRequested value)? startTrip,
    TResult Function(FinishTripRequested value)? finishTrip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripHomeEventCopyWith<$Res> {
  factory $TripHomeEventCopyWith(
          TripHomeEvent value, $Res Function(TripHomeEvent) then) =
      _$TripHomeEventCopyWithImpl<$Res, TripHomeEvent>;
}

/// @nodoc
class _$TripHomeEventCopyWithImpl<$Res, $Val extends TripHomeEvent>
    implements $TripHomeEventCopyWith<$Res> {
  _$TripHomeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadActiveTripImplCopyWith<$Res> {
  factory _$$LoadActiveTripImplCopyWith(_$LoadActiveTripImpl value,
          $Res Function(_$LoadActiveTripImpl) then) =
      __$$LoadActiveTripImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadActiveTripImplCopyWithImpl<$Res>
    extends _$TripHomeEventCopyWithImpl<$Res, _$LoadActiveTripImpl>
    implements _$$LoadActiveTripImplCopyWith<$Res> {
  __$$LoadActiveTripImplCopyWithImpl(
      _$LoadActiveTripImpl _value, $Res Function(_$LoadActiveTripImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadActiveTripImpl implements LoadActiveTrip {
  const _$LoadActiveTripImpl();

  @override
  String toString() {
    return 'TripHomeEvent.loadActiveTrip()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadActiveTripImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(
            String vehicleId, String? origin, String? destination)
        startTrip,
    required TResult Function(String tripId) finishTrip,
  }) {
    return loadActiveTrip();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String vehicleId, String? origin, String? destination)?
        startTrip,
    TResult? Function(String tripId)? finishTrip,
  }) {
    return loadActiveTrip?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String vehicleId, String? origin, String? destination)?
        startTrip,
    TResult Function(String tripId)? finishTrip,
    required TResult orElse(),
  }) {
    if (loadActiveTrip != null) {
      return loadActiveTrip();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(StartTripRequested value) startTrip,
    required TResult Function(FinishTripRequested value) finishTrip,
  }) {
    return loadActiveTrip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(StartTripRequested value)? startTrip,
    TResult? Function(FinishTripRequested value)? finishTrip,
  }) {
    return loadActiveTrip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(StartTripRequested value)? startTrip,
    TResult Function(FinishTripRequested value)? finishTrip,
    required TResult orElse(),
  }) {
    if (loadActiveTrip != null) {
      return loadActiveTrip(this);
    }
    return orElse();
  }
}

abstract class LoadActiveTrip implements TripHomeEvent {
  const factory LoadActiveTrip() = _$LoadActiveTripImpl;
}

/// @nodoc
abstract class _$$StartTripRequestedImplCopyWith<$Res> {
  factory _$$StartTripRequestedImplCopyWith(_$StartTripRequestedImpl value,
          $Res Function(_$StartTripRequestedImpl) then) =
      __$$StartTripRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String vehicleId, String? origin, String? destination});
}

/// @nodoc
class __$$StartTripRequestedImplCopyWithImpl<$Res>
    extends _$TripHomeEventCopyWithImpl<$Res, _$StartTripRequestedImpl>
    implements _$$StartTripRequestedImplCopyWith<$Res> {
  __$$StartTripRequestedImplCopyWithImpl(_$StartTripRequestedImpl _value,
      $Res Function(_$StartTripRequestedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? origin = freezed,
    Object? destination = freezed,
  }) {
    return _then(_$StartTripRequestedImpl(
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StartTripRequestedImpl implements StartTripRequested {
  const _$StartTripRequestedImpl(
      {required this.vehicleId, this.origin, this.destination});

  @override
  final String vehicleId;
  @override
  final String? origin;
  @override
  final String? destination;

  @override
  String toString() {
    return 'TripHomeEvent.startTrip(vehicleId: $vehicleId, origin: $origin, destination: $destination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartTripRequestedImpl &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination));
  }

  @override
  int get hashCode => Object.hash(runtimeType, vehicleId, origin, destination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StartTripRequestedImplCopyWith<_$StartTripRequestedImpl> get copyWith =>
      __$$StartTripRequestedImplCopyWithImpl<_$StartTripRequestedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(
            String vehicleId, String? origin, String? destination)
        startTrip,
    required TResult Function(String tripId) finishTrip,
  }) {
    return startTrip(vehicleId, origin, destination);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String vehicleId, String? origin, String? destination)?
        startTrip,
    TResult? Function(String tripId)? finishTrip,
  }) {
    return startTrip?.call(vehicleId, origin, destination);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String vehicleId, String? origin, String? destination)?
        startTrip,
    TResult Function(String tripId)? finishTrip,
    required TResult orElse(),
  }) {
    if (startTrip != null) {
      return startTrip(vehicleId, origin, destination);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(StartTripRequested value) startTrip,
    required TResult Function(FinishTripRequested value) finishTrip,
  }) {
    return startTrip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(StartTripRequested value)? startTrip,
    TResult? Function(FinishTripRequested value)? finishTrip,
  }) {
    return startTrip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(StartTripRequested value)? startTrip,
    TResult Function(FinishTripRequested value)? finishTrip,
    required TResult orElse(),
  }) {
    if (startTrip != null) {
      return startTrip(this);
    }
    return orElse();
  }
}

abstract class StartTripRequested implements TripHomeEvent {
  const factory StartTripRequested(
      {required final String vehicleId,
      final String? origin,
      final String? destination}) = _$StartTripRequestedImpl;

  String get vehicleId;
  String? get origin;
  String? get destination;
  @JsonKey(ignore: true)
  _$$StartTripRequestedImplCopyWith<_$StartTripRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FinishTripRequestedImplCopyWith<$Res> {
  factory _$$FinishTripRequestedImplCopyWith(_$FinishTripRequestedImpl value,
          $Res Function(_$FinishTripRequestedImpl) then) =
      __$$FinishTripRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String tripId});
}

/// @nodoc
class __$$FinishTripRequestedImplCopyWithImpl<$Res>
    extends _$TripHomeEventCopyWithImpl<$Res, _$FinishTripRequestedImpl>
    implements _$$FinishTripRequestedImplCopyWith<$Res> {
  __$$FinishTripRequestedImplCopyWithImpl(_$FinishTripRequestedImpl _value,
      $Res Function(_$FinishTripRequestedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
  }) {
    return _then(_$FinishTripRequestedImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FinishTripRequestedImpl implements FinishTripRequested {
  const _$FinishTripRequestedImpl({required this.tripId});

  @override
  final String tripId;

  @override
  String toString() {
    return 'TripHomeEvent.finishTrip(tripId: $tripId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinishTripRequestedImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tripId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinishTripRequestedImplCopyWith<_$FinishTripRequestedImpl> get copyWith =>
      __$$FinishTripRequestedImplCopyWithImpl<_$FinishTripRequestedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadActiveTrip,
    required TResult Function(
            String vehicleId, String? origin, String? destination)
        startTrip,
    required TResult Function(String tripId) finishTrip,
  }) {
    return finishTrip(tripId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadActiveTrip,
    TResult? Function(String vehicleId, String? origin, String? destination)?
        startTrip,
    TResult? Function(String tripId)? finishTrip,
  }) {
    return finishTrip?.call(tripId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadActiveTrip,
    TResult Function(String vehicleId, String? origin, String? destination)?
        startTrip,
    TResult Function(String tripId)? finishTrip,
    required TResult orElse(),
  }) {
    if (finishTrip != null) {
      return finishTrip(tripId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadActiveTrip value) loadActiveTrip,
    required TResult Function(StartTripRequested value) startTrip,
    required TResult Function(FinishTripRequested value) finishTrip,
  }) {
    return finishTrip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadActiveTrip value)? loadActiveTrip,
    TResult? Function(StartTripRequested value)? startTrip,
    TResult? Function(FinishTripRequested value)? finishTrip,
  }) {
    return finishTrip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadActiveTrip value)? loadActiveTrip,
    TResult Function(StartTripRequested value)? startTrip,
    TResult Function(FinishTripRequested value)? finishTrip,
    required TResult orElse(),
  }) {
    if (finishTrip != null) {
      return finishTrip(this);
    }
    return orElse();
  }
}

abstract class FinishTripRequested implements TripHomeEvent {
  const factory FinishTripRequested({required final String tripId}) =
      _$FinishTripRequestedImpl;

  String get tripId;
  @JsonKey(ignore: true)
  _$$FinishTripRequestedImplCopyWith<_$FinishTripRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TripHomeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noActiveTrip,
    required TResult Function(Trip trip) active,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noActiveTrip,
    TResult? Function(Trip trip)? active,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noActiveTrip,
    TResult Function(Trip trip)? active,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TripHomeInitial value) initial,
    required TResult Function(TripHomeLoading value) loading,
    required TResult Function(NoActiveTrip value) noActiveTrip,
    required TResult Function(TripActive value) active,
    required TResult Function(TripHomeError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TripHomeInitial value)? initial,
    TResult? Function(TripHomeLoading value)? loading,
    TResult? Function(NoActiveTrip value)? noActiveTrip,
    TResult? Function(TripActive value)? active,
    TResult? Function(TripHomeError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TripHomeInitial value)? initial,
    TResult Function(TripHomeLoading value)? loading,
    TResult Function(NoActiveTrip value)? noActiveTrip,
    TResult Function(TripActive value)? active,
    TResult Function(TripHomeError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripHomeStateCopyWith<$Res> {
  factory $TripHomeStateCopyWith(
          TripHomeState value, $Res Function(TripHomeState) then) =
      _$TripHomeStateCopyWithImpl<$Res, TripHomeState>;
}

/// @nodoc
class _$TripHomeStateCopyWithImpl<$Res, $Val extends TripHomeState>
    implements $TripHomeStateCopyWith<$Res> {
  _$TripHomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$TripHomeInitialImplCopyWith<$Res> {
  factory _$$TripHomeInitialImplCopyWith(_$TripHomeInitialImpl value,
          $Res Function(_$TripHomeInitialImpl) then) =
      __$$TripHomeInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TripHomeInitialImplCopyWithImpl<$Res>
    extends _$TripHomeStateCopyWithImpl<$Res, _$TripHomeInitialImpl>
    implements _$$TripHomeInitialImplCopyWith<$Res> {
  __$$TripHomeInitialImplCopyWithImpl(
      _$TripHomeInitialImpl _value, $Res Function(_$TripHomeInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TripHomeInitialImpl implements TripHomeInitial {
  const _$TripHomeInitialImpl();

  @override
  String toString() {
    return 'TripHomeState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TripHomeInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noActiveTrip,
    required TResult Function(Trip trip) active,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noActiveTrip,
    TResult? Function(Trip trip)? active,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noActiveTrip,
    TResult Function(Trip trip)? active,
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
    required TResult Function(TripHomeInitial value) initial,
    required TResult Function(TripHomeLoading value) loading,
    required TResult Function(NoActiveTrip value) noActiveTrip,
    required TResult Function(TripActive value) active,
    required TResult Function(TripHomeError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TripHomeInitial value)? initial,
    TResult? Function(TripHomeLoading value)? loading,
    TResult? Function(NoActiveTrip value)? noActiveTrip,
    TResult? Function(TripActive value)? active,
    TResult? Function(TripHomeError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TripHomeInitial value)? initial,
    TResult Function(TripHomeLoading value)? loading,
    TResult Function(NoActiveTrip value)? noActiveTrip,
    TResult Function(TripActive value)? active,
    TResult Function(TripHomeError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class TripHomeInitial implements TripHomeState {
  const factory TripHomeInitial() = _$TripHomeInitialImpl;
}

/// @nodoc
abstract class _$$TripHomeLoadingImplCopyWith<$Res> {
  factory _$$TripHomeLoadingImplCopyWith(_$TripHomeLoadingImpl value,
          $Res Function(_$TripHomeLoadingImpl) then) =
      __$$TripHomeLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TripHomeLoadingImplCopyWithImpl<$Res>
    extends _$TripHomeStateCopyWithImpl<$Res, _$TripHomeLoadingImpl>
    implements _$$TripHomeLoadingImplCopyWith<$Res> {
  __$$TripHomeLoadingImplCopyWithImpl(
      _$TripHomeLoadingImpl _value, $Res Function(_$TripHomeLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TripHomeLoadingImpl implements TripHomeLoading {
  const _$TripHomeLoadingImpl();

  @override
  String toString() {
    return 'TripHomeState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TripHomeLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noActiveTrip,
    required TResult Function(Trip trip) active,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noActiveTrip,
    TResult? Function(Trip trip)? active,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noActiveTrip,
    TResult Function(Trip trip)? active,
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
    required TResult Function(TripHomeInitial value) initial,
    required TResult Function(TripHomeLoading value) loading,
    required TResult Function(NoActiveTrip value) noActiveTrip,
    required TResult Function(TripActive value) active,
    required TResult Function(TripHomeError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TripHomeInitial value)? initial,
    TResult? Function(TripHomeLoading value)? loading,
    TResult? Function(NoActiveTrip value)? noActiveTrip,
    TResult? Function(TripActive value)? active,
    TResult? Function(TripHomeError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TripHomeInitial value)? initial,
    TResult Function(TripHomeLoading value)? loading,
    TResult Function(NoActiveTrip value)? noActiveTrip,
    TResult Function(TripActive value)? active,
    TResult Function(TripHomeError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class TripHomeLoading implements TripHomeState {
  const factory TripHomeLoading() = _$TripHomeLoadingImpl;
}

/// @nodoc
abstract class _$$NoActiveTripImplCopyWith<$Res> {
  factory _$$NoActiveTripImplCopyWith(
          _$NoActiveTripImpl value, $Res Function(_$NoActiveTripImpl) then) =
      __$$NoActiveTripImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoActiveTripImplCopyWithImpl<$Res>
    extends _$TripHomeStateCopyWithImpl<$Res, _$NoActiveTripImpl>
    implements _$$NoActiveTripImplCopyWith<$Res> {
  __$$NoActiveTripImplCopyWithImpl(
      _$NoActiveTripImpl _value, $Res Function(_$NoActiveTripImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NoActiveTripImpl implements NoActiveTrip {
  const _$NoActiveTripImpl();

  @override
  String toString() {
    return 'TripHomeState.noActiveTrip()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NoActiveTripImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noActiveTrip,
    required TResult Function(Trip trip) active,
    required TResult Function(String message) error,
  }) {
    return noActiveTrip();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noActiveTrip,
    TResult? Function(Trip trip)? active,
    TResult? Function(String message)? error,
  }) {
    return noActiveTrip?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noActiveTrip,
    TResult Function(Trip trip)? active,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (noActiveTrip != null) {
      return noActiveTrip();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TripHomeInitial value) initial,
    required TResult Function(TripHomeLoading value) loading,
    required TResult Function(NoActiveTrip value) noActiveTrip,
    required TResult Function(TripActive value) active,
    required TResult Function(TripHomeError value) error,
  }) {
    return noActiveTrip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TripHomeInitial value)? initial,
    TResult? Function(TripHomeLoading value)? loading,
    TResult? Function(NoActiveTrip value)? noActiveTrip,
    TResult? Function(TripActive value)? active,
    TResult? Function(TripHomeError value)? error,
  }) {
    return noActiveTrip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TripHomeInitial value)? initial,
    TResult Function(TripHomeLoading value)? loading,
    TResult Function(NoActiveTrip value)? noActiveTrip,
    TResult Function(TripActive value)? active,
    TResult Function(TripHomeError value)? error,
    required TResult orElse(),
  }) {
    if (noActiveTrip != null) {
      return noActiveTrip(this);
    }
    return orElse();
  }
}

abstract class NoActiveTrip implements TripHomeState {
  const factory NoActiveTrip() = _$NoActiveTripImpl;
}

/// @nodoc
abstract class _$$TripActiveImplCopyWith<$Res> {
  factory _$$TripActiveImplCopyWith(
          _$TripActiveImpl value, $Res Function(_$TripActiveImpl) then) =
      __$$TripActiveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Trip trip});
}

/// @nodoc
class __$$TripActiveImplCopyWithImpl<$Res>
    extends _$TripHomeStateCopyWithImpl<$Res, _$TripActiveImpl>
    implements _$$TripActiveImplCopyWith<$Res> {
  __$$TripActiveImplCopyWithImpl(
      _$TripActiveImpl _value, $Res Function(_$TripActiveImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trip = null,
  }) {
    return _then(_$TripActiveImpl(
      trip: null == trip
          ? _value.trip
          : trip // ignore: cast_nullable_to_non_nullable
              as Trip,
    ));
  }
}

/// @nodoc

class _$TripActiveImpl implements TripActive {
  const _$TripActiveImpl({required this.trip});

  @override
  final Trip trip;

  @override
  String toString() {
    return 'TripHomeState.active(trip: $trip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripActiveImpl &&
            (identical(other.trip, trip) || other.trip == trip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, trip);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripActiveImplCopyWith<_$TripActiveImpl> get copyWith =>
      __$$TripActiveImplCopyWithImpl<_$TripActiveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noActiveTrip,
    required TResult Function(Trip trip) active,
    required TResult Function(String message) error,
  }) {
    return active(trip);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noActiveTrip,
    TResult? Function(Trip trip)? active,
    TResult? Function(String message)? error,
  }) {
    return active?.call(trip);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noActiveTrip,
    TResult Function(Trip trip)? active,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(trip);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TripHomeInitial value) initial,
    required TResult Function(TripHomeLoading value) loading,
    required TResult Function(NoActiveTrip value) noActiveTrip,
    required TResult Function(TripActive value) active,
    required TResult Function(TripHomeError value) error,
  }) {
    return active(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TripHomeInitial value)? initial,
    TResult? Function(TripHomeLoading value)? loading,
    TResult? Function(NoActiveTrip value)? noActiveTrip,
    TResult? Function(TripActive value)? active,
    TResult? Function(TripHomeError value)? error,
  }) {
    return active?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TripHomeInitial value)? initial,
    TResult Function(TripHomeLoading value)? loading,
    TResult Function(NoActiveTrip value)? noActiveTrip,
    TResult Function(TripActive value)? active,
    TResult Function(TripHomeError value)? error,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(this);
    }
    return orElse();
  }
}

abstract class TripActive implements TripHomeState {
  const factory TripActive({required final Trip trip}) = _$TripActiveImpl;

  Trip get trip;
  @JsonKey(ignore: true)
  _$$TripActiveImplCopyWith<_$TripActiveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TripHomeErrorImplCopyWith<$Res> {
  factory _$$TripHomeErrorImplCopyWith(
          _$TripHomeErrorImpl value, $Res Function(_$TripHomeErrorImpl) then) =
      __$$TripHomeErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$TripHomeErrorImplCopyWithImpl<$Res>
    extends _$TripHomeStateCopyWithImpl<$Res, _$TripHomeErrorImpl>
    implements _$$TripHomeErrorImplCopyWith<$Res> {
  __$$TripHomeErrorImplCopyWithImpl(
      _$TripHomeErrorImpl _value, $Res Function(_$TripHomeErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$TripHomeErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TripHomeErrorImpl implements TripHomeError {
  const _$TripHomeErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'TripHomeState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripHomeErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripHomeErrorImplCopyWith<_$TripHomeErrorImpl> get copyWith =>
      __$$TripHomeErrorImplCopyWithImpl<_$TripHomeErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noActiveTrip,
    required TResult Function(Trip trip) active,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noActiveTrip,
    TResult? Function(Trip trip)? active,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noActiveTrip,
    TResult Function(Trip trip)? active,
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
    required TResult Function(TripHomeInitial value) initial,
    required TResult Function(TripHomeLoading value) loading,
    required TResult Function(NoActiveTrip value) noActiveTrip,
    required TResult Function(TripActive value) active,
    required TResult Function(TripHomeError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TripHomeInitial value)? initial,
    TResult? Function(TripHomeLoading value)? loading,
    TResult? Function(NoActiveTrip value)? noActiveTrip,
    TResult? Function(TripActive value)? active,
    TResult? Function(TripHomeError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TripHomeInitial value)? initial,
    TResult Function(TripHomeLoading value)? loading,
    TResult Function(NoActiveTrip value)? noActiveTrip,
    TResult Function(TripActive value)? active,
    TResult Function(TripHomeError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class TripHomeError implements TripHomeState {
  const factory TripHomeError({required final String message}) =
      _$TripHomeErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$TripHomeErrorImplCopyWith<_$TripHomeErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
