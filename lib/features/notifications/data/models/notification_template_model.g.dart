// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationTemplateModelImpl _$$NotificationTemplateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationTemplateModelImpl(
      id: json['id'] as String,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      titulo: json['titulo'] as String,
      mensagem: json['mensagem'] as String,
      prioridade: json['prioridade'] as String,
      variaveis: Map<String, String>.from(json['variaveis'] as Map),
      ativo: json['ativo'] as bool,
      criadoEm: DateTime.parse(json['criado_em'] as String),
      atualizadoEm: json['atualizado_em'] == null
          ? null
          : DateTime.parse(json['atualizado_em'] as String),
    );

Map<String, dynamic> _$$NotificationTemplateModelImplToJson(
        _$NotificationTemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'tipo': instance.tipo,
      'titulo': instance.titulo,
      'mensagem': instance.mensagem,
      'prioridade': instance.prioridade,
      'variaveis': instance.variaveis,
      'ativo': instance.ativo,
      'criado_em': instance.criadoEm.toIso8601String(),
      'atualizado_em': instance.atualizadoEm?.toIso8601String(),
    };
