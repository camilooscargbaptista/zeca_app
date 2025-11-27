import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../features/journey/domain/entities/navigation_step_entity.dart';

/// Resultado do processamento da navegação
class NavigationStatus {
  final NavigationStepEntity? currentStep;
  final double? distanceToNextMeters;
  final int? currentStepIndex;
  final bool hasReachedDestination;

  const NavigationStatus({
    this.currentStep,
    this.distanceToNextMeters,
    this.currentStepIndex,
    this.hasReachedDestination = false,
  });

  NavigationStatus copyWith({
    NavigationStepEntity? currentStep,
    double? distanceToNextMeters,
    int? currentStepIndex,
    bool? hasReachedDestination,
  }) {
    return NavigationStatus(
      currentStep: currentStep ?? this.currentStep,
      distanceToNextMeters: distanceToNextMeters ?? this.distanceToNextMeters,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      hasReachedDestination: hasReachedDestination ?? this.hasReachedDestination,
    );
  }
}

/// Serviço para processar navegação turn-by-turn em tempo real
/// 
/// Responsabilidades:
/// - Armazenar lista de steps da rota
/// - Rastrear step atual baseado na posição do motorista
/// - Calcular distância até próxima manobra
/// - Notificar mudanças via Stream
@lazySingleton
class NavigationService {
  // Lista de steps da rota
  List<NavigationStepEntity> _steps = [];
  
  // Índice do step atual (próximo a ser executado)
  int _currentStepIndex = 0;

  // Stream controller para notificar mudanças
  final _statusController = StreamController<NavigationStatus>.broadcast();

  // Threshold para considerar que passou do step (metros)
  static const double _stepCompletionThreshold = 30.0; // 30 metros

  // Threshold para considerar que chegou no destino (metros)
  static const double _destinationThreshold = 50.0; // 50 metros

  // Getter para o stream
  Stream<NavigationStatus> get statusStream => _statusController.stream;

  // Getter para steps (read-only)
  List<NavigationStepEntity> get steps => List.unmodifiable(_steps);

  // Getter para step atual
  NavigationStepEntity? get currentStep {
    if (_currentStepIndex < _steps.length) {
      return _steps[_currentStepIndex];
    }
    return null;
  }

  /// Inicializa navegação com uma nova lista de steps
  void setSteps(List<NavigationStepEntity> steps) {
    debugPrint('🧭 [Navigation] Iniciando navegação com ${steps.length} steps');
    _steps = steps;
    _currentStepIndex = 0;

    // Emitir status inicial
    _emitCurrentStatus();
  }

  /// Atualiza posição atual do motorista
  /// Calcula distância até próximo step e avança se necessário
  void updateCurrentPosition(LatLng position) {
    if (_steps.isEmpty) {
      debugPrint('⚠️ [Navigation] Sem steps carregados');
      return;
    }

    // Se já chegou no final
    if (_currentStepIndex >= _steps.length) {
      _emitDestinationReached();
      return;
    }

    final currentStep = _steps[_currentStepIndex];

    // Calcular distância até início do step atual
    final distanceToStepStart = currentStep.distanceFrom(
      position.latitude,
      position.longitude,
    );

    debugPrint('🧭 [Navigation] Step ${_currentStepIndex + 1}/${_steps.length}: '
        '${distanceToStepStart.round()}m até manobra');

    // Se passou do step atual (está muito perto do fim do step)
    final distanceToStepEnd = _calculateDistance(
      position.latitude,
      position.longitude,
      currentStep.endLat,
      currentStep.endLng,
    );

    if (distanceToStepEnd < _stepCompletionThreshold) {
      // Avançar para próximo step
      _currentStepIndex++;

      if (_currentStepIndex >= _steps.length) {
        debugPrint('✅ [Navigation] Chegou no destino!');
        _emitDestinationReached();
      } else {
        debugPrint('➡️ [Navigation] Avançando para step ${_currentStepIndex + 1}/${_steps.length}');
        _emitCurrentStatus();
      }
    } else {
      // Emitir status atual com distância atualizada
      _statusController.add(NavigationStatus(
        currentStep: currentStep,
        distanceToNextMeters: distanceToStepStart,
        currentStepIndex: _currentStepIndex,
        hasReachedDestination: false,
      ));
    }
  }

  /// Reseta navegação (limpa steps e volta ao início)
  void reset() {
    debugPrint('🔄 [Navigation] Reset');
    _steps = [];
    _currentStepIndex = 0;
  }

  /// Emite status atual
  void _emitCurrentStatus() {
    if (_currentStepIndex < _steps.length) {
      _statusController.add(NavigationStatus(
        currentStep: _steps[_currentStepIndex],
        distanceToNextMeters: null, // Será calculado no primeiro updateCurrentPosition
        currentStepIndex: _currentStepIndex,
        hasReachedDestination: false,
      ));
    }
  }

  /// Emite status de destino alcançado
  void _emitDestinationReached() {
    _statusController.add(const NavigationStatus(
      currentStep: null,
      distanceToNextMeters: null,
      currentStepIndex: null,
      hasReachedDestination: true,
    ));
  }

  /// Calcula distância entre dois pontos GPS (Haversine)
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLng = _toRadians(lng2 - lng1);

    final double a =
        (dLat / 2).sin() * (dLat / 2).sin() +
            (dLng / 2).sin() *
                (dLng / 2).sin() *
                _toRadians(lat1).cos() *
                _toRadians(lat2).cos();

    final double c = 2 * (a.sqrt().asin());
    return earthRadiusKm * c * 1000; // Retornar em metros
  }

  double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  /// Dispose para fechar o stream controller
  void dispose() {
    debugPrint('🛑 [Navigation] Dispose');
    _statusController.close();
  }
}

