/// Model for driver efficiency summary from API
/// Endpoint: GET /app/efficiency/summary
class EfficiencySummaryModel {
  final double? lastVehicleConsumptionKmL;
  final double? personalAvgKmL;
  final double? fleetAvgKmL;
  final double? deviationFromFleetPercent;
  final String personalTrend; // IMPROVING | STABLE | WORSENING
  final int? rankInFleet;
  final int totalDriversInFleet;

  EfficiencySummaryModel({
    this.lastVehicleConsumptionKmL,
    this.personalAvgKmL,
    this.fleetAvgKmL,
    this.deviationFromFleetPercent,
    this.personalTrend = 'STABLE',
    this.rankInFleet,
    this.totalDriversInFleet = 0,
  });

  factory EfficiencySummaryModel.fromJson(Map<String, dynamic> json) {
    return EfficiencySummaryModel(
      lastVehicleConsumptionKmL: json['lastVehicleConsumptionKmL'] != null
          ? (json['lastVehicleConsumptionKmL'] as num).toDouble()
          : null,
      personalAvgKmL: json['personalAvgKmL'] != null
          ? (json['personalAvgKmL'] as num).toDouble()
          : null,
      fleetAvgKmL: json['fleetAvgKmL'] != null
          ? (json['fleetAvgKmL'] as num).toDouble()
          : null,
      deviationFromFleetPercent: json['deviationFromFleetPercent'] != null
          ? (json['deviationFromFleetPercent'] as num).toDouble()
          : null,
      personalTrend: json['personalTrend'] ?? 'STABLE',
      rankInFleet: json['rankInFleet'],
      totalDriversInFleet: json['totalDriversInFleet'] ?? 0,
    );
  }

  /// Empty state factory
  factory EfficiencySummaryModel.empty() {
    return EfficiencySummaryModel();
  }

  /// Check if data is available - calculated based on personalAvgKmL
  bool get hasData => personalAvgKmL != null && personalAvgKmL! > 0;

  /// Check if data is available for display
  bool get canDisplay => hasData;

  /// Get trend icon based on personalTrend
  String get trendIcon {
    switch (personalTrend) {
      case 'IMPROVING':
        return '↑';
      case 'WORSENING':
        return '↓';
      default:
        return '→';
    }
  }

  /// Get trend label in Portuguese
  String get trendLabel {
    switch (personalTrend) {
      case 'IMPROVING':
        return 'Melhorando';
      case 'WORSENING':
        return 'Piorando';
      default:
        return 'Estável';
    }
  }

  /// Check if performance is better than fleet average
  bool get isBetterThanFleet =>
      deviationFromFleetPercent != null && deviationFromFleetPercent! > 0;

  /// Format deviation for display (e.g., "+3%" or "-5%")
  String get deviationDisplay {
    if (deviationFromFleetPercent == null) return '-';
    final sign = deviationFromFleetPercent! >= 0 ? '+' : '';
    return '$sign${deviationFromFleetPercent!.toStringAsFixed(0)}%';
  }

  /// Convert km/L to L/100km
  double? get lastVehicleConsumptionL100km {
    if (lastVehicleConsumptionKmL == null || lastVehicleConsumptionKmL == 0) {
      return null;
    }
    return 100 / lastVehicleConsumptionKmL!;
  }

  /// Convert personal average km/L to L/100km
  double? get personalAvgL100km {
    if (personalAvgKmL == null || personalAvgKmL == 0) return null;
    return 100 / personalAvgKmL!;
  }
}
