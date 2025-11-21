import 'package:equatable/equatable.dart';
import 'notification_entity.dart';

class NotificationSettingsEntity extends Equatable {
  final String userId;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final NotificationTypeSettings refueling;
  final NotificationTypeSettings vehicle;
  final NotificationTypeSettings system;
  final NotificationTypeSettings promotion;
  final NotificationTypeSettings maintenance;
  final NotificationTypeSettings security;
  final NotificationTypeSettings payment;
  final NotificationTypeSettings reminder;
  final NotificationTimeSettings horarios;
  final DateTime atualizadoEm;

  const NotificationSettingsEntity({
    required this.userId,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.smsEnabled,
    required this.refueling,
    required this.vehicle,
    required this.system,
    required this.promotion,
    required this.maintenance,
    required this.security,
    required this.payment,
    required this.reminder,
    required this.horarios,
    required this.atualizadoEm,
  });

  @override
  List<Object?> get props => [
        userId,
        pushEnabled,
        emailEnabled,
        smsEnabled,
        refueling,
        vehicle,
        system,
        promotion,
        maintenance,
        security,
        payment,
        reminder,
        horarios,
        atualizadoEm,
      ];

  NotificationTypeSettings getSettingsForType(NotificationType type) {
    switch (type) {
      case NotificationType.refueling:
        return refueling;
      case NotificationType.vehicle:
        return vehicle;
      case NotificationType.system:
        return system;
      case NotificationType.promotion:
        return promotion;
      case NotificationType.maintenance:
        return maintenance;
      case NotificationType.security:
        return security;
      case NotificationType.payment:
        return payment;
      case NotificationType.reminder:
        return reminder;
    }
  }
}

class NotificationTypeSettings extends Equatable {
  final bool enabled;
  final bool push;
  final bool email;
  final bool sms;
  final NotificationPriority minPriority;

  const NotificationTypeSettings({
    required this.enabled,
    required this.push,
    required this.email,
    required this.sms,
    required this.minPriority,
  });

  @override
  List<Object?> get props => [enabled, push, email, sms, minPriority];
}

class NotificationTimeSettings extends Equatable {
  final bool respeitarHorarioComercial;
  final int horaInicio;
  final int minutoInicio;
  final int horaFim;
  final int minutoFim;
  final List<int> diasSemana; // 0 = domingo, 1 = segunda, etc.
  final bool pausarNotificacoes;
  final DateTime? pausarAte;

  const NotificationTimeSettings({
    required this.respeitarHorarioComercial,
    required this.horaInicio,
    required this.minutoInicio,
    required this.horaFim,
    required this.minutoFim,
    required this.diasSemana,
    required this.pausarNotificacoes,
    this.pausarAte,
  });

  @override
  List<Object?> get props => [
        respeitarHorarioComercial,
        horaInicio,
        minutoInicio,
        horaFim,
        minutoFim,
        diasSemana,
        pausarNotificacoes,
        pausarAte,
      ];

  bool get isPausada {
    if (!pausarNotificacoes) return false;
    if (pausarAte == null) return false;
    return DateTime.now().isBefore(pausarAte!);
  }

  bool get isHorarioComercial {
    if (!respeitarHorarioComercial) return true;
    
    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;
    final startTime = horaInicio * 60 + minutoInicio;
    final endTime = horaFim * 60 + minutoFim;
    
    return currentTime >= startTime && currentTime <= endTime;
  }

  bool get isDiaUtil {
    if (diasSemana.isEmpty) return true;
    return diasSemana.contains(DateTime.now().weekday % 7);
  }
}
