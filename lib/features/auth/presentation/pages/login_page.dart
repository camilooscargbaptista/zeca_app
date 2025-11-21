import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../../../shared/widgets/loading/loading_overlay.dart';
import '../../../../shared/widgets/common/custom_toast.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/cpf_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  bool _rememberCpf = false;
  
  @override
  void initState() {
    super.initState();
    _loadRememberedCpf();
  }
  
  void _loadRememberedCpf() {
    final storageService = getIt<StorageService>();
    final rememberedCpf = storageService.getRememberCpf();
    if (rememberedCpf != null) {
      _cpfController.text = Formatters.formatCPF(rememberedCpf);
      setState(() {
        _rememberCpf = true;
      });
    }
  }
  
  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }
  
  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final cpf = _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
      context.read<AuthBloc>().add(LoginRequested(cpf));
    }
  }
  
  void _onRememberCpfChanged(bool? value) {
    setState(() {
      _rememberCpf = value ?? false;
    });
    
    if (_rememberCpf) {
      final cpf = _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (cpf.length == 11) {
        final storageService = getIt<StorageService>();
        storageService.saveRememberCpf(cpf);
      }
    } else {
      final storageService = getIt<StorageService>();
      storageService.clearRememberCpf();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthError) {
            CustomToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state is AuthLoading,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: FlavorConfig.instance.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.local_gas_station,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // App Name
                        Text(
                          FlavorConfig.instance.appName,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: FlavorConfig.instance.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        
                        // Slogan
                        Text(
                          'A Rede preferida de quem transporta o Brasil!',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        
                        // CPF Field
                        CPFInputField(
                          controller: _cpfController,
                          validator: Validators.validateCPF,
                          onFieldSubmitted: (_) => _onLogin(),
                        ),
                        const SizedBox(height: 16),
                        
                        // Remember CPF
                        CheckboxListTile(
                          title: const Text('Lembrar CPF'),
                          value: _rememberCpf,
                          onChanged: _onRememberCpfChanged,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 24),
                        
                        // Login Button
                        CustomButton(
                          text: 'Entrar',
                          onPressed: _onLogin,
                          isFullWidth: true,
                        ),
                        const SizedBox(height: 16),
                        
                        // Version
                        Text(
                          'v1.0.0',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
