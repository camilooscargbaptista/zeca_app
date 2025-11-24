import 'package:flutter/material.dart';

/// Card que mostra informações da navegação (rua atual, próxima instrução)
class NavigationInfoCard extends StatelessWidget {
  final String? currentStreet;
  final String? nextInstruction;
  final String? destinationName;
  final String? estimatedTime;
  final double? distanceRemaining;

  const NavigationInfoCard({
    Key? key,
    this.currentStreet,
    this.nextInstruction,
    this.destinationName,
    this.estimatedTime,
    this.distanceRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nome da rua atual
          if (currentStreet != null && currentStreet != 'Carregando...')
            Text(
              currentStreet!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          else if (currentStreet == 'Carregando...')
            const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'Carregando...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          
          if (currentStreet != null && nextInstruction != null)
            const SizedBox(height: 8),
          
          // Próxima instrução
          if (nextInstruction != null)
            Row(
              children: [
                const Icon(
                  Icons.turn_right,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    nextInstruction!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          
          if ((currentStreet != null || nextInstruction != null) && 
              (destinationName != null || estimatedTime != null))
            const Divider(height: 24),
          
          // Destino e tempo estimado
          if (destinationName != null || estimatedTime != null)
            Row(
              children: [
                const Icon(
                  Icons.place,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    destinationName ?? 'Destino',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (estimatedTime != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        estimatedTime!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                if (distanceRemaining != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '${distanceRemaining!.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
