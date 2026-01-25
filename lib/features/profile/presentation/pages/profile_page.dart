import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/di/injection.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/delete_account_dialog.dart';

/// Tela "Meu Perfil" - Exibe dados pessoais do usuário (somente leitura)
/// Para autônomos, inclui botão "Encerrar Conta"
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Carregar dados do usuário do storage
  Future<void> _loadUserData() async {
    try {
      final storageService = getIt<StorageService>();
      final userData = storageService.getUserData();
      
      if (mounted) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar dados do usuário: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Extrair iniciais do nome para o avatar
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Verificar se é autônomo
  bool get _isAutonomous {
    final companyType = _userData?['company']?['type'] as String?;
    return companyType == 'AUTONOMO';
  }

  /// Formatar CPF para exibição
  String _formatCpf(String? cpf) {
    if (cpf == null || cpf.isEmpty) return '';
    
    // Remover formatação existente
    final cleanCpf = cpf.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanCpf.length != 11) return cpf;
    
    return '${cleanCpf.substring(0, 3)}.${cleanCpf.substring(3, 6)}.${cleanCpf.substring(6, 9)}-${cleanCpf.substring(9)}';
  }

  /// Formatar telefone para exibição
  String _formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length == 11) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 7)}-${cleanPhone.substring(7)}';
    } else if (cleanPhone.length == 10) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 6)}-${cleanPhone.substring(6)}';
    }
    return phone;
  }

  /// Abrir dialog de encerrar conta
  Future<void> _handleDeleteAccount() async {
    final deleted = await DeleteAccountDialog.show(context);
    
    if (deleted && mounted) {
      // A conta foi excluída, o dialog já navegou para login
      debugPrint('✅ Conta encerrada com sucesso');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.zecaBlue,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Meu Perfil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? _buildNoDataView()
              : _buildProfileContent(),
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'Dados não encontrados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Faça login novamente para carregar seus dados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Ir para Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    final name = _userData?['name'] as String? ?? 'Usuário';
    final cpf = _userData?['cpf'] as String?;
    final email = _userData?['email'] as String?;
    final phone = _userData?['phone'] as String?;
    final companyName = _userData?['company']?['name'] as String?;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Avatar Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.zecaBlue,
                  AppColors.zecaBlue.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.zecaBlue,
                        AppColors.primaryBlueDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.zecaBlue.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Nome
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey900,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isAutonomous ? AppColors.zecaOrange : AppColors.zecaGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isAutonomous ? Icons.local_shipping : Icons.groups,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isAutonomous ? 'Autônomo' : 'Frotista',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Info Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // CPF
                if (cpf != null && cpf.isNotEmpty)
                  ProfileInfoCard(
                    icon: Icons.badge,
                    label: 'CPF',
                    value: _formatCpf(cpf),
                  ),

                // Email
                if (email != null && email.isNotEmpty)
                  ProfileInfoCard(
                    icon: Icons.email,
                    label: 'E-mail',
                    value: email,
                  ),

                // Telefone
                if (phone != null && phone.isNotEmpty)
                  ProfileInfoCard(
                    icon: Icons.phone,
                    label: 'Telefone',
                    value: _formatPhone(phone),
                  ),

                // Empresa
                if (companyName != null && companyName.isNotEmpty)
                  ProfileInfoCard(
                    icon: Icons.business,
                    label: 'Empresa',
                    value: companyName,
                  ),

                // Aviso para Frotistas
                if (!_isAutonomous)
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.zecaGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.verified_user,
                          size: 32,
                          color: AppColors.zecaGreen,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Para alterações no cadastro,\nentre em contato com o gestor da frota.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Botão Encerrar Conta (apenas para Autônomos)
                if (_isAutonomous)
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    padding: const EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.grey200),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleDeleteAccount,
                        icon: Icon(
                          Icons.delete_forever,
                          color: AppColors.error,
                        ),
                        label: Text(
                          'Encerrar Conta',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.error, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
