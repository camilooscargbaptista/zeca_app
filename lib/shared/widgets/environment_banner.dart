import 'package:flutter/material.dart';
import '../../core/config/flavor_config.dart';

/// Widget que mostra um banner indicando o ambiente atual (DEV/STAGING)
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
          child,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: _getBannerColor(config.flavor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getBannerIcon(config.flavor),
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getBannerText(config.flavor),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
        return '🔧 DESENVOLVIMENTO';
      case Flavor.staging:
        return '🧪 STAGING - stg.abastecacomzeca.com.br';
      default:
        return flavor.name.toUpperCase();
    }
  }
}
