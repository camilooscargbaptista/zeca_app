// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripModelImpl _$$TripModelImplFromJson(Map<String, dynamic> json) =>
    _$TripModelImpl(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      vehicleId: json['vehicle_id'] as String,
      driverId: json['driver_id'] as String?,
      journeyId: json['journey_id'] as String?,
      originDescription: json['origin_description'] as String?,
      originCity: json['origin_city'] as String?,
      originState: json['origin_state'] as String?,
      originLatitude: (json['origin_latitude'] as num?)?.toDouble(),
      originLongitude: (json['origin_longitude'] as num?)?.toDouble(),
      destinationDescription: json['destination_description'] as String?,
      destinationCity: json['destination_city'] as String?,
      destinationState: json['destination_state'] as String?,
      destinationLatitude: (json['destination_latitude'] as num?)?.toDouble(),
      destinationLongitude: (json['destination_longitude'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      odometerStart: (json['odometer_start'] as num?)?.toDouble(),
      odometerEnd: (json['odometer_end'] as num?)?.toDouble(),
      status: json['status'] as String,
      departureDate: json['departure_date'] == null
          ? null
          : DateTime.parse(json['departure_date'] as String),
      arrivalDate: json['arrival_date'] == null
          ? null
          : DateTime.parse(json['arrival_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      totalStops: (json['total_stops'] as num?)?.toInt(),
      totalStopDurationSeconds:
          (json['total_stop_duration_seconds'] as num?)?.toInt(),
      drivingDurationSeconds:
          (json['driving_duration_seconds'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TripModelImplToJson(_$TripModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'vehicle_id': instance.vehicleId,
      'driver_id': instance.driverId,
      'journey_id': instance.journeyId,
      'origin_description': instance.originDescription,
      'origin_city': instance.originCity,
      'origin_state': instance.originState,
      'origin_latitude': instance.originLatitude,
      'origin_longitude': instance.originLongitude,
      'destination_description': instance.destinationDescription,
      'destination_city': instance.destinationCity,
      'destination_state': instance.destinationState,
      'destination_latitude': instance.destinationLatitude,
      'destination_longitude': instance.destinationLongitude,
      'distance_km': instance.distanceKm,
      'odometer_start': instance.odometerStart,
      'odometer_end': instance.odometerEnd,
      'status': instance.status,
      'departure_date': instance.departureDate?.toIso8601String(),
      'arrival_date': instance.arrivalDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'total_stops': instance.totalStops,
      'total_stop_duration_seconds': instance.totalStopDurationSeconds,
      'driving_duration_seconds': instance.drivingDurationSeconds,
      'notes': instance.notes,
    };
