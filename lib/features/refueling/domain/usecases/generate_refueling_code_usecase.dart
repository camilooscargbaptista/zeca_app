import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/refueling_code_entity.dart';
import '../repositories/refueling_repository.dart';

@injectable
class GenerateRefuelingCodeUseCase {
  final RefuelingRepository repository;

  GenerateRefuelingCodeUseCase(this.repository);

  Future<Either<Failure, RefuelingCodeEntity>> call({
    required String veiculoId,
    required String veiculoPlaca,
    required int kmAtual,
    required String combustivel,
    required bool abastecerArla,
    required String? postoId,
    required String? postoCnpj,
    String? observacoes,
  }) async {
    return await repository.generateRefuelingCode(
      veiculoId: veiculoId,
      veiculoPlaca: veiculoPlaca,
      kmAtual: kmAtual,
      combustivel: combustivel,
      abastecerArla: abastecerArla,
      postoId: postoId,
      postoCnpj: postoCnpj,
      observacoes: observacoes,
    );
  }
}
