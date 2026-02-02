import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../models/trip_model.dart';
import '../models/trip_summary_model.dart';

/// Remote data source for Trip operations
abstract class TripRemoteDataSource {
  Future<TripModel?> getActiveTrip();
  Future<TripModel> getTripById(String tripId);
  Future<TripModel> startTrip({
    required String vehicleId,
    String? origin,
    String? destination,
  });
  Future<TripModel> finishTrip(String tripId);
  Future<TripSummaryModel> getTripSummary(String tripId);
}

@LazySingleton(as: TripRemoteDataSource)
class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final DioClient _dioClient;

  TripRemoteDataSourceImpl(this._dioClient);

  @override
  Future<TripModel?> getActiveTrip() async {
    try {
      final response = await _dioClient.get('/trips/active');
      if (response.data == null || response.data.isEmpty) {
        return null;
      }
      return TripModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<TripModel> getTripById(String tripId) async {
    final response = await _dioClient.get('/trips/$tripId');
    return TripModel.fromJson(response.data);
  }

  @override
  Future<TripModel> startTrip({
    required String vehicleId,
    String? origin,
    String? destination,
  }) async {
    final response = await _dioClient.post('/trips', data: {
      'vehicle_id': vehicleId,
      if (origin != null) 'origin': origin,
      if (destination != null) 'destination': destination,
    });
    return TripModel.fromJson(response.data);
  }

  @override
  Future<TripModel> finishTrip(String tripId) async {
    final response = await _dioClient.put('/trips/$tripId/finish');
    return TripModel.fromJson(response.data);
  }

  @override
  Future<TripSummaryModel> getTripSummary(String tripId) async {
    final response = await _dioClient.get('/trip-summary/trip/$tripId');
    return TripSummaryModel.fromJson(response.data);
  }
}
