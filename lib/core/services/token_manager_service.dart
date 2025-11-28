import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_service.dart';
import 'api_service.dart';
import '../di/injection.dart';

/// Serviço para gerenciar renovação proativa de tokens
/// Garante que o token nunca expire durante jornadas longas
class TokenManagerService {
  static final TokenManagerService _instance = TokenManagerService._internal();
  factory TokenManagerService() => _instance;
  TokenManagerService._internal();

  StorageService? _storageService;
  final ApiService _apiService = ApiService();

  /// Obter StorageService (lazy initialization)
  StorageService get _storage {
    if (_storageService == null) {
      _storageService = getIt<StorageService>();
    }
    return _storageService!;
  }

  Timer? _refreshTimer;
  bool _isRefreshing = false;
  bool _isInitialized = false;
  
  // Listeners para notificar quando token for renovado
  final List<Function(String newToken)> _tokenRefreshListeners = [];
  
  // JWT Sliding Window: Access Token = 120 minutos (2 horas)
  // Refresh Token = Sliding Window de 90 dias (nunca expira se app for usado)
  static const int _refreshIntervalMinutes = 30; // Renovar a cada 30 minutos (mais econômico com token de 2h)
  static const int _refreshBeforeExpiryMinutes = 10; // Renovar 10 minutos antes de expirar (2h - 10min = 1h50min)
  
  /// Adicionar listener para ser notificado quando token for renovado
  void addTokenRefreshListener(Function(String newToken) listener) {
    if (!_tokenRefreshListeners.contains(listener)) {
      _tokenRefreshListeners.add(listener);
      debugPrint('✅ TokenManager: Listener adicionado (total: ${_tokenRefreshListeners.length})');
    }
  }
  
  /// Remover listener
  void removeTokenRefreshListener(Function(String newToken) listener) {
    _tokenRefreshListeners.remove(listener);
    debugPrint('🗑️ TokenManager: Listener removido (total: ${_tokenRefreshListeners.length})');
  }
  
  /// Notificar todos os listeners quando token for renovado
  void _notifyTokenRefreshListeners(String newToken) {
    debugPrint('📣 TokenManager: Notificando ${_tokenRefreshListeners.length} listeners...');
    for (var listener in _tokenRefreshListeners) {
      try {
        listener(newToken);
      } catch (e) {
        debugPrint('❌ TokenManager: Erro ao notificar listener: $e');
      }
    }
  }

  /// Inicializar o serviço (deve ser chamado no startup do app)
  /// Pode ser chamado múltiplas vezes (ex: após login)
  Future<void> initialize({bool forceReinit = false}) async {
    if (_isInitialized && !forceReinit) {
      debugPrint('✅ TokenManager: Já inicializado');
      // Mesmo se já inicializado, verificar token e renovar se necessário
      await _checkAndRefreshToken();
      return;
    }
    
    debugPrint('🔄 TokenManager: Inicializando${forceReinit ? " (forçado)" : ""}...');
    
    // Verificar token e renovar se necessário
    final tokenValid = await isTokenValid();
    if (!tokenValid) {
      debugPrint('⚠️ TokenManager: Token inválido ou expirado na inicialização');
      // Tentar renovar token
      final refreshed = await _refreshToken();
      if (!refreshed) {
        // Se refresh falhou, tentar re-login automático
        debugPrint('🔄 TokenManager: Tentando re-login automático na inicialização...');
        await _tryAutoLogin();
      }
    } else {
      // Verificar se está próximo de expirar
      final token = await _storage.getAccessToken();
      if (token != null) {
        final expiresAt = _getTokenExpiration(token);
        if (expiresAt != null) {
          final now = DateTime.now();
          final timeUntilExpiry = expiresAt.difference(now);
          if (timeUntilExpiry.inMinutes <= _refreshBeforeExpiryMinutes) {
            debugPrint('🔄 TokenManager: Token próximo de expirar, renovando na inicialização...');
            await _refreshToken();
          }
        }
      }
    }
    
    // Iniciar renovação automática contínua (não apenas durante jornada)
    _startContinuousRefresh();
    
    _isInitialized = true;
    debugPrint('✅ TokenManager: Inicializado com sucesso');
  }

  /// Iniciar renovação contínua (funciona sempre, não apenas durante jornada)
  void _startContinuousRefresh() {
    _stopAutoRefresh();
    
    debugPrint('🔄 TokenManager: Iniciando renovação contínua de token');
    
    // Verificar e renovar imediatamente se necessário
    _checkAndRefreshToken();
    
    // Configurar renovação periódica
    _refreshTimer = Timer.periodic(
      const Duration(minutes: _refreshIntervalMinutes),
      (_) => _checkAndRefreshToken(),
    );
  }

  /// Iniciar renovação automática de token
  /// Deve ser chamado quando uma jornada é iniciada
  /// (A renovação contínua já está ativa, mas isso garante renovação imediata)
  void startAutoRefresh() {
    debugPrint('🔄 TokenManager: Iniciando renovação automática de token (jornada iniciada)');
    
    // Se não está inicializado, inicializar agora
    if (!_isInitialized) {
      initialize();
      return;
    }
    
    // Renovar imediatamente se necessário
    _checkAndRefreshToken();
    
    // A renovação contínua já está ativa, não precisa criar novo timer
  }

  /// Parar renovação automática
  /// NOTA: Não para completamente - mantém renovação contínua ativa
  /// Apenas para renovação específica de jornada (se houver)
  void stopAutoRefresh() {
    debugPrint('🛑 TokenManager: Parando renovação automática de token (jornada finalizada)');
    // NÃO parar completamente - manter renovação contínua ativa
    // Apenas garantir que não há timer duplicado
    // A renovação contínua continua funcionando
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Verificar e renovar token se necessário
  Future<bool> _checkAndRefreshToken() async {
    if (_isRefreshing) {
      debugPrint('⏳ TokenManager: Renovação já em andamento, aguardando...');
      return false;
    }

    try {
      _isRefreshing = true;
      
      final token = await _storage.getAccessToken();
      if (token == null) {
        debugPrint('⚠️ TokenManager: Nenhum token encontrado');
        return false;
      }

      // Verificar se o token está próximo de expirar
      final expiresAt = _getTokenExpiration(token);
      if (expiresAt == null) {
        debugPrint('⚠️ TokenManager: Não foi possível decodificar expiração do token');
        // Renovar de qualquer forma para garantir
        return await _refreshToken();
      }

      final now = DateTime.now();
      final timeUntilExpiry = expiresAt.difference(now);
      final minutesUntilExpiry = timeUntilExpiry.inMinutes;

      debugPrint('⏰ TokenManager: Token expira em $minutesUntilExpiry minutos');

      // Renovar se está próximo de expirar (2 minutos antes) ou já expirou
      if (minutesUntilExpiry <= _refreshBeforeExpiryMinutes) {
        debugPrint('🔄 TokenManager: Token próximo de expirar, renovando...');
        return await _refreshToken();
      }

      debugPrint('✅ TokenManager: Token ainda válido, não é necessário renovar');
      return true;
    } catch (e) {
      debugPrint('❌ TokenManager: Erro ao verificar token: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Renovar token garantidamente antes de operações críticas
  /// Retorna true se o token está válido (renovado ou já válido)
  /// Se refresh token falhar, tenta re-login automático
  Future<bool> ensureValidToken({bool allowAutoLogin = true}) async {
    debugPrint('🔐 TokenManager: Garantindo token válido antes de operação crítica');
    
    final token = await _storage.getAccessToken();
    if (token == null) {
      debugPrint('❌ TokenManager: Nenhum token encontrado');
      // Tentar re-login automático se permitido
      if (allowAutoLogin) {
        return await _tryAutoLogin();
      }
      return false;
    }

    // Verificar se está expirado ou próximo de expirar
    final expiresAt = _getTokenExpiration(token);
    if (expiresAt == null) {
      // Se não conseguiu decodificar, tentar renovar
      debugPrint('🔄 TokenManager: Não foi possível verificar expiração, renovando...');
      final refreshed = await _refreshToken();
      if (!refreshed && allowAutoLogin) {
        return await _tryAutoLogin();
      }
      return refreshed;
    }

    final now = DateTime.now();
    final timeUntilExpiry = expiresAt.difference(now);
    
    // Se expirou ou está próximo de expirar (5 minutos), renovar
    if (timeUntilExpiry.inMinutes <= 5) {
      debugPrint('🔄 TokenManager: Token expirado ou próximo de expirar, renovando...');
      final refreshed = await _refreshToken();
      if (!refreshed && allowAutoLogin) {
        debugPrint('🔄 TokenManager: Refresh token falhou, tentando re-login automático...');
        return await _tryAutoLogin();
      }
      return refreshed;
    }

    debugPrint('✅ TokenManager: Token válido, não é necessário renovar');
    return true;
  }

  /// Tentar re-login automático usando credenciais salvas
  /// Retorna true se o re-login foi bem-sucedido
  Future<bool> _tryAutoLogin() async {
    try {
      debugPrint('🔄 TokenManager: Tentando re-login automático...');
      
      final credentials = await _storage.getLoginCredentials();
      if (credentials == null) {
        debugPrint('❌ TokenManager: Credenciais não encontradas para re-login automático');
        return false;
      }

      debugPrint('🔄 TokenManager: Fazendo re-login automático com CPF: ${credentials['cpf']}');
      final response = await _apiService.login(
        userType: credentials['userType']!,
        cpf: credentials['cpf']!,
        password: credentials['password']!,
      );

      if (response['success'] == true) {
        debugPrint('✅ TokenManager: Re-login automático bem-sucedido!');
        // Reiniciar renovação contínua após re-login
        _startContinuousRefresh();
        return true;
      } else {
        debugPrint('❌ TokenManager: Re-login automático falhou: ${response['error']}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ TokenManager: Erro ao tentar re-login automático: $e');
      debugPrint('📚 Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Renovar token usando refresh token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) {
        debugPrint('❌ TokenManager: Refresh token não encontrado');
        return false;
      }

      debugPrint('🔄 TokenManager: Renovando token...');
      final response = await _apiService.refreshToken(refreshToken);

      if (response['success'] == true) {
        debugPrint('✅ TokenManager: Token renovado com sucesso');
        
        // Atualizar tokens no ApiService
        final newAccessToken = response['data']?['access_token'];
        final newRefreshToken = response['data']?['refresh_token'];
        
        if (newAccessToken != null) {
          await _storage.saveAccessToken(newAccessToken);
          _apiService.setAuthToken(newAccessToken);
          
          // 🔔 Notificar todos os listeners (ex: BackgroundGeolocationService)
          _notifyTokenRefreshListeners(newAccessToken);
        }
        
        if (newRefreshToken != null) {
          await _storage.saveRefreshToken(newRefreshToken);
          _apiService.setRefreshToken(newRefreshToken);
        }
        
        return true;
      } else {
        debugPrint('❌ TokenManager: Falha ao renovar token: ${response['error']}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ TokenManager: Erro ao renovar token: $e');
      return false;
    }
  }

  /// Decodificar JWT e obter data de expiração
  DateTime? _getTokenExpiration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      // Decodificar payload (parte 2 do JWT)
      final payload = parts[1];
      // Adicionar padding se necessário
      final normalizedPayload = payload.padRight(
        (payload.length + 3) ~/ 4 * 4,
        '=',
      );
      
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final payloadMap = jsonDecode(decodedString) as Map<String, dynamic>;
      
      final exp = payloadMap['exp'];
      if (exp == null) {
        return null;
      }

      // exp é um timestamp Unix (segundos)
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return expirationDate;
    } catch (e) {
      debugPrint('⚠️ TokenManager: Erro ao decodificar token: $e');
      return null;
    }
  }

  /// Verificar se o token está válido
  Future<bool> isTokenValid() async {
    final token = await _storage.getAccessToken();
    if (token == null) {
      return false;
    }

    final expiresAt = _getTokenExpiration(token);
    if (expiresAt == null) {
      return false;
    }

    return DateTime.now().isBefore(expiresAt);
  }

  /// Dispose - limpar recursos
  void dispose() {
    _stopAutoRefresh();
  }
}

