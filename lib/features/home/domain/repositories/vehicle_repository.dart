import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<Either<Failure, VehicleEntity>> searchVehicleByPlaca(String placa);
  Future<Either<Failure, List<VehicleEntity>>> getVehiclesByCompany({
    int page = 1,
    int limit = 20,
    String? search,
    bool? ativo,
  });
  Future<Either<Failure, VehicleEntity>> getVehicleById(String id);
}
