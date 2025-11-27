import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Card overlay que aparece durante a animação inicial (5s)
/// mostrando informações gerais da rota calculada
class RouteOverviewCard extends StatelessWidget {
  final String? destinationName;
  final double? distanceKm;
  final String? estimatedTime;

  const RouteOverviewCard({
    Key? key,
    this.destinationName,
    this.distanceKm,
    this.estimatedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone de sucesso
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),

              // Título
              const Text(
                'Rota Calculada!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.zecaBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Destino
              if (destinationName != null && destinationName!.isNotEmpty) ...[
                Text(
                  destinationName!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
              ],

              // Divider
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 16),

              // Informações da rota
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Distância
                  if (distanceKm != null)
                    _buildInfoItem(
                      icon: Icons.straighten,
                      label: 'Distância',
                      value: '${distanceKm!.toStringAsFixed(1)} km',
                    ),

                  // Divider vertical
                  if (distanceKm != null && estimatedTime != null)
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),

                  // Tempo estimado
                  if (estimatedTime != null)
                    _buildInfoItem(
                      icon: Icons.access_time,
                      label: 'Tempo',
                      value: estimatedTime!,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Indicador de loading
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.zecaBlue),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Iniciando navegação...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.zecaBlue, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

