import 'package:flutter/material.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/theme/app_colors.dart';

class PermissionRequestDialog extends StatefulWidget {
  final List<String> requiredPermissions;
  final VoidCallback? onAllGranted;
  final VoidCallback? onDenied;

  const PermissionRequestDialog({
    Key? key,
    required this.requiredPermissions,
    this.onAllGranted,
    this.onDenied,
  }) : super(key: key);

  @override
  State<PermissionRequestDialog> createState() => _PermissionRequestDialogState();
}

class _PermissionRequestDialogState extends State<PermissionRequestDialog> {
  final Map<String, bool> _permissionStatus = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isLoading = true;
    });

    final status = await PermissionService.checkAllPermissions();
    
    setState(() {
      _permissionStatus.clear();
      _permissionStatus.addAll(status);
      _isLoading = false;
    });
  }

  Future<void> _requestPermission(String permission) async {
    if (_isLoading) return; // Evitar múltiplas solicitações
    
    setState(() {
      _isLoading = true;
    });

    try {
      bool granted = false;
      switch (permission) {
        case 'camera':
          granted = await PermissionService.requestCameraPermission();
          break;
        case 'storage':
          granted = await PermissionService.requestStoragePermission();
          break;
        case 'location':
          granted = await PermissionService.requestLocationPermission();
          break;
        case 'notification':
          granted = await PermissionService.requestNotificationPermission();
          break;
      }

      setState(() {
        _permissionStatus[permission] = granted;
        _isLoading = false;
      });

      // Verificar se todas as permissões foram concedidas
      if (_allPermissionsGranted()) {
        widget.onAllGranted?.call();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Mostrar erro se necessário
    }
  }

  bool _allPermissionsGranted() {
    for (String permission in widget.requiredPermissions) {
      if (_permissionStatus[permission] != true) {
        return false;
      }
    }
    return true;
  }

  String _getPermissionTitle(String permission) {
    switch (permission) {
      case 'camera':
        return 'Câmera';
      case 'storage':
        return 'Galeria';
      case 'location':
        return 'Localização';
      case 'notification':
        return 'Notificações';
      default:
        return permission;
    }
  }

  String _getPermissionDescription(String permission) {
    switch (permission) {
      case 'camera':
        return 'Necessário para capturar fotos dos comprovantes';
      case 'storage':
        return 'Necessário para acessar imagens da galeria';
      case 'location':
        return 'Necessário para encontrar postos próximos';
      case 'notification':
        return 'Necessário para receber notificações do app';
      default:
        return 'Permissão necessária para o funcionamento do app';
    }
  }

  IconData _getPermissionIcon(String permission) {
    switch (permission) {
      case 'camera':
        return Icons.camera_alt;
      case 'storage':
        return Icons.photo_library;
      case 'location':
        return Icons.location_on;
      case 'notification':
        return Icons.notifications;
      default:
        return Icons.security;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Permissões Necessárias',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              'O app precisa de algumas permissões para funcionar corretamente:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Permissions List
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              ...widget.requiredPermissions.map((permission) {
                final isGranted = _permissionStatus[permission] ?? false;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isGranted ? AppColors.zecaGreen.withOpacity(0.1) : AppColors.zecaBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isGranted ? AppColors.zecaGreen.withOpacity(0.3) : AppColors.zecaBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row with Icon and Title
                      Row(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isGranted ? AppColors.zecaGreen.withOpacity(0.2) : AppColors.zecaBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getPermissionIcon(permission),
                              color: isGranted ? AppColors.zecaGreen : AppColors.zecaBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Title
                          Expanded(
                            child: Text(
                              _getPermissionTitle(permission),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isGranted ? AppColors.zecaGreen : AppColors.zecaBlue,
                              ),
                            ),
                          ),
                          
                          // Status Icon (if granted)
                          if (isGranted)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.zecaGreen,
                              size: 24,
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Description Body
                      Text(
                        _getPermissionDescription(permission),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isGranted ? AppColors.zecaGreen.withOpacity(0.8) : AppColors.zecaBlue.withOpacity(0.8),
                          height: 1.4,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Action Button at Bottom
                      if (!isGranted)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => _requestPermission(permission),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Solicitar'),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Ação simples: apenas fechar o modal
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Pular'),
                  ),
                ),
                const SizedBox(width: 12),
                if (_allPermissionsGranted())
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onAllGranted?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.zecaGreen,
                        foregroundColor: AppColors.zecaWhite,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Continuar'),
                    ),
                  )
                else
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await PermissionService.openAppSettings();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Configurações'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
