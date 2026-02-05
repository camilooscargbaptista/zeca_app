---
antigravity:
  trigger: "always_on"
  globs: ["test/**/*.dart", "**/*_test.dart"]
  description: "Guia de testes - padrões obrigatórios"
---


# 🧪 TESTING GUIDE - Flutter

> **"Código sem teste é código quebrado esperando acontecer."**

---

## 📊 REGRAS OBRIGATÓRIAS

```
╔══════════════════════════════════════════════════════════════════╗
║  COBERTURA MÍNIMA: 60%                                           ║
║  SEM TESTES = TAREFA INCOMPLETA                                  ║
║  PR SEM TESTES = PR REJEITADO                                    ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🏗️ ESTRUTURA DE TESTES

```
test/
├── features/
│   └── nome/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── nome_remote_datasource_test.dart
│       │   └── repositories/
│       │       └── nome_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── get_nome_usecase_test.dart
│       └── presentation/
│           ├── bloc/
│           │   └── nome_bloc_test.dart
│           └── pages/
│               └── nome_page_test.dart
```

---

## 📝 TEMPLATE DE TESTE - BLOC

```dart
// nome_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNomeUseCase extends Mock implements GetNomeUseCase {}

void main() {
  late NomeBloc bloc;
  late MockGetNomeUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetNomeUseCase();
    bloc = NomeBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('NomeBloc', () {
    final tItems = [
      NomeEntity(id: '1', name: 'Test 1'),
      NomeEntity(id: '2', name: 'Test 2'),
    ];

    blocTest<NomeBloc, NomeState>(
      'emits [loading, loaded] when loadRequested is successful',
      build: () {
        when(() => mockUseCase()).thenAnswer((_) async => Right(tItems));
        return bloc;
      },
      act: (bloc) => bloc.add(const NomeEvent.loadRequested()),
      expect: () => [
        const NomeState.loading(),
        NomeState.loaded(tItems),
      ],
    );

    blocTest<NomeBloc, NomeState>(
      'emits [loading, error] when loadRequested fails',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => Left(ServerFailure('Erro de servidor')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const NomeEvent.loadRequested()),
      expect: () => [
        const NomeState.loading(),
        const NomeState.error('Erro de servidor'),
      ],
    );
  });
}
```

---

## 📝 TEMPLATE DE TESTE - USECASE

```dart
// get_nome_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNomeRepository extends Mock implements NomeRepository {}

void main() {
  late GetNomeUseCase useCase;
  late MockNomeRepository mockRepository;

  setUp(() {
    mockRepository = MockNomeRepository();
    useCase = GetNomeUseCase(mockRepository);
  });

  group('GetNomeUseCase', () {
    final tItems = [NomeEntity(id: '1', name: 'Test')];

    test('should get items from repository', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenAnswer((_) async => Right(tItems));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(tItems));
      verify(() => mockRepository.getAll()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenAnswer((_) async => Left(ServerFailure('Error')));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Left>());
    });
  });
}
```

---

## 📝 TEMPLATE DE TESTE - REPOSITORY

```dart
// nome_repository_impl_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNomeRemoteDataSource extends Mock implements NomeRemoteDataSource {}

void main() {
  late NomeRepositoryImpl repository;
  late MockNomeRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockNomeRemoteDataSource();
    repository = NomeRepositoryImpl(mockDataSource);
  });

  group('NomeRepositoryImpl', () {
    final tModels = [NomeModel(id: '1', name: 'Test')];
    final tEntities = [NomeEntity(id: '1', name: 'Test')];

    test('should return entities when datasource succeeds', () async {
      // Arrange
      when(() => mockDataSource.getAll())
          .thenAnswer((_) async => tModels);

      // Act
      final result = await repository.getAll();

      // Assert
      expect(result, Right(tEntities));
    });

    test('should return ServerFailure when datasource throws DioException', () async {
      // Arrange
      when(() => mockDataSource.getAll())
          .thenThrow(DioException(requestOptions: RequestOptions()));

      // Act
      final result = await repository.getAll();

      // Assert
      expect(result, isA<Left>());
    });
  });
}
```

---

## 📝 TEMPLATE DE TESTE - WIDGET/PAGE

```dart
// nome_page_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNomeBloc extends MockBloc<NomeEvent, NomeState> implements NomeBloc {}

void main() {
  late MockNomeBloc mockBloc;

  setUp(() {
    mockBloc = MockNomeBloc();
  });

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<NomeBloc>.value(
        value: mockBloc,
        child: const NomePage(),
      ),
    );
  }

  group('NomePage', () {
    testWidgets('shows loading indicator when state is loading', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const NomeState.loading());

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list when state is loaded', (tester) async {
      // Arrange
      final items = [NomeEntity(id: '1', name: 'Test')];
      when(() => mockBloc.state).thenReturn(NomeState.loaded(items));

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('shows error message when state is error', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const NomeState.error('Erro'));

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Erro'), findsOneWidget);
    });
  });
}
```

---

## 🔧 COMANDOS

```bash
# Rodar todos os testes
flutter test

# Rodar com cobertura
flutter test --coverage

# Ver relatório de cobertura
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Rodar arquivo específico
flutter test test/features/nome/presentation/bloc/nome_bloc_test.dart

# Rodar com verbose
flutter test --reporter expanded
```

---

## 📦 DEPENDÊNCIAS DE TESTE

Adicionar no `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mocktail: ^1.0.1
```

---

## ✅ CHECKLIST DE TESTES

```
Para cada BLOC:
□ Teste estado inicial
□ Teste evento de load (sucesso)
□ Teste evento de load (falha)
□ Teste evento de create (se houver)
□ Teste evento de refresh (se houver)

Para cada USECASE:
□ Teste chama repository
□ Teste retorna sucesso
□ Teste retorna falha

Para cada REPOSITORY:
□ Teste converte model para entity
□ Teste trata DioException
□ Teste trata erro genérico

Para cada PAGE:
□ Teste estado loading
□ Teste estado loaded
□ Teste estado error
□ Teste estado empty

Cobertura:
□ flutter test --coverage >= 60%
```

---

**SEM TESTES = TAREFA INCOMPLETA. PONTO FINAL.**
