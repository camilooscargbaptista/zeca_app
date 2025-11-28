import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import '../../../../core/services/api_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/token_manager_service.dart';
import '../../../../core/services/background_geolocation_service.dart';
import '../../data/services/journey_storage_service.dart';
import '../../data/models/journey_model.dart';
import '../../domain/entities/journey_entity.dart';
import '../../domain/entities/location_point_entity.dart';
import 'journey_event.dart';
import 'journey_state.dart';

class JourneyBloc extends Bloc<JourneyEvent, JourneyState> {
  final ApiService _apiService;
  final LocationService _locationService;
  final JourneyStorageService _storageService;
  final TokenManagerService _tokenManager = TokenManagerService();
  final BackgroundGeolocationService _bgGeoService = BackgroundGeolocationService();

  Timer? _timer; // Timer para cronômetro
  LocationPointEntity? _lastPoint;
  DateTime? _journeyStartTime;
  DateTime? _restStartTime;
  bool _isTracking = false;

  JourneyBloc({
    required ApiService apiService,
    required LocationService locationService,
    required JourneyStorageService storageService,
  })  : _apiService = apiService,
        _locationService = locationService,
        _storageService = storageService,
        super(const JourneyInitial()) {
    on<LoadActiveJourney>(_onLoadActiveJourney);
    on<StartJourney>(_onStartJourney);
    on<AddLocationPoint>(_onAddLocationPoint);
    on<ToggleRest>(_onToggleRest);
    on<FinishJourney>(_onFinishJourney);
    on<CancelJourney>(_onCancelJourney);
    on<SyncPendingPoints>(_onSyncPendingPoints);
    on<UpdateJourneyTimer>(_onUpdateJourneyTimer);
  }

  Future<void> _onLoadActiveJourney(
    LoadActiveJourney event,
    Emitter<JourneyState> emit,
  ) async {
    emit(const JourneyLoading());

    try {
      // Tentar carregar do storage local primeiro
      final localJourney = _storageService.getActiveJourney();
      if (localJourney != null && localJourney.isActive) {
        // Iniciar renovação automática de token durante a jornada
        _tokenManager.startAutoRefresh();
        
        // ⚠️ CRÍTICO: Iniciar tracking ANTES de emitir JourneyLoaded
        debugPrint('🔍 [JourneyBloc] Iniciando tracking ANTES de emitir JourneyLoaded (local)');
        await _startTracking(localJourney);
        debugPrint('✅ [JourneyBloc] Tracking iniciado, agora emitindo JourneyLoaded (local)');
        
        emit(JourneyLoaded(
          journey: localJourney,
          tempoDecorridoSegundos: localJourney.tempoDirecaoSegundos,
          kmPercorridos: localJourney.kmPercorridos,
        ));
        return;
      }

      // Tentar carregar do backend
      final response = await _apiService.getActiveJourney();
      if (response['success'] == true && response['data'] != null) {
        final journeyModel = JourneyModel.fromJson(response['data']);
        final journey = journeyModel.toEntity();
        await _storageService.saveJourney(journey);
        await _storageService.setActiveJourney(journey.id);
        
        // Iniciar renovação automática de token durante a jornada
        _tokenManager.startAutoRefresh();
        
        // ⚠️ CRÍTICO: Iniciar tracking ANTES de emitir JourneyLoaded
        debugPrint('🔍 [JourneyBloc] Iniciando tracking ANTES de emitir JourneyLoaded (backend)');
        await _startTracking(journey);
        debugPrint('✅ [JourneyBloc] Tracking iniciado, agora emitindo JourneyLoaded (backend)');
        
        emit(JourneyLoaded(
          journey: journey,
          tempoDecorridoSegundos: journey.tempoDirecaoSegundos,
          kmPercorridos: journey.kmPercorridos,
        ));
      } else {
        // Se não há jornada ativa (404) ou erro, emitir estado inicial
        // 404 não é erro - é comportamento esperado quando não há jornada ativa
        emit(const JourneyInitial());
      }
    } catch (e) {
      emit(JourneyError('Erro ao carregar jornada: $e'));
    }
  }

  Future<void> _onStartJourney(
    StartJourney event,
    Emitter<JourneyState> emit,
  ) async {
    emit(const JourneyLoading());

    try {
      // Validar placa primeiro (mesma validação de abastecimento)
      final vehicleResponse = await _apiService.searchVehicle(event.placa);
      if (vehicleResponse['success'] != true) {
        emit(JourneyError(vehicleResponse['error'] ?? 'Veículo não encontrado'));
        return;
      }

      // Solicitar permissão de localização (foreground)
      final hasPermission = await _locationService.requestPermission();
      if (!hasPermission) {
        emit(const JourneyError('Permissão de localização necessária'));
        return;
      }

      // Solicitar permissão de background para rastreamento contínuo
      final hasBackgroundPermission = await _locationService.requestBackgroundPermission();
      if (!hasBackgroundPermission) {
        debugPrint('⚠️ Permissão de background não concedida, mas continuando com foreground');
        // Não bloqueia, mas avisa que pode ter limitações
      } else {
        debugPrint('✅ Permissão de background concedida');
      }

      // Iniciar jornada no backend
      final response = await _apiService.startJourney(
        placa: event.placa,
        odometroInicial: event.odometroInicial,
        destino: event.destino,
        previsaoKm: event.previsaoKm,
        observacoes: event.observacoes,
      );

      if (response['success'] == true) {
        final journeyModel = JourneyModel.fromJson(response['data']);
        final journey = journeyModel.toEntity();
        
        await _storageService.saveJourney(journey);
        await _storageService.setActiveJourney(journey.id);
        
        _journeyStartTime = DateTime.now();
        
        // Iniciar renovação automática de token durante a jornada
        _tokenManager.startAutoRefresh();
        
        // ⚠️ CRÍTICO: Iniciar tracking ANTES de emitir JourneyLoaded
        // Isso previne race condition e garante que GPS está ativo quando UI atualiza
        debugPrint('🔍 [JourneyBloc] Iniciando tracking ANTES de emitir JourneyLoaded');
        await _startTracking(journey);
        debugPrint('✅ [JourneyBloc] Tracking iniciado, agora emitindo JourneyLoaded');
        
        emit(JourneyLoaded(
          journey: journey,
          tempoDecorridoSegundos: 0,
          kmPercorridos: 0.0,
        ));
      } else {
        emit(JourneyError(response['error'] ?? 'Erro ao iniciar jornada'));
      }
    } catch (e) {
      emit(JourneyError('Erro ao iniciar jornada: $e'));
    }
  }

  Future<void> _onAddLocationPoint(
    AddLocationPoint event,
    Emitter<JourneyState> emit,
  ) async {
    if (state is! JourneyLoaded) return;

    final currentState = state as JourneyLoaded;
    final journey = currentState.journey;

    try {
      // Criar ponto de localização
      final point = LocationPointEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        journeyId: journey.id,
        latitude: event.latitude,
        longitude: event.longitude,
        velocidade: event.velocidade,
        timestamp: event.timestamp,
        sincronizado: false,
        createdAt: DateTime.now(),
      );

      // Calcular distância desde o último ponto
      double distanciaKm = 0.0;
      if (_lastPoint != null) {
        distanciaKm = _calculateDistance(
          _lastPoint!.latitude,
          _lastPoint!.longitude,
          event.latitude,
          event.longitude,
        );
      }

      debugPrint('📍 [AddPoint] Novo ponto: lat=${event.latitude.toStringAsFixed(6)}, lng=${event.longitude.toStringAsFixed(6)}, vel=${event.velocidade.toStringAsFixed(1)} km/h, dist=${(distanciaKm * 1000).toStringAsFixed(1)}m');

      // IMPORTANTE: Salvar ponto localmente PRIMEIRO (antes de qualquer outra operação)
      // Isso garante que o ponto nunca seja perdido, mesmo se houver erro depois
      await _storageService.saveLocationPoint(point);
      debugPrint('💾 [AddPoint] Ponto salvo no banco local: id=${point.id}, lat=${point.latitude}, lng=${point.longitude}');

      // Atualizar jornada
      final updatedKm = currentState.kmPercorridos + distanciaKm;
      
      // Atualizar velocidade máxima se necessário
      double? novaVelocidadeMaxima = journey.velocidadeMaxima;
      double? novaLatVelocidadeMaxima = journey.latVelocidadeMaxima;
      double? novaLongVelocidadeMaxima = journey.longVelocidadeMaxima;
      
      if (event.velocidade > (novaVelocidadeMaxima ?? 0.0)) {
        novaVelocidadeMaxima = event.velocidade;
        novaLatVelocidadeMaxima = event.latitude;
        novaLongVelocidadeMaxima = event.longitude;
        debugPrint('🏎️ [AddPoint] Nova velocidade máxima: ${event.velocidade.toStringAsFixed(1)} km/h');
      }
      final updatedJourney = JourneyEntity(
        id: journey.id,
        driverId: journey.driverId,
        vehicleId: journey.vehicleId,
        placa: journey.placa,
        odometroInicial: journey.odometroInicial,
        destino: journey.destino,
        previsaoKm: journey.previsaoKm,
        observacoes: journey.observacoes,
        dataInicio: journey.dataInicio,
        dataFim: journey.dataFim,
        status: journey.status,
        tempoDirecaoSegundos: currentState.tempoDecorridoSegundos,
        tempoDescansoSegundos: journey.tempoDescansoSegundos,
        kmPercorridos: updatedKm,
        velocidadeMedia: journey.velocidadeMedia,
        velocidadeMaxima: novaVelocidadeMaxima,
        latVelocidadeMaxima: novaLatVelocidadeMaxima,
        longVelocidadeMaxima: novaLongVelocidadeMaxima,
        createdAt: journey.createdAt,
        updatedAt: DateTime.now(),
      );

      await _storageService.saveJourney(updatedJourney);
      _lastPoint = point;

      // Tentar sincronizar ponto (em background)
      _syncPointInBackground(point);

      emit(currentState.copyWith(
        journey: updatedJourney,
        kmPercorridos: updatedKm,
        locationPoints: [...currentState.locationPoints, point],
      ));
    } catch (e) {
      // Não emitir erro para não interromper o rastreamento
      debugPrint('❌ [AddPoint] Erro ao adicionar ponto: $e');
    }
  }

  Future<void> _onToggleRest(
    ToggleRest event,
    Emitter<JourneyState> emit,
  ) async {
    if (state is! JourneyLoaded) return;

    final currentState = state as JourneyLoaded;
    final journey = currentState.journey;

    try {
      // Garantir token válido antes de operação crítica
      final tokenValid = await _tokenManager.ensureValidToken();
      if (!tokenValid) {
        emit(const JourneyError('Erro de autenticação. Tente novamente.'));
        return;
      }

      final response = await _apiService.toggleRest(
        journeyId: journey.id,
        isStartingRest: event.isStartingRest,
      );

      if (response['success'] == true) {
        if (event.isStartingRest) {
          _restStartTime = DateTime.now();
          // Pausar tracking durante descanso
          await _bgGeoService.pauseTracking();
          debugPrint('⏸️ [Rest] Tracking pausado');
        } else {
          if (_restStartTime != null) {
            final restDuration = DateTime.now().difference(_restStartTime!).inSeconds;
            final updatedJourney = JourneyEntity(
              id: journey.id,
              driverId: journey.driverId,
              vehicleId: journey.vehicleId,
              placa: journey.placa,
              odometroInicial: journey.odometroInicial,
              destino: journey.destino,
              previsaoKm: journey.previsaoKm,
              observacoes: journey.observacoes,
              dataInicio: journey.dataInicio,
              dataFim: journey.dataFim,
              status: journey.status,
              tempoDirecaoSegundos: journey.tempoDirecaoSegundos,
              tempoDescansoSegundos: journey.tempoDescansoSegundos + restDuration,
              kmPercorridos: journey.kmPercorridos,
              velocidadeMedia: journey.velocidadeMedia,
              velocidadeMaxima: journey.velocidadeMaxima,
              latVelocidadeMaxima: journey.latVelocidadeMaxima,
              longVelocidadeMaxima: journey.longVelocidadeMaxima,
              createdAt: journey.createdAt,
              updatedAt: DateTime.now(),
            );
            await _storageService.saveJourney(updatedJourney);
            emit(currentState.copyWith(
              journey: updatedJourney,
              emDescanso: false,
            ));
          }
          _restStartTime = null;
          // Retomar tracking após descanso
          await _bgGeoService.resumeTracking();
          debugPrint('▶️ [Rest] Tracking retomado');
        }

        emit(currentState.copyWith(emDescanso: event.isStartingRest));
      } else {
        emit(JourneyError(response['error'] ?? 'Erro ao alterar status de descanso'));
      }
    } catch (e) {
      // 🔧 TRATAR ERRO 409 (Descanso já ativo/inativo)
      final errorMessage = e.toString();
      if (errorMessage.contains('409') || errorMessage.contains('Já existe um período de descanso')) {
        debugPrint('⚠️ [Rest] Erro 409: Estado dessincronizado. Recarregando do backend...');
        // Recarregar jornada do backend para sincronizar estado
        try {
          final journeyResponse = await _apiService.getActiveJourney();
          if (journeyResponse['success'] == true && journeyResponse['data'] != null) {
            final journeyModel = JourneyModel.fromJson(journeyResponse['data']);
            final updatedJourney = journeyModel.toEntity();
            // Sincronizar estado de descanso baseado no backend
            final hasActiveRest = journeyResponse['data']['active_rest_period'] != null;
            emit(currentState.copyWith(
              journey: updatedJourney,
              emDescanso: hasActiveRest,
            ));
            debugPrint('✅ [Rest] Estado sincronizado: emDescanso=$hasActiveRest');
          }
        } catch (syncError) {
          debugPrint('❌ [Rest] Erro ao sincronizar estado: $syncError');
          emit(const JourneyError('Estado dessincronizado. Por favor, reinicie a viagem.'));
        }
      } else {
        emit(JourneyError('Erro ao alterar status de descanso: $e'));
      }
    }
  }

  Future<void> _onFinishJourney(
    FinishJourney event,
    Emitter<JourneyState> emit,
  ) async {
    if (state is! JourneyLoaded) return;

    final currentState = state as JourneyLoaded;
    final journey = currentState.journey;

    emit(const JourneyLoading());

    try {
      // ANTES de finalizar, sincronizar TODOS os pontos pendentes
      debugPrint('🔄 [Finish] ========================================');
      debugPrint('🔄 [Finish] Sincronizando TODOS os pontos pendentes antes de finalizar...');
      
      final totalPointsBefore = _storageService.getAllPoints(journey.id).length;
      final unsyncedBefore = _storageService.countUnsyncedPoints(journey.id);
      debugPrint('📊 [Finish] Status inicial: $totalPointsBefore pontos totais, $unsyncedBefore não sincronizados');
      
      // Tentar sincronizar até 3 vezes se necessário
      int maxRetries = 3;
      for (int retry = 1; retry <= maxRetries; retry++) {
        await _syncPendingPoints();
        
        final unsyncedAfter = _storageService.countUnsyncedPoints(journey.id);
        debugPrint('📊 [Finish] Após tentativa $retry: $unsyncedAfter pontos ainda não sincronizados');
        
        if (unsyncedAfter == 0) {
          debugPrint('✅ [Finish] Todos os pontos foram sincronizados!');
          break;
        }
        
        if (retry < maxRetries) {
          debugPrint('⚠️ [Finish] Tentando novamente em 3 segundos...');
          await Future.delayed(const Duration(seconds: 3));
        } else {
          debugPrint('⚠️ [Finish] ATENÇÃO: Ainda há $unsyncedAfter pontos não sincronizados após $maxRetries tentativas.');
          debugPrint('⚠️ [Finish] Continuando finalização, mas alguns pontos podem não ter sido enviados.');
        }
      }
      
      debugPrint('🔄 [Finish] ========================================');
      
      // Garantir token válido antes de operação crítica
      final tokenValid = await _tokenManager.ensureValidToken();
      if (!tokenValid) {
        emit(const JourneyError('Erro de autenticação. Tente novamente.'));
        return;
      }

      // Finalizar jornada
      final response = await _apiService.finishJourney(
        journeyId: journey.id,
        odometroFinal: event.odometroFinal,
      );

      if (response['success'] == true) {
        final journeyModel = JourneyModel.fromJson(response['data']);
        final finishedJourney = journeyModel.toEntity();
        
        await _storageService.saveJourney(finishedJourney);
        await _storageService.setActiveJourney(null);
        
        // Parar renovação automática de token
        _tokenManager.stopAutoRefresh();
        
        _stopTracking();
        
        emit(JourneyFinished(journey: finishedJourney));
      } else {
        emit(JourneyError(response['error'] ?? 'Erro ao finalizar jornada'));
      }
    } catch (e) {
      emit(JourneyError('Erro ao finalizar jornada: $e'));
    }
  }

  Future<void> _onCancelJourney(
    CancelJourney event,
    Emitter<JourneyState> emit,
  ) async {
    if (state is! JourneyLoaded) return;

    final currentState = state as JourneyLoaded;
    final journey = currentState.journey;

    emit(const JourneyLoading());

    try {
      // Garantir token válido antes de operação crítica
      final tokenValid = await _tokenManager.ensureValidToken();
      if (!tokenValid) {
        emit(const JourneyError('Erro de autenticação. Tente novamente.'));
        return;
      }

      final response = await _apiService.cancelJourney(journey.id);
      if (response['success'] == true) {
        await _storageService.deleteJourney(journey.id);
        
        // Parar renovação automática de token
        _tokenManager.stopAutoRefresh();
        
        _stopTracking();
        emit(const JourneyInitial());
      } else {
        emit(JourneyError(response['error'] ?? 'Erro ao cancelar jornada'));
      }
    } catch (e) {
      emit(JourneyError('Erro ao cancelar jornada: $e'));
    }
  }

  Future<void> _onSyncPendingPoints(
    SyncPendingPoints event,
    Emitter<JourneyState> emit,
  ) async {
    await _syncPendingPoints();
  }

  void _onUpdateJourneyTimer(
    UpdateJourneyTimer event,
    Emitter<JourneyState> emit,
  ) {
    if (state is! JourneyLoaded) return;

    final currentState = state as JourneyLoaded;
    final journey = currentState.journey;

    if (_journeyStartTime == null) return;

    final now = DateTime.now();
    final elapsed = now.difference(_journeyStartTime!).inSeconds;
    final restTime = _restStartTime != null 
        ? now.difference(_restStartTime!).inSeconds 
        : 0;

    final drivingTime = elapsed - restTime - journey.tempoDescansoSegundos;

    emit(currentState.copyWith(
      tempoDecorridoSegundos: drivingTime > 0 ? drivingTime : 0,
    ));
  }

  // ============================================================
  // HELPERS - Rastreamento GPS (Background Geolocation)
  // ============================================================

  Future<void> _startTracking(JourneyEntity journey) async {
    debugPrint('🔍 [Tracking] _startTracking CHAMADO para journey: ${journey.id}');
    debugPrint('🔍 [Tracking] _isTracking atual: $_isTracking');
    
    if (_isTracking) {
      debugPrint('⚠️ [Tracking] Já está ativo');
      return;
    }

    try {
      debugPrint('🚀 [Tracking] Iniciando tracking para jornada: ${journey.id}');

    _isTracking = true;
    _journeyStartTime = journey.dataInicio;
    _lastPoint = null;

    // Timer para atualizar cronômetro a cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const UpdateJourneyTimer());
    });

      // Configurar listener para receber localizações do plugin
      bg.BackgroundGeolocation.onLocation((bg.Location location) {
        if (!_isTracking) return;
        
        final currentState = state;
        if (currentState is! JourneyLoaded) return;
        if (currentState.emDescanso) return; // Não rastrear durante descanso

        final velocidadeKmh = location.coords.speed * 3.6; // m/s para km/h
        
        // Usar hora local do dispositivo (Brasil)
        final timestampLocal = DateTime.now();
        
        // Debug: comparar timestamps
        final timestampPlugin = DateTime.parse(location.timestamp);
        debugPrint('📍 [BG-GEO Location] Recebido do plugin:');
        debugPrint('   - Lat/Lng: ${location.coords.latitude}, ${location.coords.longitude}');
        debugPrint('   - Velocidade: ${velocidadeKmh.toStringAsFixed(1)} km/h');
        debugPrint('   - Em movimento: ${location.isMoving}');
        debugPrint('   - Odômetro: ${location.odometer}m');
        debugPrint('   - Timestamp Plugin: ${location.timestamp}');
        debugPrint('   - Timestamp Parsed: $timestampPlugin');
        debugPrint('   - Timestamp Local (usando): $timestampLocal');
        debugPrint('   - Diferença: ${timestampLocal.difference(timestampPlugin).inHours}h');

        // Adicionar ponto ao BLoC usando hora local do dispositivo
            add(AddLocationPoint(
          latitude: location.coords.latitude,
          longitude: location.coords.longitude,
              velocidade: velocidadeKmh.isNaN ? 0.0 : velocidadeKmh,
          timestamp: timestampLocal, // ✅ Usar hora local do dispositivo
        ));
      });

      // Iniciar tracking com o BackgroundGeolocationService
      await _bgGeoService.startTracking(journey.id);

      debugPrint('✅ [Tracking] BackgroundGeolocation iniciado com sucesso');
    } catch (e) {
      debugPrint('❌ [Tracking] Erro ao iniciar: $e');
      _isTracking = false;
      rethrow;
    }
  }

  Future<void> _stopTracking() async {
    if (!_isTracking) {
      debugPrint('⚠️ [Tracking] Já está inativo');
      return;
            }

    try {
      debugPrint('🛑 [Tracking] Parando tracking...');

    _isTracking = false;
      
      // Parar timer do cronômetro
    _timer?.cancel();
    _timer = null;
      
      // Parar BackgroundGeolocation
      await _bgGeoService.stopTracking();
      
      // Limpar estados
    _lastPoint = null;
    _journeyStartTime = null;
    _restStartTime = null;

      debugPrint('✅ [Tracking] BackgroundGeolocation parado com sucesso');
    } catch (e) {
      debugPrint('❌ [Tracking] Erro ao parar: $e');
    }
  }

  // ============================================================
  // HELPERS - Sincronização (complementar ao BackgroundGeolocation)
  // ============================================================

  // NOTA: O BackgroundGeolocation já faz auto-sync automaticamente.
  // Este método é apenas para garantir que pontos do nosso storage local
  // sejam sincronizados (caso haja algum que não foi pego pelo plugin).
  Future<void> _syncPointInBackground(LocationPointEntity point) async {
    // O plugin cuida da sincronização automaticamente
    // Apenas salvamos localmente para ter histórico
    debugPrint('💾 [Sync] Ponto salvo localmente (plugin cuida do sync): id=${point.id}');
  }

  Future<void> _syncPendingPoints() async {
    try {
      debugPrint('🔄 [Sync] Forçando sincronização de pontos pendentes do plugin...');

      // Forçar sincronização dos pontos pendentes do BackgroundGeolocation
      await _bgGeoService.syncPendingLocations();
      
      debugPrint('✅ [Sync] Sincronização manual solicitada ao plugin');
    } catch (e) {
      debugPrint('❌ [Sync] Erro ao sincronizar: $e');
    }
  }

  // ============================================================
  // HELPERS - Cálculos
  // ============================================================

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Raio da Terra em km

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Future<void> close() {
    _stopTracking();
    return super.close();
  }
}

