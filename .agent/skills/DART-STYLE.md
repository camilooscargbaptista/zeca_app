# 📝 Dart Style Guide - ZECA App

> **Effective Dart e convenções do projeto.**

---

## 🔤 Nomenclatura

### Classes e Tipos

```dart
// ✅ PascalCase
class RefuelingBloc {}
class GetRefuelingsUseCase {}
typedef JsonMap = Map<String, dynamic>;
enum FuelType { gasoline, ethanol, diesel }

// ❌ Evitar
class refuelingBloc {}
class get_refuelings_use_case {}
```

### Arquivos e Pastas

```dart
// ✅ snake_case
refueling_bloc.dart
get_refuelings_usecase.dart
refueling_model.dart

// ❌ Evitar
RefuelingBloc.dart
getRefuelingsUseCase.dart
```

### Variáveis e Funções

```dart
// ✅ camelCase
final refuelingData = await getRefuelings();
void loadData() {}
bool isLoading = false;

// ❌ Evitar
final RefuelingData = ...;
void LoadData() {}
bool IsLoading = false;
```

### Constantes

```dart
// ✅ camelCase (não SCREAMING_CAPS)
const maxRetries = 3;
const defaultTimeout = Duration(seconds: 30);

// ❌ Evitar
const MAX_RETRIES = 3;
const DEFAULT_TIMEOUT = Duration(seconds: 30);
```

### Privados

```dart
// ✅ Prefixo underscore
final _repository = RefuelingRepository();
void _handleError(Failure failure) {}

// ❌ Evitar
final repository = RefuelingRepository(); // Deveria ser privado
```

---

## 📦 Imports

### Ordem

```dart
// 1. Dart core
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Packages externos
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 4. Imports do projeto (relativos)
import '../../../core/error/failures.dart';
import '../../domain/entities/refueling.dart';

// 5. Parts (sempre por último)
part 'refueling_state.freezed.dart';
```

### Preferir relative imports

```dart
// ✅ Correto (dentro do mesmo package)
import '../domain/entities/refueling.dart';

// 🟡 Aceitável (para imports de outros packages)
import 'package:zeca_app/core/constants/app_constants.dart';
```

---

## 📐 Formatação

### Trailing Comma

```dart
// ✅ Com trailing comma (melhor diff no git)
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text('Hello'),
  );
}

// ❌ Sem trailing comma
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: const Text('Hello'));
}
```

### Quebra de Linha

```dart
// ✅ Quando passar de 80 caracteres
final result = await veryLongMethodName(
  parameter1,
  parameter2,
  parameter3,
);

// ✅ Named parameters em nova linha quando muitos
BlocBuilder<RefuelingBloc, RefuelingState>(
  buildWhen: (previous, current) => previous.items != current.items,
  builder: (context, state) {
    return Container();
  },
)
```

---

## 🎯 Boas Práticas

### const Sempre que Possível

```dart
// ✅ Correto
const EdgeInsets.all(16)
const Text('Static')
const SizedBox(height: 8)

// ❌ Evitar (recria objetos)
EdgeInsets.all(16)
Text('Static')
SizedBox(height: 8)
```

### Prefer final

```dart
// ✅ Correto
final name = 'João';
final items = <String>[];

// ❌ Evitar (se não vai reatribuir)
var name = 'João';
var items = <String>[];
```

### Type Annotations

```dart
// ✅ Explícito para campos e parâmetros
final String name;
void process(List<Refueling> items) {}

// ✅ Pode omitir em variáveis locais óbvias
final name = 'João';
final items = getItems();

// ❌ Evitar dynamic
dynamic data; // Quando possível, use Object ou tipo específico
```

### Avoid Nullable

```dart
// ✅ Preferir valores padrão
class User {
  final String name;
  final String email;
  final String phone; // Vazio ao invés de null

  User({
    required this.name,
    required this.email,
    this.phone = '',
  });
}

// 🟡 Nullable quando faz sentido
class User {
  final String name;
  final DateTime? deletedAt; // null = não deletado
}
```

---

## 📚 Documentação

### Quando Documentar

```dart
/// Processa um abastecimento e retorna o resultado.
///
/// [refuelingId] - ID do abastecimento a processar.
///
/// Returns [Right] com [Refueling] se sucesso.
/// Returns [Left] com [Failure] se erro.
///
/// Throws [ArgumentError] se [refuelingId] estiver vazio.
///
/// Example:
/// ```dart
/// final result = await useCase('ABC123');
/// result.fold(
///   (failure) => print(failure.message),
///   (refueling) => print(refueling.id),
/// );
/// ```
Future<Either<Failure, Refueling>> call(String refuelingId);
```

### Comentários

```dart
// ✅ Explicar o "porquê"
// Usamos polling como fallback porque webhooks podem falhar
final result = await _pollPaymentStatus(paymentId);

// ❌ Evitar explicar o "quê" (óbvio)
// Incrementa o contador
counter++;
```

### TODO

```dart
// TODO(camilo): Implementar cache local - issue #123
// FIXME: Memory leak quando navega rapidamente
// HACK: Workaround para bug do Flutter #12345
```

---

## 🔧 Padrões do Projeto

### Feature Folder

```
lib/features/refueling/
├── data/
│   ├── datasources/
│   │   └── refueling_remote_datasource.dart
│   ├── models/
│   │   └── refueling_model.dart
│   └── repositories/
│       └── refueling_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── refueling.dart
│   ├── repositories/
│   │   └── refueling_repository.dart
│   └── usecases/
│       └── get_refuelings_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── refueling_bloc.dart
    │   ├── refueling_event.dart
    │   └── refueling_state.dart
    ├── pages/
    │   └── refueling_page.dart
    └── widgets/
        └── refueling_card.dart
```

### Naming Conventions

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| BLoC | `{Feature}Bloc` | `RefuelingBloc` |
| Event | `{Feature}Event` | `RefuelingEvent` |
| State | `{Feature}State` | `RefuelingState` |
| UseCase | `{Action}{Feature}UseCase` | `GetRefuelingsUseCase` |
| Repository | `{Feature}Repository` | `RefuelingRepository` |
| Model | `{Feature}Model` | `RefuelingModel` |
| Page | `{Feature}Page` | `RefuelingPage` |
| Widget | `{Feature}{Purpose}` | `RefuelingCard` |

---

## 🚫 Anti-patterns

### Avoid Magic Numbers

```dart
// ❌ Evitar
if (retries > 3) { ... }
Future.delayed(Duration(seconds: 5));

// ✅ Correto
const maxRetries = 3;
const reconnectDelay = Duration(seconds: 5);

if (retries > maxRetries) { ... }
Future.delayed(reconnectDelay);
```

### Avoid String Concatenation

```dart
// ❌ Evitar
final message = 'Olá ' + name + '!';

// ✅ Correto
final message = 'Olá $name!';
final message = 'Olá ${user.name}!';
```

### Avoid Nested Ternary

```dart
// ❌ Evitar
final color = isError ? Colors.red : isWarning ? Colors.orange : Colors.green;

// ✅ Correto
Color getStatusColor() {
  if (isError) return Colors.red;
  if (isWarning) return Colors.orange;
  return Colors.green;
}
```

---

## 🔍 Análise

### analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_locals
    - avoid_print
    - avoid_empty_else
    - prefer_single_quotes
    - sort_constructors_first
    - unnecessary_brace_in_string_interps
```

### Comandos

```bash
# Análise completa
flutter analyze

# Formatação
dart format lib/

# Fix automático
dart fix --apply
```

---

*Dart Style Guide v2.0.0 - Janeiro 2026*
