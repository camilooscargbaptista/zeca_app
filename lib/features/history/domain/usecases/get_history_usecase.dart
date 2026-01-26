import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/refueling_history_entity.dart';
import '../repositories/history_repository.dart';

/// Parâmetros para o use case de buscar histórico
class GetHistoryParams {
  final int page;
  final int limit;
  final HistoryFiltersEntity? filters;

  const GetHistoryParams({
    this.page = 1,
    this.limit = 10,
    this.filters,
  });
}

/// Use case para buscar o histórico de abastecimentos
@injectable
class GetHistoryUseCase {
  final HistoryRepository _repository;

  GetHistoryUseCase(this._repository);

  /// Executa a busca do histórico
  Future<Either<Failure, (List<RefuelingHistoryEntity>, int total, bool hasMore)>> call(
    GetHistoryParams params,
  ) async {
    return await _repository.getHistory(
      page: params.page,
      limit: params.limit,
      filters: params.filters,
    );
  }
}

/// Use case para buscar detalhes de um abastecimento
@injectable
class GetRefuelingDetailsUseCase {
  final HistoryRepository _repository;

  GetRefuelingDetailsUseCase(this._repository);

  /// Executa a busca dos detalhes
  Future<Either<Failure, RefuelingHistoryEntity>> call(String id) async {
    return await _repository.getDetails(id);
  }
}
