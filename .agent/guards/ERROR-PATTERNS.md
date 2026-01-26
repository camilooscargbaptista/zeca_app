# ❌ Error Patterns - Anti-patterns Flutter

> **Catálogo de erros comuns. Consulte ANTES de implementar para não repetir.**

---

## 📊 Índice por Categoria

| Categoria | Códigos | Quantidade |
|-----------|---------|------------|
| 🔄 Estado (State) | EP-STA-XXX | 6 |
| 🏗️ Arquitetura | EP-ARC-XXX | 5 |
| 🎨 UI/Widgets | EP-WID-XXX | 6 |
| 💉 Injeção | EP-INJ-XXX | 3 |
| 🧪 Testes | EP-TST-XXX | 3 |
| ⚡ Performance | EP-PRF-XXX | 4 |
| 📱 Flutter Específico | EP-FLT-XXX | 4 |

---

## 🔄 ESTADO (State Management)

### EP-STA-001: setState em tela complexa
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - setState com múltiplos estados
class _RefuelingPageState extends State<RefuelingPage> {
  bool isLoading = false;
  String? error;
  Refueling? data;

  void loadData() async {
    setState(() => isLoading = true);
    try {
      final result = await api.getRefueling();
      setState(() {
        data = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
}

// ✅ CORRETO - Usar BLoC
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  RefuelingBloc(this._useCase) : super(const RefuelingState.initial()) {
    on<LoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(LoadRequested event, Emitter<RefuelingState> emit) async {
    emit(const RefuelingState.loading());
    final result = await _useCase();
    result.fold(
      (failure) => emit(RefuelingState.error(failure.message)),
      (data) => emit(RefuelingState.loaded(data)),
    );
  }
}
```

**Regra:** Se tem chamada de API = usar BLoC. Sem exceção.

---

### EP-STA-002: Estado mutável
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - Estado mutável
class RefuelingState {
  List<Refueling> items = [];  // Mutável!
  bool isLoading = false;

  void addItem(Refueling item) {
    items.add(item);  // Mutação direta!
  }
}

// ✅ CORRETO - Estado imutável com Freezed
@freezed
class RefuelingState with _$RefuelingState {
  const factory RefuelingState({
    @Default([]) List<Refueling> items,
    @Default(false) bool isLoading,
  }) = _RefuelingState;
}

// Para "modificar":
emit(state.copyWith(items: [...state.items, newItem]));
```

**Regra:** Estados SEMPRE imutáveis. Usar Freezed + copyWith.

---

### EP-STA-003: BlocBuilder sem buildWhen
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Rebuilda em qualquer mudança
BlocBuilder<RefuelingBloc, RefuelingState>(
  builder: (context, state) {
    return ExpensiveWidget(data: state.items);
  },
)

// ✅ CORRETO - Rebuilda apenas quando necessário
BlocBuilder<RefuelingBloc, RefuelingState>(
  buildWhen: (previous, current) => previous.items != current.items,
  builder: (context, state) {
    return ExpensiveWidget(data: state.items);
  },
)
```

**Regra:** Widgets pesados SEMPRE com buildWhen.

---

### EP-STA-004: Lógica de negócio no BLoC
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Lógica de negócio no BLoC
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final Dio _dio;  // API direta no BLoC!

  Future<void> _onSubmit(SubmitEvent event, Emitter emit) async {
    // Validação de negócio aqui - ERRADO!
    if (event.liters > vehicle.tankCapacity) {
      emit(RefuelingState.error('Excede capacidade'));
      return;
    }

    final response = await _dio.post('/refueling', data: {...});
  }
}

// ✅ CORRETO - UseCase com lógica de negócio
class CreateRefuelingUseCase {
  final RefuelingRepository _repository;
  final VehicleRepository _vehicleRepository;

  Future<Either<Failure, Refueling>> call(CreateRefuelingParams params) async {
    // Validação de negócio no UseCase
    final vehicle = await _vehicleRepository.getById(params.vehicleId);
    if (params.liters > vehicle.tankCapacity) {
      return Left(BusinessFailure('Excede capacidade do tanque'));
    }

    return _repository.create(params);
  }
}

// BLoC apenas orquestra
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final CreateRefuelingUseCase _createUseCase;

  Future<void> _onSubmit(SubmitEvent event, Emitter emit) async {
    emit(const RefuelingState.loading());
    final result = await _createUseCase(event.params);
    result.fold(
      (failure) => emit(RefuelingState.error(failure.message)),
      (data) => emit(RefuelingState.success(data)),
    );
  }
}
```

**Regra:** BLoC orquestra. UseCase valida. Repository acessa dados.

---

### EP-STA-005: Falta estados de UI
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Apenas loaded
@freezed
class JourneyState with _$JourneyState {
  const factory JourneyState.loaded(Journey data) = _Loaded;
}

// ✅ CORRETO - Todos os estados
@freezed
class JourneyState with _$JourneyState {
  const factory JourneyState.initial() = _Initial;
  const factory JourneyState.loading() = _Loading;
  const factory JourneyState.loaded(Journey data) = _Loaded;
  const factory JourneyState.empty() = _Empty;
  const factory JourneyState.error(String message) = _Error;
}

// Na UI:
state.when(
  initial: () => const SizedBox.shrink(),
  loading: () => const LoadingWidget(),
  loaded: (data) => JourneyContent(data: data),
  empty: () => const EmptyStateWidget(message: 'Nenhuma jornada'),
  error: (msg) => ErrorWidget(message: msg, onRetry: () => bloc.add(LoadRequested())),
);
```

**Regra:** SEMPRE ter: initial, loading, loaded, empty, error.

---

### EP-STA-006: StreamSubscription sem dispose
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - Subscription vazando
class _MyPageState extends State<MyPage> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((data) => doSomething(data));
    // Nunca cancela!
  }
}

// ✅ CORRETO - Dispose adequado
class _MyPageState extends State<MyPage> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((data) => doSomething(data));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

**Regra:** TODA subscription precisa de cancel no dispose.

---

## 🏗️ ARQUITETURA

### EP-ARC-001: Domain importando Data
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - Domain conhece Data
// lib/features/refueling/domain/usecases/get_refueling.dart
import '../../../data/models/refueling_model.dart';  // ERRADO!
import '../../../data/datasources/refueling_api.dart';  // ERRADO!

// ✅ CORRETO - Domain usa apenas interfaces
// lib/features/refueling/domain/usecases/get_refueling.dart
import '../repositories/refueling_repository.dart';  // Interface
import '../entities/refueling.dart';  // Entity pura
```

**Regra:** Domain NUNCA importa Data. Só interfaces e entities.

---

### EP-ARC-002: Widget chamando API diretamente
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - Widget chama API
class RefuelingPage extends StatelessWidget {
  final Dio dio = Dio();

  void onSubmit() async {
    final response = await dio.post('/refueling');  // ERRADO!
  }
}

// ✅ CORRETO - Widget usa BLoC
class RefuelingPage extends StatelessWidget {
  void onSubmit(BuildContext context) {
    context.read<RefuelingBloc>().add(const SubmitRequested());
  }
}
```

**Regra:** Widgets NUNCA chamam API. Sempre via BLoC → UseCase → Repository.

---

### EP-ARC-003: BLoC injetando Repository ao invés de UseCase
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - BLoC usa Repository diretamente
@injectable
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final RefuelingRepository _repository;  // ERRADO!

  Future<void> _onLoad(LoadEvent event, Emitter emit) async {
    final data = await _repository.getAll();  // Sem validação!
  }
}

// ✅ CORRETO - BLoC usa UseCase
@injectable
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {
  final GetRefuelingsUseCase _getRefuelingsUseCase;

  Future<void> _onLoad(LoadEvent event, Emitter emit) async {
    final result = await _getRefuelingsUseCase();
    // UseCase faz validações de negócio
  }
}
```

**Regra:** BLoC injeta UseCase. UseCase injeta Repository.

---

### EP-ARC-004: Model sem toEntity/fromEntity
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Model usado em toda aplicação
// Data, Domain e Presentation usam RefuelingModel

// ✅ CORRETO - Separação clara
// data/models/refueling_model.dart
@freezed
class RefuelingModel with _$RefuelingModel {
  const factory RefuelingModel({
    required String id,
    required double liters,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _RefuelingModel;

  factory RefuelingModel.fromJson(Map<String, dynamic> json) =>
      _$RefuelingModelFromJson(json);

  // Conversão para Entity
  Refueling toEntity() => Refueling(
    id: id,
    liters: liters,
    createdAt: DateTime.parse(createdAt),
  );
}

// domain/entities/refueling.dart
class Refueling {
  final String id;
  final double liters;
  final DateTime createdAt;  // Tipo correto!
}
```

**Regra:** Model (Data) ≠ Entity (Domain). Model tem fromJson/toJson e toEntity.

---

### EP-ARC-005: Repository retornando Model ao invés de Either
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Exceções não tratadas
abstract class RefuelingRepository {
  Future<List<Refueling>> getAll();  // Pode lançar exceção!
}

// ✅ CORRETO - Either para sucesso ou falha
abstract class RefuelingRepository {
  Future<Either<Failure, List<Refueling>>> getAll();
}

// Implementação
class RefuelingRepositoryImpl implements RefuelingRepository {
  @override
  Future<Either<Failure, List<Refueling>>> getAll() async {
    try {
      final models = await _dataSource.getAll();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erro de servidor'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

**Regra:** Repository SEMPRE retorna Either<Failure, T>.

---

## 🎨 UI/WIDGETS

### EP-WID-001: Widget tree muito profunda
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Nesting excessivo
Scaffold(
  body: Container(
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(...),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // 10+ níveis de profundidade!
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
)

// ✅ CORRETO - Extrair widgets
Scaffold(
  body: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        _HeaderSection(),
        _ContentSection(),
        _ActionButtons(),
      ],
    ),
  ),
)

class _HeaderSection extends StatelessWidget { ... }
class _ContentSection extends StatelessWidget { ... }
class _ActionButtons extends StatelessWidget { ... }
```

**Regra:** Máximo 5-7 níveis. Extrair widgets quando necessário.

---

### EP-WID-002: Hardcode de strings
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO
Text('Carregando...')
Text('Erro ao carregar dados')
Text('Confirmar abastecimento?')

// ✅ CORRETO - Centralizar strings
// lib/core/constants/app_strings.dart
abstract class AppStrings {
  static const loading = 'Carregando...';
  static const errorLoading = 'Erro ao carregar dados';
  static const confirmRefueling = 'Confirmar abastecimento?';
}

// Uso
Text(AppStrings.loading)
```

**Regra:** Strings em arquivo centralizado. Facilita i18n futuro.

---

### EP-WID-003: Cores hardcoded
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO
Container(color: Color(0xFF4CAF50))
Text('Sucesso', style: TextStyle(color: Colors.green))

// ✅ CORRETO - Usar Theme ou constantes
// lib/core/theme/app_colors.dart
abstract class AppColors {
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFF44336);
  static const primary = Color(0xFF2196F3);
}

// Uso
Container(color: AppColors.success)
// ou
Container(color: Theme.of(context).colorScheme.primary)
```

**Regra:** Cores em arquivo centralizado ou Theme.

---

### EP-WID-004: Falta de const
**Severidade:** 🟢 DESEJÁVEL

```dart
// ❌ ERRADO - Recria widget a cada build
return Padding(
  padding: EdgeInsets.all(16),  // Recria EdgeInsets
  child: Text('Static text'),   // Recria Text
);

// ✅ CORRETO - const quando possível
return const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Static text'),
);
```

**Regra:** Usar const em widgets estáticos. Evita rebuilds.

---

### EP-WID-005: Image.network sem cache/placeholder
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Sem cache nem placeholder
Image.network(url)

// ✅ CORRETO - Com cache e estados
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

**Regra:** Usar CachedNetworkImage com placeholder e errorWidget.

---

### EP-WID-006: ListView sem builder para listas grandes
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Cria todos os itens de uma vez
ListView(
  children: items.map((item) => ItemWidget(item: item)).toList(),
)

// ✅ CORRETO - Cria sob demanda
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)
```

**Regra:** Listas com mais de 10-20 itens = ListView.builder.

---

## 💉 INJEÇÃO DE DEPENDÊNCIA

### EP-INJ-001: Annotation incorreta
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - BLoC como singleton
@lazySingleton  // ERRADO para BLoC!
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {}

// ✅ CORRETO
@injectable  // Nova instância por tela
class RefuelingBloc extends Bloc<RefuelingEvent, RefuelingState> {}

// Para repositories/datasources:
@lazySingleton  // Uma instância compartilhada
class RefuelingRepositoryImpl implements RefuelingRepository {}
```

| Tipo | Annotation |
|------|------------|
| BLoC/Cubit | `@injectable` |
| UseCase | `@injectable` |
| Repository | `@lazySingleton` |
| DataSource | `@lazySingleton` |

---

### EP-INJ-002: Esquecer de rodar build_runner após @injectable
**Severidade:** 🔴 CRÍTICO

```bash
# ❌ ERRADO - Adiciona @injectable e esquece de gerar
# Erro: "No registration for type XxxBloc"

# ✅ CORRETO - Sempre rodar após mudanças
dart run build_runner build --delete-conflicting-outputs
```

**Regra:** Alterou annotation = rodar build_runner imediatamente.

---

### EP-INJ-003: Dependência circular
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - A depende de B, B depende de A
@injectable
class ServiceA {
  final ServiceB _serviceB;
  ServiceA(this._serviceB);
}

@injectable
class ServiceB {
  final ServiceA _serviceA;  // Circular!
  ServiceB(this._serviceA);
}

// ✅ CORRETO - Extrair interface ou refatorar
@injectable
class ServiceA {
  final IServiceB _serviceB;
  ServiceA(this._serviceB);
}
```

**Regra:** Se há dependência circular, refatorar arquitetura.

---

## 🧪 TESTES

### EP-TST-001: Teste sem assertion
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - Teste passa mas não verifica nada
test('should load data', () async {
  await bloc.add(LoadRequested());
  // Nenhuma verificação!
});

// ✅ CORRETO - Verificações explícitas
blocTest<RefuelingBloc, RefuelingState>(
  'should emit [loading, loaded] when load succeeds',
  build: () {
    when(() => mockUseCase()).thenAnswer((_) async => Right(testData));
    return RefuelingBloc(mockUseCase);
  },
  act: (bloc) => bloc.add(const LoadRequested()),
  expect: () => [
    const RefuelingState.loading(),
    RefuelingState.loaded(testData),
  ],
);
```

**Regra:** Todo teste precisa de expect/verify.

---

### EP-TST-002: Mock incompleto
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Só mocka caso de sucesso
setUp(() {
  when(() => mockRepo.getAll()).thenAnswer((_) async => Right([]));
});

// ✅ CORRETO - Mocka sucesso E falha
group('RefuelingBloc', () {
  group('on LoadRequested', () {
    blocTest('emits [loading, loaded] when succeeds',
      build: () {
        when(() => mockUseCase()).thenAnswer((_) async => Right(testData));
        return createBloc();
      },
      // ...
    );

    blocTest('emits [loading, error] when fails',
      build: () {
        when(() => mockUseCase()).thenAnswer((_) async => Left(ServerFailure('Error')));
        return createBloc();
      },
      // ...
    );
  });
});
```

**Regra:** Testar casos de sucesso E falha.

---

### EP-TST-003: Teste de widget sem pump
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Espera resultado síncrono
testWidgets('should show data', (tester) async {
  await tester.pumpWidget(MyWidget());
  expect(find.text('Data'), findsOneWidget);  // Pode falhar!
});

// ✅ CORRETO - pump para animações/async
testWidgets('should show data', (tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.pump();  // Para setState
  // ou
  await tester.pumpAndSettle();  // Para animações
  expect(find.text('Data'), findsOneWidget);
});
```

**Regra:** Usar pump() após ações que causam rebuild.

---

## ⚡ PERFORMANCE

### EP-PRF-001: Lógica pesada no build
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Computação no build
@override
Widget build(BuildContext context) {
  final filtered = items.where((i) => i.name.contains(query)).toList();
  final sorted = filtered..sort((a, b) => a.date.compareTo(b.date));
  final grouped = groupBy(sorted, (i) => i.category);
  // ...
}

// ✅ CORRETO - Computar no BLoC/State
@freezed
class ItemsState with _$ItemsState {
  const factory ItemsState({
    @Default([]) List<Item> items,
    @Default('') String query,
  }) = _ItemsState;

  const ItemsState._();

  // Getter computado
  List<Item> get filteredItems => items
      .where((i) => i.name.contains(query))
      .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
}
```

**Regra:** build() só monta widgets. Lógica no State/BLoC.

---

### EP-PRF-002: Não usar keys em listas
**Severidade:** 🟢 DESEJÁVEL

```dart
// ❌ ERRADO - Sem key
ListView.builder(
  itemBuilder: (_, i) => ItemWidget(item: items[i]),
)

// ✅ CORRETO - Com key para itens reordenáveis
ListView.builder(
  itemBuilder: (_, i) => ItemWidget(
    key: ValueKey(items[i].id),
    item: items[i],
  ),
)
```

**Regra:** Listas reordenáveis/removíveis precisam de Key.

---

### EP-PRF-003: Animação sem dispose
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - AnimationController sem dispose
class _MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
  }
  // Falta dispose!
}

// ✅ CORRETO
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

**Regra:** AnimationController SEMPRE precisa de dispose.

---

### EP-PRF-004: setState em loop
**Severidade:** 🔴 CRÍTICO

```dart
// ❌ ERRADO - Múltiplos rebuilds
void updateItems(List<Item> newItems) {
  for (final item in newItems) {
    setState(() {
      items.add(item);  // Rebuild a cada iteração!
    });
  }
}

// ✅ CORRETO - Um único rebuild
void updateItems(List<Item> newItems) {
  setState(() {
    items.addAll(newItems);
  });
}
```

**Regra:** setState uma vez com todas as mudanças.

---

## 📱 FLUTTER ESPECÍFICO

### EP-FLT-001: print ao invés de log
**Severidade:** 🟢 DESEJÁVEL

```dart
// ❌ ERRADO
print('Debug: $data');

// ✅ CORRETO
import 'dart:developer';
log('Debug: $data', name: 'RefuelingBloc');
```

**Regra:** Usar log() do dart:developer ou logger package.

---

### EP-FLT-002: MediaQuery não usado para responsividade
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Tamanhos fixos
Container(
  width: 300,
  height: 200,
)

// ✅ CORRETO - Responsivo
Container(
  width: MediaQuery.of(context).size.width * 0.8,
  constraints: BoxConstraints(maxWidth: 400),
)
// ou
LayoutBuilder(
  builder: (context, constraints) {
    return Container(
      width: constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.9,
    );
  },
)
```

**Regra:** Usar MediaQuery/LayoutBuilder para responsividade.

---

### EP-FLT-003: Freezed sem rodar build_runner
**Severidade:** 🔴 CRÍTICO

```bash
# ❌ ERRADO
# Alterou @freezed class e não rodou build_runner
# Erro: "The class '_$XxxState' doesn't have a constructor"

# ✅ CORRETO - Sempre após alteração
dart run build_runner build --delete-conflicting-outputs
```

**Regra:** Alterou Freezed = rodar build_runner imediatamente.

---

### EP-FLT-004: Nullable sem null check
**Severidade:** 🟡 IMPORTANTE

```dart
// ❌ ERRADO - Pode dar null error
final String? name = user?.name;
Text(name)  // Error se name for null!

// ✅ CORRETO - Tratar null
Text(name ?? 'Nome não informado')
// ou
if (name != null) Text(name)
```

**Regra:** SEMPRE tratar possíveis nulls.

---

## 📊 Resumo de Severidade

| Severidade | Quantidade | Ação |
|------------|------------|------|
| 🔴 CRÍTICO | 12 | Bloqueia merge |
| 🟡 IMPORTANTE | 15 | Corrigir antes do PR |
| 🟢 DESEJÁVEL | 4 | Melhorar quando possível |

---

*Error Patterns v2.0.0 - Janeiro 2026*
