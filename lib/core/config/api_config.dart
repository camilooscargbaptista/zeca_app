class ApiConfig {
  // URLs base para diferentes ambientes
  static const String _baseUrlDev = 'https://816343baaf24.ngrok-free.app';
  static const String _baseUrlStaging = 'https://api-staging.zeca.com.br';
  static const String _baseUrlProd = 'https://www.abastecacomzeca.com.br';
  
  // Ambiente atual (pode ser alterado via build flavor)
  // Para builds de produção (APK/IPA), alterar para 'prod'
  static const String _currentEnvironment = 'prod';
  
  /// Retorna a URL base baseada no ambiente atual
  static String get baseUrl {
    switch (_currentEnvironment) {
      case 'dev':
        return _baseUrlDev;
      case 'staging':
        return _baseUrlStaging;
      case 'prod':
        return _baseUrlProd;
      default:
        return _baseUrlDev;
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
  static Map<String, dynamic> get environmentConfig => {
    'dev': {
      'debug': true,
      'timeout': Duration(seconds: 60),
      'retryAttempts': 3,
    },
    'staging': {
      'debug': true,
      'timeout': Duration(seconds: 30),
      'retryAttempts': 2,
    },
    'prod': {
      'debug': false,
      'timeout': Duration(seconds: 30),
      'retryAttempts': 2,
    },
  };
}
