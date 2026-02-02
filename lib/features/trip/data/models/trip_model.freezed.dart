// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripModel _$TripModelFromJson(Map<String, dynamic> json) {
  return _TripModel.fromJson(json);
}

/// @nodoc
mixin _$TripModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_id')
  String get vehicleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_id')
  String? get driverId => throw _privateConstructorUsedError;
  @JsonKey(name: 'journey_id')
  String? get journeyId => throw _privateConstructorUsedError;
  String? get origin => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_distance_km')
  double? get totalDistanceKm => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TripModelCopyWith<TripModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripModelCopyWith<$Res> {
  factory $TripModelCopyWith(TripModel value, $Res Function(TripModel) then) =
      _$TripModelCopyWithImpl<$Res, TripModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'vehicle_id') String vehicleId,
      @JsonKey(name: 'driver_id') String? driverId,
      @JsonKey(name: 'journey_id') String? journeyId,
      String? origin,
      String? destination,
      @JsonKey(name: 'total_distance_km') double? totalDistanceKm,
      String status,
      @JsonKey(name: 'started_at') DateTime startedAt,
      @JsonKey(name: 'ended_at') DateTime? endedAt,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$TripModelCopyWithImpl<$Res, $Val extends TripModel>
    implements $TripModelCopyWith<$Res> {
  _$TripModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? vehicleId = null,
    Object? driverId = freezed,
    Object? journeyId = freezed,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? totalDistanceKm = freezed,
    Object? status = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      journeyId: freezed == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDistanceKm: freezed == totalDistanceKm
          ? _value.totalDistanceKm
          : totalDistanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripModelImplCopyWith<$Res>
    implements $TripModelCopyWith<$Res> {
  factory _$$TripModelImplCopyWith(
          _$TripModelImpl value, $Res Function(_$TripModelImpl) then) =
      __$$TripModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'vehicle_id') String vehicleId,
      @JsonKey(name: 'driver_id') String? driverId,
      @JsonKey(name: 'journey_id') String? journeyId,
      String? origin,
      String? destination,
      @JsonKey(name: 'total_distance_km') double? totalDistanceKm,
      String status,
      @JsonKey(name: 'started_at') DateTime startedAt,
      @JsonKey(name: 'ended_at') DateTime? endedAt,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$TripModelImplCopyWithImpl<$Res>
    extends _$TripModelCopyWithImpl<$Res, _$TripModelImpl>
    implements _$$TripModelImplCopyWith<$Res> {
  __$$TripModelImplCopyWithImpl(
      _$TripModelImpl _value, $Res Function(_$TripModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? vehicleId = null,
    Object? driverId = freezed,
    Object? journeyId = freezed,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? totalDistanceKm = freezed,
    Object? status = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$TripModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      journeyId: freezed == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      totalDistanceKm: freezed == totalDistanceKm
          ? _value.totalDistanceKm
          : totalDistanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripModelImpl extends _TripModel {
  const _$TripModelImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'vehicle_id') required this.vehicleId,
      @JsonKey(name: 'driver_id') this.driverId,
      @JsonKey(name: 'journey_id') this.journeyId,
      this.origin,
      this.destination,
      @JsonKey(name: 'total_distance_km') this.totalDistanceKm,
      required this.status,
      @JsonKey(name: 'started_at') required this.startedAt,
      @JsonKey(name: 'ended_at') this.endedAt,
      @JsonKey(name: 'created_at') required this.createdAt})
      : super._();

  factory _$TripModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'vehicle_id')
  final String vehicleId;
  @override
  @JsonKey(name: 'driver_id')
  final String? driverId;
  @override
  @JsonKey(name: 'journey_id')
  final String? journeyId;
  @override
  final String? origin;
  @override
  final String? destination;
  @override
  @JsonKey(name: 'total_distance_km')
  final double? totalDistanceKm;
  @override
  final String status;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'TripModel(id: $id, companyId: $companyId, vehicleId: $vehicleId, driverId: $driverId, journeyId: $journeyId, origin: $origin, destination: $destination, totalDistanceKm: $totalDistanceKm, status: $status, startedAt: $startedAt, endedAt: $endedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.journeyId, journeyId) ||
                other.journeyId == journeyId) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.totalDistanceKm, totalDistanceKm) ||
                other.totalDistanceKm == totalDistanceKm) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      vehicleId,
      driverId,
      journeyId,
      origin,
      destination,
      totalDistanceKm,
      status,
      startedAt,
      endedAt,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      __$$TripModelImplCopyWithImpl<_$TripModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripModelImplToJson(
      this,
    );
  }
}

abstract class _TripModel extends TripModel {
  const factory _TripModel(
          {required final String id,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'vehicle_id') required final String vehicleId,
          @JsonKey(name: 'driver_id') final String? driverId,
          @JsonKey(name: 'journey_id') final String? journeyId,
          final String? origin,
          final String? destination,
          @JsonKey(name: 'total_distance_km') final double? totalDistanceKm,
          required final String status,
          @JsonKey(name: 'started_at') required final DateTime startedAt,
          @JsonKey(name: 'ended_at') final DateTime? endedAt,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$TripModelImpl;
  const _TripModel._() : super._();

  factory _TripModel.fromJson(Map<String, dynamic> json) =
      _$TripModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'vehicle_id')
  String get vehicleId;
  @override
  @JsonKey(name: 'driver_id')
  String? get driverId;
  @override
  @JsonKey(name: 'journey_id')
  String? get journeyId;
  @override
  String? get origin;
  @override
  String? get destination;
  @override
  @JsonKey(name: 'total_distance_km')
  double? get totalDistanceKm;
  @override
  String get status;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
