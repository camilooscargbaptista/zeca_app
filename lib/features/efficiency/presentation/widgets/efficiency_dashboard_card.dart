import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/efficiency_summary_model.dart';

/// Card de eficiência para exibir na Dashboard
/// Mostra resumo de consumo, tendência e comparação com frota
class EfficiencyDashboardCard extends StatelessWidget {
  final EfficiencySummaryModel? summary;
  final bool isLoading;
  final VoidCallback? onTap;
  final bool useL100km;

  const EfficiencyDashboardCard({
    super.key,
    this.summary,
    this.isLoading = false,
    this.onTap,
    this.useL100km = false,
  });

  @override
  Widget build(BuildContext context) {
    // Show empty state if no data
    if (!isLoading && (summary == null || !summary!.canDisplay)) {
      return _buildEmptyState(context);
    }

    // Show loading skeleton
    if (isLoading) {
      return _buildLoadingSkeleton(context);
    }

    // Show full card with data
    return _buildFullCard(context);
  }

  Widget _buildFullCard(BuildContext context) {
    final lastConsumption = useL100km
        ? summary!.lastVehicleConsumptionL100km
        : summary!.lastVehicleConsumptionKmL;
    final avgConsumption = useL100km
        ? summary!.personalAvgL100km
        : summary!.personalAvgKmL;
    final unit = useL100km ? 'L/100km' : 'km/L';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.zecaBlue, Color(0xFF1E5A9A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.zecaBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.show_chart,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'EFICIÊNCIA DE COMBUSTÍVEL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Main values
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Last consumption
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: lastConsumption?.toStringAsFixed(1) ?? '—',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' $unit',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Último abastecimento',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),

                // Average
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${avgConsumption?.toStringAsFixed(1) ?? '—'} $unit',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Sua média',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Footer with trend and comparison
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Trend
                  Row(
                    children: [
                      Icon(
                        _getTrendIcon(summary!.personalTrend),
                        color: _getTrendColor(summary!.personalTrend),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        summary!.trendLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getTrendColor(summary!.personalTrend),
                        ),
                      ),
                    ],
                  ),

                  // Fleet comparison
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: summary!.isBetterThanFleet
                          ? const Color(0xFF81C784).withOpacity(0.3)
                          : const Color(0xFFE57373).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${summary!.deviationDisplay} da frota',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: summary!.isBetterThanFleet
                            ? const Color(0xFF81C784)
                            : const Color(0xFFE57373),
                      ),
                    ),
                  ),

                  // See more
                  Row(
                    children: [
                      Text(
                        'Ver mais',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EEF5),
          border: Border.all(
            color: const Color(0xFFB0C4DE),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB0C4DE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.show_chart,
                    color: Color(0xFF6B8299),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'EFICIÊNCIA DE COMBUSTÍVEL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B8299),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Icon
            const Icon(
              Icons.hourglass_empty,
              size: 28,
              color: Color(0xFF6B8299),
            ),
            const SizedBox(height: 8),

            // Message
            const Text(
              'Aguardando abastecimentos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B8299),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Após 2 abastecimentos com KM,\nseus dados aparecerão aqui',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8CA0B3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 150,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
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
        return const Color(0xFF81C784);
      case 'WORSENING':
        return const Color(0xFFE57373);
      default:
        return Colors.white.withOpacity(0.8);
    }
  }
}
