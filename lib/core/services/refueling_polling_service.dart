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
    debugPrint('🚀 [POLLING] startPolling chamado: refuelingId=$refuelingId, refuelingCode=$refuelingCode, intervalSeconds=$intervalSeconds');
    
    if (refuelingId == null && refuelingCode == null) {
      debugPrint('❌ [POLLING] É necessário fornecer refuelingId ou refuelingCode');
      return;
    }

    if (_isPolling && _currentRefuelingId == refuelingId && _currentRefuelingCode == refuelingCode) {
      debugPrint('⚠️ [POLLING] Já está fazendo polling para este ID/código');
      return;
    }

    stopPolling();

    _currentRefuelingId = refuelingId;
    _currentRefuelingCode = refuelingCode;
    _onStatusChanged = onStatusChanged;
    _isPolling = true;

    debugPrint('✅ [POLLING] Polling configurado: _isPolling=$_isPolling, _currentRefuelingId=$_currentRefuelingId, _currentRefuelingCode=$_currentRefuelingCode');

    // Verificação imediata
    debugPrint('🔍 [POLLING] Executando primeira verificação imediata...');
    _checkStatus();

    // Configurar polling periódico
    _pollingTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) {
        if (_isPolling) {
          debugPrint('⏰ [POLLING] Verificação periódica (a cada ${intervalSeconds}s)...');
          _checkStatus();
        } else {
          debugPrint('⚠️ [POLLING] Polling não está mais ativo, cancelando timer');
          _pollingTimer?.cancel();
        }
      },
    );

    debugPrint('🔄 [POLLING] Polling iniciado com sucesso! refueling_id: $refuelingId, code: $refuelingCode (intervalo: ${intervalSeconds}s)');
  }

  /// Parar polling
  void stopPolling() {
    debugPrint('⏹️ [POLLING] stopPolling chamado');
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _currentRefuelingId = null;
    _currentRefuelingCode = null;
    _onStatusChanged = null;
    _isPolling = false;
    debugPrint('✅ [POLLING] Polling parado com sucesso');
  }

  /// Verificar status atual
  Future<void> _checkStatus() async {
    if (_currentRefuelingId == null && _currentRefuelingCode == null) {
      debugPrint('⚠️ [POLLING] Sem refuelingId nem refuelingCode para verificar');
      return;
    }

    if (!_isPolling) {
      debugPrint('⚠️ [POLLING] Polling não está ativo, ignorando verificação');
      return;
    }

    try {
      String? refuelingIdToCheck = _currentRefuelingId;
      
      // SOLUÇÃO 2: Se não temos refueling_id, buscar pelo código
      if (refuelingIdToCheck == null && _currentRefuelingCode != null) {
        debugPrint('🔍 [POLLING] Buscando refueling pelo código: $_currentRefuelingCode');
        try {
          final codeResponse = await _apiService.getRefuelingByCode(_currentRefuelingCode!);
          
          debugPrint('📥 [POLLING] Resposta getRefuelingByCode: success=${codeResponse['success']}, error=${codeResponse['error']}');
          
          if (codeResponse['success'] == true && codeResponse['data'] != null) {
            final refuelingData = codeResponse['data'] as Map<String, dynamic>;
            refuelingIdToCheck = refuelingData['id'] as String?;
            final status = refuelingData['status'] as String?;
            
            debugPrint('📊 [POLLING] Dados encontrados: id=$refuelingIdToCheck, status=$status');
            
            if (refuelingIdToCheck != null) {
              debugPrint('✅ [POLLING] Refueling encontrado pelo código. ID: $refuelingIdToCheck, Status: $status');
              _currentRefuelingId = refuelingIdToCheck; // Atualizar para próximas verificações
              
              // Verificar status diretamente dos dados retornados
              if (status != null && 
                  (status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || 
                   status == 'aguardando_validacao_motorista' ||
                   status.toUpperCase() == 'AGUARDANDO_VALIDACAO_MOTORISTA')) {
                debugPrint('🎯 [POLLING] Status mudou para AGUARDANDO_VALIDACAO_MOTORISTA! Chamando callback...');
                _onStatusChanged?.call(refuelingIdToCheck);
                return; // Já encontrou, não precisa verificar novamente
              } else {
                debugPrint('⏳ [POLLING] Status ainda não é AGUARDANDO_VALIDACAO_MOTORISTA (atual: $status), continuando polling...');
              }
            } else {
              debugPrint('⚠️ [POLLING] Refueling não encontrado pelo código (ainda não foi registrado pelo posto)');
              // Continuar tentando - não retornar aqui, deixar continuar
            }
          } else {
            // Se não encontrou, pode ser que ainda não foi registrado - continuar tentando
            debugPrint('⚠️ [POLLING] Refueling não encontrado ou erro: ${codeResponse['error']} (continuando polling...)');
            // Não retornar aqui - deixar continuar para verificar novamente na próxima iteração
          }
        } catch (e) {
          debugPrint('❌ [POLLING] Erro ao buscar refueling por código: $e (continuando polling...)');
          // Continuar tentando mesmo com erro
        }
      }

      // SOLUÇÃO 1: Se já temos refueling_id (ou acabamos de obter), verificar status
      if (refuelingIdToCheck != null) {
        debugPrint('🔍 [POLLING] Verificando status do refueling: $refuelingIdToCheck');
        final response = await _apiService.getRefuelingStatus(refuelingIdToCheck);

        debugPrint('📥 [POLLING] Resposta getRefuelingStatus: success=${response['success']}, error=${response['error']}');

        if (response['success'] == true && response['data'] != null) {
          final data = response['data'] as Map<String, dynamic>;
          final status = data['status'] as String?;
          
          debugPrint('📊 [POLLING] Status atual: $status');
          
          if (status != null) {
            // Verificar se status mudou para aguardando validação
            if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA' || 
                status == 'aguardando_validacao_motorista' ||
                status.toUpperCase() == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
              // Atualizar refueling_id se ainda não tínhamos
              if (_currentRefuelingId == null && data['id'] != null) {
                _currentRefuelingId = data['id'] as String;
              }
              
              debugPrint('🎯 [POLLING] Status mudou para AGUARDANDO_VALIDACAO_MOTORISTA! Chamando callback...');
              _onStatusChanged?.call(refuelingIdToCheck);
            } else {
              debugPrint('⏳ [POLLING] Status ainda não é AGUARDANDO_VALIDACAO_MOTORISTA (atual: $status), continuando polling...');
            }
          } else {
            debugPrint('⚠️ [POLLING] Status é null nos dados retornados');
          }
        } else {
          debugPrint('⚠️ [POLLING] Erro ao obter status: ${response['error']} (continuando polling...)');
        }
      } else {
        debugPrint('⚠️ [POLLING] Não foi possível obter refuelingId para verificar (continuando polling...)');
      }
    } catch (e) {
      debugPrint('❌ [POLLING] Erro ao verificar status: $e (continuando polling...)');
      // Não parar polling em caso de erro, continuar tentando
    }
  }

  /// Verificar se há dados pendentes de validação
  /// 
  /// Retorna os dados se houver pendência, null caso contrário
  Future<Map<String, dynamic>?> checkPendingValidation(String refuelingId) async {
    try {
      // Usar endpoint específico para dados pendentes de validação
      // Este endpoint já retorna apenas dados quando status é AGUARDANDO_VALIDACAO_MOTORISTA
      final response = await _apiService.getPendingValidation(refuelingId);
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
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

