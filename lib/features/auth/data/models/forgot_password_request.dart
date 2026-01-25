/// Request model para solicitar recuperação de senha via CPF
class ForgotPasswordRequest {
  final String cpf;

  const ForgotPasswordRequest({required this.cpf});

  Map<String, dynamic> toJson() => {'cpf': cpf};
}
