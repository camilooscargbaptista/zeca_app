import 'package:flutter/material.dart';

/// Cores do design system ZECA
class _NotificationColors {
  static const Color errorRed = Color(0xFFF44336);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF2196F3);
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF757575);
  static const Color background = Color(0xFFF5F5F5);
}

/// Modais de notificação de abastecimento
/// 
/// Exibe modais para os eventos WebSocket:
/// - [showCancelledModal] - refueling:cancelled
/// - [showErrorModal] - refueling:error  
/// - [showValidatedByStationModal] - refueling:validated_by_station
class RefuelingNotificationDialogs {
  
  /// Modal de abastecimento cancelado pelo posto
  static Future<void> showCancelledModal(
    BuildContext context, {
    required String refuelingCode,
    required String cancellationReason,
    required VoidCallback onClose,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _NotificationColors.errorRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  size: 32,
                  color: _NotificationColors.errorRed,
                ),
              ),
              const SizedBox(height: 20),
              
              // Título
              const Text(
                'Abastecimento Cancelado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _NotificationColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Mensagem
              const Text(
                'O posto cancelou este abastecimento.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: _NotificationColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Motivo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: const Border(
                    left: BorderSide(
                      color: _NotificationColors.warningOrange,
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MOTIVO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _NotificationColors.warningOrange.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"$cancellationReason"',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: _NotificationColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Código
              Text(
                'Código: $refuelingCode',
                style: const TextStyle(
                  fontSize: 13,
                  color: _NotificationColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Botão
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Voltar para Início',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modal de erro no abastecimento
  static Future<void> showErrorModal(
    BuildContext context, {
    String? errorMessage,
    VoidCallback? onRetry,
    required VoidCallback onClose,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _NotificationColors.warningOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 32,
                  color: _NotificationColors.warningOrange,
                ),
              ),
              const SizedBox(height: 20),
              
              // Título
              const Text(
                'Erro no Abastecimento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _NotificationColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Mensagens
              const Text(
                'Ocorreu um erro ao processar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: _NotificationColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Entre em contato com o time ZECA.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: _NotificationColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Botões
              if (onRetry != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Tentar Novamente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _NotificationColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Voltar para Início',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _NotificationColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modal de validação pelo posto (em nome do motorista)
  static Future<void> showValidatedByStationModal(
    BuildContext context, {
    required String stationName,
    required String vehiclePlate,
    required double totalAmount,
    required String justification,
    required VoidCallback onClose,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _NotificationColors.infoBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 32,
                  color: _NotificationColors.infoBlue,
                ),
              ),
              const SizedBox(height: 20),
              
              // Título
              const Text(
                'Validado pelo Posto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _NotificationColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Mensagem
              const Text(
                'O posto validou seu abastecimento em seu nome.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: _NotificationColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Detalhes
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.local_gas_station, 'Posto', stationName),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.directions_car, 'Veículo', vehiclePlate),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Color(0xFFBBDEFB)),
                    ),
                    _buildInfoRow(
                      Icons.attach_money,
                      'Valor Total',
                      'R\$ ${totalAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Justificativa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: const Border(
                    left: BorderSide(
                      color: _NotificationColors.warningOrange,
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JUSTIFICATIVA DO POSTO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _NotificationColors.warningOrange.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"$justification"',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: _NotificationColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Botão
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Entendi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: _NotificationColors.infoBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: _NotificationColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isHighlight ? 18 : 14,
                  fontWeight: FontWeight.w600,
                  color: isHighlight ? const Color(0xFF1565C0) : _NotificationColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
