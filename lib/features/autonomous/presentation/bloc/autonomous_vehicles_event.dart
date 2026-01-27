import 'package:freezed_annotation/freezed_annotation.dart';

part 'autonomous_vehicles_event.freezed.dart';

/// Eventos para o BLoC de veículos autônomos
@freezed
class AutonomousVehiclesEvent with _$AutonomousVehiclesEvent {
  /// Carregar lista de veículos
  const factory AutonomousVehiclesEvent.loadVehicles() = _LoadVehicles;
  
  /// Veículos carregados com sucesso
  const factory AutonomousVehiclesEvent.vehiclesLoaded(
    List<Map<String, dynamic>> vehicles,
    int limit,
  ) = _VehiclesLoaded;
  
  /// Erro ao carregar veículos
  const factory AutonomousVehiclesEvent.loadFailed(String error) = _LoadFailed;
  
  /// Iniciar exclusão de veículo
  const factory AutonomousVehiclesEvent.startDelete(String vehicleId) = _StartDelete;
  
  /// Exclusão concluída
  const factory AutonomousVehiclesEvent.deleteCompleted() = _DeleteCompleted;
  
  /// Erro ao excluir veículo
  const factory AutonomousVehiclesEvent.deleteFailed(String error) = _DeleteFailed;
}
