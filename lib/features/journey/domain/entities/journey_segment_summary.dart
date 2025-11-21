/// Resumo simplificado de um trecho (usado no modal de finalização)
class JourneySegmentSummary {
  final int segmentNumber;
  final double distanceKm;
  final int durationSeconds;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;

  JourneySegmentSummary({
    required this.segmentNumber,
    required this.distanceKm,
    required this.durationSeconds,
    this.avgSpeedKmh,
    this.maxSpeedKmh,
  });

  /// Duração formatada (HH:MM)
  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Distância formatada
  String get formattedDistance {
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Velocidade média formatada
  String get formattedAvgSpeed {
    if (avgSpeedKmh == null) return '';
    return '${avgSpeedKmh!.toStringAsFixed(1)} km/h';
  }

  /// Factory para criar a partir de JSON
  factory JourneySegmentSummary.fromJson(Map<String, dynamic> json) {
    return JourneySegmentSummary(
      segmentNumber: json['segment_number'] as int,
      distanceKm: (json['distance_km'] as num).toDouble(),
      durationSeconds: json['duration_seconds'] as int,
      avgSpeedKmh: json['avg_speed_kmh'] != null 
          ? (json['avg_speed_kmh'] as num).toDouble() 
          : null,
      maxSpeedKmh: json['max_speed_kmh'] != null 
          ? (json['max_speed_kmh'] as num).toDouble() 
          : null,
    );
  }
}

