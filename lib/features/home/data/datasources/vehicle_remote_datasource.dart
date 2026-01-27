import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getCompanyVehicles();
  Future<VehicleModel> searchVehicle(String plate);
  Future<VehicleModel> searchVehicleByPlaca(String placa);
  Future<VehicleModel> validateVehicle(String plate);
  Future<VehicleModel> getVehicleById(String id);
  Future<List<VehicleModel>> getVehicleHistory(String vehicleId);
  Future<VehicleModel> updateVehicle(String id, Map<String, dynamic> data);
}

@LazySingleton(as: VehicleRemoteDataSource)
class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final DioClient _client;
  
  VehicleRemoteDataSourceImpl(this._client);
  
  @override
  Future<List<VehicleModel>> getCompanyVehicles() async {
    final response = await _client.get(ApiConstants.companyVehicles);
    final List<dynamic> vehiclesJson = response.data['data'];
    return vehiclesJson.map((json) => VehicleModel.fromJson(json)).toList();
  }
  
  @override
  Future<VehicleModel> searchVehicle(String plate) async {
    final response = await _client.get(
      ApiConstants.searchVehicle,
      queryParameters: {'plate': plate},
    );
    return VehicleModel.fromJson(response.data['data']);
  }
  
  @override
  Future<VehicleModel> searchVehicleByPlaca(String placa) async {
    final response = await _client.get(
      '${ApiConstants.vehicles}/search/$placa',
    );
    return VehicleModel.fromJson(response.data['data']);
  }
  
  @override
  Future<VehicleModel> validateVehicle(String plate) async {
    final response = await _client.post(
      ApiConstants.validateVehicle,
      data: {'plate': plate},
    );
    return VehicleModel.fromJson(response.data['data']);
  }
  
  @override
  Future<VehicleModel> getVehicleById(String id) async {
    final response = await _client.get('${ApiConstants.vehicles}/$id');
    return VehicleModel.fromJson(response.data['data']);
  }
  
  @override
  Future<List<VehicleModel>> getVehicleHistory(String vehicleId) async {
    final response = await _client.get(
      ApiConstants.vehicleHistory.replaceAll('{id}', vehicleId),
    );
    final List<dynamic> historyJson = response.data['data'];
    return historyJson.map((json) => VehicleModel.fromJson(json)).toList();
  }
  
  @override
  Future<VehicleModel> updateVehicle(String id, Map<String, dynamic> data) async {
    final response = await _client.put(
      '${ApiConstants.vehicles}/$id',
      data: data,
    );
    return VehicleModel.fromJson(response.data['data']);
  }
}
