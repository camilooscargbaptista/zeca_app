import 'package:flutter/material.dart';

/// Bottom sheet com informações de chegada durante navegação (estilo Google Maps)
class NavigationBottomSheet extends StatelessWidget {
  final String? estimatedTime;
  final double? distanceRemaining;
  final String? arrivalTime;
  final VoidCallback? onExit;

  const NavigationBottomSheet({
    Key? key,
    this.estimatedTime,
    this.distanceRemaining,
    this.arrivalTime,
    this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Logo ou ícone
            const Text(
              'ZECA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            // Informações de chegada
            if (estimatedTime != null || distanceRemaining != null || arrivalTime != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (estimatedTime != null)
                      Text(
                        estimatedTime!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    if (distanceRemaining != null || arrivalTime != null)
                      Row(
                        children: [
                          if (distanceRemaining != null)
                            Text(
                              '${distanceRemaining!.toStringAsFixed(1)} km',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          if (distanceRemaining != null && arrivalTime != null)
                            Text(
                              ' • ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          if (arrivalTime != null)
                            Text(
                              'Chegada: $arrivalTime',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            // Botão Sair
            if (onExit != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onExit,
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Sair',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

