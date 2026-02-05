import 'package:equatable/equatable.dart';
import '../../data/models/efficiency_summary_model.dart';
import '../../data/models/vehicle_efficiency_model.dart';
import '../../data/models/refueling_history_model.dart';

/// Base state class for efficiency bloc
abstract class EfficiencyState extends Equatable {
  const EfficiencyState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class EfficiencyInitial extends EfficiencyState {
  const EfficiencyInitial();
}

/// Loading state
class EfficiencyLoading extends EfficiencyState {
  const EfficiencyLoading();
}

/// State when summary is loaded (for home card)
class EfficiencySummaryLoaded extends EfficiencyState {
  final EfficiencySummaryModel summary;
  final bool useL100km;

  const EfficiencySummaryLoaded({
    required this.summary,
    this.useL100km = false,
  });

  @override
  List<Object?> get props => [summary, useL100km];
}

/// State when full efficiency data is loaded
class EfficiencyLoaded extends EfficiencyState {
  final EfficiencySummaryModel summary;
  final VehicleEfficiencyModel? vehicle;
  final List<RefuelingHistoryModel> recentHistory;
  final bool useL100km;
  final String selectedPeriod;

  const EfficiencyLoaded({
    required this.summary,
    this.vehicle,
    this.recentHistory = const [],
    this.useL100km = false,
    this.selectedPeriod = 'month',
  });

  EfficiencyLoaded copyWith({
    EfficiencySummaryModel? summary,
    VehicleEfficiencyModel? vehicle,
    List<RefuelingHistoryModel>? recentHistory,
    bool? useL100km,
    String? selectedPeriod,
  }) {
    return EfficiencyLoaded(
      summary: summary ?? this.summary,
      vehicle: vehicle ?? this.vehicle,
      recentHistory: recentHistory ?? this.recentHistory,
      useL100km: useL100km ?? this.useL100km,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }

  @override
  List<Object?> get props => [summary, vehicle, recentHistory, useL100km, selectedPeriod];
}

/// State for history screen with pagination
class EfficiencyHistoryLoaded extends EfficiencyState {
  final List<RefuelingHistoryModel> items;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final bool useL100km;
  final String selectedPeriod;

  const EfficiencyHistoryLoaded({
    required this.items,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isLoadingMore = false,
    this.useL100km = false,
    this.selectedPeriod = 'month',
  });

  bool get hasMore => currentPage < totalPages;

  EfficiencyHistoryLoaded copyWith({
    List<RefuelingHistoryModel>? items,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    bool? useL100km,
    String? selectedPeriod,
  }) {
    return EfficiencyHistoryLoaded(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      useL100km: useL100km ?? this.useL100km,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }

  @override
  List<Object?> get props => [items, currentPage, totalPages, isLoadingMore, useL100km, selectedPeriod];
}

/// Error state
class EfficiencyError extends EfficiencyState {
  final String message;

  const EfficiencyError(this.message);

  @override
  List<Object?> get props => [message];
}
