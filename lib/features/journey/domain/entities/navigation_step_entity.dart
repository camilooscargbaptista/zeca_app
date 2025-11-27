/// Representa um passo individual de navegação (turn-by-turn)
/// 
/// Contém informações sobre uma manobra específica na rota,
/// como "Vire à direita na Av. Paulista em 350 metros".
class NavigationStepEntity {
  /// Instrução em texto legível (ex: "Vire à direita na Av. Paulista")
  final String instruction;

  /// Tipo de manobra (turn-right, turn-left, straight, etc.)
  /// Valores possíveis do Google Directions API:
  /// - turn-left, turn-right
  /// - turn-slight-left, turn-slight-right
  /// - turn-sharp-left, turn-sharp-right
  /// - keep-left, keep-right
  /// - uturn-left, uturn-right
  /// - roundabout-left, roundabout-right
  /// - straight, ramp-left, ramp-right
  /// - merge, fork-left, fork-right
  /// - ferry, ferry-train
  final String? maneuver;

  /// Distância deste passo em metros
  final double distanceMeters;

  /// Duração estimada deste passo em segundos
  final int durationSeconds;

  /// Coordenadas do início deste passo
  final double startLat;
  final double startLng;

  /// Coordenadas do fim deste passo
  final double endLat;
  final double endLng;

  NavigationStepEntity({
    required this.instruction,
    this.maneuver,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });

  /// Formata a distância para exibição
  /// Ex: "350m", "1.2km"
  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()}m';
    } else {
      final km = distanceMeters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
  }

  /// Formata a duração para exibição
  /// Ex: "30 seg", "2 min"
  String get formattedDuration {
    if (durationSeconds < 60) {
      return '$durationSeconds seg';
    } else {
      final minutes = (durationSeconds / 60).round();
      return '$minutes min';
    }
  }

  /// Verifica se este passo está ativo (próximo na rota)
  bool isNear(double currentLat, double currentLng, double thresholdMeters) {
    final distance = _calculateDistance(
      currentLat,
      currentLng,
      startLat,
      startLng,
    );
    return distance <= thresholdMeters;
  }

  /// Calcula distância até o início deste passo usando fórmula de Haversine
  double distanceFrom(double lat, double lng) {
    return _calculateDistance(lat, lng, startLat, startLng);
  }

  /// Fórmula de Haversine para calcular distância entre dois pontos GPS
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLng = _toRadians(lng2 - lng1);

    final double a = 
        (dLat / 2).sin() * (dLat / 2).sin() +
        (dLng / 2).sin() * (dLng / 2).sin() *
        _toRadians(lat1).cos() *
        _toRadians(lat2).cos();

    final double c = 2 * (a.sqrt().asin());
    final double distanceKm = earthRadiusKm * c;

    return distanceKm * 1000; // Retornar em metros
  }

  double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  @override
  String toString() {
    return 'NavigationStep(instruction: $instruction, maneuver: $maneuver, distance: $formattedDistance)';
  }
}

