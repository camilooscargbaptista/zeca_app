// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'autonomous_vehicles_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AutonomousVehiclesState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get vehicles => throw _privateConstructorUsedError;
  int get vehicleLimit => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

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
      {bool isLoading,
      bool isDeleting,
      List<Map<String, dynamic>> vehicles,
      int vehicleLimit,
      String? error});
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
    Object? isLoading = null,
    Object? isDeleting = null,
    Object? vehicles = null,
    Object? vehicleLimit = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      vehicles: null == vehicles
          ? _value.vehicles
          : vehicles // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      vehicleLimit: null == vehicleLimit
          ? _value.vehicleLimit
          : vehicleLimit // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
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
      {bool isLoading,
      bool isDeleting,
      List<Map<String, dynamic>> vehicles,
      int vehicleLimit,
      String? error});
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
    Object? isLoading = null,
    Object? isDeleting = null,
    Object? vehicles = null,
    Object? vehicleLimit = null,
    Object? error = freezed,
  }) {
    return _then(_$AutonomousVehiclesStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      vehicles: null == vehicles
          ? _value._vehicles
          : vehicles // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      vehicleLimit: null == vehicleLimit
          ? _value.vehicleLimit
          : vehicleLimit // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AutonomousVehiclesStateImpl extends _AutonomousVehiclesState {
  const _$AutonomousVehiclesStateImpl(
      {this.isLoading = true,
      this.isDeleting = false,
      final List<Map<String, dynamic>> vehicles = const [],
      this.vehicleLimit = 3,
      this.error})
      : _vehicles = vehicles,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isDeleting;
  final List<Map<String, dynamic>> _vehicles;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get vehicles {
    if (_vehicles is EqualUnmodifiableListView) return _vehicles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vehicles);
  }

  @override
  @JsonKey()
  final int vehicleLimit;
  @override
  final String? error;

  @override
  String toString() {
    return 'AutonomousVehiclesState(isLoading: $isLoading, isDeleting: $isDeleting, vehicles: $vehicles, vehicleLimit: $vehicleLimit, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutonomousVehiclesStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            const DeepCollectionEquality().equals(other._vehicles, _vehicles) &&
            (identical(other.vehicleLimit, vehicleLimit) ||
                other.vehicleLimit == vehicleLimit) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isDeleting,
      const DeepCollectionEquality().hash(_vehicles), vehicleLimit, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AutonomousVehiclesStateImplCopyWith<_$AutonomousVehiclesStateImpl>
      get copyWith => __$$AutonomousVehiclesStateImplCopyWithImpl<
          _$AutonomousVehiclesStateImpl>(this, _$identity);
}

abstract class _AutonomousVehiclesState extends AutonomousVehiclesState {
  const factory _AutonomousVehiclesState(
      {final bool isLoading,
      final bool isDeleting,
      final List<Map<String, dynamic>> vehicles,
      final int vehicleLimit,
      final String? error}) = _$AutonomousVehiclesStateImpl;
  const _AutonomousVehiclesState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get isDeleting;
  @override
  List<Map<String, dynamic>> get vehicles;
  @override
  int get vehicleLimit;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$AutonomousVehiclesStateImplCopyWith<_$AutonomousVehiclesStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
