import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../models/refueling_history_model.dart';

/// Interface para o datasource remoto de histórico
abstract class HistoryRemoteDataSource {
  /// Busca o histórico de abastecimentos com filtros e paginação
  Future<HistoryResponseModel> getHistory({
    int page = 1,
    int limit = 10,
    String? startDate,
    String? endDate,
    String? vehiclePlate,
    String? status,
  });

  /// Busca os detalhes de um abastecimento específico
  Future<RefuelingHistoryModel> getDetails(String id);
}

/// Implementação do datasource remoto de histórico
@Injectable(as: HistoryRemoteDataSource)
class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final DioClient _client;

  HistoryRemoteDataSourceImpl(this._client);

  @override
  Future<HistoryResponseModel> getHistory({
    int page = 1,
    int limit = 10,
    String? startDate,
    String? endDate,
    String? vehiclePlate,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    // Adicionar filtros opcionais
    if (startDate != null && endDate != null) {
      queryParams['start_date'] = startDate;
      queryParams['end_date'] = endDate;
    }
    if (vehiclePlate != null && vehiclePlate.isNotEmpty) {
      queryParams['vehicle_plate'] = vehiclePlate;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    // Usar endpoint correto do backend: GET /refueling
    final response = await _client.get(
      '/refueling',
      queryParameters: queryParams,
    );

    // Parsear resposta
    final List<dynamic> dataJson = response.data['data'] ?? [];
    final refuelings = dataJson
        .map((json) => RefuelingHistoryModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return HistoryResponseModel(
      data: refuelings,
      total: response.data['total'] ?? refuelings.length,
      page: response.data['page'] ?? page,
      limit: response.data['limit'] ?? limit,
    );
  }

  @override
  Future<RefuelingHistoryModel> getDetails(String id) async {
    // Usar endpoint: GET /refueling/:id
    final response = await _client.get('/refueling/$id');
    
    return RefuelingHistoryModel.fromJson(response.data);
  }
}
