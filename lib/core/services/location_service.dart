import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Serviço para gerenciar localização e geocodificação
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Verificar se permissão de localização foi concedida
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('⚠️ Serviço de localização desabilitado');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      debugPrint('⚠️ Permissão de localização negada');
      return false;
    }
    
    if (permission == LocationPermission.deniedForever) {
      debugPrint('⚠️ Permissão de localização negada permanentemente');
      return false;
    }

    debugPrint('✅ Permissão de localização concedida');
    return true;
  }

  /// Solicitar permissão de localização (When In Use / Foreground)
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('⚠️ Serviço de localização desabilitado. Por favor, habilite nas configurações.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('❌ Permissão de localização negada pelo usuário');
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      debugPrint('❌ Permissão de localização negada permanentemente. Abra as configurações para habilitar.');
      return false;
    }

    debugPrint('✅ Permissão de localização concedida: $permission');
    return true;
  }

  /// Solicitar permissão de localização em background (Always / All the Time)
  /// Necessário para rastreamento contínuo durante jornadas
  Future<bool> requestBackgroundPermission() async {
    // Primeiro verificar se serviço está habilitado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('⚠️ Serviço de localização desabilitado. Por favor, habilite nas configurações.');
      return false;
    }

    // Verificar permissão atual
    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint('📍 Permissão atual: $permission');
    
    // Se já tem "Always", está OK
    if (permission == LocationPermission.always) {
      debugPrint('✅ Permissão de background já concedida (Always)');
      return true;
    }
    
    // Se negado permanentemente, não pode solicitar
    if (permission == LocationPermission.deniedForever) {
      debugPrint('❌ Permissão negada permanentemente. Usuário precisa abrir Configurações.');
      return false;
    }
    
    // Se negado ou não determinado, solicitar primeiro "When In Use"
    if (permission == LocationPermission.denied) {
      debugPrint('📍 Solicitando permissão "When In Use" primeiro...');
      permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        debugPrint('❌ Permissão "When In Use" negada');
        return false;
      }
      
      debugPrint('✅ Permissão "When In Use" concedida');
    }
    
    // Agora temos pelo menos "When In Use"
    // No iOS, o sistema solicitará automaticamente "Always" quando apropriado
    // No Android 10+, precisamos que o usuário vá para configurações
    
    if (Platform.isIOS) {
      // iOS: O sistema mostrará prompt de "Always" automaticamente
      // DEPOIS que o usuário usar o app por um tempo com "When In Use"
      debugPrint('📱 iOS detectado');
      
      if (permission == LocationPermission.whileInUse) {
        debugPrint('⚠️ Permissão "When In Use" concedida');
        debugPrint('💡 Para rastreamento em background:');
        debugPrint('   1. Use o app normalmente por alguns minutos');
        debugPrint('   2. iOS mostrará prompt "Sempre Permitir" automaticamente');
        debugPrint('   OU vá em: Ajustes > ZECA > Localização > Sempre Permitir');
        
        // Com "When In Use", o app funcionará em foreground
        // iOS mostrará o prompt de "Always" automaticamente depois
        return true;
      } else if (permission == LocationPermission.always) {
        debugPrint('✅ Permissão "Always" concedida - rastreamento em background habilitado');
        return true;
      }
      
      return false;
    } else {
      // Android: Verificar versão
      debugPrint('🤖 Android detectado');
      
      // Android 10+ (API 29+) requer que usuário vá para configurações
      // para conceder permissão "All the time"
      if (permission == LocationPermission.whileInUse) {
        debugPrint('⚠️ Permissão "While Using" concedida no Android');
        debugPrint('💡 Para rastreamento em background completo:');
        debugPrint('💡 1. Abra Configurações do Android');
        debugPrint('💡 2. Vá em Apps > ZECA > Permissões > Localização');
        debugPrint('💡 3. Selecione "Permitir o tempo todo"');
        
        // No Android, o Geolocator com ForegroundNotification ainda funciona
        // mesmo com "While Using" desde que o app esteja com notificação visível
        return true; // Retornar true pois foreground service funcionará
      }
      
      return permission == LocationPermission.always;
    }
  }

  /// Verificar se tem permissão de background
  Future<bool> hasBackgroundPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (Platform.isIOS) {
      // iOS: Precisa de "Always"
      return permission == LocationPermission.always;
    } else {
      // Android: "Always" é ideal, mas "WhileInUse" + ForegroundService funciona
      return permission == LocationPermission.always || 
             permission == LocationPermission.whileInUse;
    }
  }
  
  /// Abrir configurações do app para o usuário ajustar permissões
  Future<bool> openAppSettings() async {
    debugPrint('📱 Abrindo configurações do app...');
    return await Geolocator.openAppSettings();
  }
  
  /// Abrir configurações de localização do sistema
  Future<bool> openLocationSettings() async {
    debugPrint('📍 Abrindo configurações de localização...');
    return await Geolocator.openLocationSettings();
  }

  /// Obter posição atual (retorna Position diretamente)
  Future<Position?> getCurrentPosition() async {
    try {
      // Verificar permissão primeiro
      bool hasPermission = await checkPermission();
      if (!hasPermission) {
        hasPermission = await requestPermission();
        if (!hasPermission) {
          return null;
        }
      }

      debugPrint('📍 Obtendo posição atual...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint('✅ Posição obtida: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      debugPrint('❌ Erro ao obter posição: $e');
      return null;
    }
  }

  /// Obter localização atual
  Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      // Verificar permissão primeiro
      bool hasPermission = await checkPermission();
      if (!hasPermission) {
        hasPermission = await requestPermission();
        if (!hasPermission) {
          return null;
        }
      }

      debugPrint('📍 Obtendo localização atual...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint('✅ Localização obtida: ${position.latitude}, ${position.longitude}');

      // Tentar obter endereço via geocodificação reversa
      String? address;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          address = _formatAddress(place);
          debugPrint('✅ Endereço obtido: $address');
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao obter endereço: $e');
        // Continuar sem endereço, será buscado no backend
      }

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address, // Pode ser null, backend buscará automaticamente
      };
    } catch (e) {
      debugPrint('❌ Erro ao obter localização: $e');
      return null;
    }
  }

  /// Formatar endereço a partir de Placemark
  String _formatAddress(Placemark place) {
    List<String> parts = [];
    
    if (place.street != null && place.street!.isNotEmpty) {
      parts.add(place.street!);
    }
    
    if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
      parts.add(place.subThoroughfare!);
    }
    
    if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
      parts.add(place.thoroughfare!);
    }
    
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      parts.add(place.subLocality!);
    }
    
    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    }
    
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      parts.add(place.administrativeArea!);
    }
    
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      parts.add(place.postalCode!);
    }
    
    if (place.country != null && place.country!.isNotEmpty) {
      parts.add(place.country!);
    }

    return parts.join(', ');
  }

  /// Obter nome do dispositivo
  String getDeviceName() {
    if (Platform.isIOS) {
      return 'iOS Device';
    } else if (Platform.isAndroid) {
      return 'Android Device';
    }
    return 'Unknown Device';
  }
}




