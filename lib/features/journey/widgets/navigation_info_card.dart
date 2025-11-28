import 'package:flutter/material.dart';
import '../../../core/utils/navigation_utils.dart';

/// Card que mostra informações da navegação durante a viagem (estilo Google Maps/Waze)
/// 
/// Suporta:
/// - Ícones de manobra dinâmicos (virar direita, esquerda, etc.)
/// - Distância em metros até próxima ação
/// - Instrução formatada ("Em 350m, vire à direita")
class NavigationInfoCard extends StatelessWidget {
  final String? currentStreet;
  final String? nextStreet;
  final String? nextInstruction;
  final String? estimatedTime;
  final double? distanceRemaining;
  final VoidCallback? onNextInstruction;
  
  /// 🆕 Tipo de manobra (turn-right, turn-left, straight, etc.)
  final String? maneuverType;
  
  /// 🆕 Distância em metros até a próxima manobra
  final double? distanceToNextMeters;

  const NavigationInfoCard({
    Key? key,
    this.currentStreet,
    this.nextStreet,
    this.nextInstruction,
    this.estimatedTime,
    this.distanceRemaining,
    this.onNextInstruction,
    this.maneuverType,
    this.distanceToNextMeters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: Colors.green[600],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Ícone de manobra dinâmico
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    NavigationUtils.getManeuverIcon(maneuverType),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                // Instrução de navegação
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🆕 Distância + Instrução formatada
                      if (distanceToNextMeters != null && nextInstruction != null)
                        Text(
                          NavigationUtils.formatInstructionWithDistance(
                            nextInstruction!,
                            distanceToNextMeters!,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      // Fallback: Rua atual
                      else if (currentStreet != null && currentStreet != 'Carregando...')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStreet!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (nextInstruction != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                nextInstruction!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        )
                      else if (currentStreet == 'Carregando...')
                        const Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Carregando navegação...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'Siga em frente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                // Botão "Depois" (próxima instrução)
                if (onNextInstruction != null)
                  TextButton(
                    onPressed: onNextInstruction,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Depois'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
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
