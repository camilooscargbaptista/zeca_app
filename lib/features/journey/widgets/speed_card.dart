import 'package:flutter/material.dart';

/// Card compacto que mostra velocidade atual vs limite
class SpeedCard extends StatelessWidget {
  final double? currentSpeed; // km/h
  final int? speedLimit; // km/h

  const SpeedCard({
    Key? key,
    this.currentSpeed,
    this.speedLimit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final speed = currentSpeed ?? 0;
    final limit = speedLimit ?? 0;
    final isOverSpeed = limit > 0 && speed > limit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isOverSpeed ? Colors.red.shade400 : Colors.white,
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
          // Velocidade atual
          Text(
            speed.round().toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isOverSpeed ? Colors.white : Colors.black87,
            ),
          ),
          // Label km/h
          Text(
            'km/h',
            style: TextStyle(
              fontSize: 12,
              color: isOverSpeed ? Colors.white70 : Colors.grey,
            ),
          ),
          // Limite de velocidade
          if (limit > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isOverSpeed ? Colors.white : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Limite $limit',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isOverSpeed ? Colors.red.shade400 : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
