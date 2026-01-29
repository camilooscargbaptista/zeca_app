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
  /// NOVO: Callback que retorna status, refuelingId e dados completos
  /// Usado para tratar múltiplos status (AGUARDANDO_VALIDACAO_MOTORISTA, CONCLUIDO, CONTESTADO)
  Function(String status, String refuelingId, Map<String, dynamic> data)? _onStatusWithData;
  bool _isPolling = false;
  
  /// Contador de 404 consecutivos - se chegar a 3, considera como CANCELADO
  int _notFoundCount = 0;
  static const int _maxNotFoundBeforeCancelled = 3;

  /// Iniciar polling para um refueling_id ou código de abastecimento
  /// 
  /// [refuelingId] - ID do abastecimento para monitorar (opcional)
  /// [refuelingCode] - Código de abastecimento para buscar refueling (opcional)
  /// [onStatusChanged] - Callback chamado quando o status muda para AGUARDANDO_VALIDACAO_MOTORISTA
  /// [onStatusWithData] - NOVO: Callback com status, refuelingId e dados (para tratar múltiplos status)
  /// [intervalSeconds] - Intervalo entre verificações (padrão: 15 segundos)
  void startPolling({
    String? refuelingId,
    String? refuelingCode,
    Function(String)? onStatusChanged,
    Function(String status, String refuelingId, Map<String, dynamic> data)? onStatusWithData,
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
    _onStatusWithData = onStatusWithData;
    _isPolling = true;
    _notFoundCount = 0; // Reset contador de 404

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
                _notFoundCount = 0; // Reset contador quando encontra o registro
              }
            } else {
              debugPrint('⚠️ [POLLING] Refueling não encontrado pelo código (ainda não foi registrado pelo posto)');
              // Continuar tentando - não retornar aqui, deixar continuar
            }
          } else {
            // Se não encontrou, pode ser que ainda não foi registrado - ou foi cancelado
            _notFoundCount++;
            debugPrint('⚠️ [POLLING] Refueling não encontrado ou erro: ${codeResponse['error']} (404 #$_notFoundCount de $_maxNotFoundBeforeCancelled)');
            
            // Se atingiu o limite de 404 consecutivos, considerar como CANCELADO
            if (_notFoundCount >= _maxNotFoundBeforeCancelled) {
              debugPrint('❌ [POLLING] $_maxNotFoundBeforeCancelled 404s consecutivos - considerando como CANCELADO');
              if (_onStatusWithData != null) {
                _onStatusWithData?.call('CANCELADO', _currentRefuelingCode ?? '', {});
              }
              stopPolling();
              return;
            }
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
          final statusUpper = status?.toUpperCase() ?? '';
          
          debugPrint('📊 [POLLING] Status atual: $status');
          
          if (status != null) {
            // Atualizar refueling_id se ainda não tínhamos
            if (_currentRefuelingId == null && data['id'] != null) {
              _currentRefuelingId = data['id'] as String;
            }
            
            // NOVO: Chamar callback multi-status se registrado
            if (_onStatusWithData != null) {
              // Detectar múltiplos status relevantes
              if (statusUpper == 'AGUARDANDO_VALIDACAO_MOTORISTA' ||
                  statusUpper == 'VALIDADO' ||
                  statusUpper == 'CONCLUIDO' ||
                  statusUpper == 'CONTESTADO' ||
                  statusUpper == 'CANCELADO') {
                debugPrint('🎯 [POLLING] Status relevante detectado: $status! Chamando onStatusWithData...');
                _onStatusWithData?.call(statusUpper, refuelingIdToCheck, data);
                return; // Status tratado
              }
            }
            
            // Fallback: callback antigo (compatibilidade)
            if (statusUpper == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
              debugPrint('🎯 [POLLING] Status mudou para AGUARDANDO_VALIDACAO_MOTORISTA! Chamando callback...');
              _onStatusChanged?.call(refuelingIdToCheck);
            } else {
              debugPrint('⏳ [POLLING] Status ainda não é final (atual: $status), continuando polling...');
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

  /// Iniciar polling para verificar um status específico (genérico)
  /// 
  /// Usado para AUTÔNOMO que espera status CONCLUIDO
  /// [refuelingCode] - Código de abastecimento para buscar refueling
  /// [targetStatus] - Status alvo a aguardar (ex: 'CONCLUIDO')
  /// [onStatusReached] - Callback chamado quando o status é atingido (recebe dados do refueling)
  /// [intervalSeconds] - Intervalo entre verificações (padrão: 60 segundos = 1 minuto)
  /// [delaySeconds] - Delay inicial antes de iniciar polling (padrão: 180 segundos = 3 minutos)
  void startPollingForStatus({
    required String refuelingCode,
    required String targetStatus,
    required Function(Map<String, dynamic>) onStatusReached,
    int intervalSeconds = 60, // ALTERADO: 1 minuto
    int delaySeconds = 180,   // NOVO: 3 minutos de delay inicial
  }) {
    debugPrint('🚀 [POLLING] startPollingForStatus chamado: code=$refuelingCode, targetStatus=$targetStatus');
    debugPrint('⏱️ [POLLING] Delay inicial: ${delaySeconds}s, Intervalo: ${intervalSeconds}s');
    
    stopPolling();

    _currentRefuelingCode = refuelingCode;
    _isPolling = true;

    // NOVO: Delay inicial antes de começar o polling (fallback para WebSocket)
    if (delaySeconds > 0) {
      debugPrint('⏳ [POLLING] Aguardando ${delaySeconds}s (${delaySeconds ~/ 60} min) antes de iniciar polling...');
      
      _pollingTimer = Timer(Duration(seconds: delaySeconds), () {
        if (!_isPolling) {
          debugPrint('⚠️ [POLLING] Polling foi cancelado durante o delay inicial');
          return;
        }
        
        debugPrint('🔍 [POLLING] Delay inicial concluído. Iniciando polling periódico...');
        
        // Verificação imediata após o delay
        _checkStatusForTarget(targetStatus, onStatusReached);
        
        // Configurar polling periódico
        _pollingTimer = Timer.periodic(
          Duration(seconds: intervalSeconds),
          (_) {
            if (_isPolling) {
              debugPrint('⏰ [POLLING] Verificação periódica para status $targetStatus...');
              _checkStatusForTarget(targetStatus, onStatusReached);
            } else {
              _pollingTimer?.cancel();
            }
          },
        );
      });
    } else {
      // Sem delay - comportamento antigo para compatibilidade
      debugPrint('🔍 [POLLING] Executando primeira verificação imediata...');
      _checkStatusForTarget(targetStatus, onStatusReached);

      // Configurar polling periódico
      _pollingTimer = Timer.periodic(
        Duration(seconds: intervalSeconds),
        (_) {
          if (_isPolling) {
            debugPrint('⏰ [POLLING] Verificação periódica para status $targetStatus...');
            _checkStatusForTarget(targetStatus, onStatusReached);
          } else {
            _pollingTimer?.cancel();
          }
        },
      );
    }

    debugPrint('🔄 [POLLING] Polling configurado - delay: ${delaySeconds}s, intervalo: ${intervalSeconds}s');
  }

  /// Verificar status alvo (para AUTÔNOMO verificando CONCLUIDO)
  Future<void> _checkStatusForTarget(String targetStatus, Function(Map<String, dynamic>) onStatusReached) async {
    if (_currentRefuelingCode == null) {
      debugPrint('⚠️ [POLLING] Sem refuelingCode para verificar');
      return;
    }

    if (!_isPolling) {
      return;
    }

    try {
      debugPrint('🔍 [POLLING] Buscando refueling pelo código: $_currentRefuelingCode');
      final codeResponse = await _apiService.getRefuelingByCode(_currentRefuelingCode!);
      
      if (codeResponse['success'] == true && codeResponse['data'] != null) {
        final refuelingData = codeResponse['data'] as Map<String, dynamic>;
        final status = refuelingData['status'] as String?;
        
        // Verificar também se existe um objeto 'refueling' com status (estrutura comum quando o codigo foi usado)
        String? refuelingStatus;
        if (refuelingData['refueling'] is Map) {
           refuelingStatus = refuelingData['refueling']['status'] as String?;
        }

        debugPrint('📊 [POLLING] Code Status: $status, Nested Refueling Status: $refuelingStatus');
        
        final effectiveStatus = refuelingStatus ?? status;
        
        if (effectiveStatus != null && effectiveStatus.toUpperCase() == targetStatus.toUpperCase()) {
          debugPrint('🎯 [POLLING] Status $targetStatus atingido (Code ou Nested)! Chamando callback...');
          
          // Se tiver dados aninhados de refueling, mesclar ou passar o objeto de refueling
          // para garantir que tenhamos os dados de pagamento (valor, litros, etc)
          var finalData = Map<String, dynamic>.from(refuelingData);
          if (refuelingData['refueling'] is Map) {
             finalData.addAll(refuelingData['refueling'] as Map<String, dynamic>);
          }
          
          onStatusReached(finalData);
        } else {
          // SMART POLLING: Verificando lista de últimos abastecimentos como fallback
          bool smartPollingFound = false;
          if (targetStatus == 'CONCLUIDO') {
             try {
               final cleanCurrentCode = _currentRefuelingCode?.replaceAll('-', '');
               debugPrint('🕵️ [SMART POLLING] Verificando lista de últimos abastecimentos para código: $cleanCurrentCode');
               
               final recentRes = await _apiService.getLastRefuelings(limit: 5);
               if (recentRes['success'] == true && recentRes['data'] != null && recentRes['data']['data'] is List) {
                  final list = recentRes['data']['data'] as List;
                  
                  for (var item in list) {
                     final itemCode = item['refueling_code']?.toString().replaceAll('-', '');
                     final itemStatus = item['status']?.toString().toUpperCase();
                     
                     if (itemCode == cleanCurrentCode && itemStatus == 'CONCLUIDO') {
                         debugPrint('🎯 [SMART POLLING] Abastecimento CONCLUIDO encontrado na lista recente!');
                         onStatusReached(item);
                         smartPollingFound = true;
                         break;
                     }
                  }
               }
             } catch (e) {
               debugPrint('❌ [SMART POLLING] Erro: $e');
             }
          }

          if (!smartPollingFound) {
            debugPrint('⏳ [POLLING] Status ainda não é $targetStatus (Code: $status, Refueling: $refuelingStatus), continuando polling...');
          }
        }
      } else {
        debugPrint('⚠️ [POLLING] Refueling não encontrado: ${codeResponse['error']} (continuando polling...)');
      }
    } catch (e) {
      debugPrint('❌ [POLLING] Erro ao verificar status: $e (continuando polling...)');
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

  /// Verificar status por código uma vez (sem iniciar polling)
  Future<Map<String, dynamic>?> checkStatusByCodeOnce(String code) async {
    try {
      final response = await _apiService.getRefuelingByCode(code);
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao verificar status por código: $e');
      return null;
    }
  }

  /// NOVO: Polling genérico que retorna dados para decisão na UI
  /// 
  /// Diferente de startPollingForStatus que tem lógica interna,
  /// este método apenas faz polling e chama callback com os dados.
  /// A lógica de decisão fica na camada de UI.
  void startPollingGeneric({
    required String refuelingCode,
    required Function(Map<String, dynamic>) onDataReceived,
    int intervalSeconds = 10,
    int delaySeconds = 0,
  }) {
    debugPrint('🚀 [POLLING] startPollingGeneric chamado: code=$refuelingCode, interval=${intervalSeconds}s, delay=${delaySeconds}s');
    
    stopPolling();
    
    _currentRefuelingCode = refuelingCode;
    _isPolling = true;
    
    debugPrint('✅ [POLLING] Polling genérico configurado: _isPolling=$_isPolling, code=$refuelingCode');
    
    void doPolling() {
      debugPrint('🔍 [POLLING] Executando verificação...');
      _checkStatusGeneric(refuelingCode, onDataReceived);
    }
    
    void startTimer() {
      // Verificação imediata
      doPolling();
      
      // Configurar polling periódico
      _pollingTimer = Timer.periodic(
        Duration(seconds: intervalSeconds),
        (_) {
          if (_isPolling) {
            debugPrint('⏰ [POLLING] Verificação periódica (a cada ${intervalSeconds}s)...');
            doPolling();
          } else {
            debugPrint('⚠️ [POLLING] Polling não está mais ativo, cancelando timer');
            _pollingTimer?.cancel();
          }
        },
      );
      
      debugPrint('🔄 [POLLING] Polling genérico iniciado! (intervalo: ${intervalSeconds}s)');
    }
    
    if (delaySeconds > 0) {
      debugPrint('⏳ [POLLING] Aguardando ${delaySeconds}s antes de iniciar...');
      _pollingTimer = Timer(Duration(seconds: delaySeconds), startTimer);
    } else {
      startTimer();
    }
  }
  
  /// Verificação genérica que retorna os dados brutos
  Future<void> _checkStatusGeneric(String code, Function(Map<String, dynamic>) onDataReceived) async {
    if (!_isPolling) {
      debugPrint('⚠️ [POLLING] Polling não está ativo, ignorando verificação');
      return;
    }
    
    try {
      final response = await _apiService.getRefuelingByCode(code);
      
      debugPrint('📥 [POLLING] Resposta: success=${response['success']}, error=${response['error']}');
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        debugPrint('📊 [POLLING] Dados: id=${data['id']}, status=${data['status']}, is_pending_code=${data['is_pending_code']}');
        onDataReceived(data);
      } else {
        debugPrint('⚠️ [POLLING] Sem dados ou erro: ${response['error']}');
      }
    } catch (e) {
      debugPrint('❌ [POLLING] Erro ao verificar: $e');
    }
  }

  bool get isPolling => _isPolling;
  String? get currentRefuelingId => _currentRefuelingId;
  String? get currentRefuelingCode => _currentRefuelingCode;
}

