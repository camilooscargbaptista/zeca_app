import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/volume.dart';
import '../../domain/entities/refueling_history_entity.dart';

/// Widget que exibe o resumo/totalizadores do histórico
class HistorySummaryWidget extends StatelessWidget {
  final HistorySummaryEntity summary;

  const HistorySummaryWidget({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 20,
                  color: AppColors.zecaBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumo do Período',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.local_gas_station,
                  label: 'Abastecimentos',
                  value: '${summary.totalRefuelings}',
                  color: AppColors.zecaBlue,
                ),
                _buildStatItem(
                  icon: Icons.water_drop,
                  label: 'Total Litros',
                  value: Volume.fromDouble(summary.totalLiters).formatted,
                  color: AppColors.zecaGreen,
                ),
                _buildStatItem(
                  icon: Icons.attach_money,
                  label: 'Valor Total',
                  value: Money.fromDouble(summary.totalValue).formatted,
                  color: AppColors.zecaOrange,
                ),
              ],
            ),
            if (summary.totalRefuelings > 0) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Média: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey600,
                    ),
                  ),
                  Text(
                    '${Money.fromDouble(summary.averagePricePerLiter).formatted}/L',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.zecaBlue,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }
}
