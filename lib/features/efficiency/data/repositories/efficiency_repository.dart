import '../../../../core/services/api_service.dart';
import '../models/efficiency_summary_model.dart';
import '../models/refueling_history_model.dart';
import '../models/vehicle_efficiency_model.dart';

/// Repository for efficiency data from backend APIs
class EfficiencyRepository {
  final ApiService _apiService;

  EfficiencyRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get driver efficiency summary
  /// GET /app/efficiency/summary
  Future<EfficiencySummaryModel> getSummary() async {
    try {
      final result = await _apiService.get('/app/efficiency/summary');
      if (result['success'] == true && result['data'] != null) {
        return EfficiencySummaryModel.fromJson(result['data']);
      }
      return EfficiencySummaryModel.empty();
    } catch (e) {
      // Return empty on error to show empty state
      return EfficiencySummaryModel.empty();
    }
  }

  /// Get current vehicle efficiency
  /// GET /app/efficiency/vehicle
  Future<VehicleEfficiencyModel?> getCurrentVehicle() async {
    try {
      final result = await _apiService.get('/app/efficiency/vehicle');
      if (result['success'] == true && result['data'] != null) {
        return VehicleEfficiencyModel.fromJson(result['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get refueling history with efficiency data
  /// GET /app/efficiency/history
  Future<PaginatedRefuelingHistory> getHistory({
    int page = 1,
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final result = await _apiService.get(
        '/app/efficiency/history',
        queryParameters: queryParams,
      );

      if (result['success'] == true && result['data'] != null) {
        return PaginatedRefuelingHistory.fromJson(result['data']);
      }
      return PaginatedRefuelingHistory(
        items: [],
        total: 0,
        page: 1,
        limit: limit,
        totalPages: 0,
      );
    } catch (e) {
      return PaginatedRefuelingHistory(
        items: [],
        total: 0,
        page: 1,
        limit: limit,
        totalPages: 0,
      );
    }
  }
}
