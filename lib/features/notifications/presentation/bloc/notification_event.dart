part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String? tipo;
  final NotificationStatus? status;
  final bool? naoLidas;

  const LoadNotifications({
    this.tipo,
    this.status,
    this.naoLidas,
  });

  @override
  List<Object?> get props => [tipo, status, naoLidas];
}

class LoadMoreNotifications extends NotificationEvent {
  final String? tipo;
  final NotificationStatus? status;
  final bool? naoLidas;

  const LoadMoreNotifications({
    this.tipo,
    this.status,
    this.naoLidas,
  });

  @override
  List<Object?> get props => [tipo, status, naoLidas];
}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllAsRead extends NotificationEvent {
  const MarkAllAsRead();
}

class ArchiveNotification extends NotificationEvent {
  final String notificationId;

  const ArchiveNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class LoadNotificationSettings extends NotificationEvent {
  const LoadNotificationSettings();
}

class UpdateNotificationSettings extends NotificationEvent {
  final NotificationSettingsEntity settings;

  const UpdateNotificationSettings(this.settings);

  @override
  List<Object?> get props => [settings];
}

class RefreshNotifications extends NotificationEvent {
  final String? tipo;
  final NotificationStatus? status;
  final bool? naoLidas;

  const RefreshNotifications({
    this.tipo,
    this.status,
    this.naoLidas,
  });

  @override
  List<Object?> get props => [tipo, status, naoLidas];
}
