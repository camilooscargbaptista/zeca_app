import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_template_entity.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_template_model.freezed.dart';
part 'notification_template_model.g.dart';

@freezed
class NotificationTemplateModel with _$NotificationTemplateModel {
  const NotificationTemplateModel._();
  
  const factory NotificationTemplateModel({
    required String id,
    required String nome,
    required String tipo,
    required String titulo,
    required String mensagem,
    @JsonKey(name: 'prioridade') required String prioridade,
    @JsonKey(name: 'variaveis') required Map<String, String> variaveis,
    required bool ativo,
    @JsonKey(name: 'criado_em') required DateTime criadoEm,
    @JsonKey(name: 'atualizado_em') DateTime? atualizadoEm,
  }) = _NotificationTemplateModel;

  factory NotificationTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationTemplateModelFromJson(json);

  NotificationTemplateEntity toEntity() {
    return NotificationTemplateEntity(
      id: id,
      nome: nome,
      tipo: tipo,
      titulo: titulo,
      mensagem: mensagem,
      prioridade: NotificationPriority.fromString(prioridade) ?? NotificationPriority.media,
      variaveis: variaveis,
      ativo: ativo,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm,
    );
  }
}
