import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trip_summary.dart';

part 'trip_summary_model.freezed.dart';
part 'trip_summary_model.g.dart';

/// Sub-model para breakdown por categoria
@freezed
class ExpenseBreakdownModel with _$ExpenseBreakdownModel {
  const factory ExpenseBreakdownModel({
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'category_name') @Default('Outros') String categoryName,
    @JsonKey(name: 'category_icon') String? categoryIcon,
    @Default(0) double amount,
    @Default(0) int count,
    @Default(0) double percentage,
  }) = _ExpenseBreakdownModel;

  factory ExpenseBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseBreakdownModelFromJson(json);
}

/// Sub-model para breakdown de receitas
@freezed
class RevenueBreakdownModel with _$RevenueBreakdownModel {
  const factory RevenueBreakdownModel({
    @JsonKey(name: 'total_revenue') @Default(0) double totalRevenue,
    @JsonKey(name: 'revenue_count') @Default(0) int revenueCount,
    @JsonKey(name: 'advance_received') @Default(0) double advanceReceived,
    @JsonKey(name: 'pending_amount') @Default(0) double pendingAmount,
  }) = _RevenueBreakdownModel;

  factory RevenueBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueBreakdownModelFromJson(json);
}

/// TripSummaryModel - corresponde EXATAMENTE ao TripSummaryDto do backend
@freezed
class TripSummaryModel with _$TripSummaryModel {
  const TripSummaryModel._();

  const factory TripSummaryModel({
    // Identificação
    @JsonKey(name: 'reference_id') required String referenceId,
    @JsonKey(name: 'reference_type') @Default('TRIP') String referenceType,
    
    // Distância
    @JsonKey(name: 'distance_km') @Default(0) double distanceKm,
    
    // Gastos
    @JsonKey(name: 'variable_expenses') @Default(0) double variableExpenses,
    @JsonKey(name: 'fixed_expenses') @Default(0) double fixedExpenses,
    @JsonKey(name: 'total_expenses') @Default(0) double totalExpenses,
    @JsonKey(name: 'cost_per_km') @Default(0) double costPerKm,
    @JsonKey(name: 'expenses_by_category') @Default([]) List<ExpenseBreakdownModel> expensesByCategory,
    
    // Receitas
    @JsonKey(name: 'total_revenue') @Default(0) double totalRevenue,
    @JsonKey(name: 'revenue_breakdown') RevenueBreakdownModel? revenueBreakdown,
    
    // Resultado
    @Default(0) double profit,
    @JsonKey(name: 'profit_margin') @Default(0) double profitMargin,
    @JsonKey(name: 'profit_per_km') @Default(0) double profitPerKm,
    
    // Opcionais
    @JsonKey(name: 'avg_cost_per_km') double? avgCostPerKm,
    @JsonKey(name: 'cost_variation_percent') double? costVariationPercent,
  }) = _TripSummaryModel;

  factory TripSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TripSummaryModelFromJson(json);

  /// Convert to domain entity
  TripSummary toEntity() => TripSummary(
        tripId: referenceId,
        origin: null, // Não vem da API
        destination: null,
        totalDistanceKm: distanceKm,
        totalExpenses: totalExpenses,
        totalRevenues: totalRevenue,
        netProfit: profit,
        profitMargin: profitMargin,
        costPerKm: costPerKm,
        expenseCount: expensesByCategory.fold(0, (sum, cat) => sum + cat.count),
        revenueCount: revenueBreakdown?.revenueCount ?? 0,
        expensesByCategory: {
          for (var cat in expensesByCategory) cat.categoryName: cat.amount
        },
        startedAt: null,
        endedAt: null,
      );
}
