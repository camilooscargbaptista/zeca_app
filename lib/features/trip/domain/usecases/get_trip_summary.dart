import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trip_summary.dart';
import '../repositories/trip_repository.dart';

/// Use case to get trip summary with financial data
class GetTripSummary implements UseCase<TripSummary, GetTripSummaryParams> {
  final TripRepository repository;

  GetTripSummary(this.repository);

  @override
  Future<Either<Failure, TripSummary>> call(GetTripSummaryParams params) async {
    return await repository.getTripSummary(params.tripId);
  }
}

class GetTripSummaryParams extends Equatable {
  final String tripId;

  const GetTripSummaryParams({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}
