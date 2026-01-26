# ⚡ Cheatsheet - ZECA App

> **Referência rápida para comandos e padrões mais usados.**

---

## 🔧 Comandos Essenciais

### Build & Run

```bash
# Rodar em debug
flutter run

# Rodar em dispositivo específico
flutter run -d <device_id>

# Listar dispositivos
flutter devices

# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release

# Build iOS (no Mac)
flutter build ios --debug --no-codesign
flutter build ios --release
```

### Code Generation

```bash
# Gerar código (Freezed, Retrofit, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild)
dart run build_runner watch --delete-conflicting-outputs

# Limpar e regenerar
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Testes

```bash
# Rodar todos os testes
flutter test

# Rodar teste específico
flutter test test/features/refueling/

# Com cobertura
flutter test --coverage

# Gerar HTML de cobertura
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # Mac
```

### Análise & Formatação

```bash
# Análise estática
flutter analyze

# Formatar código
dart format lib/

# Verificar formatação (CI)
dart format --set-exit-if-changed lib/

# Ordenar imports
dart fix --apply
```

### Dependências

```bash
# Instalar dependências
flutter pub get

# Atualizar dependências
flutter pub upgrade

# Ver dependências desatualizadas
flutter pub outdated

# Limpar cache
flutter clean
flutter pub get
```

---

## 📁 Estrutura de Feature

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
│       ├── get_refuelings_usecase.dart
│       └── create_refueling_usecase.dart
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

---

## 🧊 Freezed Quick Reference

### Model (Data)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    @JsonKey(name: 'user_name') required String userName,
    @Default('') String description,
    String? optional,
  }) = _MyModel;

  const MyModel._();  // Para métodos extras

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

### State (BLoC) - Union Type

```dart
part 'my_state.freezed.dart';

@freezed
class MyState with _$MyState {
  const factory MyState.initial() = _Initial;
  const factory MyState.loading() = _Loading;
  const factory MyState.loaded(Data data) = _Loaded;
  const factory MyState.error(String message) = _Error;
}
```

### State (BLoC) - Single Class

```dart
@freezed
class MyFormState with _$MyFormState {
  const factory MyFormState({
    @Default('') String name,
    @Default(false) bool isLoading,
    String? error,
  }) = _MyFormState;

  const MyFormState._();

  bool get isValid => name.isNotEmpty;
}
```

### Event (BLoC)

```dart
part 'my_event.freezed.dart';

@freezed
class MyEvent with _$MyEvent {
  const factory MyEvent.loadRequested() = LoadRequested;
  const factory MyEvent.submitRequested(Params params) = SubmitRequested;
  const factory MyEvent.fieldChanged(String value) = FieldChanged;
}
```

---

## 💉 Dependency Injection

### Annotations

```dart
@injectable        // Nova instância (BLoC, UseCase)
@lazySingleton     // Uma instância (Repository, DataSource)
@lazySingleton(as: Interface)  // Registra como interface

@factoryMethod     // Para classes geradas (Retrofit)
@preResolve        // Para async (SharedPreferences)
```

### Exemplos

```dart
// DataSource
@LazySingleton(as: RefuelingRemoteDataSource)
@RestApi()
abstract class RefuelingRemoteDataSourceImpl { ... }

// Repository
@LazySingleton(as: RefuelingRepository)
class RefuelingRepositoryImpl implements RefuelingRepository { ... }

// UseCase
@injectable
class GetRefuelingsUseCase { ... }

// BLoC
@injectable
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> { ... }
```

### Uso

```dart
// No Widget
BlocProvider(
  create: (_) => getIt<RefuelingBloc>()..add(const LoadRequested()),
  child: const MyView(),
)

// Direto
final service = getIt<MyService>();
```

---

## 🔄 BLoC Patterns

### BLoC Básico

```dart
@injectable
class MyBloc extends Bloc<MyEvent, MyState> {
  final MyUseCase _useCase;

  MyBloc(this._useCase) : super(const MyState.initial()) {
    on<LoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    LoadRequested event,
    Emitter<MyState> emit,
  ) async {
    emit(const MyState.loading());
    final result = await _useCase();
    result.fold(
      (failure) => emit(MyState.error(failure.userMessage)),
      (data) => emit(MyState.loaded(data)),
    );
  }
}
```

### UI com BLoC

```dart
// Builder
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
      loaded: (data) => DataWidget(data: data),
      error: (msg) => ErrorWidget(message: msg),
    );
  },
)

// Listener (side effects)
BlocListener<MyBloc, MyState>(
  listener: (context, state) {
    state.whenOrNull(
      error: (msg) => ScaffoldMessenger.of(context).showSnackBar(...),
    );
  },
  child: ...,
)

// Consumer (ambos)
BlocConsumer<MyBloc, MyState>(
  listener: (context, state) { ... },
  builder: (context, state) { ... },
)

// Disparar evento
context.read<MyBloc>().add(const LoadRequested());
```

---

## 🧪 Testing

### BLoC Test

```dart
blocTest<MyBloc, MyState>(
  'description',
  build: () {
    when(() => mockUseCase()).thenAnswer((_) async => Right(data));
    return MyBloc(mockUseCase);
  },
  act: (bloc) => bloc.add(const LoadRequested()),
  expect: () => [
    const MyState.loading(),
    MyState.loaded(data),
  ],
);
```

### Widget Test

```dart
testWidgets('should show data', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: mockBloc,
        child: const MyWidget(),
      ),
    ),
  );

  await tester.pump();

  expect(find.text('Data'), findsOneWidget);
});
```

---

## 📊 Either (dartz)

```dart
// Tipo
Either<Failure, Success>

// Retornar sucesso
return Right(data);

// Retornar erro
return Left(ServerFailure('message'));

// Consumir
result.fold(
  (failure) => handleError(failure),
  (success) => handleSuccess(success),
);

// Mapear
result.map((data) => transform(data));

// Verificar
result.isRight()  // É sucesso?
result.isLeft()   // É erro?
```

---

## 🎨 Widget Patterns

### const Widget

```dart
// ✅ Sempre que possível
const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Static'),
)
```

### ListView.builder

```dart
// ✅ Para listas grandes
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(
    key: ValueKey(items[index].id),
    item: items[index],
  ),
)
```

### MediaQuery

```dart
final width = MediaQuery.of(context).size.width;
final height = MediaQuery.of(context).size.height;
final isTablet = width > 600;
```

### Theme

```dart
final primaryColor = Theme.of(context).primaryColor;
final textTheme = Theme.of(context).textTheme;
final colorScheme = Theme.of(context).colorScheme;
```

---

## 🚨 Regras de Negócio (RN-XXX)

### Consultar

```bash
cat .context/BUSINESS-RULES.md | grep "RN-"
```

### Prefixos

| Prefixo | Módulo |
|---------|--------|
| RN-JRN | Jornada |
| RN-ABT | Abastecimento |
| RN-PAG | Pagamento |
| RN-VEI | Veículo |
| RN-MOT | Motorista |
| RN-POS | Posto |

---

## 📋 Checklists Rápidos

### Nova Feature

```
□ Criar estrutura de pastas (data/domain/presentation)
□ Criar Entity (domain)
□ Criar Model com fromJson/toEntity (data)
□ Criar Repository interface (domain)
□ Criar Repository impl (data)
□ Criar UseCase (domain)
□ Criar BLoC + Event + State (presentation)
□ Registrar DI (@injectable/@lazySingleton)
□ Rodar build_runner
□ Criar Page + Widgets (presentation)
□ Criar testes (bloc_test)
```

### Pré-Commit

```
□ flutter analyze (0 erros)
□ flutter test (verde)
□ dart format lib/
□ build_runner executado
□ Branch atualizada com develop
```

### Pré-PR

```
□ Cobertura ≥ 60%
□ Build Android OK
□ Build iOS OK
□ Commits organizados
□ LESSONS-LEARNED atualizado (se necessário)
```

---

## 🔗 Links Úteis

| Recurso | Comando |
|---------|---------|
| INDEX | `cat .agent/INDEX.md` |
| Quality Gates | `cat .agent/guards/QUALITY-GATES.md` |
| Error Patterns | `cat .agent/guards/ERROR-PATTERNS.md` |
| PREFLIGHT | `cat .agent/guards/PREFLIGHT.md` |
| Lessons | `cat .context/LESSONS-LEARNED.md` |
| Business Rules | `cat .context/BUSINESS-RULES.md` |
| API Contracts | `cat .context/API-CONTRACTS.md` |

---

*Cheatsheet v2.0.0 - Janeiro 2026*
