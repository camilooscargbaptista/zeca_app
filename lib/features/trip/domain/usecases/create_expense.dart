import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Use case to create a new expense
class CreateExpense implements UseCase<Expense, CreateExpenseParams> {
  final ExpenseRepository repository;

  CreateExpense(this.repository);

  @override
  Future<Either<Failure, Expense>> call(CreateExpenseParams params) async {
    return await repository.createExpense(
      tripId: params.tripId,
      categoryId: params.categoryId,
      amount: params.amount,
      description: params.description,
      location: params.location,
      receiptPath: params.receiptPath,
    );
  }
}

class CreateExpenseParams extends Equatable {
  final String tripId;
  final String categoryId;
  final double amount;
  final String? description;
  final String? location;
  final String? receiptPath;

  const CreateExpenseParams({
    required this.tripId,
    required this.categoryId,
    required this.amount,
    this.description,
    this.location,
    this.receiptPath,
  });

  @override
  List<Object?> get props => [
        tripId,
        categoryId,
        amount,
        description,
        location,
        receiptPath,
      ];
}
