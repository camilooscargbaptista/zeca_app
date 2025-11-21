import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_settings_entity.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_settings_model.freezed.dart';
part 'notification_settings_model.g.dart';

@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const NotificationSettingsModel._();
  
  const factory NotificationSettingsModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'push_enabled') required bool pushEnabled,
    @JsonKey(name: 'email_enabled') required bool emailEnabled,
    @JsonKey(name: 'sms_enabled') required bool smsEnabled,
    required NotificationTypeSettingsModel refueling,
    required NotificationTypeSettingsModel vehicle,
    required NotificationTypeSettingsModel system,
    required NotificationTypeSettingsModel promotion,
    required NotificationTypeSettingsModel maintenance,
    required NotificationTypeSettingsModel security,
    required NotificationTypeSettingsModel payment,
    required NotificationTypeSettingsModel reminder,
    required NotificationTimeSettingsModel horarios,
    @JsonKey(name: 'atualizado_em') required DateTime atualizadoEm,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);

  NotificationSettingsEntity toEntity() {
    return NotificationSettingsEntity(
      userId: userId,
      pushEnabled: pushEnabled,
      emailEnabled: emailEnabled,
      smsEnabled: smsEnabled,
      refueling: refueling.toEntity(),
      vehicle: vehicle.toEntity(),
      system: system.toEntity(),
      promotion: promotion.toEntity(),
      maintenance: maintenance.toEntity(),
      security: security.toEntity(),
      payment: payment.toEntity(),
      reminder: reminder.toEntity(),
      horarios: horarios.toEntity(),
      atualizadoEm: atualizadoEm,
    );
  }
}

@freezed
class NotificationTypeSettingsModel with _$NotificationTypeSettingsModel {
  const NotificationTypeSettingsModel._();
  
  const factory NotificationTypeSettingsModel({
    required bool enabled,
    required bool push,
    required bool email,
    required bool sms,
    @JsonKey(name: 'min_prioridade') required String minPrioridade,
  }) = _NotificationTypeSettingsModel;

  factory NotificationTypeSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationTypeSettingsModelFromJson(json);

  NotificationTypeSettings toEntity() {
    return NotificationTypeSettings(
      enabled: enabled,
      push: push,
      email: email,
      sms: sms,
      minPriority: NotificationPriority.fromString(minPrioridade) ?? NotificationPriority.media,
    );
  }
}

@freezed
class NotificationTimeSettingsModel with _$NotificationTimeSettingsModel {
  const NotificationTimeSettingsModel._();
  
  const factory NotificationTimeSettingsModel({
    @JsonKey(name: 'respeitar_horario_comercial') required bool respeitarHorarioComercial,
    @JsonKey(name: 'hora_inicio') required int horaInicio,
    @JsonKey(name: 'minuto_inicio') required int minutoInicio,
    @JsonKey(name: 'hora_fim') required int horaFim,
    @JsonKey(name: 'minuto_fim') required int minutoFim,
    @JsonKey(name: 'dias_semana') required List<int> diasSemana,
    @JsonKey(name: 'pausar_notificacoes') required bool pausarNotificacoes,
    @JsonKey(name: 'pausar_ate') DateTime? pausarAte,
  }) = _NotificationTimeSettingsModel;

  factory NotificationTimeSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationTimeSettingsModelFromJson(json);

  NotificationTimeSettings toEntity() {
    return NotificationTimeSettings(
      respeitarHorarioComercial: respeitarHorarioComercial,
      horaInicio: horaInicio,
      minutoInicio: minutoInicio,
      horaFim: horaFim,
      minutoFim: minutoFim,
      diasSemana: diasSemana,
      pausarNotificacoes: pausarNotificacoes,
      pausarAte: pausarAte,
    );
  }
}
