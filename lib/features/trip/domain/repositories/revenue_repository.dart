import 'package:dartz/dartz.dart';
import '../entities/trip_revenue.dart';
import '../../../../core/error/failures.dart';

/// Abstract repository for Revenue operations
abstract class RevenueRepository {
  /// Get revenues for a trip
  Future<Either<Failure, List<TripRevenue>>> getRevenuesByTrip(String tripId);

  /// Create a new revenue
  Future<Either<Failure, TripRevenue>> createRevenue({
    required String tripId,
    required double amount,
    String? origin,
    String? destination,
    String? clientName,
    String status = 'PENDING',
  });

  /// Mark revenue as paid
  Future<Either<Failure, TripRevenue>> markAsPaid(String revenueId);

  /// Get total revenues for a trip
  Future<Either<Failure, double>> getTotalRevenuesByTrip(String tripId);
}
