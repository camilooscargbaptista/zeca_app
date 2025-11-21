import 'dart:async';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// Serviço para fazer polling do status do abastecimento
class RefuelingPollingService {
  static final RefuelingPollingService _instance = RefuelingPollingService._internal();
  factory RefuelingPollingService() => _instance;
  RefuelingPollingService._internal();

  final ApiService _apiService = ApiService();
  Timer? _pollingTimer;
  String? _currentRefuelingId;
  String? _currentRefuelingCode; // Código de abastecimento (para buscar refueling)
  Function(String)? _onStatusChanged;
  bool _isPolling = false;

  /// Iniciar polling para um refueling_id ou código de abastecimento
  /// 
  /// [refuelingId] - ID do abastecimento para monitorar (opcional)
  /// [refuelingCode] - Código de abastecimento para buscar refueling (opcional)
  /// [onStatusChanged] - Callback chamado quando o status muda
  /// [intervalSeconds] - Intervalo entre verificações (padrão: 15 segundos)
  void startPolling({
    String? refuelingId,
    String? refuelingCode,
    Function(String)? onStatusChanged,
    int intervalSeconds = 15,
  }) {
    if (refuelingId == null && refuelingCode == null) {
      debugPrint('❌ É necessário fornecer refuelingId ou refuelingCode');
      return;
    }

    if (_isPolling && _currentRefuelingId == refuelingId && _currentRefuelingCode == refuelingCode) {
      // Já está fazendo polling para este ID/código
      return;
    }

    stopPolling();

    _currentRefuelingId = refuelingId;
    _currentRefuelingCode = refuelingCode;
    _onStatusChanged = onStatusChanged;
    _isPolling = true;

    // Verificação imediata
    _checkStatus();

    // Configurar polling periódico
    _pollingTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _checkStatus(),
    );

    debugPrint('🔄 Polling iniciado para refueling_id: $refuelingId, code: $refuelingCode (intervalo: ${intervalSeconds}s)');
  }

  /// Parar polling
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _currentRefuelingId = null;
    _currentRefuelingCode = null;
    _onStatusChanged = null;
    _isPolling = false;
    debugPrint('⏹️ Polling parado');
  }

  /// Verificar status atual
  Future<void> _checkStatus() async {
    if (_currentRefuelingId == null && _currentRefuelingCode == null) return;

    try {
      String? refuelingIdToCheck = _currentRefuelingId;
      
      // SOLUÇÃO 2: Se não temos refueling_id, buscar pelo código
      if (refuelingIdToCheck == null && _currentRefuelingCode != null) {
        debugPrint('🔍 Buscando refueling pelo código: $_currentRefuelingCode');
        try {
          final codeResponse = await _apiService.getRefuelingByCode(_currentRefuelingCode!);
          
          if (codeResponse['success'] == true && codeResponse['data'] != null) {
            final refuelingData = codeResponse['data'] as Map<String, dynamic>;
            refuelingIdToCheck = refuelingData['id'] as String?;
            
            if (refuelingIdToCheck != null) {
              debugPrint('✅ Refueling encontrado pelo código. ID: $refuelingIdToCheck');
              _currentRefuelingId = refuelingIdToCheck; // Atualizar para próximas verificações
              
              // Verificar status diretamente dos dados retornados
              final status = refuelingData['status'] as String?;
              if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || 
                  status == 'aguardando_validacao_motorista') {
                _onStatusChanged?.call(refuelingIdToCheck);
                return; // Já encontrou, não precisa verificar novamente
              }
            } else {
              debugPrint('⚠️ Refueling não encontrado pelo código (ainda não foi registrado pelo posto)');
              return; // Ainda não foi registrado, continuar tentando
            }
          } else {
            debugPrint('⚠️ Erro ao buscar refueling por código: ${codeResponse['error']}');
            return; // Erro ao buscar, continuar tentando na próxima iteração
          }
        } catch (e) {
          debugPrint('❌ Erro ao buscar refueling por código: $e');
          return; // Erro, continuar tentando
        }
      }

      if (refuelingIdToCheck == null) return;

      // SOLUÇÃO 1: Se já temos refueling_id, usar diretamente
      debugPrint('🔍 Verificando status do refueling: $refuelingIdToCheck');
      final response = await _apiService.getRefuelingStatus(refuelingIdToCheck);

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        final status = data['status'] as String?;
        
        if (status != null) {
          // Verificar se status mudou para aguardando validação
          if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || 
              status == 'aguardando_validacao_motorista') {
            // Atualizar refueling_id se ainda não tínhamos
            if (_currentRefuelingId == null && data['id'] != null) {
              _currentRefuelingId = data['id'] as String;
            }
            
            _onStatusChanged?.call(refuelingIdToCheck);
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao verificar status: $e');
      // Não parar polling em caso de erro, continuar tentando
    }
  }

  /// Verificar se há dados pendentes de validação
  /// 
  /// Retorna os dados se houver pendência, null caso contrário
  Future<Map<String, dynamic>?> checkPendingValidation(String refuelingId) async {
    try {
      // TODO: Implementar endpoint real quando backend estiver pronto
      // GET /refueling/{id}/pending-validation
      
      // Por enquanto, verificar status e retornar dados se status for AGUARDANDO_VALIDACAO_MOTORISTA
      final response = await _apiService.getRefuelingStatus(refuelingId);
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        final status = data['status'] as String?;
        
        if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || 
            status == 'aguardando_validacao_motorista') {
          return data;
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao verificar validação pendente: $e');
      return null;
    }
  }

  /// Verificar status uma vez (sem iniciar polling)
  Future<Map<String, dynamic>?> checkStatusOnce(String refuelingId) async {
    try {
      final response = await _apiService.getRefuelingStatus(refuelingId);
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao verificar status: $e');
      return null;
    }
  }

  bool get isPolling => _isPolling;
  String? get currentRefuelingId => _currentRefuelingId;
  String? get currentRefuelingCode => _currentRefuelingCode;
}

