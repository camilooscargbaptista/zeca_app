import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeca_app/core/errors/failures.dart';
import 'package:zeca_app/features/auth/domain/entities/user_entity.dart';
import 'package:zeca_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../test_helpers/mock_dependencies.dart';
import '../../../../test_helpers/test_fixtures.dart';

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    group('LoginRequested', () {
      const tCpf = '12345678900';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when login succeeds',
        build: () {
          when(() => mockLoginUseCase(tCpf))
              .thenAnswer((_) async => const Right(tUserEntity));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginRequested(tCpf)),
        expect: () => [
          const AuthLoading(),
          const AuthAuthenticated(tUserEntity),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase(tCpf)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails with server error',
        build: () {
          when(() => mockLoginUseCase(any()))
              .thenAnswer((_) async => Left(ServerFailure(message: 'Erro no servidor')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginRequested(tCpf)),
        expect: () => [
          const AuthLoading(),
          const AuthError('Erro no servidor'),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase(tCpf)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails with network error',
        build: () {
          when(() => mockLoginUseCase(any()))
              .thenAnswer((_) async => Left(NetworkFailure(message: 'Sem conexão')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginRequested(tCpf)),
        expect: () => [
          const AuthLoading(),
          const AuthError('Sem conexão'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails with unauthorized error',
        build: () {
          when(() => mockLoginUseCase(any()))
              .thenAnswer((_) async => Left(UnauthorizedFailure(message: 'CPF inválido')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LoginRequested(tCpf)),
        expect: () => [
          const AuthLoading(),
          const AuthError('CPF inválido'),
        ],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when logout succeeds',
        build: () {
          when(() => mockLogoutUseCase())
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LogoutRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(() => mockLogoutUseCase()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when logout fails',
        build: () {
          when(() => mockLogoutUseCase())
              .thenAnswer((_) async => Left(ServerFailure(message: 'Erro ao deslogar')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LogoutRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthError('Erro ao deslogar'),
        ],
      );
    });

    group('CheckAuthStatus', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthUnauthenticated when user is not authenticated',
        build: () {
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => false);
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.isAuthenticated()).called(1);
          verifyNever(() => mockAuthRepository.getCurrentUser());
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthAuthenticated when user is authenticated and user data exists',
        build: () {
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => true);
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => const Right(tUserEntity));
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthAuthenticated(tUserEntity),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.isAuthenticated()).called(1);
          verify(() => mockAuthRepository.getCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthUnauthenticated when authenticated but user data is null',
        build: () {
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => true);
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthUnauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthUnauthenticated when getting user data fails',
        build: () {
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => true);
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => Left(ServerFailure(message: 'Erro')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthUnauthenticated(),
        ],
      );
    });
  });
}
