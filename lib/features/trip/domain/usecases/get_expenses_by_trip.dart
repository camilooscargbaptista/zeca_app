import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Use case to get expenses for a trip
class GetExpensesByTrip implements UseCase<List<Expense>, GetExpensesByTripParams> {
  final ExpenseRepository repository;

  GetExpensesByTrip(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(GetExpensesByTripParams params) async {
    return await repository.getExpensesByTrip(params.tripId);
  }
}

class GetExpensesByTripParams extends Equatable {
  final String tripId;

  const GetExpensesByTripParams({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}
