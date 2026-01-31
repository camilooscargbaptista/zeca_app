---
antigravity:
  trigger: "always_on"
  globs: ["lib/**/*.dart", "**/injection.dart", "**/di/**"]
  description: "Padrões de Dependency Injection obrigatórios"
---


# 💉 Dependency Injection Patterns - ZECA App

> **"Inversão de dependência para código testável e manutenível."**

---

## 📚 Stack de DI

| Package | Função |
|---------|--------|
| **get_it** | Service Locator |
| **injectable** | Code generation para get_it |

---

## 🔧 Setup

### pubspec.yaml

```yaml
dependencies:
  get_it: ^7.6.7
  injectable: ^2.3.2

dev_dependencies:
  build_runner: ^2.4.8
  injectable_generator: ^2.4.1
```

### Estrutura de Arquivos

```
lib/
├── core/
│   └── di/
│       ├── injection.dart           # Configuração principal
│       └── injection.config.dart    # Gerado pelo injectable
└── features/
    └── refueling/
        ├── data/
        │   ├── datasources/
        │   │   └── refueling_remote_datasource.dart  # @LazySingleton
        │   └── repositories/
        │       └── refueling_repository_impl.dart    # @LazySingleton
        ├── domain/
        │   └── usecases/
        │       └── get_refuelings_usecase.dart       # @injectable
        └── presentation/
            └── bloc/
                └── refueling_bloc.dart               # @injectable
```

---

## 📋 Configuração Principal

### injection.dart

```dart
// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
```

### Inicialização no main.dart

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar DI
  await configureDependencies();

  runApp(const MyApp());
}
```

---

## 📊 Padrões por Camada

### Ordem de Registro (Importante!)

```
1. External     → Packages externos (Dio, SharedPreferences, Firebase)
2. DataSources  → Acesso a dados (API, Local)
3. Repositories → Implementações
4. UseCases     → Casos de uso
5. BLoCs        → Presentation layer
```

### 1. External (Módulo separado)

```dart
// lib/core/di/modules/external_module.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ExternalModule {
  // Dio como Singleton
  @lazySingleton
  Dio get dio => Dio(BaseOptions(
        baseUrl: 'https://api.zeca.com.br',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));

  // SharedPreferences (async)
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
```

### 2. DataSource

```dart
// lib/features/refueling/data/datasources/refueling_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'refueling_remote_datasource.g.dart';

abstract class RefuelingRemoteDataSource {
  Future<List<RefuelingModel>> getAll();
  Future<RefuelingModel> getById(String id);
  Future<RefuelingModel> create(CreateRefuelingRequest request);
}

@LazySingleton(as: RefuelingRemoteDataSource)
@RestApi()
abstract class RefuelingRemoteDataSourceImpl
    implements RefuelingRemoteDataSource {
  @factoryMethod
  factory RefuelingRemoteDataSourceImpl(Dio dio) =
      _RefuelingRemoteDataSourceImpl;

  @override
  @GET('/refuelings')
  Future<List<RefuelingModel>> getAll();

  @override
  @GET('/refuelings/{id}')
  Future<RefuelingModel> getById(@Path('id') String id);

  @override
  @POST('/refuelings')
  Future<RefuelingModel> create(@Body() CreateRefuelingRequest request);
}
```

### 3. Repository

```dart
// lib/features/refueling/data/repositories/refueling_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/refueling.dart';
import '../../domain/repositories/refueling_repository.dart';
import '../datasources/refueling_remote_datasource.dart';

@LazySingleton(as: RefuelingRepository)
class RefuelingRepositoryImpl implements RefuelingRepository {
  final RefuelingRemoteDataSource _remoteDataSource;

  RefuelingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Refueling>>> getAll() async {
    try {
      final models = await _remoteDataSource.getAll();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Refueling>> create(CreateRefuelingParams params) async {
    try {
      final request = CreateRefuelingRequest.fromParams(params);
      final model = await _remoteDataSource.create(request);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

### 4. UseCase

```dart
// lib/features/refueling/domain/usecases/get_refuelings_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/refueling.dart';
import '../repositories/refueling_repository.dart';

@injectable
class GetRefuelingsUseCase {
  final RefuelingRepository _repository;

  GetRefuelingsUseCase(this._repository);

  Future<Either<Failure, List<Refueling>>> call() async {
    return _repository.getAll();
  }
}

// Com parâmetros
@injectable
class CreateRefuelingUseCase {
  final RefuelingRepository _repository;
  final VehicleRepository _vehicleRepository;

  CreateRefuelingUseCase(this._repository, this._vehicleRepository);

  Future<Either<Failure, Refueling>> call(CreateRefuelingParams params) async {
    // Validação de negócio
    final vehicleResult = await _vehicleRepository.getById(params.vehicleId);

    return vehicleResult.fold(
      (failure) => Left(failure),
      (vehicle) async {
        // Validar combustível
        if (!vehicle.fuelTypes.contains(params.fuelType)) {
          return Left(BusinessFailure('Combustível incompatível'));
        }

        // Validar capacidade
        if (params.liters > vehicle.tankCapacity) {
          return Left(BusinessFailure('Excede capacidade do tanque'));
        }

        return _repository.create(params);
      },
    );
  }
}
```

### 5. BLoC

```dart
// lib/features/refueling/presentation/bloc/refueling_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_refuelings_usecase.dart';
import '../../domain/usecases/create_refueling_usecase.dart';

@injectable
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final GetRefuelingsUseCase _getRefuelingsUseCase;
  final CreateRefuelingUseCase _createRefuelingUseCase;

  RefuelingBloc(
    this._getRefuelingsUseCase,
    this._createRefuelingUseCase,
  ) : super(const RefuelingState.initial()) {
    on<LoadRequested>(_onLoadRequested);
    on<CreateRequested>(_onCreateRequested);
  }

  Future<void> _onLoadRequested(
    LoadRequested event,
    Emitter<RefuelingState> emit,
  ) async {
    emit(const RefuelingState.loading());

    final result = await _getRefuelingsUseCase();

    result.fold(
      (failure) => emit(RefuelingState.error(failure.userMessage)),
      (refuelings) => refuelings.isEmpty
          ? emit(const RefuelingState.empty())
          : emit(RefuelingState.loaded(refuelings)),
    );
  }

  Future<void> _onCreateRequested(
    CreateRequested event,
    Emitter<RefuelingState> emit,
  ) async {
    emit(const RefuelingState.loading());

    final result = await _createRefuelingUseCase(event.params);

    result.fold(
      (failure) => emit(RefuelingState.error(failure.userMessage)),
      (_) => add(const LoadRequested()), // Recarrega lista
    );
  }
}
```

---

## 📋 Annotations Reference

### Escopo de Vida

| Annotation | Comportamento | Uso |
|------------|---------------|-----|
| `@injectable` | Nova instância a cada inject | BLoC, UseCase |
| `@lazySingleton` | Uma instância (lazy) | Repository, DataSource |
| `@singleton` | Uma instância (eager) | Raramente usado |

### Interface/Implementação

```dart
// Interface no Domain
abstract class RefuelingRepository {
  Future<Either<Failure, List<Refueling>>> getAll();
}

// Implementação no Data
@LazySingleton(as: RefuelingRepository)  // Registra como interface
class RefuelingRepositoryImpl implements RefuelingRepository {
  // ...
}
```

### Factory Method (para classes geradas)

```dart
// Retrofit DataSource
@LazySingleton(as: RefuelingRemoteDataSource)
@RestApi()
abstract class RefuelingRemoteDataSourceImpl {
  @factoryMethod  // get_it usa este factory
  factory RefuelingRemoteDataSourceImpl(Dio dio) =
      _RefuelingRemoteDataSourceImpl;
}
```

### PreResolve (para async)

```dart
@module
abstract class ExternalModule {
  @preResolve  // Resolve antes de continuar
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
```

### Environments

```dart
// Apenas em dev
@dev
@LazySingleton(as: ApiClient)
class MockApiClient implements ApiClient {}

// Apenas em prod
@prod
@LazySingleton(as: ApiClient)
class RealApiClient implements ApiClient {}

// Inicialização com environment
await configureDependencies(environment: 'dev');
```

---

## 🎨 Uso na UI

### BlocProvider com getIt

```dart
// Tela simples
class RefuelingPage extends StatelessWidget {
  const RefuelingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RefuelingBloc>()..add(const LoadRequested()),
      child: const _RefuelingView(),
    );
  }
}
```

### MultiBlocProvider

```dart
class RefuelingFormPage extends StatelessWidget {
  const RefuelingFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<RefuelingFormBloc>()..add(const InitRequested()),
        ),
        BlocProvider(
          create: (_) => getIt<VehicleBloc>()..add(const LoadVehicles()),
        ),
      ],
      child: const _RefuelingFormView(),
    );
  }
}
```

### Acessar dependência diretamente

```dart
// Quando precisa de serviço fora de Widget
final authService = getIt<AuthService>();
final isLoggedIn = await authService.isLoggedIn();
```

---

## 🧪 Testing

### Setup de Testes

```dart
// test/helpers/test_injection.dart

import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockRefuelingRepository extends Mock implements RefuelingRepository {}
class MockGetRefuelingsUseCase extends Mock implements GetRefuelingsUseCase {}

void setupTestDependencies() {
  final getIt = GetIt.instance;

  // Limpar registros anteriores
  getIt.reset();

  // Registrar mocks
  getIt.registerLazySingleton<RefuelingRepository>(
    () => MockRefuelingRepository(),
  );
  getIt.registerFactory<GetRefuelingsUseCase>(
    () => MockGetRefuelingsUseCase(),
  );
}
```

### BLoC Test

```dart
// test/features/refueling/presentation/bloc/refueling_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRefuelingsUseCase extends Mock implements GetRefuelingsUseCase {}

void main() {
  late MockGetRefuelingsUseCase mockUseCase;
  late RefuelingBloc bloc;

  setUp(() {
    mockUseCase = MockGetRefuelingsUseCase();
    bloc = RefuelingBloc(mockUseCase, MockCreateRefuelingUseCase());
  });

  tearDown(() {
    bloc.close();
  });

  group('RefuelingBloc', () {
    final testRefuelings = [
      Refueling(id: '1', liters: 50, ...),
      Refueling(id: '2', liters: 30, ...),
    ];

    blocTest<RefuelingBloc, RefuelingState>(
      'emits [loading, loaded] when LoadRequested succeeds',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => Right(testRefuelings),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadRequested()),
      expect: () => [
        const RefuelingState.loading(),
        RefuelingState.loaded(testRefuelings),
      ],
    );

    blocTest<RefuelingBloc, RefuelingState>(
      'emits [loading, error] when LoadRequested fails',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadRequested()),
      expect: () => [
        const RefuelingState.loading(),
        const RefuelingState.error('Erro no servidor. Tente novamente.'),
      ],
    );

    blocTest<RefuelingBloc, RefuelingState>(
      'emits [loading, empty] when list is empty',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => const Right([]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadRequested()),
      expect: () => [
        const RefuelingState.loading(),
        const RefuelingState.empty(),
      ],
    );
  });
}
```

---

## ⚠️ Erros Comuns

### 1. Esquecer de rodar build_runner

```bash
# Erro: "Object/factory with type XxxBloc is not registered"

# Solução:
dart run build_runner build --delete-conflicting-outputs
```

### 2. Annotation errada para BLoC

```dart
// ❌ ERRADO - Singleton para BLoC
@lazySingleton
class RefuelingBloc extends Bloc<...> {}

// ✅ CORRETO - Nova instância
@injectable
class RefuelingBloc extends Bloc<...> {}
```

### 3. Interface não registrada

```dart
// ❌ ERRADO - Registra só implementação
@LazySingleton
class RefuelingRepositoryImpl implements RefuelingRepository {}

// ✅ CORRETO - Registra como interface
@LazySingleton(as: RefuelingRepository)
class RefuelingRepositoryImpl implements RefuelingRepository {}
```

### 4. Dependência circular

```dart
// ❌ ERRADO - A depende de B, B depende de A
// Causa: StackOverflow no getIt

// ✅ CORRETO - Refatorar para remover ciclo
// Ou usar @lazySingleton com cuidado
```

### 5. PreResolve faltando para async

```dart
// ❌ ERRADO - Async sem preResolve
@lazySingleton
SharedPreferences get prefs => SharedPreferences.getInstance(); // Erro!

// ✅ CORRETO
@preResolve
Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
```

---

## 📋 Checklist DI

```
Nova classe com DI:
□ Escolher annotation correta (@injectable ou @lazySingleton)
□ Se implementa interface: usar (as: Interface)
□ Se é gerada (Retrofit): usar @factoryMethod
□ Rodar: dart run build_runner build --delete-conflicting-outputs
□ Verificar: injection.config.dart atualizado
□ Criar mock para testes
□ Testar com bloc_test
```

---

## 📊 Tabela de Decisão

| Tipo | Annotation | Interface? | Escopo |
|------|------------|------------|--------|
| BLoC | `@injectable` | Não | Por tela |
| Cubit | `@injectable` | Não | Por tela |
| UseCase | `@injectable` | Não | Por uso |
| Repository | `@lazySingleton(as:)` | Sim | App |
| DataSource | `@lazySingleton(as:)` | Sim | App |
| Service | `@lazySingleton` | Depende | App |
| External (Dio) | Module + `@lazySingleton` | Não | App |

---

*DI Patterns v2.0.0 - Janeiro 2026*
