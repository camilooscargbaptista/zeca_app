import 'dart:io';
import 'package:flutter/foundation.dart';

// Import do arquivo local (não commitado)
import 'api_keys.local.dart' as local;

/// Configuração de chaves de API
/// 
/// IMPORTANTE: Este arquivo NÃO deve conter chaves reais.
/// Use variáveis de ambiente ou um arquivo local api_keys.local.dart
class ApiKeys {
  static String? _cachedKey;

  /// Chave da API do Google Maps (Places, Directions, Geocoding)
  /// 
  /// Prioridade:
  /// 1. Variável de ambiente GOOGLE_MAPS_API_KEY
  /// 2. Arquivo api_keys.local.dart (não commitado) - descomente o import acima
  /// 
  /// Se nenhuma for encontrada, lança exceção em produção.
  static String get googleMapsApiKey {
    if (_cachedKey != null) {
      return _cachedKey!;
    }

    // Tentar variável de ambiente primeiro
    final envKey = Platform.environment['GOOGLE_MAPS_API_KEY'];
    if (envKey != null && envKey.isNotEmpty && envKey != 'GOOGLE_MAPS_API_KEY_PLACEHOLDER') {
      _cachedKey = envKey;
      return _cachedKey!;
    }

    // Tentar arquivo local (não commitado)
    try {
      final key = local.LocalApiKeys.googleMapsApiKey;
      if (key.isNotEmpty && key != 'GOOGLE_MAPS_API_KEY_PLACEHOLDER') {
        _cachedKey = key;
        debugPrint('✅ [ApiKeys] API Key carregada do arquivo local');
        return _cachedKey!;
      }
    } catch (e) {
      debugPrint('⚠️ [ApiKeys] Arquivo local não encontrado ou inválido: $e');
    }
    
    // Fallback: tentar ler do arquivo local diretamente (se o import falhou)
    if (kDebugMode) {
      try {
        final localFile = File('lib/core/config/api_keys.local.dart');
        if (localFile.existsSync()) {
          final content = localFile.readAsStringSync();
          final match = RegExp(r"googleMapsApiKey = '([^']+)'").firstMatch(content);
          if (match != null && match.group(1) != null) {
            final key = match.group(1)!;
            if (key.isNotEmpty && key != 'GOOGLE_MAPS_API_KEY_PLACEHOLDER') {
              _cachedKey = key;
              debugPrint('✅ [ApiKeys] API Key carregada via fallback (leitura direta)');
              return _cachedKey!;
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ [ApiKeys] Erro ao ler arquivo local via fallback: $e');
      }
      
      debugPrint('⚠️⚠️⚠️ [ApiKeys] ATENÇÃO: GOOGLE_MAPS_API_KEY não configurada!');
      debugPrint('⚠️ Configure a variável de ambiente ou crie api_keys.local.dart');
      debugPrint('⚠️ Para produção, isso NÃO deve acontecer!');
      // Em desenvolvimento, retornar placeholder (não funcionará, mas não quebra o app)
      return 'GOOGLE_MAPS_API_KEY_PLACEHOLDER';
    }

    // Em produção, lançar exceção
    throw Exception(
      'GOOGLE_MAPS_API_KEY não configurada.\n\n'
      'Configure de uma das seguintes formas:\n'
      '1. Variável de ambiente: export GOOGLE_MAPS_API_KEY=sua_chave\n'
      '2. Arquivo local: crie lib/core/config/api_keys.local.dart\n'
      '3. Para Android/iOS: substitua GOOGLE_MAPS_API_KEY_PLACEHOLDER nos arquivos nativos',
    );
  }
}
