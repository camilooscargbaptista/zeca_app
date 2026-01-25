/// Request model para verificar token de recuperação
class VerifyResetTokenRequest {
  final String cpf;
  final String token;

  const VerifyResetTokenRequest({
    required this.cpf,
    required this.token,
  });

  Map<String, dynamic> toJson() => {
        'cpf': cpf,
        'token': token,
      };
}
