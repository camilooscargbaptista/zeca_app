import 'package:flutter/foundation.dart';

// Import do arquivo local (não commitado) - usado para desenvolvimento
import 'api_keys.local.dart';

/// Configuração de chaves de API
/// 
/// A chave é carregada de api_keys.local.dart
/// Este arquivo está no .gitignore e não é commitado
class ApiKeys {
  /// Chave da API do Google Maps (Places, Directions, Geocoding)
  static String get googleMapsApiKey {
    final key = LocalApiKeys.googleMapsApiKey;
    
    if (key.isEmpty || key == 'GOOGLE_MAPS_API_KEY_PLACEHOLDER') {
      debugPrint('⚠️⚠️⚠️ [ApiKeys] ATENÇÃO: GOOGLE_MAPS_API_KEY não configurada!');
      debugPrint('⚠️ Configure em lib/core/config/api_keys.local.dart');
      
      if (kReleaseMode) {
        throw Exception(
          'GOOGLE_MAPS_API_KEY não configurada.\n\n'
          'Configure em lib/core/config/api_keys.local.dart',
        );
      }
      
      return 'GOOGLE_MAPS_API_KEY_PLACEHOLDER';
    }
    
    return key;
  }
}
