import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/vehicle_efficiency_model.dart';

/// Card de eficiência do veículo atual
class EfficiencyVehicleCard extends StatelessWidget {
  final VehicleEfficiencyModel vehicle;
  final bool useL100km;

  const EfficiencyVehicleCard({
    super.key,
    required this.vehicle,
    this.useL100km = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  size: 16,
                  color: AppColors.zecaBlue,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'VEÍCULO ATUAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Plate badge and model
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.zecaBlue, Color(0xFF1E5A9A)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  vehicle.plate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                vehicle.model ?? 'Veículo',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Metrics
          _buildMetricRow(
            'Último consumo',
            vehicle.formatLastConsumption(useL100km: useL100km),
            isIdeal: false,
          ),
          _buildMetricRow(
            'Média do veículo',
            vehicle.formatMovingAvg(useL100km: useL100km),
            isIdeal: false,
          ),
          _buildMetricRow(
            'Consumo ideal',
            vehicle.formatIdealConsumption(useL100km: useL100km),
            isIdeal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, {bool isIdeal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[100]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isIdeal ? AppColors.success : Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
