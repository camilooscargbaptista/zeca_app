// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      mensagem: json['mensagem'] as String,
      tipo: json['tipo'] as String,
      prioridade: json['prioridade'] as String,
      status: json['status'] as String,
      criadoEm: DateTime.parse(json['criado_em'] as String),
      lidoEm: json['lido_em'] == null
          ? null
          : DateTime.parse(json['lido_em'] as String),
      acao: json['acao'] == null
          ? null
          : NotificationActionModel.fromJson(
              json['acao'] as Map<String, dynamic>),
      dadosExtras: json['dados_extras'] as Map<String, dynamic>?,
      imagemUrl: json['imagem_url'] as String?,
      iconeUrl: json['icone_url'] as String?,
      userId: json['user_id'] as String?,
      refuelingId: json['refueling_id'] as String?,
      vehicleId: json['vehicle_id'] as String?,
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'mensagem': instance.mensagem,
      'tipo': instance.tipo,
      'prioridade': instance.prioridade,
      'status': instance.status,
      'criado_em': instance.criadoEm.toIso8601String(),
      'lido_em': instance.lidoEm?.toIso8601String(),
      'acao': instance.acao,
      'dados_extras': instance.dadosExtras,
      'imagem_url': instance.imagemUrl,
      'icone_url': instance.iconeUrl,
      'user_id': instance.userId,
      'refueling_id': instance.refuelingId,
      'vehicle_id': instance.vehicleId,
    };

_$NotificationActionModelImpl _$$NotificationActionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationActionModelImpl(
      tipo: json['tipo'] as String,
      rota: json['rota'] as String?,
      parametros: json['parametros'] as Map<String, dynamic>?,
      url: json['url'] as String?,
      textoBotao: json['texto_botao'] as String?,
    );

Map<String, dynamic> _$$NotificationActionModelImplToJson(
        _$NotificationActionModelImpl instance) =>
    <String, dynamic>{
      'tipo': instance.tipo,
      'rota': instance.rota,
      'parametros': instance.parametros,
      'url': instance.url,
      'texto_botao': instance.textoBotao,
    };
