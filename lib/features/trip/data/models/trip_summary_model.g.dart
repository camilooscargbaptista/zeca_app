// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseBreakdownModelImpl _$$ExpenseBreakdownModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseBreakdownModelImpl(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String? ?? 'Outros',
      categoryIcon: json['category_icon'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$ExpenseBreakdownModelImplToJson(
        _$ExpenseBreakdownModelImpl instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_icon': instance.categoryIcon,
      'amount': instance.amount,
      'count': instance.count,
      'percentage': instance.percentage,
    };

_$RevenueBreakdownModelImpl _$$RevenueBreakdownModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RevenueBreakdownModelImpl(
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      revenueCount: (json['revenue_count'] as num?)?.toInt() ?? 0,
      advanceReceived: (json['advance_received'] as num?)?.toDouble() ?? 0,
      pendingAmount: (json['pending_amount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$RevenueBreakdownModelImplToJson(
        _$RevenueBreakdownModelImpl instance) =>
    <String, dynamic>{
      'total_revenue': instance.totalRevenue,
      'revenue_count': instance.revenueCount,
      'advance_received': instance.advanceReceived,
      'pending_amount': instance.pendingAmount,
    };

_$TripSummaryModelImpl _$$TripSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TripSummaryModelImpl(
      referenceId: json['reference_id'] as String,
      referenceType: json['reference_type'] as String? ?? 'TRIP',
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0,
      variableExpenses: (json['variable_expenses'] as num?)?.toDouble() ?? 0,
      fixedExpenses: (json['fixed_expenses'] as num?)?.toDouble() ?? 0,
      totalExpenses: (json['total_expenses'] as num?)?.toDouble() ?? 0,
      costPerKm: (json['cost_per_km'] as num?)?.toDouble() ?? 0,
      expensesByCategory: (json['expenses_by_category'] as List<dynamic>?)
              ?.map((e) =>
                  ExpenseBreakdownModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      revenueBreakdown: json['revenue_breakdown'] == null
          ? null
          : RevenueBreakdownModel.fromJson(
              json['revenue_breakdown'] as Map<String, dynamic>),
      profit: (json['profit'] as num?)?.toDouble() ?? 0,
      profitMargin: (json['profit_margin'] as num?)?.toDouble() ?? 0,
      profitPerKm: (json['profit_per_km'] as num?)?.toDouble() ?? 0,
      avgCostPerKm: (json['avg_cost_per_km'] as num?)?.toDouble(),
      costVariationPercent:
          (json['cost_variation_percent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TripSummaryModelImplToJson(
        _$TripSummaryModelImpl instance) =>
    <String, dynamic>{
      'reference_id': instance.referenceId,
      'reference_type': instance.referenceType,
      'distance_km': instance.distanceKm,
      'variable_expenses': instance.variableExpenses,
      'fixed_expenses': instance.fixedExpenses,
      'total_expenses': instance.totalExpenses,
      'cost_per_km': instance.costPerKm,
      'expenses_by_category': instance.expensesByCategory,
      'total_revenue': instance.totalRevenue,
      'revenue_breakdown': instance.revenueBreakdown,
      'profit': instance.profit,
      'profit_margin': instance.profitMargin,
      'profit_per_km': instance.profitPerKm,
      'avg_cost_per_km': instance.avgCostPerKm,
      'cost_variation_percent': instance.costVariationPercent,
    };
