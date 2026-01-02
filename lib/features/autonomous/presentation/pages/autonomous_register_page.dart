import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../shared/widgets/common/custom_toast.dart';
import '../bloc/autonomous_registration_bloc.dart';

class AutonomousRegisterPage extends StatefulWidget {
  const AutonomousRegisterPage({Key? key}) : super(key: key);

  @override
  State<AutonomousRegisterPage> createState() => _AutonomousRegisterPageState();
}

class _AutonomousRegisterPageState extends State<AutonomousRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;

  // Máscaras
  final _cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final _birthDateMaskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validação de CPF com algoritmo oficial
  bool _isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;
    
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int firstDigit = (sum * 10) % 11;
    if (firstDigit == 10) firstDigit = 0;
    if (firstDigit != int.parse(cpf[9])) return false;
    
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int secondDigit = (sum * 10) % 11;
    if (secondDigit == 10) secondDigit = 0;
    if (secondDigit != int.parse(cpf[10])) return false;
    
    return true;
  }

  /// Validação de data de nascimento
  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data de nascimento é obrigatória';
    }
    
    final parts = value.split('/');
    if (parts.length != 3) return 'Data inválida';
    
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    
    if (day == null || month == null || year == null) return 'Data inválida';
    if (day < 1 || day > 31 || month < 1 || month > 12) return 'Data inválida';
    if (year < 1900 || year > DateTime.now().year - 18) {
      return 'Você deve ter pelo menos 18 anos';
    }
    
    try {
      final date = DateTime(year, month, day);
      if (date.day != day || date.month != month) return 'Data inválida';
    } catch (e) {
      return 'Data inválida';
    }
    
    return null;
  }

  /// Converter data DD/MM/YYYY para YYYY-MM-DD
  String _formatBirthDateForApi(String date) {
    final parts = date.split('/');
    if (parts.length != 3) return date;
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsAccepted) {
        CustomToast.showError(context, 'Você precisa aceitar os termos de uso');
        return;
      }

      final cpf = _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final phone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final birthDate = _formatBirthDateForApi(_birthDateController.text);

      context.read<AutonomousRegistrationBloc>().add(
            AutonomousRegistrationEvent.register(
              name: _nameController.text.trim(),
              cpf: cpf,
              phone: phone,
              birthDate: birthDate,
              email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
              password: _passwordController.text,
              termsAccepted: _termsAccepted,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlavorConfig.instance.primaryColor;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Cadastro Autônomo',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AutonomousRegistrationBloc, AutonomousRegistrationState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (response) {
              CustomToast.showSuccess(context, 'Cadastro realizado com sucesso! Faça login para continuar.');
              // Navegar para tela de login (cadastro requer autenticação para acessar veículos)
              context.go('/login');
            },
            error: (message) {
              CustomToast.showError(context, message);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return Stack(
            children: [
              // Form scrollable
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome Completo
                      _buildLabel('Nome Completo'),
                      _buildTextField(
                        controller: _nameController,
                        hint: 'Ex: João da Silva',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Nome é obrigatório';
                          if (value.length < 3) return 'Nome deve ter pelo menos 3 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // CPF
                      _buildLabel('CPF'),
                      _buildTextField(
                        controller: _cpfController,
                        hint: '000.000.000-00',
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_cpfMaskFormatter],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'CPF é obrigatório';
                          if (!_isValidCPF(value)) return 'CPF inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Telefone
                      _buildLabel('Telefone'),
                      _buildTextField(
                        controller: _phoneController,
                        hint: '(00) 00000-0000',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [_phoneMaskFormatter],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Telefone é obrigatório';
                          final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (digits.length < 10) return 'Telefone inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Data de Nascimento
                      _buildLabel('Data de Nascimento'),
                      _buildTextField(
                        controller: _birthDateController,
                        hint: 'DD/MM/AAAA',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_birthDateMaskFormatter],
                        validator: _validateBirthDate,
                      ),
                      const SizedBox(height: 16),

                      // Email (opcional)
                      _buildLabel('E-mail (opcional)'),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'seu@email.com',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            // Regex que aceita + e outros caracteres válidos
                            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                              return 'E-mail inválido';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Senha
                      _buildLabel('Senha'),
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Mínimo 6 caracteres',
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Senha é obrigatória';
                          if (value.length < 6) return 'Senha deve ter pelo menos 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirmar Senha
                      _buildLabel('Confirmar Senha'),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hint: 'Repita a senha',
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Confirme a senha';
                          if (value != _passwordController.text) return 'As senhas não coincidem';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Termos de Uso
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(
                                value: _termsAccepted,
                                onChanged: (value) => setState(() => _termsAccepted = value ?? false),
                                activeColor: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF424242),
                                      height: 1.4,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Li e aceito os '),
                                      TextSpan(
                                        text: 'Termos de Uso',
                                        style: TextStyle(
                                          color: primaryColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: ' e a '),
                                      TextSpan(
                                        text: 'Política de Privacidade',
                                        style: TextStyle(
                                          color: primaryColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
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
              ),
              
              // Loading overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              
              // Bottom bar fixa
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onRegister,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'CADASTRAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'Já tenho conta',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF757575),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
