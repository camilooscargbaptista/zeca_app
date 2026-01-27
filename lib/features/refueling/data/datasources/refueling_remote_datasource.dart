import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/refueling_code_model.dart';
import '../models/document_model.dart';

abstract class RefuelingRemoteDataSource {
  Future<RefuelingCodeModel> generateRefuelingCode({
    required String veiculoId,
    required String veiculoPlaca,
    required int kmAtual,
    required String combustivel,
    required bool abastecerArla,
    required String? postoId,
    required String? postoCnpj,
    String? observacoes,
  });

  Future<RefuelingCodeModel> validateRefuelingCode(String codigo);

  Future<RefuelingCodeModel> finalizeRefueling({
    required String refuelingId,
    required double quantidadeLitros,
    required double valorTotal,
    required int kmFinal,
    double? quantidadeArla,
    double? valorArla,
    String? observacoes,
    required List<String> comprovantesIds,
  });

  Future<RefuelingCodeModel> cancelRefueling({
    required String refuelingId,
    required String motivo,
    String? observacoes,
  });

  Future<RefuelingCodeModel> getRefuelingStatus(String refuelingId);

  Future<List<RefuelingCodeModel>> getRefuelingHistory({
    int page = 1,
    int limit = 20,
    String? veiculoId,
    String? dataInicio,
    String? dataFim,
    String? status,
    String? search,
  });
}

@LazySingleton(as: RefuelingRemoteDataSource)
class RefuelingRemoteDataSourceImpl implements RefuelingRemoteDataSource {
  final DioClient _client;

  RefuelingRemoteDataSourceImpl(this._client);

  @override
  Future<RefuelingCodeModel> generateRefuelingCode({
    required String veiculoId,
    required String veiculoPlaca,
    required int kmAtual,
    required String combustivel,
    required bool abastecerArla,
    required String? postoId,
    required String? postoCnpj,
    String? observacoes,
  }) async {
    final response = await _client.post(
      ApiConstants.refuelingCodes,
      data: {
        'veiculo_id': veiculoId,
        'veiculo_placa': veiculoPlaca,
        'km_atual': kmAtual,
        'combustivel': combustivel,
        'abastecer_arla': abastecerArla,
        if (postoId != null) 'posto_id': postoId,
        if (postoCnpj != null) 'posto_cnpj': postoCnpj,
        if (observacoes != null) 'observacoes': observacoes,
      },
    );
    return RefuelingCodeModel.fromJson(response.data['data']);
  }

  @override
  Future<RefuelingCodeModel> validateRefuelingCode(String codigo) async {
    final response = await _client.get(
      '${ApiConstants.refuelingCodes}/validate/$codigo',
    );
    return RefuelingCodeModel.fromJson(response.data['data']);
  }

  @override
  Future<RefuelingCodeModel> finalizeRefueling({
    required String refuelingId,
    required double quantidadeLitros,
    required double valorTotal,
    required int kmFinal,
    double? quantidadeArla,
    double? valorArla,
    String? observacoes,
    required List<String> comprovantesIds,
  }) async {
    final response = await _client.post(
      '${ApiConstants.refuelingCodes}/$refuelingId/finalize',
      data: {
        'quantidade_litros': quantidadeLitros,
        'valor_total': valorTotal,
        'km_final': kmFinal,
        if (quantidadeArla != null) 'quantidade_arla': quantidadeArla,
        if (valorArla != null) 'valor_arla': valorArla,
        if (observacoes != null) 'observacoes': observacoes,
        'comprovantes_ids': comprovantesIds,
      },
    );
    return RefuelingCodeModel.fromJson(response.data['data']);
  }

  @override
  Future<RefuelingCodeModel> cancelRefueling({
    required String refuelingId,
    required String motivo,
    String? observacoes,
  }) async {
    final response = await _client.post(
      '${ApiConstants.refuelingCodes}/$refuelingId/cancel',
      data: {
        'motivo': motivo,
        if (observacoes != null) 'observacoes': observacoes,
      },
    );
    return RefuelingCodeModel.fromJson(response.data['data']);
  }

  @override
  Future<RefuelingCodeModel> getRefuelingStatus(String refuelingId) async {
    final response = await _client.get(
      '${ApiConstants.refuelingCodes}/$refuelingId/status',
    );
    return RefuelingCodeModel.fromJson(response.data['data']);
  }

  @override
  Future<List<RefuelingCodeModel>> getRefuelingHistory({
    int page = 1,
    int limit = 20,
    String? veiculoId,
    String? dataInicio,
    String? dataFim,
    String? status,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (veiculoId != null) queryParams['veiculo_id'] = veiculoId;
    if (dataInicio != null) queryParams['data_inicio'] = dataInicio;
    if (dataFim != null) queryParams['data_fim'] = dataFim;
    if (status != null) queryParams['status'] = status;
    if (search != null) queryParams['search'] = search;

    final response = await _client.get(
      ApiConstants.refuelingHistory,
      queryParameters: queryParams,
    );

    final List<dynamic> refuelingJson = response.data['data']['refuelings'];
    return refuelingJson.map((json) => RefuelingCodeModel.fromJson(json)).toList();
  }
}