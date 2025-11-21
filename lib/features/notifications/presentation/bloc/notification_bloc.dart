import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/notification_settings_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/get_notification_settings_usecase.dart';
import '../../domain/usecases/update_notification_settings_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final GetNotificationSettingsUseCase _getNotificationSettingsUseCase;
  final UpdateNotificationSettingsUseCase _updateNotificationSettingsUseCase;

  NotificationBloc({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationReadUseCase markNotificationReadUseCase,
    required GetNotificationSettingsUseCase getNotificationSettingsUseCase,
    required UpdateNotificationSettingsUseCase updateNotificationSettingsUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markNotificationReadUseCase = markNotificationReadUseCase,
        _getNotificationSettingsUseCase = getNotificationSettingsUseCase,
        _updateNotificationSettingsUseCase = updateNotificationSettingsUseCase,
        super(const NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<LoadMoreNotifications>(_onLoadMoreNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<ArchiveNotification>(_onArchiveNotification);
    on<DeleteNotification>(_onDeleteNotification);
    on<LoadNotificationSettings>(_onLoadNotificationSettings);
    on<UpdateNotificationSettings>(_onUpdateNotificationSettings);
    on<RefreshNotifications>(_onRefreshNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    final result = await _getNotificationsUseCase(
      page: 1,
      limit: 20,
      tipo: event.tipo,
      status: event.status,
      naoLidas: event.naoLidas,
    );

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(
        notifications: notifications,
        hasMore: notifications.length == 20,
        page: 1,
      )),
    );
  }

  Future<void> _onLoadMoreNotifications(
    LoadMoreNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is! NotificationLoaded) return;

    final currentState = state as NotificationLoaded;
    if (!currentState.hasMore) return;

    emit(NotificationLoadingMore(
      notifications: currentState.notifications,
      hasMore: currentState.hasMore,
      page: currentState.page,
    ));

    final result = await _getNotificationsUseCase(
      page: currentState.page + 1,
      limit: 20,
      tipo: event.tipo,
      status: event.status,
      naoLidas: event.naoLidas,
    );

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (newNotifications) => emit(NotificationLoaded(
        notifications: [...currentState.notifications, ...newNotifications],
        hasMore: newNotifications.length == 20,
        page: currentState.page + 1,
      )),
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _markNotificationReadUseCase(event.notificationId);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) {
        if (state is NotificationLoaded) {
          final currentState = state as NotificationLoaded;
          final updatedNotifications = currentState.notifications.map((notification) {
            if (notification.id == event.notificationId) {
              return NotificationEntity(
                id: notification.id,
                titulo: notification.titulo,
                mensagem: notification.mensagem,
                tipo: notification.tipo,
                prioridade: notification.prioridade,
                status: NotificationStatus.lida,
                criadoEm: notification.criadoEm,
                lidoEm: DateTime.now(),
                acao: notification.acao,
                dadosExtras: notification.dadosExtras,
                imagemUrl: notification.imagemUrl,
                iconeUrl: notification.iconeUrl,
                userId: notification.userId,
                refuelingId: notification.refuelingId,
                vehicleId: notification.vehicleId,
              );
            }
            return notification;
          }).toList();

          emit(NotificationLoaded(
            notifications: updatedNotifications,
            hasMore: currentState.hasMore,
            page: currentState.page,
          ));
        }
      },
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    // TODO: Implementar MarkAllAsReadUseCase
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final updatedNotifications = currentState.notifications.map((notification) {
        return NotificationEntity(
          id: notification.id,
          titulo: notification.titulo,
          mensagem: notification.mensagem,
          tipo: notification.tipo,
          prioridade: notification.prioridade,
          status: NotificationStatus.lida,
          criadoEm: notification.criadoEm,
          lidoEm: DateTime.now(),
          acao: notification.acao,
          dadosExtras: notification.dadosExtras,
          imagemUrl: notification.imagemUrl,
          iconeUrl: notification.iconeUrl,
          userId: notification.userId,
          refuelingId: notification.refuelingId,
          vehicleId: notification.vehicleId,
        );
      }).toList();

      emit(NotificationLoaded(
        notifications: updatedNotifications,
        hasMore: currentState.hasMore,
        page: currentState.page,
      ));
    }
  }

  void _onArchiveNotification(
    ArchiveNotification event,
    Emitter<NotificationState> emit,
  ) {
    // TODO: Implementar ArchiveNotificationUseCase
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final updatedNotifications = currentState.notifications
          .where((notification) => notification.id != event.notificationId)
          .toList();

      emit(NotificationLoaded(
        notifications: updatedNotifications,
        hasMore: currentState.hasMore,
        page: currentState.page,
      ));
    }
  }

  void _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) {
    // TODO: Implementar DeleteNotificationUseCase
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final updatedNotifications = currentState.notifications
          .where((notification) => notification.id != event.notificationId)
          .toList();

      emit(NotificationLoaded(
        notifications: updatedNotifications,
        hasMore: currentState.hasMore,
        page: currentState.page,
      ));
    }
  }

  Future<void> _onLoadNotificationSettings(
    LoadNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _getNotificationSettingsUseCase();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (settings) => emit(NotificationSettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _updateNotificationSettingsUseCase(event.settings);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (settings) => emit(NotificationSettingsUpdated(settings)),
    );
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    add(LoadNotifications(
      tipo: event.tipo,
      status: event.status,
      naoLidas: event.naoLidas,
    ));
  }
}
