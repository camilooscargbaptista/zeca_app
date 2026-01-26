import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/refueling_history_entity.dart';

part 'history_event.freezed.dart';

/// Eventos do BLoC de histórico
@freezed
class HistoryEvent with _$HistoryEvent {
  /// Carrega a lista inicial (ou recarrega do zero)
  const factory HistoryEvent.loadHistory() = LoadHistory;

  /// Carrega mais itens (paginação)
  const factory HistoryEvent.loadMore() = LoadMore;

  /// Aplica filtros e recarrega
  const factory HistoryEvent.applyFilters(HistoryFiltersEntity filters) = ApplyFilters;

  /// Limpa filtros e recarrega
  const factory HistoryEvent.clearFilters() = ClearFilters;

  /// Atualiza a lista (pull-to-refresh)
  const factory HistoryEvent.refresh() = RefreshHistory;
}
