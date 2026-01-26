import 'package:equatable/equatable.dart';

/// Eventos do BLoC de alterar senha
abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

/// Valida senha durante digitação
class ChangePasswordValidate extends ChangePasswordEvent {
  final String password;
  final String confirmPassword;

  const ChangePasswordValidate({
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [password, confirmPassword];
}

/// Envia requisição de alteração de senha
class ChangePasswordSubmit extends ChangePasswordEvent {
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordSubmit({
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [newPassword, confirmPassword];
}

/// Faz logout após sucesso
class ChangePasswordLogout extends ChangePasswordEvent {}
