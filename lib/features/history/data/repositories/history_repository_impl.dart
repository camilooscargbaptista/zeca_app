import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/refueling_history_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';

/// Implementação do repository de histórico
@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource _remoteDataSource;

  HistoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, (List<RefuelingHistoryEntity>, int total, bool hasMore)>> getHistory({
    int page = 1,
    int limit = 10,
    HistoryFiltersEntity? filters,
  }) async {
    try {
      // Formatar datas para o formato esperado pelo backend
      String? startDate;
      String? endDate;
      
      if (filters?.startDate != null) {
        startDate = filters!.startDate!.toIso8601String().split('T')[0];
      }
      if (filters?.endDate != null) {
        endDate = filters!.endDate!.toIso8601String().split('T')[0];
      }

      final response = await _remoteDataSource.getHistory(
        page: page,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        vehiclePlate: filters?.vehiclePlate,
        status: filters?.status,
      );

      // Converter models para entities
      final entities = response.data.map((model) => model.toEntity()).toList();
      
      return Right((entities, response.total, response.hasMore));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RefuelingHistoryEntity>> getDetails(String id) async {
    try {
      final model = await _remoteDataSource.getDetails(id);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
