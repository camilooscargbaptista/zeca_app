import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/services/pending_validation_storage.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/token_manager_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/dialogs/success_dialog.dart';

class LoginPageSimple extends StatefulWidget {
  const LoginPageSimple({Key? key}) : super(key: key);

  @override
  State<LoginPageSimple> createState() => _LoginPageSimpleState();
}

class _LoginPageSimpleState extends State<LoginPageSimple> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  
  // Máscara para CPF
  final _cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    // Permissão de localização já é solicitada no splash_page.dart
    // Não chamar aqui para evitar race condition
    _loadRememberedCpf();
  }

  /// Carregar CPF salvo se existir
  Future<void> _loadRememberedCpf() async {
    try {
      final storageService = getIt<StorageService>();
      final rememberedCpf = storageService.getRememberCpf();
      
      if (rememberedCpf != null && rememberedCpf.isNotEmpty) {
        // Aplicar máscara ao CPF salvo usando o formatter
        final textEditingValue = _cpfMaskFormatter.formatEditUpdate(
          const TextEditingValue(),
          TextEditingValue(text: rememberedCpf),
        );
        setState(() {
          _cpfController.text = textEditingValue.text;
          _rememberMe = true; // Se tem CPF salvo, marcar checkbox
        });
        debugPrint('✅ CPF carregado: ${textEditingValue.text}');
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar CPF salvo: $e');
    }
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Solicitar permissão de localização ao abrir o app
  Future<void> _requestLocationPermission() async {
    try {
      // Verificar status atual da permissão
      final status = await Permission.location.status;
      
      // Só solicitar permissão se não foi dada ou foi negada
      if (status.isDenied) {
        print('📍 Solicitando permissão de localização...');
        await Permission.location.request();
        print('✅ Permissão de localização solicitada');
      } else if (status.isGranted) {
        print('✅ Permissão de localização já concedida');
      } else if (status.isPermanentlyDenied) {
        print('🚫 Permissão de localização bloqueada permanentemente');
      }
    } catch (e) {
      print('❌ Erro ao verificar/solicitar localização: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  
                  // Logo do ZECA (sem fundo preto)
                  Center(
                    child: Container(
                      height: 240,
                      width: 240,
                      child: Image.asset(
                        'assets/images/common/zeca_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Se a imagem não existir, mostrar o logo desenhado
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                'ZECA',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Título do App
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'A Rede preferida de quem transporta o Brasil',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                
                // Campo CPF
                TextFormField(
                  controller: _cpfController,
                  inputFormatters: [_cpfMaskFormatter],
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    hintText: '000.000.000-00',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu CPF';
                    }
                    if (value.length < 14) {
                      return 'CPF deve ter 11 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Campo Senha
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Lembrar-me
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Lembrar-me'),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Botão Login
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'ENTRAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                
                // Link Esqueci minha senha
                TextButton(
                  onPressed: () {
                    _showForgotPasswordDialog();
                  },
                  child: const Text('Esqueci minha senha'),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Mostrar modal de esqueci a senha
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Esqueci minha senha'),
            ],
          ),
          content: const Text(
            'Entre em contato com o gestor da frota, para atualizar sua senha.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Usar API real para login
      final apiService = ApiService();
      final response = await apiService.login(
        userType: 'DRIVER',
        cpf: _cpfController.text,
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['success'] == true) {
        // Login bem-sucedido
        if (mounted) {
          final userData = response['data'];
          
          // Salvar ou limpar CPF baseado no checkbox "Lembrar-me"
          try {
            final storageService = getIt<StorageService>();
            if (_rememberMe) {
              // Salvar CPF (sem máscara)
              final cpfSemMascara = _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
              await storageService.saveRememberCpf(cpfSemMascara);
              debugPrint('✅ CPF salvo para lembrar: $cpfSemMascara');
            } else {
              // Limpar CPF salvo
              await storageService.clearRememberCpf();
              debugPrint('✅ CPF removido (lembrar-me desmarcado)');
            }
          } catch (e) {
            debugPrint('⚠️ Erro ao salvar/limpar CPF: $e');
          }
          
          // Salvar dados do usuário no storage
          try {
            final storageService = getIt<StorageService>();
            if (userData['user'] != null) {
              await storageService.saveUserData(userData['user']);
              debugPrint('✅ Dados do usuário salvos no storage');
            }
          } catch (e) {
            debugPrint('⚠️ Erro ao salvar dados do usuário: $e');
          }
          
          // Inicializar/Reiniciar TokenManagerService após login bem-sucedido
          try {
            await TokenManagerService().initialize(forceReinit: true);
            debugPrint('✅ TokenManagerService reinicializado após login');
          } catch (e) {
            debugPrint('⚠️ Erro ao reinicializar TokenManagerService: $e');
          }
          
          // Verificar se há validação pendente para recuperar
          final pendingValidation = await PendingValidationStorage.getPendingValidation();
          
          if (pendingValidation != null) {
            // Há validação pendente - navegar para tela de aguardando
            debugPrint('✅ Validação pendente encontrada. Recuperando...');
            debugPrint('📦 RefuelingId: ${pendingValidation['refuelingId']}');
            debugPrint('📦 RefuelingCode: ${pendingValidation['refuelingCode']}');
            
            // Mostrar mensagem informativa
            if (mounted) {
              SuccessDialog.show(
                context,
                title: 'Validação Pendente',
                message: 'Você tem uma validação de abastecimento pendente. Redirecionando...',
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navegar para tela de aguardando com dados salvos
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      context.go('/refueling-waiting', extra: {
                        'refueling_id': pendingValidation['refuelingId'],
                        'refueling_code': pendingValidation['refuelingCode'],
                        'vehicle_data': pendingValidation['vehicleData'] as Map<String, dynamic>?,
                        'station_data': pendingValidation['stationData'] as Map<String, dynamic>?,
                      });
                    }
                  });
                },
              );
            }
          } else {
            // Sem validação pendente - navegar para tela de início de jornada
            SuccessDialog.show(
              context,
              title: 'Login Realizado',
              message: 'Bem-vindo, ${userData['user']?['name'] ?? 'Usuário'}!',
            );
            context.go('/journey-start');
          }
        }
      } else {
        // Erro de login
        if (mounted) {
          ErrorDialog.show(
            context,
            title: 'Erro de Login',
            message: response['error'] ?? 'CPF ou senha incorretos',
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro de Conexão',
          message: 'Erro de conexão: $e',
        );
      }
    }
  }
}
