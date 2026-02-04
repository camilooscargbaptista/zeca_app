import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';

/// Remote datasource for Revenue API calls
@lazySingleton
class RevenueRemoteDatasource {
  final DioClient _dioClient;

  RevenueRemoteDatasource(this._dioClient);

  /// Create a new revenue
  Future<Map<String, dynamic>> createRevenue({
    required String vehicleId,
    String? tripId,
    required double totalAmount,
    String? originCity,
    String? destinationCity,
    String? cargoDescription,
    String? clientName,
  }) async {
    final body = <String, dynamic>{
      'vehicle_id': vehicleId,
      'total_amount': totalAmount,
    };

    if (tripId != null) body['trip_id'] = tripId;
    if (originCity != null) body['origin_city'] = originCity;
    if (destinationCity != null) body['destination_city'] = destinationCity;
    if (cargoDescription != null) body['cargo_description'] = cargoDescription;
    if (clientName != null) body['client_name'] = clientName;

    final response = await _dioClient.post('/revenues', data: body);
    return response.data as Map<String, dynamic>;
  }

  /// Get revenues by trip
  Future<List<Map<String, dynamic>>> getRevenuesByTrip(String tripId) async {
    final response = await _dioClient.get('/revenues/trip/$tripId');
    final data = response.data as List<dynamic>;
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  /// Get all revenues
  Future<List<Map<String, dynamic>>> getAllRevenues() async {
    final response = await _dioClient.get('/revenues');
    final data = response.data as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    return items.map((e) => e as Map<String, dynamic>).toList();
  }
}
