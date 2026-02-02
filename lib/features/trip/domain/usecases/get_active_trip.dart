import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

/// Use case to get the active trip
class GetActiveTrip implements UseCase<Trip?, NoParams> {
  final TripRepository repository;

  GetActiveTrip(this.repository);

  @override
  Future<Either<Failure, Trip?>> call(NoParams params) async {
    return await repository.getActiveTrip();
  }
}
