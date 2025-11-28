import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import '../config/api_config.dart';
import 'storage_service.dart';
import 'device_service.dart';
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
      
      final token = storageService.read<String>('access_token');
      final deviceId = await deviceService.getDeviceId();

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
        // CONFIGURAÇÕES DE REDE/API
        // ============================================
        // IMPORTANTE: Backend espera POST /api/journeys/location-point (singular!)
        // Body: { journey_id, latitude, longitude, velocidade, timestamp }
        url: '${ApiConfig.baseUrl}/api/journeys/location-point',
        
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'x-device-id': deviceId,
        },
        
        // Adicionar journey_id a TODOS os pontos enviados
        extras: {
          'journey_id': journeyId,
        },
        
        // Configurar formato do body para o backend
        httpRootProperty: '.',
        locationTemplate: '{"journey_id":"<%= extras.journey_id %>","latitude":<%= latitude %>,"longitude":<%= longitude %>,"velocidade":<%= speed %>,"timestamp":"<%= timestamp %>"}',
        
        autoSync: true, // Sincronizar automaticamente
        autoSyncThreshold: 5, // Enviar a cada 5 pontos
        batchSync: true, // Enviar em lote
        maxBatchSize: 50, // Máximo 50 pontos por request
        maxDaysToPersist: 7, // Manter no máximo 7 dias no SQLite local
        maxRecordsToPersist: 1000, // Máximo 1000 pontos no SQLite local
        
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

  /// Sincronizar manualmente pontos pendentes
  Future<void> syncPendingLocations() async {
    try {
      debugPrint('🔄 [BG-GEO] Sincronizando pontos pendentes...');
      
      // Forçar sincronização
      await bg.BackgroundGeolocation.sync();
      debugPrint('✅ [BG-GEO] Sincronização iniciada');
    } catch (e) {
      debugPrint('❌ [BG-GEO] Erro ao sincronizar: $e');
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
  }

  void _onMotionChange(bg.Location location) {
    debugPrint('🚗 [BG-GEO] Mudança de movimento:');
    debugPrint('   - Em movimento: ${location.isMoving}');
    debugPrint('   - Velocidade: ${(location.coords.speed * 3.6).toStringAsFixed(1)} km/h');
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
    if (event.success) {
      debugPrint('✅ [BG-GEO] HTTP Success: ${event.status}');
    } else {
      debugPrint('❌ [BG-GEO] HTTP Error: ${event.status}');
      debugPrint('   Response: ${event.responseText}');
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

