import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/refueling_history_entity.dart';

/// Interface do repository de histórico de abastecimentos
abstract class HistoryRepository {
  /// Busca o histórico de abastecimentos com filtros e paginação
  Future<Either<Failure, (List<RefuelingHistoryEntity>, int total, bool hasMore)>> getHistory({
    int page = 1,
    int limit = 10,
    HistoryFiltersEntity? filters,
  });

  /// Busca os detalhes de um abastecimento específico
  Future<Either<Failure, RefuelingHistoryEntity>> getDetails(String id);
}
