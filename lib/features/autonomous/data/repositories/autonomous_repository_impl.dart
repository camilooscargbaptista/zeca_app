import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/autonomous_remote_datasource.dart';
import '../models/autonomous_vehicle_model.dart';
import '../models/register_autonomous_model.dart';

abstract class AutonomousRepository {
  /// Registrar motorista autônomo
  Future<Either<Failure, RegisterAutonomousResponse>> register(RegisterAutonomousRequest request);
  
  /// Buscar termos de uso
  Future<Either<Failure, TermsVersionModel?>> getTerms();
  
  /// Verificar se CPF já existe
  Future<Either<Failure, bool>> checkCpfExists(String cpf);
  
  /// Listar veículos
  Future<Either<Failure, List<AutonomousVehicleModel>>> getVehicles();
  
  /// Criar veículo
  Future<Either<Failure, AutonomousVehicleModel>> createVehicle(CreateAutonomousVehicleRequest request);
  
  /// Atualizar veículo
  Future<Either<Failure, AutonomousVehicleModel>> updateVehicle(String id, UpdateAutonomousVehicleRequest request);
  
  /// Remover veículo
  Future<Either<Failure, void>> deleteVehicle(String id);
  
  /// Contagem de veículos
  Future<Either<Failure, Map<String, int>>> countVehicles();
}

@LazySingleton(as: AutonomousRepository)
class AutonomousRepositoryImpl implements AutonomousRepository {
  final AutonomousRemoteDataSource _remoteDataSource;
  
  AutonomousRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<Either<Failure, RegisterAutonomousResponse>> register(RegisterAutonomousRequest request) async {
    try {
      final result = await _remoteDataSource.register(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, TermsVersionModel?>> getTerms() async {
    try {
      final result = await _remoteDataSource.getTerms();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> checkCpfExists(String cpf) async {
    try {
      final result = await _remoteDataSource.checkCpf(cpf);
      return Right(result.exists);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<AutonomousVehicleModel>>> getVehicles() async {
    try {
      final result = await _remoteDataSource.getVehicles();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AutonomousVehicleModel>> createVehicle(CreateAutonomousVehicleRequest request) async {
    try {
      final result = await _remoteDataSource.createVehicle(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AutonomousVehicleModel>> updateVehicle(String id, UpdateAutonomousVehicleRequest request) async {
    try {
      final result = await _remoteDataSource.updateVehicle(id, request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteVehicle(String id) async {
    try {
      await _remoteDataSource.deleteVehicle(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Map<String, int>>> countVehicles() async {
    try {
      final result = await _remoteDataSource.countVehicles();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
