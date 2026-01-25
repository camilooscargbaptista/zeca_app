/// Request model para redefinir senha via CPF
class ResetPasswordRequest {
  final String cpf;
  final String token;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordRequest({
    required this.cpf,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
        'cpf': cpf,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
}
