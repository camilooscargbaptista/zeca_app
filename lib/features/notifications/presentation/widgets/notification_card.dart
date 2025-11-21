import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../../../core/config/flavor_config.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onArchive,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: notification.isNaoLida ? 2 : 1,
      color: notification.isNaoLida 
          ? FlavorConfig.instance.primaryColor.withOpacity(0.05)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícone da notificação
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getNotificationColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getNotificationIcon(),
                  color: _getNotificationColor(),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Conteúdo da notificação
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.titulo,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: notification.isNaoLida 
                                  ? FontWeight.bold 
                                  : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (notification.isNaoLida)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: FlavorConfig.instance.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Mensagem
                    Text(
                      notification.mensagem,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Informações adicionais
                    Row(
                      children: [
                        // Tipo
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getNotificationColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getNotificationTypeLabel(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getNotificationColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Prioridade
                        if (notification.isAltaPrioridade)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'URGENTE',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        const Spacer(),

                        // Data
                        Text(
                          _formatDate(notification.criadoEm),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),

                    // Ação (se disponível)
                    if (notification.acao != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: FlavorConfig.instance.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: FlavorConfig.instance.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.touch_app,
                              color: FlavorConfig.instance.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              notification.acao!.textoBotao ?? 'Tocar para abrir',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: FlavorConfig.instance.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Menu de ações
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      onMarkAsRead?.call();
                      break;
                    case 'archive':
                      onArchive?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (notification.isNaoLida)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.mark_email_read, size: 16),
                          SizedBox(width: 8),
                          Text('Marcar como lida'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'archive',
                    child: Row(
                      children: [
                        Icon(Icons.archive, size: 16),
                        SizedBox(width: 8),
                        Text('Arquivar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Excluir', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor() {
    switch (notification.tipo) {
      case 'refueling':
        return Colors.blue;
      case 'vehicle':
        return Colors.green;
      case 'system':
        return Colors.orange;
      case 'promotion':
        return Colors.purple;
      case 'maintenance':
        return Colors.amber;
      case 'security':
        return Colors.red;
      case 'payment':
        return Colors.teal;
      case 'reminder':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon() {
    switch (notification.tipo) {
      case 'refueling':
        return Icons.local_gas_station;
      case 'vehicle':
        return Icons.directions_car;
      case 'system':
        return Icons.settings;
      case 'promotion':
        return Icons.local_offer;
      case 'maintenance':
        return Icons.build;
      case 'security':
        return Icons.security;
      case 'payment':
        return Icons.payment;
      case 'reminder':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  String _getNotificationTypeLabel() {
    switch (notification.tipo) {
      case 'refueling':
        return 'Abastecimento';
      case 'vehicle':
        return 'Veículo';
      case 'system':
        return 'Sistema';
      case 'promotion':
        return 'Promoção';
      case 'maintenance':
        return 'Manutenção';
      case 'security':
        return 'Segurança';
      case 'payment':
        return 'Pagamento';
      case 'reminder':
        return 'Lembrete';
      default:
        return 'Notificação';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min atrás';
    } else {
      return 'Agora';
    }
  }
}
