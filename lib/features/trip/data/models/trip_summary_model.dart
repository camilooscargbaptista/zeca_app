import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trip_summary.dart';

part 'trip_summary_model.freezed.dart';
part 'trip_summary_model.g.dart';

@freezed
class TripSummaryModel with _$TripSummaryModel {
  const TripSummaryModel._();

  const factory TripSummaryModel({
    @JsonKey(name: 'trip_id') required String tripId,
    String? origin,
    String? destination,
    @JsonKey(name: 'total_distance_km') @Default(0) double totalDistanceKm,
    @JsonKey(name: 'total_expenses') @Default(0) double totalExpenses,
    @JsonKey(name: 'total_revenues') @Default(0) double totalRevenues,
    @JsonKey(name: 'net_profit') @Default(0) double netProfit,
    @JsonKey(name: 'profit_margin') @Default(0) double profitMargin,
    @JsonKey(name: 'cost_per_km') @Default(0) double costPerKm,
    @JsonKey(name: 'expense_count') @Default(0) int expenseCount,
    @JsonKey(name: 'revenue_count') @Default(0) int revenueCount,
    @JsonKey(name: 'expenses_by_category')
    @Default({})
    Map<String, double> expensesByCategory,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
  }) = _TripSummaryModel;

  factory TripSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TripSummaryModelFromJson(json);

  /// Convert to domain entity
  TripSummary toEntity() => TripSummary(
        tripId: tripId,
        origin: origin,
        destination: destination,
        totalDistanceKm: totalDistanceKm,
        totalExpenses: totalExpenses,
        totalRevenues: totalRevenues,
        netProfit: netProfit,
        profitMargin: profitMargin,
        costPerKm: costPerKm,
        expenseCount: expenseCount,
        revenueCount: revenueCount,
        expensesByCategory: expensesByCategory,
        startedAt: startedAt,
        endedAt: endedAt,
      );
}
