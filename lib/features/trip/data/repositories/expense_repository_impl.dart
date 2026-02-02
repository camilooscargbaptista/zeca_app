import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

@LazySingleton(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;

  ExpenseRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ExpenseCategoryEntity>>> getCategories() async {
    try {
      final result = await _remoteDataSource.getCategories();
      return Right(result.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByTrip(
    String tripId,
  ) async {
    try {
      final result = await _remoteDataSource.getExpensesByTrip(tripId);
      return Right(result.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> createExpense({
    required String tripId,
    required String categoryId,
    required double amount,
    String? description,
    String? location,
    String? receiptPath,
  }) async {
    try {
      final result = await _remoteDataSource.createExpense(
        tripId: tripId,
        categoryId: categoryId,
        amount: amount,
        description: description,
        location: location,
        receiptPath: receiptPath,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getExpensesSummaryByCategory(
    String tripId,
  ) async {
    try {
      final result =
          await _remoteDataSource.getExpensesSummaryByCategory(tripId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String expenseId) async {
    try {
      await _remoteDataSource.deleteExpense(expenseId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
