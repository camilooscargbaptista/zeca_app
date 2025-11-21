import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/refueling_entity.dart';
import '../repositories/refueling_repository.dart';

@injectable
class FinalizeRefuelingUseCase {
  final RefuelingRepository repository;

  FinalizeRefuelingUseCase(this.repository);

  Future<Either<Failure, RefuelingEntity>> call({
    required String refuelingId,
    required double quantidadeLitros,
    required double valorTotal,
    required int kmFinal,
    double? quantidadeArla,
    double? valorArla,
    String? observacoes,
    required List<String> comprovantesIds,
  }) async {
    return await repository.finalizeRefueling(
      refuelingId: refuelingId,
      quantidadeLitros: quantidadeLitros,
      valorTotal: valorTotal,
      kmFinal: kmFinal,
      quantidadeArla: quantidadeArla,
      valorArla: valorArla,
      observacoes: observacoes,
      comprovantesIds: comprovantesIds,
    );
  }
}
