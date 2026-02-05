import 'package:equatable/equatable.dart';

/// Entity representing a Trip Summary with financial data
class TripSummary extends Equatable {
  final String tripId;
  final String? origin;
  final String? destination;
  final double totalDistanceKm;
  final double totalExpenses;
  final double totalRevenues;
  final double netProfit;
  final double profitMargin;
  final double costPerKm;
  final int expenseCount;
  final int revenueCount;
  final Map<String, double> expensesByCategory;
  final DateTime? startedAt;
  final DateTime? endedAt;

  const TripSummary({
    required this.tripId,
    this.origin,
    this.destination,
    required this.totalDistanceKm,
    required this.totalExpenses,
    required this.totalRevenues,
    required this.netProfit,
    required this.profitMargin,
    required this.costPerKm,
    required this.expenseCount,
    required this.revenueCount,
    required this.expensesByCategory,
    this.startedAt,
    this.endedAt,
  });

  /// Factory for empty summary
  factory TripSummary.empty(String tripId) => TripSummary(
        tripId: tripId,
        totalDistanceKm: 0,
        totalExpenses: 0,
        totalRevenues: 0,
        netProfit: 0,
        profitMargin: 0,
        costPerKm: 0,
        expenseCount: 0,
        revenueCount: 0,
        expensesByCategory: const {},
      );

  bool get hasProfitableTrip => netProfit > 0;

  @override
  List<Object?> get props => [
        tripId,
        origin,
        destination,
        totalDistanceKm,
        totalExpenses,
        totalRevenues,
        netProfit,
        profitMargin,
        costPerKm,
        expenseCount,
        revenueCount,
        expensesByCategory,
        startedAt,
        endedAt,
      ];
}
