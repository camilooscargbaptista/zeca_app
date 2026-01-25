import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/api_service.dart';

// Events
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
  
  @override
  List<Object?> get props => [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String cpf;
  final String token;
  final String password;
  final String passwordConfirmation;
  
  const ResetPasswordSubmitted({
    required this.cpf,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });
  
  @override
  List<Object?> get props => [cpf, token, password, passwordConfirmation];
}

class ResetPasswordValidate extends ResetPasswordEvent {
  final String password;
  final String passwordConfirmation;
  
  const ResetPasswordValidate({
    required this.password,
    required this.passwordConfirmation,
  });
  
  @override
  List<Object?> get props => [password, passwordConfirmation];
}

class ResetPasswordReset extends ResetPasswordEvent {}

// States
abstract class ResetPasswordState extends Equatable {
  final bool passwordsMatch;
  final bool isValid;
  
  const ResetPasswordState({
    this.passwordsMatch = true,
    this.isValid = false,
  });
  
  @override
  List<Object?> get props => [passwordsMatch, isValid];
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial({
    super.passwordsMatch,
    super.isValid,
  });
}

class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading({
    super.passwordsMatch,
    super.isValid,
  });
}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  
  const ResetPasswordSuccess({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  
  const ResetPasswordError(this.message, {
    super.passwordsMatch,
    super.isValid,
  });
  
  @override
  List<Object?> get props => [message, passwordsMatch, isValid];
}

// BLoC
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ApiService _apiService;
  
  ResetPasswordBloc({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onSubmitted);
    on<ResetPasswordValidate>(_onValidate);
    on<ResetPasswordReset>(_onReset);
  }
  
  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    // Validar senhas antes de enviar
    if (event.password != event.passwordConfirmation) {
      emit(const ResetPasswordError(
        'As senhas não coincidem',
        passwordsMatch: false,
        isValid: false,
      ));
      return;
    }
    
    if (event.password.length < 6) {
      emit(const ResetPasswordError(
        'A senha deve ter pelo menos 6 caracteres',
        passwordsMatch: true,
        isValid: false,
      ));
      return;
    }
    
    emit(const ResetPasswordLoading(passwordsMatch: true, isValid: true));
    
    final result = await _apiService.resetPasswordByCpf(
      cpf: event.cpf,
      token: event.token,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
    );
    
    if (result['success'] == true) {
      emit(ResetPasswordSuccess(
        message: result['message'] ?? 'Senha alterada com sucesso',
      ));
    } else {
      emit(ResetPasswordError(
        result['error'] ?? 'Erro ao redefinir senha',
        passwordsMatch: true,
        isValid: true,
      ));
    }
  }
  
  void _onValidate(
    ResetPasswordValidate event,
    Emitter<ResetPasswordState> emit,
  ) {
    final passwordsMatch = event.password == event.passwordConfirmation ||
        event.passwordConfirmation.isEmpty;
    final isValid = event.password.length >= 6 &&
        event.passwordConfirmation.length >= 6 &&
        event.password == event.passwordConfirmation;
    
    emit(ResetPasswordInitial(
      passwordsMatch: passwordsMatch,
      isValid: isValid,
    ));
  }
  
  void _onReset(
    ResetPasswordReset event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(const ResetPasswordInitial());
  }
}
