import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Utilitários para navegação turn-by-turn
class NavigationUtils {
  /// Calcula a distância entre dois pontos GPS em metros
  /// Usa a fórmula de Haversine
  static double calculateDistanceBetweenPoints(LatLng point1, LatLng point2) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _toRadians(point2.latitude - point1.latitude);
    final double dLng = _toRadians(point2.longitude - point1.longitude);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.sin(dLng / 2) *
                math.sin(dLng / 2) *
                math.cos(_toRadians(point1.latitude)) *
                math.cos(_toRadians(point2.latitude));

    final double c = 2 * math.asin(math.sqrt(a));
    final double distanceKm = earthRadiusKm * c;

    return distanceKm * 1000; // Retornar em metros
  }

  /// Converte graus para radianos
  static double _toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  /// Formata distância para exibição com contexto de proximidade
  /// Ex: "Em 350 metros", "Em 50 metros", "Agora"
  static String formatDistanceToNextStep(double meters) {
    if (meters < 10) {
      return 'Agora';
    } else if (meters < 100) {
      return 'Em ${meters.round()} metros';
    } else if (meters < 1000) {
      // Arredondar para 50m (ex: 350, 400, 450)
      final rounded = ((meters / 50).round() * 50).toInt();
      return 'Em $rounded metros';
    } else {
      final km = meters / 1000;
      return 'Em ${km.toStringAsFixed(1)} km';
    }
  }

  /// Retorna ícone apropriado para cada tipo de manobra
  /// Baseado nos tipos de maneuver do Google Directions API
  static IconData getManeuverIcon(String? maneuver) {
    if (maneuver == null || maneuver.isEmpty) {
      return Icons.arrow_upward; // Padrão: seguir em frente
    }

    switch (maneuver.toLowerCase()) {
      // Virar à direita
      case 'turn-right':
        return Icons.turn_right;
      case 'turn-slight-right':
        return Icons.turn_slight_right;
      case 'turn-sharp-right':
        return Icons.turn_sharp_right;

      // Virar à esquerda
      case 'turn-left':
        return Icons.turn_left;
      case 'turn-slight-left':
        return Icons.turn_slight_left;
      case 'turn-sharp-left':
        return Icons.turn_sharp_left;

      // Manter faixa
      case 'keep-right':
        return Icons.arrow_forward;
      case 'keep-left':
        return Icons.arrow_forward;

      // Retornos
      case 'uturn-right':
      case 'uturn-left':
        return Icons.u_turn_right;

      // Rotatórias
      case 'roundabout-right':
      case 'roundabout-left':
        return Icons.roundabout_right;

      // Seguir em frente
      case 'straight':
        return Icons.arrow_upward;

      // Rampas
      case 'ramp-right':
        return Icons.merge;
      case 'ramp-left':
        return Icons.merge;

      // Bifurcações
      case 'fork-right':
        return Icons.call_split;
      case 'fork-left':
        return Icons.call_split;

      // Merge
      case 'merge':
        return Icons.merge;

      // Ferry
      case 'ferry':
      case 'ferry-train':
        return Icons.directions_boat;

      // Padrão
      default:
        return Icons.arrow_upward;
    }
  }

  /// Retorna descrição em português da manobra
  static String getManeuverDescription(String? maneuver) {
    if (maneuver == null || maneuver.isEmpty) {
      return 'Siga em frente';
    }

    switch (maneuver.toLowerCase()) {
      case 'turn-right':
        return 'Vire à direita';
      case 'turn-slight-right':
        return 'Mantenha-se à direita';
      case 'turn-sharp-right':
        return 'Vire à direita (curva fechada)';

      case 'turn-left':
        return 'Vire à esquerda';
      case 'turn-slight-left':
        return 'Mantenha-se à esquerda';
      case 'turn-sharp-left':
        return 'Vire à esquerda (curva fechada)';

      case 'keep-right':
        return 'Mantenha-se à direita';
      case 'keep-left':
        return 'Mantenha-se à esquerda';

      case 'uturn-right':
      case 'uturn-left':
        return 'Faça retorno';

      case 'roundabout-right':
      case 'roundabout-left':
        return 'Entre na rotatória';

      case 'straight':
        return 'Siga em frente';

      case 'ramp-right':
        return 'Pegue a saída à direita';
      case 'ramp-left':
        return 'Pegue a saída à esquerda';

      case 'fork-right':
        return 'Na bifurcação, vá à direita';
      case 'fork-left':
        return 'Na bifurcação, vá à esquerda';

      case 'merge':
        return 'Entre na pista';

      case 'ferry':
      case 'ferry-train':
        return 'Embarque na balsa';

      default:
        return 'Siga em frente';
    }
  }

  /// Remove tags HTML de instruções do Google Directions API
  /// Ex: "<b>Vire à direita</b> na <b>Av. Paulista</b>" → "Vire à direita na Av. Paulista"
  static String stripHtmlTags(String htmlString) {
    // Remove tags HTML
    var cleanString = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Remove entidades HTML comuns
    cleanString = cleanString
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    
    // Remove espaços extras
    cleanString = cleanString.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleanString;
  }

  /// Formata instrução completa para exibição
  /// Ex: "Em 350 metros, vire à direita"
  static String formatInstructionWithDistance(
    String instruction,
    double distanceMeters,
  ) {
    final distanceText = formatDistanceToNextStep(distanceMeters);
    
    if (distanceText == 'Agora') {
      return instruction;
    }
    
    return '$distanceText, ${instruction.toLowerCase()}';
  }
}

