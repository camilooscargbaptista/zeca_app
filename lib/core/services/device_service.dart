import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'storage_service.dart';
import '../di/injection.dart';

/// Serviço para gerenciar informações do dispositivo (Device ID, OS, modelo, etc)
/// Necessário para JWT Sliding Window com controle de sessões
class DeviceService {
  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Uuid _uuid = const Uuid();
  
  String? _cachedDeviceId;
  Map<String, dynamic>? _cachedDeviceInfo;
  
  static const String _deviceIdKey = 'zeca_device_id';
  
  /// Obter ou gerar Device ID único
  /// Este ID é gerado uma única vez e permanece o mesmo durante toda a vida do app
  /// Usado pelo backend para controlar sessões simultâneas (limite: 1 dispositivo)
  Future<String> getDeviceId() async {
    // Retornar de cache se já foi carregado
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }
    
    try {
      final storage = getIt<StorageService>();
      
      // Tentar buscar do storage
      String? deviceId = storage.read<String>(_deviceIdKey);
      
      // Se não existe, gerar novo UUID
      if (deviceId == null || deviceId.isEmpty) {
        deviceId = _uuid.v4();
        await storage.write(_deviceIdKey, deviceId);
        if (kDebugMode) {
          print('🆕 Novo Device ID gerado: $deviceId');
        }
      } else {
        if (kDebugMode) {
          print('✅ Device ID recuperado: $deviceId');
        }
      }
      
      _cachedDeviceId = deviceId;
      return deviceId;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao obter Device ID: $e');
      }
      // Fallback: gerar UUID temporário (não salva)
      return _uuid.v4();
    }
  }
  
  /// Obter informações detalhadas do dispositivo
  /// Retorna Map com: device_type, os, os_version, device_model, app_version, platform
  Future<Map<String, dynamic>> getDeviceInfo() async {
    // Retornar de cache se já foi carregado
    if (_cachedDeviceInfo != null) {
      return _cachedDeviceInfo!;
    }
    
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      
      Map<String, dynamic> deviceInfo = {
        'app_version': packageInfo.version,
        'app_build': packageInfo.buildNumber,
        'platform': Platform.isIOS ? 'ios' : 'android',
      };
      
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceInfo.addAll({
          'device_type': _getAndroidDeviceType(androidInfo),
          'os': 'Android',
          'os_version': androidInfo.version.release,
          'device_model': '${androidInfo.manufacturer} ${androidInfo.model}',
          'device_brand': androidInfo.brand,
          'sdk_version': androidInfo.version.sdkInt.toString(),
        });
        if (kDebugMode) {
          print('📱 Device Info (Android): ${androidInfo.manufacturer} ${androidInfo.model} - Android ${androidInfo.version.release}');
        }
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        deviceInfo.addAll({
          'device_type': _getIosDeviceType(iosInfo),
          'os': 'iOS',
          'os_version': iosInfo.systemVersion,
          'device_model': iosInfo.model,
          'device_name': iosInfo.name,
          'system_name': iosInfo.systemName,
        });
        if (kDebugMode) {
          print('📱 Device Info (iOS): ${iosInfo.model} - iOS ${iosInfo.systemVersion}');
        }
      } else {
        // Fallback para outras plataformas (improvável no mobile)
        deviceInfo.addAll({
          'device_type': 'unknown',
          'os': Platform.operatingSystem,
          'os_version': Platform.operatingSystemVersion,
          'device_model': 'unknown',
        });
      }
      
      _cachedDeviceInfo = deviceInfo;
      return deviceInfo;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao obter Device Info: $e');
      }
      // Fallback básico
      return {
        'device_type': 'mobile',
        'os': Platform.isIOS ? 'iOS' : 'Android',
        'os_version': 'unknown',
        'device_model': 'unknown',
        'app_version': '1.0.0',
        'platform': Platform.isIOS ? 'ios' : 'android',
      };
    }
  }
  
  /// Determinar tipo do dispositivo Android
  String _getAndroidDeviceType(AndroidDeviceInfo info) {
    // Heurística simples baseada em tamanho da tela
    // Pode ser melhorada com mais lógica
    final isTablet = info.isPhysicalDevice && 
                     (info.model.toLowerCase().contains('tab') || 
                      info.model.toLowerCase().contains('pad'));
    return isTablet ? 'tablet' : 'mobile';
  }
  
  /// Determinar tipo do dispositivo iOS
  String _getIosDeviceType(IosDeviceInfo info) {
    final model = info.model.toLowerCase();
    if (model.contains('ipad')) {
      return 'tablet';
    } else if (model.contains('iphone') || model.contains('ipod')) {
      return 'mobile';
    }
    return 'mobile'; // Default
  }
  
  /// Obter resumo do dispositivo (para logs)
  Future<String> getDeviceSummary() async {
    try {
      final deviceId = await getDeviceId();
      final deviceInfo = await getDeviceInfo();
      
      return '''
═══════════════════════════════════════════════════════
📱 DEVICE INFO
═══════════════════════════════════════════════════════
Device ID: $deviceId
Type: ${deviceInfo['device_type']}
OS: ${deviceInfo['os']} ${deviceInfo['os_version']}
Model: ${deviceInfo['device_model']}
App Version: ${deviceInfo['app_version']} (build ${deviceInfo['app_build']})
Platform: ${deviceInfo['platform']}
═══════════════════════════════════════════════════════
''';
    } catch (e) {
      return '❌ Erro ao obter resumo do dispositivo: $e';
    }
  }
  
  /// Limpar Device ID (CUIDADO: só usar em casos extremos como logout completo)
  /// Isso vai gerar um novo Device ID no próximo acesso
  Future<void> clearDeviceId() async {
    try {
      final storage = getIt<StorageService>();
      await storage.delete(_deviceIdKey);
      _cachedDeviceId = null;
      if (kDebugMode) {
        print('🗑️ Device ID limpo');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao limpar Device ID: $e');
      }
    }
  }
  
  /// Limpar cache de informações do dispositivo
  /// (Device ID não é limpo, apenas as informações detalhadas)
  void clearCache() {
    _cachedDeviceInfo = null;
    if (kDebugMode) {
      print('🧹 Cache de Device Info limpo');
    }
  }
}
