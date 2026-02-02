import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/trip.dart';
import '../../domain/entities/trip_summary.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_datasource.dart';

@LazySingleton(as: TripRepository)
class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource _remoteDataSource;

  TripRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Trip?>> getActiveTrip() async {
    try {
      final result = await _remoteDataSource.getActiveTrip();
      return Right(result?.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Trip>> getTripById(String tripId) async {
    try {
      final result = await _remoteDataSource.getTripById(tripId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Trip>> startTrip({
    required String vehicleId,
    String? origin,
    String? destination,
  }) async {
    try {
      final result = await _remoteDataSource.startTrip(
        vehicleId: vehicleId,
        origin: origin,
        destination: destination,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Trip>> finishTrip(String tripId) async {
    try {
      final result = await _remoteDataSource.finishTrip(tripId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripSummary>> getTripSummary(String tripId) async {
    try {
      final result = await _remoteDataSource.getTripSummary(tripId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
