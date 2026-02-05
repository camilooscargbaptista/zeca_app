---
antigravity:
  trigger: "always_on"
  globs: ["lib/**/*.dart"]
  description: "Regras de Clean Architecture - SEMPRE aplicar"
---


# 🏗️ CLEAN ARCHITECTURE - ZECA App

> **"Separação de responsabilidades é a chave."**

---

## 📊 VISÃO GERAL

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐                     │
│  │  Pages  │──│  BLoC   │──│ Widgets │                     │
│  └─────────┘  └────┬────┘  └─────────┘                     │
│                    │                                         │
├────────────────────┼────────────────────────────────────────┤
│                    ▼         DOMAIN                          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐                     │
│  │UseCases │──│Repository│──│Entities │                     │
│  └────┬────┘  │Interface │  └─────────┘                     │
│       │       └─────────┘                                    │
├───────┼─────────────────────────────────────────────────────┤
│       ▼              DATA                                    │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐                     │
│  │Repository│──│DataSource│──│ Models  │                    │
│  │  Impl   │  └─────────┘  │(Freezed)│                     │
│  └─────────┘               └─────────┘                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 📂 ESTRUTURA DE PASTAS

```
lib/features/nome/
│
├── data/                          # 📊 DATA LAYER
│   │                              # Implementação, API, Models
│   │
│   ├── datasources/
│   │   ├── nome_remote_datasource.dart    # Chamadas API (Retrofit)
│   │   └── nome_local_datasource.dart     # Cache local (Hive)
│   │
│   ├── models/
│   │   ├── nome_model.dart                # DTO com Freezed
│   │   ├── nome_model.freezed.dart        # Gerado
│   │   └── nome_model.g.dart              # Gerado
│   │
│   └── repositories/
│       └── nome_repository_impl.dart      # Implementa interface
│
├── domain/                        # 🎯 DOMAIN LAYER
│   │                              # Regras de negócio puras
│   │
│   ├── entities/
│   │   └── nome_entity.dart               # Entidade pura (Equatable)
│   │
│   ├── repositories/
│   │   └── nome_repository.dart           # Interface abstrata
│   │
│   └── usecases/
│       ├── get_nome_usecase.dart          # Caso de uso
│       └── create_nome_usecase.dart
│
└── presentation/                  # 🎨 PRESENTATION LAYER
    │                              # UI, BLoC, Widgets
    │
    ├── bloc/
    │   ├── nome_bloc.dart                 # Lógica de estado
    │   ├── nome_event.dart                # Eventos (Freezed)
    │   └── nome_state.dart                # Estados (Freezed)
    │
    ├── pages/
    │   └── nome_page.dart                 # Tela principal
    │
    └── widgets/
        └── nome_item_widget.dart          # Widgets específicos
```

---

## 🔄 FLUXO DE DADOS

```
USER ACTION
    │
    ▼
┌─────────┐    Event     ┌─────────┐
│  Page   │─────────────▶│  BLoC   │
└─────────┘              └────┬────┘
                              │
                              ▼
                        ┌─────────┐
                        │ UseCase │
                        └────┬────┘
                              │
                              ▼
                        ┌─────────┐
                        │Repository│ (Interface)
                        └────┬────┘
                              │
                              ▼
                        ┌─────────┐
                        │Repo Impl│
                        └────┬────┘
                              │
                              ▼
                        ┌─────────┐
                        │DataSource│
                        └────┬────┘
                              │
                              ▼
                           API/DB
                              │
                              ▼
                        ┌─────────┐
                        │  Model  │
                        └────┬────┘
                              │
              ┌───────────────┴───────────────┐
              │  toEntity()                   │
              ▼                               ▼
        ┌─────────┐                    ┌─────────┐
        │ Entity  │◀───────────────────│ UseCase │
        └────┬────┘    Either<F,E>     └─────────┘
              │
              ▼
        ┌─────────┐    State     ┌─────────┐
        │  BLoC   │─────────────▶│  Page   │
        └─────────┘              └─────────┘
```

---

## 📋 RESPONSABILIDADES

### DATA LAYER

| Componente | Responsabilidade |
|------------|------------------|
| **Model** | DTO para serialização JSON (Freezed) |
| **DataSource** | Chamadas de API/DB (Retrofit/Hive) |
| **Repository Impl** | Implementa interface, trata erros |

```dart
// Model → Converte de/para JSON
@freezed
class NomeModel {
  factory NomeModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  
  // Converte para Entity
  NomeEntity toEntity() => NomeEntity(...);
}

// DataSource → Chama API
@RestApi()
abstract class NomeRemoteDataSource {
  @GET('/nome')
  Future<List<NomeModel>> getAll();
}

// Repository Impl → Trata erros, converte
class NomeRepositoryImpl implements NomeRepository {
  Future<Either<Failure, List<NomeEntity>>> getAll() async {
    try {
      final models = await dataSource.getAll();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
```

### DOMAIN LAYER

| Componente | Responsabilidade |
|------------|------------------|
| **Entity** | Objeto de domínio puro |
| **Repository** | Interface abstrata |
| **UseCase** | Regra de negócio única |

```dart
// Entity → Objeto puro
class NomeEntity extends Equatable {
  final String id;
  final String name;
}

// Repository → Interface
abstract class NomeRepository {
  Future<Either<Failure, List<NomeEntity>>> getAll();
}

// UseCase → Uma ação
class GetNomeUseCase {
  Future<Either<Failure, List<NomeEntity>>> call() {
    return repository.getAll();
  }
}
```

### PRESENTATION LAYER

| Componente | Responsabilidade |
|------------|------------------|
| **BLoC** | Gerencia estado, chama UseCases |
| **Event** | Ações do usuário |
| **State** | Estados da tela |
| **Page** | UI principal |
| **Widget** | Componentes reutilizáveis |

```dart
// Event → Ações
@freezed
class NomeEvent {
  const factory NomeEvent.loadRequested() = _LoadRequested;
}

// State → Estados
@freezed
class NomeState {
  const factory NomeState.loading() = _Loading;
  const factory NomeState.loaded(List<NomeEntity> items) = _Loaded;
  const factory NomeState.error(String message) = _Error;
}

// BLoC → Processa eventos, emite estados
class NomeBloc extends Bloc<NomeEvent, NomeState> {
  on<_LoadRequested>((event, emit) async {
    emit(NomeState.loading());
    final result = await useCase();
    result.fold(
      (f) => emit(NomeState.error(f.message)),
      (items) => emit(NomeState.loaded(items)),
    );
  });
}
```

---

## ⚠️ REGRAS IMPORTANTES

### ❌ NUNCA

```dart
// ❌ Page chamando DataSource diretamente
class NomePage {
  final dataSource = NomeRemoteDataSource();
  
  void load() {
    dataSource.getAll(); // ERRADO!
  }
}

// ❌ UseCase conhecendo implementação
class GetNomeUseCase {
  final NomeRepositoryImpl repo; // ERRADO! Usar interface
}

// ❌ Domain importando Data
import '../data/models/nome_model.dart'; // ERRADO em domain/
```

### ✅ SEMPRE

```dart
// ✅ Page usa BLoC
class NomePage {
  Widget build(context) {
    return BlocBuilder<NomeBloc, NomeState>(
      builder: (context, state) => ...
    );
  }
}

// ✅ UseCase usa interface
class GetNomeUseCase {
  final NomeRepository repo; // Interface do domain/
}

// ✅ Data implementa Domain
class NomeRepositoryImpl implements NomeRepository {
  // Implementação
}
```

---

## 🔍 DEPENDÊNCIAS ENTRE CAMADAS

```
PRESENTATION ──────▶ DOMAIN ◀────── DATA
     │                  │              │
     │                  │              │
     ▼                  ▼              ▼
  - Pages           - Entities     - Models
  - BLoC            - UseCases     - DataSources
  - Widgets         - Repository   - Repository
                      Interface      Impl
```

**Regra:** As setas indicam dependência. Domain não depende de ninguém.

---

## 📋 CHECKLIST

```
Nova Feature:
□ Domain primeiro (entity, repository interface, usecase)
□ Data depois (model, datasource, repository impl)
□ Presentation por último (bloc, page, widgets)
□ Registrar DI
□ Adicionar rota
□ Rodar build_runner
```

---

**DOMAIN É O CENTRO. TUDO DEPENDE DELE, ELE NÃO DEPENDE DE NADA.**
