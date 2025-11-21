// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JourneyModelImpl _$$JourneyModelImplFromJson(Map<String, dynamic> json) =>
    _$JourneyModelImpl(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      vehicleId: json['vehicle_id'] as String,
      placa: json['placa'] as String,
      odometroInicial: (json['odometro_inicial'] as num).toInt(),
      destino: json['destino'] as String?,
      previsaoKm: (json['previsao_km'] as num?)?.toInt(),
      observacoes: json['observacoes'] as String?,
      dataInicio: DateTime.parse(json['data_inicio'] as String),
      dataFim: json['data_fim'] == null
          ? null
          : DateTime.parse(json['data_fim'] as String),
      status: json['status'] as String,
      tempoDirecaoSegundos:
          (json['tempo_direcao_segundos'] as num?)?.toInt() ?? 0,
      tempoDescansoSegundos:
          (json['tempo_descanso_segundos'] as num?)?.toInt() ?? 0,
      kmPercorridos: (json['km_percorridos'] as num?)?.toDouble() ?? 0.0,
      velocidadeMedia: (json['velocidade_media'] as num?)?.toDouble(),
      velocidadeMaxima: (json['velocidade_maxima'] as num?)?.toDouble(),
      latVelocidadeMaxima: (json['lat_velocidade_maxima'] as num?)?.toDouble(),
      longVelocidadeMaxima:
          (json['long_velocidade_maxima'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      segmentsSummaryJson: (json['segments_summary'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$JourneyModelImplToJson(_$JourneyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driver_id': instance.driverId,
      'vehicle_id': instance.vehicleId,
      'placa': instance.placa,
      'odometro_inicial': instance.odometroInicial,
      'destino': instance.destino,
      'previsao_km': instance.previsaoKm,
      'observacoes': instance.observacoes,
      'data_inicio': instance.dataInicio.toIso8601String(),
      'data_fim': instance.dataFim?.toIso8601String(),
      'status': instance.status,
      'tempo_direcao_segundos': instance.tempoDirecaoSegundos,
      'tempo_descanso_segundos': instance.tempoDescansoSegundos,
      'km_percorridos': instance.kmPercorridos,
      'velocidade_media': instance.velocidadeMedia,
      'velocidade_maxima': instance.velocidadeMaxima,
      'lat_velocidade_maxima': instance.latVelocidadeMaxima,
      'long_velocidade_maxima': instance.longVelocidadeMaxima,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'segments_summary': instance.segmentsSummaryJson,
    };
