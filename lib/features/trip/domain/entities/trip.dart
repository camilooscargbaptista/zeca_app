import 'package:equatable/equatable.dart';

/// Entity representing a Trip
class Trip extends Equatable {
  final String id;
  final String companyId;
  final String vehicleId;
  final String? driverId;
  final String? journeyId;
  final String? origin;
  final String? destination;
  final double? totalDistanceKm;
  final String status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? createdAt;

  const Trip({
    required this.id,
    required this.companyId,
    required this.vehicleId,
    this.driverId,
    this.journeyId,
    this.origin,
    this.destination,
    this.totalDistanceKm,
    required this.status,
    this.startedAt,
    this.endedAt,
    this.createdAt,
  });

  bool get isActive => status == 'ACTIVE';
  bool get isCompleted => status == 'COMPLETED';

  @override
  List<Object?> get props => [
        id,
        companyId,
        vehicleId,
        driverId,
        journeyId,
        origin,
        destination,
        totalDistanceKm,
        status,
        startedAt,
        endedAt,
        createdAt,
      ];
}
