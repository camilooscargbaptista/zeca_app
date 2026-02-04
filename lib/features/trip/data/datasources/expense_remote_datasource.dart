import 'dart:convert';
import 'dart:io';

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
    String? receiptUrl,
  });
  Future<Map<String, double>> getExpensesSummaryByCategory(String tripId);
  Future<void> deleteExpense(String expenseId);
  Future<String?> uploadReceiptBase64({
    required String expenseId,
    required String imagePath,
  });
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
    String? receiptUrl,
  }) async {
    final response = await _dioClient.post('/expenses', data: {
      'trip_id': tripId,
      'category_id': categoryId,
      'amount': amount,
      'expense_date': DateTime.now().toUtc().toIso8601String().split('T').first,
      if (description != null) 'description': description,
      if (location != null) 'location_name': location,
      if (receiptUrl != null) 'receipt_url': receiptUrl,
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

  @override
  Future<String?> uploadReceiptBase64({
    required String expenseId,
    required String imagePath,
  }) async {
    try {
      // Ler arquivo e converter para base64
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      // Detectar extensão e MIME type
      final extension = imagePath.split('.').last.toLowerCase();
      final mimeType = _getMimeType(extension);
      final fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.$extension';

      // Enviar para API /uploads/base64
      final response = await _dioClient.post('/uploads/base64', data: {
        'entity_type': 'expense',
        'entity_id': expenseId,
        'file_type': 'expense_receipt',
        'base64': 'data:$mimeType;base64,$base64String',
        'file_name': fileName,
        'mime_type': mimeType,
      });

      // Retornar URL do arquivo
      return response.data['s3_key'] as String?;
    } catch (e) {
      // Em caso de erro, retornar null (upload falhou, mas gasto foi salvo)
      return null;
    }
  }

  String _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
