import 'package:dartz/dartz.dart';
import '../entities/expense.dart';
import '../entities/expense_category.dart';
import '../../../../core/error/failures.dart';

/// Abstract repository for Expense operations
abstract class ExpenseRepository {
  /// Get all expense categories
  Future<Either<Failure, List<ExpenseCategoryEntity>>> getCategories();

  /// Get expenses for a trip
  Future<Either<Failure, List<Expense>>> getExpensesByTrip(String tripId);

  /// Create a new expense
  Future<Either<Failure, Expense>> createExpense({
    required String tripId,
    required String categoryId,
    required double amount,
    String? description,
    String? location,
    String? receiptPath,
  });

  /// Get expense summary by category for a trip
  Future<Either<Failure, Map<String, double>>> getExpensesSummaryByCategory(
    String tripId,
  );

  /// Delete an expense
  Future<Either<Failure, void>> deleteExpense(String expenseId);
}
