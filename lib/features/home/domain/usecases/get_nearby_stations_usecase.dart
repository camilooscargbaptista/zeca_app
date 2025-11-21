import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/fuel_station_entity.dart';
import '../repositories/fuel_station_repository.dart';

@injectable
class GetNearbyStationsUseCase {
  final FuelStationRepository repository;

  GetNearbyStationsUseCase(this.repository);

  Future<Either<Failure, List<FuelStationEntity>>> call({
    required double latitude,
    required double longitude,
    int radius = 10000,
    String? combustivel,
    bool? conveniado,
  }) async {
    return await repository.getNearbyStations(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      combustivel: combustivel,
      conveniado: conveniado,
    );
  }
}
