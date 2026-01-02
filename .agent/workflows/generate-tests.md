---
description: Gerar testes unitários, de BLoC e widget tests para Flutter
---

# /generate-tests - Geração de Testes Flutter

## Pré-requisitos

Informar:
- Qual arquivo/módulo testar?
- Tipo: BLoC test, Unit test, Widget test, ou todos?

---

## Steps

### 1. Identificar Arquivo Alvo

```bash
# Localizar arquivo
find lib -name "*[nome]*" -type f | grep "\.dart$"

# Ler conteúdo do arquivo
cat [caminho/do/arquivo]
```

### 2. Analisar Código

Identificar:
- Tipo de arquivo (BLoC, Repository, UseCase, Widget, Model)
- Métodos públicos (devem ser testados)
- Dependências (precisam de mock)
- Estados possíveis (para BLoC)
- Interações (para Widget)

### 3. Verificar Testes Existentes

```bash
# Verificar se já existe arquivo de teste
ls -la test/features/[modulo]/ 2>/dev/null

# Se existir, ler conteúdo
cat test/features/[modulo]/[nome]_test.dart 2>/dev/null
```

---

## Teste de BLoC (bloc_test)

### Estrutura do Arquivo

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:zeca_app/features/[feature]/domain/usecases/[usecase].dart';
import 'package:zeca_app/features/[feature]/presentation/bloc/[nome]_bloc.dart';

import '[nome]_bloc_test.mocks.dart';

@GenerateMocks([GetSomethingUseCase])
void main() {
  late SomethingBloc bloc;
  late MockGetSomethingUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetSomethingUseCase();
    bloc = SomethingBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  // Fixture
  final tSomething = Something(id: '1', name: 'Test');

  group('SomethingBloc', () {
    test('initial state should be SomethingInitial', () {
      expect(bloc.state, equals(SomethingInitial()));
    });

    blocTest<SomethingBloc, SomethingState>(
      'should emit [Loading, Loaded] when data is fetched successfully',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => Right(tSomething),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadSomething('1')),
      expect: () => [
        SomethingLoading(),
        SomethingLoaded(tSomething),
      ],
      verify: (_) {
        verify(mockUseCase('1')).called(1);
      },
    );

    blocTest<SomethingBloc, SomethingState>(
      'should emit [Loading, Error] when fetching fails',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadSomething('1')),
      expect: () => [
        SomethingLoading(),
        SomethingError('Server error'),
      ],
    );

    blocTest<SomethingBloc, SomethingState>(
      'should emit [Loading, Empty] when no data found',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => Right(null),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadSomething('1')),
      expect: () => [
        SomethingLoading(),
        SomethingEmpty(),
      ],
    );
  });
}
```

### Rodar Mocks

```bash
# Gerar mocks do Mockito
dart run build_runner build --delete-conflicting-outputs

# Rodar testes do BLoC
flutter test test/features/[feature]/presentation/bloc/[nome]_bloc_test.dart
```

---

## Teste de UseCase

### Estrutura do Arquivo

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:zeca_app/features/[feature]/domain/repositories/[nome]_repository.dart';
import 'package:zeca_app/features/[feature]/domain/usecases/get_[nome].dart';

import 'get_[nome]_test.mocks.dart';

@GenerateMocks([SomethingRepository])
void main() {
  late GetSomething useCase;
  late MockSomethingRepository mockRepository;

  setUp(() {
    mockRepository = MockSomethingRepository();
    useCase = GetSomething(mockRepository);
  });

  final tSomething = Something(id: '1', name: 'Test');

  group('GetSomething', () {
    test('should get something from repository', () async {
      // Arrange
      when(mockRepository.getSomething(any))
          .thenAnswer((_) async => Right(tSomething));

      // Act
      final result = await useCase('1');

      // Assert
      expect(result, Right(tSomething));
      verify(mockRepository.getSomething('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(mockRepository.getSomething(any))
          .thenAnswer((_) async => Left(ServerFailure('Error')));

      // Act
      final result = await useCase('1');

      // Assert
      expect(result, Left(ServerFailure('Error')));
    });
  });
}
```

---

## Teste de Repository

### Estrutura do Arquivo

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:zeca_app/core/network/network_info.dart';
import 'package:zeca_app/features/[feature]/data/datasources/[nome]_remote_datasource.dart';
import 'package:zeca_app/features/[feature]/data/repositories/[nome]_repository_impl.dart';

import '[nome]_repository_impl_test.mocks.dart';

@GenerateMocks([SomethingRemoteDataSource, NetworkInfo])
void main() {
  late SomethingRepositoryImpl repository;
  late MockSomethingRemoteDataSource mockDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockDataSource = MockSomethingRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SomethingRepositoryImpl(
      remoteDataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tModel = SomethingModel(id: '1', name: 'Test');
  final tEntity = tModel.toEntity();

  group('getSomething', () {
    test('should check if device is online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDataSource.getSomething(any))
          .thenAnswer((_) async => tModel);

      // Act
      await repository.getSomething('1');

      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return data when call is successful', () async {
        // Arrange
        when(mockDataSource.getSomething(any))
            .thenAnswer((_) async => tModel);

        // Act
        final result = await repository.getSomething('1');

        // Assert
        expect(result, Right(tEntity));
      });

      test('should return ServerFailure when call fails', () async {
        // Arrange
        when(mockDataSource.getSomething(any))
            .thenThrow(ServerException('Error'));

        // Act
        final result = await repository.getSomething('1');

        // Assert
        expect(result, Left(ServerFailure('Error')));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NetworkFailure when offline', () async {
        // Act
        final result = await repository.getSomething('1');

        // Assert
        expect(result, Left(NetworkFailure('Sem conexão')));
      });
    });
  });
}
```

---

## Widget Test

### Estrutura do Arquivo

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zeca_app/features/[feature]/presentation/bloc/[nome]_bloc.dart';
import 'package:zeca_app/features/[feature]/presentation/pages/[nome]_page.dart';

class MockSomethingBloc extends MockBloc<SomethingEvent, SomethingState>
    implements SomethingBloc {}

void main() {
  late MockSomethingBloc mockBloc;

  setUp(() {
    mockBloc = MockSomethingBloc();
  });

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<SomethingBloc>.value(
        value: mockBloc,
        child: const SomethingPage(),
      ),
    );
  }

  group('SomethingPage', () {
    testWidgets('should show loading indicator when state is Loading',
        (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(SomethingLoading());

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when state is Error',
        (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(SomethingError('Erro ao carregar'));

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Erro ao carregar'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);
    });

    testWidgets('should show empty message when state is Empty',
        (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(SomethingEmpty());

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Nenhum item encontrado'), findsOneWidget);
    });

    testWidgets('should show data when state is Loaded', (tester) async {
      // Arrange
      final items = [Something(id: '1', name: 'Item 1')];
      when(() => mockBloc.state).thenReturn(SomethingLoaded(items));

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('should trigger LoadSomething when retry button is pressed',
        (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(SomethingError('Erro'));

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.text('Tentar novamente'));

      // Assert
      verify(() => mockBloc.add(LoadSomething())).called(1);
    });
  });
}
```

---

## Comandos de Teste

```bash
# Gerar mocks (Mockito)
dart run build_runner build --delete-conflicting-outputs

# Rodar todos os testes
flutter test

# Rodar testes de um módulo
flutter test test/features/[feature]/

# Rodar teste específico
flutter test test/features/[feature]/presentation/bloc/[nome]_bloc_test.dart

# Rodar com cobertura
flutter test --coverage

# Gerar relatório de cobertura
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Checklist de Qualidade

```
□ Teste para estado inicial
□ Teste para caso de sucesso
□ Teste para caso de erro
□ Teste para caso vazio (se aplicável)
□ Teste para interações do usuário (Widget test)
□ Mocks configurados corretamente
□ build_runner executado
□ Assertions verificam resultado esperado
□ Testes são independentes
□ Nomes descritivos (should [X] when [Y])
□ Cobertura ≥60%
```
