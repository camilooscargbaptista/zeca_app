import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

/// Serviço para gerenciar Deep Links
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final GlobalKey<NavigatorState>? _navigatorKey = GlobalKey<NavigatorState>();

  /// Configurar navigator key
  void setNavigatorKey(GlobalKey<NavigatorState> key) {
    // Este método será usado se precisarmos de um navigator global
  }

  /// Processar deep link
  /// 
  /// [data] - Dados do deep link (pode vir de push notification ou URL)
  Future<void> handleDeepLink(
    BuildContext? context,
    Map<String, dynamic> data,
  ) async {
    try {
      final type = data['type'] as String?;
      final refuelingId = data['refueling_id'] as String?;

      if (context == null) {
        debugPrint('⚠️ Context não disponível para processar deep link');
        return;
      }

      switch (type) {
        case 'refueling_validation_pending':
          if (refuelingId != null && refuelingId.isNotEmpty) {
            debugPrint('🔗 Navegando para validação: $refuelingId');
            context.go('/refueling-validation/$refuelingId');
          }
          break;

        case 'refueling_waiting':
          // Navegar para tela de aguardando
          final refuelingCode = data['refueling_code'] as String? ?? '';
          context.go('/refueling-waiting', extra: {
            'refueling_id': refuelingId ?? '',
            'refueling_code': refuelingCode,
            'vehicle_data': data['vehicle_data'],
            'station_data': data['station_data'],
          });
          break;

        default:
          debugPrint('⚠️ Tipo de deep link desconhecido: $type');
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar deep link: $e');
    }
  }

  /// Processar URL deep link
  /// 
  /// Formato esperado: zeca://refueling-validation/{id}
  Future<void> handleUrlDeepLink(
    BuildContext? context,
    String url,
  ) async {
    try {
      debugPrint('🔗 Processando URL deep link: $url');

      // Parse da URL
      final uri = Uri.parse(url);
      
      if (uri.scheme != 'zeca') {
        debugPrint('⚠️ Scheme não reconhecido: ${uri.scheme}');
        return;
      }

      final path = uri.path;
      final segments = path.split('/').where((s) => s.isNotEmpty).toList();

      if (segments.isEmpty) {
        return;
      }

      final route = segments[0];
      final params = <String, dynamic>{};

      // Extrair parâmetros da query string
      uri.queryParameters.forEach((key, value) {
        params[key] = value;
      });

      switch (route) {
        case 'refueling-validation':
          if (segments.length > 1) {
            final refuelingId = segments[1];
            if (context != null) {
              context.go('/refueling-validation/$refuelingId');
            }
          }
          break;

        case 'refueling-waiting':
          if (context != null) {
            context.go('/refueling-waiting', extra: params);
          }
          break;

        default:
          debugPrint('⚠️ Rota deep link desconhecida: $route');
      }
    } catch (e) {
      debugPrint('❌ Erro ao processar URL deep link: $e');
    }
  }
}

