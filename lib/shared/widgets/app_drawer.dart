import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/user_service.dart';
import '../../../core/di/injection.dart';

/// Widget unificado para o drawer (menu lateral) do app ZECA.
/// 
/// Este componente é usado em TODAS as telas do app para garantir
/// consistência visual e de navegação.
/// 
/// ## Regras de Negócio Implementadas:
/// - RN-MENU-001: Menu idêntico em todas as telas
/// - RN-MENU-002: Item "Histórico" sempre visível
/// - RN-MENU-003: Item "Sair" sempre em vermelho (AppColors.error)
/// - RN-MENU-004: Menu NÃO mostra status de jornada
/// - RN-MENU-005: Versão do app no rodapé
/// - RN-MENU-006: Header com avatar + nome + badge de tipo
/// - RN-MENU-007: Componente único reutilizado em todo app
class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _userName = 'Usuário';
  String _userInitials = 'US';
  bool _isAutonomous = false;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAppVersion();
  }

  /// Carrega dados do usuário do StorageService
  Future<void> _loadUserData() async {
    try {
      final storageService = getIt<StorageService>();
      final userData = storageService.getUserData();
      final userService = UserService();

      if (userData != null) {
        final name = userData['nome'] ?? userData['name'] ?? 'Usuário';
        final companyType = userData['company']?['type'] as String?;
        setState(() {
          _userName = name;
          _userInitials = _extractInitials(name);
          _isAutonomous = userService.isAutonomous || 
                          userData['is_autonomous'] == true ||
                          userData['isAutonomous'] == true ||
                          companyType == 'AUTONOMO';
        });
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar dados do usuário no drawer: $e');
    }
  }

  /// Carrega versão do app usando package_info_plus
  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = 'Versão ${packageInfo.version}+${packageInfo.buildNumber}';
      });
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar versão do app: $e');
      setState(() {
        _appVersion = 'Versão --';
      });
    }
  }

  /// Extrai iniciais do nome do usuário
  String _extractInitials(String name) {
    if (name.isEmpty) return 'US';
    
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
    } else if (names.isNotEmpty && names[0].length >= 2) {
      return names[0].substring(0, 2).toUpperCase();
    }
    return 'US';
  }

  /// Realiza logout e navega para login
  Future<void> _handleLogout() async {
    // Fechar drawer primeiro
    Navigator.of(context).pop();
    
    try {
      final storageService = getIt<StorageService>();
      final userService = UserService();
      
      // Limpar todos os dados
      await storageService.clearTokens();
      await storageService.clearUserData();
      await storageService.clearJourneyVehicleData();
      userService.clearUserData();
      
      debugPrint('✅ Logout realizado com sucesso');
      
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      debugPrint('❌ Erro ao realizar logout: $e');
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ============================================
          // HEADER: Avatar + Nome + Badge
          // ============================================
          _buildHeader(),
          
          // ============================================
          // MENU ITEMS
          // ============================================
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Meu Perfil
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'Meu Perfil',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile');
                  },
                ),
                
                // Meus Veículos - RN-MENU-008: Apenas para motoristas autônomos
                if (_isAutonomous)
                  _buildMenuItem(
                    icon: Icons.directions_car,
                    title: 'Meus Veículos',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/autonomous/vehicles');
                    },
                  ),
                
                // Histórico (RN-MENU-002: sempre visível)
                _buildMenuItem(
                  icon: Icons.receipt_long,
                  title: 'Histórico',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/history');
                  },
                ),
                
                // Eficiência de Combustível
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.zecaBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.show_chart,
                      color: AppColors.zecaBlue,
                    ),
                  ),
                  title: Row(
                    children: [
                      const Text(
                        'Eficiência',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.zecaBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'NOVO',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/efficiency');
                  },
                ),
                
                // Alterar Senha
                _buildMenuItem(
                  icon: Icons.lock_reset,
                  title: 'Alterar Senha',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/change-password');
                  },
                ),
                
                const Divider(height: 1),
                
                // Sair (RN-MENU-003: sempre em vermelho)
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Sair',
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: _handleLogout,
                ),
              ],
            ),
          ),
          
          // ============================================
          // FOOTER: Versão do App (RN-MENU-005)
          // ============================================
          _buildFooter(),
        ],
      ),
    );
  }

  /// Constrói o header do drawer com avatar, nome e badge
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.zecaBlue, AppColors.primaryBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar com iniciais
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                _userInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Nome do usuário
          Text(
            _userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          
          // Badge de tipo (RN-MENU-006)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _isAutonomous ? AppColors.zecaOrange : AppColors.secondaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _isAutonomous ? 'Autônomo' : 'Frotista',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói um item do menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.zecaBlue,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.grey900,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  /// Constrói o footer com versão do app
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.grey200),
        ),
      ),
      child: Center(
        child: Text(
          _appVersion,
          style: const TextStyle(
            color: AppColors.grey600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
