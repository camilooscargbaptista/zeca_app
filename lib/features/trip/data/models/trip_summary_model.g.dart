// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripSummaryModelImpl _$$TripSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TripSummaryModelImpl(
      tripId: json['trip_id'] as String,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      totalDistanceKm: (json['total_distance_km'] as num?)?.toDouble() ?? 0,
      totalExpenses: (json['total_expenses'] as num?)?.toDouble() ?? 0,
      totalRevenues: (json['total_revenues'] as num?)?.toDouble() ?? 0,
      netProfit: (json['net_profit'] as num?)?.toDouble() ?? 0,
      profitMargin: (json['profit_margin'] as num?)?.toDouble() ?? 0,
      costPerKm: (json['cost_per_km'] as num?)?.toDouble() ?? 0,
      expenseCount: (json['expense_count'] as num?)?.toInt() ?? 0,
      revenueCount: (json['revenue_count'] as num?)?.toInt() ?? 0,
      expensesByCategory:
          (json['expenses_by_category'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
    );

Map<String, dynamic> _$$TripSummaryModelImplToJson(
        _$TripSummaryModelImpl instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'origin': instance.origin,
      'destination': instance.destination,
      'total_distance_km': instance.totalDistanceKm,
      'total_expenses': instance.totalExpenses,
      'total_revenues': instance.totalRevenues,
      'net_profit': instance.netProfit,
      'profit_margin': instance.profitMargin,
      'cost_per_km': instance.costPerKm,
      'expense_count': instance.expenseCount,
      'revenue_count': instance.revenueCount,
      'expenses_by_category': instance.expensesByCategory,
      'started_at': instance.startedAt?.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
    };
