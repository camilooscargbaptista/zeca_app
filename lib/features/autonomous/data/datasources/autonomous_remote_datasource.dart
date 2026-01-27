import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/autonomous_vehicle_model.dart';
import '../models/register_autonomous_model.dart';

abstract class AutonomousRemoteDataSource {
  /// Registrar motorista autônomo
  Future<RegisterAutonomousResponse> register(RegisterAutonomousRequest request);
  
  /// Buscar termos de uso
  Future<TermsVersionModel?> getTerms();
  
  /// Verificar se CPF já existe
  Future<CheckCpfResponse> checkCpf(String cpf);
  
  /// Listar veículos do autônomo
  Future<List<AutonomousVehicleModel>> getVehicles();
  
  /// Contar veículos
  Future<Map<String, int>> countVehicles();
  
  /// Criar veículo
  Future<AutonomousVehicleModel> createVehicle(CreateAutonomousVehicleRequest request);
  
  /// Atualizar veículo
  Future<AutonomousVehicleModel> updateVehicle(String id, UpdateAutonomousVehicleRequest request);
  
  /// Remover veículo
  Future<void> deleteVehicle(String id);
}

@LazySingleton(as: AutonomousRemoteDataSource)
class AutonomousRemoteDataSourceImpl implements AutonomousRemoteDataSource {
  final DioClient _client;
  
  static const String _basePath = '/autonomous';
  
  AutonomousRemoteDataSourceImpl(this._client);
  
  @override
  Future<RegisterAutonomousResponse> register(RegisterAutonomousRequest request) async {
    final response = await _client.post(
      '$_basePath/register',
      data: request.toJson(),
    );
    return RegisterAutonomousResponse.fromJson(response.data);
  }
  
  @override
  Future<TermsVersionModel?> getTerms() async {
    final response = await _client.get('$_basePath/terms');
    if (response.data == null) return null;
    return TermsVersionModel.fromJson(response.data);
  }
  
  @override
  Future<CheckCpfResponse> checkCpf(String cpf) async {
    final response = await _client.get(
      '$_basePath/check-cpf',
      queryParameters: {'cpf': cpf},
    );
    return CheckCpfResponse.fromJson(response.data);
  }
  
  @override
  Future<List<AutonomousVehicleModel>> getVehicles() async {
    final response = await _client.get('$_basePath/vehicles');
    final List<dynamic> data = response.data;
    return data.map((e) => AutonomousVehicleModel.fromJson(e)).toList();
  }
  
  @override
  Future<Map<String, int>> countVehicles() async {
    final response = await _client.get('$_basePath/vehicles/count');
    return {
      'count': response.data['count'] as int,
      'limit': response.data['limit'] as int,
    };
  }
  
  @override
  Future<AutonomousVehicleModel> createVehicle(CreateAutonomousVehicleRequest request) async {
    final response = await _client.post(
      '$_basePath/vehicles',
      data: request.toJson(),
    );
    return AutonomousVehicleModel.fromJson(response.data);
  }
  
  @override
  Future<AutonomousVehicleModel> updateVehicle(String id, UpdateAutonomousVehicleRequest request) async {
    final response = await _client.put(
      '$_basePath/vehicles/$id',
      data: request.toJson(),
    );
    return AutonomousVehicleModel.fromJson(response.data);
  }
  
  @override
  Future<void> deleteVehicle(String id) async {
    await _client.delete('$_basePath/vehicles/$id');
  }
}
