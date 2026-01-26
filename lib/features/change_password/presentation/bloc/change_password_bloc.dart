import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/usecases/change_password_usecase.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

/// BLoC para gerenciamento de alteração de senha do motorista
@injectable
class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;
  final AuthBloc _authBloc;

  ChangePasswordBloc(
    this._changePasswordUseCase,
    this._authBloc,
  ) : super(ChangePasswordInitial()) {
    on<ChangePasswordValidate>(_onValidate);
    on<ChangePasswordSubmit>(_onSubmit);
    on<ChangePasswordLogout>(_onLogout);
  }

  /// Valida senha em tempo real durante digitação
  void _onValidate(
    ChangePasswordValidate event,
    Emitter<ChangePasswordState> emit,
  ) {
    final password = event.password;
    final confirmPassword = event.confirmPassword;

    // Validar regras
    final validation = _validatePassword(password);
    final passwordsMatch = password == confirmPassword || confirmPassword.isEmpty;

    final isValid = validation.isValid &&
        passwordsMatch &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;

    emit(ChangePasswordValidated(
      isValid: isValid,
      passwordsMatch: passwordsMatch,
      passwordError: password.length == 6 ? validation.errorMessage : null,
    ));
  }

  /// Envia requisição para alterar senha
  Future<void> _onSubmit(
    ChangePasswordSubmit event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoading());

    final result = await _changePasswordUseCase.execute(
      newPassword: event.newPassword,
      confirmPassword: event.confirmPassword,
    );

    result.fold(
      (failure) => emit(ChangePasswordError(message: failure.message)),
      (message) => emit(ChangePasswordSuccess(message: message)),
    );
  }

  /// Faz logout após alteração bem sucedida
  void _onLogout(
    ChangePasswordLogout event,
    Emitter<ChangePasswordState> emit,
  ) {
    _authBloc.add(LogoutRequested());
    emit(ChangePasswordLoggedOut());
  }

  /// Valida regras de segurança da senha
  _ValidationResult _validatePassword(String password) {
    if (password.length != 6) {
      return _ValidationResult(false, 'A senha deve ter exatamente 6 dígitos');
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(password)) {
      return _ValidationResult(false, 'A senha deve conter apenas números');
    }

    // Verificar sequência crescente
    bool isAscending = true;
    for (int i = 0; i < password.length - 1; i++) {
      if (int.parse(password[i + 1]) != int.parse(password[i]) + 1) {
        isAscending = false;
        break;
      }
    }
    if (isAscending) {
      return _ValidationResult(false, 'Não pode ser sequência crescente');
    }

    // Verificar sequência decrescente
    bool isDescending = true;
    for (int i = 0; i < password.length - 1; i++) {
      if (int.parse(password[i + 1]) != int.parse(password[i]) - 1) {
        isDescending = false;
        break;
      }
    }
    if (isDescending) {
      return _ValidationResult(false, 'Não pode ser sequência decrescente');
    }

    // Verificar todos iguais
    if (password.split('').every((c) => c == password[0])) {
      return _ValidationResult(false, 'Não pode ter todos os dígitos iguais');
    }

    // Verificar mais de 3 consecutivos iguais
    for (int i = 0; i < password.length - 3; i++) {
      if (password[i] == password[i + 1] &&
          password[i] == password[i + 2] &&
          password[i] == password[i + 3]) {
        return _ValidationResult(false, 'Máximo 3 dígitos iguais consecutivos');
      }
    }

    return _ValidationResult(true, null);
  }
}

class _ValidationResult {
  final bool isValid;
  final String? errorMessage;

  _ValidationResult(this.isValid, this.errorMessage);
}
