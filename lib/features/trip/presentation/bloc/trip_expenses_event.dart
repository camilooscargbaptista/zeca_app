import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_expenses_event.freezed.dart';

/// Trip Expenses Events
@freezed
class TripExpensesEvent with _$TripExpensesEvent {
  /// Load active trip data
  const factory TripExpensesEvent.loadActiveTrip() = LoadActiveTrip;

  /// Load trip summary
  const factory TripExpensesEvent.loadTripSummary(String tripId) = LoadTripSummary;

  /// Load expense categories
  const factory TripExpensesEvent.loadCategories() = LoadCategories;

  /// Load expenses for trip
  const factory TripExpensesEvent.loadExpenses(String tripId) = LoadExpenses;

  /// Create new expense
  const factory TripExpensesEvent.createExpense({
    required String tripId,
    required String categoryId,
    required double amount,
    String? description,
    String? location,
    String? receiptPath,
  }) = CreateExpenseEvent;

  /// Create new revenue/freight
  const factory TripExpensesEvent.createRevenue({
    required String tripId,
    required String vehicleId,
    required double amount,
    String? origin,
    String? destination,
    String? clientName,
  }) = CreateRevenueEvent;

  /// Start a new trip
  const factory TripExpensesEvent.startTrip({
    required String origin,
    String? destination,
    required String vehicleId,
  }) = StartTripEvent;

  /// Finish current trip
  const factory TripExpensesEvent.finishTrip(String tripId) = FinishTripEvent;

  /// Refresh all data
  const factory TripExpensesEvent.refresh() = RefreshTripExpenses;

  /// Clear success flag after navigation
  const factory TripExpensesEvent.clearSuccessFlag() = ClearSuccessFlag;
}

