import 'package:equatable/equatable.dart';

/// Estados do BLoC de alterar senha
abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ChangePasswordInitial extends ChangePasswordState {}

/// Estado de validação em tempo real
class ChangePasswordValidated extends ChangePasswordState {
  final bool isValid;
  final bool passwordsMatch;
  final String? passwordError;

  const ChangePasswordValidated({
    required this.isValid,
    required this.passwordsMatch,
    this.passwordError,
  });

  @override
  List<Object?> get props => [isValid, passwordsMatch, passwordError];
}

/// Estado de loading durante envio
class ChangePasswordLoading extends ChangePasswordState {}

/// Estado de sucesso
class ChangePasswordSuccess extends ChangePasswordState {
  final String message;

  const ChangePasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado de erro
class ChangePasswordError extends ChangePasswordState {
  final String message;

  const ChangePasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado de logout concluído
class ChangePasswordLoggedOut extends ChangePasswordState {}
