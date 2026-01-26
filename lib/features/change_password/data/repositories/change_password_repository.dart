import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/api_service.dart';

/// Repository para alteração de senha do motorista
@injectable
class ChangePasswordRepository {
  final ApiService _apiService;

  ChangePasswordRepository(this._apiService);

  /// Altera a senha do motorista autenticado
  Future<Either<Failure, String>> changePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '/drivers/me/change-password',
        data: {
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      if (response['success'] == true) {
        return Right(response['message'] ?? 'Senha alterada com sucesso');
      } else {
        return Left(
          ApiFailure(message: response['message'] ?? 'Erro ao alterar senha'),
        );
      }
    } catch (e) {
      final message = e.toString();
      if (message.contains('sequência crescente')) {
        return const Left(ApiFailure(message: 'A senha não pode ser uma sequência crescente (ex: 123456)'));
      }
      if (message.contains('sequência decrescente')) {
        return const Left(ApiFailure(message: 'A senha não pode ser uma sequência decrescente (ex: 654321)'));
      }
      if (message.contains('dígitos iguais')) {
        return const Left(ApiFailure(message: 'A senha não pode ter todos os dígitos iguais'));
      }
      if (message.contains('consecutivos')) {
        return const Left(ApiFailure(message: 'A senha não pode ter mais de 3 dígitos iguais consecutivos'));
      }
      if (message.contains('coincidem')) {
        return const Left(ApiFailure(message: 'As senhas não coincidem'));
      }
      return Left(ApiFailure(message: 'Erro ao alterar senha: $e'));
    }
  }
}
