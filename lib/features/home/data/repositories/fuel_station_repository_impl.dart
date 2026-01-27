import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/fuel_station_entity.dart';
import '../../domain/repositories/fuel_station_repository.dart';
import '../datasources/fuel_station_remote_datasource.dart';

@LazySingleton(as: FuelStationRepository)
class FuelStationRepositoryImpl implements FuelStationRepository {
  final FuelStationRemoteDataSource _remoteDataSource;

  FuelStationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<FuelStationEntity>>> getNearbyStations({
    required double latitude,
    required double longitude,
    int radius = 10000,
    String? combustivel,
    bool? conveniado,
  }) async {
    try {
      final stationModels = await _remoteDataSource.getNearbyStations(
        latitude,
        longitude,
        radius.toDouble(),
      );
      
      final stationEntities = stationModels.map((model) {
        // Adapter: NearbyStationModel -> FuelStationEntity
        return FuelStationEntity(
          id: model.id,
          cnpj: model.cnpj,
          razaoSocial: model.name, // Nearby retorna 'name', usamos como razao para compatibilidade
          nomeFantasia: model.name,
          endereco: FuelStationAddressEntity(
            logradouro: model.address.street,
            numero: model.address.number ?? 'S/N',
            bairro: '', // Não vem no nearby
            cidade: model.address.city,
            uf: model.address.state,
            cep: '', // Não vem no nearby
            latitude: model.latitude,
            longitude: model.longitude,
          ),
          conveniado: model.isPartner,
          precos: model.pricesMap, // Usando o getter que converte List para Map
          servicos: [], // Não vem no nearby
          formasPagamento: [], // Não vem no nearby
          ativo: true,
          distanciaKm: model.distanceKm,
          contato: null,
          avaliacao: null,
        );
      }).toList();
      
      return Right(stationEntities);
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
  Future<Either<Failure, FuelStationEntity>> validateStationByCnpj(String cnpj) async {
    try {
      final stationModel = await _remoteDataSource.validateStationByCnpj(cnpj);
      final stationEntity = stationModel.toEntity();
      return Right(stationEntity);
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
  Future<Either<Failure, Map<String, double>>> getStationPrices(String stationId) async {
    try {
      final prices = await _remoteDataSource.getStationPrices(stationId);
      return Right(prices);
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
