import 'package:flutter/foundation.dart';
import 'flavor_config.dart';

/// Configuração de API do ZECA App
/// 
/// URLs são definidas no [FlavorConfig] baseado no flavor/ambiente atual.
/// Para mudar de ambiente, use um entrypoint diferente:
/// - main_dev.dart - Desenvolvimento
/// - main_staging.dart - Staging
/// - main_prod.dart - Produção
class ApiConfig {
  /// Retorna a URL base baseada no flavor atual
  /// Usa FlavorConfig.instance para obter a URL correta
  static String get baseUrl {
    try {
      final url = FlavorConfig.instance.baseUrl;
      debugPrint('🌐 [ApiConfig] baseUrl = $url (flavor: ${FlavorConfig.instance.name})');
      return url;
    } catch (e) {
      // Fallback caso FlavorConfig não tenha sido inicializado
      // Isso NÃO deve acontecer em produção!
      debugPrint('⚠️ [ApiConfig] FlavorConfig não inicializado, usando fallback!');
      return 'https://www.abastecacomzeca.com.br';
    }
  }
  
  /// Retorna a URL completa da API
  static String get apiUrl => '$baseUrl/api/v1';
  
  /// Headers padrão para todas as requisições
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'X-Platform': 'ios', // Será dinâmico baseado na plataforma
    'X-Client-Type': 'mobile',
  };
  
  /// Timeout para requisições
  static const Duration timeout = Duration(seconds: 30);
  
  /// Configurações específicas por ambiente
  static Map<String, dynamic> get environmentConfig {
    final flavor = FlavorConfig.instance.flavor;
    
    switch (flavor) {
      case Flavor.dev:
        return {
          'debug': true,
          'timeout': const Duration(seconds: 60),
          'retryAttempts': 3,
        };
      case Flavor.staging:
        return {
          'debug': true,
          'timeout': const Duration(seconds: 30),
          'retryAttempts': 2,
        };
      case Flavor.prod:
        return {
          'debug': false,
          'timeout': const Duration(seconds: 30),
          'retryAttempts': 2,
        };
      default:
        return {
          'debug': true,
          'timeout': const Duration(seconds: 30),
          'retryAttempts': 2,
        };
    }
  }
  
  /// Retorna nome do ambiente atual para debug
  static String get environmentName => FlavorConfig.instance.name;
  
  /// Verifica se está em modo debug
  static bool get isDebugMode => FlavorConfig.instance.isDevelopment || FlavorConfig.instance.isStaging;
}

