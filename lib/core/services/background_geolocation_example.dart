/// EXEMPLO DE USO: BackgroundGeolocationService
/// 
/// Este arquivo mostra como usar o novo service de tracking.
/// Copie e adapte para seu caso de uso.

import 'background_geolocation_service.dart';

class ExampleUsage {
  final _bgGeo = BackgroundGeolocationService();

  /// EXEMPLO 1: Iniciar tracking ao começar jornada
  Future<void> startJourney(String journeyId) async {
    try {
      // 1. Inicializar o service (se ainda não foi)
      await _bgGeo.initialize();
      
      // 2. Iniciar tracking
      await _bgGeo.startTracking(journeyId);
      
      print('✅ Jornada iniciada com tracking ativo');
    } catch (e) {
      print('❌ Erro ao iniciar jornada: $e');
    }
  }

  /// EXEMPLO 2: Pausar tracking durante descanso
  Future<void> startRest() async {
    try {
      await _bgGeo.pauseTracking();
      print('⏸️ Tracking pausado (descanso)');
    } catch (e) {
      print('❌ Erro ao pausar: $e');
    }
  }

  /// EXEMPLO 3: Retomar tracking após descanso
  Future<void> endRest() async {
    try {
      await _bgGeo.resumeTracking();
      print('▶️ Tracking retomado');
    } catch (e) {
      print('❌ Erro ao retomar: $e');
    }
  }

  /// EXEMPLO 4: Finalizar jornada
  Future<void> finishJourney() async {
    try {
      // Sincronizar pontos pendentes antes de parar
      await _bgGeo.syncPendingLocations();
      
      // Parar tracking
      await _bgGeo.stopTracking();
      
      print('✅ Jornada finalizada');
    } catch (e) {
      print('❌ Erro ao finalizar: $e');
    }
  }

  /// EXEMPLO 5: Obter posição atual (pontual)
  Future<void> getCurrentLocation() async {
    try {
      final location = await _bgGeo.getCurrentPosition();
      
      if (location != null) {
        print('📍 Posição atual:');
        print('   Lat: ${location.coords.latitude}');
        print('   Lng: ${location.coords.longitude}');
        print('   Velocidade: ${(location.coords.speed * 3.6).toStringAsFixed(1)} km/h');
      }
    } catch (e) {
      print('❌ Erro ao obter posição: $e');
    }
  }

  /// EXEMPLO 6: Verificar status do tracking
  Future<void> checkStatus() async {
    try {
      final status = await _bgGeo.getStatus();
      
      print('📊 Status do tracking:');
      print('   - Ativo: ${status['is_tracking']}');
      print('   - Journey ID: ${status['journey_id']}');
      print('   - Pontos pendentes: ${status['pending_locations']}');
      print('   - Odômetro: ${status['odometer']}m');
    } catch (e) {
      print('❌ Erro ao verificar status: $e');
    }
  }

  /// EXEMPLO 7: Sincronizar manualmente
  Future<void> syncManually() async {
    try {
      await _bgGeo.syncPendingLocations();
      print('✅ Sincronização manual concluída');
    } catch (e) {
      print('❌ Erro na sincronização: $e');
    }
  }
}

/// MIGRAÇÃO DO CÓDIGO ANTIGO (Geolocator) PARA O NOVO (BackgroundGeolocation)
/// 
/// ANTES (com Geolocator):
/// ```dart
/// _positionStream = Geolocator.getPositionStream(
///   locationSettings: locationSettings,
/// ).listen((position) {
///   // Processar posição
///   add(AddLocationPoint(...));
/// });
/// ```
/// 
/// DEPOIS (com BackgroundGeolocation):
/// ```dart
/// await BackgroundGeolocationService().startTracking(journeyId);
/// // O plugin cuida de tudo automaticamente!
/// // - Captura
/// - Persistência local
/// // - Sincronização com API
/// // - Motion detection
/// // - Economia de bateria
/// ```
/// 
/// VANTAGENS DO NOVO SISTEMA:
/// ✅ Funciona em background (app fechado)
/// ✅ Sobrevive a otimizações de bateria
/// ✅ Auto-sync com API
/// ✅ Motion detection (economiza bateria)
/// ✅ Persistência local (SQLite)
/// ✅ Retry automático se falhar
/// ✅ Heartbeat quando parado
/// ✅ Logs detalhados

