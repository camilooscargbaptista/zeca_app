import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../models/expense_model.dart';
import '../models/expense_category_model.dart';

/// Remote data source for Expense operations
abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseCategoryModel>> getCategories();
  Future<List<ExpenseModel>> getExpensesByTrip(String tripId);
  Future<ExpenseModel> createExpense({
    required String tripId,
    required String categoryId,
    required double amount,
    String? description,
    String? location,
    String? receiptPath,
  });
  Future<Map<String, double>> getExpensesSummaryByCategory(String tripId);
  Future<void> deleteExpense(String expenseId);
}

@LazySingleton(as: ExpenseRemoteDataSource)
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final DioClient _dioClient;

  ExpenseRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ExpenseCategoryModel>> getCategories() async {
    final response = await _dioClient.get('/expenses/categories');
    final List<dynamic> data = response.data;
    return data.map((json) => ExpenseCategoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<ExpenseModel>> getExpensesByTrip(String tripId) async {
    final response = await _dioClient.get('/expenses/trip/$tripId');
    // API pode retornar lista direta [] ou {data: []}
    final List<dynamic> data = response.data is List
        ? response.data
        : (response.data['data'] ?? []);
    return data.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  @override
  Future<ExpenseModel> createExpense({
    required String tripId,
    required String categoryId,
    required double amount,
    String? description,
    String? location,
    String? receiptPath,
  }) async {
    final response = await _dioClient.post('/expenses', data: {
      'trip_id': tripId,
      'category_id': categoryId,
      'amount': amount,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (receiptPath != null) 'receipt_path': receiptPath,
    });
    return ExpenseModel.fromJson(response.data);
  }

  @override
  Future<Map<String, double>> getExpensesSummaryByCategory(
    String tripId,
  ) async {
    final response = await _dioClient.get('/expenses/trip/$tripId/summary');
    final Map<String, dynamic> data = response.data['by_category'] ?? {};
    return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await _dioClient.delete('/expenses/$expenseId');
  }
}
