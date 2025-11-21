import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String titulo;
  final String mensagem;
  final String tipo;
  final NotificationPriority prioridade;
  final NotificationStatus status;
  final DateTime criadoEm;
  final DateTime? lidoEm;
  final NotificationAction? acao;
  final Map<String, dynamic>? dadosExtras;
  final String? imagemUrl;
  final String? iconeUrl;
  final String? userId;
  final String? refuelingId;
  final String? vehicleId;

  const NotificationEntity({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.tipo,
    required this.prioridade,
    required this.status,
    required this.criadoEm,
    this.lidoEm,
    this.acao,
    this.dadosExtras,
    this.imagemUrl,
    this.iconeUrl,
    this.userId,
    this.refuelingId,
    this.vehicleId,
  });

  @override
  List<Object?> get props => [
        id,
        titulo,
        mensagem,
        tipo,
        prioridade,
        status,
        criadoEm,
        lidoEm,
        acao,
        dadosExtras,
        imagemUrl,
        iconeUrl,
        userId,
        refuelingId,
        vehicleId,
      ];

  bool get isLida => status == NotificationStatus.lida;
  bool get isNaoLida => status == NotificationStatus.naoLida;
  bool get isArquivada => status == NotificationStatus.arquivada;
  bool get isAltaPrioridade => prioridade == NotificationPriority.alta;
  bool get isMediaPrioridade => prioridade == NotificationPriority.media;
  bool get isBaixaPrioridade => prioridade == NotificationPriority.baixa;
}

enum NotificationPriority {
  baixa('baixa', 'Baixa'),
  media('media', 'Média'),
  alta('alta', 'Alta'),
  critica('critica', 'Crítica');

  const NotificationPriority(this.value, this.label);
  
  final String value;
  final String label;

  static NotificationPriority? fromString(String value) {
    for (final priority in NotificationPriority.values) {
      if (priority.value == value) return priority;
    }
    return null;
  }
}

enum NotificationStatus {
  naoLida('nao_lida', 'Não Lida'),
  lida('lida', 'Lida'),
  arquivada('arquivada', 'Arquivada');

  const NotificationStatus(this.value, this.label);
  
  final String value;
  final String label;

  static NotificationStatus? fromString(String value) {
    for (final status in NotificationStatus.values) {
      if (status.value == value) return status;
    }
    return null;
  }
}

class NotificationAction extends Equatable {
  final String tipo;
  final String? rota;
  final Map<String, dynamic>? parametros;
  final String? url;
  final String? textoBotao;

  const NotificationAction({
    required this.tipo,
    this.rota,
    this.parametros,
    this.url,
    this.textoBotao,
  });

  @override
  List<Object?> get props => [tipo, rota, parametros, url, textoBotao];
}

enum NotificationType {
  refueling('refueling', 'Abastecimento', '⛽'),
  vehicle('vehicle', 'Veículo', '🚗'),
  system('system', 'Sistema', '🔔'),
  promotion('promotion', 'Promoção', '🎉'),
  maintenance('maintenance', 'Manutenção', '🔧'),
  security('security', 'Segurança', '🔒'),
  payment('payment', 'Pagamento', '💳'),
  reminder('reminder', 'Lembrete', '⏰');

  const NotificationType(this.value, this.label, this.emoji);
  
  final String value;
  final String label;
  final String emoji;

  static NotificationType? fromString(String value) {
    for (final type in NotificationType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
