import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/efficiency_repository.dart';
import 'efficiency_event.dart';
import 'efficiency_state.dart';

/// BLoC for managing efficiency data
class EfficiencyBloc extends Bloc<EfficiencyEvent, EfficiencyState> {
  final EfficiencyRepository _repository;
  bool _useL100km = false;
  String _selectedPeriod = 'month';

  EfficiencyBloc({EfficiencyRepository? repository})
      : _repository = repository ?? EfficiencyRepository(),
        super(const EfficiencyInitial()) {
    on<LoadEfficiencySummary>(_onLoadSummary);
    on<LoadVehicleEfficiency>(_onLoadVehicle);
    on<LoadRefuelingHistory>(_onLoadHistory);
    on<LoadMoreHistory>(_onLoadMoreHistory);
    on<ToggleEfficiencyUnit>(_onToggleUnit);
    on<SetEfficiencyUnit>(_onSetUnit);
    on<FilterHistoryByPeriod>(_onFilterByPeriod);
  }

  /// Load summary for home card display
  Future<void> _onLoadSummary(
    LoadEfficiencySummary event,
    Emitter<EfficiencyState> emit,
  ) async {
    emit(const EfficiencyLoading());
    try {
      final summary = await _repository.getSummary();
      emit(EfficiencySummaryLoaded(
        summary: summary,
        useL100km: _useL100km,
      ));
    } catch (e) {
      emit(EfficiencyError(e.toString()));
    }
  }

  /// Load full efficiency data for efficiency screen
  Future<void> _onLoadVehicle(
    LoadVehicleEfficiency event,
    Emitter<EfficiencyState> emit,
  ) async {
    emit(const EfficiencyLoading());
    try {
      // Load all data in parallel
      final results = await Future.wait([
        _repository.getSummary(),
        _repository.getCurrentVehicle(),
        _repository.getHistory(limit: 5),
      ]);

      emit(EfficiencyLoaded(
        summary: results[0] as dynamic,
        vehicle: results[1] as dynamic,
        recentHistory: (results[2] as dynamic).items,
        useL100km: _useL100km,
        selectedPeriod: _selectedPeriod,
      ));
    } catch (e) {
      emit(EfficiencyError(e.toString()));
    }
  }

  /// Load history with filters
  Future<void> _onLoadHistory(
    LoadRefuelingHistory event,
    Emitter<EfficiencyState> emit,
  ) async {
    if (!event.refresh && state is EfficiencyHistoryLoaded) {
      // Already loading
      return;
    }

    emit(const EfficiencyLoading());
    try {
      final result = await _repository.getHistory(
        page: event.page,
        limit: event.limit,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(EfficiencyHistoryLoaded(
        items: result.items,
        currentPage: result.page,
        totalPages: result.totalPages,
        useL100km: _useL100km,
        selectedPeriod: _selectedPeriod,
      ));
    } catch (e) {
      emit(EfficiencyError(e.toString()));
    }
  }

  /// Load more history items for infinite scroll
  Future<void> _onLoadMoreHistory(
    LoadMoreHistory event,
    Emitter<EfficiencyState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EfficiencyHistoryLoaded || !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final dates = _getPeriodDates(_selectedPeriod);
      final result = await _repository.getHistory(
        page: currentState.currentPage + 1,
        startDate: dates['start'],
        endDate: dates['end'],
      );

      emit(currentState.copyWith(
        items: [...currentState.items, ...result.items],
        currentPage: result.page,
        totalPages: result.totalPages,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Toggle between km/L and L/100km
  void _onToggleUnit(
    ToggleEfficiencyUnit event,
    Emitter<EfficiencyState> emit,
  ) {
    _useL100km = !_useL100km;
    _emitWithUpdatedUnit(emit);
  }

  /// Set unit preference
  void _onSetUnit(
    SetEfficiencyUnit event,
    Emitter<EfficiencyState> emit,
  ) {
    _useL100km = event.useL100km;
    _emitWithUpdatedUnit(emit);
  }

  /// Filter history by period
  Future<void> _onFilterByPeriod(
    FilterHistoryByPeriod event,
    Emitter<EfficiencyState> emit,
  ) async {
    _selectedPeriod = event.period;
    final dates = _getPeriodDates(event.period);

    add(LoadRefuelingHistory(
      refresh: true,
      startDate: dates['start'],
      endDate: dates['end'],
    ));
  }

  /// Get date range for period filter
  Map<String, DateTime?> _getPeriodDates(String period) {
    final now = DateTime.now();
    DateTime? start;
    DateTime? end;

    switch (period) {
      case 'week':
        start = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        start = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'quarter':
        start = DateTime(now.year, now.month - 3, now.day);
        break;
      case 'year':
        start = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    return {'start': start, 'end': end};
  }

  /// Re-emit current state with updated unit preference
  void _emitWithUpdatedUnit(Emitter<EfficiencyState> emit) {
    final currentState = state;
    if (currentState is EfficiencySummaryLoaded) {
      emit(EfficiencySummaryLoaded(
        summary: currentState.summary,
        useL100km: _useL100km,
      ));
    } else if (currentState is EfficiencyLoaded) {
      emit(currentState.copyWith(useL100km: _useL100km));
    } else if (currentState is EfficiencyHistoryLoaded) {
      emit(currentState.copyWith(useL100km: _useL100km));
    }
  }
}
