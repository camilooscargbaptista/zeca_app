part of 'checklist_bloc.dart';

/// Eventos do ChecklistBloc
@freezed
class ChecklistEvent with _$ChecklistEvent {
  /// Carregar dados do veículo e checklist
  const factory ChecklistEvent.loadData() = _LoadData;

  /// Veículo carregado
  const factory ChecklistEvent.vehicleLoaded(Map<String, dynamic> vehicleData) = _VehicleLoaded;

  /// Checklist carregado
  const factory ChecklistEvent.checklistLoaded(Map<String, dynamic> checklistData) = _ChecklistLoaded;

  /// Erro no carregamento
  const factory ChecklistEvent.loadFailed(String message) = _LoadFailed;

  /// Responder um item
  const factory ChecklistEvent.answerItem({
    required String itemId,
    required String value,
    @Default(true) bool isConforming,
    String? notes,
  }) = _AnswerItem;

  /// Iniciar salvamento
  const factory ChecklistEvent.startSaving() = _StartSaving;

  /// Execução iniciada
  const factory ChecklistEvent.executionStarted(String executionId) = _ExecutionStarted;

  /// Salvamento concluído com sucesso
  const factory ChecklistEvent.saveCompleted() = _SaveCompleted;

  /// Erro ao salvar
  const factory ChecklistEvent.saveFailed(String message) = _SaveFailed;

  /// Limpar erro
  const factory ChecklistEvent.clearError() = _ClearError;

  /// Reset do estado
  const factory ChecklistEvent.reset() = _Reset;
}
