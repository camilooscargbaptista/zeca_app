import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vehicle_entity.dart';
import '../repositories/vehicle_repository.dart';

@injectable
class SearchVehicleUseCase {
  final VehicleRepository repository;

  SearchVehicleUseCase(this.repository);

  Future<Either<Failure, VehicleEntity>> call(String placa) async {
    return await repository.searchVehicleByPlaca(placa);
  }
}
