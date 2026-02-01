import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/refueling_history_model.dart';

/// Item de histórico de abastecimento com dados de eficiência
class EfficiencyHistoryItem extends StatelessWidget {
  final RefuelingHistoryModel item;
  final bool useL100km;
  final bool showDivider;

  const EfficiencyHistoryItem({
    super.key,
    required this.item,
    this.useL100km = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: showDivider
            ? Border(
                bottom: BorderSide(color: Colors.grey[100]!),
              )
            : null,
      ),
      child: Row(
        children: [
          // Date
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Text(
                  item.dayDisplay,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.monthDisplay,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Consumption with anomaly badge
                Row(
                  children: [
                    Text(
                      item.formatConsumption(useL100km: useL100km),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.isAnomaly) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning,
                              size: 12,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.deviationDisplay,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),

                // Details
                Text(
                  item.detailsDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Status icon
          SizedBox(
            width: 32,
            child: Icon(
              item.isAnomaly ? Icons.error : Icons.check_circle,
              size: 22,
              color: item.isAnomaly ? AppColors.error : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
