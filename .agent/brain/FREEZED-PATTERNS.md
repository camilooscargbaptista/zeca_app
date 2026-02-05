---
antigravity:
  trigger: "always_on"
  globs: ["**/*.freezed.dart", "**/models/**", "**/entities/**"]
  description: "Padrões Freezed para modelos imutáveis"
---


# 🧊 Freezed Patterns - ZECA App

> **"Imutabilidade é a chave para estados previsíveis."**

---

## 📚 O que é Freezed?

Freezed é um gerador de código que cria:
- Classes **imutáveis**
- **copyWith** automático
- **Union types** (sealed classes)
- **JSON serialization** (com json_serializable)
- **Equality** (==) e **hashCode** automáticos

---

## 🔧 Setup

### pubspec.yaml

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.8
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

### Comando para gerar

```bash
# Gerar código
dart run build_runner build --delete-conflicting-outputs

# Watch mode (desenvolvimento)
dart run build_runner watch --delete-conflicting-outputs
```

---

## 📋 Padrões por Tipo

### 1. Model (Data Layer)

```dart
// lib/features/refueling/data/models/refueling_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/refueling.dart';

part 'refueling_model.freezed.dart';
part 'refueling_model.g.dart';

@freezed
class RefuelingModel with _$RefuelingModel {
  const factory RefuelingModel({
    required String id,
    required double liters,
    @JsonKey(name: 'fuel_type') required String fuelType,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'station_id') required String stationId,
    @JsonKey(name: 'station_name') String? stationName,
    @Default('PENDING') String status,
  }) = _RefuelingModel;

  // Necessário para métodos extras
  const RefuelingModel._();

  factory RefuelingModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingModelFromJson(json);

  // Conversão para Entity
  Refueling toEntity() => Refueling(
        id: id,
        liters: liters,
        fuelType: FuelType.fromString(fuelType),
        totalPrice: totalPrice,
        createdAt: DateTime.parse(createdAt),
        stationId: stationId,
        stationName: stationName,
        status: RefuelingStatus.fromString(status),
      );

  // Conversão de Entity para Model
  factory RefuelingModel.fromEntity(Refueling entity) => RefuelingModel(
        id: entity.id,
        liters: entity.liters,
        fuelType: entity.fuelType.name,
        totalPrice: entity.totalPrice,
        createdAt: entity.createdAt.toIso8601String(),
        stationId: entity.stationId,
        stationName: entity.stationName,
        status: entity.status.name,
      );
}
```

### 2. Entity (Domain Layer)

```dart
// lib/features/refueling/domain/entities/refueling.dart

// Entity SEM Freezed - classe Dart pura
class Refueling {
  final String id;
  final double liters;
  final FuelType fuelType;
  final double totalPrice;
  final DateTime createdAt;
  final String stationId;
  final String? stationName;
  final RefuelingStatus status;

  const Refueling({
    required this.id,
    required this.liters,
    required this.fuelType,
    required this.totalPrice,
    required this.createdAt,
    required this.stationId,
    this.stationName,
    required this.status,
  });

  // Getters computados
  double get pricePerLiter => totalPrice / liters;
  bool get isCompleted => status == RefuelingStatus.completed;
}
```

> **Nota:** Entities podem usar Freezed se precisar de copyWith, mas para ZECA usamos classes Dart puras.

### 3. State (BLoC)

#### Padrão Union Type (Recomendado para estados simples)

```dart
// lib/features/refueling/presentation/bloc/refueling_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/refueling.dart';

part 'refueling_state.freezed.dart';

@freezed
class RefuelingState with _$RefuelingState {
  /// Estado inicial - antes de qualquer ação
  const factory RefuelingState.initial() = RefuelingInitial;

  /// Carregando dados
  const factory RefuelingState.loading() = RefuelingLoading;

  /// Dados carregados com sucesso
  const factory RefuelingState.loaded(List<Refueling> refuelings) = RefuelingLoaded;

  /// Lista vazia
  const factory RefuelingState.empty() = RefuelingEmpty;

  /// Erro
  const factory RefuelingState.error(String message) = RefuelingError;
}
```

**Uso na UI:**

```dart
BlocBuilder<RefuelingBloc, RefuelingState>(
  builder: (context, state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const LoadingWidget(),
      loaded: (refuelings) => RefuelingList(items: refuelings),
      empty: () => const EmptyStateWidget(message: 'Nenhum abastecimento'),
      error: (message) => ErrorWidget(
        message: message,
        onRetry: () => context.read<RefuelingBloc>().add(const LoadRequested()),
      ),
    );
  },
)
```

#### Padrão Single Class (Recomendado para estados complexos)

```dart
// lib/features/refueling/presentation/bloc/refueling_form_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/refueling.dart';

part 'refueling_form_state.freezed.dart';

@freezed
class RefuelingFormState with _$RefuelingFormState {
  const factory RefuelingFormState({
    // Dados do formulário
    @Default('') String vehicleId,
    @Default('') String stationId,
    @Default('') String fuelType,
    @Default(0.0) double liters,

    // Estados de UI
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,

    // Erros
    String? errorMessage,
    String? vehicleError,
    String? litersError,

    // Dados carregados
    @Default([]) List<Vehicle> vehicles,
    @Default([]) List<Station> stations,

    // Resultado
    Refueling? createdRefueling,
  }) = _RefuelingFormState;

  // Necessário para getters
  const RefuelingFormState._();

  // Getters computados
  bool get isValid =>
      vehicleId.isNotEmpty &&
      stationId.isNotEmpty &&
      fuelType.isNotEmpty &&
      liters > 0;

  bool get hasError => errorMessage != null;

  bool get canSubmit => isValid && !isSubmitting && !isLoading;
}
```

**Uso na UI:**

```dart
BlocBuilder<RefuelingFormBloc, RefuelingFormState>(
  builder: (context, state) {
    if (state.isLoading) {
      return const LoadingWidget();
    }

    return Form(
      child: Column(
        children: [
          VehicleDropdown(
            vehicles: state.vehicles,
            selectedId: state.vehicleId,
            error: state.vehicleError,
            onChanged: (id) => bloc.add(VehicleSelected(id)),
          ),
          LitersInput(
            value: state.liters,
            error: state.litersError,
            onChanged: (v) => bloc.add(LitersChanged(v)),
          ),
          SubmitButton(
            isLoading: state.isSubmitting,
            enabled: state.canSubmit,
            onPressed: () => bloc.add(const FormSubmitted()),
          ),
        ],
      ),
    );
  },
)
```

### 4. Event (BLoC)

```dart
// lib/features/refueling/presentation/bloc/refueling_event.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'refueling_event.freezed.dart';

@freezed
class RefuelingEvent with _$RefuelingEvent {
  // Carregar lista
  const factory RefuelingEvent.loadRequested() = LoadRequested;

  // Refresh (pull-to-refresh)
  const factory RefuelingEvent.refreshRequested() = RefreshRequested;

  // Criar novo
  const factory RefuelingEvent.createRequested(CreateRefuelingParams params) =
      CreateRequested;

  // Atualizar
  const factory RefuelingEvent.updateRequested(
    String id,
    UpdateRefuelingParams params,
  ) = UpdateRequested;

  // Deletar
  const factory RefuelingEvent.deleteRequested(String id) = DeleteRequested;

  // Buscar
  const factory RefuelingEvent.searchRequested(String query) = SearchRequested;

  // Selecionar item
  const factory RefuelingEvent.itemSelected(Refueling refueling) = ItemSelected;

  // Limpar seleção
  const factory RefuelingEvent.selectionCleared() = SelectionCleared;
}
```

### 5. Params (UseCase)

```dart
// lib/features/refueling/domain/usecases/create_refueling.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_refueling.freezed.dart';

@freezed
class CreateRefuelingParams with _$CreateRefuelingParams {
  const factory CreateRefuelingParams({
    required String vehicleId,
    required String stationId,
    required String fuelType,
    required double liters,
    String? odometerPhoto,
    int? odometer,
  }) = _CreateRefuelingParams;
}
```

### 6. Failure (Error handling)

```dart
// lib/core/error/failures.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  /// Erro de servidor (500, 502, etc)
  const factory Failure.server([String? message]) = ServerFailure;

  /// Erro de rede (sem conexão)
  const factory Failure.network([String? message]) = NetworkFailure;

  /// Erro de autenticação (401)
  const factory Failure.unauthorized([String? message]) = UnauthorizedFailure;

  /// Não encontrado (404)
  const factory Failure.notFound([String? message]) = NotFoundFailure;

  /// Erro de validação (400)
  const factory Failure.validation(Map<String, String> errors) = ValidationFailure;

  /// Erro de negócio
  const factory Failure.business(String message) = BusinessFailure;

  /// Erro desconhecido
  const factory Failure.unknown([String? message]) = UnknownFailure;
}

// Extension para mensagem amigável
extension FailureX on Failure {
  String get userMessage => when(
        server: (msg) => msg ?? 'Erro no servidor. Tente novamente.',
        network: (msg) => msg ?? 'Sem conexão. Verifique sua internet.',
        unauthorized: (msg) => msg ?? 'Sessão expirada. Faça login novamente.',
        notFound: (msg) => msg ?? 'Não encontrado.',
        validation: (errors) => errors.values.first,
        business: (msg) => msg,
        unknown: (msg) => msg ?? 'Erro inesperado. Tente novamente.',
      );
}
```

---

## ⚙️ Configurações Avançadas

### JsonKey Comum

```dart
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    // Nome diferente no JSON
    @JsonKey(name: 'user_name') required String userName,

    // Ignorar no JSON
    @JsonKey(includeFromJson: false, includeToJson: false) String? localOnly,

    // Valor padrão se null no JSON
    @JsonKey(defaultValue: 0) required int count,

    // Converter custom
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required DateTime date,

    // Enum como string
    @JsonKey(unknownEnumValue: Status.unknown) required Status status,
  }) = _MyModel;
}

DateTime _dateFromJson(String json) => DateTime.parse(json);
String _dateToJson(DateTime date) => date.toIso8601String();
```

### Default Values

```dart
@freezed
class MyState with _$MyState {
  const factory MyState({
    // Primitivos
    @Default('') String query,
    @Default(0) int page,
    @Default(false) bool isLoading,
    @Default(1.0) double opacity,

    // Listas (SEMPRE const [])
    @Default([]) List<Item> items,

    // Maps (SEMPRE const {})
    @Default({}) Map<String, dynamic> metadata,

    // Nullable (sem @Default)
    String? selectedId,
    Item? selectedItem,
  }) = _MyState;
}
```

### Union Types com Dados Compartilhados

```dart
@freezed
class AuthState with _$AuthState {
  // Todos os states podem ter isLoading
  const factory AuthState.initial({
    @Default(false) bool isLoading,
  }) = AuthInitial;

  const factory AuthState.authenticated({
    required User user,
    @Default(false) bool isLoading,
  }) = AuthAuthenticated;

  const factory AuthState.unauthenticated({
    String? errorMessage,
    @Default(false) bool isLoading,
  }) = AuthUnauthenticated;
}

// Acesso ao campo compartilhado
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    // Acessar campo comum
    final isLoading = state.maybeWhen(
      initial: (loading) => loading,
      authenticated: (_, loading) => loading,
      unauthenticated: (_, loading) => loading,
      orElse: () => false,
    );

    // ou usar map
    final isLoading = state.map(
      initial: (s) => s.isLoading,
      authenticated: (s) => s.isLoading,
      unauthenticated: (s) => s.isLoading,
    );
  },
)
```

---

## 🎯 Convenções ZECA App

### Nomenclatura de Arquivos

```
feature/
├── data/
│   └── models/
│       ├── refueling_model.dart
│       ├── refueling_model.freezed.dart  # Gerado
│       └── refueling_model.g.dart        # Gerado (JSON)
├── domain/
│   ├── entities/
│   │   └── refueling.dart  # Sem Freezed
│   └── usecases/
│       ├── create_refueling.dart
│       └── create_refueling.freezed.dart  # Gerado (Params)
└── presentation/
    └── bloc/
        ├── refueling_bloc.dart
        ├── refueling_event.dart
        ├── refueling_event.freezed.dart  # Gerado
        ├── refueling_state.dart
        └── refueling_state.freezed.dart  # Gerado
```

### Parts Obrigatórios

```dart
// Para Freezed (obrigatório)
part 'nome_arquivo.freezed.dart';

// Para JSON (se usar fromJson)
part 'nome_arquivo.g.dart';
```

### Ordem dos Imports

```dart
// 1. Dart
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

// 4. Projeto
import '../../../domain/entities/refueling.dart';

// 5. Parts (sempre por último)
part 'refueling_model.freezed.dart';
part 'refueling_model.g.dart';
```

---

## ⚠️ Erros Comuns

### 1. Esquecer de rodar build_runner

```bash
# Erro: The class '_$XxxState' doesn't have a constructor

# Solução:
dart run build_runner build --delete-conflicting-outputs
```

### 2. Esquecer o const na factory

```dart
// ❌ ERRADO
factory MyState.initial() = _Initial;

// ✅ CORRETO
const factory MyState.initial() = _Initial;
```

### 3. Esquecer o part

```dart
// ❌ ERRADO - Falta part
@freezed
class MyModel with _$MyModel { ... }

// ✅ CORRETO
part 'my_model.freezed.dart';  // Obrigatório!

@freezed
class MyModel with _$MyModel { ... }
```

### 4. Mixin errado

```dart
// ❌ ERRADO
class MyModel with _MyModel { ... }

// ✅ CORRETO
class MyModel with _$MyModel { ... }  // Note o $
```

### 5. Default com valor mutável

```dart
// ❌ ERRADO - Lista não-const
@Default([]) List<Item> items  // Pode causar bugs!

// ✅ CORRETO - Sempre const para coleções
@Default(<Item>[]) List<Item> items
// ou simplesmente
@Default([]) List<Item> items  // [] é inferido como const
```

---

## 📋 Checklist Freezed

```
Novo arquivo Freezed:
□ import 'package:freezed_annotation/freezed_annotation.dart';
□ part 'nome_arquivo.freezed.dart';
□ part 'nome_arquivo.g.dart'; (se usar JSON)
□ @freezed antes da classe
□ class Nome with _$Nome
□ const factory para cada variante
□ const Nome._(); (se tiver métodos/getters extras)
□ Rodar: dart run build_runner build --delete-conflicting-outputs
□ Verificar: arquivo .freezed.dart gerado
□ Verificar: arquivo .g.dart gerado (se JSON)
```

---

*Freezed Patterns v2.0.0 - Janeiro 2026*
