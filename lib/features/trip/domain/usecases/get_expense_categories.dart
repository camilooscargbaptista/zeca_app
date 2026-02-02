import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense_category.dart';
import '../repositories/expense_repository.dart';

/// Use case to get expense categories
class GetExpenseCategories
    implements UseCase<List<ExpenseCategoryEntity>, NoParams> {
  final ExpenseRepository repository;

  GetExpenseCategories(this.repository);

  @override
  Future<Either<Failure, List<ExpenseCategoryEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getCategories();
  }
}
