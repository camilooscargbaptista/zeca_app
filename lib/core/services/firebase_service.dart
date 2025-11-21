import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'api_service.dart';
import 'user_service.dart';
import 'deep_link_service.dart';

/// Serviço para gerenciar Firebase e Push Notifications
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ApiService _apiService = ApiService();
  String? _fcmToken;
  
  /// Inicializar Firebase e configurar notificações
  Future<void> initialize() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        debugPrint('🍎 iOS detectado - Configurando push notifications');
      }
      
      // Solicitar permissão de notificação
      try {
        NotificationSettings settings = await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          debugPrint('✅ Permissão de notificação concedida');
        } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
          debugPrint('⚠️ Permissão de notificação provisória');
        } else {
          debugPrint('⚠️ Permissão de notificação negada');
        }
      } catch (e) {
        debugPrint('❌ Erro ao solicitar permissão de notificação: $e');
        rethrow;
      }

      // Obter token FCM
      try {
        await _getFCMToken();
      } catch (e) {
        debugPrint('❌ Erro ao obter token FCM: $e');
        rethrow;
      }

      // Configurar handlers de mensagem
      try {
        _setupMessageHandlers();
      } catch (e) {
        debugPrint('❌ Erro ao configurar handlers de mensagem: $e');
        rethrow;
      }

      // Configurar atualização de token
      try {
        _messaging.onTokenRefresh.listen((newToken) {
          debugPrint('🔄 Token FCM atualizado: $newToken');
          _fcmToken = newToken;
          _registerTokenOnBackend(newToken);
        });
      } catch (e) {
        debugPrint('❌ Erro ao configurar listener de token refresh: $e');
        rethrow;
      }

      debugPrint('✅ Firebase Service inicializado com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar Firebase Service: $e');
      rethrow;
    }
  }

  /// Obter token FCM
  Future<String?> _getFCMToken() async {
    try {
      // Verificar se Firebase está inicializado
      try {
        Firebase.app();
      } catch (e) {
        debugPrint('❌ Firebase não está inicializado. Erro: $e');
        throw Exception('Firebase não está inicializado. Reinicie o app.');
      }
      
      // No iOS, é necessário aguardar o APNS token ser configurado pelo AppDelegate
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        debugPrint('🍎 iOS detectado - aguardando APNS token...');
        debugPrint('⏳ Aguardando AppDelegate configurar APNS token...');
        
        // Aguardar um pouco mais para dar tempo do AppDelegate processar
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Tentar obter APNS token com múltiplas tentativas (aguardando ser configurado pelo AppDelegate)
        String? apnsToken;
        const maxAttempts = 10; // Aumentar tentativas
        for (int i = 0; i < maxAttempts; i++) {
          try {
            apnsToken = await _messaging.getAPNSToken();
            if (apnsToken != null) {
              debugPrint('✅ APNS token obtido na tentativa ${i + 1}: $apnsToken');
              break;
            } else {
              debugPrint('⚠️ APNS token ainda não disponível (tentativa ${i + 1}/$maxAttempts), aguardando...');
              // Backoff exponencial: 1s, 2s, 3s, etc.
              await Future.delayed(Duration(seconds: min(i + 1, 3)));
            }
          } catch (e) {
            debugPrint('⚠️ Erro ao obter APNS token (tentativa ${i + 1}): $e');
            if (i < maxAttempts - 1) {
              await Future.delayed(Duration(seconds: min(i + 1, 3)));
            }
          }
        }
        
        if (apnsToken == null) {
          debugPrint('⚠️ APNS token não disponível após $maxAttempts tentativas');
          debugPrint('💡 Verificações necessárias:');
          debugPrint('   1. Dispositivo físico (não simulador)');
          debugPrint('   2. Push Notifications habilitado no App ID');
          debugPrint('   3. Provisioning Profile com Push Notifications');
          debugPrint('   4. Runner.entitlements configurado no Xcode');
          debugPrint('   5. Code Signing Entitlements apontando para Runner.entitlements');
          debugPrint('   6. Build feito com certificado de distribuição/desenvolvimento válido');
        }
      }
      
      _fcmToken = await _messaging.getToken();
      if (_fcmToken != null) {
        debugPrint('📱 Token FCM obtido: $_fcmToken');
        await _registerTokenOnBackend(_fcmToken!);
      } else {
        debugPrint('⚠️ Token FCM é null');
      }
      return _fcmToken;
    } catch (e) {
      debugPrint('❌ Erro ao obter token FCM: $e');
      // No iOS, se o erro for sobre APNS token, pode ser que push não esteja disponível
      if (defaultTargetPlatform == TargetPlatform.iOS && 
          e.toString().contains('apns-token-not-set')) {
        debugPrint('⚠️ APNS token não disponível - pode ser conta pessoal (Personal Team)');
        debugPrint('💡 Personal Teams não suportam Push Notifications');
        debugPrint('💡 É necessário Apple Developer Program (conta paga) para push no iOS');
        // Não fazer retry - push não está disponível
        return null;
      }
      // Para outros erros, retornar null ao invés de rethrow
      return null;
    }
  }

  /// Registrar token no backend
  Future<void> _registerTokenOnBackend(String token) async {
    try {
      final userService = UserService();
      if (!userService.isLoggedIn) {
        debugPrint('⚠️ Usuário não está logado, token não será registrado');
        return;
      }

      // Detectar plataforma
      String platform = 'android';
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        platform = 'ios';
      }

      final response = await _apiService.registerDeviceToken(
        deviceToken: token,
        platform: platform,
      );

      if (response['success'] == true) {
        debugPrint('✅ Token FCM registrado no backend: $token');
      } else {
        debugPrint('⚠️ Erro ao registrar token: ${response['error']}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao registrar token no backend: $e');
    }
  }

  /// Configurar handlers de mensagem
  void _setupMessageHandlers() {
      // Handlers serão configurados no DeepLinkHandler widget
      // para ter acesso ao context
  }

  /// Processar mensagem em foreground
  void _handleForegroundMessage(RemoteMessage message) {
    // Aqui você pode mostrar um dialog ou snackbar
    // Por enquanto, apenas log
    final data = message.data;
    
    // Se for notificação de validação pendente, pode mostrar alerta
    if (data['type'] == 'refueling_validation_pending') {
      debugPrint('🔔 Validação de abastecimento pendente!');
    }
  }

  /// Processar deep link
  void _handleDeepLink(Map<String, dynamic> data) {
    try {
      // Usar DeepLinkService para processar
      // Nota: Context será obtido via navigator key ou callback
      DeepLinkService().handleDeepLink(null, data);
    } catch (e) {
      debugPrint('❌ Erro ao processar deep link: $e');
    }
  }

  /// Obter token FCM atual
  String? get fcmToken => _fcmToken;

  /// Obter token FCM (força atualização)
  /// Retorna null se push notifications não estiverem disponíveis (ex: iOS com conta pessoal)
  Future<String?> getFCMToken() async {
    try {
      // Verificar se Firebase está inicializado
      try {
        Firebase.app();
      } catch (e) {
        debugPrint('❌ Firebase não está inicializado. Erro: $e');
        return null;
      }
      
      // Se já temos token, retornar
      if (_fcmToken != null) {
        return _fcmToken;
      }
      
      // Obter novo token
      return await _getFCMToken();
    } catch (e) {
      // Tratar erro graciosamente - push pode não estar disponível
      if (e.toString().contains('apns-token-not-set') || 
          e.toString().contains('not available')) {
        debugPrint('⚠️ Push notifications não disponível: $e');
        debugPrint('💡 Personal Teams (contas gratuitas) não suportam Push Notifications');
        debugPrint('💡 É necessário Apple Developer Program (conta paga) para push no iOS');
      } else {
        debugPrint('❌ Erro ao obter token FCM: $e');
      }
      return null;
    }
  }
}

