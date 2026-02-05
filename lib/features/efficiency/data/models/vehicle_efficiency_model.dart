/// Model for current vehicle efficiency data
/// Endpoint: GET /app/efficiency/vehicle
class VehicleEfficiencyModel {
  final String id;
  final String plate;
  final String? model;
  final double? lastConsumptionKmL;
  final double? movingAvgKmL;
  final double? historicalAvgKmL;
  final double? idealConsumption;
  final String trend; // IMPROVING | STABLE | WORSENING

  VehicleEfficiencyModel({
    required this.id,
    required this.plate,
    this.model,
    this.lastConsumptionKmL,
    this.movingAvgKmL,
    this.historicalAvgKmL,
    this.idealConsumption,
    this.trend = 'STABLE',
  });

  factory VehicleEfficiencyModel.fromJson(Map<String, dynamic> json) {
    return VehicleEfficiencyModel(
      id: json['id'] ?? '',
      plate: json['plate'] ?? '',
      model: json['model'],
      lastConsumptionKmL: json['lastConsumptionKmL'] != null
          ? (json['lastConsumptionKmL'] as num).toDouble()
          : null,
      movingAvgKmL: json['movingAvgKmL'] != null
          ? (json['movingAvgKmL'] as num).toDouble()
          : null,
      historicalAvgKmL: json['historicalAvgKmL'] != null
          ? (json['historicalAvgKmL'] as num).toDouble()
          : null,
      idealConsumption: json['idealConsumption'] != null
          ? (json['idealConsumption'] as num).toDouble()
          : null,
      trend: json['trend'] ?? 'STABLE',
    );
  }

  /// Format last consumption for display
  String formatLastConsumption({bool useL100km = false}) {
    if (lastConsumptionKmL == null) return '— km/L';
    if (useL100km) {
      final l100 = 100 / lastConsumptionKmL!;
      return '${l100.toStringAsFixed(1)} L/100km';
    }
    return '${lastConsumptionKmL!.toStringAsFixed(1)} km/L';
  }

  /// Format moving average for display
  String formatMovingAvg({bool useL100km = false}) {
    if (movingAvgKmL == null) return '— km/L';
    if (useL100km) {
      final l100 = 100 / movingAvgKmL!;
      return '${l100.toStringAsFixed(1)} L/100km';
    }
    return '${movingAvgKmL!.toStringAsFixed(1)} km/L';
  }

  /// Format ideal consumption for display
  String formatIdealConsumption({bool useL100km = false}) {
    if (idealConsumption == null) return '— km/L';
    if (useL100km) {
      final l100 = 100 / idealConsumption!;
      return '${l100.toStringAsFixed(1)} L/100km';
    }
    return '${idealConsumption!.toStringAsFixed(1)} km/L';
  }

  /// Check if vehicle has efficiency data
  bool get hasData => lastConsumptionKmL != null || movingAvgKmL != null;
}
