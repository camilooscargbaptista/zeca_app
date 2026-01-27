part of 'checklist_bloc.dart';

/// Estados do ChecklistBloc
@freezed
class ChecklistState with _$ChecklistState {
  const factory ChecklistState({
    // Estado de carregamento
    @Default(true) bool isLoading,
    @Default(false) bool isSaving,

    // Dados
    @Default(null) Map<String, dynamic>? vehicleData,
    @Default(null) Map<String, dynamic>? checklistData,
    @Default(null) String? executionId,

    // Mapa de respostas: item_id -> {value, is_conforming, notes}
    @Default({}) Map<String, Map<String, dynamic>> responses,

    // Erro
    @Default(false) bool hasError,
    @Default(null) String? errorMessage,

    // Sucesso de salvamento
    @Default(false) bool saveSuccess,
  }) = _ChecklistState;
}
