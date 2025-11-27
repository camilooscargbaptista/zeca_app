import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/journey_entity.dart';
import '../../../../core/theme/app_colors.dart';

/// Tela de resumo completo da jornada após finalização
/// 
/// Mostra:
/// - Distância total, tempos, velocidades
/// - Número de descansos realizados
/// - Lista resumida de trechos
/// - Botões para ver detalhes e voltar para Home
class JourneySummaryPage extends StatelessWidget {
  final JourneyEntity journey;

  const JourneySummaryPage({
    Key? key,
    required this.journey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contar descansos (se houver dados de rest_periods no journey)
    // Por enquanto,vamos usar uma estimativa baseada no tempo de descanso
    final int estimatedRestCount = journey.tempoDescansoSegundos > 0
        ? (journey.tempoDescansoSegundos / 1800).ceil() // ~30 min por descanso
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo da Viagem'),
        backgroundColor: AppColors.zecaBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remover botão voltar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Ícone de sucesso
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Viagem Finalizada!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              journey.placa,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // Cards de métricas
            _buildMetricCard(
              icon: Icons.route,
              label: 'Distância Total',
              value: '${journey.kmPercorridos.toStringAsFixed(1)} km',
              color: AppColors.zecaBlue,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.access_time,
                    label: 'Tempo em Viagem',
                    value: journey.formattedTempoDirecao,
                    color: Colors.green,
                    compact: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.hotel,
                    label: 'Tempo Descanso',
                    value: journey.formattedTempoDescanso,
                    color: Colors.orange,
                    compact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.speed,
                    label: 'Vel. Média',
                    value: journey.velocidadeMedia != null
                        ? '${journey.velocidadeMedia!.toStringAsFixed(1)} km/h'
                        : 'N/A',
                    color: Colors.blue,
                    compact: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.speed,
                    label: 'Vel. Máxima',
                    value: journey.velocidadeMaxima != null
                        ? '${journey.velocidadeMaxima!.toStringAsFixed(1)} km/h'
                        : 'N/A',
                    color: Colors.red,
                    compact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildMetricCard(
              icon: Icons.coffee,
              label: 'Descansos Realizados',
              value: estimatedRestCount > 0
                  ? '$estimatedRestCount ${estimatedRestCount == 1 ? "descanso" : "descansos"}'
                  : 'Nenhum descanso',
              color: Colors.brown,
            ),
            const SizedBox(height: 16),

            // Odômetro
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Odômetro Inicial',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${journey.odometroInicial} km',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  Column(
                    children: [
                      const Text(
                        'Odômetro Final',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${journey.odometroFinal} km',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de trechos (se houver)
            if (journey.segmentsSummary != null &&
                journey.segmentsSummary!.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Trechos da Viagem',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...journey.segmentsSummary!.map((segment) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.zecaBlue.withOpacity(0.1),
                      child: Text(
                        '${segment.segmentNumber}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.zecaBlue,
                        ),
                      ),
                    ),
                    title: Text(
                      '${segment.formattedDistance} • ${segment.formattedDuration}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: segment.avgSpeedKmh != null
                        ? Text('Média: ${segment.formattedAvgSpeed}')
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  context.push('/journey-segments/${journey.id}');
                },
                icon: const Icon(Icons.list_alt),
                label: const Text('Ver Detalhes dos Trechos'),
              ),
              const SizedBox(height: 24),
            ],

            // Botões de ação
            const Divider(),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.zecaBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 8),
                  Text(
                    'Voltar para Home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool compact = false,
  }) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: compact ? 28 : 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: compact ? 12 : 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: compact ? 16 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

