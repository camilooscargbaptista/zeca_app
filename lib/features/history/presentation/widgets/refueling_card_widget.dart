import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/money.dart';
import '../../domain/entities/refueling_history_entity.dart';

/// Card que exibe um item do histórico de abastecimentos
class RefuelingCardWidget extends StatelessWidget {
  final RefuelingHistoryEntity refueling;
  final VoidCallback? onTap;

  const RefuelingCardWidget({
    Key? key,
    required this.refueling,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Data e Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.grey600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormat.format(refueling.refuelingDatetime),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeFormat.format(refueling.refuelingDatetime),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey400,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusBadge(),
                ],
              ),
              const SizedBox(height: 12),

              // Posto
              Row(
                children: [
                  Icon(
                    Icons.local_gas_station,
                    size: 18,
                    color: AppColors.zecaBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      refueling.stationName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Veículo
              Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 16,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    refueling.vehiclePlate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Detalhes do abastecimento
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Combustível e Litros
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          refueling.fuelType,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${refueling.quantityLiters.toStringAsFixed(1)} L',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Valor
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Valor total',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Money.fromDouble(refueling.totalAmount).formatted,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.zecaGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Pagamento (se disponível)
              if (refueling.paymentMethod != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 14,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      refueling.paymentMethod!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey600,
                      ),
                    ),
                    if (refueling.isAutonomous) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.zecaOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Autônomo',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.zecaOrange,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              // Indicador de navegação
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;

    if (refueling.isConcluido) {
      backgroundColor = AppColors.success.withOpacity(0.1);
      textColor = AppColors.success;
    } else if (refueling.isPendente) {
      backgroundColor = AppColors.warning.withOpacity(0.1);
      textColor = AppColors.warning;
    } else if (refueling.isCancelado) {
      backgroundColor = AppColors.error.withOpacity(0.1);
      textColor = AppColors.error;
    } else {
      backgroundColor = AppColors.grey200;
      textColor = AppColors.grey600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        refueling.statusLabel,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
