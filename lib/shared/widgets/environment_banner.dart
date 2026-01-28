import 'package:flutter/material.dart';
import '../../core/config/flavor_config.dart';

/// Widget que mostra um banner indicando o ambiente atual (DEV/STAGING)
/// O banner fica sobreposto na área da barra de status, não afeta o layout.
/// Não é exibido em produção.
class EnvironmentBanner extends StatelessWidget {
  final Widget child;

  const EnvironmentBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final config = FlavorConfig.instance;
    
    // Não mostrar em produção
    if (config.isProduction) {
      return child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          // Conteúdo do app (sem alteração de layout)
          child,
          // Banner sobreposto na área da status bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  bottom: 2,
                ),
                decoration: BoxDecoration(
                  color: _getBannerColor(config.flavor).withOpacity(0.95),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getBannerIcon(config.flavor),
                      size: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getBannerText(config.flavor),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBannerColor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return Colors.purple;
      case Flavor.staging:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getBannerIcon(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return Icons.developer_mode;
      case Flavor.staging:
        return Icons.science;
      default:
        return Icons.info;
    }
  }

  String _getBannerText(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return 'DEV';
      case Flavor.staging:
        return 'STAGING - stg.abastecacomzeca.com.br';
      default:
        return flavor.name.toUpperCase();
    }
  }
}
