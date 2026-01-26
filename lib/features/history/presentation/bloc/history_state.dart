import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/refueling_history_entity.dart';

part 'history_state.freezed.dart';

/// Estados do BLoC de histórico
@freezed
class HistoryState with _$HistoryState {
  const HistoryState._();

  /// Estado inicial
  const factory HistoryState.initial() = HistoryInitial;

  /// Carregando (primeira carga)
  const factory HistoryState.loading() = HistoryLoading;

  /// Carregado com sucesso
  const factory HistoryState.loaded({
    required List<RefuelingHistoryEntity> refuelings,
    required HistorySummaryEntity summary,
    required HistoryFiltersEntity filters,
    required int currentPage,
    required int total,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = HistoryLoaded;

  /// Erro ao carregar
  const factory HistoryState.error({
    required String message,
    HistoryFiltersEntity? filters,
  }) = HistoryError;

  /// Verifica se está no estado loaded
  bool get isLoaded => this is HistoryLoaded;

  /// Retorna os refuelings se estiver loaded
  List<RefuelingHistoryEntity> get refuelings {
    if (this is HistoryLoaded) {
      return (this as HistoryLoaded).refuelings;
    }
    return [];
  }

  /// Retorna os filtros atuais
  HistoryFiltersEntity get currentFilters {
    if (this is HistoryLoaded) {
      return (this as HistoryLoaded).filters;
    }
    if (this is HistoryError) {
      return (this as HistoryError).filters ?? const HistoryFiltersEntity();
    }
    return const HistoryFiltersEntity();
  }
}
