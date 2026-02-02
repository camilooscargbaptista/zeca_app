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
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      totalDistanceKm: (json['total_distance_km'] as num?)?.toDouble(),
      status: json['status'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$TripModelImplToJson(_$TripModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'vehicle_id': instance.vehicleId,
      'driver_id': instance.driverId,
      'journey_id': instance.journeyId,
      'origin': instance.origin,
      'destination': instance.destination,
      'total_distance_km': instance.totalDistanceKm,
      'status': instance.status,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
