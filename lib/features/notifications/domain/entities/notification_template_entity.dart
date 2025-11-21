import 'package:equatable/equatable.dart';
import 'notification_entity.dart';

class NotificationTemplateEntity extends Equatable {
  final String id;
  final String nome;
  final String tipo;
  final String titulo;
  final String mensagem;
  final NotificationPriority prioridade;
  final Map<String, String> variaveis;
  final bool ativo;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;

  const NotificationTemplateEntity({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.titulo,
    required this.mensagem,
    required this.prioridade,
    required this.variaveis,
    required this.ativo,
    required this.criadoEm,
    this.atualizadoEm,
  });

  @override
  List<Object?> get props => [
        id,
        nome,
        tipo,
        titulo,
        mensagem,
        prioridade,
        variaveis,
        ativo,
        criadoEm,
        atualizadoEm,
      ];

  String processarTemplate(Map<String, String> valores) {
    String resultado = mensagem;
    
    for (final entry in valores.entries) {
      resultado = resultado.replaceAll('{{${entry.key}}}', entry.value);
    }
    
    return resultado;
  }

  String processarTitulo(Map<String, String> valores) {
    String resultado = titulo;
    
    for (final entry in valores.entries) {
      resultado = resultado.replaceAll('{{${entry.key}}}', entry.value);
    }
    
    return resultado;
  }
}

enum NotificationTemplateType {
  refuelingCodeGenerated('refueling_code_generated', 'Código de Abastecimento Gerado'),
  refuelingCodeExpired('refueling_code_expired', 'Código de Abastecimento Expirado'),
  refuelingCompleted('refueling_completed', 'Abastecimento Finalizado'),
  refuelingCancelled('refueling_cancelled', 'Abastecimento Cancelado'),
  vehicleMaintenance('vehicle_maintenance', 'Manutenção do Veículo'),
  paymentDue('payment_due', 'Pagamento Vencido'),
  promotionAvailable('promotion_available', 'Promoção Disponível'),
  systemUpdate('system_update', 'Atualização do Sistema'),
  securityAlert('security_alert', 'Alerta de Segurança'),
  reminder('reminder', 'Lembrete');

  const NotificationTemplateType(this.value, this.label);
  
  final String value;
  final String label;

  static NotificationTemplateType? fromString(String value) {
    for (final type in NotificationTemplateType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
