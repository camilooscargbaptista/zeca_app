import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/fuel_station_entity.dart';

abstract class FuelStationRepository {
  Future<Either<Failure, List<FuelStationEntity>>> getNearbyStations({
    required double latitude,
    required double longitude,
    int radius = 10000,
    String? combustivel,
    bool? conveniado,
  });
  Future<Either<Failure, FuelStationEntity>> validateStationByCnpj(String cnpj);
  Future<Either<Failure, Map<String, double>>> getStationPrices(String stationId);
}
