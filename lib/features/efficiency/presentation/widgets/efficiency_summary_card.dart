import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/efficiency_summary_model.dart';

/// Card de resumo de eficiência para a tela principal
class EfficiencySummaryCard extends StatelessWidget {
  final EfficiencySummaryModel summary;
  final bool useL100km;

  const EfficiencySummaryCard({
    super.key,
    required this.summary,
    this.useL100km = false,
  });

  @override
  Widget build(BuildContext context) {
    final avgValue = useL100km ? summary.personalAvgL100km : summary.personalAvgKmL;
    final unit = useL100km ? 'L/100km' : 'km/L';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main value
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: avgValue?.toStringAsFixed(1) ?? '—',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: AppColors.zecaBlue,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$unit (Sua média)',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),

          // Trend badge
          if (summary.hasData)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getTrendBackgroundColor(summary.personalTrend),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getTrendIcon(summary.personalTrend),
                    size: 16,
                    color: _getTrendColor(summary.personalTrend),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    summary.trendLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _getTrendColor(summary.personalTrend),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Stats row
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  summary.deviationDisplay,
                  'vs. Frota',
                ),
                _buildStat(
                  summary.rankInFleet?.toString() ?? '—',
                  'Ranking',
                  suffix: '°',
                ),
                _buildStat(
                  summary.totalDriversInFleet.toString(),
                  'Motoristas',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, {String suffix = ''}) {
    return Column(
      children: [
        Text(
          '$value$suffix',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'IMPROVING':
        return Icons.trending_up;
      case 'WORSENING':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'IMPROVING':
        return AppColors.success;
      case 'WORSENING':
        return AppColors.error;
      default:
        return Colors.grey[600]!;
    }
  }

  Color _getTrendBackgroundColor(String trend) {
    switch (trend) {
      case 'IMPROVING':
        return const Color(0xFFE8F5E9);
      case 'WORSENING':
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey[100]!;
    }
  }
}
