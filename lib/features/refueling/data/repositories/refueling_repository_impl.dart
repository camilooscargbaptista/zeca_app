import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/refueling_code_entity.dart';
import '../../domain/entities/refueling_entity.dart';
import '../../domain/entities/refueling_shared_entities.dart';
import '../../domain/repositories/refueling_repository.dart';
import '../datasources/refueling_remote_datasource.dart';

@LazySingleton(as: RefuelingRepository)
class RefuelingRepositoryImpl implements RefuelingRepository {
  final RefuelingRemoteDataSource _remoteDataSource;

  RefuelingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, RefuelingCodeEntity>> generateRefuelingCode({
    required String veiculoId,
    required String veiculoPlaca,
    required int kmAtual,
    required String combustivel,
    required bool abastecerArla,
    required String? postoId,
    required String? postoCnpj,
    String? observacoes,
  }) async {
    try {
      final refuelingCodeModel = await _remoteDataSource.generateRefuelingCode(
        veiculoId: veiculoId,
        veiculoPlaca: veiculoPlaca,
        kmAtual: kmAtual,
        combustivel: combustivel,
        abastecerArla: abastecerArla,
        postoId: postoId,
        postoCnpj: postoCnpj,
        observacoes: observacoes,
      );
      final refuelingCodeEntity = refuelingCodeModel.toEntity();
      return Right(refuelingCodeEntity);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RefuelingCodeEntity>> validateRefuelingCode(String codigo) async {
    try {
      final refuelingCodeModel = await _remoteDataSource.validateRefuelingCode(codigo);
      final refuelingCodeEntity = refuelingCodeModel.toEntity();
      return Right(refuelingCodeEntity);
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

  @override
  Future<Either<Failure, RefuelingEntity>> finalizeRefueling({
    required String refuelingId,
    required double quantidadeLitros,
    required double valorTotal,
    required int kmFinal,
    double? quantidadeArla,
    double? valorArla,
    String? observacoes,
    required List<String> comprovantesIds,
  }) async {
    try {
      final refuelingCodeModel = await _remoteDataSource.finalizeRefueling(
        refuelingId: refuelingId,
        quantidadeLitros: quantidadeLitros,
        valorTotal: valorTotal,
        kmFinal: kmFinal,
        quantidadeArla: quantidadeArla,
        valorArla: valorArla,
        observacoes: observacoes,
        comprovantesIds: comprovantesIds,
      );
      
      // Converter RefuelingCodeModel para RefuelingEntity
      final refuelingEntity = _convertToRefuelingEntity(refuelingCodeModel);
      return Right(refuelingEntity);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RefuelingEntity>> cancelRefueling({
    required String refuelingId,
    required String motivo,
    String? observacoes,
  }) async {
    try {
      final refuelingCodeModel = await _remoteDataSource.cancelRefueling(
        refuelingId: refuelingId,
        motivo: motivo,
        observacoes: observacoes,
      );
      
      final refuelingEntity = _convertToRefuelingEntity(refuelingCodeModel);
      return Right(refuelingEntity);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RefuelingEntity>> getRefuelingStatus(String refuelingId) async {
    try {
      final refuelingCodeModel = await _remoteDataSource.getRefuelingStatus(refuelingId);
      final refuelingEntity = _convertToRefuelingEntity(refuelingCodeModel);
      return Right(refuelingEntity);
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

  @override
  Future<Either<Failure, List<RefuelingEntity>>> getRefuelingHistory({
    int page = 1,
    int limit = 20,
    String? veiculoId,
    String? dataInicio,
    String? dataFim,
    String? status,
    String? search,
  }) async {
    try {
      final refuelingCodeModels = await _remoteDataSource.getRefuelingHistory(
        page: page,
        limit: limit,
        veiculoId: veiculoId,
        dataInicio: dataInicio,
        dataFim: dataFim,
        status: status,
        search: search,
      );
      
      final refuelingEntities = refuelingCodeModels
          .map((model) => _convertToRefuelingEntity(model))
          .toList();
      return Right(refuelingEntities);
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

  RefuelingEntity _convertToRefuelingEntity(refuelingCodeModel) {
    // TODO: Implementar conversão completa de RefuelingCodeModel para RefuelingEntity
    // Por enquanto, retorna uma entidade básica
    return RefuelingEntity(
      id: refuelingCodeModel.id,
      codigo: refuelingCodeModel.code,
      status: refuelingCodeModel.status,
      veiculo: RefuelingVehicleEntity(
        id: refuelingCodeModel.vehicleId,
        placa: refuelingCodeModel.vehiclePlate,
        modelo: '',
        marca: '',
      ),
      posto: RefuelingStationEntity(
        id: refuelingCodeModel.stationId,
        cnpj: refuelingCodeModel.stationCnpj,
        nome: '',
        endereco: '',
      ),
      dadosAbastecimento: RefuelingFinalDataEntity(
        quantidadeLitros: 0,
        valorTotal: 0,
        kmFinal: 0,
        valorTotalGeral: 0,
      ),
      comprovantes: [],
    );
  }
}
