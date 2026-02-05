import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trip_revenue.dart';
import '../repositories/revenue_repository.dart';

/// UseCase for creating a new revenue/freight
@lazySingleton
class CreateRevenue implements UseCase<TripRevenue, CreateRevenueParams> {
  final RevenueRepository _repository;

  CreateRevenue(this._repository);

  @override
  Future<Either<Failure, TripRevenue>> call(CreateRevenueParams params) {
    return _repository.createRevenue(
      tripId: params.tripId,
      vehicleId: params.vehicleId,
      amount: params.amount,
      origin: params.origin,
      destination: params.destination,
      clientName: params.clientName,
    );
  }
}

class CreateRevenueParams extends Equatable {
  final String tripId;
  final String vehicleId;
  final double amount;
  final String? origin;
  final String? destination;
  final String? clientName;

  const CreateRevenueParams({
    required this.tripId,
    required this.vehicleId,
    required this.amount,
    this.origin,
    this.destination,
    this.clientName,
  });

  @override
  List<Object?> get props => [tripId, vehicleId, amount, origin, destination, clientName];
}
