import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

/// Use case for starting a new trip
class StartTrip implements UseCase<Trip, StartTripParams> {
  final TripRepository repository;

  StartTrip(this.repository);

  @override
  Future<Either<Failure, Trip>> call(StartTripParams params) async {
    return await repository.startTrip(
      vehicleId: params.vehicleId,
      origin: params.origin,
      destination: params.destination,
    );
  }
}

/// Parameters for StartTrip use case
class StartTripParams extends Equatable {
  final String vehicleId;
  final String? origin;
  final String? destination;

  const StartTripParams({
    required this.vehicleId,
    this.origin,
    this.destination,
  });

  @override
  List<Object?> get props => [vehicleId, origin, destination];
}
