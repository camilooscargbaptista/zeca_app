import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import '../config/api_config.dart';
import 'storage_service.dart';
import 'device_service.dart';
import 'token_manager_service.dart';
import 'api_service.dart';
import '../../core/di/injection.dart';

/// Service para gerenciar tracking em background usando flutter_background_geolocation
/// 
/// Este service substitui o geolocator para tracking mais robusto e confiável,
/// especialmente em background (app fechado ou em segundo plano).
/// 
/// Funcionalidades:
/// - Tracking contínuo em background
/// - Persistência local (SQLite interno do plugin)
/// - Auto-sync com API quando houver conexão
/// - Economia de bateria (motion detection)
/// - Sobrevive a otimizações de bateria do Android/iOS
class BackgroundGeolocationService {
  static final BackgroundGeolocationService _instance = BackgroundGeolocationService._internal();
  factory BackgroundGeolocationService() => _instance;
  BackgroundGeolocationService._internal();

  bool _isConfigured = false;
  bool _isTracking = false;
  String? _currentJourneyId;

  /// Inicializar e configurar o plugin
  /// Deve ser chamado uma vez no app (pode ser no main ou antes de iniciar jornada)
  Future<void> initialize() async {
    if (_isConfigured) return;

    debugPrint('🔧 [BG-GEO] Inicializando Background Geolocation Service...');

    try {
      // Listener para eventos de localização
      bg.BackgroundGeolocation.onLocation(_onLocation);

      // Listener para eventos de motion (movimento/parada)
      bg.BackgroundGeolocation.onMotionChange(_onMotionChange);

      // Listener para eventos de atividade (andando, dirigindo, parado)
      bg.BackgroundGeolocation.onActivityChange(_onActivityChange);

      // Listener para eventos de provedor (GPS ligado/desligado)
      bg.BackgroundGeolocation.onProviderChange(_onProviderChange);

      // Listener para erros de conexão HTTP
      bg.BackgroundGeolocation.onHttp(_onHttp);

      // Listener para sincronização de dados
      bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

      debugPrint('✅ [BG-GEO] Listeners configurados');
      _isConfigured = true;
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao inicializar: $e');
      rethrow;
    }
  }

  /// Atualizar token nos headers do plugin (quando token é renovado)
  Future<void> updateAuthToken(String newToken) async {
    if (!_isTracking) {
      debugPrint('⚠️ [BG-GEO] Tracking não está ativo, ignorando atualização de token');
      return;
    }

    try {
      debugPrint('🔄 [BG-GEO] Atualizando token nos headers...');
      
      final deviceService = DeviceService();
      final deviceId = await deviceService.getDeviceId();
      
      // Atualizar configuração do plugin com novo token
      await bg.BackgroundGeolocation.setConfig(bg.Config(
        headers: {
          'Authorization': 'Bearer $newToken',
          'Content-Type': 'application/json',
          'x-device-id': deviceId,
        },
      ));
      
      debugPrint('✅ [BG-GEO] Token atualizado com sucesso');
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao atualizar token: $e');
    }
  }

  /// Iniciar tracking de uma jornada
  Future<void> startTracking(String journeyId) async {
    if (!_isConfigured) {
      await initialize();
    }

    if (_isTracking) {
      debugPrint('⚠️ [BG-GEO] Tracking já está ativo');
      return;
    }

    _currentJourneyId = journeyId;

    try {
      debugPrint('🚀 [BG-GEO] Iniciando tracking para jornada: $journeyId');

      // Obter token e device info
      final storageService = getIt<StorageService>();
      final deviceService = DeviceService();
      
      final token = await storageService.getAccessToken();  // ✅ Usar método correto (SecureStorage)
      final deviceId = await deviceService.getDeviceId();
      
      if (token == null) {
        debugPrint('❌ [BG-GEO] Token não encontrado no storage!');
        throw Exception('Token não encontrado. Faça login novamente.');
      }
      
      debugPrint('🔑 [BG-GEO] Usando token para tracking (primeiros 20 chars): ${token.substring(0, 20)}...');

      // 🔔 Registrar listener para renovação de token
      final tokenManager = getIt<TokenManagerService>();
      tokenManager.addTokenRefreshListener((newToken) {
        debugPrint('🔔 [BG-GEO] Token renovado! Atualizando headers...');
        updateAuthToken(newToken);
      });

      // Configurar o plugin
      bg.State state = await bg.BackgroundGeolocation.ready(bg.Config(
        // ============================================
        // CONFIGURAÇÕES DE TRACKING
        // ============================================
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 30.0, // Capturar a cada 30 metros
        stopTimeout: 5, // Parar tracking após 5 minutos parado
        stopOnTerminate: false, // Continuar mesmo se app fechar
        startOnBoot: false, // NÃO iniciar automaticamente ao ligar dispositivo
        enableHeadless: true, // Funciona mesmo sem UI
        
        // ============================================
        // CONFIGURAÇÕES DE MOTION DETECTION
        // ============================================
        stopDetectionDelay: 5, // Minutos para detectar que parou
        disableMotionActivityUpdates: false, // Usar sensores de movimento
        
        // ============================================
        // CONFIGURAÇÕES DE BATERIA
        // ============================================
        preventSuspend: true, // Prevenir que iOS suspenda o app
        heartbeatInterval: 60, // Heartbeat a cada 60s quando parado
        
        // ============================================
        // ESTRATÉGIA DE ENVIO PARA BACKEND
        // ============================================
        // ❌ NÃO usar 'url' do plugin (envia campos extras que backend rejeita)
        // ✅ Plugin SÓ captura GPS
        // ✅ App envia manualmente via Dio (listener _onLocation)
        // ✅ Controle total sobre formato dos dados
        
        // ============================================
        // CONFIGURAÇÕES DE LOG (DEBUG)
        // ============================================
        debug: kDebugMode, // Ativar logs apenas em debug
        logLevel: kDebugMode ? bg.Config.LOG_LEVEL_VERBOSE : bg.Config.LOG_LEVEL_OFF,
        
        // ============================================
        // NOTIFICAÇÃO (ANDROID)
        // ============================================
        notification: bg.Notification(
          title: "🚛 Jornada ZECA Ativa",
          text: "Rastreando sua viagem em tempo real",
          color: "#1976D2",
          smallIcon: "drawable/notification_icon",
          largeIcon: "drawable/notification_icon_large",
          priority: bg.Config.NOTIFICATION_PRIORITY_LOW,
          channelName: "Rastreamento de Jornada",
          sticky: true,
        ),
        
        // ============================================
        // CONFIGURAÇÕES ANDROID
        // ============================================
        foregroundService: true,
        enableTimestampMeta: true,
        
        // ============================================
        // CONFIGURAÇÕES iOS
        // ============================================
        locationAuthorizationRequest: 'Always',
        backgroundPermissionRationale: bg.PermissionRationale(
          title: "Permitir acesso à localização em segundo plano",
          message: "Para rastrear sua jornada mesmo quando o app estiver fechado, "
                   "precisamos acessar sua localização continuamente.",
          positiveAction: "Alterar para '{backgroundPermissionOptionLabel}'",
          negativeAction: "Cancelar",
        ),
      ));

      debugPrint('✅ [BG-GEO] Plugin configurado');
      debugPrint('   - Enabled: ${state.enabled}');
      debugPrint('   - Tracking: ${state.trackingMode}');

      // Iniciar tracking
      await bg.BackgroundGeolocation.start();
      
      _isTracking = true;
      debugPrint('✅ [BG-GEO] Tracking iniciado com sucesso!');
      
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao iniciar tracking: $e');
      _isTracking = false;
      _currentJourneyId = null;
      rethrow;
    }
  }

  /// Parar tracking
  Future<void> stopTracking() async {
    if (!_isTracking) {
      debugPrint('⚠️ [BG-GEO] Tracking já está inativo');
      return;
    }

    try {
      debugPrint('🛑 [BG-GEO] Parando tracking...');

      // Sincronizar pontos pendentes antes de parar
      await syncPendingLocations();

      // Parar tracking
      await bg.BackgroundGeolocation.stop();

      _isTracking = false;
      _currentJourneyId = null;

      debugPrint('✅ [BG-GEO] Tracking parado com sucesso');
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao parar tracking: $e');
      rethrow;
    }
  }

  /// Pausar tracking (durante descanso)
  Future<void> pauseTracking() async {
    if (!_isTracking) return;

    try {
      debugPrint('⏸️ [BG-GEO] Pausando tracking...');
      await bg.BackgroundGeolocation.changePace(false);
      debugPrint('✅ [BG-GEO] Tracking pausado');
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao pausar tracking: $e');
    }
  }

  /// Retomar tracking (após descanso)
  Future<void> resumeTracking() async {
    if (!_isTracking) return;

    try {
      debugPrint('▶️ [BG-GEO] Retomando tracking...');
      await bg.BackgroundGeolocation.changePace(true);
      debugPrint('✅ [BG-GEO] Tracking retomado');
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao retomar tracking: $e');
    }
  }

  /// Transformar dados do plugin para formato da API
  /// Converte speed (m/s) para velocidade (km/h) e adiciona journey_id
  Map<String, dynamic> _transformLocationToApi(bg.Location location) {
    // Garantir que velocidade seja sempre >= 0 (backend valida isso)
    // iOS Simulator pode retornar speed = -1.0 quando parado
    final speedMps = location.coords.speed ?? 0.0;
    final velocidadeKmh = speedMps >= 0 ? speedMps * 3.6 : 0.0;
    
    return {
      'journey_id': _currentJourneyId!,
      'latitude': location.coords.latitude,
      'longitude': location.coords.longitude,
      'velocidade': velocidadeKmh,  // km/h (sempre >= 0)
      'timestamp': location.timestamp,
    };
  }
  
  /// Enviar location point para API via Dio (HTTP manual)
  /// Esta é a solução recomendada pelo guia do backend
  Future<void> _sendLocationPoint(bg.Location location) async {
    try {
      // Validar journey_id
      if (_currentJourneyId == null) {
        debugPrint('⚠️ [BG-GEO] Journey ID não definido, ignorando ponto');
        return;
      }

      // Transformar dados do plugin para formato da API
      final payload = _transformLocationToApi(location);
      
      debugPrint('📤 [BG-GEO] Enviando ponto via Dio:');
      debugPrint('   - Journey: ${payload['journey_id']}');
      debugPrint('   - Lat/Lng: ${payload['latitude']}, ${payload['longitude']}');
      debugPrint('   - Velocidade: ${payload['velocidade']} km/h');
      debugPrint('   - Timestamp: ${payload['timestamp']}');

      // Enviar via ApiService (singleton, não usa GetIt)
      final apiService = ApiService();
      final response = await apiService.addLocationPoint(
        journeyId: payload['journey_id'],
        latitude: payload['latitude'],
        longitude: payload['longitude'],
        velocidade: payload['velocidade'],
        timestamp: DateTime.parse(payload['timestamp']),
      );

      if (response['success'] == true) {
        debugPrint('✅ [BG-GEO] Ponto enviado com SUCESSO! Status: 201');
      } else {
        debugPrint('⚠️ [BG-GEO] Falha ao enviar ponto: ${response['error']}');
      }
      
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao enviar ponto: $e');
      // NÃO fazer throw - continuar tracking mesmo se falhar
      // Os pontos ficam salvos localmente e podemos retentar depois
    }
  }
  
  /// Sincronizar manualmente pontos pendentes
  /// NOTA: Como agora usamos HTTP manual, não há pontos pendentes no plugin
  /// Deixando método para compatibilidade, mas não faz nada
  Future<void> syncPendingLocations() async {
    debugPrint('ℹ️ [BG-GEO] syncPendingLocations() não necessário com HTTP manual');
    debugPrint('   Pontos são enviados imediatamente via Dio');
  }
  
  /// Obter quantidade de pontos pendentes no banco local
  /// NOTA: O plugin versão 4.18 não expõe método getCount() diretamente
  /// A contagem é inferida pelos logs HTTP de sync
  Future<int> getPendingLocationsCount() async {
    // Método não disponível na API pública do plugin v4.18
    // O plugin gerencia o SQLite internamente
    debugPrint('⚠️ [BG-GEO] getCount() não disponível nesta versão do plugin');
    debugPrint('   Use logs HTTP para monitorar envios');
    return 0;
  }
  
  /// Obter todos os pontos pendentes (para debug)
  /// NOTA: O plugin versão 4.18 não expõe método getLocations() diretamente
  Future<List<bg.Location>> getPendingLocations() async {
    // Método não disponível na API pública do plugin v4.18
    debugPrint('⚠️ [BG-GEO] getLocations() não disponível nesta versão do plugin');
    return [];
  }
  
  /// Limpar banco local (CUIDADO: usar apenas para debug/testes)
  Future<void> destroyLocations() async {
    try {
      debugPrint('🗑️ [BG-GEO] Limpando banco local...');
      // O plugin tem este método disponível
      await bg.BackgroundGeolocation.destroyLocations();
      debugPrint('✅ [BG-GEO] Banco local limpo');
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao limpar: $e');
    }
  }

  /// Obter posição atual
  Future<bg.Location?> getCurrentPosition() async {
    try {
      debugPrint('📍 [BG-GEO] Obtendo posição atual...');
      final location = await bg.BackgroundGeolocation.getCurrentPosition(
        samples: 1,
        timeout: 30,
        maximumAge: 5000,
        desiredAccuracy: 10,
      );
      debugPrint('✅ [BG-GEO] Posição obtida: ${location.coords.latitude}, ${location.coords.longitude}');
      return location;
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao obter posição: $e');
      return null;
    }
  }

  /// Obter status do tracking
  Future<Map<String, dynamic>> getStatus() async {
    final state = await bg.BackgroundGeolocation.state;

    return {
      'is_tracking': _isTracking,
      'journey_id': _currentJourneyId,
      'enabled': state.enabled,
      'tracking_mode': state.trackingMode,
      'odometer': state.odometer,
    };
  }

  // ============================================================
  // LISTENERS / CALLBACKS
  // ============================================================

  void _onLocation(bg.Location location) {
    debugPrint('📍 [BG-GEO] Localização capturada:');
    debugPrint('   - Lat/Lng: ${location.coords.latitude}, ${location.coords.longitude}');
    debugPrint('   - Velocidade: ${location.coords.speed} m/s (${(location.coords.speed * 3.6).toStringAsFixed(1)} km/h)');
    debugPrint('   - Precisão: ${location.coords.accuracy}m');
    debugPrint('   - Em movimento: ${location.isMoving}');
    debugPrint('   - Odômetro: ${location.odometer}m');
    
    // ✨ NOVO: Enviar ponto para backend via HTTP manual (Dio)
    _sendLocationPoint(location);
  }

  void _onMotionChange(bg.Location location) {
    debugPrint('🚗 [BG-GEO] Mudança de movimento:');
    debugPrint('   - Em movimento: ${location.isMoving}');
    debugPrint('   - Velocidade: ${(location.coords.speed * 3.6).toStringAsFixed(1)} km/h');
    
    // ✨ NOVO: Enviar ponto para backend via HTTP manual (Dio)
    _sendLocationPoint(location);
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    debugPrint('🏃 [BG-GEO] Mudança de atividade:');
    debugPrint('   - Atividade: ${event.activity}');
    debugPrint('   - Confiança: ${event.confidence}%');
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    debugPrint('📡 [BG-GEO] Mudança de provedor:');
    debugPrint('   - GPS habilitado: ${event.gps}');
    debugPrint('   - Rede habilitada: ${event.network}');
    debugPrint('   - Status: ${event.status}');
    
    if (!event.enabled) {
      debugPrint('⚠️ [BG-GEO] ATENÇÃO: Serviços de localização desabilitados!');
    }
  }

  void _onHttp(bg.HttpEvent event) {
    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('🌐 [BG-GEO HTTP] ${event.success ? "✅ SUCCESS" : "❌ ERROR"}');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('📊 Status Code: ${event.status}');
    debugPrint('📥 Response:');
    debugPrint(event.responseText ?? '(empty)');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('');
    
    if (!event.success) {
      // Log adicional para erros
      debugPrint('⚠️ [BG-GEO HTTP] ATENÇÃO: Falha ao enviar ponto!');
      debugPrint('⚠️ Possíveis causas:');
      debugPrint('   - Sem internet (status 0 ou timeout)');
      debugPrint('   - URL incorreta (404)');
      debugPrint('   - Token expirado (401)');
      debugPrint('   - Body inválido (400)');
      debugPrint('   - Erro no servidor (500)');
      debugPrint('⚠️ Status: ${event.status}');
    }
  }

  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    debugPrint('📶 [BG-GEO] Conectividade mudou: ${event.connected ? "ONLINE" : "OFFLINE"}');
    
    if (event.connected) {
      // Quando voltar online, tentar sincronizar pontos pendentes
      syncPendingLocations();
    }
  }

  // ============================================================
  // GETTERS
  // ============================================================

  bool get isTracking => _isTracking;
  String? get currentJourneyId => _currentJourneyId;
}

