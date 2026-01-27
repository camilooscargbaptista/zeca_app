import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/fuel_station_model.dart';
import '../models/nearby_station_model.dart';
import '../models/fuel_type_model.dart';

abstract class FuelStationRemoteDataSource {
  Future<List<FuelStationModel>> getCompanyFuelStations();
  Future<FuelStationModel> validateStation(String cnpj);
  Future<FuelStationModel> validateStationByCnpj(String cnpj);
  Future<FuelStationModel> getStationById(String id);
  Future<List<NearbyStationModel>> getNearbyStations(double latitude, double longitude, double radiusKm);
  Future<Map<String, double>> getStationPrices(String stationId);
  Future<List<FuelPriceModel>> getFuelPrices();
  Future<List<FuelTypeModel>> getFuelTypes();
  Future<List<FuelPriceHistoryModel>> getPriceHistory(String stationId, String fuelTypeId);
}

@LazySingleton(as: FuelStationRemoteDataSource)
class FuelStationRemoteDataSourceImpl implements FuelStationRemoteDataSource {
  final DioClient _client;
  
  FuelStationRemoteDataSourceImpl(this._client);
  
  @override
  Future<List<FuelStationModel>> getCompanyFuelStations() async {
    final response = await _client.get(ApiConstants.companyFuelStations);
    final List<dynamic> stationsJson = response.data['data'];
    return stationsJson.map((json) => FuelStationModel.fromJson(json)).toList();
  }
  
  @override
  Future<FuelStationModel> validateStation(String cnpj) async {
    final response = await _client.post(
      ApiConstants.validateStation,
      data: {'cnpj': cnpj},
    );
    return FuelStationModel.fromJson(response.data['data']);
  }
  
  @override
  Future<FuelStationModel> validateStationByCnpj(String cnpj) async {
    final response = await _client.get(
      '${ApiConstants.fuelStations}/validate/$cnpj',
    );
    return FuelStationModel.fromJson(response.data['data']);
  }
  
  @override
  Future<FuelStationModel> getStationById(String id) async {
    final response = await _client.get('${ApiConstants.fuelStations}/$id');
    return FuelStationModel.fromJson(response.data['data']);
  }
  
  @override
  Future<List<NearbyStationModel>> getNearbyStations(
    double latitude,
    double longitude,
    double radiusKm,
  ) async {
    final response = await _client.get(
      ApiConstants.nearbyStations,
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'radius': radiusKm.toInt(),
      },
    );
    
    // O backend novo retorna { success: true, data: [...], meta: {...} }
    // As vezes o DioClient já extrai o data se tiver interceptor, mas vou assumir response.data['data']
    final List<dynamic> stationsJson = response.data['data'];
    return stationsJson.map((json) => NearbyStationModel.fromJson(json)).toList();
  }
  
  @override
  Future<Map<String, double>> getStationPrices(String stationId) async {
    final response = await _client.get(
      ApiConstants.stationPrices.replaceAll('{id}', stationId),
    );
    return Map<String, double>.from(response.data['data']);
  }
  
  @override
  Future<List<FuelPriceModel>> getFuelPrices() async {
    final response = await _client.get(ApiConstants.fuelPrices);
    final List<dynamic> pricesJson = response.data['data'];
    return pricesJson.map((json) => FuelPriceModel.fromJson(json)).toList();
  }
  
  @override
  Future<List<FuelTypeModel>> getFuelTypes() async {
    final response = await _client.get(ApiConstants.fuelTypes);
    final List<dynamic> typesJson = response.data['data'];
    return typesJson.map((json) => FuelTypeModel.fromJson(json)).toList();
  }
  
  @override
  Future<List<FuelPriceHistoryModel>> getPriceHistory(
    String stationId,
    String fuelTypeId,
  ) async {
    final response = await _client.get(
      '${ApiConstants.fuelPrices}/history',
      queryParameters: {
        'station_id': stationId,
        'fuel_type_id': fuelTypeId,
      },
    );
    final List<dynamic> historyJson = response.data['data'];
    return historyJson.map((json) => FuelPriceHistoryModel.fromJson(json)).toList();
  }
}
