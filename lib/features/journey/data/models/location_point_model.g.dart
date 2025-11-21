// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationPointModelImpl _$$LocationPointModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationPointModelImpl(
      id: json['id'] as String,
      journeyId: json['journey_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      velocidade: (json['velocidade'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      sincronizado: json['sincronizado'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$LocationPointModelImplToJson(
        _$LocationPointModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'journey_id': instance.journeyId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'velocidade': instance.velocidade,
      'timestamp': instance.timestamp.toIso8601String(),
      'sincronizado': instance.sincronizado,
      'created_at': instance.createdAt?.toIso8601String(),
    };
