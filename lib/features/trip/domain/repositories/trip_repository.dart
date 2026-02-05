import 'package:dartz/dartz.dart';
import '../entities/trip.dart';
import '../entities/trip_summary.dart';
import '../../../../core/errors/failures.dart';

/// Abstract repository for Trip operations
abstract class TripRepository {
  /// Get the active trip for the current user
  Future<Either<Failure, Trip?>> getActiveTrip();

  /// Get trip by ID
  Future<Either<Failure, Trip>> getTripById(String tripId);

  /// Start a new trip
  Future<Either<Failure, Trip>> startTrip({
    required String vehicleId,
    String? origin,
    String? destination,
  });

  /// Finish the active trip
  Future<Either<Failure, Trip>> finishTrip(String tripId);

  /// Get trip summary with financial data
  Future<Either<Failure, TripSummary>> getTripSummary(String tripId);
}
