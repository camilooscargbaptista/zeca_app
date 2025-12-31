import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final StorageService storageService;
  
  AuthRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.storageService,
  );
  
  @override
  Future<Either<Failure, UserEntity>> login(String cpf) async {
    try {
      // Para OAuth, precisamos de senha também
      // Por enquanto, vamos usar um fluxo simplificado
      // Em produção, isso seria uma tela de login com senha
      final password = 'default_password'; // Isso deve vir da UI
      
      // Fazer login OAuth - agora retorna todos os dados do usuário
      final loginResponse = await remoteDataSource.loginWithOAuth(cpf, password);
      
      // Converter para UserModel diretamente da resposta de login
      // Não precisa mais chamar /oauth/userinfo!
      final userModel = UserModel.fromLoginResponse(loginResponse.user);
      
      // Salvar tokens
      await storageService.saveAccessToken(loginResponse.accessToken);
      await storageService.saveRefreshToken(loginResponse.refreshToken);
      
      // Cachear usuário
      await localDataSource.cacheUser(userModel);
      
      return Right(userModel.toEntity());
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro desconhecido: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Revogar token no servidor
      final accessToken = await storageService.getAccessToken();
      if (accessToken != null) {
        try {
          await remoteDataSource.revokeToken(accessToken);
        } catch (e) {
          // Ignorar erro de revogação, continuar com logout local
        }
      }
      
      // Limpar cache local
      await localDataSource.clearCache();
      await storageService.clearTokens();
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Erro ao fazer logout: $e'));
    }
  }
  
  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final oldRefreshToken = await storageService.getRefreshToken();
      if (oldRefreshToken == null) {
        return const Left(UnauthorizedFailure(message: 'Refresh token não encontrado'));
      }
      
      final tokenResponse = await remoteDataSource.refreshOAuthToken(oldRefreshToken);
      await storageService.saveAccessToken(tokenResponse.accessToken);
      await storageService.saveRefreshToken(tokenResponse.refreshToken);
      
      return Right(tokenResponse.accessToken);
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro ao atualizar token: $e'));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: 'Erro ao obter usuário: $e'));
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    final token = await storageService.getAccessToken();
    return token != null;
  }
}
