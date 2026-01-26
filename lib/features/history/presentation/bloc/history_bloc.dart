import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/refueling_history_entity.dart';
import '../../domain/usecases/get_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

/// BLoC para gerenciamento do histórico de abastecimentos
@injectable
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase _getHistoryUseCase;

  static const int _itemsPerPage = 10;

  HistoryBloc(this._getHistoryUseCase) : super(const HistoryState.initial()) {
    on<LoadHistory>(_onLoadHistory);
    on<LoadMore>(_onLoadMore);
    on<ApplyFilters>(_onApplyFilters);
    on<ClearFilters>(_onClearFilters);
    on<RefreshHistory>(_onRefresh);
  }

  /// Handler para carregar histórico inicial
  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryState.loading());

    final result = await _getHistoryUseCase(
      const GetHistoryParams(page: 1, limit: _itemsPerPage),
    );

    result.fold(
      (failure) => emit(HistoryState.error(message: failure.message)),
      (data) {
        final (refuelings, total, hasMore) = data;
        final summary = HistorySummaryEntity.fromRefuelings(refuelings);
        
        emit(HistoryState.loaded(
          refuelings: refuelings,
          summary: summary,
          filters: const HistoryFiltersEntity(),
          currentPage: 1,
          total: total,
          hasMore: hasMore,
        ));
      },
    );
  }

  /// Handler para carregar mais itens (paginação)
  Future<void> _onLoadMore(
    LoadMore event,
    Emitter<HistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HistoryLoaded || currentState.isLoadingMore || !currentState.hasMore) {
      return;
    }

    // Emit loading more state
    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await _getHistoryUseCase(
      GetHistoryParams(
        page: nextPage,
        limit: _itemsPerPage,
        filters: currentState.filters,
      ),
    );

    result.fold(
      (failure) {
        // Volta ao estado anterior sem loading
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (data) {
        final (newRefuelings, total, hasMore) = data;
        final allRefuelings = [...currentState.refuelings, ...newRefuelings];
        final summary = HistorySummaryEntity.fromRefuelings(allRefuelings);
        
        emit(currentState.copyWith(
          refuelings: allRefuelings,
          summary: summary,
          currentPage: nextPage,
          total: total,
          hasMore: hasMore,
          isLoadingMore: false,
        ));
      },
    );
  }

  /// Handler para aplicar filtros
  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryState.loading());

    final result = await _getHistoryUseCase(
      GetHistoryParams(
        page: 1,
        limit: _itemsPerPage,
        filters: event.filters,
      ),
    );

    result.fold(
      (failure) => emit(HistoryState.error(
        message: failure.message,
        filters: event.filters,
      )),
      (data) {
        final (refuelings, total, hasMore) = data;
        final summary = HistorySummaryEntity.fromRefuelings(refuelings);
        
        emit(HistoryState.loaded(
          refuelings: refuelings,
          summary: summary,
          filters: event.filters,
          currentPage: 1,
          total: total,
          hasMore: hasMore,
        ));
      },
    );
  }

  /// Handler para limpar filtros
  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<HistoryState> emit,
  ) async {
    add(const HistoryEvent.loadHistory());
  }

  /// Handler para refresh (pull-to-refresh)
  Future<void> _onRefresh(
    RefreshHistory event,
    Emitter<HistoryState> emit,
  ) async {
    final currentFilters = state.currentFilters;
    
    final result = await _getHistoryUseCase(
      GetHistoryParams(
        page: 1,
        limit: _itemsPerPage,
        filters: currentFilters,
      ),
    );

    result.fold(
      (failure) => emit(HistoryState.error(
        message: failure.message,
        filters: currentFilters,
      )),
      (data) {
        final (refuelings, total, hasMore) = data;
        final summary = HistorySummaryEntity.fromRefuelings(refuelings);
        
        emit(HistoryState.loaded(
          refuelings: refuelings,
          summary: summary,
          filters: currentFilters,
          currentPage: 1,
          total: total,
          hasMore: hasMore,
        ));
      },
    );
  }
}
