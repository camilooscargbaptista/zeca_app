class LocationPointEntity {
  final String id;
  final String journeyId;
  final double latitude;
  final double longitude;
  final double velocidade; // km/h
  final DateTime timestamp;
  final bool sincronizado;
  final DateTime createdAt;

  LocationPointEntity({
    required this.id,
    required this.journeyId,
    required this.latitude,
    required this.longitude,
    required this.velocidade,
    required this.timestamp,
    required this.sincronizado,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'journey_id': journeyId,
      'latitude': latitude,
      'longitude': longitude,
      'velocidade': velocidade,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

