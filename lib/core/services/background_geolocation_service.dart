// =============================================================================
// ARQUIVO TEMPORARIAMENTE DESATIVADO
// =============================================================================
// Motivo: A dependência flutter_background_geolocation foi removida do pubspec.yaml
// para facilitar publicação nas stores (permissões sensíveis).
//
// Este arquivo será reativado quando:
// 1. Decidirmos implementar tracking em background novamente
// 2. Tivermos justificativa aprovada para ACCESS_BACKGROUND_LOCATION
//
// Data: 12/12/2025
// Branch: feature/store-preparation
// =============================================================================

/*
// CÓDIGO ORIGINAL COMENTADO - NÃO REMOVER
// TODO: Reativar quando flutter_background_geolocation voltar

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
...
(código original mantido no histórico git)
*/

// =============================================================================
// PLACEHOLDER - Serviço stub que mantém a interface mas não faz nada
// =============================================================================

import 'package:flutter/foundation.dart';

/// Placeholder para BackgroundGeolocationService
/// 
/// IMPORTANTE: Este é um stub que não faz tracking real.
/// O tracking em background foi desativado para publicação nas stores.
/// Use geolocator para localização em foreground.
class BackgroundGeolocationService {
  static final BackgroundGeolocationService _instance = BackgroundGeolocationService._internal();
  factory BackgroundGeolocationService() => _instance;
  BackgroundGeolocationService._internal();

  bool _isTracking = false;
  String? _currentJourneyId;

  /// Inicializar - NÃO FAZ NADA (placeholder)
  Future<void> initialize() async {
    debugPrint('⚠️ [BG-GEO] PLACEHOLDER - Background geolocation desativado');
  }

  /// Iniciar tracking - NÃO FAZ NADA (placeholder)
  Future<void> startTracking(String journeyId) async {
    debugPrint('⚠️ [BG-GEO] PLACEHOLDER - startTracking($journeyId) - DESATIVADO');
    _currentJourneyId = journeyId;
    _isTracking = true;
  }

  /// Parar tracking - NÃO FAZ NADA (placeholder)
  Future<void> stopTracking() async {
    debugPrint('⚠️ [BG-GEO] PLACEHOLDER - stopTracking() - DESATIVADO');
    _isTracking = false;
    _currentJourneyId = null;
  }

  /// Pausar tracking - NÃO FAZ NADA (placeholder)
  Future<void> pauseTracking() async {
    debugPrint('⚠️ [BG-GEO] PLACEHOLDER - pauseTracking() - DESATIVADO');
  }

  /// Retomar tracking - NÃO FAZ NADA (placeholder)
  Future<void> resumeTracking() async {
    debugPrint('⚠️ [BG-GEO] PLACEHOLDER - resumeTracking() - DESATIVADO');
  }

  /// Sincronizar - NÃO FAZ NADA (placeholder)
  Future<void> syncPendingLocations() async {
    debugPrint('⚠️ [BG-GEO] PLACEHOLDER - syncPendingLocations() - DESATIVADO');
  }

  /// Obter posição atual - RETORNA NULL (placeholder)
  Future<dynamic> getCurrentPosition() async {
    debugPrint('⚠️ [BG-GEO] PLACEHOLDER - getCurrentPosition() - DESATIVADO');
    return null;
  }

  /// Obter status
  Future<Map<String, dynamic>> getStatus() async {
    return {
      'is_tracking': _isTracking,
      'journey_id': _currentJourneyId,
      'enabled': false,
      'tracking_mode': 'DISABLED',
      'odometer': 0,
      'note': 'Background geolocation desativado para publicação nas stores',
    };
  }

  bool get isTracking => _isTracking;
  String? get currentJourneyId => _currentJourneyId;
}
