import 'package:flutter/material.dart';
import 'permission_service.dart';
import '../../shared/widgets/permissions/permission_request_dialog.dart';
import '../../shared/widgets/dialogs/success_dialog.dart';

class AppInitializationService {
  // Inicialização geral do app
  static Future<void> initialize() async {
    // Aqui podem ser adicionadas outras inicializações necessárias
    // como configuração de storage, notificações, etc.
  }

  // Verificar e solicitar permissões essenciais no início do app
  static Future<void> initializePermissions(BuildContext context) async {
    try {
      final requiredPermissions = ['camera', 'storage', 'location', 'notification'];
      
      // Verificar se todas as permissões já foram concedidas
      final permissions = await PermissionService.checkAllPermissions();
      final missingPermissions = <String>[];
      
      for (String permission in requiredPermissions) {
        if (permissions[permission] != true) {
          missingPermissions.add(permission);
        }
      }
      
      // Se há permissões faltando, solicitar automaticamente primeiro
      if (missingPermissions.isNotEmpty && context.mounted) {
        // Solicitar permissões automaticamente primeiro
        await _requestPermissionsAutomatically(missingPermissions);
        
        // Depois mostrar o dialog para as que não foram concedidas
        final remainingPermissions = await _checkRemainingPermissions(requiredPermissions);
        if (remainingPermissions.isNotEmpty && context.mounted) {
          await _showPermissionDialog(context, remainingPermissions);
        }
      }
    } catch (e) {
      print('Erro ao inicializar permissões: $e');
    }
  }

  // Solicitar permissões automaticamente
  static Future<void> _requestPermissionsAutomatically(List<String> permissions) async {
    for (String permission in permissions) {
      try {
        switch (permission) {
          case 'camera':
            await PermissionService.requestCameraPermission();
            break;
          case 'storage':
            await PermissionService.requestStoragePermission();
            break;
          case 'location':
            await PermissionService.requestLocationPermission();
            break;
          case 'notification':
            await PermissionService.requestNotificationPermission();
            break;
        }
        // Pequena pausa entre solicitações
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        print('Erro ao solicitar permissão $permission: $e');
      }
    }
  }

  // Verificar permissões restantes após solicitação automática
  static Future<List<String>> _checkRemainingPermissions(List<String> requiredPermissions) async {
    final permissions = await PermissionService.checkAllPermissions();
    final remaining = <String>[];
    
    for (String permission in requiredPermissions) {
      if (permissions[permission] != true) {
        remaining.add(permission);
      }
    }
    
    return remaining;
  }

  static Future<void> _showPermissionDialog(BuildContext context, List<String> missingPermissions) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionRequestDialog(
        requiredPermissions: missingPermissions,
        onAllGranted: () {
          Navigator.of(context).pop();
          SuccessDialog.show(
            context,
            title: 'Permissões Concedidas',
            message: 'Todas as permissões foram concedidas!',
          );
        },
        onDenied: () {
          // Ação simples: apenas fechar o modal
          Navigator.of(context).pop();
        },
      ),
    );
  }

  // Verificar permissões específicas antes de usar funcionalidades
  static Future<bool> checkCameraPermission(BuildContext context) async {
    final hasPermission = await PermissionService.hasCameraPermission();
    if (!hasPermission) {
      await _showPermissionDialog(context, ['camera']);
      return await PermissionService.hasCameraPermission();
    }
    return true;
  }

  static Future<bool> checkStoragePermission(BuildContext context) async {
    final hasPermission = await PermissionService.hasStoragePermission();
    if (!hasPermission) {
      await _showPermissionDialog(context, ['storage']);
      return await PermissionService.hasStoragePermission();
    }
    return true;
  }

  static Future<bool> checkLocationPermission(BuildContext context) async {
    final hasPermission = await PermissionService.hasLocationPermission();
    if (!hasPermission) {
      await _showPermissionDialog(context, ['location']);
      return await PermissionService.hasLocationPermission();
    }
    return true;
  }

  static Future<bool> checkNotificationPermission(BuildContext context) async {
    final hasPermission = await PermissionService.hasNotificationPermission();
    if (!hasPermission) {
      await _showPermissionDialog(context, ['notification']);
      return await PermissionService.hasNotificationPermission();
    }
    return true;
  }
}
