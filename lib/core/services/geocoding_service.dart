import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Serviço para obter informações de localização reversa (endereço a partir de coordenadas)
@injectable
class GeocodingService {
  /// Obtém o nome da rua a partir de coordenadas
  Future<String?> getStreetName(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        
        // Tentar retornar nome da rua
        if (place.street != null && place.street!.isNotEmpty) {
          return place.street;
        }
        
        // Fallback para thoroughfare (via principal)
        if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          return place.thoroughfare;
        }
        
        // Fallback para subThoroughfare
        if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
          return place.subThoroughfare;
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ [Geocoding] Erro ao obter nome da rua: $e');
      return null;
    }
  }

  /// Obtém endereço completo a partir de coordenadas
  Future<String?> getFullAddress(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[];
        
        if (place.street != null && place.street!.isNotEmpty) {
          parts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          parts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          parts.add(place.locality!);
        }
        
        return parts.isNotEmpty ? parts.join(', ') : null;
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ [Geocoding] Erro ao obter endereço: $e');
      return null;
    }
  }

  /// Estima limite de velocidade baseado no tipo de via
  /// Retorna velocidade em km/h
  int estimateSpeedLimit(String? streetType) {
    if (streetType == null) return 60; // Padrão urbano
    
    final type = streetType.toLowerCase();
    
    // Rodovias e vias expressas
    if (type.contains('rodovia') || 
        type.contains('marginal') ||
        type.contains('expressa') ||
        type.contains('br-') ||
        type.contains('sp-')) {
      return 110;
    }
    
    // Avenidas
    if (type.contains('avenida') || type.contains('av.')) {
      return 60;
    }
    
    // Ruas residenciais
    if (type.contains('rua') || type.contains('r.')) {
      return 40;
    }
    
    // Padrão
    return 60;
  }
}
