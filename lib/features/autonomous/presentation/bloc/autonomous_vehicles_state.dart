import 'package:freezed_annotation/freezed_annotation.dart';

part 'autonomous_vehicles_state.freezed.dart';

/// Estado para o BLoC de veículos autônomos
@freezed
class AutonomousVehiclesState with _$AutonomousVehiclesState {
  const AutonomousVehiclesState._();
  
  const factory AutonomousVehiclesState({
    @Default(true) bool isLoading,
    @Default(false) bool isDeleting,
    @Default([]) List<Map<String, dynamic>> vehicles,
    @Default(3) int vehicleLimit,
    String? error,
  }) = _AutonomousVehiclesState;
  
  /// Verifica se pode adicionar mais veículos
  bool get canAddVehicle => vehicles.length < vehicleLimit;
  
  /// Total de veículos
  int get vehicleCount => vehicles.length;
}
