part of 'refueling_confirmation_bloc.dart';

/// Status do fluxo de confirmação
enum ConfirmationStatus {
  /// Estado inicial
  initial,
  
  /// Conectando ao WebSocket
  connecting,
  
  /// Aguardando posto registrar abastecimento
  waitingForStation,
  
  /// Dados recebidos, aguardando validação do motorista (Frota)
  dataReceived,
  
  /// Motorista está validando
  validating,
  
  /// Abastecimento concluído com sucesso
  completed,
  
  /// Abastecimento cancelado pelo posto
  cancelled,
  
  /// Motorista rejeitou os dados
  rejected,
  
  /// Erro genérico
  error,
  
  /// Timeout sem resposta
  timeout,
}

/// Estado do BLoC de Confirmação de Abastecimento
class RefuelingConfirmationState extends Equatable {
  final ConfirmationStatus status;
  final String? refuelingCode;
  final String? refuelingId;
  final bool isAutonomous;
  
  /// Dados do abastecimento recebidos
  final Map<String, dynamic>? refuelingData;
  
  /// Dados do veículo
  final Map<String, dynamic>? vehicleData;
  
  /// Dados do posto
  final Map<String, dynamic>? stationData;
  
  /// Mensagem de erro
  final String? errorMessage;
  
  /// Código de erro para tratamento específico
  final String? errorCode;
  
  /// Motivo do cancelamento pelo posto
  final String? cancellationReason;
  
  /// WebSocket está conectado?
  final bool isWebSocketConnected;
  
  /// Usando polling como fallback?
  final bool isPollingFallback;
  
  /// Tentativas de retry
  final int retryCount;
  
  /// Tempo restante para timeout (segundos)
  final int? timeoutRemainingSeconds;

  const RefuelingConfirmationState({
    this.status = ConfirmationStatus.initial,
    this.refuelingCode,
    this.refuelingId,
    this.isAutonomous = false,
    this.refuelingData,
    this.vehicleData,
    this.stationData,
    this.errorMessage,
    this.errorCode,
    this.cancellationReason,
    this.isWebSocketConnected = false,
    this.isPollingFallback = false,
    this.retryCount = 0,
    this.timeoutRemainingSeconds,
  });

  /// Estado inicial
  factory RefuelingConfirmationState.initial() => const RefuelingConfirmationState();

  /// Copiar com alterações
  RefuelingConfirmationState copyWith({
    ConfirmationStatus? status,
    String? refuelingCode,
    String? refuelingId,
    bool? isAutonomous,
    Map<String, dynamic>? refuelingData,
    Map<String, dynamic>? vehicleData,
    Map<String, dynamic>? stationData,
    String? errorMessage,
    String? errorCode,
    String? cancellationReason,
    bool? isWebSocketConnected,
    bool? isPollingFallback,
    int? retryCount,
    int? timeoutRemainingSeconds,
  }) {
    return RefuelingConfirmationState(
      status: status ?? this.status,
      refuelingCode: refuelingCode ?? this.refuelingCode,
      refuelingId: refuelingId ?? this.refuelingId,
      isAutonomous: isAutonomous ?? this.isAutonomous,
      refuelingData: refuelingData ?? this.refuelingData,
      vehicleData: vehicleData ?? this.vehicleData,
      stationData: stationData ?? this.stationData,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      isWebSocketConnected: isWebSocketConnected ?? this.isWebSocketConnected,
      isPollingFallback: isPollingFallback ?? this.isPollingFallback,
      retryCount: retryCount ?? this.retryCount,
      timeoutRemainingSeconds: timeoutRemainingSeconds ?? this.timeoutRemainingSeconds,
    );
  }

  @override
  List<Object?> get props => [
    status,
    refuelingCode,
    refuelingId,
    isAutonomous,
    refuelingData,
    vehicleData,
    stationData,
    errorMessage,
    errorCode,
    cancellationReason,
    isWebSocketConnected,
    isPollingFallback,
    retryCount,
    timeoutRemainingSeconds,
  ];
}
