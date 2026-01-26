# 🤖 Cursor Rules - ZECA App Flutter

> **Regras para AI assistants trabalhando no projeto ZECA App.**

---

## 🎯 Você é

Um desenvolvedor Flutter sênior com experiência em:
- Clean Architecture
- BLoC Pattern (flutter_bloc)
- Freezed para imutabilidade
- get_it + injectable para DI
- Testes com bloc_test e mocktail

---

## 📋 Antes de QUALQUER tarefa

```bash
# 1. Ler PREFLIGHT obrigatório
cat .agent/guards/PREFLIGHT.md

# 2. Verificar erros passados
cat .context/LESSONS-LEARNED.md

# 3. Consultar regras de negócio
cat .context/BUSINESS-RULES.md

# 4. Verificar anti-patterns
cat .agent/guards/ERROR-PATTERNS.md
```

---

## 🏗️ Estrutura de Feature

```
lib/features/{feature}/
├── data/
│   ├── datasources/
│   │   └── {feature}_remote_datasource.dart
│   ├── models/
│   │   └── {feature}_model.dart
│   └── repositories/
│       └── {feature}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {feature}.dart
│   ├── repositories/
│   │   └── {feature}_repository.dart
│   └── usecases/
│       └── get_{feature}_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── {feature}_bloc.dart
    │   ├── {feature}_event.dart
    │   └── {feature}_state.dart
    ├── pages/
    │   └── {feature}_page.dart
    └── widgets/
        └── {feature}_card.dart
```

---

## 🧊 Freezed - SEMPRE Usar

### Model (Data Layer)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'refueling_model.freezed.dart';
part 'refueling_model.g.dart';

@freezed
class RefuelingModel with _$RefuelingModel {
  const factory RefuelingModel({
    required String id,
    @JsonKey(name: 'fuel_type') required String fuelType,
    @Default('') String description,
  }) = _RefuelingModel;

  const RefuelingModel._();

  factory RefuelingModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingModelFromJson(json);

  Refueling toEntity() => Refueling(id: id, fuelType: fuelType);
}
```

### State (Presentation Layer)

```dart
part 'refueling_state.freezed.dart';

@freezed
class RefuelingState with _$RefuelingState {
  const factory RefuelingState.initial() = _Initial;
  const factory RefuelingState.loading() = _Loading;
  const factory RefuelingState.loaded(List<Refueling> items) = _Loaded;
  const factory RefuelingState.empty() = _Empty;
  const factory RefuelingState.error(String message) = _Error;
}
```

### Event (Presentation Layer)

```dart
part 'refueling_event.freezed.dart';

@freezed
class RefuelingEvent with _$RefuelingEvent {
  const factory RefuelingEvent.loadRequested() = LoadRequested;
  const factory RefuelingEvent.refreshRequested() = RefreshRequested;
  const factory RefuelingEvent.createRequested(CreateParams params) = CreateRequested;
}
```

---

## 💉 Dependency Injection

### Annotations

```dart
// BLoC/UseCase = @injectable (nova instância)
@injectable
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {}

// Repository/DataSource = @lazySingleton
@LazySingleton(as: RefuelingRepository)
class RefuelingRepositoryImpl implements RefuelingRepository {}
```

### SEMPRE após criar injetável

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🔄 BLoC Pattern

```dart
@injectable
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final GetRefuelingsUseCase _getRefuelingsUseCase;

  RefuelingBloc(this._getRefuelingsUseCase)
      : super(const RefuelingState.initial()) {
    on<LoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    LoadRequested event,
    Emitter<RefuelingState> emit,
  ) async {
    emit(const RefuelingState.loading());

    final result = await _getRefuelingsUseCase();

    result.fold(
      (failure) => emit(RefuelingState.error(failure.userMessage)),
      (items) => items.isEmpty
          ? emit(const RefuelingState.empty())
          : emit(RefuelingState.loaded(items)),
    );
  }
}
```

---

## 🎨 Widget com BLoC

```dart
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

class _RefuelingView extends StatelessWidget {
  const _RefuelingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RefuelingBloc, RefuelingState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (items) => _ItemsList(items: items),
            empty: () => const _EmptyView(),
            error: (msg) => _ErrorView(message: msg),
          );
        },
      ),
    );
  }
}
```

---

## ❌ NUNCA Fazer

```dart
// ❌ setState em telas com API
setState(() => isLoading = true);

// ❌ Chamar API diretamente no Widget
final response = await Dio().get('/api/data');

// ❌ Estado mutável
class MyState { List<Item> items = []; }

// ❌ Domain importando Data
import '../../../data/models/my_model.dart';

// ❌ BLoC como singleton
@lazySingleton
class MyBloc extends Bloc<...> {}

// ❌ print para debug
print('debug: $data');
```

---

## ✅ SEMPRE Fazer

```dart
// ✅ BLoC para estado complexo
context.read<MyBloc>().add(LoadData());

// ✅ Estado imutável com Freezed
@freezed class MyState with _$MyState {}

// ✅ Either para erros
Future<Either<Failure, Data>> getData();

// ✅ const em widgets estáticos
const Padding(padding: EdgeInsets.all(16))

// ✅ log para debug
import 'dart:developer';
log('debug: $data', name: 'MyClass');

// ✅ buildWhen em widgets pesados
BlocBuilder(buildWhen: (p, c) => p.items != c.items)
```

---

## 🔧 Comandos Frequentes

```bash
# Gerar código
dart run build_runner build --delete-conflicting-outputs

# Análise
flutter analyze

# Testes
flutter test

# Cobertura
flutter test --coverage

# Formatar
dart format lib/
```

---

## 📚 Arquivos Importantes

| Precisa de... | Consulte... |
|---------------|-------------|
| Estrutura geral | `.agent/INDEX.md` |
| Quality gates | `.agent/guards/QUALITY-GATES.md` |
| Anti-patterns | `.agent/guards/ERROR-PATTERNS.md` |
| Preflight | `.agent/guards/PREFLIGHT.md` |
| Regras negócio | `.context/BUSINESS-RULES.md` |
| Erros passados | `.context/LESSONS-LEARNED.md` |
| Padrões BLoC | `.agent/brain/BLOC-PATTERNS.md` |
| Padrões Freezed | `.agent/brain/FREEZED-PATTERNS.md` |
| Padrões DI | `.agent/brain/DI-PATTERNS.md` |
| API endpoints | `.context/API-CONTRACTS.md` |

---

## 🚦 Checklist Rápido

```
□ Li PREFLIGHT antes de começar
□ Verifiquei LESSONS-LEARNED
□ Estrutura Clean Architecture
□ Estados com Freezed
□ BLoC com @injectable
□ Repository com Either
□ build_runner executado
□ Testes escritos
□ flutter analyze OK
```

---

*Cursor Rules v2.0.0 - Janeiro 2026*
