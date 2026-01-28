import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zeca_app/core/services/websocket_service.dart';
import 'package:zeca_app/core/services/refueling_polling_service.dart';
import 'package:zeca_app/core/services/api_service.dart';
import 'package:zeca_app/core/services/storage_service.dart';
import 'package:zeca_app/core/di/injection.dart';


part 'refueling_confirmation_event.dart';
part 'refueling_confirmation_state.dart';

/// BLoC centralizado para confirmação de abastecimento
/// 
/// Gerencia o fluxo de confirmação para AUTÔNOMO e FROTA:
/// - Conexão WebSocket
/// - Polling fallback
/// - Validação/Rejeição (Frota)
/// - Timeout e recuperação de erros
class RefuelingConfirmationBloc extends Bloc<RefuelingConfirmationEvent, RefuelingConfirmationState> {
  final WebSocketService _webSocketService;
  final RefuelingPollingService _pollingService;
  final ApiService _apiService;
  final StorageService _storageService;
  
  Timer? _timeoutTimer;
  StreamSubscription? _webSocketSubscription;
  
  static const int timeoutSeconds = 300; // 5 minutos
  static const int pollingIntervalSeconds = 15;
  static const int maxRetries = 3;

  RefuelingConfirmationBloc({
    WebSocketService? webSocketService,
    RefuelingPollingService? pollingService,
    ApiService? apiService,
    StorageService? storageService,
  }) : _webSocketService = webSocketService ?? WebSocketService(),
       _pollingService = pollingService ?? RefuelingPollingService(),
       _apiService = apiService ?? ApiService(),
       _storageService = storageService ?? getIt<StorageService>(),
       super(RefuelingConfirmationState.initial()) {
    
    on<StartListeningForConfirmation>(_onStartListening);
    on<ConfirmationEventReceived>(_onEventReceived);
    on<ConfirmValidation>(_onConfirmValidation);
    on<RejectValidation>(_onRejectValidation);
    on<StopListening>(_onStopListening);
    on<TimeoutReached>(_onTimeoutReached);
    on<ConnectionError>(_onConnectionError);
    on<RetryConnection>(_onRetryConnection);
    on<ForceCheckStatus>(_onForceCheckStatus);
  }

  /// Iniciar escuta por confirmação
  Future<void> _onStartListening(
    StartListeningForConfirmation event,
    Emitter<RefuelingConfirmationState> emit,
  ) async {
    debugPrint('🚀 [ConfirmationBLoC] Iniciando escuta para código: ${event.refuelingCode}');
    
    emit(state.copyWith(
      status: ConfirmationStatus.connecting,
      refuelingCode: event.refuelingCode,
      isAutonomous: event.isAutonomous,
      vehicleData: event.vehicleData,
      stationData: event.stationData,
    ));

    try {
      // 1. Obter token
      final token = await _storageService.getAccessToken();
      if (token == null) {
        emit(state.copyWith(
          status: ConfirmationStatus.error,
          errorCode: 'NO_TOKEN',
          errorMessage: 'Sessão expirada. Faça login novamente.',
        ));
        return;
      }

      // 2. Conectar WebSocket
      await _connectWebSocket(token, event.isAutonomous, emit);

      // 3. Iniciar timer de timeout
      _startTimeoutTimer(emit);

      // 4. Atualizar estado
      emit(state.copyWith(
        status: ConfirmationStatus.waitingForStation,
        isWebSocketConnected: _webSocketService.isConnected,
      ));

      // 5. Iniciar polling como fallback
      _startPollingFallback(event.refuelingCode, event.isAutonomous);

      // 6. Verificar se já existe abastecimento
      await _checkExistingRefueling(event.refuelingCode, emit);

    } catch (e) {
      debugPrint('❌ [ConfirmationBLoC] Erro ao iniciar: $e');
      emit(state.copyWith(
        status: ConfirmationStatus.error,
        errorMessage: 'Erro ao iniciar conexão: $e',
      ));
    }
  }

  /// Conectar WebSocket
  Future<void> _connectWebSocket(
    String token,
    bool isAutonomous,
    Emitter<RefuelingConfirmationState> emit,
  ) async {
    _webSocketService.connect(
      token: token,
      onAutonomousPaymentConfirmed: isAutonomous ? (data) {
        add(ConfirmationEventReceived(
          eventType: 'autonomous_payment_confirmed',
          data: Map<String, dynamic>.from(data),
        ));
      } : null,
      onRefuelingPendingValidation: !isAutonomous ? (data) {
        add(ConfirmationEventReceived(
          eventType: 'refueling:pending_validation',
          data: Map<String, dynamic>.from(data),
        ));
      } : null,
      onConnected: () {
        debugPrint('✅ [ConfirmationBLoC] WebSocket conectado');
      },
      onError: (error) {
        debugPrint('❌ [ConfirmationBLoC] WebSocket erro: $error');
        add(ConnectionError(error));
      },
      onDisconnected: () {
        debugPrint('🔌 [ConfirmationBLoC] WebSocket desconectado');
      },
    );
  }

  /// Iniciar polling como fallback
  void _startPollingFallback(String refuelingCode, bool isAutonomous) {
    debugPrint('🔄 [ConfirmationBLoC] Iniciando polling fallback');
    
    if (isAutonomous) {
      _pollingService.startPollingForStatus(
        refuelingCode: refuelingCode,
        targetStatus: 'CONCLUIDO',
        intervalSeconds: pollingIntervalSeconds,
        onStatusReached: (data) {
          add(ConfirmationEventReceived(
            eventType: 'autonomous_payment_confirmed',
            data: Map<String, dynamic>.from(data),
          ));
        },
      );
    } else {
      _pollingService.startPolling(
        refuelingCode: refuelingCode,
        intervalSeconds: pollingIntervalSeconds,
        onStatusChanged: (refuelingId) async {
          // Buscar dados completos
          final response = await _apiService.getPendingValidation(refuelingId);
          if (response['success'] == true && response['data'] != null) {
            add(ConfirmationEventReceived(
              eventType: 'refueling:pending_validation',
              data: Map<String, dynamic>.from(response['data']),
            ));
          }
        },
      );
    }
  }

  /// Verificar se já existe abastecimento
  Future<void> _checkExistingRefueling(
    String refuelingCode,
    Emitter<RefuelingConfirmationState> emit,
  ) async {
    try {
      final response = await _pollingService.checkStatusByCodeOnce(refuelingCode);
      if (response != null) {
        final status = response['status']?.toString().toUpperCase();
        
        if (status == 'CONCLUIDO') {
          add(ConfirmationEventReceived(
            eventType: 'autonomous_payment_confirmed',
            data: Map<String, dynamic>.from(response),
          ));
        } else if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
          add(ConfirmationEventReceived(
            eventType: 'refueling:pending_validation',
            data: Map<String, dynamic>.from(response),
          ));
        } else if (status == 'CANCELADO') {
          add(ConfirmationEventReceived(
            eventType: 'refueling:cancelled',
            data: Map<String, dynamic>.from(response),
          ));
        }
      }
    } catch (e) {
      debugPrint('⚠️ [ConfirmationBLoC] Erro ao verificar existente: $e');
    }
  }

  /// Evento recebido (WebSocket ou Polling)
  Future<void> _onEventReceived(
    ConfirmationEventReceived event,
    Emitter<RefuelingConfirmationState> emit,
  ) async {
    debugPrint('📦 [ConfirmationBLoC] Evento recebido: ${event.eventType}');
    debugPrint('📦 [ConfirmationBLoC] Dados: ${event.data}');

    // Parar polling e timer
    _pollingService.stopPolling();
    _timeoutTimer?.cancel();

    switch (event.eventType) {
      case 'autonomous_payment_confirmed':
        emit(state.copyWith(
          status: ConfirmationStatus.completed,
          refuelingData: event.data,
          refuelingId: event.data['id']?.toString() ?? event.data['refueling_id']?.toString(),
        ));
        break;

      case 'refueling:pending_validation':
        emit(state.copyWith(
          status: ConfirmationStatus.dataReceived,
          refuelingData: event.data,
          refuelingId: event.data['id']?.toString() ?? event.data['refueling_id']?.toString(),
        ));
        break;

      case 'refueling:cancelled':
        emit(state.copyWith(
          status: ConfirmationStatus.cancelled,
          refuelingData: event.data,
          cancellationReason: event.data['cancellation_reason']?.toString(),
        ));
        break;

      case 'refueling:error':
        emit(state.copyWith(
          status: ConfirmationStatus.error,
          errorCode: event.data['error_code']?.toString(),
          errorMessage: event.data['error_message']?.toString(),
        ));
        break;

      default:
        debugPrint('⚠️ [ConfirmationBLoC] Evento desconhecido: ${event.eventType}');
    }
  }

  /// Confirmar validação (Frota)
  Future<void> _onConfirmValidation(
    ConfirmValidation event,
    Emitter<RefuelingConfirmationState> emit,
  ) async {
    debugPrint('✅ [ConfirmationBLoC] Confirmando validação: ${event.refuelingId}');
    
    emit(state.copyWith(status: ConfirmationStatus.validating));

    try {
      final response = await _apiService.validateRefueling(
        refuelingId: event.refuelingId,
        device: event.device,
        latitude: event.latitude,
        longitude: event.longitude,
        address: event.address,
      );

      if (response['success'] == true) {
        emit(state.copyWith(status: ConfirmationStatus.completed));
      } else {
        throw Exception(response['error'] ?? 'Erro ao confirmar validação');
      }
    } catch (e) {
      debugPrint('❌ [ConfirmationBLoC] Erro ao confirmar: $e');
      emit(state.copyWith(
        status: ConfirmationStatus.error,
        errorMessage: 'Erro ao confirmar: $e',
      ));
    }
  }

  /// Rejeitar validação (Frota)
  Future<void> _onRejectValidation(
    RejectValidation event,
    Emitter<RefuelingConfirmationState> emit,
  ) async {
    debugPrint('❌ [ConfirmationBLoC] Rejeitando validação: ${event.refuelingId}');
    
    emit(state.copyWith(status: ConfirmationStatus.validating));

    try {
      final response = await _apiService.rejectRefueling(
        refuelingId: event.refuelingId,
        device: event.device,
        latitude: event.latitude,
        longitude: event.longitude,
        address: event.address,
      );

      if (response['success'] == true) {
        emit(state.copyWith(status: ConfirmationStatus.rejected));
      } else {
        throw Exception(response['error'] ?? 'Erro ao rejeitar');
      }
    } catch (e) {
      debugPrint('❌ [ConfirmationBLoC] Erro ao rejeitar: $e');
      emit(state.copyWith(
        status: ConfirmationStatus.error,
        errorMessage: 'Erro ao rejeitar: $e',
      ));
    }
  }

  /// Parar escuta
  void _onStopListening(
    StopListening event,
    Emitter<RefuelingConfirmationState> emit,
  ) {
    debugPrint('🛑 [ConfirmationBLoC] Parando escuta');
    _cleanup();
  }

  /// Timeout atingido
  void _onTimeoutReached(
    TimeoutReached event,
    Emitter<RefuelingConfirmationState> emit,
  ) {
    debugPrint('⏱️ [ConfirmationBLoC] Timeout atingido');
    _pollingService.stopPolling();
    emit(state.copyWith(status: ConfirmationStatus.timeout));
  }

  /// Erro de conexão
  void _onConnectionError(
    ConnectionError event,
    Emitter<RefuelingConfirmationState> emit,
  ) {
    debugPrint('❌ [ConfirmationBLoC] Erro de conexão: ${event.message}');
    
    // Se ainda não atingiu max retries, continuar com polling
    if (state.retryCount < maxRetries) {
      emit(state.copyWith(
        isWebSocketConnected: false,
        isPollingFallback: true,
        retryCount: state.retryCount + 1,
      ));
    } else {
      emit(state.copyWith(
        status: ConfirmationStatus.error,
        errorMessage: 'Falha na conexão após ${state.retryCount} tentativas',
      ));
    }
  }

  /// Retry manual
  Future<void> _onRetryConnection(
    RetryConnection event,
    Emitter<RefuelingConfirmationState> emit,
  ) async {
    debugPrint('🔄 [ConfirmationBLoC] Retry manual');
    
    if (state.refuelingCode != null) {
      add(StartListeningForConfirmation(
        refuelingCode: state.refuelingCode!,
        isAutonomous: state.isAutonomous,
        vehicleData: state.vehicleData,
        stationData: state.stationData,
      ));
    }
  }

  /// Verificação manual forçada
  Future<void> _onForceCheckStatus(
    ForceCheckStatus event,
    Emitter<RefuelingConfirmationState> emit,
  ) async {
    debugPrint('🔍 [ConfirmationBLoC] Verificação manual');
    
    if (state.refuelingCode == null) return;
    
    try {
      final response = await _pollingService.checkStatusByCodeOnce(state.refuelingCode!);
      if (response != null) {
        final status = response['status']?.toString().toUpperCase();
        
        if (status == 'CONCLUIDO' || status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || status == 'CANCELADO') {
          add(ConfirmationEventReceived(
            eventType: status == 'CONCLUIDO' 
                ? 'autonomous_payment_confirmed' 
                : status == 'CANCELADO'
                    ? 'refueling:cancelled'
                    : 'refueling:pending_validation',
            data: Map<String, dynamic>.from(response),
          ));
        }
      }
    } catch (e) {
      debugPrint('❌ [ConfirmationBLoC] Erro na verificação manual: $e');
    }
  }

  /// Iniciar timer de timeout
  void _startTimeoutTimer(Emitter<RefuelingConfirmationState> emit) {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(Duration(seconds: timeoutSeconds), () {
      add(const TimeoutReached());
    });
  }

  /// Limpar recursos
  void _cleanup() {
    _timeoutTimer?.cancel();
    _pollingService.stopPolling();
    _webSocketSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _cleanup();
    return super.close();
  }
}
