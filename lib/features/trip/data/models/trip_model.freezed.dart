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
  String? get journeyId =>
      throw _privateConstructorUsedError; // Campos de origem/destino - todos opcionais
  @JsonKey(name: 'origin_description')
  String? get originDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_city')
  String? get originCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_state')
  String? get originState => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_latitude')
  double? get originLatitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_longitude')
  double? get originLongitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_description')
  String? get destinationDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_city')
  String? get destinationCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_state')
  String? get destinationState => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_latitude')
  double? get destinationLatitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_longitude')
  double? get destinationLongitude =>
      throw _privateConstructorUsedError; // Distância e odômetro - opcionais
  @JsonKey(name: 'distance_km')
  double? get distanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'odometer_start')
  double? get odometerStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'odometer_end')
  double? get odometerEnd =>
      throw _privateConstructorUsedError; // Status e datas
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'departure_date')
  DateTime? get departureDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_date')
  DateTime? get arrivalDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Métricas de paradas
  @JsonKey(name: 'total_stops')
  int? get totalStops => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_stop_duration_seconds')
  int? get totalStopDurationSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'driving_duration_seconds')
  int? get drivingDurationSeconds =>
      throw _privateConstructorUsedError; // Notas
  String? get notes => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'origin_description') String? originDescription,
      @JsonKey(name: 'origin_city') String? originCity,
      @JsonKey(name: 'origin_state') String? originState,
      @JsonKey(name: 'origin_latitude') double? originLatitude,
      @JsonKey(name: 'origin_longitude') double? originLongitude,
      @JsonKey(name: 'destination_description') String? destinationDescription,
      @JsonKey(name: 'destination_city') String? destinationCity,
      @JsonKey(name: 'destination_state') String? destinationState,
      @JsonKey(name: 'destination_latitude') double? destinationLatitude,
      @JsonKey(name: 'destination_longitude') double? destinationLongitude,
      @JsonKey(name: 'distance_km') double? distanceKm,
      @JsonKey(name: 'odometer_start') double? odometerStart,
      @JsonKey(name: 'odometer_end') double? odometerEnd,
      String status,
      @JsonKey(name: 'departure_date') DateTime? departureDate,
      @JsonKey(name: 'arrival_date') DateTime? arrivalDate,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'total_stops') int? totalStops,
      @JsonKey(name: 'total_stop_duration_seconds')
      int? totalStopDurationSeconds,
      @JsonKey(name: 'driving_duration_seconds') int? drivingDurationSeconds,
      String? notes});
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
    Object? originDescription = freezed,
    Object? originCity = freezed,
    Object? originState = freezed,
    Object? originLatitude = freezed,
    Object? originLongitude = freezed,
    Object? destinationDescription = freezed,
    Object? destinationCity = freezed,
    Object? destinationState = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? distanceKm = freezed,
    Object? odometerStart = freezed,
    Object? odometerEnd = freezed,
    Object? status = null,
    Object? departureDate = freezed,
    Object? arrivalDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? totalStops = freezed,
    Object? totalStopDurationSeconds = freezed,
    Object? drivingDurationSeconds = freezed,
    Object? notes = freezed,
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
      originDescription: freezed == originDescription
          ? _value.originDescription
          : originDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      originCity: freezed == originCity
          ? _value.originCity
          : originCity // ignore: cast_nullable_to_non_nullable
              as String?,
      originState: freezed == originState
          ? _value.originState
          : originState // ignore: cast_nullable_to_non_nullable
              as String?,
      originLatitude: freezed == originLatitude
          ? _value.originLatitude
          : originLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      originLongitude: freezed == originLongitude
          ? _value.originLongitude
          : originLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationDescription: freezed == destinationDescription
          ? _value.destinationDescription
          : destinationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationCity: freezed == destinationCity
          ? _value.destinationCity
          : destinationCity // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationState: freezed == destinationState
          ? _value.destinationState
          : destinationState // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationLatitude: freezed == destinationLatitude
          ? _value.destinationLatitude
          : destinationLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationLongitude: freezed == destinationLongitude
          ? _value.destinationLongitude
          : destinationLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      odometerStart: freezed == odometerStart
          ? _value.odometerStart
          : odometerStart // ignore: cast_nullable_to_non_nullable
              as double?,
      odometerEnd: freezed == odometerEnd
          ? _value.odometerEnd
          : odometerEnd // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      departureDate: freezed == departureDate
          ? _value.departureDate
          : departureDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivalDate: freezed == arrivalDate
          ? _value.arrivalDate
          : arrivalDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalStops: freezed == totalStops
          ? _value.totalStops
          : totalStops // ignore: cast_nullable_to_non_nullable
              as int?,
      totalStopDurationSeconds: freezed == totalStopDurationSeconds
          ? _value.totalStopDurationSeconds
          : totalStopDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      drivingDurationSeconds: freezed == drivingDurationSeconds
          ? _value.drivingDurationSeconds
          : drivingDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'origin_description') String? originDescription,
      @JsonKey(name: 'origin_city') String? originCity,
      @JsonKey(name: 'origin_state') String? originState,
      @JsonKey(name: 'origin_latitude') double? originLatitude,
      @JsonKey(name: 'origin_longitude') double? originLongitude,
      @JsonKey(name: 'destination_description') String? destinationDescription,
      @JsonKey(name: 'destination_city') String? destinationCity,
      @JsonKey(name: 'destination_state') String? destinationState,
      @JsonKey(name: 'destination_latitude') double? destinationLatitude,
      @JsonKey(name: 'destination_longitude') double? destinationLongitude,
      @JsonKey(name: 'distance_km') double? distanceKm,
      @JsonKey(name: 'odometer_start') double? odometerStart,
      @JsonKey(name: 'odometer_end') double? odometerEnd,
      String status,
      @JsonKey(name: 'departure_date') DateTime? departureDate,
      @JsonKey(name: 'arrival_date') DateTime? arrivalDate,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'total_stops') int? totalStops,
      @JsonKey(name: 'total_stop_duration_seconds')
      int? totalStopDurationSeconds,
      @JsonKey(name: 'driving_duration_seconds') int? drivingDurationSeconds,
      String? notes});
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
    Object? originDescription = freezed,
    Object? originCity = freezed,
    Object? originState = freezed,
    Object? originLatitude = freezed,
    Object? originLongitude = freezed,
    Object? destinationDescription = freezed,
    Object? destinationCity = freezed,
    Object? destinationState = freezed,
    Object? destinationLatitude = freezed,
    Object? destinationLongitude = freezed,
    Object? distanceKm = freezed,
    Object? odometerStart = freezed,
    Object? odometerEnd = freezed,
    Object? status = null,
    Object? departureDate = freezed,
    Object? arrivalDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? totalStops = freezed,
    Object? totalStopDurationSeconds = freezed,
    Object? drivingDurationSeconds = freezed,
    Object? notes = freezed,
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
      originDescription: freezed == originDescription
          ? _value.originDescription
          : originDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      originCity: freezed == originCity
          ? _value.originCity
          : originCity // ignore: cast_nullable_to_non_nullable
              as String?,
      originState: freezed == originState
          ? _value.originState
          : originState // ignore: cast_nullable_to_non_nullable
              as String?,
      originLatitude: freezed == originLatitude
          ? _value.originLatitude
          : originLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      originLongitude: freezed == originLongitude
          ? _value.originLongitude
          : originLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationDescription: freezed == destinationDescription
          ? _value.destinationDescription
          : destinationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationCity: freezed == destinationCity
          ? _value.destinationCity
          : destinationCity // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationState: freezed == destinationState
          ? _value.destinationState
          : destinationState // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationLatitude: freezed == destinationLatitude
          ? _value.destinationLatitude
          : destinationLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      destinationLongitude: freezed == destinationLongitude
          ? _value.destinationLongitude
          : destinationLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      odometerStart: freezed == odometerStart
          ? _value.odometerStart
          : odometerStart // ignore: cast_nullable_to_non_nullable
              as double?,
      odometerEnd: freezed == odometerEnd
          ? _value.odometerEnd
          : odometerEnd // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      departureDate: freezed == departureDate
          ? _value.departureDate
          : departureDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivalDate: freezed == arrivalDate
          ? _value.arrivalDate
          : arrivalDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalStops: freezed == totalStops
          ? _value.totalStops
          : totalStops // ignore: cast_nullable_to_non_nullable
              as int?,
      totalStopDurationSeconds: freezed == totalStopDurationSeconds
          ? _value.totalStopDurationSeconds
          : totalStopDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      drivingDurationSeconds: freezed == drivingDurationSeconds
          ? _value.drivingDurationSeconds
          : drivingDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'origin_description') this.originDescription,
      @JsonKey(name: 'origin_city') this.originCity,
      @JsonKey(name: 'origin_state') this.originState,
      @JsonKey(name: 'origin_latitude') this.originLatitude,
      @JsonKey(name: 'origin_longitude') this.originLongitude,
      @JsonKey(name: 'destination_description') this.destinationDescription,
      @JsonKey(name: 'destination_city') this.destinationCity,
      @JsonKey(name: 'destination_state') this.destinationState,
      @JsonKey(name: 'destination_latitude') this.destinationLatitude,
      @JsonKey(name: 'destination_longitude') this.destinationLongitude,
      @JsonKey(name: 'distance_km') this.distanceKm,
      @JsonKey(name: 'odometer_start') this.odometerStart,
      @JsonKey(name: 'odometer_end') this.odometerEnd,
      required this.status,
      @JsonKey(name: 'departure_date') this.departureDate,
      @JsonKey(name: 'arrival_date') this.arrivalDate,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'total_stops') this.totalStops,
      @JsonKey(name: 'total_stop_duration_seconds')
      this.totalStopDurationSeconds,
      @JsonKey(name: 'driving_duration_seconds') this.drivingDurationSeconds,
      this.notes})
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
// Campos de origem/destino - todos opcionais
  @override
  @JsonKey(name: 'origin_description')
  final String? originDescription;
  @override
  @JsonKey(name: 'origin_city')
  final String? originCity;
  @override
  @JsonKey(name: 'origin_state')
  final String? originState;
  @override
  @JsonKey(name: 'origin_latitude')
  final double? originLatitude;
  @override
  @JsonKey(name: 'origin_longitude')
  final double? originLongitude;
  @override
  @JsonKey(name: 'destination_description')
  final String? destinationDescription;
  @override
  @JsonKey(name: 'destination_city')
  final String? destinationCity;
  @override
  @JsonKey(name: 'destination_state')
  final String? destinationState;
  @override
  @JsonKey(name: 'destination_latitude')
  final double? destinationLatitude;
  @override
  @JsonKey(name: 'destination_longitude')
  final double? destinationLongitude;
// Distância e odômetro - opcionais
  @override
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  @override
  @JsonKey(name: 'odometer_start')
  final double? odometerStart;
  @override
  @JsonKey(name: 'odometer_end')
  final double? odometerEnd;
// Status e datas
  @override
  final String status;
  @override
  @JsonKey(name: 'departure_date')
  final DateTime? departureDate;
  @override
  @JsonKey(name: 'arrival_date')
  final DateTime? arrivalDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// Métricas de paradas
  @override
  @JsonKey(name: 'total_stops')
  final int? totalStops;
  @override
  @JsonKey(name: 'total_stop_duration_seconds')
  final int? totalStopDurationSeconds;
  @override
  @JsonKey(name: 'driving_duration_seconds')
  final int? drivingDurationSeconds;
// Notas
  @override
  final String? notes;

  @override
  String toString() {
    return 'TripModel(id: $id, companyId: $companyId, vehicleId: $vehicleId, driverId: $driverId, journeyId: $journeyId, originDescription: $originDescription, originCity: $originCity, originState: $originState, originLatitude: $originLatitude, originLongitude: $originLongitude, destinationDescription: $destinationDescription, destinationCity: $destinationCity, destinationState: $destinationState, destinationLatitude: $destinationLatitude, destinationLongitude: $destinationLongitude, distanceKm: $distanceKm, odometerStart: $odometerStart, odometerEnd: $odometerEnd, status: $status, departureDate: $departureDate, arrivalDate: $arrivalDate, createdAt: $createdAt, updatedAt: $updatedAt, totalStops: $totalStops, totalStopDurationSeconds: $totalStopDurationSeconds, drivingDurationSeconds: $drivingDurationSeconds, notes: $notes)';
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
            (identical(other.originDescription, originDescription) ||
                other.originDescription == originDescription) &&
            (identical(other.originCity, originCity) ||
                other.originCity == originCity) &&
            (identical(other.originState, originState) ||
                other.originState == originState) &&
            (identical(other.originLatitude, originLatitude) ||
                other.originLatitude == originLatitude) &&
            (identical(other.originLongitude, originLongitude) ||
                other.originLongitude == originLongitude) &&
            (identical(other.destinationDescription, destinationDescription) ||
                other.destinationDescription == destinationDescription) &&
            (identical(other.destinationCity, destinationCity) ||
                other.destinationCity == destinationCity) &&
            (identical(other.destinationState, destinationState) ||
                other.destinationState == destinationState) &&
            (identical(other.destinationLatitude, destinationLatitude) ||
                other.destinationLatitude == destinationLatitude) &&
            (identical(other.destinationLongitude, destinationLongitude) ||
                other.destinationLongitude == destinationLongitude) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.odometerStart, odometerStart) ||
                other.odometerStart == odometerStart) &&
            (identical(other.odometerEnd, odometerEnd) ||
                other.odometerEnd == odometerEnd) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.departureDate, departureDate) ||
                other.departureDate == departureDate) &&
            (identical(other.arrivalDate, arrivalDate) ||
                other.arrivalDate == arrivalDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.totalStops, totalStops) ||
                other.totalStops == totalStops) &&
            (identical(
                    other.totalStopDurationSeconds, totalStopDurationSeconds) ||
                other.totalStopDurationSeconds == totalStopDurationSeconds) &&
            (identical(other.drivingDurationSeconds, drivingDurationSeconds) ||
                other.drivingDurationSeconds == drivingDurationSeconds) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        companyId,
        vehicleId,
        driverId,
        journeyId,
        originDescription,
        originCity,
        originState,
        originLatitude,
        originLongitude,
        destinationDescription,
        destinationCity,
        destinationState,
        destinationLatitude,
        destinationLongitude,
        distanceKm,
        odometerStart,
        odometerEnd,
        status,
        departureDate,
        arrivalDate,
        createdAt,
        updatedAt,
        totalStops,
        totalStopDurationSeconds,
        drivingDurationSeconds,
        notes
      ]);

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
      @JsonKey(name: 'origin_description') final String? originDescription,
      @JsonKey(name: 'origin_city') final String? originCity,
      @JsonKey(name: 'origin_state') final String? originState,
      @JsonKey(name: 'origin_latitude') final double? originLatitude,
      @JsonKey(name: 'origin_longitude') final double? originLongitude,
      @JsonKey(name: 'destination_description')
      final String? destinationDescription,
      @JsonKey(name: 'destination_city') final String? destinationCity,
      @JsonKey(name: 'destination_state') final String? destinationState,
      @JsonKey(name: 'destination_latitude') final double? destinationLatitude,
      @JsonKey(name: 'destination_longitude')
      final double? destinationLongitude,
      @JsonKey(name: 'distance_km') final double? distanceKm,
      @JsonKey(name: 'odometer_start') final double? odometerStart,
      @JsonKey(name: 'odometer_end') final double? odometerEnd,
      required final String status,
      @JsonKey(name: 'departure_date') final DateTime? departureDate,
      @JsonKey(name: 'arrival_date') final DateTime? arrivalDate,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'total_stops') final int? totalStops,
      @JsonKey(name: 'total_stop_duration_seconds')
      final int? totalStopDurationSeconds,
      @JsonKey(name: 'driving_duration_seconds')
      final int? drivingDurationSeconds,
      final String? notes}) = _$TripModelImpl;
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
  @override // Campos de origem/destino - todos opcionais
  @JsonKey(name: 'origin_description')
  String? get originDescription;
  @override
  @JsonKey(name: 'origin_city')
  String? get originCity;
  @override
  @JsonKey(name: 'origin_state')
  String? get originState;
  @override
  @JsonKey(name: 'origin_latitude')
  double? get originLatitude;
  @override
  @JsonKey(name: 'origin_longitude')
  double? get originLongitude;
  @override
  @JsonKey(name: 'destination_description')
  String? get destinationDescription;
  @override
  @JsonKey(name: 'destination_city')
  String? get destinationCity;
  @override
  @JsonKey(name: 'destination_state')
  String? get destinationState;
  @override
  @JsonKey(name: 'destination_latitude')
  double? get destinationLatitude;
  @override
  @JsonKey(name: 'destination_longitude')
  double? get destinationLongitude;
  @override // Distância e odômetro - opcionais
  @JsonKey(name: 'distance_km')
  double? get distanceKm;
  @override
  @JsonKey(name: 'odometer_start')
  double? get odometerStart;
  @override
  @JsonKey(name: 'odometer_end')
  double? get odometerEnd;
  @override // Status e datas
  String get status;
  @override
  @JsonKey(name: 'departure_date')
  DateTime? get departureDate;
  @override
  @JsonKey(name: 'arrival_date')
  DateTime? get arrivalDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override // Métricas de paradas
  @JsonKey(name: 'total_stops')
  int? get totalStops;
  @override
  @JsonKey(name: 'total_stop_duration_seconds')
  int? get totalStopDurationSeconds;
  @override
  @JsonKey(name: 'driving_duration_seconds')
  int? get drivingDurationSeconds;
  @override // Notas
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
