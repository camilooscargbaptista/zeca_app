import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/expense_category.dart';
import '../../../domain/entities/trip_summary.dart';

part 'trip_expenses_state.freezed.dart';

/// Trip Expenses State
@freezed
class TripExpensesState with _$TripExpensesState {
  const factory TripExpensesState({
    // Loading flags
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingCategories,
    @Default(false) bool isCreatingExpense,

    // Data
    Trip? activeTrip,
    TripSummary? tripSummary,
    @Default([]) List<ExpenseCategoryEntity> categories,
    @Default([]) List<Expense> expenses,

    // UI State
    String? errorMessage,
    @Default(false) bool expenseCreatedSuccess,

    // Computed values
    @Default(0.0) double totalExpenses,
    @Default(0.0) double totalRevenues,
    @Default(0.0) double netProfit,
  }) = _TripExpensesState;

  /// Initial state
  factory TripExpensesState.initial() => const TripExpensesState();
}
