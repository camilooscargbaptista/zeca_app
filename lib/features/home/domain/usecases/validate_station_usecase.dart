import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/fuel_station_entity.dart';
import '../repositories/fuel_station_repository.dart';

@injectable
class ValidateStationUseCase {
  final FuelStationRepository repository;

  ValidateStationUseCase(this.repository);

  Future<Either<Failure, FuelStationEntity>> call(String cnpj) async {
    return await repository.validateStationByCnpj(cnpj);
  }
}
