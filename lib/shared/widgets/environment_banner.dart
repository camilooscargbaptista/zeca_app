import 'package:flutter/material.dart';
import '../../core/config/flavor_config.dart';

/// Widget que exibe um banner indicando ambiente de staging/dev
/// Deve ser usado no topo do app para indicar claramente que não é produção
class EnvironmentBanner extends StatelessWidget {
  final Widget child;
  
  const EnvironmentBanner({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    // Só exibe banner se NÃO for produção
    if (FlavorConfig.instance.isProduction) {
      return child;
    }
    
    return Banner(
      message: _getBannerText(),
      location: BannerLocation.topEnd,
      color: _getBannerColor(),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      child: child,
    );
  }
  
  String _getBannerText() {
    if (FlavorConfig.instance.isStaging) {
      return 'STAGING';
    } else if (FlavorConfig.instance.isDevelopment) {
      return 'DEV';
    }
    return FlavorConfig.instance.name.toUpperCase();
  }
  
  Color _getBannerColor() {
    if (FlavorConfig.instance.isStaging) {
      return Colors.orange;
    } else if (FlavorConfig.instance.isDevelopment) {
      return Colors.red;
    }
    return Colors.purple;
  }
}

/// Widget alternativo: barra fixa no topo da tela
class EnvironmentBar extends StatelessWidget {
  const EnvironmentBar({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Só exibe se NÃO for produção
    if (FlavorConfig.instance.isProduction) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        bottom: 4,
        left: 16,
        right: 16,
      ),
      color: _getBarColor(),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIcon(),
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              _getBarText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '• ${FlavorConfig.instance.baseUrl.replaceAll('https://', '')}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getBarText() {
    if (FlavorConfig.instance.isStaging) {
      return 'AMBIENTE DE TESTE';
    } else if (FlavorConfig.instance.isDevelopment) {
      return 'DESENVOLVIMENTO';
    }
    return FlavorConfig.instance.name.toUpperCase();
  }
  
  Color _getBarColor() {
    if (FlavorConfig.instance.isStaging) {
      return Colors.orange.shade700;
    } else if (FlavorConfig.instance.isDevelopment) {
      return Colors.red.shade700;
    }
    return Colors.purple.shade700;
  }
  
  IconData _getIcon() {
    if (FlavorConfig.instance.isStaging) {
      return Icons.science;
    } else if (FlavorConfig.instance.isDevelopment) {
      return Icons.developer_mode;
    }
    return Icons.bug_report;
  }
}
