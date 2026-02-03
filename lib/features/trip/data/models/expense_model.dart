import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/expense.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

/// Converter para lidar com amount que pode vir como String ou num do backend
class AmountConverter implements JsonConverter<double, dynamic> {
  const AmountConverter();

  @override
  double fromJson(dynamic json) {
    if (json == null) return 0.0;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json) ?? 0.0;
    return 0.0;
  }

  @override
  dynamic toJson(double object) => object;
}

@freezed
class ExpenseModel with _$ExpenseModel {
  const ExpenseModel._();

  const factory ExpenseModel({
    required String id,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'category_code') @Default('OTHER') String categoryCode,
    @JsonKey(name: 'category_name') @Default('Outros') String categoryName,
    @AmountConverter() required double amount,
    String? description,
    String? location,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'expense_date') DateTime? expenseDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
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
        expenseDate: expenseDate ?? DateTime.now(),
        createdAt: createdAt ?? DateTime.now(),
      );
}
