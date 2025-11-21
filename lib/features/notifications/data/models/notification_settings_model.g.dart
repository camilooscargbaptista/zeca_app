// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsModelImpl _$$NotificationSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsModelImpl(
      userId: json['user_id'] as String,
      pushEnabled: json['push_enabled'] as bool,
      emailEnabled: json['email_enabled'] as bool,
      smsEnabled: json['sms_enabled'] as bool,
      refueling: NotificationTypeSettingsModel.fromJson(
          json['refueling'] as Map<String, dynamic>),
      vehicle: NotificationTypeSettingsModel.fromJson(
          json['vehicle'] as Map<String, dynamic>),
      system: NotificationTypeSettingsModel.fromJson(
          json['system'] as Map<String, dynamic>),
      promotion: NotificationTypeSettingsModel.fromJson(
          json['promotion'] as Map<String, dynamic>),
      maintenance: NotificationTypeSettingsModel.fromJson(
          json['maintenance'] as Map<String, dynamic>),
      security: NotificationTypeSettingsModel.fromJson(
          json['security'] as Map<String, dynamic>),
      payment: NotificationTypeSettingsModel.fromJson(
          json['payment'] as Map<String, dynamic>),
      reminder: NotificationTypeSettingsModel.fromJson(
          json['reminder'] as Map<String, dynamic>),
      horarios: NotificationTimeSettingsModel.fromJson(
          json['horarios'] as Map<String, dynamic>),
      atualizadoEm: DateTime.parse(json['atualizado_em'] as String),
    );

Map<String, dynamic> _$$NotificationSettingsModelImplToJson(
        _$NotificationSettingsModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'push_enabled': instance.pushEnabled,
      'email_enabled': instance.emailEnabled,
      'sms_enabled': instance.smsEnabled,
      'refueling': instance.refueling,
      'vehicle': instance.vehicle,
      'system': instance.system,
      'promotion': instance.promotion,
      'maintenance': instance.maintenance,
      'security': instance.security,
      'payment': instance.payment,
      'reminder': instance.reminder,
      'horarios': instance.horarios,
      'atualizado_em': instance.atualizadoEm.toIso8601String(),
    };

_$NotificationTypeSettingsModelImpl
    _$$NotificationTypeSettingsModelImplFromJson(Map<String, dynamic> json) =>
        _$NotificationTypeSettingsModelImpl(
          enabled: json['enabled'] as bool,
          push: json['push'] as bool,
          email: json['email'] as bool,
          sms: json['sms'] as bool,
          minPrioridade: json['min_prioridade'] as String,
        );

Map<String, dynamic> _$$NotificationTypeSettingsModelImplToJson(
        _$NotificationTypeSettingsModelImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'push': instance.push,
      'email': instance.email,
      'sms': instance.sms,
      'min_prioridade': instance.minPrioridade,
    };

_$NotificationTimeSettingsModelImpl
    _$$NotificationTimeSettingsModelImplFromJson(Map<String, dynamic> json) =>
        _$NotificationTimeSettingsModelImpl(
          respeitarHorarioComercial:
              json['respeitar_horario_comercial'] as bool,
          horaInicio: (json['hora_inicio'] as num).toInt(),
          minutoInicio: (json['minuto_inicio'] as num).toInt(),
          horaFim: (json['hora_fim'] as num).toInt(),
          minutoFim: (json['minuto_fim'] as num).toInt(),
          diasSemana: (json['dias_semana'] as List<dynamic>)
              .map((e) => (e as num).toInt())
              .toList(),
          pausarNotificacoes: json['pausar_notificacoes'] as bool,
          pausarAte: json['pausar_ate'] == null
              ? null
              : DateTime.parse(json['pausar_ate'] as String),
        );

Map<String, dynamic> _$$NotificationTimeSettingsModelImplToJson(
        _$NotificationTimeSettingsModelImpl instance) =>
    <String, dynamic>{
      'respeitar_horario_comercial': instance.respeitarHorarioComercial,
      'hora_inicio': instance.horaInicio,
      'minuto_inicio': instance.minutoInicio,
      'hora_fim': instance.horaFim,
      'minuto_fim': instance.minutoFim,
      'dias_semana': instance.diasSemana,
      'pausar_notificacoes': instance.pausarNotificacoes,
      'pausar_ate': instance.pausarAte?.toIso8601String(),
    };
