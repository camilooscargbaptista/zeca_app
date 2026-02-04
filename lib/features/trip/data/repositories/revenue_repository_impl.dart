import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/trip_revenue.dart';
import '../../domain/repositories/revenue_repository.dart';
import '../datasources/revenue_remote_datasource.dart';

@LazySingleton(as: RevenueRepository)
class RevenueRepositoryImpl implements RevenueRepository {
  final RevenueRemoteDatasource _datasource;

  RevenueRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<TripRevenue>>> getRevenuesByTrip(String tripId) async {
    try {
      final data = await _datasource.getRevenuesByTrip(tripId);
      final revenues = data.map((json) => _mapToEntity(json)).toList();
      return Right(revenues);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripRevenue>> createRevenue({
    required String tripId,
    required double amount,
    String? origin,
    String? destination,
    String? clientName,
    String status = 'PENDING',
    String? vehicleId,
  }) async {
    try {
      if (vehicleId == null) {
        return const Left(ServerFailure(message: 'vehicleId é obrigatório'));
      }
      
      final data = await _datasource.createRevenue(
        vehicleId: vehicleId,
        tripId: tripId,
        totalAmount: amount,
        originCity: origin,
        destinationCity: destination,
        clientName: clientName,
      );
      return Right(_mapToEntity(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripRevenue>> markAsPaid(String revenueId) async {
    // TODO: Implement when API supports
    return const Left(ServerFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, double>> getTotalRevenuesByTrip(String tripId) async {
    try {
      final result = await getRevenuesByTrip(tripId);
      return result.fold(
        (failure) => Left(failure),
        (revenues) {
          final total = revenues.fold<double>(0, (sum, r) => sum + r.amount);
          return Right(total);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  TripRevenue _mapToEntity(Map<String, dynamic> json) {
    return TripRevenue(
      id: json['id'] as String,
      tripId: json['trip_id'] as String? ?? '',
      amount: _parseAmount(json['total_amount'] ?? json['amount']),
      origin: json['origin_city'] as String?,
      destination: json['destination_city'] as String?,
      clientName: json['client_name'] as String?,
      status: json['payment_status'] as String? ?? 'PENDING',
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  double _parseAmount(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
