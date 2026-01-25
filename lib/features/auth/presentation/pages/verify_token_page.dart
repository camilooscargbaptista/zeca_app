import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/common/custom_toast.dart';
import '../bloc/verify_token_bloc.dart';

/// Tela de verificação do token OTP de 6 dígitos
class VerifyTokenPage extends StatelessWidget {
  final String cpf;
  
  const VerifyTokenPage({super.key, required this.cpf});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyTokenBloc(),
      child: _VerifyTokenView(cpf: cpf),
    );
  }
}

class _VerifyTokenView extends StatefulWidget {
  final String cpf;
  
  const _VerifyTokenView({required this.cpf});

  @override
  State<_VerifyTokenView> createState() => _VerifyTokenViewState();
}

class _VerifyTokenViewState extends State<_VerifyTokenView> {
  final List<TextEditingController> _controllers = List.generate(
    6, 
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _token => _controllers.map((c) => c.text).join();
  bool get _isComplete => _token.length == 6;

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    if (_isComplete) {
      _onSubmit();
    }
    
    setState(() {});
  }

  void _onKeyPressed(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent && 
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onSubmit() {
    if (_isComplete) {
      context.read<VerifyTokenBloc>().add(VerifyTokenSubmitted(
        cpf: widget.cpf,
        token: _token,
      ));
    }
  }

  void _onResend() {
    context.read<VerifyTokenBloc>().add(VerifyTokenResendRequested(widget.cpf));
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _clearFields() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryBlue),
          onPressed: () => context.go('/login'),
        ),
        title: const Text(
          'Verificar Código',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<VerifyTokenBloc, VerifyTokenState>(
        listener: (context, state) {
          if (state is VerifyTokenSuccess) {
            context.push('/forgot-password/reset', extra: {
              'cpf': state.cpf,
              'token': state.token,
            });
          } else if (state is VerifyTokenError) {
            CustomToast.showError(context, state.message);
            _clearFields();
          }
        },
        builder: (context, state) {
          final isLoading = state is VerifyTokenLoading;
          final hasError = state is VerifyTokenError;
          final canResend = state.remainingSeconds <= 0;
          
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descrição
                  Text(
                    'Digite o código de 6 dígitos enviado para seu email cadastrado.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Campos OTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        height: 56,
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (event) => _onKeyPressed(index, event),
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            enabled: !isLoading,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: hasError 
                                      ? Colors.red 
                                      : const Color(0xFFE0E0E0),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: hasError 
                                      ? Colors.red 
                                      : const Color(0xFFE0E0E0),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppColors.primaryBlue,
                                  width: 2,
                                ),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => _onDigitChanged(index, value),
                          ),
                        ),
                      );
                    }),
                  ),
                  
                  // Mensagem de erro
                  if (hasError) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        (state as VerifyTokenError).message,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Botão Verificar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isComplete && !isLoading ? _onSubmit : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'VERIFICAR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Timer e reenviar
                  Center(
                    child: Column(
                      children: [
                        if (!canResend) ...[
                          Text(
                            'Reenviar código em',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(state.remainingSeconds),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Não recebeu o código?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: canResend && !isLoading ? _onResend : null,
                          child: Text(
                            'Reenviar Código',
                            style: TextStyle(
                              color: canResend ? AppColors.primaryBlue : Colors.grey,
                              fontWeight: FontWeight.w500,
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
        },
      ),
    );
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
