import 'journey_segment_summary.dart';

enum JourneyStatus {
  ACTIVE,
  FINISHED,
  CANCELLED,
}

class JourneyEntity {
  final String id;
  final String driverId;
  final String vehicleId;
  final String placa;
  final int odometroInicial;
  final String? destino;
  final int? previsaoKm;
  final String? observacoes;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final JourneyStatus status;
  final int tempoDirecaoSegundos;
  final int tempoDescansoSegundos;
  final double kmPercorridos;
  final double? velocidadeMedia;
  final double? velocidadeMaxima;
  final double? latVelocidadeMaxima;
  final double? longVelocidadeMaxima;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  /// Resumo dos trechos da jornada (disponível após finalização)
  final List<JourneySegmentSummary>? segmentsSummary;

  JourneyEntity({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.placa,
    required this.odometroInicial,
    this.destino,
    this.previsaoKm,
    this.observacoes,
    required this.dataInicio,
    this.dataFim,
    required this.status,
    required this.tempoDirecaoSegundos,
    required this.tempoDescansoSegundos,
    required this.kmPercorridos,
    this.velocidadeMedia,
    this.velocidadeMaxima,
    this.latVelocidadeMaxima,
    this.longVelocidadeMaxima,
    required this.createdAt,
    required this.updatedAt,
    this.segmentsSummary,
  });

  bool get isActive => status == JourneyStatus.ACTIVE;
  bool get isFinished => status == JourneyStatus.FINISHED;
  bool get isCancelled => status == JourneyStatus.CANCELLED;

  String get formattedTempoDirecao {
    final horas = tempoDirecaoSegundos ~/ 3600;
    final minutos = (tempoDirecaoSegundos % 3600) ~/ 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}';
  }

  String get formattedTempoDescanso {
    final horas = tempoDescansoSegundos ~/ 3600;
    final minutos = (tempoDescansoSegundos % 3600) ~/ 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}';
  }

  int get odometroFinal => odometroInicial + kmPercorridos.round();
}

