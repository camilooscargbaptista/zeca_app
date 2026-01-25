import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/dialogs/success_dialog.dart';

/// Modal de confirmação para encerrar conta
/// Requer senha de confirmação e permite motivo opcional
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({Key? key}) : super(key: key);

  /// Exibe o dialog e retorna true se a conta foi excluída
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DeleteAccountDialog(),
    );
    return result ?? false;
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  
  bool _isLoading = false;
  bool _isCheckingPendencies = true;
  bool _canDelete = false;
  String? _pendencyMessage;
  String? _selectedReason;
  bool _obscurePassword = true;

  final List<String> _reasons = [
    'Não uso mais o serviço',
    'Encontrei outro serviço',
    'Problemas com o app',
    'Dificuldades financeiras',
    'Outro motivo',
  ];

  @override
  void initState() {
    super.initState();
    _checkPendencies();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  /// Verificar se o usuário tem pendências antes de permitir exclusão
  Future<void> _checkPendencies() async {
    try {
      final response = await _apiService.checkCanDeleteAccount();
      
      if (mounted) {
        setState(() {
          _isCheckingPendencies = false;
          if (response['success'] == true) {
            _canDelete = response['data']?['canDelete'] ?? false;
            if (!_canDelete) {
              final pendencies = response['data']?['pendencies'];
              if (pendencies != null) {
                final pendingRefuelings = pendencies['pendingRefuelings'] ?? 0;
                if (pendingRefuelings > 0) {
                  _pendencyMessage = 'Você tem $pendingRefuelings abastecimento(s) pendente(s). '
                      'Finalize-os antes de encerrar a conta.';
                }
              }
            }
          } else {
            _pendencyMessage = response['error'] ?? 'Erro ao verificar pendências';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingPendencies = false;
          _pendencyMessage = 'Erro ao verificar pendências: $e';
        });
      }
    }
  }

  /// Confirmar exclusão da conta
  Future<void> _confirmDelete() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.deleteAccount(
        confirmationPassword: _passwordController.text,
        reason: _selectedReason,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response['success'] == true) {
        // Limpar todos os dados locais
        await _clearAllData();
        
        if (mounted) {
          Navigator.of(context).pop(true);
          
          // Mostrar mensagem de sucesso e navegar para login
          SuccessDialog.show(
            context,
            title: 'Conta Encerrada',
            message: 'Sua conta foi excluída com sucesso. Todos os dados foram anonimizados conforme a LGPD.',
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
          );
        }
      } else {
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Erro',
            message: response['error'] ?? 'Não foi possível excluir a conta',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Erro inesperado: $e',
        );
      }
    }
  }

  /// Limpar todos os dados locais após exclusão
  Future<void> _clearAllData() async {
    try {
      final storageService = getIt<StorageService>();
      final apiService = ApiService();
      
      apiService.clearAuthToken();
      apiService.clearRefreshToken();
      await storageService.clearTokens();
      await storageService.clearUserData();
      await storageService.clearJourneyVehicleData();
      
      UserService().clearUserData();
      
      debugPrint('✅ Todos os dados locais foram limpos');
    } catch (e) {
      debugPrint('⚠️ Erro ao limpar dados locais: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.grey200),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: AppColors.error,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Encerrar Conta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: _isCheckingPendencies
                  ? _buildLoadingContent()
                  : !_canDelete
                      ? _buildPendencyContent()
                      : _buildFormContent(),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: AppColors.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: AppColors.grey600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_isLoading || !_canDelete) ? null : _confirmDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirmar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Verificando pendências...',
          style: TextStyle(
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildPendencyContent() {
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          size: 48,
          color: AppColors.warning,
        ),
        const SizedBox(height: 16),
        Text(
          'Não é possível encerrar a conta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _pendencyMessage ?? 'Existem pendências que impedem a exclusão.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey600,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aviso
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppColors.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Esta ação é irreversível. Todos os seus dados serão anonimizados conforme a LGPD.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.error,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Campo de senha
          Text(
            'Senha de confirmação *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Digite sua senha',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grey200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grey200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.zecaBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.grey500,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'A senha é obrigatória';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Campo de motivo
          Text(
            'Motivo (opcional)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedReason,
            decoration: InputDecoration(
              hintText: 'Selecione um motivo...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grey200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grey200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.zecaBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            items: _reasons.map((reason) {
              return DropdownMenuItem(
                value: reason,
                child: Text(reason),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedReason = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
