import 'flavor_config.dart';

class ApiConfig {
  /// Retorna a URL base baseada no FlavorConfig
  static String get baseUrl => FlavorConfig.instance.baseUrl;
  
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
  
  /// Verifica se está em ambiente de desenvolvimento/staging
  static bool get isDebugEnvironment => 
      FlavorConfig.instance.isDevelopment || FlavorConfig.instance.isStaging;
  
  /// Configurações específicas por ambiente
  static Map<String, dynamic> get environmentConfig => {
    'debug': isDebugEnvironment,
    'timeout': timeout,
    'retryAttempts': isDebugEnvironment ? 3 : 2,
  };
}

