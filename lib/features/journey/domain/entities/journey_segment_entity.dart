import 'package:intl/intl.dart';

/// Entidade que representa um trecho individual de uma jornada
/// 
/// Um trecho é criado cada vez que o motorista inicia/retoma a direção
/// e é finalizado quando ele inicia um descanso ou finaliza a jornada
class JourneySegmentEntity {
  final String id;
  final String journeyId;
  final int segmentNumber;
  final DateTime startTime;
  final DateTime? endTime;
  final double startLatitude;
  final double startLongitude;
  final double? endLatitude;
  final double? endLongitude;
  final double distanceKm;
  final int durationSeconds;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;
  final double? maxSpeedLatitude;
  final double? maxSpeedLongitude;
  final int locationPointsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  JourneySegmentEntity({
    required this.id,
    required this.journeyId,
    required this.segmentNumber,
    required this.startTime,
    this.endTime,
    required this.startLatitude,
    required this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    required this.distanceKm,
    required this.durationSeconds,
    this.avgSpeedKmh,
    this.maxSpeedKmh,
    this.maxSpeedLatitude,
    this.maxSpeedLongitude,
    required this.locationPointsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Duração formatada (HH:MM)
  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Horário de início formatado
  String get formattedStartTime {
    return DateFormat('HH:mm').format(startTime);
  }

  /// Horário de fim formatado
  String get formattedEndTime {
    if (endTime == null) return 'Em andamento';
    return DateFormat('HH:mm').format(endTime!);
  }

  /// Data formatada
  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(startTime);
  }

  /// Verifica se o trecho está ativo (sem end_time)
  bool get isActive => endTime == null;

  /// Distância formatada
  String get formattedDistance {
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Velocidade média formatada
  String get formattedAvgSpeed {
    if (avgSpeedKmh == null) return 'N/A';
    return '${avgSpeedKmh!.toStringAsFixed(1)} km/h';
  }

  /// Velocidade máxima formatada
  String get formattedMaxSpeed {
    if (maxSpeedKmh == null) return 'N/A';
    return '${maxSpeedKmh!.toStringAsFixed(1)} km/h';
  }
}

