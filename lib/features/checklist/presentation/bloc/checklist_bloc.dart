import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'checklist_event.dart';
part 'checklist_state.dart';
part 'checklist_bloc.freezed.dart';

/// BLoC para gerenciar estado do Checklist
/// 
/// Responsabilidades:
/// - Carregar dados do veículo e checklist
/// - Gerenciar respostas dos itens
/// - Controlar fluxo de salvamento
/// - Gerenciar estado de loading/saving
@injectable
class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  ChecklistBloc() : super(const ChecklistState()) {
    on<_LoadData>(_onLoadData);
    on<_VehicleLoaded>(_onVehicleLoaded);
    on<_ChecklistLoaded>(_onChecklistLoaded);
    on<_LoadFailed>(_onLoadFailed);
    on<_AnswerItem>(_onAnswerItem);
    on<_StartSaving>(_onStartSaving);
    on<_ExecutionStarted>(_onExecutionStarted);
    on<_SaveCompleted>(_onSaveCompleted);
    on<_SaveFailed>(_onSaveFailed);
    on<_ClearError>(_onClearError);
    on<_Reset>(_onReset);
  }

  void _onLoadData(
    _LoadData event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    ));
  }

  void _onVehicleLoaded(
    _VehicleLoaded event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(vehicleData: event.vehicleData));
  }

  void _onChecklistLoaded(
    _ChecklistLoaded event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(
      checklistData: event.checklistData,
      isLoading: false,
    ));
  }

  void _onLoadFailed(
    _LoadFailed event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(
      isLoading: false,
      hasError: true,
      errorMessage: event.message,
    ));
  }

  void _onAnswerItem(
    _AnswerItem event,
    Emitter<ChecklistState> emit,
  ) {
    final newResponses = Map<String, Map<String, dynamic>>.from(state.responses);
    newResponses[event.itemId] = {
      'value': event.value,
      'is_conforming': event.isConforming,
      'notes': event.notes,
    };
    emit(state.copyWith(responses: newResponses));
  }

  void _onStartSaving(
    _StartSaving event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(
      isSaving: true,
      hasError: false,
      errorMessage: null,
      saveSuccess: false,
    ));
  }

  void _onExecutionStarted(
    _ExecutionStarted event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(executionId: event.executionId));
  }

  void _onSaveCompleted(
    _SaveCompleted event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(
      isSaving: false,
      saveSuccess: true,
    ));
  }

  void _onSaveFailed(
    _SaveFailed event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(
      isSaving: false,
      hasError: true,
      errorMessage: event.message,
    ));
  }

  void _onClearError(
    _ClearError event,
    Emitter<ChecklistState> emit,
  ) {
    emit(state.copyWith(
      hasError: false,
      errorMessage: null,
    ));
  }

  void _onReset(
    _Reset event,
    Emitter<ChecklistState> emit,
  ) {
    emit(const ChecklistState());
  }

  /// Helper: Verifica se há checklist disponível
  bool hasChecklist() {
    if (state.checklistData == null) return false;
    final checklists = state.checklistData!['checklists'] as List?;
    return checklists != null && checklists.isNotEmpty;
  }

  /// Helper: Calcula progresso do checklist
  Map<String, dynamic> calculateProgress() {
    int totalItems = 0;
    int answeredItems = 0;
    
    final checklists = state.checklistData?['checklists'] as List?;
    if (checklists == null || checklists.isEmpty) {
      return {'total': 0, 'answered': 0, 'percentage': 0.0};
    }
    
    final checklist = checklists[0];
    final sections = checklist['sections'] as List?;
    if (sections == null) {
      return {'total': 0, 'answered': 0, 'percentage': 0.0};
    }
    
    for (final section in sections) {
      final items = section['items'] as List?;
      if (items == null) continue;
      
      totalItems += items.length;
      
      for (final item in items) {
        final itemId = item['id'];
        if (state.responses.containsKey(itemId)) {
          answeredItems++;
        }
      }
    }
    
    final percentage = totalItems > 0 ? (answeredItems / totalItems) : 0.0;
    
    return {
      'total': totalItems,
      'answered': answeredItems,
      'percentage': percentage,
    };
  }

  /// Helper: Verifica se todos os itens críticos foram respondidos
  bool areAllRequiredItemsAnswered() {
    if (state.checklistData == null) return false;
    
    final checklists = state.checklistData!['checklists'] as List?;
    if (checklists == null || checklists.isEmpty) return false;
    
    final checklist = checklists[0];
    final sections = checklist['sections'] as List?;
    if (sections == null) return true;
    
    for (final section in sections) {
      final items = section['items'] as List?;
      if (items == null) continue;
      
      for (final item in items) {
        final itemId = item['id'];
        if (item['is_critical'] == true && !state.responses.containsKey(itemId)) {
          return false;
        }
      }
    }
    
    return true;
  }
}
