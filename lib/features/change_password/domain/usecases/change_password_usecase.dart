import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/change_password_repository.dart';

/// Use case para alterar senha do motorista
@injectable
class ChangePasswordUseCase {
  final ChangePasswordRepository _repository;

  ChangePasswordUseCase(this._repository);

  /// Executa a alteração de senha
  Future<Either<Failure, String>> execute({
    required String newPassword,
    required String confirmPassword,
  }) {
    return _repository.changePassword(
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
