import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/refueling_code_entity.dart';
import '../repositories/refueling_repository.dart';

@injectable
class ValidateRefuelingCodeUseCase {
  final RefuelingRepository repository;

  ValidateRefuelingCodeUseCase(this.repository);

  Future<Either<Failure, RefuelingCodeEntity>> call(String codigo) async {
    return await repository.validateRefuelingCode(codigo);
  }
}
