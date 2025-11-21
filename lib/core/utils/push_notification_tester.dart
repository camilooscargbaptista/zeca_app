import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

/// Utilitário para testar push notifications e deep links
class PushNotificationTester {
  /// Simular recebimento de notificação de validação pendente
  /// 
  /// Use este método para testar o deep link sem precisar enviar push real
  static Future<void> simulateValidationPendingNotification({
    required String refuelingId,
  }) async {
    debugPrint('🧪 Simulando notificação de validação pendente...');
    
    // Criar mensagem simulada
    final simulatedMessage = RemoteMessage(
      messageId: 'test_${DateTime.now().millisecondsSinceEpoch}',
      notification: RemoteNotification(
        title: 'Validação Pendente',
        body: 'Dados do abastecimento aguardando sua validação',
      ),
      data: {
        'type': 'refueling_validation_pending',
        'refueling_id': refuelingId,
      },
    );

    // Processar como se fosse uma notificação real
    // Nota: Isso não vai disparar os listeners automaticamente,
    // mas você pode usar para testar o DeepLinkService diretamente
    debugPrint('📨 Mensagem simulada criada:');
    debugPrint('   Tipo: ${simulatedMessage.data['type']}');
    debugPrint('   Refueling ID: ${simulatedMessage.data['refueling_id']}');
    
    return Future.value();
  }

  /// Obter token FCM para testes
  static Future<String?> getFCMTokenForTesting() async {
    try {
      final token = await FirebaseService().getFCMToken();
      debugPrint('📱 Token FCM para testes: $token');
      return token;
    } catch (e) {
      debugPrint('❌ Erro ao obter token: $e');
      return null;
    }
  }

  /// Verificar status de permissões
  static Future<void> checkNotificationPermissions() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.getNotificationSettings();
      
      debugPrint('📋 Status de permissões:');
      debugPrint('   Authorization: ${settings.authorizationStatus}');
      debugPrint('   Alert: ${settings.alert}');
      debugPrint('   Badge: ${settings.badge}');
      debugPrint('   Sound: ${settings.sound}');
    } catch (e) {
      debugPrint('❌ Erro ao verificar permissões: $e');
    }
  }
}

