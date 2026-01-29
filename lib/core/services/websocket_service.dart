import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/api_config.dart';

/// Serviço de WebSocket para notificações em tempo real
/// 
/// Conecta ao servidor WebSocket para receber eventos de abastecimento
/// em tempo real, substituindo o polling a cada 15 segundos.
/// 
/// Eventos recebidos:
/// - refueling:pending_validation - Quando abastecimento precisa validação do motorista
class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  bool _isConnecting = false;
  String? _currentDriverId;
  
  // === NOVO: Timeout e código para conexão persistente ===
  Timer? _timeoutTimer;
  String? _currentRefuelingCode;
  static const int CONNECTION_TIMEOUT_MINUTES = 30;
  
  // Callbacks para eventos
  Function(Map<String, dynamic>)? _onRefuelingPendingValidation;
  Function(Map<String, dynamic>)? _onAutonomousPaymentConfirmed;
  Function(Map<String, dynamic>)? _onRefuelingCancelled;
  Function(Map<String, dynamic>)? _onRefuelingError;
  Function(Map<String, dynamic>)? _onRefuelingValidatedByStation;
  Function()? _onConnected;
  Function(String)? _onError;
  Function()? _onDisconnected;
  
  // Stream controller para eventos de conexão
  final StreamController<bool> _connectionStatusController = 
      StreamController<bool>.broadcast();
  
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool get isConnected => _isConnected;

  /// Conectar ao servidor WebSocket
  /// 
  /// [token] - JWT token para autenticação
  /// [onRefuelingPendingValidation] - Callback quando receber evento de validação pendente
  void connect({
    required String token,
    Function(Map<String, dynamic>)? onRefuelingPendingValidation,
    Function(Map<String, dynamic>)? onAutonomousPaymentConfirmed,
    Function()? onConnected,
    Function(String)? onError,
    Function()? onDisconnected,
  }) {
    // Atualizar callbacks sempre (mesmo se já conectado)
    _onRefuelingPendingValidation = onRefuelingPendingValidation;
    _onAutonomousPaymentConfirmed = onAutonomousPaymentConfirmed;
    _onConnected = onConnected;
    _onError = onError;
    _onDisconnected = onDisconnected;

    if (_isConnecting || _isConnected) {
      debugPrint('⚠️ [WebSocket] Já conectado ou conectando... Apenas atualizando listeners.');
      // Se tiver callback de conexão, chamar imediatamanete se já conectado
      if (_isConnected) {
         _onConnected?.call();
      }
      return;
    }

    _isConnecting = true;

    try {
      // URL base para Socket.IO - NÃO adicionar namespace na URL
      // O namespace é configurado via option 'path' ou simplesmente /refueling
      // Bug conhecido: socket_io_client adiciona porta :0 quando usa HTTPS sem porta explícita
      final baseUrl = ApiConfig.baseUrl;
      
      debugPrint('🔌 [WebSocket] Conectando a: $baseUrl (namespace: /refueling)');

      _socket = IO.io(
        '$baseUrl/refueling', // Namespace na URL
        IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // Permitir fallback para polling HTTP
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .setAuth({'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .setReconnectionDelayMax(10000)
          .enableForceNew() // Forçar nova conexão
          .build(),
      );

      _setupListeners();

    } catch (e) {
      debugPrint('❌ [WebSocket] Erro ao conectar: $e');
      _isConnecting = false;
      _onError?.call(e.toString());
    }
  }

  /// Configurar listeners de eventos
  void _setupListeners() {
    if (_socket == null) return;

    // Evento de conexão estabelecida
    _socket!.onConnect((_) {
      debugPrint('✅ [WebSocket] Conectado ao servidor!');
      _isConnected = true;
      _isConnecting = false;
      _connectionStatusController.add(true);
      _onConnected?.call();
    });

    // Debug: Logar TODOS os eventos recebidos
    _socket!.onAny((event, data) {
      debugPrint('🕵️ [WebSocket] Evento raw recebido: "$event"');
      if (data != null) debugPrint('   Dados: $data');
    });

    // Evento de confirmação de conexão do servidor
    _socket!.on('connected', (data) {
      debugPrint('✅ [WebSocket] Confirmação do servidor: $data');
      if (data is Map && data['room'] != null) {
        debugPrint('📍 [WebSocket] Associado à sala: ${data['room']}');
      }
    });

    // ⚡ EVENTO PRINCIPAL: Abastecimento pendente de validação
    _socket!.on('refueling:pending_validation', (data) {
      debugPrint('🎯 [WebSocket] Evento recebido: refueling:pending_validation');
      debugPrint('📦 [WebSocket] Dados: $data');
      
      if (data is Map<String, dynamic>) {
        _onRefuelingPendingValidation?.call(data);
      } else if (data is Map) {
        _onRefuelingPendingValidation?.call(Map<String, dynamic>.from(data));
      }
    });

    // 💰 EVENTO: Pagamento Autônomo Confirmado
    _socket!.on('autonomous_payment_confirmed', (data) {
      debugPrint('💰 [WebSocket] Evento recebido: autonomous_payment_confirmed');
      debugPrint('📦 [WebSocket] Dados: $data');
      
      if (data is Map<String, dynamic>) {
        _onAutonomousPaymentConfirmed?.call(data);
      } else if (data is Map) {
        _onAutonomousPaymentConfirmed?.call(Map<String, dynamic>.from(data));
      }
    });

    // ❌ EVENTO: Abastecimento Cancelado pelo Posto
    _socket!.on('refueling:cancelled', (data) {
      debugPrint('❌ [WebSocket] Evento recebido: refueling:cancelled');
      debugPrint('📦 [WebSocket] Dados: $data');
      
      if (data is Map<String, dynamic>) {
        _onRefuelingCancelled?.call(data);
      } else if (data is Map) {
        _onRefuelingCancelled?.call(Map<String, dynamic>.from(data));
      }
    });

    // ⚠️ EVENTO: Erro no Abastecimento
    _socket!.on('refueling:error', (data) {
      debugPrint('⚠️ [WebSocket] Evento recebido: refueling:error');
      debugPrint('📦 [WebSocket] Dados: $data');
      
      if (data is Map<String, dynamic>) {
        _onRefuelingError?.call(data);
      } else if (data is Map) {
        _onRefuelingError?.call(Map<String, dynamic>.from(data));
      }
    });

    // ℹ️ EVENTO: Validado pelo Posto (em nome do motorista)
    _socket!.on('refueling:validated_by_station', (data) {
      debugPrint('ℹ️ [WebSocket] Evento recebido: refueling:validated_by_station');
      debugPrint('📦 [WebSocket] Dados: $data');
      
      if (data is Map<String, dynamic>) {
        _onRefuelingValidatedByStation?.call(data);
      } else if (data is Map) {
        _onRefuelingValidatedByStation?.call(Map<String, dynamic>.from(data));
      }
    });

    // Evento de erro
    _socket!.on('error', (data) {
      debugPrint('❌ [WebSocket] Erro do servidor: $data');
      if (data is Map && data['message'] != null) {
        _onError?.call(data['message'].toString());
      }
    });

    // Evento de desconexão
    _socket!.onDisconnect((_) {
      debugPrint('🔌 [WebSocket] Desconectado do servidor');
      _isConnected = false;
      _connectionStatusController.add(false);
      _onDisconnected?.call();
    });

    // Evento de erro de conexão
    _socket!.onConnectError((error) {
      debugPrint('❌ [WebSocket] Erro de conexão: $error');
      _isConnecting = false;
      _onError?.call('Erro de conexão: $error');
    });

    // Evento de reconexão
    _socket!.onReconnect((_) {
      debugPrint('🔄 [WebSocket] Reconectado!');
      _isConnected = true;
      _connectionStatusController.add(true);
    });

    // Evento de tentativa de reconexão
    _socket!.onReconnectAttempt((attemptNumber) {
      debugPrint('🔄 [WebSocket] Tentativa de reconexão #$attemptNumber');
    });

    // Evento de erro de reconexão
    _socket!.onReconnectError((error) {
      debugPrint('❌ [WebSocket] Erro de reconexão: $error');
    });

    // Evento de falha de reconexão (todas tentativas falharam)
    _socket!.onReconnectFailed((_) {
      debugPrint('❌ [WebSocket] Todas tentativas de reconexão falharam');
      _isConnecting = false;
      _onError?.call('Falha ao reconectar - usando fallback de polling');
    });
  }

  /// Desconectar do servidor WebSocket
  void disconnect() {
    debugPrint('🔌 [WebSocket] Desconectando...');
    
    // Cancelar timeout se existir
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    _currentRefuelingCode = null;
    
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    
    _isConnected = false;
    _isConnecting = false;
    _currentDriverId = null;
    
    _onRefuelingPendingValidation = null;
    _onConnected = null;
    _onError = null;
    _onDisconnected = null;
    
    _connectionStatusController.add(false);
    
    debugPrint('✅ [WebSocket] Desconectado');
  }

  /// Conectar para abastecimento específico com timeout de 30 minutos
  /// 
  /// Esta é a forma preferida de conectar durante o fluxo de abastecimento.
  /// O WebSocket permanece conectado até:
  /// - Timeout de 30 minutos
  /// - Receber evento de conclusão/cancelamento
  /// - Chamada explícita de disconnect()
  void connectForRefueling({
    required String token,
    required String refuelingCode,
    Function(Map<String, dynamic>)? onRefuelingPendingValidation,
    Function(Map<String, dynamic>)? onAutonomousPaymentConfirmed,
    Function()? onConnected,
    Function(String)? onError,
  }) {
    debugPrint('🚀 [WebSocket] connectForRefueling iniciado para código: $refuelingCode');
    
    // Salvar código atual para validação de eventos
    _currentRefuelingCode = refuelingCode;
    
    // Cancelar timeout anterior se existir
    _timeoutTimer?.cancel();
    
    // Conectar WebSocket
    connect(
      token: token,
      onRefuelingPendingValidation: onRefuelingPendingValidation,
      onAutonomousPaymentConfirmed: onAutonomousPaymentConfirmed,
      onConnected: () {
        debugPrint('✅ [WebSocket] Conectado para código: $refuelingCode');
        onConnected?.call();
      },
      onError: onError,
    );
    
    // Configurar timeout de 30 minutos
    _timeoutTimer = Timer(Duration(minutes: CONNECTION_TIMEOUT_MINUTES), () {
      debugPrint('⏰ [WebSocket] Timeout de $CONNECTION_TIMEOUT_MINUTES minutos atingido. Desconectando...');
      disconnect();
    });
    
    debugPrint('⏱️ [WebSocket] Timeout configurado para $CONNECTION_TIMEOUT_MINUTES minutos');
  }
  
  /// Getter para código de abastecimento atual
  String? get currentRefuelingCode => _currentRefuelingCode;
  
  /// Verificar se está conectado para um código específico
  bool isConnectedForCode(String code) {
    return _isConnected && _currentRefuelingCode == code;
  }

  /// Reconectar manualmente
  void reconnect() {
    if (_socket != null) {
      debugPrint('🔄 [WebSocket] Forçando reconexão...');
      _socket!.connect();
    }
  }

  /// Verificar se está conectado
  bool checkConnection() {
    return _socket?.connected ?? false;
  }

  /// Limpar recursos
  void dispose() {
    disconnect();
    _connectionStatusController.close();
  }

  /// Registrar listener temporário para pagamento autônomo
  /// Útil quando o callback não foi passado no connect ou precisa ser atualizado
  void listenForAutonomousPaymentConfirmed(Function(Map<String, dynamic>) callback) {
    _onAutonomousPaymentConfirmed = callback;
  }

  /// Registrar listener para validação pendente de FROTA
  /// Quando o posto registra abastecimento e precisa validação do motorista
  void listenForFleetPendingValidation(Function(Map<String, dynamic>) callback) {
    _onRefuelingPendingValidation = callback;
  }

  /// Registrar listener para evento de abastecimento cancelado pelo posto
  void listenForRefuelingCancelled(Function(Map<String, dynamic>) callback) {
    _onRefuelingCancelled = callback;
  }

  /// Registrar listener para evento de erro no abastecimento
  void listenForRefuelingError(Function(Map<String, dynamic>) callback) {
    _onRefuelingError = callback;
  }

  /// Registrar listener para evento de validação pelo posto (em nome do motorista)
  void listenForRefuelingValidatedByStation(Function(Map<String, dynamic>) callback) {
    _onRefuelingValidatedByStation = callback;
  }
}
