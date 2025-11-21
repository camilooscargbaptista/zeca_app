import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../entities/notification_settings_entity.dart';
import '../entities/notification_template_entity.dart';

abstract class NotificationRepository {
  // Notificações
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int page = 1,
    int limit = 20,
    String? tipo,
    NotificationStatus? status,
    bool? naoLidas,
  });

  Future<Either<Failure, NotificationEntity>> getNotificationById(String id);

  Future<Either<Failure, void>> markAsRead(String notificationId);

  Future<Either<Failure, void>> markAllAsRead();

  Future<Either<Failure, void>> archiveNotification(String notificationId);

  Future<Either<Failure, void>> deleteNotification(String notificationId);

  Future<Either<Failure, int>> getUnreadCount();

  // Configurações
  Future<Either<Failure, NotificationSettingsEntity>> getNotificationSettings();

  Future<Either<Failure, NotificationSettingsEntity>> updateNotificationSettings(
    NotificationSettingsEntity settings,
  );

  // Templates
  Future<Either<Failure, List<NotificationTemplateEntity>>> getTemplates({
    String? tipo,
    bool? ativo,
  });

  Future<Either<Failure, NotificationTemplateEntity>> getTemplateById(String id);

  // Push Notifications
  Future<Either<Failure, String>> registerDeviceToken(String token);

  Future<Either<Failure, void>> unregisterDeviceToken();

  Future<Either<Failure, bool>> isPushNotificationEnabled();

  Future<Either<Failure, void>> requestNotificationPermission();

  // Envio de notificações
  Future<Either<Failure, void>> sendNotification({
    required String titulo,
    required String mensagem,
    required String tipo,
    required NotificationPriority prioridade,
    String? userId,
    String? refuelingId,
    String? vehicleId,
    NotificationAction? acao,
    Map<String, dynamic>? dadosExtras,
    String? imagemUrl,
  });
}
