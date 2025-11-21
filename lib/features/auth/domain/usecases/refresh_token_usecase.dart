import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class RefreshTokenUseCase {
  final AuthRepository repository;
  
  RefreshTokenUseCase(this.repository);
  
  Future<Either<Failure, String>> call() async {
    return await repository.refreshToken();
  }
}
