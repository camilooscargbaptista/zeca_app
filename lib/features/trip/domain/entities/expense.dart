import 'package:equatable/equatable.dart';

/// Entity representing an Expense
class Expense extends Equatable {
  final String id;
  final String tripId;
  final String categoryId;
  final String categoryCode;
  final String categoryName;
  final double amount;
  final String? description;
  final String? location;
  final String? receiptUrl;
  final DateTime expenseDate;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.tripId,
    required this.categoryId,
    required this.categoryCode,
    required this.categoryName,
    required this.amount,
    this.description,
    this.location,
    this.receiptUrl,
    required this.expenseDate,
    required this.createdAt,
  });

  bool get hasReceipt => receiptUrl != null && receiptUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        tripId,
        categoryId,
        categoryCode,
        categoryName,
        amount,
        description,
        location,
        receiptUrl,
        expenseDate,
        createdAt,
      ];
}
