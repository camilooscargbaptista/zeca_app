import 'package:equatable/equatable.dart';

/// Entity representing a Trip Revenue (Freight)
class TripRevenue extends Equatable {
  final String id;
  final String tripId;
  final double amount;
  final String? origin;
  final String? destination;
  final String? clientName;
  final String status;
  final DateTime? paidAt;
  final DateTime createdAt;

  const TripRevenue({
    required this.id,
    required this.tripId,
    required this.amount,
    this.origin,
    this.destination,
    this.clientName,
    required this.status,
    this.paidAt,
    required this.createdAt,
  });

  bool get isPaid => status == 'PAID';
  bool get isPending => status == 'PENDING';

  @override
  List<Object?> get props => [
        id,
        tripId,
        amount,
        origin,
        destination,
        clientName,
        status,
        paidAt,
        createdAt,
      ];
}
