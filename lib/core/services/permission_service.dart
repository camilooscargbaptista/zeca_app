import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:geolocator/geolocator.dart';

class PermissionService {
  // Solicitar permissão de câmera
  static Future<bool> requestCameraPermission() async {
    final status = await ph.Permission.camera.request();
    return status == ph.PermissionStatus.granted;
  }

  // Verificar se tem permissão de câmera
  static Future<bool> hasCameraPermission() async {
    final status = await ph.Permission.camera.status;
    return status == ph.PermissionStatus.granted;
  }

  // Solicitar permissão de galeria
  static Future<bool> requestStoragePermission() async {
    final status = await ph.Permission.photos.request();
    return status == ph.PermissionStatus.granted;
  }

  // Verificar se tem permissão de galeria
  static Future<bool> hasStoragePermission() async {
    final status = await ph.Permission.photos.status;
    return status == ph.PermissionStatus.granted;
  }

  // Solicitar permissão de localização
  static Future<bool> requestLocationPermission() async {
    final status = await ph.Permission.location.request();
    return status == ph.PermissionStatus.granted;
  }

  // Verificar se tem permissão de localização
  static Future<bool> hasLocationPermission() async {
    final status = await ph.Permission.location.status;
    return status == ph.PermissionStatus.granted;
  }

  // Solicitar permissão de notificações (temporariamente desabilitado)
  static Future<bool> requestNotificationPermission() async {
    // TODO: Implementar quando Firebase estiver configurado
    return true;
  }

  // Verificar se tem permissão de notificações (temporariamente desabilitado)
  static Future<bool> hasNotificationPermission() async {
    // TODO: Implementar quando Firebase estiver configurado
    return true;
  }

  // Solicitar todas as permissões necessárias
  static Future<Map<String, bool>> requestAllPermissions() async {
    final results = <String, bool>{};
    
    // Câmera
    results['camera'] = await requestCameraPermission();
    
    // Galeria
    results['storage'] = await requestStoragePermission();
    
    // Localização
    results['location'] = await requestLocationPermission();
    
    // Notificações
    results['notification'] = await requestNotificationPermission();
    
    return results;
  }

  // Verificar todas as permissões
  static Future<Map<String, bool>> checkAllPermissions() async {
    final results = <String, bool>{};
    
    results['camera'] = await hasCameraPermission();
    results['storage'] = await hasStoragePermission();
    results['location'] = await hasLocationPermission();
    results['notification'] = await hasNotificationPermission();
    
    return results;
  }

  // Abrir configurações do app
  static Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  // Verificar se o serviço de localização está habilitado
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Solicitar para habilitar o serviço de localização
  static Future<bool> requestLocationService() async {
    return await Geolocator.openLocationSettings();
  }
}
