import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

/// Use case for finishing an active trip
class FinishTrip implements UseCase<Trip, FinishTripParams> {
  final TripRepository repository;

  FinishTrip(this.repository);

  @override
  Future<Either<Failure, Trip>> call(FinishTripParams params) async {
    return await repository.finishTrip(params.tripId);
  }
}

/// Parameters for FinishTrip use case
class FinishTripParams extends Equatable {
  final String tripId;

  const FinishTripParams({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}
