import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/notification_model.dart';
import '../models/notification_settings_model.dart';
import '../models/notification_template_model.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
    String? tipo,
    String? status,
    bool? naoLidas,
  });

  Future<NotificationModel> getNotificationById(String id);

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();

  Future<void> archiveNotification(String notificationId);

  Future<void> deleteNotification(String notificationId);

  Future<int> getUnreadCount();

  Future<NotificationSettingsModel> getNotificationSettings();

  Future<NotificationSettingsModel> updateNotificationSettings(
    NotificationSettingsModel settings,
  );

  Future<List<NotificationTemplateModel>> getTemplates({
    String? tipo,
    bool? ativo,
  });

  Future<NotificationTemplateModel> getTemplateById(String id);

  Future<String> registerDeviceToken(String token);

  Future<void> unregisterDeviceToken();

  Future<bool> isPushNotificationEnabled();

  Future<void> requestNotificationPermission();

  Future<void> sendNotification({
    required String titulo,
    required String mensagem,
    required String tipo,
    required String prioridade,
    String? userId,
    String? refuelingId,
    String? vehicleId,
    Map<String, dynamic>? acao,
    Map<String, dynamic>? dadosExtras,
    String? imagemUrl,
  });
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _client;

  NotificationRemoteDataSourceImpl(this._client);

  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
    String? tipo,
    String? status,
    bool? naoLidas,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (tipo != null) queryParams['tipo'] = tipo;
    if (status != null) queryParams['status'] = status;
    if (naoLidas != null) queryParams['nao_lidas'] = naoLidas;

    final response = await _client.get(
      ApiConstants.notifications,
      queryParameters: queryParams,
    );

    final List<dynamic> notificationsJson = response.data['data']['notifications'];
    return notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<NotificationModel> getNotificationById(String id) async {
    final response = await _client.get('${ApiConstants.notifications}/$id');
    return NotificationModel.fromJson(response.data['data']);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _client.post('${ApiConstants.notifications}/$notificationId/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _client.post('${ApiConstants.notifications}/read-all');
  }

  @override
  Future<void> archiveNotification(String notificationId) async {
    await _client.post('${ApiConstants.notifications}/$notificationId/archive');
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _client.delete('${ApiConstants.notifications}/$notificationId');
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _client.get('${ApiConstants.notifications}/unread-count');
    return response.data['data']['count'];
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async {
    final response = await _client.get(ApiConstants.notificationSettings);
    return NotificationSettingsModel.fromJson(response.data['data']);
  }

  @override
  Future<NotificationSettingsModel> updateNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
    final response = await _client.put(
      ApiConstants.notificationSettings,
      data: settings.toJson(),
    );
    return NotificationSettingsModel.fromJson(response.data['data']);
  }

  @override
  Future<List<NotificationTemplateModel>> getTemplates({
    String? tipo,
    bool? ativo,
  }) async {
    final queryParams = <String, dynamic>{};
    if (tipo != null) queryParams['tipo'] = tipo;
    if (ativo != null) queryParams['ativo'] = ativo;

    final response = await _client.get(
      ApiConstants.notificationTemplates,
      queryParameters: queryParams,
    );

    final List<dynamic> templatesJson = response.data['data'];
    return templatesJson.map((json) => NotificationTemplateModel.fromJson(json)).toList();
  }

  @override
  Future<NotificationTemplateModel> getTemplateById(String id) async {
    final response = await _client.get('${ApiConstants.notificationTemplates}/$id');
    return NotificationTemplateModel.fromJson(response.data['data']);
  }

  @override
  Future<String> registerDeviceToken(String token) async {
    final response = await _client.post(
      ApiConstants.deviceTokens,
      data: {'token': token},
    );
    return response.data['data']['device_id'];
  }

  @override
  Future<void> unregisterDeviceToken() async {
    await _client.delete(ApiConstants.deviceTokens);
  }

  @override
  Future<bool> isPushNotificationEnabled() async {
    final response = await _client.get('${ApiConstants.deviceTokens}/status');
    return response.data['data']['enabled'];
  }

  @override
  Future<void> requestNotificationPermission() async {
    // TODO: Implementar solicitação de permissão local
    // Por enquanto, apenas chama a API
    await _client.post('${ApiConstants.deviceTokens}/request-permission');
  }

  @override
  Future<void> sendNotification({
    required String titulo,
    required String mensagem,
    required String tipo,
    required String prioridade,
    String? userId,
    String? refuelingId,
    String? vehicleId,
    Map<String, dynamic>? acao,
    Map<String, dynamic>? dadosExtras,
    String? imagemUrl,
  }) async {
    await _client.post(
      ApiConstants.sendNotification,
      data: {
        'titulo': titulo,
        'mensagem': mensagem,
        'tipo': tipo,
        'prioridade': prioridade,
        if (userId != null) 'user_id': userId,
        if (refuelingId != null) 'refueling_id': refuelingId,
        if (vehicleId != null) 'vehicle_id': vehicleId,
        if (acao != null) 'acao': acao,
        if (dadosExtras != null) 'dados_extras': dadosExtras,
        if (imagemUrl != null) 'imagem_url': imagemUrl,
      },
    );
  }
}
