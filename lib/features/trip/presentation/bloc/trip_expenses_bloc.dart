import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_active_trip.dart';
import '../../domain/usecases/get_trip_summary.dart';
import '../../domain/usecases/get_expense_categories.dart';
import '../../domain/usecases/get_expenses_by_trip.dart';
import '../../domain/usecases/create_expense.dart' as expense_usecase;
import '../../domain/usecases/create_revenue.dart' as revenue_usecase;
import '../../domain/usecases/start_trip.dart';
import '../../domain/usecases/finish_trip.dart';
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
  final expense_usecase.CreateExpense createExpense;
  final revenue_usecase.CreateRevenue createRevenue;
  final StartTrip startTrip;
  final FinishTrip finishTrip;

  TripExpensesBloc({
    required this.getActiveTrip,
    required this.getTripSummary,
    required this.getExpenseCategories,
    required this.getExpensesByTrip,
    required this.createExpense,
    required this.createRevenue,
    required this.startTrip,
    required this.finishTrip,
  }) : super(TripExpensesState.initial()) {
    on<LoadActiveTrip>(_onLoadActiveTrip);
    on<LoadTripSummary>(_onLoadTripSummary);
    on<LoadCategories>(_onLoadCategories);
    on<LoadExpenses>(_onLoadExpenses);
    on<CreateExpenseEvent>(_onCreateExpense);
    on<CreateRevenueEvent>(_onCreateRevenue);
    on<StartTripEvent>(_onStartTrip);
    on<FinishTripEvent>(_onFinishTrip);
    on<RefreshTripExpenses>(_onRefresh);
    on<ClearSuccessFlag>(_onClearSuccessFlag);
  }

  Future<void> _onLoadActiveTrip(
    LoadActiveTrip event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getActiveTrip(const NoParams());
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

    final result = await getExpenseCategories(const NoParams());
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
    CreateExpenseEvent event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isCreatingExpense: true, errorMessage: null));

    final result = await createExpense(usecase.CreateExpenseParams(
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
      },
    );
  }

  Future<void> _onStartTrip(
    StartTripEvent event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await startTrip(StartTripParams(
      vehicleId: event.vehicleId,
      origin: event.origin,
      destination: event.destination,
    ));

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
        // Auto-load summary and expenses for new trip
        add(LoadTripSummary(trip.id));
        add(LoadExpenses(trip.id));
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

  Future<void> _onFinishTrip(
    FinishTripEvent event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await finishTrip(FinishTripParams(tripId: event.tripId));
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (trip) {
        // Limpa o estado da viagem ativa após encerrar
        emit(state.copyWith(
          isLoading: false,
          activeTrip: null,
          tripSummary: null,
          expenses: [],
          totalExpenses: 0,
          totalRevenues: 0,
          netProfit: 0,
        ));
      },
    );
  }

  void _onClearSuccessFlag(
    ClearSuccessFlag event,
    Emitter<TripExpensesState> emit,
  ) {
    emit(state.copyWith(
      expenseCreatedSuccess: false,
      revenueCreatedSuccess: false,
    ));
  }

  Future<void> _onCreateRevenue(
    CreateRevenueEvent event,
    Emitter<TripExpensesState> emit,
  ) async {
    emit(state.copyWith(isCreatingRevenue: true, errorMessage: null));

    final result = await createRevenue(revenue_usecase.CreateRevenueParams(
      tripId: event.tripId,
      vehicleId: event.vehicleId,
      amount: event.amount,
      origin: event.origin,
      destination: event.destination,
      clientName: event.clientName,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isCreatingRevenue: false,
        errorMessage: failure.message,
      )),
      (revenue) {
        // Add to total and mark success
        final newRevenue = state.totalRevenues + revenue.amount;

        emit(state.copyWith(
          isCreatingRevenue: false,
          revenueCreatedSuccess: true,
          totalRevenues: newRevenue,
          netProfit: newRevenue - state.totalExpenses,
        ));
      },
    );
  }
}
