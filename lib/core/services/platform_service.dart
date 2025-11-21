import 'dart:io';

class PlatformService {
  /// Detecta a plataforma atual
  static String get currentPlatform {
    if (Platform.isAndroid) {
      return 'ANDROID';
    } else if (Platform.isIOS) {
      return 'IOS';
    } else {
      return 'WEB';
    }
  }
  
  /// Retorna a plataforma em formato para API
  static String get platformForApi {
    return currentPlatform;
  }
}
