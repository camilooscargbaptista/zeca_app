import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_keys.dart';
import '../../features/journey/domain/entities/navigation_step_entity.dart';
import '../utils/navigation_utils.dart';

/// Modelo para uma rota calculada (versão simples, sem steps)
class RouteResult {
  final double distanceKm;
  final int durationMinutes;
  final String? polyline; // Para desenhar no mapa (opcional)

  RouteResult({
    required this.distanceKm,
    required this.durationMinutes,
    this.polyline,
  });

  /// Formata o tempo em horas e minutos (ex: "3h 43min")
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '$durationMinutes min';
    }
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}min';
  }

  @override
  String toString() => '${distanceKm.toStringAsFixed(1)} km, $formattedDuration';
}

/// Modelo para uma rota calculada COM instruções turn-by-turn
class RouteResultWithSteps extends RouteResult {
  final List<NavigationStepEntity> steps;

  RouteResultWithSteps({
    required super.distanceKm,
    required super.durationMinutes,
    required super.polyline,
    required this.steps,
  });

  @override
  String toString() => '${super.toString()}, ${steps.length} steps';
}

/// Serviço para calcular rotas usando Google Directions API
class DirectionsService {
  // API Key obtida de forma segura via ApiKeys
  String get _apiKey => ApiKeys.googleMapsApiKey;
  
  final Dio _dio = Dio();

  DirectionsService() {
    _dio.options.baseUrl = 'https://maps.googleapis.com/maps/api';
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  /// Calcula rota entre origem e destino
  /// Retorna distância em KM e tempo estimado em minutos
  /// vehicleType: 'car', 'truck', 'motorcycle', 'bicycle', 'walking' (padrão: 'car')
  Future<RouteResult?> calculateRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? language = 'pt-BR',
    String? vehicleType = 'car', // 'car', 'truck', etc.
  }) async {
    try {
      debugPrint('🗺️ [Directions] Calculando rota: ($originLat, $originLng) → ($destLat, $destLng)');

      // Determinar modo baseado no tipo de veículo
      // Google Directions API suporta: driving, walking, bicycling, transit
      // Para caminhões, ainda usamos 'driving', mas podemos adicionar restrições depois
      String mode = 'driving';
      if (vehicleType == 'walking') {
        mode = 'walking';
      } else if (vehicleType == 'bicycle') {
        mode = 'bicycling';
      }
      // Para 'car' e 'truck', ambos usam 'driving'
      
      final response = await _dio.get(
        '/directions/json',
        queryParameters: {
          'origin': '$originLat,$originLng',
          'destination': '$destLat,$destLng',
          'key': _apiKey,
          'language': language ?? 'pt-BR',
          'units': 'metric', // Usar sistema métrico (km)
          'mode': mode, // Modo baseado no tipo de veículo
          'alternatives': false, // Apenas a rota principal
          // Para caminhões, podemos adicionar 'avoid' depois se necessário
          // 'avoid': vehicleType == 'truck' ? 'tolls' : null,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final routes = response.data['routes'] as List?;
        
        if (routes == null || routes.isEmpty) {
          debugPrint('⚠️ [Directions] Nenhuma rota encontrada');
          return null;
        }

        final route = routes[0] as Map<String, dynamic>;
        final legs = route['legs'] as List?;
        
        if (legs == null || legs.isEmpty) {
          debugPrint('⚠️ [Directions] Nenhum trecho encontrado na rota');
          return null;
        }

        // Somar distância e duração de todos os trechos
        double totalDistanceMeters = 0;
        int totalDurationSeconds = 0;

        for (final leg in legs) {
          final distance = leg['distance'] as Map<String, dynamic>;
          final duration = leg['duration'] as Map<String, dynamic>;
          
          totalDistanceMeters += (distance['value'] as num).toDouble();
          totalDurationSeconds += (duration['value'] as num).toInt();
        }

        final distanceKm = totalDistanceMeters / 1000.0;
        final durationMinutes = (totalDurationSeconds / 60.0).round();

        // Obter polyline (opcional, para desenhar no mapa)
        final overviewPolyline = route['overview_polyline'] as Map<String, dynamic>?;
        final polyline = overviewPolyline?['points'] as String?;

        final result = RouteResult(
          distanceKm: distanceKm,
          durationMinutes: durationMinutes,
          polyline: polyline,
        );

        debugPrint('✅ [Directions] Rota calculada: ${result.distanceKm.toStringAsFixed(1)} km, ${result.durationMinutes} min');
        return result;
      } else {
        final status = response.data['status'] as String?;
        final errorMessage = response.data['error_message'] as String?;
        debugPrint('❌ [Directions] Erro ao calcular rota: $status - $errorMessage');
        return null;
      }
    } catch (e) {
      debugPrint('❌ [Directions] Erro ao calcular rota: $e');
      return null;
    }
  }

  /// Calcula rota COM instruções turn-by-turn (steps)
  /// Retorna distância, tempo, polyline E lista de steps para navegação
  Future<RouteResultWithSteps?> calculateRouteWithSteps({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? language = 'pt-BR',
    String? vehicleType = 'car',
  }) async {
    try {
      debugPrint('🗺️ [Directions] Calculando rota COM steps: ($originLat, $originLng) → ($destLat, $destLng)');

      // Determinar modo
      String mode = 'driving';
      if (vehicleType == 'walking') {
        mode = 'walking';
      } else if (vehicleType == 'bicycle') {
        mode = 'bicycling';
      }

      final response = await _dio.get(
        '/directions/json',
        queryParameters: {
          'origin': '$originLat,$originLng',
          'destination': '$destLat,$destLng',
          'key': _apiKey,
          'language': language ?? 'pt-BR',
          'units': 'metric',
          'mode': mode,
          'alternatives': false,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final routes = response.data['routes'] as List?;

        if (routes == null || routes.isEmpty) {
          debugPrint('⚠️ [Directions] Nenhuma rota encontrada');
          return null;
        }

        final route = routes[0] as Map<String, dynamic>;
        final legs = route['legs'] as List?;

        if (legs == null || legs.isEmpty) {
          debugPrint('⚠️ [Directions] Nenhum leg encontrado na rota');
          return null;
        }

        // Processar totais e steps
        double totalDistanceMeters = 0;
        int totalDurationSeconds = 0;
        final List<NavigationStepEntity> allSteps = [];

        for (final leg in legs) {
          final distance = leg['distance'] as Map<String, dynamic>;
          final duration = leg['duration'] as Map<String, dynamic>;

          totalDistanceMeters += (distance['value'] as num).toDouble();
          totalDurationSeconds += (duration['value'] as num).toInt();

          // Processar steps deste leg
          final steps = leg['steps'] as List?;
          if (steps != null) {
            for (final step in steps) {
              try {
                final stepDistance = step['distance'] as Map<String, dynamic>;
                final stepDuration = step['duration'] as Map<String, dynamic>;
                final htmlInstructions = step['html_instructions'] as String?;
                final maneuver = step['maneuver'] as String?;

                // Coordenadas de início e fim do step
                final startLocation = step['start_location'] as Map<String, dynamic>;
                final endLocation = step['end_location'] as Map<String, dynamic>;

                // Limpar HTML das instruções
                final cleanInstruction = htmlInstructions != null
                    ? NavigationUtils.stripHtmlTags(htmlInstructions)
                    : 'Siga em frente';

                final navigationStep = NavigationStepEntity(
                  instruction: cleanInstruction,
                  maneuver: maneuver,
                  distanceMeters: (stepDistance['value'] as num).toDouble(),
                  durationSeconds: (stepDuration['value'] as num).toInt(),
                  startLat: (startLocation['lat'] as num).toDouble(),
                  startLng: (startLocation['lng'] as num).toDouble(),
                  endLat: (endLocation['lat'] as num).toDouble(),
                  endLng: (endLocation['lng'] as num).toDouble(),
                );

                allSteps.add(navigationStep);
              } catch (e) {
                debugPrint('⚠️ [Directions] Erro ao processar step: $e');
                // Continuar processando outros steps
              }
            }
          }
        }

        final distanceKm = totalDistanceMeters / 1000.0;
        final durationMinutes = (totalDurationSeconds / 60.0).round();

        // Obter polyline
        final overviewPolyline = route['overview_polyline'] as Map<String, dynamic>?;
        final polyline = overviewPolyline?['points'] as String?;

        final result = RouteResultWithSteps(
          distanceKm: distanceKm,
          durationMinutes: durationMinutes,
          polyline: polyline,
          steps: allSteps,
        );

        debugPrint('✅ [Directions] Rota calculada: ${result.distanceKm.toStringAsFixed(1)} km, ${result.durationMinutes} min, ${result.steps.length} steps');
        return result;
      } else {
        final status = response.data['status'] as String?;
        final errorMessage = response.data['error_message'] as String?;
        debugPrint('❌ [Directions] Erro ao calcular rota: $status - $errorMessage');
        return null;
      }
    } catch (e) {
      debugPrint('❌ [Directions] Erro ao calcular rota com steps: $e');
      return null;
    }
  }
}

