/// Model for refueling history with efficiency data
/// Endpoint: GET /app/efficiency/history
class RefuelingHistoryModel {
  final String id;
  final String vehicleId;
  final String? vehiclePlate;
  final double quantityLiters;
  final double? odometerReading;
  final double? kmTraveled;
  final double? consumptionKmL;
  final double? deviationPercent;
  final bool isAnomaly;
  final DateTime refuelingDatetime;
  final String? fuelType;

  RefuelingHistoryModel({
    required this.id,
    required this.vehicleId,
    this.vehiclePlate,
    required this.quantityLiters,
    this.odometerReading,
    this.kmTraveled,
    this.consumptionKmL,
    this.deviationPercent,
    this.isAnomaly = false,
    required this.refuelingDatetime,
    this.fuelType,
  });

  factory RefuelingHistoryModel.fromJson(Map<String, dynamic> json) {
    return RefuelingHistoryModel(
      id: json['id'] ?? '',
      vehicleId: json['vehicleId'] ?? json['vehicle_id'] ?? '',
      vehiclePlate: json['vehiclePlate'] ?? json['vehicle_plate'],
      quantityLiters: (json['quantityLiters'] ?? json['quantity_liters'] ?? 0).toDouble(),
      odometerReading: json['odometerReading'] != null || json['odometer_reading'] != null
          ? ((json['odometerReading'] ?? json['odometer_reading']) as num).toDouble()
          : null,
      kmTraveled: json['kmTraveled'] != null || json['km_traveled'] != null
          ? ((json['kmTraveled'] ?? json['km_traveled']) as num).toDouble()
          : null,
      consumptionKmL: json['consumptionKmL'] != null || json['consumption_km_l'] != null
          ? ((json['consumptionKmL'] ?? json['consumption_km_l']) as num).toDouble()
          : null,
      deviationPercent: json['deviationPercent'] != null || json['deviation_percent'] != null
          ? ((json['deviationPercent'] ?? json['deviation_percent']) as num).toDouble()
          : null,
      isAnomaly: json['isAnomaly'] ?? json['is_anomaly'] ?? false,
      refuelingDatetime: DateTime.parse(
        json['refuelingDatetime'] ?? json['refueling_datetime'] ?? DateTime.now().toIso8601String(),
      ),
      fuelType: json['fuelType'] ?? json['fuel_type'],
    );
  }

  /// Convert km/L to L/100km
  double? get consumptionL100km {
    if (consumptionKmL == null || consumptionKmL == 0) return null;
    return 100 / consumptionKmL!;
  }

  /// Format consumption for display
  String formatConsumption({bool useL100km = false}) {
    if (consumptionKmL == null) return '— km/L';
    if (useL100km) {
      final l100 = consumptionL100km;
      if (l100 == null) return '— L/100km';
      return '${l100.toStringAsFixed(1)} L/100km';
    }
    return '${consumptionKmL!.toStringAsFixed(1)} km/L';
  }

  /// Format deviation for display
  String get deviationDisplay {
    if (deviationPercent == null) return '';
    final sign = deviationPercent! >= 0 ? '+' : '';
    return '$sign${deviationPercent!.toStringAsFixed(0)}%';
  }

  /// Get day of month for display
  String get dayDisplay => refuelingDatetime.day.toString().padLeft(2, '0');

  /// Get month abbreviation for display
  String get monthDisplay {
    const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    return months[refuelingDatetime.month - 1];
  }

  /// Check if consumption data is available
  bool get hasConsumptionData => consumptionKmL != null && kmTraveled != null;

  /// Format details string for history list
  String get detailsDisplay {
    final parts = <String>[];
    if (vehiclePlate != null) parts.add(vehiclePlate!);
    parts.add('${quantityLiters.toStringAsFixed(0)} L');
    if (kmTraveled != null) {
      parts.add('${kmTraveled!.toStringAsFixed(0)} km');
    }
    return parts.join(' • ');
  }
}

/// Paginated response wrapper
class PaginatedRefuelingHistory {
  final List<RefuelingHistoryModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginatedRefuelingHistory({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedRefuelingHistory.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] ?? json['data'] ?? []) as List;
    return PaginatedRefuelingHistory(
      items: itemsList.map((e) => RefuelingHistoryModel.fromJson(e)).toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? json['total_pages'] ?? 1,
    );
  }

  bool get hasMore => page < totalPages;
}
