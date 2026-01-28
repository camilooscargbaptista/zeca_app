part of 'refueling_confirmation_bloc.dart';

/// Eventos do BLoC de Confirmação de Abastecimento
abstract class RefuelingConfirmationEvent extends Equatable {
  const RefuelingConfirmationEvent();

  @override
  List<Object?> get props => [];
}

/// Iniciar escuta por confirmação de abastecimento
class StartListeningForConfirmation extends RefuelingConfirmationEvent {
  final String refuelingCode;
  final bool isAutonomous;
  final Map<String, dynamic>? vehicleData;
  final Map<String, dynamic>? stationData;

  const StartListeningForConfirmation({
    required this.refuelingCode,
    required this.isAutonomous,
    this.vehicleData,
    this.stationData,
  });

  @override
  List<Object?> get props => [refuelingCode, isAutonomous, vehicleData, stationData];
}

/// Evento WebSocket/Polling recebido
class ConfirmationEventReceived extends RefuelingConfirmationEvent {
  final String eventType;
  final Map<String, dynamic> data;

  const ConfirmationEventReceived({
    required this.eventType,
    required this.data,
  });

  @override
  List<Object?> get props => [eventType, data];
}

/// Motorista confirma validação (Frota)
class ConfirmValidation extends RefuelingConfirmationEvent {
  final String refuelingId;
  final double latitude;
  final double longitude;
  final String? address;
  final String device;

  const ConfirmValidation({
    required this.refuelingId,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.device,
  });

  @override
  List<Object?> get props => [refuelingId, latitude, longitude, address, device];
}

/// Motorista rejeita validação (Frota)
class RejectValidation extends RefuelingConfirmationEvent {
  final String refuelingId;
  final double latitude;
  final double longitude;
  final String? address;
  final String device;

  const RejectValidation({
    required this.refuelingId,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.device,
  });

  @override
  List<Object?> get props => [refuelingId, latitude, longitude, address, device];
}

/// Parar escuta
class StopListening extends RefuelingConfirmationEvent {
  const StopListening();
}

/// Timeout atingido
class TimeoutReached extends RefuelingConfirmationEvent {
  const TimeoutReached();
}

/// Erro de conexão
class ConnectionError extends RefuelingConfirmationEvent {
  final String message;

  const ConnectionError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Retry manual
class RetryConnection extends RefuelingConfirmationEvent {
  const RetryConnection();
}

/// Verificação manual forçada
class ForceCheckStatus extends RefuelingConfirmationEvent {
  const ForceCheckStatus();
}
