import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/autonomous_repository_impl.dart';
import '../../data/models/autonomous_vehicle_model.dart';

part 'autonomous_vehicles_bloc.freezed.dart';

// Events
@freezed
class AutonomousVehiclesEvent with _$AutonomousVehiclesEvent {
  const factory AutonomousVehiclesEvent.load() = _Load;
  const factory AutonomousVehiclesEvent.create(CreateAutonomousVehicleRequest request) = _Create;
  const factory AutonomousVehiclesEvent.update(String id, UpdateAutonomousVehicleRequest request) = _Update;
  const factory AutonomousVehiclesEvent.delete(String id) = _Delete;
}

// State
@freezed
class AutonomousVehiclesState with _$AutonomousVehiclesState {
  const factory AutonomousVehiclesState({
    @Default([]) List<AutonomousVehicleModel> vehicles,
    @Default(0) int count,
    @Default(3) int limit,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? errorMessage,
    String? successMessage,
  }) = _AutonomousVehiclesState;
}

// Bloc
@injectable
class AutonomousVehiclesBloc extends Bloc<AutonomousVehiclesEvent, AutonomousVehiclesState> {
  final AutonomousRepository _repository;

  AutonomousVehiclesBloc(this._repository) : super(const AutonomousVehiclesState()) {
    on<_Load>(_onLoad);
    on<_Create>(_onCreate);
    on<_Update>(_onUpdate);
    on<_Delete>(_onDelete);
  }

  Future<void> _onLoad(_Load event, Emitter<AutonomousVehiclesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    final vehiclesResult = await _repository.getVehicles();
    final countResult = await _repository.countVehicles();
    
    vehiclesResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (vehicles) {
        countResult.fold(
          (failure) => emit(state.copyWith(
            isLoading: false,
            vehicles: vehicles,
            count: vehicles.length,
          )),
          (countData) => emit(state.copyWith(
            isLoading: false,
            vehicles: vehicles,
            count: countData['count'] ?? vehicles.length,
            limit: countData['limit'] ?? 3,
          )),
        );
      },
    );
  }

  Future<void> _onCreate(_Create event, Emitter<AutonomousVehiclesState> emit) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, successMessage: null));
    
    final result = await _repository.createVehicle(event.request);
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (vehicle) {
        final updatedVehicles = [...state.vehicles, vehicle];
        emit(state.copyWith(
          isSaving: false,
          vehicles: updatedVehicles,
          count: updatedVehicles.length,
          successMessage: 'Veículo cadastrado com sucesso!',
        ));
      },
    );
  }

  Future<void> _onUpdate(_Update event, Emitter<AutonomousVehiclesState> emit) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, successMessage: null));
    
    final result = await _repository.updateVehicle(event.id, event.request);
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (vehicle) {
        final updatedVehicles = state.vehicles.map((v) => v.id == event.id ? vehicle : v).toList();
        emit(state.copyWith(
          isSaving: false,
          vehicles: updatedVehicles,
          successMessage: 'Veículo atualizado com sucesso!',
        ));
      },
    );
  }

  Future<void> _onDelete(_Delete event, Emitter<AutonomousVehiclesState> emit) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, successMessage: null));
    
    final result = await _repository.deleteVehicle(event.id);
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) {
        final updatedVehicles = state.vehicles.where((v) => v.id != event.id).toList();
        emit(state.copyWith(
          isSaving: false,
          vehicles: updatedVehicles,
          count: updatedVehicles.length,
          successMessage: 'Veículo removido com sucesso!',
        ));
      },
    );
  }
}
