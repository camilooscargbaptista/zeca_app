import 'package:equatable/equatable.dart';

/// Base event class for efficiency bloc
abstract class EfficiencyEvent extends Equatable {
  const EfficiencyEvent();

  @override
  List<Object?> get props => [];
}

/// Load efficiency summary for home card
class LoadEfficiencySummary extends EfficiencyEvent {
  const LoadEfficiencySummary();
}

/// Load current vehicle efficiency
class LoadVehicleEfficiency extends EfficiencyEvent {
  const LoadVehicleEfficiency();
}

/// Load refueling history
class LoadRefuelingHistory extends EfficiencyEvent {
  final int page;
  final int limit;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool refresh;

  const LoadRefuelingHistory({
    this.page = 1,
    this.limit = 10,
    this.startDate,
    this.endDate,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [page, limit, startDate, endDate, refresh];
}

/// Load more history items (pagination)
class LoadMoreHistory extends EfficiencyEvent {
  const LoadMoreHistory();
}

/// Toggle efficiency unit between km/L and L/100km
class ToggleEfficiencyUnit extends EfficiencyEvent {
  const ToggleEfficiencyUnit();
}

/// Set efficiency unit preference
class SetEfficiencyUnit extends EfficiencyEvent {
  final bool useL100km;

  const SetEfficiencyUnit(this.useL100km);

  @override
  List<Object?> get props => [useL100km];
}

/// Filter history by period
class FilterHistoryByPeriod extends EfficiencyEvent {
  final String period; // week, month, quarter, year

  const FilterHistoryByPeriod(this.period);

  @override
  List<Object?> get props => [period];
}
