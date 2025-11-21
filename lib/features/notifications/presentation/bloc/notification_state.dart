part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoadingMore extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasMore;
  final int page;

  const NotificationLoadingMore({
    required this.notifications,
    required this.hasMore,
    required this.page,
  });

  @override
  List<Object?> get props => [notifications, hasMore, page];
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasMore;
  final int page;

  const NotificationLoaded({
    required this.notifications,
    required this.hasMore,
    required this.page,
  });

  @override
  List<Object?> get props => [notifications, hasMore, page];
}

class NotificationSettingsLoaded extends NotificationState {
  final NotificationSettingsEntity settings;

  const NotificationSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class NotificationSettingsUpdated extends NotificationState {
  final NotificationSettingsEntity settings;

  const NotificationSettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
