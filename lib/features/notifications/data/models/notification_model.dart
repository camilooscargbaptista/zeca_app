import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();
  
  const factory NotificationModel({
    required String id,
    required String titulo,
    required String mensagem,
    required String tipo,
    @JsonKey(name: 'prioridade') required String prioridade,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'criado_em') required DateTime criadoEm,
    @JsonKey(name: 'lido_em') DateTime? lidoEm,
    @JsonKey(name: 'acao') NotificationActionModel? acao,
    @JsonKey(name: 'dados_extras') Map<String, dynamic>? dadosExtras,
    @JsonKey(name: 'imagem_url') String? imagemUrl,
    @JsonKey(name: 'icone_url') String? iconeUrl,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'refueling_id') String? refuelingId,
    @JsonKey(name: 'vehicle_id') String? vehicleId,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      titulo: titulo,
      mensagem: mensagem,
      tipo: tipo,
      prioridade: NotificationPriority.fromString(prioridade) ?? NotificationPriority.media,
      status: NotificationStatus.fromString(status) ?? NotificationStatus.naoLida,
      criadoEm: criadoEm,
      lidoEm: lidoEm,
      acao: acao?.toEntity(),
      dadosExtras: dadosExtras,
      imagemUrl: imagemUrl,
      iconeUrl: iconeUrl,
      userId: userId,
      refuelingId: refuelingId,
      vehicleId: vehicleId,
    );
  }
}

@freezed
class NotificationActionModel with _$NotificationActionModel {
  const NotificationActionModel._();
  
  const factory NotificationActionModel({
    required String tipo,
    String? rota,
    Map<String, dynamic>? parametros,
    String? url,
    @JsonKey(name: 'texto_botao') String? textoBotao,
  }) = _NotificationActionModel;

  factory NotificationActionModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationActionModelFromJson(json);

  NotificationAction toEntity() {
    return NotificationAction(
      tipo: tipo,
      rota: rota,
      parametros: parametros,
      url: url,
      textoBotao: textoBotao,
    );
  }
}
