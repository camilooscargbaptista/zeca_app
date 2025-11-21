import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/journey_entity.dart';
import '../../domain/entities/journey_segment_summary.dart';

part 'journey_model.freezed.dart';
part 'journey_model.g.dart';

@freezed
abstract class JourneyModel with _$JourneyModel {
  const JourneyModel._();
  
  const factory JourneyModel({
    required String id,
    @JsonKey(name: 'driver_id') required String driverId,
    @JsonKey(name: 'vehicle_id') required String vehicleId,
    required String placa,
    @JsonKey(name: 'odometro_inicial') required int odometroInicial,
    String? destino,
    @JsonKey(name: 'previsao_km') int? previsaoKm,
    String? observacoes,
    @JsonKey(name: 'data_inicio') required DateTime dataInicio,
    @JsonKey(name: 'data_fim') DateTime? dataFim,
    required String status,
    @JsonKey(name: 'tempo_direcao_segundos') @Default(0) int tempoDirecaoSegundos,
    @JsonKey(name: 'tempo_descanso_segundos') @Default(0) int tempoDescansoSegundos,
    @JsonKey(name: 'km_percorridos') @Default(0.0) double kmPercorridos,
    @JsonKey(name: 'velocidade_media') double? velocidadeMedia,
    @JsonKey(name: 'velocidade_maxima') double? velocidadeMaxima,
    @JsonKey(name: 'lat_velocidade_maxima') double? latVelocidadeMaxima,
    @JsonKey(name: 'long_velocidade_maxima') double? longVelocidadeMaxima,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'segments_summary') List<Map<String, dynamic>>? segmentsSummaryJson,
  }) = _JourneyModel;
  
  factory JourneyModel.fromJson(Map<String, dynamic> json) =>
      _$JourneyModelFromJson(json);

  JourneyEntity toEntity() {
    // Converter segments_summary JSON para lista de JourneySegmentSummary
    List<JourneySegmentSummary>? segments;
    if (segmentsSummaryJson != null && segmentsSummaryJson!.isNotEmpty) {
      segments = segmentsSummaryJson!
          .map((json) => JourneySegmentSummary.fromJson(json))
          .toList();
    }
    
    return JourneyEntity(
      id: id,
      driverId: driverId,
      vehicleId: vehicleId,
      placa: placa,
      odometroInicial: odometroInicial,
      destino: destino,
      previsaoKm: previsaoKm,
      observacoes: observacoes,
      dataInicio: dataInicio,
      dataFim: dataFim,
      status: JourneyStatus.values.firstWhere(
        (e) => e.name == status.toUpperCase(),
        orElse: () => JourneyStatus.ACTIVE,
      ),
      tempoDirecaoSegundos: tempoDirecaoSegundos,
      tempoDescansoSegundos: tempoDescansoSegundos,
      kmPercorridos: kmPercorridos,
      velocidadeMedia: velocidadeMedia,
      velocidadeMaxima: velocidadeMaxima,
      latVelocidadeMaxima: latVelocidadeMaxima,
      longVelocidadeMaxima: longVelocidadeMaxima,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      segmentsSummary: segments,
    );
  }
}

