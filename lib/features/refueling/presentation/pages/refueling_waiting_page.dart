import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'dart:convert';
import '../../../../core/services/refueling_polling_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/pending_validation_storage.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/dialogs/success_dialog.dart';
import '../../../../core/services/websocket_service.dart';
import '../../data/models/payment_confirmed_model.dart';
import '../widgets/refueling_notification_dialogs.dart';
import 'autonomous_payment_success_page.dart';

class RefuelingWaitingPage extends StatefulWidget {
  final String refuelingId;
  final String refuelingCode;
  final Map<String, dynamic>? vehicleData;
  final Map<String, dynamic>? stationData;
  final Map<String, dynamic>? driverEstimate; // Dados digitados pelo motorista
  final bool isAutonomous;
  
  const RefuelingWaitingPage({
    Key? key,
    required this.refuelingId,
    required this.refuelingCode,
    this.vehicleData,
    this.stationData,
    this.driverEstimate,
    this.isAutonomous = false,
  }) : super(key: key);

  @override
  State<RefuelingWaitingPage> createState() => _RefuelingWaitingPageState();
}

class _RefuelingWaitingPageState extends State<RefuelingWaitingPage> {
  final RefuelingPollingService _pollingService = RefuelingPollingService();
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  bool _isPolling = false;
  bool _isLoading = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? _refuelingData;
  String? _currentRefuelingId; // ID atual do refueling (pode vir dos dados carregados)
  
  // Dados da empresa para CNPJ (carregado do user_data)
  String _cnpjEmpresa = '';
  String _nomeEmpresa = '';
  // KM do veículo (carregado do journey_vehicle_data)
  int _kmVeiculo = 0;
  
  // Controllers para edição (se contestar)
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isContesting = false;

  @override
  void initState() {
    super.initState();
    _currentRefuelingId = widget.refuelingId.isNotEmpty ? widget.refuelingId : null;
    
    // Salvar estado de validação pendente para recuperar após login se necessário
    _savePendingValidationState();
    
    // Inicializar após obter is_autonomous do JWT
    _initializeWithJwtData();
  }
  
  /// Inicializa a página lendo is_autonomous do JWT token
  Future<void> _initializeWithJwtData() async {
    bool isAutonomous = widget.isAutonomous; // fallback para widget parameter
    
    debugPrint('🔍 [RefuelingWaitingPage] _initializeWithJwtData - INICIANDO');
    debugPrint('🔍 [RefuelingWaitingPage] widget.isAutonomous = ${widget.isAutonomous}');
    
    try {
      final storageService = getIt<StorageService>();
      final token = await storageService.getAccessToken();
      
      debugPrint('🔍 [RefuelingWaitingPage] Token obtido: ${token != null ? 'SIM' : 'NÃO'}');
      
      // NOVO: Carregar CNPJ da empresa do user_data
      final userData = storageService.getUserData();
      if (userData != null) {
        _cnpjEmpresa = userData['cnpj']?.toString() ?? 
                       userData['empresa_cnpj']?.toString() ?? 
                       userData['company']?['cnpj']?.toString() ?? '';
        _nomeEmpresa = userData['empresa']?.toString() ?? 
                       userData['empresa_nome']?.toString() ?? 
                       userData['company']?['nome']?.toString() ?? '';
        debugPrint('📋 [WAITING] CNPJ carregado: $_cnpjEmpresa, Empresa: $_nomeEmpresa');
      }
      
      // NOVO: Carregar KM do veículo do journey_vehicle_data
      final vehicleData = await storageService.getJourneyVehicleData();
      if (vehicleData != null) {
        _kmVeiculo = vehicleData['km'] ?? vehicleData['mileage'] ?? vehicleData['odometer'] ?? 0;
        debugPrint('📋 [WAITING] KM carregado: $_kmVeiculo');
      }
      
      // Atualizar UI com os dados carregados
      if (mounted) setState(() {});
      
      if (token != null) {
        // Decodificar JWT para ler is_autonomous
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
          final decoded = jsonDecode(payload) as Map<String, dynamic>;
          
          debugPrint('🔍 [JWT] Payload completo: $decoded');
          debugPrint('🔍 [JWT] is_autonomous raw value: ${decoded['is_autonomous']}');
          debugPrint('🔍 [JWT] role: ${decoded['role']}');
          
          // Verificar is_autonomous OU role MOTORISTA_AUTONOMO
          isAutonomous = decoded['is_autonomous'] == true || 
                         decoded['role'] == 'MOTORISTA_AUTONOMO';
          debugPrint('🔑 [JWT] is_autonomous FINAL: $isAutonomous');
        }
      }
    } catch (e) {
      debugPrint('⚠️ [JWT] Erro ao decodificar token: $e, usando widget.isAutonomous: ${widget.isAutonomous}');
    }
    
    debugPrint('🎯 [RefuelingWaitingPage] Decisão final isAutonomous: $isAutonomous');
    
    if (isAutonomous) {
      // AUTÔNOMO: WebSocket como principal + polling como fallback (verifica CONCLUIDO)
      debugPrint('🚗 [RefuelingWaitingPage] AUTÔNOMO - configurando WebSocket + polling fallback');
      _setupWebSocketListener();
      _setupNotificationListeners(); // Novos eventos: cancelled, error, validated_by_station
      // Polling fallback: verifica status CONCLUIDO
      _startPollingForAutonomous();
    } else {
      // FROTA: WebSocket como principal + polling como fallback (AGUARDANDO_VALIDACAO_MOTORISTA)
      debugPrint('🚛 [RefuelingWaitingPage] FROTA - configurando WebSocket + polling fallback');
      _setupFleetWebSocketListener();
      _setupNotificationListeners(); // Novos eventos: cancelled, error, validated_by_station
      
      // Se já temos o refuelingId, carregar dados imediatamente
      if (widget.refuelingId.isNotEmpty) {
        debugPrint('🚀 [RefuelingWaitingPage] refuelingId presente, carregando dados imediatamente: ${widget.refuelingId}');
        _loadRefuelingData(widget.refuelingId);
        // Verificar também se já está CONCLUIDO (caso seja autônomo mal detectado)
        _checkIfAlreadyCompleted(widget.refuelingId);
        // CORREÇÃO: Iniciar polling para detectar CANCELADO e outros status
        debugPrint('🔄 [RefuelingWaitingPage] FROTA (com ID) - iniciando polling para detectar mudanças de status...');
        _startPolling();
      } else if (widget.refuelingCode.isNotEmpty) {
         // Se tem código, verificar status pelo código
         _checkIfAlreadyCompletedByCode(widget.refuelingCode);
         
        // Polling fallback: verifica status AGUARDANDO_VALIDACAO_MOTORISTA
        debugPrint('🔄 [RefuelingWaitingPage] FROTA - iniciando polling fallback...');
        _startPolling();
      } else {
         debugPrint('🔄 [RefuelingWaitingPage] FROTA - iniciando polling fallback...');
         _startPolling();
      }
    }
  }

  /// Verificar se abastecimento já está concluído (fallback de segurança)
  Future<void> _checkIfAlreadyCompleted(String refuelingId) async {
      try {
        final response = await _apiService.getRefuelingStatus(refuelingId);
        if (response['success'] == true && response['data'] != null) {
            final data = response['data'];
            if (data['status'] == 'CONCLUIDO') {
                debugPrint('✅ [RefuelingWaitingPage] Detectado status CONCLUIDO na inicialização! Navegando...');
                _navigateToSuccess(data);
            }
        }
      } catch (e) {
          debugPrint('⚠️ Erro ao verificar status inicial: $e');
      }
  }

  Future<void> _checkIfAlreadyCompletedByCode(String code) async {
      try {
        final response = await _apiService.getRefuelingByCode(code);
        if (response['success'] == true && response['data'] != null) {
            final data = response['data'];
            if (data['status'] == 'CONCLUIDO') {
                debugPrint('✅ [RefuelingWaitingPage] Detectado status CONCLUIDO por código! Navegando...');
                _navigateToSuccess(data);
            }
        }
      } catch (e) {
          debugPrint('⚠️ Erro ao verificar status por código: $e');
      }
  }

  void _navigateToSuccess(Map<String, dynamic> data) {
      if (!mounted) return;
      _pollingService.stopPolling();
      WebSocketService().disconnect();
      
      // Helper para parsear valores
      double parseDouble(dynamic value) {
        if (value == null) return 0.0;
        if (value is num) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
        return 0.0;
      }

      context.go('/autonomous-success', extra: {
        'refuelingCode': widget.refuelingCode,
        'status': data['status']?.toString() ?? 'CONCLUIDO',
        'totalValue': parseDouble(data['total_amount']),
        'quantityLiters': parseDouble(data['quantity_liters']),
        'pricePerLiter': parseDouble(data['unit_price']),
        'pumpPrice': parseDouble(data['pump_price']),
        'savings': parseDouble(data['savings']),
        'stationName': data['station_name']?.toString() ?? widget.stationData?['nome'] ?? 'Posto',
        'vehiclePlate': data['vehicle_plate']?.toString() ?? widget.vehicleData?['placa'] ?? '',
        'fuelType': data['fuel_type']?.toString() ?? 'Combustível',
        'timestamp': DateTime.now().toIso8601String(),
      });
  }
  
  /// Salvar estado de validação pendente para recuperar após login
  Future<void> _savePendingValidationState() async {
    if (widget.refuelingId.isNotEmpty && widget.refuelingCode.isNotEmpty) {
      await PendingValidationStorage.savePendingValidation(
        refuelingId: widget.refuelingId,
        refuelingCode: widget.refuelingCode,
        vehicleData: widget.vehicleData,
        stationData: widget.stationData,
      );
    }
  }

  void _setupWebSocketListener() {
    debugPrint('🔌 [RefuelingWaitingPage] Configurando listener para pagamento autônomo. Código: ${widget.refuelingCode}');
    
    WebSocketService().listenForAutonomousPaymentConfirmed((data) {
      debugPrint('💰 [RefuelingWaitingPage] Pagamento confirmado recebido via WebSocket: $data');
      
      try {
        final payload = data['data'] ?? data;
        final model = PaymentConfirmedModel.fromJson(Map<String, dynamic>.from(payload));
        
        if (model.refuelingCode == widget.refuelingCode) {
          debugPrint('✅ [RefuelingWaitingPage] Código confirmado! Navegando para sucesso...');
          
          if (mounted) {
            _pollingService.stopPolling();
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AutonomousPaymentSuccessPage(data: model),
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('❌ [RefuelingWaitingPage] Erro ao processar evento de pagamento: $e');
      }
    });
  }

  /// Configurar WebSocket listener para FROTA (refueling:pending_validation)
  void _setupFleetWebSocketListener() {
    debugPrint('🔌 [RefuelingWaitingPage] Configurando listener para validação de FROTA. Código: ${widget.refuelingCode}');
    
    WebSocketService().listenForFleetPendingValidation((data) {
      debugPrint('📋 [RefuelingWaitingPage] Validação pendente recebida via WebSocket: $data');
      
      try {
        // O evento pode vir com refueling_code ou refuelingCode
        final eventCode = data['refueling_code']?.toString() ?? data['refuelingCode']?.toString() ?? '';
        
        if (eventCode == widget.refuelingCode) {
          debugPrint('✅ [RefuelingWaitingPage] Código de FROTA confirmado! Carregando dados...');
          
          if (mounted) {
            _pollingService.stopPolling();
            
            // Obter refueling_id do evento
            final refuelingId = data['refueling_id']?.toString() ?? data['refuelingId']?.toString() ?? '';
            
            if (refuelingId.isNotEmpty) {
              _loadRefuelingData(refuelingId);
            } else {
              debugPrint('⚠️ [RefuelingWaitingPage] refueling_id não encontrado no evento, usando código');
              // Se não temos o ID, tentar buscar pelos dados já recebidos
              setState(() {
                _refuelingData = data;
                _isPolling = false;
              });
            }
          }
        }
      } catch (e) {
        debugPrint('❌ [RefuelingWaitingPage] Erro ao processar evento de validação FROTA: $e');
      }
    });
  }

  /// Configurar listeners para eventos de notificação (cancelamento, erro, validação pelo posto)
  /// Deve ser chamado para TODOS os fluxos (autônomo e frota)
  void _setupNotificationListeners() {
    debugPrint('🔔 [RefuelingWaitingPage] Configurando listeners de notificação para código: ${widget.refuelingCode}');
    
    // ❌ Listener para abastecimento cancelado pelo posto
    WebSocketService().listenForRefuelingCancelled((data) {
      debugPrint('❌ [RefuelingWaitingPage] Evento refueling:cancelled recebido: $data');
      
      try {
        final eventCode = data['refueling_code']?.toString() ?? data['refuelingCode']?.toString() ?? '';
        
        if (eventCode == widget.refuelingCode && mounted) {
          _pollingService.stopPolling();
          
          final cancellationReason = data['cancellation_reason']?.toString() ?? 'Motivo não informado';
          
          RefuelingNotificationDialogs.showCancelledModal(
            context,
            refuelingCode: widget.refuelingCode,
            cancellationReason: cancellationReason,
            onClose: () => context.go('/home'),
          );
        }
      } catch (e) {
        debugPrint('❌ [RefuelingWaitingPage] Erro ao processar refueling:cancelled: $e');
      }
    });
    
    // ⚠️ Listener para erro no abastecimento
    WebSocketService().listenForRefuelingError((data) {
      debugPrint('⚠️ [RefuelingWaitingPage] Evento refueling:error recebido: $data');
      
      try {
        final eventCode = data['refueling_code']?.toString() ?? data['refuelingCode']?.toString() ?? '';
        
        if (eventCode == widget.refuelingCode && mounted) {
          _pollingService.stopPolling();
          
          RefuelingNotificationDialogs.showErrorModal(
            context,
            onRetry: () {
              // Tentar novamente = voltar para gerar novo código
              context.go('/home');
            },
            onClose: () => context.go('/home'),
          );
        }
      } catch (e) {
        debugPrint('❌ [RefuelingWaitingPage] Erro ao processar refueling:error: $e');
      }
    });
    
    // ℹ️ Listener para validação pelo posto (em nome do motorista)
    WebSocketService().listenForRefuelingValidatedByStation((data) {
      debugPrint('ℹ️ [RefuelingWaitingPage] Evento refueling:validated_by_station recebido: $data');
      
      try {
        final eventCode = data['refueling_code']?.toString() ?? data['refuelingCode']?.toString() ?? '';
        
        if (eventCode == widget.refuelingCode && mounted) {
          _pollingService.stopPolling();
          
          final stationName = data['station_name']?.toString() ?? 'Posto desconhecido';
          final vehiclePlate = data['vehicle_plate']?.toString() ?? '';
          final totalAmount = double.tryParse(data['total_amount']?.toString() ?? '0') ?? 0.0;
          final justification = data['justification']?.toString() ?? 'Motorista ausente';
          
          RefuelingNotificationDialogs.showValidatedByStationModal(
            context,
            stationName: stationName,
            vehiclePlate: vehiclePlate,
            totalAmount: totalAmount,
            justification: justification,
            onClose: () => context.go('/home'),
          );
        }
      } catch (e) {
        debugPrint('❌ [RefuelingWaitingPage] Erro ao processar refueling:validated_by_station: $e');
      }
    });
  }

  @override
  void dispose() {
    _pollingService.stopPolling();
    _quantityController.dispose();
    _kmController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _startPolling() {
    // Se não tiver refueling_id, tentar usar o código para buscar
    if (widget.refuelingId.isEmpty && widget.refuelingCode.isEmpty) {
      return;
    }

    setState(() {
      _isPolling = true;
    });

    _pollingService.startPolling(
      refuelingId: widget.refuelingId.isNotEmpty ? widget.refuelingId : null,
      refuelingCode: widget.refuelingId.isEmpty && widget.refuelingCode.isNotEmpty 
          ? widget.refuelingCode 
          : null,
      intervalSeconds: 5, // Polling mais rápido
      // NOVO: callback multi-status para tratar diferentes cenários
      onStatusWithData: (status, refuelingId, data) async {
        debugPrint('🔔 [RefuelingWaitingPage] Status recebido: $status, id: $refuelingId');
        
        if (!mounted) return;
        
        // ⚠️ IMPORTANTE: Verificar se é código pendente (RefuelingCode) ou Refueling
        final isPendingCode = data['is_pending_code'] == true;
        final hasRefuelingId = data['id'] != null && data['id'].toString().isNotEmpty;
        
        debugPrint('🔍 [RefuelingWaitingPage] isPendingCode=$isPendingCode, hasRefuelingId=$hasRefuelingId');
        
        // 1. Se for código pendente com VALIDADO → Aguardar posto registrar dados (NÃO navegar!)
        // O usuário JÁ PASSOU pela RefuelingValidatedPage, então VALIDADO significa que
        // ele está esperando o posto registrar os dados (litros, valor, etc)
        if (isPendingCode && status == 'VALIDADO') {
          debugPrint('⏳ [RefuelingWaitingPage] Código VALIDADO - aguardando posto registrar dados...');
          // NÃO navegar de volta! Continuar polling até AGUARDANDO_VALIDACAO_MOTORISTA
          return;
        }
        
        // 2. Se for código pendente sem status final → Continuar polling
        if (isPendingCode && !hasRefuelingId) {
          if (status == 'ACTIVE') {
            debugPrint('⏳ [RefuelingWaitingPage] Código ACTIVE - aguardando posto escanear...');
            // Não para o polling, continua
            return;
          }
          if (status == 'EXPIRED' || status == 'RECUSED' || status == 'FRAUD_ATTEMPT') {
            debugPrint('❌ [RefuelingWaitingPage] Código $status - erro');
            _pollingService.stopPolling();
            await PendingValidationStorage.clearPendingValidation();
            _showStatusMessageAndNavigateHome(status);
            return;
          }
        }
        
        // 3. Se tem RefuelingId → É um Refueling real, processar status
        _pollingService.stopPolling();
        
        switch (status) {
          case 'AGUARDANDO_VALIDACAO_MOTORISTA':
            // Posto registrou dados, motorista precisa confirmar
            debugPrint('📋 Dados pendentes de validação');
            await _loadRefuelingData(refuelingId);
            break;
            
          case 'CONCLUIDO':
            // Abastecimento concluído
            debugPrint('✅ Abastecimento CONCLUIDO');
            await PendingValidationStorage.clearPendingValidation();
            _navigateToSuccessFromPolling(data);
            break;
            
          case 'VALIDADO':
            // VALIDADO de Refueling (motorista já validou, aguardando NF-e)
            // Isso é diferente de VALIDADO do código!
            debugPrint('✅ Abastecimento VALIDADO pelo motorista');
            await PendingValidationStorage.clearPendingValidation();
            _navigateToSuccessFromPolling(data);
            break;
            
          case 'CONTESTADO':
          case 'CANCELADO':
          case 'RECUSED':
            // Abastecimento contestado/cancelado/recusado pelo posto
            debugPrint('❌ Abastecimento $status');
            await PendingValidationStorage.clearPendingValidation();
            _showStatusMessageAndNavigateHome(status);
            break;
            
          default:
            debugPrint('⚠️ Status não tratado: $status');
        }
      },
    );
  }
  
  /// Navegar para tela de sucesso quando polling detecta CONCLUIDO
  void _navigateToSuccessFromPolling(Map<String, dynamic> data) {
    if (!mounted) return;
    
    // Helper para parsear valores
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Verificar se é autônomo para rota correta
        if (widget.isAutonomous) {
          context.go('/autonomous-success', extra: {
            'refuelingCode': widget.refuelingCode,
            'status': 'CONCLUIDO',
            'totalValue': parseDouble(data['total_amount']),
            'quantityLiters': parseDouble(data['quantity_liters']),
            'pricePerLiter': parseDouble(data['unit_price']),
            'savings': parseDouble(data['savings']),
            'stationName': data['station_name']?.toString() ?? widget.stationData?['nome'] ?? 'Posto',
            'vehiclePlate': data['vehicle_plate']?.toString() ?? widget.vehicleData?['placa'] ?? '',
            'timestamp': DateTime.now().toIso8601String(),
          });
        } else {
          // Frota: mostrar sucesso simples e voltar para home
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
              title: const Text('Abastecimento Concluído'),
              content: const Text(
                'O posto validou e finalizou este abastecimento diretamente.\n\n'
                'Nenhuma ação adicional é necessária.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    });
  }
  
  /// Mostrar mensagem de status e navegar para home
  void _showStatusMessageAndNavigateHome(String status) {
    if (!mounted) return;
    
    String title = status == 'CONTESTADO' ? 'Abastecimento Contestado' : 'Abastecimento Cancelado';
    String message = status == 'CONTESTADO' 
        ? 'Este abastecimento foi contestado e não pode mais ser validado.'
        : 'Este abastecimento foi cancelado.';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          status == 'CONTESTADO' ? Icons.warning_amber : Icons.cancel,
          color: status == 'CONTESTADO' ? Colors.orange : Colors.red,
          size: 48,
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/home');
            },
            child: const Text('Voltar para Início'),
          ),
        ],
      ),
    );
  }

  /// Polling fallback para AUTÔNOMO - verifica status CONCLUIDO
  /// Autônomo não passa por AGUARDANDO_VALIDACAO_MOTORISTA, vai direto para CONCLUIDO
  void _startPollingForAutonomous() {
    if (widget.refuelingCode.isEmpty) {
      debugPrint('❌ [POLLING AUTÔNOMO] Código de abastecimento vazio');
      return;
    }

    setState(() {
      _isPolling = true;
    });

    debugPrint('🔄 [POLLING AUTÔNOMO] Iniciando polling fallback para código: ${widget.refuelingCode}');

    _pollingService.startPollingForStatus(
      refuelingCode: widget.refuelingCode,
      targetStatus: 'CONCLUIDO',
      intervalSeconds: 5, // Polling mais rápido
      onStatusReached: (data) async {
        debugPrint('✅ [POLLING AUTÔNOMO] Status CONCLUIDO detectado! Navegando para sucesso...');
        if (mounted) {
          _pollingService.stopPolling();
          WebSocketService().disconnect();
          
          // Helper para parsear valores que podem ser String ou num
          double parseDouble(dynamic value) {
            if (value == null) return 0.0;
            if (value is num) return value.toDouble();
            if (value is String) return double.tryParse(value) ?? 0.0;
            return 0.0;
          }
          
          // Usar addPostFrameCallback para garantir navegação no main thread
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              debugPrint('🚀 [RefuelingWaitingPage AUTÔNOMO] Executando navegação para /autonomous-success...');
              // Navegar para tela de sucesso usando GoRouter
              context.go('/autonomous-success', extra: {
                'refuelingCode': widget.refuelingCode,
                'status': data['status']?.toString() ?? 'CONCLUIDO',
                'totalValue': parseDouble(data['total_amount']),
                'quantityLiters': parseDouble(data['quantity_liters']),
                'pricePerLiter': parseDouble(data['unit_price']),
                'pumpPrice': parseDouble(data['pump_price']),
                'savings': parseDouble(data['savings']),
                'stationName': data['station_name']?.toString() ?? widget.stationData?['nome'] ?? 'Posto',
                'vehiclePlate': data['vehicle_plate']?.toString() ?? widget.vehicleData?['placa'] ?? '',
                'fuelType': data['fuel_type']?.toString() ?? 'Combustível',
                'timestamp': DateTime.now().toIso8601String(),
              });
            } else {
              debugPrint('⚠️ [RefuelingWaitingPage AUTÔNOMO] Widget não está mais mounted, navegação cancelada');
            }
          });
        }
      },
    );
  }

  /// Polling de monitoramento: verifica se status muda enquanto
  /// motorista está na tela de validação (ex: posto valida diretamente)
  void _startMonitoringPolling(String refuelingId) {
    debugPrint('🔄 [MONITORING] Iniciando polling de monitoramento para: $refuelingId');
    
    _pollingService.startPolling(
      refuelingId: refuelingId,
      intervalSeconds: 3, // Polling rápido: posto pode validar a qualquer momento
      onStatusWithData: (status, id, data) async {
        debugPrint('🔔 [MONITORING] Status detectado: $status');
        
        if (!mounted) return;
        
        // Ignorar se ainda está aguardando validação do motorista
        if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
          debugPrint('⏳ [MONITORING] Ainda aguardando validação do motorista, continuando...');
          return; // Continua monitorando
        }
        
        // Status mudou! Parar polling e reagir
        _pollingService.stopPolling();
        
        switch (status) {
          case 'VALIDADO':
          case 'CONCLUIDO':
            // Posto validou ou concluiu diretamente!
            debugPrint('✅ [MONITORING] Posto validou/concluiu diretamente (status: $status)! Navegando para sucesso...');
            await PendingValidationStorage.clearPendingValidation();
            _navigateToSuccessFromPolling(data);
            break;
            
          case 'CONTESTADO':
          case 'CANCELADO':
            debugPrint('⚠️ [MONITORING] Abastecimento $status');
            await PendingValidationStorage.clearPendingValidation();
            _showStatusMessageAndNavigateHome(status);
            break;
            
          default:
            debugPrint('❓ [MONITORING] Status inesperado: $status');
        }
      },
    );
  }

  Future<void> _loadRefuelingData(String refuelingId) async {
    setState(() {
      _isLoading = true;
      _isPolling = false;
    });

    try {
      final response = await _apiService.getPendingValidation(refuelingId);
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        
        setState(() {
          _refuelingData = data;
          
          // Atualizar refuelingId se ainda não tínhamos
          if (_currentRefuelingId == null || _currentRefuelingId!.isEmpty) {
            if (data['id'] != null) {
              _currentRefuelingId = data['id'].toString();
              debugPrint('✅ RefuelingId atualizado: $_currentRefuelingId');
            }
          }
          
          // Preencher controllers com dados registrados (para edição se contestar)
          if (data['quantity_liters'] != null) {
            _quantityController.text = data['quantity_liters'].toString();
          }
          if (data['odometer_reading'] != null) {
            _kmController.text = data['odometer_reading'].toString();
          }
          
          _isLoading = false;
        });
        
        // NOVO: Iniciar polling de monitoramento para detectar
        // se posto valida enquanto motorista está na tela
        final refId = _currentRefuelingId ?? refuelingId;
        _startMonitoringPolling(refId);
      } else {
        throw Exception('Dados não encontrados');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Se erro 404, o abastecimento não está mais pendente - limpar estado local
      final errorMessage = e.toString();
      if (errorMessage.contains('404') || errorMessage.contains('não encontrados')) {
        debugPrint('⚠️ Abastecimento não está mais pendente de validação. Limpando estado local.');
        
        // Limpar estado local
        await PendingValidationStorage.clearPendingValidation();
        
        if (mounted) {
          // Mostrar mensagem informativa e redirecionar
          _pollingService.stopPolling();
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                icon: const Icon(Icons.info_outline, color: Colors.blue, size: 48),
                title: const Text('Validação Não Necessária'),
                content: const Text(
                  'Este abastecimento não requer mais sua validação.\n\n'
                  'Pode ter sido cancelado, já validado ou está em outro status.',
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.go('/home');
                    },
                    child: const Text('Voltar para Início'),
                  ),
                ],
              );
            },
          );
        }
        return;
      }
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao carregar dados: $e',
        );
      }
    }
  }
  
  /// Obter refuelingId atual (do widget ou dos dados carregados)
  String _getRefuelingId() {
    if (_currentRefuelingId != null && _currentRefuelingId!.isNotEmpty) {
      return _currentRefuelingId!;
    }
    if (widget.refuelingId.isNotEmpty) {
      return widget.refuelingId;
    }
    if (_refuelingData != null && _refuelingData!['id'] != null) {
      return _refuelingData!['id'].toString();
    }
    return '';
  }

  /// Mostrar modal de confirmação antes de confirmar
  void _showConfirmValidation() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green[700], size: 28),
              const SizedBox(width: 8),
              const Text('Confirmar Abastecimento?'),
            ],
          ),
          content: _refuelingData != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Você confirma os seguintes dados?'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildConfirmInfoRow('Quantidade', '${_refuelingData!['quantity_liters'] ?? '0'} L'),
                          _buildConfirmInfoRow('Valor Total', 'R\$ ${_refuelingData!['total_amount'] ?? '0,00'}'),
                        ],
                      ),
                    ),
                  ],
                )
              : const Text('Você confirma que os dados do abastecimento estão corretos?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _confirmValidation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sim, Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _confirmValidation() async {
    final refuelingId = _getRefuelingId();
    
    debugPrint('🚀 [VALIDATION] Iniciando validação para refuelingId: $refuelingId');
    
    if (refuelingId.isEmpty) {
      ErrorDialog.show(
        context,
        title: 'Erro',
        message: 'ID do abastecimento não encontrado',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      debugPrint('🔐 [VALIDATION] Verificando permissão de localização...');
      // Verificar e solicitar permissão de localização
      bool hasPermission = await _locationService.checkPermission();
      debugPrint('🔐 [VALIDATION] Permissão atual: $hasPermission');
      
      if (!hasPermission) {
        debugPrint('🔐 [VALIDATION] Solicitando permissão...');
        hasPermission = await _locationService.requestPermission();
        debugPrint('🔐 [VALIDATION] Permissão após solicitação: $hasPermission');
        
        if (!hasPermission) {
          setState(() {
            _isSubmitting = false;
          });
          
          if (mounted) {
            ErrorDialog.show(
              context,
              title: 'Permissão Necessária',
              message: 'É necessário permitir o acesso à localização para validar o abastecimento.\n\nPor favor, habilite nas configurações do dispositivo.',
            );
          }
          return;
        }
      }

      // Obter localização atual
      debugPrint('📍 [VALIDATION] Obtendo localização para validação...');
      
      // Adicionar timeout para evitar travamento
      final locationData = await _locationService.getCurrentLocation()
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              debugPrint('⏱️ [VALIDATION] Timeout ao obter localização (15s)');
              return null;
            },
          );
      
      if (locationData == null) {
        debugPrint('❌ [VALIDATION] Localização não obtida');
        setState(() {
          _isSubmitting = false;
        });
        
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Erro de Localização',
            message: 'Não foi possível obter a localização atual. Verifique se o GPS está habilitado e tente novamente.',
          );
        }
        return;
      }
      
      debugPrint('✅ [VALIDATION] Localização obtida: ${locationData['latitude']}, ${locationData['longitude']}');

      // Obter nome do dispositivo
      final deviceName = _locationService.getDeviceName();
      debugPrint('📱 [VALIDATION] Device: $deviceName');

      // Chamar API de validação
      debugPrint('📤 [VALIDATION] Enviando validação para API...');
      debugPrint('📤 [VALIDATION] RefuelingId: $refuelingId');
      debugPrint('📤 [VALIDATION] Latitude: ${locationData['latitude']}');
      debugPrint('📤 [VALIDATION] Longitude: ${locationData['longitude']}');
      
      final response = await _apiService.validateRefueling(
        refuelingId: refuelingId,
        device: deviceName,
        latitude: locationData['latitude'] as double,
        longitude: locationData['longitude'] as double,
        address: locationData['address'] as String?,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('⏱️ [VALIDATION] Timeout na chamada da API (30s)');
          return {
            'success': false,
            'error': 'Timeout ao validar abastecimento. Tente novamente.',
          };
        },
      );
      
      debugPrint('📥 [VALIDATION] Resposta da API: ${response.toString()}');
      
      if (response['success'] == true) {
        setState(() {
          _isSubmitting = false;
        });
        
        // Limpar estado de validação pendente após sucesso
        await PendingValidationStorage.clearPendingValidation();
        
        if (mounted) {
          // Parar polling antes de mostrar modal
          _pollingService.stopPolling();
          
          SuccessDialog.show(
            context,
            title: 'Validação Confirmada',
            message: 'Dados do abastecimento confirmados com sucesso!',
            onPressed: () {
              Navigator.of(context).pop();
              // Voltar para home
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  context.go('/home');
                }
              });
            },
          );
        }
      } else {
        throw Exception(response['error'] ?? 'Erro ao confirmar validação');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao confirmar validação: $e',
        );
      }
    }
  }
  
  /// Mostrar modal de confirmação antes de rejeitar
  void _showRejectConfirmation() {
    final TextEditingController reasonController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              const SizedBox(width: 8),
              const Text('Rejeitar Abastecimento?'),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informe o motivo da rejeição:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Ex: Valor incorreto, quilometragem errada...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O motivo é obrigatório';
                    }
                    if (value.trim().length < 5) {
                      return 'Informe um motivo mais detalhado';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final reason = reasonController.text.trim();
                  Navigator.of(dialogContext).pop();
                  _contestValidation(reason);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar Rejeição'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _contestValidation(String reason) async {
    final refuelingId = _getRefuelingId();
    
    if (refuelingId.isEmpty) {
      ErrorDialog.show(
        context,
        title: 'Erro',
        message: 'ID do abastecimento não encontrado',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Verificar e solicitar permissão de localização
      bool hasPermission = await _locationService.checkPermission();
      if (!hasPermission) {
        hasPermission = await _locationService.requestPermission();
        if (!hasPermission) {
          setState(() {
            _isSubmitting = false;
          });
          
          if (mounted) {
            ErrorDialog.show(
              context,
              title: 'Permissão Necessária',
              message: 'É necessário permitir o acesso à localização para rejeitar o abastecimento.\n\nPor favor, habilite nas configurações do dispositivo.',
            );
          }
          return;
        }
      }

      // Obter localização atual
      debugPrint('📍 Obtendo localização para contestação...');
      final locationData = await _locationService.getCurrentLocation();
      
      if (locationData == null) {
        setState(() {
          _isSubmitting = false;
        });
        
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Erro de Localização',
            message: 'Não foi possível obter a localização atual. Verifique se o GPS está habilitado e tente novamente.',
          );
        }
        return;
      }

      // Obter nome do dispositivo
      final deviceName = _locationService.getDeviceName();

      // Chamar API de contestação
      debugPrint('⚠️ Enviando contestação com motivo: $reason');
      debugPrint('📍 Localização: ${locationData['latitude']}, ${locationData['longitude']}');
      
      final response = await _apiService.contestRefueling(
        refuelingId: refuelingId,
        reason: reason,
        device: deviceName,
        latitude: locationData['latitude'] as double,
        longitude: locationData['longitude'] as double,
        address: locationData['address'] as String?,
      );
      
      if (response['success'] == true) {
        setState(() {
          _isSubmitting = false;
        });
        
        // Limpar estado de validação pendente após sucesso
        await PendingValidationStorage.clearPendingValidation();
        
        if (mounted) {
          // Parar polling antes de mostrar modal
          _pollingService.stopPolling();
          
          SuccessDialog.show(
            context,
            title: 'Contestação Enviada',
            message: 'Sua contestação foi registrada e será analisada pelo posto.',
            onPressed: () {
              Navigator.of(context).pop();
              // Voltar para home
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  context.go('/home');
                }
              });
            },
          );
        }
      } else {
        throw Exception(response['error'] ?? 'Erro ao contestar abastecimento');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro ao contestar abastecimento: $e',
        );
      }
    }
  }

  void _goToHome() {
    _pollingService.stopPolling();
    context.go('/home');
  }

  /// Método chamado ao pressionar o botão voltar
  Future<void> _onBackPressed() async {
    // Parar polling antes de mostrar o diálogo
    _pollingService.stopPolling();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Validação'),
        content: const Text(
          'Tem certeza que deseja sair desta tela?\n\n'
          'Você poderá retornar para validar este abastecimento através da tela de abastecimentos pendentes.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Reiniciar polling se o usuário cancelar o diálogo
              if (widget.refuelingId.isNotEmpty || widget.refuelingCode.isNotEmpty) {
                _startPolling();
              }
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Parar polling definitivamente
      _pollingService.stopPolling();

      // Navegar de volta para home
      context.go('/home');
    } else if (mounted) {
      // Se não confirmou, reiniciar polling
      if (widget.refuelingId.isNotEmpty || widget.refuelingCode.isNotEmpty) {
        _startPolling();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _refuelingData != null && !_isLoading;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(hasData ? 'Dados Recebidos' : 'Aguardando Registro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _onBackPressed(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Corpo principal
            Expanded(
              child: hasData 
                ? _buildDataReceivedBody()
                : _buildWaitingStateBody(),
            ),
            
            // Footer com botões
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: hasData
                    ? Row(
                        children: [
                          // Botão Rejeitar
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isSubmitting ? null : _showRejectConfirmation,
                              icon: const Icon(Icons.close),
                              label: const Text('Rejeitar'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.red[300]!),
                                foregroundColor: Colors.red[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Botão Confirmar
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _showConfirmValidation,
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.check),
                              label: Text(_isSubmitting ? 'Confirmando...' : 'Confirmar'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _goToHome,
                          icon: const Icon(Icons.home),
                          label: const Text('Voltar para Início'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// UI para estado "Dados Recebidos" (posto já registrou)
  Widget _buildDataReceivedBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Ícone checkmark verde
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 56,
              color: Colors.green.shade600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Título
          Text(
            'Dados do Abastecimento Recebidos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.green.shade700,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Subtítulo
          Text(
            'Revise os dados registrados pelo posto\ne confirme ou rejeite as informações.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Card com dados registrados pelo posto (DESTAQUE VERDE)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade500, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Row(
                  children: [
                    const Icon(Icons.checklist, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'Dados Registrados pelo Posto',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                // Grid 2x2 para dados principais
                Row(
                  children: [
                    Expanded(
                      child: _buildPostoGridItem(
                        'Quantidade',
                        _refuelingData!['quantity_liters'] != null
                            ? '${double.parse(_refuelingData!['quantity_liters'].toString()).toStringAsFixed(2)} L'
                            : 'N/A',
                        isBig: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPostoGridItem(
                        'Valor Total',
                        _refuelingData!['total_amount'] != null
                            ? 'R\$ ${double.parse(_refuelingData!['total_amount'].toString()).toStringAsFixed(2)}'
                            : 'N/A',
                        isBig: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildPostoGridItem(
                        'Preço/Litro',
                        _refuelingData!['unit_price'] != null
                            ? 'R\$ ${double.parse(_refuelingData!['unit_price'].toString()).toStringAsFixed(2)}'
                            : 'N/A',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPostoGridItem(
                        'Quilometragem',
                        _refuelingData!['odometer_reading'] != null
                            ? '${_formatKm(_refuelingData!['odometer_reading'])} km'
                            : 'N/A',
                      ),
                    ),
                  ],
                ),
                // Atendente (se disponível)
                if (_refuelingData!['attendant_name'] != null) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Atendente: ${_refuelingData!['attendant_name']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Card com dados do motorista para comparação
          if (widget.driverEstimate != null) _buildDriverEstimateCard(),

          const SizedBox(height: 16),
                    
          // SEGUNDO: Card com informações básicas (branco)
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Informações do Abastecimento',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.vehicleData != null)
                    _buildInfoRow(
                      'Veículo',
                      widget.vehicleData!['placa'] ?? 'N/A',
                      Icons.directions_car,
                    ),
                  if (widget.stationData != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Posto',
                      widget.stationData!['nome'] ?? 'N/A',
                      Icons.local_gas_station,
                    ),
                  ],
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Código',
                    widget.refuelingCode,
                    Icons.qr_code,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Indicador de loading ou polling
          if (_isLoading)
            const CircularProgressIndicator()
          else if (_isPolling && _refuelingData == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Verificando status...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Item do grid de dados do posto (fundo translúcido, texto branco)
  Widget _buildPostoGridItem(String label, String value, {bool isBig = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isBig ? 20 : 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Formata quilometragem: converte para inteiro (sem decimais)
  String _formatKm(dynamic value) {
    if (value == null) return '0';
    if (value is int) return value.toString();
    if (value is double) return value.toInt().toString();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed?.toInt().toString() ?? value;
    }
    return value.toString();
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// UI para estado "Aguardando Registro" (sem dados do posto ainda)
  /// Segue mockup: MOCK-aguardando-registro.html
  Widget _buildWaitingStateBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Ícone animado (relógio)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time,
              size: 56,
              color: Colors.blue.shade600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Título
          Text(
            'Registro em Andamento',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blue.shade700,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Subtítulo
          Text(
            'Informe os dados abaixo ao frentista\npara registro no sistema do posto.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Card principal (Volume e KM)
          if (widget.driverEstimate != null) _buildDriverEstimateCard(),
          
          const SizedBox(height: 16),
          
          // Instruction box (verde)
          _buildInstructionBox(),
          
          const SizedBox(height: 16),
          
          // CNPJ Card (amarelo)
          _buildCnpjCard(),
          
          const SizedBox(height: 16),
          
          // Info Card (Veículo, Posto, Código)
          _buildInfoCard(),
          
          const SizedBox(height: 12),
          
          // Polling indicator
          _buildPollingIndicator(),
        ],
      ),
    );
  }

  /// Caixa de instrução verde
  Widget _buildInstructionBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.green.shade700, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importante',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Informe estes dados ao caixa/frentista para que ele registre o abastecimento no sistema do posto.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Info card com Veículo, Posto, Código
  Widget _buildInfoCard() {
    final plate = widget.vehicleData?['placa'] ?? widget.vehicleData?['plate'] ?? '---';
    final stationName = widget.stationData?['nome'] ?? widget.stationData?['name'] ?? 'Posto';
    final code = widget.refuelingCode.isNotEmpty ? widget.refuelingCode : '---';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 16),
              const SizedBox(width: 8),
              Text(
                'Informações do Abastecimento',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          
          // Veículo
          _buildInfoCardRow('Veículo', plate, isPlate: true),
          const SizedBox(height: 10),
          
          // Posto
          _buildInfoCardRow('Posto', stationName),
          const SizedBox(height: 10),
          
          // Código
          _buildInfoCardRow('Código', code, isCode: true),
        ],
      ),
    );
  }

  Widget _buildInfoCardRow(String label, String value, {bool isPlate = false, bool isCode = false}) {
    Widget valueWidget;
    
    if (isPlate) {
      valueWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'monospace',
          ),
        ),
      );
    } else if (isCode) {
      valueWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: Colors.grey[800],
          ),
        ),
      );
    } else {
      valueWidget = Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        valueWidget,
      ],
    );
  }

  /// Polling indicator (roxo)
  Widget _buildPollingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
            height: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple.shade600,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Aguardando confirmação do posto...',
            style: TextStyle(
              fontSize: 11,
              color: Colors.purple.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// Card com dados digitados pelo motorista (Volume e KM)
  /// Baseado no mockup MOCK-aguardando-registro.html
  Widget _buildDriverEstimateCard() {
    final liters = widget.driverEstimate?['liters'] ?? 0.0;
    
    // Tentar obter KM do driverEstimate, vehicleData, ou storage (_kmVeiculo)
    String kmDisplay = '---';
    
    if (widget.driverEstimate?['km'] != null) {
      kmDisplay = _formatKm(widget.driverEstimate!['km']);
    } else if (widget.vehicleData?['km'] != null) {
      kmDisplay = _formatKm(widget.vehicleData!['km']);
    } else if (widget.vehicleData?['mileage'] != null) {
      kmDisplay = _formatKm(widget.vehicleData!['mileage']);
    } else if (_kmVeiculo > 0) {
      // Fallback: usar KM carregado do storage
      kmDisplay = _formatKm(_kmVeiculo);
    }
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade400, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.local_gas_station, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Informe ao Posto',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Volume
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'VOLUME',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${liters is double ? liters.toStringAsFixed(2).replaceAll('.', ',') : liters} L',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          
          Divider(color: Colors.blue.shade200, height: 24),
          
          // KM
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUILOMETRAGEM',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$kmDisplay km',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          
          // Código de Abastecimento
          if (widget.refuelingCode.isNotEmpty) ...[
            Divider(color: Colors.blue.shade200, height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CÓDIGO',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SelectableText(
                  widget.refuelingCode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Card com CNPJ da frota para emissão de Nota Fiscal
  Widget _buildCnpjCard() {
    // Tentar obter CNPJ e nome da empresa do vehicleData ou do storage
    String cnpj = '---';
    String empresaNome = '';
    
    // O CNPJ pode vir do vehicleData ou do storage (_cnpjEmpresa)
    if (widget.vehicleData?['empresa_cnpj'] != null) {
      cnpj = _formatCnpj(widget.vehicleData!['empresa_cnpj'].toString());
      empresaNome = widget.vehicleData?['empresa_nome'] ?? '';
    } else if (widget.vehicleData?['cnpj'] != null) {
      cnpj = _formatCnpj(widget.vehicleData!['cnpj'].toString());
      empresaNome = widget.vehicleData?['empresa'] ?? '';
    } else if (_cnpjEmpresa.isNotEmpty) {
      // Fallback: usar CNPJ carregado do storage (user_data)
      cnpj = _formatCnpj(_cnpjEmpresa);
      empresaNome = _nomeEmpresa;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade600),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.orange.shade700, size: 16),
              const SizedBox(width: 8),
              Text(
                'CNPJ PARA NOTA FISCAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // CNPJ
          Text(
            cnpj,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
              fontFamily: 'monospace',
            ),
          ),
          
          // Nome da empresa
          if (empresaNome.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              empresaNome,
              style: TextStyle(
                fontSize: 12,
                color: Colors.brown.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Formata CNPJ: 12345678000190 -> 12.345.678/0001-90
  String _formatCnpj(String cnpj) {
    final cleaned = cnpj.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length != 14) return cnpj; // retorna original se inválido
    return '${cleaned.substring(0, 2)}.${cleaned.substring(2, 5)}.${cleaned.substring(5, 8)}/${cleaned.substring(8, 12)}-${cleaned.substring(12, 14)}';
  }
}

