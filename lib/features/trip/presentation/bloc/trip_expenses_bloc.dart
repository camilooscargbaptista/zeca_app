import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_active_trip.dart';
import '../../domain/usecases/get_trip_summary.dart';
import '../../domain/usecases/get_expense_categories.dart';
import '../../domain/usecases/get_expenses_by_trip.dart';
import '../../domain/usecases/create_expense.dart';
import 'trip_expenses_event.dart';
import 'trip_expenses_state.dart';

/// BLoC for Trip Expenses feature
/// Manages state for expenses, revenues, and trip summary
@injectable
class TripExpensesBloc extends Bloc<TripExpensesEvent, TripExpensesState> {
  final GetActiveTrip getActiveTrip;
  final GetTripSummary getTripSummary;
  final GetExpenseCategories getExpenseCategories;
  final GetExpensesByTrip getExpensesByTrip;
  final CreateExpense createExpense;

  TripExpensesBloc({
    required this.getActiveTrip,
    required this.getTripSummary,
    required this.getExpenseCategories,
    required this.getExpensesByTrip,
    required this.createExpense,
  }) : super(TripExpensesState.initial()) {
    on<LoadActiveTrip>(_onLoadActiveTrip);
    on<LoadTripSummary>(_onLoadTripSummary);
    on<LoadCategories>(_onLoadCategories);
    on<LoadExpenses>(_onLoadExpenses);
    on<CreateExpense>(_onCreateExpense);
    on<RefreshTripExpenses>(_onRefresh);
  }

  Future<void> _onLoadActiveTrip(
    LoadActiveTrip event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getActiveTrip();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (trip) {
        emit(state.copyWith(
          isLoading: false,
          activeTrip: trip,
        ));
        // Auto-load summary if trip exists
        if (trip != null) {
          add(LoadTripSummary(trip.id));
          add(LoadExpenses(trip.id));
        }
      },
    );
  }

  Future<void> _onLoadTripSummary(
    LoadTripSummary event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getTripSummary(GetTripSummaryParams(tripId: event.tripId));
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (summary) => emit(state.copyWith(
        isLoading: false,
        tripSummary: summary,
        totalExpenses: summary.totalExpenses,
        totalRevenues: summary.totalRevenues,
        netProfit: summary.netProfit,
      )),
    );
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isLoadingCategories: true));

    final result = await getExpenseCategories();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingCategories: false,
        errorMessage: failure.message,
      )),
      (categories) => emit(state.copyWith(
        isLoadingCategories: false,
        categories: categories,
      )),
    );
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await getExpensesByTrip(
      GetExpensesByTripParams(tripId: event.tripId),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (expenses) => emit(state.copyWith(
        isLoading: false,
        expenses: expenses,
      )),
    );
  }

  Future<void> _onCreateExpense(
    CreateExpense event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isCreatingExpense: true, errorMessage: null));

    final result = await createExpense(CreateExpenseParams(
      tripId: event.tripId,
      categoryId: event.categoryId,
      amount: event.amount,
      description: event.description,
      location: event.location,
      receiptPath: event.receiptPath,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isCreatingExpense: false,
        errorMessage: failure.message,
      )),
      (expense) {
        // Add to list and recalculate totals
        final updatedExpenses = [...state.expenses, expense];
        final newTotal = state.totalExpenses + expense.amount;

        emit(state.copyWith(
          isCreatingExpense: false,
          expenseCreatedSuccess: true,
          expenses: updatedExpenses,
          totalExpenses: newTotal,
          netProfit: state.totalRevenues - newTotal,
        ));

        // Reset success flag after delay
        Future.delayed(const Duration(seconds: 2), () {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(state.copyWith(expenseCreatedSuccess: false));
        });
      },
    );
  }

  Future<void> _onRefresh(
    RefreshTripExpenses event,
    Emitter<TripExpensesState> emit,
  ) async {
    if (state.activeTrip != null) {
      add(LoadTripSummary(state.activeTrip!.id));
      add(LoadExpenses(state.activeTrip!.id));
    } else {
      add(const LoadActiveTrip());
    }
    add(const LoadCategories());
  }
}
