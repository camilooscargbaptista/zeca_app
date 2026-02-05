---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Contexto ARCHITECTURE.md"
---


# ZECA App - Arquitetura Flutter

## Visão Geral

O ZECA App é o aplicativo mobile para motoristas e frotistas, desenvolvido em Flutter seguindo Clean Architecture com BLoC Pattern.

---

## Stack Tecnológica

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| Flutter | 3.x | Framework UI |
| Dart | 3.x | Linguagem |
| flutter_bloc | 8.x | State Management |
| get_it | 7.x | Dependency Injection |
| injectable | 2.x | Code Generation para DI |
| dio | 5.x | HTTP Client |
| freezed | 2.x | Imutabilidade e Union Types |
| dartz | 0.10.x | Functional Programming (Either) |
| shared_preferences | 2.x | Local Storage |
| flutter_secure_storage | 9.x | Secure Storage |

---

## Estrutura de Pastas

```
lib/
├── main.dart                      # Entry point
├── injection.dart                 # Configuração DI (get_it)
│
├── core/                          # Código compartilhado
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── route_constants.dart
│   │
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   │
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── api_interceptor.dart
│   │   └── network_info.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   │
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── extensions.dart
│   │
│   └── widgets/                   # Widgets reutilizáveis
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       ├── empty_widget.dart
│       └── ...
│
├── features/                      # Features (Clean Architecture)
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login.dart
│   │   │       ├── logout.dart
│   │   │       └── get_current_user.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── splash_page.dart
│   │       └── widgets/
│   │           └── login_form.dart
│   │
│   ├── refueling/                 # Feature de Abastecimento
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── vehicles/                  # Feature de Veículos
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── stations/                  # Feature de Postos
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── history/                   # Feature de Histórico
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── routes/                        # Navegação
    ├── app_router.dart
    └── route_guards.dart

test/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── ...
├── mocks/
│   └── mock_repositories.dart
└── fixtures/
    └── test_fixtures.dart
```

---

## Clean Architecture

### Camadas

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │    Pages    │  │   Widgets   │  │    BLoC     │          │
│  └─────────────┘  └─────────────┘  └──────┬──────┘          │
└───────────────────────────────────────────┼─────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │  Entities   │  │  UseCases   │  │ Repositories│          │
│  │             │  │             │  │ (abstract)  │          │
│  └─────────────┘  └─────────────┘  └──────┬──────┘          │
└───────────────────────────────────────────┼─────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   Models    │  │ DataSources │  │ Repositories│          │
│  │             │  │             │  │   (impl)    │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

### Fluxo de Dados

```
UI Event
    │
    ▼
BLoC.add(Event)
    │
    ▼
UseCase.call()
    │
    ▼
Repository.method()
    │
    ▼
DataSource.fetch()
    │
    ▼
API Response / Local Data
    │
    ▼
Model.fromJson()
    │
    ▼
Entity (via toEntity())
    │
    ▼
Either<Failure, Entity>
    │
    ▼
BLoC.emit(State)
    │
    ▼
UI Update
```

---

## Padrões de Código

### Entity (Domain Layer)

```dart
// lib/features/refueling/domain/entities/refueling.dart
class Refueling {
  final String id;
  final String code;
  final double totalValue;
  final double quantityLiters;
  final RefuelingStatus status;
  
  const Refueling({
    required this.id,
    required this.code,
    required this.totalValue,
    required this.quantityLiters,
    required this.status,
  });
}

enum RefuelingStatus { pending, confirmed, completed, cancelled }
```

### Model (Data Layer)

```dart
// lib/features/refueling/data/models/refueling_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'refueling_model.freezed.dart';
part 'refueling_model.g.dart';

@freezed
class RefuelingModel with _$RefuelingModel {
  const RefuelingModel._();
  
  const factory RefuelingModel({
    required String id,
    required String code,
    @JsonKey(name: 'total_value') required double totalValue,
    @JsonKey(name: 'quantity_liters') required double quantityLiters,
    required String status,
  }) = _RefuelingModel;

  factory RefuelingModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingModelFromJson(json);

  Refueling toEntity() => Refueling(
    id: id,
    code: code,
    totalValue: totalValue,
    quantityLiters: quantityLiters,
    status: RefuelingStatus.values.byName(status.toLowerCase()),
  );
}
```

### Repository Interface (Domain Layer)

```dart
// lib/features/refueling/domain/repositories/refueling_repository.dart
abstract class RefuelingRepository {
  Future<Either<Failure, Refueling>> getRefueling(String id);
  Future<Either<Failure, List<Refueling>>> getRefuelings();
  Future<Either<Failure, Refueling>> createRefueling(CreateRefuelingParams params);
}
```

### Repository Implementation (Data Layer)

```dart
// lib/features/refueling/data/repositories/refueling_repository_impl.dart
@LazySingleton(as: RefuelingRepository)
class RefuelingRepositoryImpl implements RefuelingRepository {
  final RefuelingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RefuelingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Refueling>> getRefueling(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('Sem conexão'));
    }
    try {
      final model = await remoteDataSource.getRefueling(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

### UseCase (Domain Layer)

```dart
// lib/features/refueling/domain/usecases/get_refueling.dart
@lazySingleton
class GetRefueling {
  final RefuelingRepository repository;

  GetRefueling(this.repository);

  Future<Either<Failure, Refueling>> call(String id) {
    return repository.getRefueling(id);
  }
}
```

### BLoC (Presentation Layer)

```dart
// lib/features/refueling/presentation/bloc/refueling_bloc.dart
@injectable
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final GetRefueling _getRefueling;

  RefuelingBloc(this._getRefueling) : super(RefuelingInitial()) {
    on<LoadRefueling>(_onLoadRefueling);
  }

  Future<void> _onLoadRefueling(
    LoadRefueling event,
    Emitter<RefuelingState> emit,
  ) async {
    emit(RefuelingLoading());
    
    final result = await _getRefueling(event.id);
    
    result.fold(
      (failure) => emit(RefuelingError(failure.message)),
      (refueling) => emit(RefuelingLoaded(refueling)),
    );
  }
}
```

### Page (Presentation Layer)

```dart
// lib/features/refueling/presentation/pages/refueling_page.dart
class RefuelingPage extends StatelessWidget {
  final String id;
  
  const RefuelingPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RefuelingBloc>()..add(LoadRefueling(id)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Abastecimento')),
        body: BlocBuilder<RefuelingBloc, RefuelingState>(
          builder: (context, state) {
            if (state is RefuelingLoading) {
              return const LoadingWidget();
            }
            if (state is RefuelingError) {
              return ErrorWidget(
                message: state.message,
                onRetry: () => context.read<RefuelingBloc>().add(LoadRefueling(id)),
              );
            }
            if (state is RefuelingLoaded) {
              return RefuelingContent(refueling: state.refueling);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

---

## Dependency Injection

```dart
// lib/injection.dart
final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

// Uso
final bloc = getIt<RefuelingBloc>();
```

---

## Comandos Úteis

```bash
# Rodar app
flutter run

# Build
flutter build apk
flutter build ios

# Testes
flutter test
flutter test --coverage

# Gerar código (Freezed, Injectable, etc)
dart run build_runner build --delete-conflicting-outputs

# Watch mode para geração
dart run build_runner watch --delete-conflicting-outputs

# Análise
flutter analyze

# Formatação
dart format lib/

# Limpar
flutter clean
flutter pub get
```

---

## Variáveis de Ambiente

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );
}

// Uso no build:
// flutter run --dart-define=API_URL=https://api.zeca.com.br/api/v1
```
