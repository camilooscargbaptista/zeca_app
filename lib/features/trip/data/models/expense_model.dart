import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/expense.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
class ExpenseModel with _$ExpenseModel {
  const ExpenseModel._();

  const factory ExpenseModel({
    required String id,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'category_code') required String categoryCode,
    @JsonKey(name: 'category_name') required String categoryName,
    required double amount,
    String? description,
    String? location,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'expense_date') required DateTime expenseDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  /// Convert to domain entity
  Expense toEntity() => Expense(
        id: id,
        tripId: tripId,
        categoryId: categoryId,
        categoryCode: categoryCode,
        categoryName: categoryName,
        amount: amount,
        description: description,
        location: location,
        receiptUrl: receiptUrl,
        expenseDate: expenseDate,
        createdAt: createdAt,
      );
}
