import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/refueling_code_entity.dart';
import '../entities/refueling_entity.dart';
import '../entities/document_entity.dart';

abstract class RefuelingRepository {
  Future<Either<Failure, RefuelingCodeEntity>> generateRefuelingCode({
    required String veiculoId,
    required String veiculoPlaca,
    required int kmAtual,
    required String combustivel,
    required bool abastecerArla,
    required String? postoId,
    required String? postoCnpj,
    String? observacoes,
  });

  Future<Either<Failure, RefuelingCodeEntity>> validateRefuelingCode(String codigo);

  Future<Either<Failure, RefuelingEntity>> finalizeRefueling({
    required String refuelingId,
    required double quantidadeLitros,
    required double valorTotal,
    required int kmFinal,
    double? quantidadeArla,
    double? valorArla,
    String? observacoes,
    required List<String> comprovantesIds,
  });

  Future<Either<Failure, RefuelingEntity>> cancelRefueling({
    required String refuelingId,
    required String motivo,
    String? observacoes,
  });

  Future<Either<Failure, RefuelingEntity>> getRefuelingStatus(String refuelingId);

  Future<Either<Failure, List<RefuelingEntity>>> getRefuelingHistory({
    int page = 1,
    int limit = 20,
    String? veiculoId,
    String? dataInicio,
    String? dataFim,
    String? status,
    String? search,
  });
}
