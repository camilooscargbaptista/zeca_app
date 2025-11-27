import 'package:flutter/material.dart';

/// Card que mostra resumo da rota antes de iniciar navegação (estilo Google Maps)
class RouteSummaryCard extends StatelessWidget {
  final String? originName;
  final String? destinationName;
  final String? estimatedTime;
  final double? distanceKm;
  final String? arrivalTime;
  final VoidCallback? onStart;
  final VoidCallback? onSwap;

  const RouteSummaryCard({
    Key? key,
    this.originName,
    this.destinationName,
    this.estimatedTime,
    this.distanceKm,
    this.arrivalTime,
    this.onStart,
    this.onSwap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Origem e Destino
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicadores de origem e destino
                Column(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 24,
                      color: Colors.grey[300],
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Nomes dos locais
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Origem
                      Text(
                        originName ?? 'Seu local',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Destino
                      Text(
                        destinationName ?? 'Destino',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botões de ação
                if (onSwap != null)
                  IconButton(
                    icon: const Icon(Icons.swap_vert, size: 20),
                    onPressed: onSwap,
                    tooltip: 'Trocar origem e destino',
                  ),
              ],
            ),
          ),
          
          // Informações de rota e botão iniciar
          if (estimatedTime != null || distanceKm != null || onStart != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // Informações de tempo e distância
                  if (estimatedTime != null || distanceKm != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (estimatedTime != null)
                            Row(
                              children: [
                                Text(
                                  estimatedTime!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                if (arrivalTime != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    'Chegada: $arrivalTime',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          if (distanceKm != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${distanceKm!.toStringAsFixed(1)} km',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  // Botão Iniciar
                  if (onStart != null)
                    ElevatedButton.icon(
                      onPressed: onStart,
                      icon: const Icon(Icons.navigation, size: 20),
                      label: const Text('Iniciar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

